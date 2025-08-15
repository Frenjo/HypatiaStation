/obj/mecha/combat/reticence
	name = "\improper Reticence"
	desc = "A silent and fast miming exosuit with limited stealth capability. Popular among mimes and mime assassins."
	icon_state = "reticence"
	infra_luminosity = 5

	step_sound = null
	turn_sound = null

	health = 140
	move_delay = 0.3 SECONDS
	deflect_chance = 60
	damage_resistance = list("brute" = 0, "fire" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0)
	internal_damage_threshold = 60

	operation_req_access = list(ACCESS_MIME)
	add_req_access = FALSE

	mecha_type = MECHA_TYPE_RETICENCE
	excluded_equipment = list(
		/obj/item/mecha_equipment/melee_armour_booster,
		/obj/item/mecha_equipment/melee_defence_shocker,
		/obj/item/mecha_equipment/ranged_armour_booster,
		/obj/item/mecha_equipment/emp_insulation
	)

	wreckage = /obj/structure/mecha_wreckage/reticence

	var/is_stealthed = FALSE
	var/stealth_energy_drain = 100

/obj/mecha/combat/reticence/go_out()
	if(is_stealthed)
		disable_stealth()
	. = ..()

/obj/mecha/combat/reticence/melee_action(target)
	if(!melee_can_hit)
		return

	if(ismob(target))
		step_away(target, src, 15)

/obj/mecha/combat/reticence/get_stats_part()
	. = ..()
	. += "<b>Stealth: [is_stealthed ? "enabled" : "disabled"]</b>"

/obj/mecha/combat/reticence/get_commands()
	. = {"<div class='wr'>
		<div class='header'>Special</div>
		<div class='links'>
		<a href='byond://?src=\ref[src];stealth=1'><span id="stealth_command">[is_stealthed ? "Dis" : "En"]able Stealth</span></a>
		<br>
		</div>
		</div>
	"}
	. += ..()

/obj/mecha/combat/reticence/handle_topic(mob/user, datum/topic_input/topic)
	. = ..()
	if(!.)
		return FALSE

	if(topic.has("stealth"))
		do_stealth()
		return

/obj/mecha/combat/reticence/verb/toggle_stealth()
	set category = "Exosuit Interface"
	set name = "Toggle Stealth"
	set popup_menu = FALSE
	set src = usr.loc

	if(usr != occupant)
		return
	if(isnull(occupant))
		return

	do_stealth()

/obj/mecha/combat/reticence/proc/do_stealth()
	if(!has_charge(2000)) // This is akin to the force fields where they stop working below 2000 charge.
		disable_stealth(TRUE)
		return

	if(is_stealthed)
		disable_stealth()
	else
		enable_stealth()

/obj/mecha/combat/reticence/proc/enable_stealth()
	if(is_stealthed)
		return
	animate(src, alpha = 21, color = "#878787", time = 1 SECOND)
	is_stealthed = TRUE
	balloon_alert(occupant, "enabled stealth")
	send_byjax(occupant, "exosuit.browser", "stealth_command", "Disable Stealth")
	log_message("Toggled stealth.")

/obj/mecha/combat/reticence/proc/disable_stealth(failed = FALSE)
	if(!is_stealthed)
		return
	animate(src, alpha = 255, color = initial(color), time = 1 SECOND)
	is_stealthed = FALSE
	balloon_alert(occupant, failed ? "stealth failed" : "disabled stealth")
	send_byjax(occupant, "exosuit.browser", "stealth_command", "Enable Stealth")
	log_message("Toggled stealth.")

/obj/mecha/combat/reticence/process()
	. = ..()
	if(!is_stealthed)
		return
	if(world.time % 2 SECONDS != 0)
		return

	// Handles stealth power drain.
	if(get_charge() >= stealth_energy_drain)
		use_power(stealth_energy_drain)
	else
		disable_stealth(TRUE)