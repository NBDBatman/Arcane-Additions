# Runs "as and at" the source item, whether the extraction resolved (a
# choice was taken - it's already missing that enchant), was cancelled (via
# the marker), or had nothing extractable to begin with. Clears any leftover
# choice books and releases the item back to normal pickup.

kill @e[tag=arcane_additions.extract_choice,distance=..4]
data merge entity @s {PickupDelay:0s}
tag @s remove arcane_additions.extract_source
data remove storage arcane_additions:extractor session
