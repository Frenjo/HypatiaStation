/obj/mecha/combat/durand
	name = "\improper Durand"
	desc = "An aging combat exosuit utilised by the NanoTrasen corporation. Originally developed to combat hostile alien lifeforms."
	icon_state = "durand"
	infra_luminosity = 8

	entry_direction = NORTH

	force = 40

	health = 400
	step_in = 4
	max_temperature = 30000
	deflect_chance = 20
	damage_absorption = list("brute" = 0.5, "fire" = 1.1, "bullet" = 0.65, "laser" = 0.85, "energy" = 0.9, "bomb" = 0.8)

	mecha_flag = MECHA_FLAG_DURAND

	wreckage = /obj/structure/mecha_wreckage/durand

	var/defence = 0
	var/defence_deflect = 35

/obj/mecha/combat/durand/relaymove(mob/user, direction)
	if(defence)
		if(world.time - last_message > 20)
			occupant_message(SPAN_WARNING("Unable to move while in defence mode."))
			last_message = world.time
		return 0
	. = ..()

/obj/mecha/combat/durand/get_stats_part()
	. = ..()
	. += "<b>Defence Mode: [defence ? "enabled" : "disabled"]</b>"

/obj/mecha/combat/durand/get_commands()
	. = {"<div class='wr'>
		<div class='header'>Special</div>
		<div class='links'>
		<a href='byond://?src=\ref[src];defence_mode=1'><span id="defence_mode_command">[defence ? "Dis" : "En"]able Defence Mode</span></a>
		</div>
		</div>
	"}
	. += ..()

/obj/mecha/combat/durand/Topic(href, href_list)
	. = ..()
	if(href_list["defence_mode"])
		defence_mode()

/obj/mecha/combat/durand/verb/defence_mode()
	set category = "Exosuit Interface"
	set name = "Toggle Defence Mode"
	set popup_menu = FALSE
	set src = usr.loc

	if(usr != occupant)
		return

	defence = !defence
	if(defence)
		deflect_chance = defence_deflect
	else
		deflect_chance = initial(deflect_chance)
	balloon_alert(occupant, "[defence ? "en" : "dis"]abled defence mode")
	send_byjax(occupant, "exosuit.browser", "defence_mode_command", "[defence ? "Dis" : "En"]able Defence Mode")
	log_message("Toggled defence mode.")

// Archambeau
/obj/mecha/combat/durand/archambeau
	name = "\improper Archambeau"
	desc = "A modern variant of the aging Durand-type exosuit. This version features enhanced lightweight armour plating akin to that originally developed for the Phazon-type exosuit."
	icon_state = "archambeau"
	infra_luminosity = 6

	force = 25

	step_in = 3
	step_energy_drain = 15
	max_temperature = 25000
	deflect_chance = 20
	damage_absorption = list("brute" = 0.6, "fire" = 0.9, "bullet" = 0.675, "laser" = 0.775, "energy" = 0.8, "bomb" = 0.75)
	internal_damage_threshold = 35

	wreckage = /obj/structure/mecha_wreckage/durand/archambeau