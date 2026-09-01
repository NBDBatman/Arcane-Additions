# Custom Enchantments — Feasibility Notes (Minecraft Java 26.1.x, Vanilla Datapack)

**Target:** Minecraft Java 26.1.2, **vanilla datapack only** (no mods/plugins).
**Purpose:** Design/feasibility reference for implementing a set of custom enchantments. Each entry below records the verdict, the working approach, and the known gotchas, as worked out in discussion.

---

## Recurring architecture (applies to all of these)

- The **data-driven enchantment** is, in most cases, just a **marker + registration layer** (glint, lore, anvil cost, `supported_items`, level cap). The actual behaviour usually lives in **functions**, unless a native effect component covers it.
- **Enchantment effect components scale by enchantment *level*, not by a custom per-item counter.** Anything that needs to read a custom value (charges, etc.) and scale off it must be driven by a function.
- Confirmed enchantment **entity effects** available in 26.1 include: `apply_impulse`, `apply_exhaustion`, `apply_mob_effect`, `damage_entity`, `change_item_damage`, `explode`, `ignite`, `play_sound`, `replace_block`, `replace_disk`, `run_function`, `set_block_properties`, `spawn_particles`, `summon_entity`.
- **Player inventory is not directly `/data`-writable.** In-hand item edits go through the `item` command; freely editable items are **dropped item entities**.
- **Vanilla has no "block broken" event/trigger** and **no data-driven anvil recipe**, and you **cannot read anvil input slots**. These shape several designs below.

---

## 1. Soulbound (keep item through death)

**Verdict:** Possible, but NOT via the enchantment itself — enchantment is cosmetic only; mechanic is all functions.

**Why:** No native "on death, keep/don't-drop this item" effect component exists.

**Approach:**
- Register cosmetic enchant (e.g. `namespace:soulbound`) for glint/lore/anvil.
- `deathCount` scoreboard objective to detect deaths each tick.
- **Snapshot continuously**, *before* death: every tick, copy any soulbound-tagged inventory item into a data storage keyed by player UUID (drops happen instantly on death, so you must already have the copy).
- On the death tick: **kill the dropped item entities** that match the soulbound NBT (prevents duplication), then **restore** the stored copies after respawn.

**Gotchas:** timing (snapshot must predate death); duplication (give-back without killing the ground item = dupe). Select dropped entities by matching `minecraft:enchantments` in their `Item` component.

---

## 2. Explosive Arrows (bow)

**Verdict:** Fully doable in **pure JSON, no functions**. Cleanest of the set.

**Approach (enchantment effects only):**
- `minecraft:hit_block` → `minecraft:explode` (terrain hits).
- `minecraft:post_attack` (attacker → victim) → `minecraft:explode` (mob hits).
- Bow enchantments propagate onto the arrow (same as Flame/Power/Punch), so the effects fire from the fired arrow.

**Key levers:**
- `block_interaction`: `"none"` = damage-only / no terrain damage; `"trigger"`/`"tnt"` = destroys blocks.
- `attribute_to_user: true` = kills credited to shooter.
- `radius` as a `LevelBasedValue` to scale per level.

**Gotchas:** blast will hurt the archer at close range (intended balance). Verify exact `minecraft:explode` subfield names / `block_interaction` enum values against the 26.1 enchantment page — that effect's schema is the fiddliest and has shifted across versions.

---

## 3. Echo (boots) — ORIGINAL silent-footsteps idea: NOT VIABLE

**Verdict:** Trigger logic fine; intended payload **impossible in vanilla**.

- **Triggers are fine:** "standing still 3s", "moving too fast", "took damage" — all doable via per-player scoreboards (position delta / movement stats) + a feet-slot predicate for the enchant.
- **Payload is not:** there is no way to silence a player's footsteps. Footstep sounds are **client-side** (each client plays them from its own movement); a server-side datapack has no hook to suppress them. No attribute / mob effect / component does it; player NBT isn't writable like a mob's `Silent`. `/stopsound` spam is unreliable and fires after the sound starts.
- **It wouldn't help anyway:** footstep *audio* doesn't drive mob AI in vanilla. Normal mobs aggro on line of sight; the only movement-reactive system is the Warden / sculk **vibration** system, which a datapack can't selectively mute per player.

**Reframe → Invisibility payload (VIABLE):** keep the exact triggers, swap payload to Invisibility. Stand still 3s → invisible 10–20s; sprint or take damage cancels it. `minecraft:tick` + function build. Genuinely shrinks normal-mob detection range and hides from players.

