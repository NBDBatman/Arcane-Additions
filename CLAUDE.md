# Arcane Additions — Project Notes

A vanilla-friendly Minecraft datapack (pack format 94) that adds custom enchantments
under the `arcane_additions` namespace.

## Conventions

- **Enchantment files** live in `data/arcane_additions/enchantment/<id>.json`. Each one:
  - Uses `description.text` for the in-game name fallback.
  - Targets items via `supported_items` / `primary_items`, usually pointing at a tag
    in `data/arcane_additions/tags/item/`.
  - Uses `minecraft:attributes` effects with a stable, hand-picked `uuid` per attribute
    modifier (do not regenerate UUIDs once an enchant has shipped — it breaks existing
    item NBT).
  - Uses `minecraft:lookup` amount tables keyed by level (`values` array, index 0 = level 1)
    with a `fallback` for levels beyond the table.
- **Item tags** in `data/arcane_additions/tags/item/` group items an enchantment applies to
  (e.g. `harness.json` lists all 16 harness color variants).
- **Vanilla tag hooks** in `data/minecraft/tags/...`:
  - `enchantment/in_enchanting_table.json` — must list every new enchantment ID or it
    won't be obtainable via the enchanting table.
  - `function/load.json` and `function/tick.json` — wire up `arcane_additions:load` /
    `arcane_additions:tick`.
  - `item/enchantable/armor.json` — used to mark non-vanilla-armor items (like harnesses)
    as eligible for armor-slot enchantments.
- **Translations** go in `assets/arcane_additions/lang/en_us.json` using keys like
  `enchantment.arcane_additions.<id>`. This file is currently empty and needs to be
  populated for every enchantment.
- **Guide book** (`data/arcane_additions/recipe/guide_book.json`) is a crafting
  recipe (`minecraft:book` + `minecraft:enchanted_book`, shapeless) that outputs a
  `minecraft:written_book` with a hardcoded `minecraft:written_book_content`
  component — one page per enchantment. Its recipe-unlock advancement lives at
  `data/arcane_additions/advancement/recipes/guide_book.json`. When adding a new
  enchantment, add a page here too.

## Workflow Notes

- After adding/editing an enchantment, double check:
  1. The enchantment JSON itself.
  2. Any item tag it depends on.
  3. `in_enchanting_table.json` registration.
  4. A translation entry in `en_us.json`.
  5. A page in the guide book (`data/arcane_additions/recipe/guide_book.json`).
- `arcane_additions_enchants.md` is a brainstorm/idea list — not all entries are implemented.
  `SUGGESTIONS.md` tracks a curated, actionable backlog.
- Keep `min_format`/`max_format` in `pack.mcmeta` in sync with the targeted Minecraft version.
- `Arcane Additions.zip` is a packaged build artifact — regenerate it rather than hand-editing,
  and don't treat it as a source of truth.

## Ensnare

In addition to the attribute-based enchantments above, this pack includes the
**Ensnare** enchantment (`arcane_additions:ensnare`), merged in (and fully
folded into the `arcane_additions` namespace) from the standalone "Silk
Spawners" data pack. It lives under `data/arcane_additions/enchantment/`,
`data/arcane_additions/function/`, `data/arcane_additions/advancement/ensnare/`,
and `data/minecraft/loot_table/blocks/spawner.json`, and is registered
alongside the other enchantments in
`data/minecraft/tags/enchantment/in_enchanting_table.json`. Its load/tick
logic is merged into `arcane_additions:load`/`arcane_additions:tick`.

Ensnare makes monster spawners drop as an item when broken with a pickaxe
enchanted with it, preserving the spawner's mob type and settings (`SpawnData`,
`SpawnPotentials`, `Delay`, `MinSpawnDelay`, `MaxSpawnDelay`, `SpawnCount`,
`MaxNearbyEntities`, `RequiredPlayerRange`, `SpawnRange`), and restores that
data when the dropped item is placed. Silk Touch alone still breaks spawners
normally (no special drop, normal XP), and an Ensnare-broken "empty" spawner
(no `SpawnData`) also drops only XP. The dropped item is labeled with the mob
it contains and lore noting it's been ensnared.

- `data/arcane_additions/enchantment/ensnare.json` — defines the enchantment
  (max level 1, `supported_items`/`primary_items` both `#minecraft:pickaxes`).
  Uses a literal text `description` rather than a translation key, since data
  packs can't ship `lang` files.
- `data/minecraft/loot_table/blocks/spawner.json` — overrides the vanilla
  spawner loot table to add the drop when broken with Ensnare (level 1+),
  using `copy_custom_data` to copy the spawner config fields into
  `minecraft:custom_data.SpawnerData` on the dropped item.
- `data/arcane_additions/function/` — Ensnare-specific pack logic:
  - `load.mcfunction` — registers the `arcane_additions.ray` scoreboard
    objective used for raycasting.
  - `tick.mcfunction` — runs every tick. Freshly-dropped `minecraft:spawner`
    items lacking `custom_data.SpawnerData.SpawnData.entity.id` (vanilla's
    native Silk Touch drop, or an Ensnare drop of an empty spawner with no
    `SpawnData` or a `SpawnData` with no entity id) are removed and replaced
    with 15-43 XP via `remove_silk_touch_drop`/`spawn_xp`. Items that do have
    a contained mob get their bonus XP orbs killed and are renamed/relabeled
    via `label_item`/`label_item_2`.
  - `place_spawner.mcfunction`/`raycast.mcfunction`/`apply_data.mcfunction` —
    when the dropped item is placed, an advancement
    (`data/arcane_additions/advancement/ensnare/place_spawner.json`) raycasts
    to find the new spawner block and merges the item's stashed
    `custom_data.SpawnerData` back onto the block entity's real fields.
- As of 1.21.5+, item predicates (`minecraft:match_tool`, etc.) require
  enchantment checks under `"predicates": {"minecraft:enchantments": [...]}`
  rather than the old top-level `"enchantments"` field — relevant if adding
  more enchantment-gated loot table entries.
- The "Ensnare" section of `SUGGESTIONS.md` tracks the backlog for this part
  of the pack, and `CHANGELOG.md` tracks its version history.
