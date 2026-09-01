# Runs "as and at" the placing player the instant the advancement triggers.
# Reward functions don't get the block's own position, so we look outward
# from the player's eyes along their facing direction to find the lectern
# they just placed. 6 blocks covers reach distance comfortably. "align xyz"
# snaps the (otherwise fractional) ray-hit point down to the block's own
# integer origin, since summon_marker.mcfunction's offsets are relative to
# that origin; "return run" stops after the first hit so a lectern spanning
# multiple ^N steps doesn't summon more than one marker. Because "return run"
# exits this function immediately on a hit, summon_marker.mcfunction does its
# own revoke (still "as" the player - only position changed) for that case;
# the unconditional revoke below only ends up handling the no-hit fallback.

execute at @s anchored eyes positioned ^ ^ ^1 if block ~ ~ ~ minecraft:lectern align xyz run return run function arcane_additions:extractor/summon_marker
execute at @s anchored eyes positioned ^ ^ ^2 if block ~ ~ ~ minecraft:lectern align xyz run return run function arcane_additions:extractor/summon_marker
execute at @s anchored eyes positioned ^ ^ ^3 if block ~ ~ ~ minecraft:lectern align xyz run return run function arcane_additions:extractor/summon_marker
execute at @s anchored eyes positioned ^ ^ ^4 if block ~ ~ ~ minecraft:lectern align xyz run return run function arcane_additions:extractor/summon_marker
execute at @s anchored eyes positioned ^ ^ ^5 if block ~ ~ ~ minecraft:lectern align xyz run return run function arcane_additions:extractor/summon_marker
execute at @s anchored eyes positioned ^ ^ ^6 if block ~ ~ ~ minecraft:lectern align xyz run return run function arcane_additions:extractor/summon_marker

# Fallback: only reached if no lectern was found in any of the 6 steps above
# (summon_marker.mcfunction handles the revoke on the success path itself,
# since "return run" skips this line when a hit occurs).
advancement revoke @s only arcane_additions:extractor/placed
