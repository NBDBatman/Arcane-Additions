# Runs "as and at" the interacting player. Right-clicking the marker cancels
# any in-progress extraction on the extractor being looked at (the frozen
# item is released and any floating enchant-book choices are discarded,
# unmodified) - same reach-distance raycast on_place.mcfunction uses to find
# the lectern the marker belongs to, since reward functions aren't given the
# clicked entity's position.

execute at @s anchored eyes positioned ^ ^ ^1 if block ~ ~ ~ minecraft:lectern as @e[tag=arcane_additions.extract_source,distance=..3.5] at @s run function arcane_additions:extractor/finish_extraction
execute at @s anchored eyes positioned ^ ^ ^2 if block ~ ~ ~ minecraft:lectern as @e[tag=arcane_additions.extract_source,distance=..3.5] at @s run function arcane_additions:extractor/finish_extraction
execute at @s anchored eyes positioned ^ ^ ^3 if block ~ ~ ~ minecraft:lectern as @e[tag=arcane_additions.extract_source,distance=..3.5] at @s run function arcane_additions:extractor/finish_extraction
execute at @s anchored eyes positioned ^ ^ ^4 if block ~ ~ ~ minecraft:lectern as @e[tag=arcane_additions.extract_source,distance=..3.5] at @s run function arcane_additions:extractor/finish_extraction
execute at @s anchored eyes positioned ^ ^ ^5 if block ~ ~ ~ minecraft:lectern as @e[tag=arcane_additions.extract_source,distance=..3.5] at @s run function arcane_additions:extractor/finish_extraction
execute at @s anchored eyes positioned ^ ^ ^6 if block ~ ~ ~ minecraft:lectern as @e[tag=arcane_additions.extract_source,distance=..3.5] at @s run function arcane_additions:extractor/finish_extraction

advancement revoke @s only arcane_additions:extractor/interacted
