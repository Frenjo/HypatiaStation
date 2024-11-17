/obj/mecha/medical/odysseus
	name = "Odysseus"
	desc = "These exosuits are developed and produced by Vey-Med. (&copy; All rights reserved)."
	icon_state = "odysseus"

	initial_icon = "odysseus"
	step_in = 2
	max_temperature = 15000
	health = 120
	wreckage = /obj/effect/decal/mecha_wreckage/odysseus
	internal_damage_threshold = 35
	deflect_chance = 15
	step_energy_drain = 6

	var/obj/item/clothing/glasses/hud/health/mech/hud

/obj/mecha/medical/odysseus/New()
	. = ..()
	hud = new /obj/item/clothing/glasses/hud/health/mech(src)

/obj/mecha/medical/odysseus/moved_inside(mob/living/carbon/human/H)
	if(..())
		if(isnotnull(H.glasses))
			occupant_message(SPAN_WARNING("\The [H.glasses] prevent you from using \the [src]'s [hud]."))
		else
			H.glasses = hud
		return TRUE
	return FALSE

/obj/mecha/medical/odysseus/go_out()
	if(ishuman(occupant))
		var/mob/living/carbon/human/H = occupant
		if(H.glasses == hud)
			H.glasses = null
	. = ..()
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
/obj/item/clothing/glasses/hud/health/mech
	name = "integrated medical HUD"

/obj/item/clothing/glasses/hud/health/mech/process_hud(mob/M)
	process_med_hud(M, 1)