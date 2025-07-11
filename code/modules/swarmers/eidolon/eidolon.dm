/obj/mecha/combat/eidolon
	name = "\improper Eidolon"
	desc = "A mech of strange origin. Where did it come from?"
	icon_state = "eidolon"
	infra_luminosity = 8

	pass_flags = PASS_FLAG_SWARMER

	damtype = HALLOSS
	force = 35

	health = 250
	move_delay = 0.3 SECONDS
	max_temperature = 30000
	deflect_chance = 30
	damage_resistance = list("brute" = 15, "fire" = 90, "bullet" = 35, "laser" = 35, "energy" = 35, "bomb" = 20)

	step_sound = 'sound/mecha/movement/eidolon/sbdwalk0.ogg'
	turn_sound = 'sound/mecha/movement/mechmove01.ogg'

	mecha_type = MECHA_TYPE_EIDOLON
	starts_with = list(/obj/item/mecha_equipment/weapon/energy/disabler/rapid)

	wreckage = /obj/structure/mecha_wreckage/eidolon

	var/salvaged = FALSE // Salvaged version can fit regular sized humans.

	var/rolling = FALSE
	var/step_loop = 0

/obj/mecha/combat/eidolon/MouseDrop_T(atom/dropping, mob/user)
	if(salvaged)
		return ..()
	if(!isswarmer(user))
		return FALSE

	user.visible_message(
		SPAN_INFO("[user] starts to climb into \the [src]."),
		SPAN_INFO("You start to climb into \the [src].")
	)
	if(do_after(user, 4 SECONDS, src))
		if(isnull(occupant))
			moved_inside(user)
		else if(occupant != user)
			to_chat(user, SPAN_WARNING("\The [occupant] was faster. Try better next time, loser."))
	else
		to_chat(user, SPAN_INFO("You stop entering the exosuit."))
	return TRUE

/obj/mecha/combat/eidolon/go_out()
	. = ..()
	if(isnotnull(occupant))
		return
	if(rolling)
		toggle_ball_mode()

/obj/mecha/combat/eidolon/mechstep(direction) // No strafing when rolling, also looping movement sound.
	if(!rolling)
		step_loop = (step_loop++) % 3
		step_sound = "sound/mecha/movement/eidolon/sbdwalk[step_loop].ogg"
	. = ..()

/obj/mecha/combat/eidolon/get_stats_part()
	. = ..()
	. += "<b>Ball Mode: [rolling ? "enabled" : "disabled"]</b>"

/obj/mecha/combat/eidolon/get_commands()
	. = {"<div class='wr'>
		<div class='header'>Special</div>
		<div class='links'>
		<a href='byond://?src=\ref[src];ball_mode=1'><span id="ball_mode_command">[rolling ? "Dis" : "En"]able Ball Mode</span></a>
		</div>
		</div>
	"}
	. += ..()

/obj/mecha/combat/eidolon/Topic(href, list/href_list)
	. = ..()
	if(href_list["ball_mode"])
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
		move_delay = 0.05 SECONDS
		step_sound = 'sound/mecha/movement/eidolon/mechball.ogg'
		step_sound_volume = 100
		turn_sound = null
	else
		icon_state = initial(icon_state)
		deflect_chance -= 40
		move_delay = initial(move_delay)
		step_sound = initial(step_sound)
		step_sound_volume = initial(step_sound_volume)
		turn_sound = initial(turn_sound)
	balloon_alert(occupant, "[rolling ? "en" : "dis"]abled ball mode")
	send_byjax(occupant, "exosuit.browser", "ball_mode_command", "[rolling ? "Dis" : "En"]able Ball Mode")
	log_message("Toggled ball mode.")

/obj/mecha/combat/eidolon/salvaged // We can rebuild him.
	name = "\improper Salvaged Eidolon"
	desc = "A primitive replica of a mech of strange origin. This one appears to be constructed from salvaged parts."

	pass_flags = null

	force = 26

	move_delay = 0.5 SECONDS
	deflect_chance = 20
	damage_resistance = list("brute" = 15, "fire" = 90, "bullet" = 25, "laser" = 25, "energy" = 25, "bomb" = 80)

	starts_with = null

	wreckage = /obj/structure/mecha_wreckage/eidolon/wrecked // Double wrecked, he ain't getting up from that!

	salvaged = TRUE