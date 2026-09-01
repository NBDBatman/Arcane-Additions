# Executed "as" the placing player, "at" the lectern's own integer origin
# (see on_place.mcfunction). The interaction entity sits just above/in front
# of the lectern's top face: it catches the right-click before it reaches
# the block, and its CustomName is what renders the floating name over the
# lectern.

summon minecraft:interaction ~0.5 ~1.05 ~0.5 {Tags:["arcane_extractor"],width:1.0f,height:0.6f,CustomName:'{"text":"Enchant Extractor","color":"light_purple","italic":false}',CustomNameVisible:1b}

# Reset so the same player can craft + place another extractor later. Still
# "as" the player here - only the position changed, not the executor.
advancement revoke @s only arcane_additions:extractor/placed
