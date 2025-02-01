/obj/mecha/combat/eidolon
	name = "\improper Eidolon"
	desc = "A mech of strange origin. Where did it come from?"
	icon_state = "eidolon"
	infra_luminosity = 8
	initial_icon = "eidolon"

	damtype = HALLOSS
	force = 35

	health = 250
	step_in = 3
	max_temperature = 30000
	deflect_chance = 30
	damage_absorption = list("brute" = 0.85, "fire" = 0, "bullet" = 0.65, "laser" = 0.65, "energy" = 0.65, "bomb" = 0.8)

	step_sound = 'sound/mecha/eidolon/sbdwalk0.ogg'
	turn_sound = 'sound/mecha/mechmove01.ogg'

	wreckage = /obj/structure/mecha_wreckage/eidolon

	var/salvaged = FALSE // Salvaged version can fit regular sized humans.

	var/rolling = FALSE
	var/step_loop = 0

/obj/mecha/combat/eidolon/New()
	. = ..()
	var/obj/item/mecha_part/equipment/weapon/energy/rapid_disabler/disabler = new /obj/item/mecha_part/equipment/weapon/energy/rapid_disabler(src)
	disabler.attach(src)

/obj/mecha/combat/eidolon/Topic(href, list/href_list)
	. = ..()
	if(href_list["toggle_ball_mode"])
		toggle_ball_mode()

/obj/mecha/combat/eidolon/get_stats_part()
	. = ..()
	. += "<b>Ball mode: [rolling ? "enabled" : "disabled"]</b>"

/obj/mecha/combat/eidolon/get_commands()
	. = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='byond://?src=\ref[src];toggle_ball_mode=1'>Toggle Ball Mode</a>
						</div>
						</div>
						"}
	. += ..()

/obj/mecha/combat/eidolon/mechstep(direction) // No strafing when rolling, also looping movement sound.
	if(!rolling)
		step_loop = (step_loop++) % 3
		step_sound = "sound/mecha/eidolon/sbdwalk[step_loop].ogg"
	. = ..()

/obj/mecha/combat/eidolon/go_out()
	. = ..()
	if(isnotnull(occupant))
		return
	if(rolling)
		toggle_ball_mode()

/obj/mecha/combat/eidolon/verb/toggle_ball_mode()
	set category = "Exosuit Interface"
	set name = "Toggle Ball Mode"
	set popup_menu = FALSE
	set src = usr.loc

	if(usr != occupant)
		return

	rolling = !rolling
	if(rolling)
		icon_state = "eidolon-ball"
		deflect_chance += 40
		step_in = 0.5
		step_sound = 'sound/mecha/eidolon/mechball.ogg'
		step_sound_volume = 100
		turn_sound = null
		occupant_message(SPAN_INFO("You enable ball mode."))
	else
		icon_state = initial_icon
		deflect_chance -= 40
		step_in = initial(step_in)
		step_sound = initial(step_sound)
		step_sound_volume = initial(step_sound_volume)
		turn_sound = initial(turn_sound)
		occupant_message(SPAN_WARNING("You disable ball mode."))
	log_message("Toggled ball mode.")

/obj/mecha/combat/eidolon/salvaged // We can rebuild him.
	force = 26

	step_in = 5
	deflect_chance = 20
	damage_absorption = list("brute" = 0.85, "fire" = 0, "bullet" = 0.75, "laser" = 0.75, "energy" = 0.75, "bomb" = 0.8)

	wreckage = /obj/structure/mecha_wreckage/eidolon/wrecked // Double wrecked, he ain't getting up from that!

	salvaged = TRUE

/obj/mecha/combat/eidolon/salvaged/New()
	. = ..()
	for_no_type_check(var/obj/item/mecha_part/equipment/equip, equipment)
		equip.detach()
		qdel(equip)