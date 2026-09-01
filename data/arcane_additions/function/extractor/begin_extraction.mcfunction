# Runs "as and at" a freshly detected enchanted item dropped on an extractor.
# Freeze it in place and spawn one enchanted-book choice per enchantment it
# carries (see check_enchants.mcfunction). If none of its enchantments are
# ones we recognize, immediately release it unchanged.

tag @s add arcane_additions.extract_source
data merge entity @s {PickupDelay:32767s,NoGravity:1b,Motion:[0.0d,0.0d,0.0d]}

function arcane_additions:extractor/check_enchants

execute unless data storage arcane_additions:extractor session.queued run function arcane_additions:extractor/finish_extraction
