/obj/mecha/medical/odysseus
	name = "\improper Odysseus"
	desc = "A medical exosuit developed and produced by Vey-Med(&copy; all rights reserved)."
	icon_state = "odysseus"

	health = 120
	move_delay = 0.2 SECONDS
	step_energy_drain = 6
	max_temperature = 15000
	deflect_chance = 15
	internal_damage_threshold = 35

	mecha_type = MECHA_TYPE_ODYSSEUS

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

	health = 220
	move_delay = 0.15 SECONDS
	step_energy_drain = 3
	max_temperature = 35000
	deflect_chance = 25
	damage_resistance = list("brute" = 35, "fire" = 20, "bullet" = 30, "laser" = 20, "energy" = 20, "bomb" = 20)

	max_equip = 4

	wreckage = /obj/structure/mecha_wreckage/odysseus/dark

/obj/mecha/medical/odysseus/dark/add_cell(obj/item/cell/C = null)
	if(isnotnull(C))
		C.forceMove(src)
		cell = C
		return
	cell = new /obj/item/cell/hyper(src)

// Equipped variant
/obj/mecha/medical/odysseus/dark/equipped
	starts_with = list(
		/obj/item/mecha_equipment/medical/sleeper, /obj/item/mecha_equipment/medical/syringe_gun,
		/obj/item/mecha_equipment/melee_armour_booster, /obj/item/mecha_equipment/ranged_armour_booster
	)

// Eurymachus
/obj/mecha/medical/odysseus/eurymachus
	name = "\improper Eurymachus"
	desc = "A sinister variant of the Vey-Med(&copy; all rights reserved) Odysseus-type chassis featuring weapons-capable hardpoints and the unique ability to camouflage as its regular counterpart."
	icon_state = "eurymachus"

	health = 170
	move_delay = 0.175 SECONDS
	step_energy_drain = 4.5
	max_temperature = 25000
	deflect_chance = 20
	damage_resistance = list("brute" = 27.5, "fire" = 10, "bullet" = 20, "laser" = 10, "energy" = 10, "bomb" = 10)

	operation_req_access = list(ACCESS_SYNDICATE)
	add_req_access = FALSE

	mecha_type = MECHA_TYPE_EURYMACHUS

	wreckage = /obj/structure/mecha_wreckage/odysseus/eurymachus

	var/camouflage = FALSE
	var/camouflage_energy_drain = 50
	var/camouflage_animation_playing = FALSE

/obj/mecha/medical/odysseus/eurymachus/process()
	. = ..()
	if(!camouflage)
		return
	if(world.time % 2 SECONDS != 0)
		return

	// Handles camouflage power drain.
	if(get_charge() >= camouflage_energy_drain)
		use_power(camouflage_energy_drain)
	else
		toggle_camouflage()

/obj/mecha/medical/odysseus/eurymachus/add_cell(obj/item/cell/C = null)
	if(isnotnull(C))
		C.forceMove(src)
		cell = C
		return
	cell = new /obj/item/cell/hyper(src)

/obj/mecha/medical/odysseus/eurymachus/get_stats_part()
	. = ..()
	. += "<b>Camouflage: [camouflage ? "enabled" : "disabled"]</b>"

/obj/mecha/medical/odysseus/eurymachus/get_commands()
	. = {"<div class='wr'>
		<div class='header'>Special</div>
		<div class='links'>
		<a href='byond://?src=\ref[src];camouflage=1'><span id="camouflage_command">[camouflage ? "Dis" : "En"]able Camouflage</span></a>
		<br>
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

	if(camouflage)
		camouflage = FALSE
		do_camouflage_effects()
		disable_camouflage()
	else
		if(camouflage_animation_playing)
			balloon_alert(occupant, "camouflage recharging!")
			return
		balloon_alert(occupant, "activating camouflage...")
		apply_wibbly_filters(src)
		if(do_after(occupant, 4 SECONDS, src) && has_charge(2000)) // This is akin to the force fields where they stop working below 2000 charge.
			do_camouflage_effects()
			enable_camouflage()
		else
			do_camouflage_effects()
			balloon_alert(occupant, "camouflage failed!")
		remove_wibbly_filters(src)
		camouflage_animation_playing = FALSE

	send_byjax(occupant, "exosuit.browser", "camouflage_command", "[camouflage ? "Dis" : "En"]able camouflage")
	log_message("Toggled camouflage.")

/obj/mecha/medical/odysseus/eurymachus/proc/do_camouflage_effects()
	var/turf/T = GET_TURF(src)
	make_sparks(3, TRUE, T)
	var/obj/effect/overlay/pulse = new /obj/effect/overlay(T)
	pulse.icon = 'icons/effects/effects.dmi'
	pulse.plane = UNLIT_EFFECTS_PLANE
	flick("emppulse", pulse)
	spawn(8)
		qdel(pulse)
	playsound(T, 'sound/effects/pop.ogg', 100, TRUE, -6)

/obj/mecha/medical/odysseus/eurymachus/proc/enable_camouflage()
	balloon_alert(occupant, "enabled camouflage")
	camouflage = TRUE
	icon_state = /obj/mecha/medical/odysseus::icon_state
	desc = /obj/mecha/medical/odysseus::desc

/obj/mecha/medical/odysseus/eurymachus/proc/disable_camouflage()
	balloon_alert(occupant, "disabled camouflage")
	camouflage = FALSE
	icon_state = initial(icon_state)
	desc = initial(desc)

// Equipped variant
/obj/mecha/medical/odysseus/eurymachus/equipped
	starts_with = list(
		/obj/item/mecha_equipment/weapon/energy/taser, /obj/item/mecha_equipment/medical/sleeper,
		/obj/item/mecha_equipment/medical/syringe_gun
	)