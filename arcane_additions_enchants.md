# Arcane Additions — Enchantment Idea List

Fresh, cohesive vanilla-friendly concepts with clear themes and tighter names.
Each entry notes the ATTRIBUTE or POTION effect it would use (or custom logic).

---

## Attribute-Based Enchantments (use minecraft:attributes)

### Movement
- Wayfarer — boots — `minecraft:movement_speed`
- Fleetstep — boots — `minecraft:movement_speed` while sprinting (conditional later)
- Trailbound — boots — small constant `minecraft:movement_speed`
- Riverstride — boots — `minecraft:water_movement_efficiency`
- Gills — helmet — `minecraft:oxygen_bonus`
- Highstep — boots — `minecraft:step_height`

### Combat Survivability
- Ironhide — chestplate — `minecraft:armor_toughness`
- Brace — armor — `minecraft:knockback_resistance`
- Unyielding — armor — `minecraft:armor` at low health (future conditional)
- Steadfast — armor — small `minecraft:knockback_resistance`

### Attack & Tools
- Might — weapon — `minecraft:attack_damage`
- Tempo — weapon — `minecraft:attack_speed`
- Cleaver — tools — `minecraft:block_break_speed`
- Drawn Aim — ranged — `minecraft:attack_speed`
- Grip — tools — `minecraft:block_break_speed` while crouching

### Mount / Harness Attributes
- Glideweave — harness — `minecraft:flying_speed`
- Springlift — harness — `minecraft:jump_strength`
- Enduring — harness — `minecraft:movement_speed`
- Wakecut — harness — `minecraft:water_movement_efficiency`

---

## Potion-Based Enchantments (apply status effects)

### Passive Effects
- Nightglow — helmet — `night_vision`
- Emberguard — chestplate — `fire_resistance`
- Snowbound — boots — `resistance` in snow areas
- Lungs — helmet — `water_breathing`
- Softfall — boots — `slow_falling`

### Combat Triggers
- Bloodrite — weapon — `regeneration` on kill
- Surge — armor — `speed` after taking damage
- Rage — weapon — `strength` after critical hit
- Bulwark Pulse — shield — `resistance` while blocking
- Toxin Edge — weapon — `poison` chance on hit
- Hinder — weapon — `slowness` chance on hit

### Utility Triggers
- Harvest Spark — tools — `haste` after breaking crops
- Deepcore — tools — `haste` underground
- Dawnblessed — armor — `regeneration` daytime
- Duskbound — armor — `speed` nighttime
- Stormheart — armor — `strength` during thunderstorms

---

## Weapon Enchantments (mixed mechanics)
- Momentum — weapon — uses `minecraft:attack_damage` scaling with sprint
- Mercyless — weapon — extra `minecraft:attack_damage` vs low HP
- Cleave — weapon — small sweep bonus (future custom)
- Pinning — bow — `slowness` potion
- Ricochet — bow — custom logic
- Tether — bow — custom pull mechanic
- Sundering — weapon — extra damage vs armored mobs (future conditional)
- Disarm — weapon — custom drop mechanic
- Duelist — weapon — `minecraft:attack_damage` if one enemy nearby

---

## Tool Enchantments

### Mining
- Veinbound — custom logic
- Prospector — custom particles
- Pulverize — custom drops
- Stabilize — custom falling block prevention
- Magnet — custom item attraction
- Precision — custom targeting

### Farming & Building
- Planter — custom replant
- Timberfall — custom tree detection
- Leveler — custom area flatten
- Mason — custom block placement line
- Hydrate — water placement logic

---

## Armor Enchantments
- Frostguard — `resistance` vs freezing damage
- Tempered — `fire_resistance`
- Cushion — fall reduction via `slow_falling`
- Anchor — `knockback_resistance`
- Veil — custom mob detection
- Aquashell — `dolphins_grace`
- Pathfinder — `speed` on paths

---

## Mount & Companion Enchantments
- Tailwind — `minecraft:flying_speed` acceleration
- Glide — `slow_falling`
- Bonded — custom follow logic
- Recall — teleport logic
- Navigator — obstacle avoidance logic
- Carrier — storage logic
- Guardian Spirit — `resistance` chance

---

## Treasure / Rare Enchantments
- Soulbound — custom keep inventory logic
- Resonance — XP multiplier
- Timeless — durability prevention logic
- Phantom Ward — `invisibility` vs phantoms
- Gravitate — item attraction logic
- Prosperity — bonus loot logic

---

## Experimental / Custom-Logic Ideas (requires functions)

### Environmental Interaction
- Earthmold — biome block replacement
- Frostwake — freeze nearby water
- Campfire Cook — inventory cooking
- Windstep — `jump_boost` after falling
- Oreflare — temporary `glowing` on ores

### Combat Systems
- Combo — stacking damage logic
- Parry — timed damage negation
- Overcharge — charge attack multiplier
- Rebound — reflect projectile

### Utility Mechanics
- Blink Mark — stored position recall
- Beaconlink — shared beacon effects
- Chrono — revive rewind mechanic
- Phase — pass through mobs briefly
- Magnet Boots — ceiling walking logic

---

## Future Expansion Themes
- Nether-focused enchant set
- Ocean exploration set
- End dimension mobility set
- Mount mastery progression
- Boss drop exclusive enchants
