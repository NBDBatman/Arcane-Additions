# Runs "as and at" each Enchant Extractor marker every tick (hooked from the
# main tick.mcfunction). The lectern sits at ~-0.5 ~-1.05 ~-0.5 relative to
# the marker (see summon_marker.mcfunction for the inverse offset).

execute unless block ~-0.5 ~-1.05 ~-0.5 minecraft:lectern run function arcane_additions:extractor/despawn_marker

# An extraction is already in progress: watch for the player picking one of
# the floating enchant-book choices.
execute if block ~-0.5 ~-1.05 ~-0.5 minecraft:lectern as @e[tag=arcane_additions.extract_source,distance=..3.5] at @s run function arcane_additions:extractor/watch_choices

# No extraction in progress: look for a freshly dropped enchanted item placed
# on the extractor. The marker floats ~1 block above the lectern, but a
# dropped item falls to the ground near the player's feet, so the radius
# here is generous rather than tight.
execute if block ~-0.5 ~-1.05 ~-0.5 minecraft:lectern unless entity @e[tag=arcane_additions.extract_source,distance=..3.5] as @e[type=item,distance=..3] at @s if data entity @s Item.components."minecraft:enchantments" run function arcane_additions:extractor/begin_extraction
