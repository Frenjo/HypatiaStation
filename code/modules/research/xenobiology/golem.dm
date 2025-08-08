////////Adamantine Golem stuff I dunno where else to put it
/obj/item/clothing/under/golem
	name = "adamantine skin"
	desc = "a golem's skin"
	icon_state = "golem"
	item_state = "golem"
	item_color = "golem"
	has_sensor = 0
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	can_remove = FALSE

/obj/item/clothing/suit/golem
	name = "adamantine shell"
	desc = "a golem's thick outer shell"
	icon_state = "golem"
	item_state = "golem"
	w_class = 4//bulky item
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS | HEAD
	slowdown = 1.0
	inv_flags = INV_FLAG_HIDE_GLOVES | INV_FLAG_HIDE_JUMPSUIT | INV_FLAG_HIDE_SHOES
	item_flags = ITEM_FLAG_STOPS_PRESSURE_DAMAGE | ITEM_FLAG_ONE_SIZE_FITS_ALL
	heat_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS | HEAD
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS | HEAD
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	can_remove = FALSE
	armor = list(melee = 80, bullet = 20, laser = 20, energy = 10, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/shoes/golem
	name = "golem's feet"
	desc = "sturdy adamantine feet"
	icon_state = "golem"
	item_state = null
	can_remove = FALSE
	item_flags = ITEM_FLAG_NO_SLIP
	slowdown = SHOES_SLOWDOWN + 1

/obj/item/clothing/mask/gas/golem
	name = "golem's face"
	desc = "the imposing face of an adamantine golem"
	icon_state = "golem"
	obj_flags = OBJ_FLAG_UNACIDABLE
	item_state = "golem"
	can_remove = FALSE
	siemens_coefficient = 0

/obj/item/clothing/gloves/golem
	name = "golem's hands"
	desc = "strong adamantine hands"
	icon_state = "golem"
	item_state = null
	siemens_coefficient = 0
	can_remove = FALSE

/obj/item/clothing/head/space/golem
	name = "golem's head"
	desc = "a golem's head"
	icon_state = "golem"
	obj_flags = OBJ_FLAG_UNACIDABLE
	item_state = "dermal"
	item_color = "dermal"
	can_remove = FALSE
	item_flags = ITEM_FLAG_STOPS_PRESSURE_DAMAGE
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 80, bullet = 20, laser = 20, energy = 10, bomb = 0, bio = 0, rad = 0)

/obj/effect/golemrune
	anchored = TRUE
	desc = "a strange rune used to create golems. It glows when spirits are nearby."
	name = "rune"
	icon = 'icons/obj/rune.dmi'
	icon_state = "golem"
	layer = TURF_LAYER

/obj/effect/golemrune/initialise()
	. = ..()
	START_PROCESSING(PCobj, src)

/obj/effect/golemrune/Destroy()
	STOP_PROCESSING(PCobj, src)
	return ..()

/obj/effect/golemrune/process()
	var/mob/dead/ghost/ghost
	for(var/mob/dead/ghost/O in src.loc)
		if(!O.client)
			continue
		if(O.mind && O.mind.current && O.mind.current.stat != DEAD)
			continue
		ghost = O
		break
	if(ghost)
		icon_state = "golem2"
	else
		icon_state = "golem"

/obj/effect/golemrune/attack_hand(mob/living/user)
	var/mob/dead/ghost/ghost
	for(var/mob/dead/ghost/O in src.loc)
		if(!O.client)
			continue
		if(O.mind && O.mind.current && O.mind.current.stat != DEAD)
			continue
		ghost = O
		break
	if(!ghost)
		to_chat(user, SPAN_DEADSAY("The rune fizzles uselessly. There is no spirit nearby."))
		return
	var/mob/living/carbon/human/G = new /mob/living/carbon/human
	G.dna.mutantrace = "adamantine"
	G.real_name = "Adamantine Golem ([rand(1, 1000)])"
	G.equip_outfit(/decl/hierarchy/outfit/adamantine_golem)
	G.forceMove(loc)
	G.key = ghost.key
	to_chat(G, "You are an adamantine golem. You move slowly, but are highly resistant to heat and cold as well as blunt trauma. You are unable to wear clothes, but can still use most tools. Serve [user], and assist them in completing their goals at any cost.")
	qdel (src)

/obj/effect/golemrune/proc/announce_to_ghosts()
	for(var/mob/dead/ghost/G in GLOBL.player_list)
		if(G.client)
			var/area/A = GET_AREA(src)
			if(isnotnull(A))
				to_chat(G, SPAN_DEADSAY("<em>Golem rune created in [A.name].</em>"))

// Adamanatine Golem outfit
/decl/hierarchy/outfit/adamantine_golem
	name = "Adamantine Golem"

	uniform = /obj/item/clothing/under/golem
	suit = /obj/item/clothing/suit/golem

	head = /obj/item/clothing/head/space/golem
	mask = /obj/item/clothing/mask/gas/golem
	gloves = /obj/item/clothing/gloves/golem
	shoes = /obj/item/clothing/shoes/golem