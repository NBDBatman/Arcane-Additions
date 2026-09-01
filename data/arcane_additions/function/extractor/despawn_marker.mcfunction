# Runs "as and at" a marker whose lectern is gone (broken). Release (not
# kill - the player shouldn't lose their item just because the extractor
# was broken mid-use) any item it was mid-extraction on, then remove the
# marker itself.

execute as @e[tag=arcane_additions.extract_source,distance=..3.5] at @s run function arcane_additions:extractor/finish_extraction
kill @s
