/obj/mecha/combat/durand
	name = "Durand"
	desc = "An aging combat exosuit utilized by the NanoTrasen corporation. Originally developed to combat hostile alien lifeforms."
	icon_state = "durand"
	initial_icon = "durand"

	step_in = 4
	health = 400
	deflect_chance = 20
	damage_absorption = list("brute" = 0.5, "fire" = 1.1, "bullet" = 0.65, "laser" = 0.85, "energy" = 0.9, "bomb" = 0.8)
	max_temperature = 30000
	infra_luminosity = 8
	force = 40
	wreckage = /obj/effect/decal/mecha_wreckage/durand

	var/defence = 0
	var/defence_deflect = 35

/obj/mecha/combat/durand/relaymove(mob/user, direction)
	if(defence)
		if(world.time - last_message > 20)
			occupant_message(SPAN_WARNING("Unable to move while in defence mode."))
			last_message = world.time
		return 0
	. = ..()

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
		occupant_message(SPAN_INFO("You enable defence mode."))
	else
		deflect_chance = initial(deflect_chance)
		occupant_message(SPAN_WARNING("You disable defence mode."))
	log_message("Toggled defence mode.")

/obj/mecha/combat/durand/get_stats_part()
	. = ..()
	. += "<b>Defence mode: [defence ? "on" : "off"]</b>"

/obj/mecha/combat/durand/get_commands()
	. = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='byond://?src=\ref[src];toggle_defence_mode=1'>Toggle defence mode</a>
						</div>
						</div>
						"}
	. += ..()

/obj/mecha/combat/durand/Topic(href, href_list)
	. = ..()
	if(href_list["toggle_defence_mode"])
		defence_mode()