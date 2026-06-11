execute if score @s arcane_additions.ray matches 12.. run return fail
execute if block ~ ~ ~ minecraft:spawner run return run function arcane_additions:apply_data
scoreboard players add @s arcane_additions.ray 1
execute positioned ^ ^ ^0.5 run function arcane_additions:raycast
