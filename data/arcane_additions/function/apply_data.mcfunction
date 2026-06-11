data remove storage arcane_additions:cache last
data modify storage arcane_additions:cache last set from block ~ ~ ~ components."minecraft:custom_data".SpawnerData
data modify block ~ ~ ~ {} merge from storage arcane_additions:cache last
data remove block ~ ~ ~ components