---

## 4. Echo vs Warden / sculk (design boundary)

- **Invisibility does nothing vs the Warden.** Warden is blind; it detects via **vibrations** (movement, jumping, breaking, item use — directly and via sculk sensors) and **smell** (sniffs out nearest player, locating you regardless of invis/sneak).
- **Sculk sensors** also fire on vibration, not sight — invisibility irrelevant. They're beaten by **sneaking** (crouch-walking = no step vibration) and **wool / wool carpet** (dampens/blocks vibration).
- **Takeaway:** Echo (in any form) is a **sight-stealth** tool — useful against eyes (normal mobs, players), useless in the Deep Dark. Worth leaning into as intentional design/flavour.

---

## 5. Tipped / Coated Swords (apply potion on hit, charges that degrade)

**Verdict:** Core mechanic fully doable. The "dip in a potion cauldron" interaction is Bedrock-only and can't be reproduced literally in Java.

**Application + charge consumption (native):**
- `minecraft:post_attack` → `apply_mob_effect` applies the potion to whatever you hit (victim targeting handled for you).
- `change_item_damage` on the same hook spends one charge per swing (use durability or a custom_data integer as the charge pool).

**Degradation ("weaker & shorter as it wears off"):**
- Define 3 tiers as enchant **levels 1/2/3** (strong/medium/weak, each its own duration + amplifier).
- A **tick function** reads remaining charges and syncs the stored enchant level to the current tier → effect naturally weakens as charges drain.
- This function only touches the **wielder's own item**, sidestepping the "apply to the specific mob I hit" problem.

