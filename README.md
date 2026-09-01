# Arcane Additions

A Minecraft datapack that adds new enchantments to enhance vanilla gameplay.

- **Pack format:** 94 (`min_format` / `max_format` 94)
- **Namespace:** `arcane_additions`

## Installation

1. Copy this folder (or `Arcane Additions.zip`) into your world's `datapacks/` directory.
2. Run `/reload` or restart the world.
3. Enable the datapack with `/datapack enable "file/Arcane Additions"` if it isn't active automatically.

## Current Enchantments

| ID | Display Name | Slot(s) | Supported Items | Effect | Max Level |
| --- | --- | --- | --- | --- | --- |
| `bulwark_shield` | Bulwark | offhand | `#arcane_additions:bulwark_shield` (shields) | `minecraft:armor` +2 / +4 / +6 | 3 |
| `fortify_chest` | Fortify | chest | `#arcane_additions:fortify_chest` (chest armor) | `minecraft:armor` +2 / +4 / +6 | 3 |
| `swift_harness` | Swift Harness | any | `#arcane_additions:harness` (all harness colors) | `minecraft:flying_speed` +0.01 / +0.02 / +0.03 | 3 |
| `ensnare` | Ensnare | mainhand | `#minecraft:pickaxes` | Picks up monster spawners as items, see below | 1 |
| `explosive_arrows` | Explosive Arrows | mainhand | `#arcane_additions:explosive_bow` (bows & crossbows) | Arrows explode on hit (radius 1.5 / 2.5 / 3.5) | 3 |

All five enchantments are registered in `minecraft:in_enchanting_table` and obtainable via `minecraft:book` as a primary item (for Bulwark/Fortify), or directly on pickaxes (for Ensnare).

## Project Structure

```
data/arcane_additions/
  enchantment/          # Enchantment definitions
  tags/item/             # Item tags used by supported_items / primary_items
  function/              # load.mcfunction / tick.mcfunction / Ensnare / extractor logic
  advancement/ensnare/   # Drives Ensnare's spawner-placement raycast
  advancement/extractor/ # Drives the Enchant Extractor's placement + interaction
  advancement/recipes/   # Recipe-unlock advancements
  recipe/                # Craftable items (currently just the Enchant Extractor)
data/minecraft/tags/
  enchantment/in_enchanting_table.json  # Registers our enchants for table discovery
  function/load.json, tick.json         # Hooks our functions into vanilla load/tick
  item/enchantable/armor.json           # Marks harness as enchantable armor
data/minecraft/loot_table/blocks/spawner.json  # Ensnare's spawner drop override
assets/arcane_additions/lang/
  en_us.json           # Translations (currently empty — needs entries)
```

## Known Issues / TODO

- `assets/arcane_additions/lang/en_us.json` is empty — enchantment names will not display correctly in-game until translation keys are added.
- `Arcane Additions.zip` in the project root may be a stale build artifact — verify before distributing.

See [SUGGESTIONS.md](SUGGESTIONS.md) for a backlog of future enchantment ideas and improvements, and [arcane_additions_enchants.md](arcane_additions_enchants.md) for the original brainstorm list.

## Ensnare (spawner pickup)

This pack also includes **Ensnare** (`arcane_additions:ensnare`, max level 1,
pickaxes only), merged in from the standalone "Silk Spawners" data pack.
Breaking a monster spawner with a pickaxe enchanted with Ensnare picks the
spawner up as an item — preserving its mob type and settings (`SpawnData`,
`SpawnPotentials`, `Delay`, `MinSpawnDelay`, `MaxSpawnDelay`, `SpawnCount`,
`MaxNearbyEntities`, `RequiredPlayerRange`, `SpawnRange`) — and restores them
when the item is placed again. The dropped item is renamed to show the
contained mob (e.g. "Zombie Spawner") with lore noting it's been ensnared.
Silk Touch alone, or Ensnare on an "empty" spawner with no mob
configured, behaves exactly like vanilla: no item drop, just 15-43 XP.

See the "Ensnare" section of [SUGGESTIONS.md](SUGGESTIONS.md) for its backlog
and [CHANGELOG.md](CHANGELOG.md) for its version history.

## Enchant Extractor (disenchanting)

Craft an **Enchant Extractor** (a lectern surrounded by books and amethyst
shards — `data/arcane_additions/recipe/enchant_extractor.json`) and place it
in the world. A floating "Enchant Extractor" marker appears above it.

Drop an enchanted tool, weapon, or piece of armor onto the extractor: it
freezes in place and one enchanted book pops up for every enchantment on the
item (any vanilla enchantment, or any of this pack's own). Pick up the book
for the enchant you want — it's a fully realized `enchanted_book` with that
exact enchant and level — and the original item is released back for pickup,
missing only that one enchant and keeping the rest. Right-click the marker
at any point to cancel and get the original item back untouched.

This only reads `minecraft:enchantments` (enchants applied to a tool/weapon/
armor piece), not `minecraft:stored_enchantments` on enchanted books.

- `data/arcane_additions/recipe/enchant_extractor.json` /
  `data/arcane_additions/advancement/recipes/enchant_extractor.json` — the
  crafting recipe and its recipe-book unlock.
- `data/arcane_additions/advancement/extractor/placed.json` +
  `function/extractor/on_place.mcfunction` — raycasts from the placing
  player to find the just-placed lectern (reward functions aren't given the
  block's own position) and summons the marker.
- `function/extractor/summon_marker.mcfunction` — spawns the `interaction`
  entity marker, which both blocks the vanilla lectern GUI and acts as the
  click target for cancelling an extraction.
- `advancement/extractor/interacted.json` +
  `function/extractor/on_interact.mcfunction` — detects right-clicks on the
  marker (same raycast technique as placement) and cancels any in-progress
  extraction on that extractor.
- `function/extractor/tick.mcfunction` — runs every tick for each marker:
  cleans itself up if its lectern was broken, watches for a choice being
  taken during an active extraction, or watches for a newly dropped
  enchanted item otherwise.
- `function/extractor/begin_extraction.mcfunction` /
  `check_enchants.mcfunction` — freezes a newly dropped item and, for every
  known enchantment ID it has, spawns a matching enchanted-book choice and
  records it as queued. `check_enchants.mcfunction` is a generated checklist
  (one block per enchantment ID — all 43 vanilla enchantments plus this
  pack's own five) since vanilla commands can't enumerate an NBT compound's
  keys directly.
- `function/extractor/watch_choices.mcfunction` — the inverse generated
  checklist, run every tick during an active extraction: when a queued
  choice's book has disappeared (been picked up), removes that one enchant
  from the source item and marks the session done.
- `function/extractor/finish_extraction.mcfunction` /
  `despawn_marker.mcfunction` — shared cleanup: clears any remaining choice
  books and releases the source item, whether extraction resolved, was
  cancelled, or the lectern was broken outright.

Adding a new enchantment to the extractor's checklist: add its ID to
`scripts/generate_extractor_checklist.sh` and re-run it to regenerate
`check_enchants.mcfunction` / `watch_choices.mcfunction`.
