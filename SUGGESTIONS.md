# Suggestions / Backlog

A curated list of ideas and improvements for Arcane Additions, ranging from quick fixes
to larger feature work. Pulled partly from `arcane_additions_enchants.md` and expanded
with technical/QoL suggestions.

---

## Quick Fixes / Technical Debt

- [ ] Populate `assets/arcane_additions/lang/en_us.json` with translation keys for all
      existing enchantments (`enchantment.arcane_additions.bulwark_shield`,
      `enchantment.arcane_additions.fortify_chest`, `enchantment.arcane_additions.swift_harness`).
- [ ] Decide what `load.mcfunction` should actually do (e.g. announce datapack version,
      scoreboard init) or remove the load function tag if unused.
- [ ] Either implement tick-based logic or remove `tick.mcfunction` / its function tag
      to avoid an empty per-tick call.
- [ ] Verify `Arcane Additions.zip` is up to date or add it to `.gitignore` / remove it
      from version control as a build artifact.
- [ ] Add a `data/arcane_additions/tags/item/` entry consolidating "all custom enchant
      books" if you plan to add loot table integration later.
- [ ] Add a `pack.png` icon for the datapack.
- [ ] Consider adding a `CHANGELOG.md` to track version-to-version enchant changes.
- [ ] Add example commands (give commands with `enchanted_book` + `stored_enchantments`)
      to the README for quick testing.

---

## Near-Term Enchantment Additions (low complexity, attribute/potion based)

These can reuse the existing `minecraft:attributes` / status-effect pattern with no
custom function logic.

- [ ] **Wayfarer** (boots) — `minecraft:movement_speed` bonus.
- [ ] **Ironhide** (chestplate) — `minecraft:armor_toughness` bonus.
- [ ] **Brace** (armor, all slots) — `minecraft:knockback_resistance` bonus.
- [ ] **Might** (weapon) — `minecraft:attack_damage` bonus.
- [ ] **Tempo** (weapon) — `minecraft:attack_speed` bonus.
- [ ] **Cleaver** (tools) — `minecraft:block_break_speed` bonus.
- [ ] **Highstep** (boots) — `minecraft:step_height` bonus (small, e.g. +0.5/+1).
- [ ] **Riverstride** (boots) — `minecraft:water_movement_efficiency` bonus.
- [ ] **Gills** (helmet) — `minecraft:oxygen_bonus`.
- [ ] **Springlift** (harness) — `minecraft:jump_strength` bonus, mirrors Swift Harness pattern.
- [ ] **Glideweave** (harness) — `minecraft:flying_speed` bonus, alternate scaling/tier from Swift Harness.
- [ ] **Wakecut** (harness) — `minecraft:water_movement_efficiency` bonus.
- [ ] **Nightglow** (helmet) — grants `minecraft:night_vision` while worn (via `minecraft:apply_mob_effect` enchant effect).
- [ ] **Lungs** (helmet) — grants `minecraft:water_breathing` while worn.
- [ ] **Softfall** (boots) — grants `minecraft:slow_falling` on fall (via damage/fall trigger effect).
- [ ] **Emberguard** (chestplate) — grants `minecraft:fire_resistance` while worn or reduces fire damage taken.

---

## Mid-Term Enchantments (event-triggered effects)

Use `minecraft:effects/...` enchant effect components (e.g. `damage_immunity`,
`post_attack`, `attributes` with conditional context) — still no custom functions needed
in modern versions, but more involved tuning.