**Why not the literal cauldron dip:** Java cauldrons hold only water/lava/powder snow (no potion cauldron — that's Bedrock), and Java datapacks have **no clean "right-clicked a block with an item" trigger**.

---

## 6. Coating application route — recipe vs anvil

### Crafting recipe
- Vanilla recipes match by **item type** and **do not read/carry NBT or components** by default.
- So "sword + potion → coated sword" as a flat recipe gives the **same** result regardless of which potion. Two fixes:
  - **One recipe per potion type** (roster of JSON files) — simple, no functions, but tedious and can't preserve the input sword's data.
  - **Function-backed pipeline** — a recipe/detection function reads `minecraft:potion_contents` off the input potion and stamps the matching tier/effect data onto the output. Handles any potion from one pipeline.

### Anvil (preferred for preservation)
- **No data-driven anvil recipes in vanilla**, and you **can't read anvil slots** — so "sword + potion in anvil" is not definable/interceptable. (Mods like AnvilAPI add this; not available to us.)
- **But the anvil natively preserves the left item's enchants/durability/name and merges the right item in** — which solves the preservation problem (see §7) for free.
- **Native path = enchanted book:** deliver the coating as a book carrying a custom `namespace:coating` enchant; player combines sword + book in a normal anvil.
  - Catch: anvil carries over **enchantments** (+ name/repair) but **strips custom_data** from the book → potion identity must live in the **enchant ID** (one coating enchant per potion type, e.g. `coating_poison`, `coating_weakness`).
  - A tick function **bootstraps the charge counter** on freshly-coated swords (anvil can't write custom_data).
  - Watch the survival **"Too Expensive!"** cap (level 40) — keep `anvil_cost` low.

### Recommended synthesis
Make the coating **books** from potions via a **crafting recipe + function** (where data-copying works and can read the potion), then **apply the book via the anvil** (where enchant/durability/name preservation is free). Each step uses the mechanism that's good at that job.

---

## 7. Preserving the sword's existing enchants (constraint on §5/§6)

- Building a fresh output item **wipes** the player's existing `minecraft:enchantments`, `minecraft:damage`, `minecraft:custom_name`, `minecraft:repair_cost`. A flat recipe can't preserve them → this **forces the component-copying pipeline** (or the anvil route, which preserves natively).
- The **coating tier shares the `minecraft:enchantments` component** with the player's real enchants. So:
  - The coating enchant must be its **own distinct ID** (coexists with Sharpness/Mending in the map).
  - The tick function must do a **surgical edit of only its own enchant key** — never overwrite the whole component, or it strips the other enchants (classic bug).

---

## 8. Vein Miner & Multi-Break

**Verdict:** Both doable in **pure vanilla** (proven packs exist), with one structural caveat.

**Caveat — no block-break hook:** vanilla has no mining event for enchantments and no block-break advancement trigger. Standard workaround: **watch the block the player is looking at and detect when it turns to air**, gated behind **sneaking + correct tool**. So it's a "sneak-mine to activate" enchant, not a fully passive on-break effect.

**Breaking + drops (solid):** `loot spawn <pos> mine <block> <tool>` simulates mining each block **with the held tool**, so **Fortune / Silk Touch / Unbreaking** all replicate correctly; then `setblock <pos> air` removes it.

**Vein Miner:**
- Mines only **connected same-type** blocks (ores) via a **capped flood-fill** from the mined block.
- Cap the vein size (performance / runaway veins).

**Multi-Break (mechanically simpler — fixed region, no flood-fill):**
- Breaks **all** blocks in a fixed region oriented to the mined face / look direction.
- Levels: **L1 = 3×3 (plane)**, **L2 = 3×3×3 (cube)**, **L3 = 5×5 (plane)**, **L4 = 5×5×5 (cube)**.

**Decisions for both:**
- **Blacklist (recommended mandatory):** bedrock, spawners, containers (chests/shulkers), maybe obsidian/portals — avoid grief and breaking unbreakables.
- **Performance:** 5×5×5 = 125 blocks/swing, each a `loot spawn` + `setblock`. Cap it; consider spreading work across ticks, or accept a hitch on the top level.
- **Durability:** charge the tool per block (Unbreaking-aware) or it's wildly OP.
- Enchant = marker/gate; **level = area size**.

**Suggested build order:** multi-break first (cleaner core, no flood-fill; reuses the same detection + `loot spawn` pipeline that vein miner then builds on).

---

## 9. Disenchanter (remove a specific enchant, recover it as a book)

**Verdict:** Achievable, and one of the easier ones (no event-detection problem).

**Value over the grindstone:** grindstone removes **all** enchants and destroys them. The datapack version's point is to **pull a specific enchant, keep the rest**, and **recover it as a book**.

**Constraint:** no native single-key removal — `remove_components` is all-or-nothing on `minecraft:enchantments`; `set_enchantments` only adds/overwrites. And player inventory isn't directly `/data`-writable.

**Approach (item-entity route — cleanest):**
- Player drops the item onto a detected "altar" block.
- Function reads its enchantments, then `data remove`s the chosen key from the **dropped item entity** at `Item.components."minecraft:enchantments".levels."minecraft:<id>"` (item entities are fully `/data`-writable — no reconstruction).
- Spawn the extracted enchant as an `enchanted_book` with `minecraft:stored_enchantments` set to that enchant + level.
- Player picks the item back up, missing exactly that one enchant.

**Alt (in-hand) route:** read to storage, filter, rebuild the item SNBT, `item replace … with $(macro)`. Works but item-string reconstruction is finicky — only if you want no-dropping.

**Decisions:**
- **Selection UX** (which enchant to pull): one-at-a-time (least-valuable/topmost), a `/trigger` chat menu, or the nicest — altar spawns one clickable book per enchant and the player takes the one to extract.
- **Cost** (balance): XP, lapis, and/or a fee item.

---

## Quick feasibility summary

| Feature | Verdict | Where the work lives |
|---|---|---|
| Soulbound | Possible | Functions (enchant cosmetic only) |
| Explosive arrows | Easy | Pure JSON, no functions |
| Echo (silent footsteps) | **Not viable** | — (reframe to invisibility) |
| Echo (invisibility) | Possible | `tick` + function |
| Tipped/coated swords | Possible | Enchant (apply/consume) + tick function (tier sync) |
| Coating via recipe | Possible | Recipe + function (data copy) |
| Coating via anvil | Possible | Native anvil + coating-book enchants + bootstrap function |
| Vein miner | Possible (sneak-gated) | Functions (flood-fill + `loot spawn`) |
| Multi-break | Possible (sneak-gated) | Functions (region + `loot spawn`) |
| Disenchanter | Possible | Functions (item-entity edit) |

---

## Things to verify against the live 26.1 wiki before building
- Exact `minecraft:explode` subfields and `block_interaction` enum values.
- Current `apply_mob_effect` / `change_item_damage` field shapes.
- Anvil book-application gating via `supported_items` for custom enchants.
- That no data-driven anvil recipe or block-break trigger has been added in your exact 26.1.x build (none in base vanilla as of these notes).
