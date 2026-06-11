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

All four enchantments are registered in `minecraft:in_enchanting_table` and obtainable via `minecraft:book` as a primary item (for Bulwark/Fortify), or directly on pickaxes (for Ensnare).

## Project Structure

```
data/arcane_additions/
  enchantment/        # Enchantment definitions
  tags/item/           # Item tags used by supported_items / primary_items
  function/            # load.mcfunction / tick.mcfunction / Ensnare logic
  advancement/ensnare/ # Drives Ensnare's spawner-placement raycast
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

## Guide Book

Craft a `minecraft:book` with any `minecraft:enchanted_book` to get the
**Arcane Additions** guide — a written book with one page per enchantment
describing what it does, what it applies to, and its max level.