- [ ] **Bloodrite** (weapon) — `minecraft:regeneration` on kill (post_attack effect).
- [ ] **Surge** (armor) — temporary `minecraft:speed` after taking damage (damage taken trigger).
- [ ] **Rage** (weapon) — temporary `minecraft:strength` after landing a critical hit.
- [ ] **Bulwark Pulse** (shield) — `minecraft:resistance` while actively blocking.
- [ ] **Toxin Edge** (weapon) — chance to apply `minecraft:poison` on hit.
- [ ] **Hinder** (weapon) — chance to apply `minecraft:slowness` on hit.
- [ ] **Harvest Spark** (tools) — temporary `minecraft:haste` after breaking crops.
- [ ] **Deepcore** (tools) — `minecraft:haste` while below a Y-level threshold.
- [ ] **Dawnblessed** / **Duskbound** (armor) — time-of-day conditional `regeneration`/`speed`.
- [ ] **Stormheart** (armor) — `minecraft:strength` during thunderstorms.
- [ ] **Mercyless** (weapon) — bonus `attack_damage` vs targets below an HP threshold.
- [ ] **Duelist** (weapon) — bonus `attack_damage` when only one hostile mob is nearby.

---

## Long-Term / Custom Logic Enchantments (require functions + data tracking)

These need scoreboards, NBT/component checks, predicates, and likely advancements or
`tick.mcfunction` logic. Good candidates for a "v2" milestone once the framework above
is stable.

- [ ] **Soulbound** — keep specific items on death (custom death-event handling).
- [ ] **Magnet** — pull nearby item entities toward the player.
- [ ] **Veinbound** — break connected ore blocks of the same type in one swing.
- [ ] **Timberfall** — break an entire tree when the base log is broken.
- [ ] **Planter** — auto-replant crops on harvest.
- [ ] **Recall** — store a position and teleport back to it (with cooldown).
- [ ] **Blink Mark** — short-range teleport on use.
- [ ] **Combo** — stacking damage bonus for consecutive hits within a time window.
- [ ] **Parry** — brief damage negation window after a specific input/action.
- [ ] **Phantom Ward** — grant brief `minecraft:invisibility` specifically vs phantoms (requires entity-type-aware trigger).
- [ ] **Resonance** — multiply XP gained from kills/mining.
- [ ] **Prosperity** — chance for bonus loot rolls on mob kills/block breaks.

---

## System / Framework Ideas

- [ ] Introduce a shared "enchant tier" naming convention (e.g. Common/Rare/Treasure)
      and reflect it in `weight`, `max_level`, and rarity-based loot tables.
- [ ] Add a loot table or trade integration so higher-tier enchant books are obtainable
      in survival (currently only enchanting table + anvil via `primary_items`).
- [ ] Build a small advancement tree that rewards players for discovering/using each
      new enchantment (good onboarding + discoverability).
- [ ] Add a datapack version scoreboard, set in `load.mcfunction`, so future updates can
      detect and migrate old worlds.
- [ ] Consider a config item/book that lets server owners toggle enchant categories
      on/off (e.g. disable custom-logic enchants on low-power servers).
- [ ] Group enchantments into themed "expansion" sub-packs (Nether set, Ocean set, End
      set, Mount mastery) as outlined in `arcane_additions_enchants.md`'s "Future
      Expansion Themes" section — could be separate datapacks that depend on this one.

---

## Ensnare

- **Advancement for first spawner pickup**: A simple advancement
  (`data/arcane_additions/advancement/ensnare/get_spawner.json`) triggered by
  picking up a `minecraft:spawner` item, as a fun milestone.
- **Gate Ensnare behind progression**: It's now obtainable via the enchanting
  table/anvil/commands like a normal enchantment. If you want a more
  deliberate gate, consider also/instead adding it via a librarian/wandering
  trader trade or a rare structure loot table entry.
- **Other silk-touchable blocks**: If the goal is broader "silk touch
  preserves block entity" behavior, consider similar overrides for other
  block-entity blocks players might want to move (e.g. command blocks,
  beehives with bees — though beehives already support this in vanilla).
- **Multi-version support**: If you want this pack to work across multiple
  Minecraft versions, consider maintaining separate branches/folders per
  `pack_format`, or use the `pack.mcmeta` `min_format`/`max_format` /
  `supported_formats` field to widen compatibility.
- **Break feedback for Ensnare**: Play a sound (e.g.
  `playsound minecraft:block.beacon.activate`) or spawn particles when a
  spawner is successfully ensnared, to make the moment feel more distinct
  from a normal break.
