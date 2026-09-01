#!/usr/bin/env bash
# Regenerates the Enchant Extractor's per-enchantment checklist functions:
#   data/arcane_additions/function/extractor/check_enchants.mcfunction
#   data/arcane_additions/function/extractor/watch_choices.mcfunction
#
# Vanilla commands can't enumerate an NBT compound's keys, so "does this item
# have enchant X" has to be checked one known ID at a time. Add new IDs to
# VANILLA/CUSTOM below (CUSTOM should match this pack's own enchantment IDs,
# i.e. the filenames under data/arcane_additions/enchantment/) and re-run
# this script from the repo root to regenerate both files.
set -euo pipefail
cd "$(dirname "$0")/.."

VANILLA="aqua_affinity bane_of_arthropods binding_curse blast_protection breach channeling density depth_strider efficiency feather_falling fire_aspect fire_protection flame fortune frost_walker impaling infinity knockback looting loyalty luck_of_the_sea lunge lure mending multishot piercing power projectile_protection protection punch quick_charge respiration riptide sharpness silk_touch smite soul_speed sweeping_edge swift_sneak thorns unbreaking vanishing_curse wind_burst"
CUSTOM="bulwark_shield ensnare explosive_arrows fortify_chest swift_harness"

CHECK_FILE="data/arcane_additions/function/extractor/check_enchants.mcfunction"
WATCH_FILE="data/arcane_additions/function/extractor/watch_choices.mcfunction"

{
  echo '# Generated block: one entry per known enchantment ID (43 vanilla + this'
  echo "# pack's own). Runs \"as and at\" the source item (see begin_extraction.mcfunction)."
  echo '# For each enchantment the item actually has, spawns a floating enchanted-book'
  echo '# choice carrying that exact enchant + level, and records it as queued so'
  echo '# watch_choices.mcfunction knows to wait for it.'
} > "$CHECK_FILE"

{
  echo '# Generated block: mirrors check_enchants.mcfunction. Runs every tick "as and'
  echo '# at" the source item while an extraction is in progress. For each queued'
  echo '# enchant whose choice book has disappeared (picked up), removes that one'
  echo '# enchant from the source item and marks the session done.'
} > "$WATCH_FILE"

emit_pair() {
  ns="$1"
  id="$2"
  path="${ns}.${id}"
  key="${ns}:${id}"
  tag="arcane_additions.enchant.${path}"

  {
    echo ""
    # NBT depth check: outer{ Item{ ... components{ stored_enchantments{ levels{} } } } , Tags... outer-close }
    # After the empty levels{} pair: 3 closes (stored_enchantments, components, Item) before
    # ",Tags", then 1 final close (the outer compound) at the very end after Motion's "]".
    echo "execute if data entity @s Item.components.\"minecraft:enchantments\".levels.\"${key}\" run summon minecraft:item ~ ~0.4 ~ {Item:{id:\"minecraft:enchanted_book\",count:1,components:{\"minecraft:stored_enchantments\":{levels:{}}}},Tags:[\"arcane_additions.extract_choice\",\"${tag}\"],PickupDelay:20s,NoGravity:0b,Motion:[0.0d,0.3d,0.0d]}"
    echo "execute if data entity @s Item.components.\"minecraft:enchantments\".levels.\"${key}\" run data modify entity @e[tag=arcane_additions.extract_choice,tag=${tag},limit=1,sort=nearest,distance=..2] Item.components.\"minecraft:stored_enchantments\".levels.\"${key}\" set from entity @s Item.components.\"minecraft:enchantments\".levels.\"${key}\""
    echo "execute if data entity @s Item.components.\"minecraft:enchantments\".levels.\"${key}\" run data modify storage arcane_additions:extractor session.queued.${path} set value 1b"
  } >> "$CHECK_FILE"

  {
    echo ""
    echo "execute if data storage arcane_additions:extractor session.queued.${path} unless entity @e[tag=arcane_additions.extract_choice,tag=${tag},distance=..4] run data remove entity @s Item.components.\"minecraft:enchantments\".levels.\"${key}\""
    echo "execute if data storage arcane_additions:extractor session.queued.${path} unless entity @e[tag=arcane_additions.extract_choice,tag=${tag},distance=..4] run data modify storage arcane_additions:extractor session.done set value 1b"
    echo "execute if data storage arcane_additions:extractor session.queued.${path} unless entity @e[tag=arcane_additions.extract_choice,tag=${tag},distance=..4] run data remove storage arcane_additions:extractor session.queued.${path}"
  } >> "$WATCH_FILE"
}

for id in $VANILLA; do emit_pair "minecraft" "$id"; done
for id in $CUSTOM; do emit_pair "arcane_additions" "$id"; done

{
  echo ""
  echo "# One or more enchants were resolved this tick - clean up and release the item."
  echo "execute if data storage arcane_additions:extractor session.done run function arcane_additions:extractor/finish_extraction"
} >> "$WATCH_FILE"

echo "Regenerated $CHECK_FILE and $WATCH_FILE"
