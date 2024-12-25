/obj/mecha/medical/odysseus
	name = "\improper Odysseus"
	desc = "A medical exosuit developed and produced by Vey-Med(&copy; All rights reserved)."
	icon_state = "odysseus"
	initial_icon = "odysseus"

	health = 120
	step_in = 2
	step_energy_drain = 6
	max_temperature = 15000
	deflect_chance = 15
	internal_damage_threshold = 35

	wreckage = /obj/effect/decal/mecha_wreckage/odysseus

/*
/obj/mecha/medical/odysseus/verb/set_perspective()
	set category = "Exosuit Interface"
	set name = "Set Client Perspective"
	set src = usr.loc

	var/perspective = input("Select a perspective type.", "Client perspective", occupant.client.perspective) in list(MOB_PERSPECTIVE, EYE_PERSPECTIVE)
	to_world("[perspective]")
	occupant.client.perspective = perspective

/obj/mecha/medical/odysseus/verb/toggle_eye()
	set category = "Exosuit Interface"
	set name = "Toggle Eye"
	set src = usr.loc

	if(occupant.client.eye == occupant)
		occupant.client.eye = src
	else
		occupant.client.eye = occupant
	to_world("[occupant.client.eye]")
*/
//TODO - Check documentation for client.eye and client.perspective...

// Dark Odysseus
/obj/mecha/medical/odysseus/dark
	name = "\improper Dark Odysseus"
	desc = "A significantly upgraded Vey-Med(&copy; All rights reserved) Odysseus-type chassis painted in a dark livery."
	icon_state = "dark_odysseus"
	initial_icon = "dark_odysseus"

	health = 220
	step_in = 1.5
	step_energy_drain = 3
	max_temperature = 35000
	deflect_chance = 25
	damage_absorption = list("brute" = 0.65, "fire" = 1, "bullet" = 0.7, "laser" = 0.8, "energy" = 0.8, "bomb" = 0.8)

	max_equip = 4

	wreckage = /obj/effect/decal/mecha_wreckage/odysseus/dark

/obj/mecha/medical/odysseus/dark/New()
	. = ..()
	var/obj/item/mecha_part/equipment/part = new /obj/item/mecha_part/equipment/medical/sleeper(src)
	part.attach(src)
	part = new /obj/item/mecha_part/equipment/medical/syringe_gun(src)
	part.attach(src)
	part = new /obj/item/mecha_part/equipment/melee_armour_booster(src)
	part.attach(src)
	part = new /obj/item/mecha_part/equipment/ranged_armour_booster(src)
	part.attach(src)