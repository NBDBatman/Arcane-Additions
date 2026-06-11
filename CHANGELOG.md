# Changelog

All notable changes to the Ensnare portion of this data pack (originally the
standalone "Silk Spawners" pack, merged into Arcane Additions) will be
documented in this file.

## [1.1.0]

### Changed

- Migrated Ensnare fully into the `arcane_additions` namespace. The
  `silk_spawner:*` enchantment, functions, advancement, and scoreboard
  objective are gone — everything now lives under `data/arcane_additions/`
  as `arcane_additions:ensnare`, with its load/tick logic merged into
  `arcane_additions:load` / `arcane_additions:tick`.
- Removed the Spawn Delay/Spawn Count/Player Range lines from the dropped
  spawner item's lore (they showed vanilla's hardcoded defaults rather than
  the spawner's actual settings). The lore now just notes the item has been
  ensnared; the underlying spawner data is still preserved and restored on
  placement.

## [1.0.0]

### Added

- **Ensnare** enchantment (`arcane_additions:ensnare`, max level 1), obtainable
  via enchanting table, anvil, or commands on pickaxes.
- Breaking a monster spawner with a pickaxe enchanted with Ensnare drops it as
  an item, preserving its `SpawnData`, `SpawnPotentials`, `Delay`,
  `MinSpawnDelay`, `MaxSpawnDelay`, `SpawnCount`, `MaxNearbyEntities`,
  `RequiredPlayerRange`, and `SpawnRange`.
- Placing the dropped item restores the original spawner configuration.
- The dropped item is renamed to show the contained mob (e.g. "Zombie
  Spawner") and its lore describes the mob and a summary of its spawn
  settings (spawn delay, spawn count, required player range).
- Breaking a spawner with Silk Touch alone (no Ensnare) behaves exactly like
  vanilla without this pack: no item drop, just 15-43 XP. This also restores
  vanilla pre-26.1.2 behavior, since 26.1.2 added a native (data-less)
  spawner item drop for Silk Touch that this pack removes.
- Breaking an "empty" spawner (no mob configured) with Ensnare also drops only
  XP, since there's nothing to restore.
