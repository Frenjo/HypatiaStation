/obj/mecha/medical/odysseus
	name = "\improper Odysseus"
	desc = "A medical exosuit developed and produced by Vey-Med(&copy; all rights reserved)."
	icon_state = "odysseus"
	initial_icon = "odysseus"

	health = 120
	step_in = 2
	step_energy_drain = 6
	max_temperature = 15000
	deflect_chance = 15
	internal_damage_threshold = 35

	wreckage = /obj/structure/mecha_wreckage/odysseus

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
	desc = "A significantly upgraded Vey-Med(&copy; all rights reserved) Odysseus-type chassis painted in a dark livery."
	icon_state = "dark_odysseus"
	initial_icon = "dark_odysseus"

	health = 220
	step_in = 1.5
	step_energy_drain = 3
	max_temperature = 35000
	deflect_chance = 25
	damage_absorption = list("brute" = 0.65, "fire" = 1, "bullet" = 0.7, "laser" = 0.8, "energy" = 0.8, "bomb" = 0.8)

	max_equip = 4

	wreckage = /obj/structure/mecha_wreckage/odysseus/dark

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

/obj/mecha/medical/odysseus/dark/add_cell(obj/item/cell/C = null)
	if(isnotnull(C))
		C.forceMove(src)
		cell = C
		return
	cell = new /obj/item/cell/hyper(src)

// Eurymachus
/obj/mecha/medical/odysseus/eurymachus
	name = "\improper Eurymachus"
	desc = "A sinister variant of the Vey-Med(&copy; all rights reserved) Odysseus-type chassis featuring weapons-capable hardpoints and the unique ability to camouflage as its regular counterpart."
	icon_state = "eurymachus"
	initial_icon = "eurymachus"

	health = 170
	step_in = 1.75
	step_energy_drain = 4.5
	max_temperature = 25000
	deflect_chance = 20
	damage_absorption = list("brute" = 0.725, "fire" = 1.1, "bullet" = 0.8, "laser" = 0.9, "energy" = 0.9, "bomb" = 0.9)

	wreckage = /obj/structure/mecha_wreckage/odysseus/eurymachus

	excluded_equipment = list(
		/obj/item/mecha_part/equipment/tool/hydraulic_clamp,
		/obj/item/mecha_part/equipment/tool/extinguisher,
		/obj/item/mecha_part/equipment/tool/rcd,
		/obj/item/mecha_part/equipment/tool/cable_layer
	)

	var/datum/global_iterator/camouflage_iterator
	var/camouflage = FALSE
	var/camouflage_energy_drain = 100

/obj/mecha/medical/odysseus/eurymachus/New()
	. = ..()
	var/obj/item/mecha_part/equipment/part = new /obj/item/mecha_part/equipment/weapon/energy/taser(src)
	part.attach(src)
	part = new /obj/item/mecha_part/equipment/medical/sleeper(src)
	part.attach(src)
	part = new /obj/item/mecha_part/equipment/medical/syringe_gun(src)
	part.attach(src)

/obj/mecha/medical/odysseus/eurymachus/add_cell(obj/item/cell/C = null)
	if(isnotnull(C))
		C.forceMove(src)
		cell = C
		return
	cell = new /obj/item/cell/hyper(src)

/obj/mecha/medical/odysseus/eurymachus/add_iterators()
	. = ..()
	camouflage_iterator = new /datum/global_iterator/mecha_camouflage(list(src))

/obj/mecha/medical/odysseus/eurymachus/remove_iterators()
	. = ..()
	QDEL_NULL(camouflage_iterator)

/obj/mecha/medical/odysseus/eurymachus/get_commands()
	. = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='byond://?src=\ref[src];camouflage=1'><span id="camouflage_command">[camouflage ? "Dis" : "En"]able camouflage</span></a><br>
						</div>
						</div>
						"}
	. += ..()

/obj/mecha/medical/odysseus/eurymachus/Topic(href, href_list)
	. = ..()
	if(href_list["camouflage"])
		toggle_camouflage()

/obj/mecha/medical/odysseus/eurymachus/verb/toggle_camouflage()
	set category = "Exosuit Interface"
	set name = "Toggle Camouflage"
	set popup_menu = FALSE
	set src = usr.loc

	camouflage = !camouflage
	send_byjax(occupant, "exosuit.browser", "camouflage_command", "[camouflage ? "Dis" : "En"]able camouflage")
	occupant_message("<font color=\"[camouflage ? "#00f\">En" : "#f00\">Dis"]abled camouflage.</font>")
	// Does some sparks and the chameleon projector effect.
	var/turf/T = GET_TURF(src)
	make_sparks(3, TRUE, T)
	var/obj/effect/overlay/pulse = new /obj/effect/overlay(T)
	pulse.icon = 'icons/effects/effects.dmi'
	pulse.plane = UNLIT_EFFECTS_PLANE
	flick("emppulse", pulse)
	spawn(8)
		qdel(pulse)
	playsound(T, 'sound/effects/pop.ogg', 100, TRUE, -6)
	// Swaps the icon states and descriptions then updates the iterator.
	if(camouflage)
		icon_state = "odysseus"
		desc = "A medical exosuit developed and produced by Vey-Med(&copy; all rights reserved)."
		camouflage_iterator.start()
	else
		icon_state = "eurymachus"
		desc = "A sinister variant of the Vey-Med(&copy; all rights reserved) Odysseus-type chassis featuring weapons-capable hardpoints and the unique ability to camouflage as its regular counterpart."
		camouflage_iterator.stop()
	log_message("Toggled camouflage.")

// Mecha camouflage power drain handler.
/datum/global_iterator/mecha_camouflage
	delay = 2 SECONDS

/datum/global_iterator/mecha_camouflage/process(obj/mecha/medical/odysseus/eurymachus/mecha)
	if(mecha.get_charge() >= mecha.camouflage_energy_drain)
		mecha.use_power(mecha.camouflage_energy_drain)
	else
		mecha.toggle_camouflage()