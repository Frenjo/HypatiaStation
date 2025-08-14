#define MOVE_DELAY_ANGRY (0.45 SECONDS)
#define MOVE_DELAY_SAFETY (0.25 SECONDS)

/obj/mecha/combat/justice
	name = "\improper Justice"
	desc = "A black-and-red Syndicate exosuit designed for execution orders. For safety reasons, it is advised against standing too close."
	icon_state = "justice"

	force = 60

	activation_sound = 'sound/mecha/voice/nominalsyndi.ogg'
	activation_sound_volume = 90

	health = 200
	move_delay = MOVE_DELAY_SAFETY
	step_energy_drain = 2
	max_temperature = 40000
	damage_resistance = list("brute" = 30, "fire" = 30, "bullet" = 20, "laser" = 20, "energy" = 30, "bomb" = 30)

	operation_req_access = list(ACCESS_SYNDICATE)
	add_req_access = FALSE

	mecha_type = MECHA_TYPE_JUSTICE
	max_equip = 3

	wreckage = /obj/structure/mecha_wreckage/justice

	var/weapons_safety = TRUE
	var/is_invisible = FALSE
	var/invisibility_energy_drain = 200

/obj/mecha/combat/justice/Move(new_loc, direction)
	. = ..()
	update_icon()

/obj/mecha/combat/justice/update_icon()
	. = ..()
	if(isnotnull(occupant))
		icon_state = weapons_safety ? "justice" : "justice-angry"
	if(!check_for_support())
		icon_state = "[icon_state]-fly"

/obj/mecha/combat/justice/melee_action(atom/target)
	if(weapons_safety)
		return
	if(is_invisible)
		disable_invisibility(TRUE)
	. = ..()
	playsound(src, 'sound/mecha/justice/blade_attack.ogg', 100, TRUE)

/obj/mecha/combat/justice/get_stats_part()
	. = ..()
	. += "<b>Safety: [weapons_safety ? "enabled" : "disabled"]</b>"
	. += "<br>"
	. += "<b>Invisibility: [is_invisible ? "enabled" : "disabled"]</b>"

/obj/mecha/combat/justice/get_commands()
	. = {"<div class='wr'>
		<div class='header'>Special</div>
		<div class='links'>
		<a href='byond://?src=\ref[src];safety=1'><span id="safety_command">[weapons_safety ? "Dis" : "En"]able Safety</span></a>
		<br>
		<a href='byond://?src=\ref[src];invisibility=1'><span id="invisibility_command">[is_invisible ? "Dis" : "En"]able Invisibility</span></a>
		<br>
		</div>
		</div>
	"}
	. += ..()

/obj/mecha/combat/justice/handle_topic(mob/user, datum/topic_input/topic)
	. = ..()
	if(!.)
		return FALSE

	if(topic.has("safety"))
		do_safety()
		return

	if(topic.has("invisibility"))
		do_invisibility()
		return

/obj/mecha/combat/justice/verb/toggle_safety()
	set category = "Exosuit Interface"
	set name = "Toggle Safety"
	set popup_menu = FALSE
	set src = usr.loc

	if(usr != occupant)
		return
	if(isnull(occupant))
		return

	do_safety()

/obj/mecha/combat/justice/proc/do_safety()
	weapons_safety = !weapons_safety
	if(weapons_safety)
		move_delay = MOVE_DELAY_SAFETY
		spawn(1 SECOND)
			if(is_invisible)
				disable_invisibility(TRUE)
	else
		move_delay = MOVE_DELAY_ANGRY
	update_icon()

	playsound(src, 'sound/mecha/justice/blade_safety.ogg', 100, FALSE) // Everyone needs to hear this sound.
	balloon_alert(occupant, "[weapons_safety ? "en" : "dis"]abled safety")
	send_byjax(occupant, "exosuit.browser", "safety_command", "[weapons_safety ? "Dis" : "En"]able Safety")
	log_message("Toggled safety.")

/obj/mecha/combat/justice/verb/toggle_invisibility()
	set category = "Exosuit Interface"
	set name = "Toggle Invisibility"
	set popup_menu = FALSE
	set src = usr.loc

	if(usr != occupant)
		return
	if(isnull(occupant))
		return

	do_invisibility()

/obj/mecha/combat/justice/proc/do_invisibility()
	if(weapons_safety)
		balloon_alert(occupant, "safety is on!")
		return
	if(!has_charge(2000)) // This is akin to the force fields where they stop working below 2000 charge.
		disable_invisibility(TRUE)
		return

	if(is_invisible)
		disable_invisibility()
	else
		enable_invisibility()

/obj/mecha/combat/justice/proc/enable_invisibility()
	if(is_invisible)
		return
	make_sparks(1, TRUE, GET_TURF(src))
	playsound(src, 'sound/mecha/justice/stealth_effect.ogg', 100, FALSE)
	animate(src, alpha = 0, time = 0.5 SECONDS)
	step_sound_volume = 0
	turn_sound_volume = 0
	is_invisible = TRUE
	balloon_alert(occupant, "enabled invisibility")
	send_byjax(occupant, "exosuit.browser", "invisibility_command", "Disable Invisibility")
	log_message("Toggled invisibility.")

/obj/mecha/combat/justice/proc/disable_invisibility(failed = FALSE)
	if(!is_invisible)
		return
	make_sparks(1, TRUE, GET_TURF(src))
	playsound(src, 'sound/mecha/justice/stealth_effect.ogg', 100, FALSE)
	animate(src, alpha = 255, time = 0.5 SECONDS)
	step_sound_volume = initial(step_sound_volume)
	turn_sound_volume = initial(turn_sound_volume)
	is_invisible = FALSE
	balloon_alert(occupant, failed ? "invisibility failed" : "disabled invisibility")
	send_byjax(occupant, "exosuit.browser", "invisibility_command", "Enable Invisibility")
	log_message("Toggled invisibility.")

/obj/mecha/combat/justice/process()
	. = ..()
	if(!is_invisible)
		return
	if(world.time % 2 SECONDS != 0)
		return

	// Handles camouflage power drain.
	if(get_charge() >= invisibility_energy_drain)
		use_power(invisibility_energy_drain)
	else
		disable_invisibility(TRUE)

#undef MOVE_DELAY_SAFETY
#undef MOVE_DELAY_ANGRY