advancement revoke @s only arcane_additions:ensnare/place_spawner
scoreboard players set @s arcane_additions.ray 0
execute as @s at @s anchored eyes positioned ^ ^ ^-0.1 run function arcane_additions:raycast
