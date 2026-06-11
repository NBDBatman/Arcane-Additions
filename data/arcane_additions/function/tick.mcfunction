# Arcane Additions
# Tick function (runs every tick).

# Ensnare: a spawner item without SpawnData.entity.id has no mob to restore -
# either it's vanilla's native Silk Touch drop (no custom_data.SpawnerData at
# all) or an Ensnare drop of an "empty" spawner (SpawnerData present but no
# SpawnData, or a SpawnData with no entity id). Remove it and drop the normal
# 15-43 XP instead, matching vanilla's "no item, just XP" behavior for all
# three cases.
execute as @e[type=item,nbt={Age:0s,Item:{id:"minecraft:spawner"}}] at @s unless data entity @s Item.components."minecraft:custom_data".SpawnerData.SpawnData.entity.id run function arcane_additions:remove_silk_touch_drop

# Remove the XP orbs that vanilla always spawns when a spawner is broken,
# even with Silk Touch.
execute as @e[type=item,nbt={Age:0s,Item:{id:"minecraft:spawner"}}] at @s if data entity @s Item.components."minecraft:custom_data".SpawnerData.SpawnData.entity.id run kill @e[type=experience_orb,distance=..1.5,nbt={Age:0s}]

# Label the dropped spawner item with the mob it's set to spawn.
execute as @e[type=item,nbt={Age:0s,Item:{id:"minecraft:spawner"}}] at @s if data entity @s Item.components."minecraft:custom_data".SpawnerData.SpawnData.entity.id run function arcane_additions:label_item with entity @s Item.components."minecraft:custom_data".SpawnerData.SpawnData.entity
