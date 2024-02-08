/*
 * Light
 */
//this item is intended to give the effect of entering the mine, so that light gradually fades
/obj/effect/light_emitter
	name = "Light-emtter"
	anchored = TRUE
	unacidable = 1
	light_range = 8

/*
 * Miner Lockers
 */
/obj/structure/closet/secure_closet/miner
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

/obj/structure/closet/secure_closet/miner/New()
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
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 15
	throwforce = 4
	item_state = "pickaxe"
	w_class = 4
	matter_amounts = list(MATERIAL_METAL = 3750) //one sheet, but where can you make them?
	origin_tech = list(RESEARCH_TECH_MATERIALS = 1, RESEARCH_TECH_ENGINEERING = 1)
	attack_verb = list("hit", "pierced", "sliced", "attacked")
	sharp = 1

	var/excavation_amount = 100

	var/digspeed = 40 //moving the delay to an item var so R&D can make improved picks. --NEO

	var/drill_sound = 'sound/weapons/Genhit.ogg'
	var/drill_verb = "picking"

/obj/item/pickaxe/hammer
	name = "sledgehammer"
	desc = "A mining hammer made of reinforced metal. You feel like smashing your boss in the face with this."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "sledgehammer"

/obj/item/pickaxe/silver
	name = "silver pickaxe"
	icon_state = "spickaxe"
	item_state = "spickaxe"
	digspeed = 30
	origin_tech = list(RESEARCH_TECH_MATERIALS = 3)
	desc = "This makes no metallurgic sense."

/obj/item/pickaxe/drill
	name = "mining drill" // Can dig sand as well!
	icon_state = "handdrill"
	item_state = "jackhammer"
	digspeed = 30
	origin_tech = list(RESEARCH_TECH_MATERIALS = 2, RESEARCH_TECH_POWERSTORAGE = 3, RESEARCH_TECH_ENGINEERING = 2)
	desc = "Yours is the drill that will pierce through the rock walls."
	drill_verb = "drilling"

/obj/item/pickaxe/jackhammer
	name = "sonic jackhammer"
	icon_state = "jackhammer"
	item_state = "jackhammer"
	digspeed = 20 //faster than drill, but cannot dig
	origin_tech = list(RESEARCH_TECH_MATERIALS = 3, RESEARCH_TECH_POWERSTORAGE = 2, RESEARCH_TECH_ENGINEERING = 2)
	desc = "Cracks rocks with sonic blasts, perfect for killing cave lizards."
	drill_verb = "hammering"

/obj/item/pickaxe/gold
	name = "golden pickaxe"
	icon_state = "gpickaxe"
	item_state = "gpickaxe"
	digspeed = 20
	origin_tech = list(RESEARCH_TECH_MATERIALS = 4)
	desc = "This makes no metallurgic sense."

/obj/item/pickaxe/plasmacutter
	name = "plasma cutter"
	icon_state = "plasmacutter"
	item_state = "gun"
	w_class = 3 //it is smaller than the pickaxe
	damtype = "fire"
	digspeed = 20 //Can slice though normal walls, all girders, or be used in reinforced wall deconstruction/ light thermite on fire
	origin_tech = list(RESEARCH_TECH_MATERIALS = 4, RESEARCH_TECH_PLASMATECH = 3, RESEARCH_TECH_ENGINEERING = 3)
	desc = "A rock cutter that uses bursts of hot plasma. You could use it to cut limbs off of xenos! Or, you know, mine stuff."
	drill_verb = "cutting"

/obj/item/pickaxe/diamond
	name = "diamond pickaxe"
	icon_state = "dpickaxe"
	item_state = "dpickaxe"
	digspeed = 10
	origin_tech = list(RESEARCH_TECH_MATERIALS = 6, RESEARCH_TECH_ENGINEERING = 4)
	desc = "A pickaxe with a diamond pick head, this is just like minecraft."

/obj/item/pickaxe/diamonddrill //When people ask about the badass leader of the mining tools, they are talking about ME!
	name = "diamond mining drill"
	icon_state = "diamonddrill"
	item_state = "jackhammer"
	digspeed = 5 //Digs through walls, girders, and can dig up sand
	origin_tech = list(RESEARCH_TECH_MATERIALS = 6, RESEARCH_TECH_POWERSTORAGE = 4, RESEARCH_TECH_ENGINEERING = 5)
	desc = "Yours is the drill that will pierce the heavens!"
	drill_verb = "drilling"

/obj/item/pickaxe/borgdrill
	name = "cyborg mining drill"
	icon_state = "diamonddrill"
	item_state = "jackhammer"
	digspeed = 15
	desc = ""
	drill_verb = "drilling"

/*
 * Shovel
 */
/obj/item/shovel
	name = "shovel"
	desc = "A large tool for digging and moving dirt."
	icon = 'icons/obj/items.dmi'
	icon_state = "shovel"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	force = 8
	throwforce = 4
	item_state = "shovel"
	w_class = 3
	matter_amounts = list(MATERIAL_METAL = 50)
	origin_tech = list(RESEARCH_TECH_MATERIALS = 1, RESEARCH_TECH_ENGINEERING = 1)
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
	name = "Mining car (not for rails)"
	icon = 'icons/obj/storage/crate.dmi'
	icon_state = "miningcar"
	density = TRUE
	icon_opened = "miningcaropen"
	icon_closed = "miningcar"