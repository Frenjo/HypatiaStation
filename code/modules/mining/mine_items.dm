/*
 * Light
 */
//this item is intended to give the effect of entering the mine, so that light gradually fades
/obj/effect/light_emitter
	name = "light-emtter"
	anchored = TRUE
	unacidable = 1
	light_range = 8

/*
 * Miner Lockers
 */
/obj/structure/closet/secure/miner
	name = "miner's equipment"
	req_access = list(ACCESS_MINING)
	icon_state = "miningsec1"
	icon_closed = "miningsec"
	icon_locked = "miningsec1"
	icon_opened = "miningsecopen"
	icon_broken = "miningsecbroken"
	icon_off = "miningsecoff"

	starts_with = list(
		/obj/item/radio/headset/mining,
		/obj/item/clothing/under/rank/miner,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/shoes/black,
		/obj/item/gas_analyser,
		/obj/item/storage/bag/ore,
		/obj/item/flashlight/lantern,
		/obj/item/shovel,
		/obj/item/pickaxe,
		/obj/item/clothing/glasses/meson
	)

/obj/structure/closet/secure/miner/New()
	if(prob(50))
		starts_with.Add(/obj/item/storage/backpack/industrial)
	else
		starts_with.Add(/obj/item/storage/satchel/eng)
	. = ..()

/*
 * Shuttle Computer
 */
// MOVED TO /obj/machinery/computer/shuttle_control/mining

/*
 * Lantern
 */
/obj/item/flashlight/lantern
	name = "lantern"
	icon_state = "lantern"
	desc = "A mining lantern."
	brightness_on = 6			// luminosity when on

/*
 * Pickaxe
 */
/obj/item/pickaxe
	name = "pickaxe"
	icon = 'icons/obj/items.dmi'
	icon_state = "pickaxe"
	item_state = "pickaxe"
	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT
	force = 15
	throwforce = 4
	w_class = 4
	matter_amounts = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET) //one sheet, but where can you make them?
	origin_tech = list(/decl/tech/materials = 1, /decl/tech/engineering = 1)
	attack_verb = list("hit", "pierced", "sliced", "attacked")
	sharp = 1

	var/excavation_amount = 100

	// The time it takes for this tool to actually dig something.
	var/dig_time = 4 SECONDS //moving the delay to an item var so R&D can make improved picks. --NEO

	var/drill_sound = 'sound/weapons/Genhit.ogg'
	var/drill_verb = "picking"

/obj/item/pickaxe/silver
	name = "silver pickaxe"
	desc = "This makes no metallurgic sense."
	icon_state = "spickaxe"
	item_state = "spickaxe"

	origin_tech = list(/decl/tech/materials = 3)
	dig_time = 3 SECONDS

/obj/item/pickaxe/gold
	name = "golden pickaxe"
	desc = "This makes no metallurgic sense."
	icon_state = "gpickaxe"
	item_state = "gpickaxe"

	origin_tech = list(/decl/tech/materials = 4)
	dig_time = 2 SECONDS

/obj/item/pickaxe/diamond
	name = "diamond pickaxe"
	desc = "A pickaxe with a diamond pick head, this is just like minecraft."
	icon_state = "dpickaxe"
	item_state = "dpickaxe"

	matter_amounts = /datum/design/mining/pick_diamond::materials
	origin_tech = /datum/design/mining/pick_diamond::req_tech
	dig_time = 1 SECOND

/obj/item/pickaxe/drill
	name = "mining drill"
	desc = "Yours is the drill that will pierce through the rock walls."
	icon_state = "handdrill"
	item_state = "jackhammer"

	matter_amounts = /datum/design/mining/drill::materials
	origin_tech = /datum/design/mining/drill::req_tech
	dig_time = 3 SECONDS // Can dig sand as well!
	drill_verb = "drilling"

/obj/item/pickaxe/diamonddrill //When people ask about the badass leader of the mining tools, they are talking about ME!
	name = "diamond mining drill"
	desc = "Yours is the drill that will pierce the heavens!"
	icon_state = "diamonddrill"
	item_state = "jackhammer"

	matter_amounts = /datum/design/mining/drill_diamond::materials
	origin_tech = /datum/design/mining/drill_diamond::req_tech
	dig_time = 0.5 SECONDS // Digs through walls, girders, and can dig up sand.
	drill_verb = "drilling"

/obj/item/pickaxe/borgdrill
	name = "cyborg mining drill"
	desc = ""
	icon_state = "diamonddrill"
	item_state = "jackhammer"

	dig_time = 1.5 SECONDS
	drill_verb = "drilling"

/obj/item/pickaxe/jackhammer
	name = "sonic jackhammer"
	desc = "Cracks rocks with sonic blasts, perfect for killing cave lizards."
	icon_state = "jackhammer"
	item_state = "jackhammer"

	matter_amounts = /datum/design/mining/jackhammer::materials
	origin_tech = /datum/design/mining/jackhammer::req_tech
	dig_time = 2 SECONDS // Faster than drill, but cannot dig.
	drill_verb = "hammering"

/obj/item/pickaxe/plasmacutter
	name = "plasma cutter"
	desc = "A rock cutter that uses bursts of hot plasma. You could use it to cut limbs off of xenos! Or, you know, mine stuff."
	icon_state = "plasmacutter"
	item_state = "gun"
	w_class = 3 //it is smaller than the pickaxe
	damtype = "fire"

	matter_amounts = /datum/design/mining/plasmacutter::materials
	origin_tech = /datum/design/mining/plasmacutter::req_tech
	dig_time = 2 SECONDS // Can slice though normal walls, all girders, or be used in reinforced wall deconstruction/light thermite on fire.
	drill_verb = "cutting"

/obj/item/pickaxe/hammer
	name = "sledgehammer"
	desc = "A mining hammer made of reinforced metal. You feel like smashing your boss in the face with this."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "sledgehammer"

/*
 * Shovel
 */
/obj/item/shovel
	name = "shovel"
	desc = "A large tool for digging and moving dirt."
	icon = 'icons/obj/items.dmi'
	icon_state = "shovel"
	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT
	force = 8
	throwforce = 4
	item_state = "shovel"
	w_class = 3
	matter_amounts = list(/decl/material/steel = 50)
	origin_tech = list(/decl/tech/materials = 1, /decl/tech/engineering = 1)
	attack_verb = list("bashed", "bludgeoned", "thrashed", "whacked")

/obj/item/shovel/spade
	name = "spade"
	desc = "A small tool for digging and moving dirt."
	icon_state = "spade"
	item_state = "spade"
	force = 5
	throwforce = 7
	w_class = 2

/*
 * Mining Car
 *
 * (Crate-like thing, not the rail car.)
 */
/obj/structure/closet/crate/miningcar
	desc = "A mining car. This one doesn't work on rails, but has to be dragged."
	name = "mining car (not for rails)"
	icon = 'icons/obj/storage/crate.dmi'
	icon_state = "miningcar"
	density = TRUE
	icon_opened = "miningcaropen"
	icon_closed = "miningcar"