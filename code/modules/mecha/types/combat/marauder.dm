// Marauder
/obj/mecha/combat/marauder
	name = "\improper Marauder"
	desc = "Heavy-duty, combat exosuit, developed after the Durand model. Rarely found among civilian populations."
	icon_state = "marauder"
	infra_luminosity = 3

	force = 45

	health = 500
	step_in = 5
	max_temperature = 60000
	deflect_chance = 25
	damage_absorption = list("brute" = 0.5, "fire" = 0.7, "bullet" = 0.45, "laser" = 0.6, "energy" = 0.7, "bomb" = 0.7)
	internal_damage_threshold = 25

	operation_req_access = list(ACCESS_CENT_SPECOPS)
	add_req_access = FALSE

	max_equip = 4
	mecha_flag = MECHA_FLAG_MARAUDER

	wreckage = /obj/structure/mecha_wreckage/marauder

	var/zoom = 0
	var/thrusters = 0
	var/smoke = 5
	var/smoke_ready = TRUE
	var/smoke_cooldown = 100
	var/datum/effect/system/smoke_spread/smoke_system

/obj/mecha/combat/marauder/New()
	. = ..()
	smoke_system = new /datum/effect/system/smoke_spread(src)
	smoke_system.set_up(3, 0, src)
	smoke_system.attach(src)

/obj/mecha/combat/marauder/Destroy()
	QDEL_NULL(smoke_system)
	return ..()

/obj/mecha/combat/marauder/relaymove(mob/user, direction)
	if(user != occupant) //While not "realistic", this piece is player friendly.
		user.forceMove(GET_TURF(src))
		to_chat(user, SPAN_INFO("You climb out from \the [src]."))
		return 0
	if(!can_move)
		return 0
	if(zoom)
		if(world.time - last_message > 20)
			occupant_message(SPAN_WARNING("Unable to move while in zoom mode."))
			last_message = world.time
		return 0
	if(connected_port)
		if(world.time - last_message > 20)
			occupant_message(SPAN_WARNING("Unable to move while connected to the air system port."))
			last_message = world.time
		return 0
	if(!thrusters && pr_inertial_movement.active())
		return 0
	if(state || !has_charge(step_energy_drain))
		return 0
	var/tmp_step_in = step_in
	var/tmp_step_energy_drain = step_energy_drain
	var/move_result = 0
	if(internal_damage & MECHA_INT_CONTROL_LOST)
		move_result = mechsteprand()
	else if(dir != direction)
		move_result = mechturn(direction)
	else
		move_result	= mechstep(direction)
	if(move_result)
		if(isspace(loc))
			if(!check_for_support())
				pr_inertial_movement.start(list(src, direction))
				if(thrusters)
					pr_inertial_movement.set_process_args(list(src, direction))
					tmp_step_energy_drain = step_energy_drain * 2

		can_move = FALSE
		spawn(tmp_step_in)
			can_move = TRUE
		use_power(tmp_step_energy_drain)
		return 1
	return 0

/obj/mecha/combat/marauder/verb/toggle_thrusters()
	set category = "Exosuit Interface"
	set name = "Toggle Thrusters"
	set popup_menu = FALSE
	set src = usr.loc

	if(usr != occupant)
		return
	if(isnull(occupant))
		return

	if(get_charge() > 0)
		thrusters = !thrusters
		balloon_alert(occupant, "[thrusters ? "en" : "dis"]abled thrusters")
		send_byjax(occupant, "exosuit.browser", "thrusters_command", "[thrusters ? "Dis" : "En"]able Thrusters")
		log_message("Toggled thrusters.")

/obj/mecha/combat/marauder/verb/smoke()
	set category = "Exosuit Interface"
	set name = "Smoke"
	set popup_menu = FALSE
	set src = usr.loc

	if(usr != occupant)
		return

	if(smoke_ready && smoke > 0)
		smoke_system.start()
		smoke--
		smoke_ready = FALSE
		spawn(smoke_cooldown)
			smoke_ready = TRUE

/obj/mecha/combat/marauder/verb/zoom()
	set category = "Exosuit Interface"
	set name = "Zoom"
	set popup_menu = FALSE
	set src = usr.loc

	if(usr != occupant)
		return
	if(isnull(occupant?.client))
		return

	zoom = !zoom
	balloon_alert(occupant, "[zoom ? "en" : "dis"]abled zoom mode")
	send_byjax(occupant, "exosuit.browser", "zoom_command", "[zoom ? "Dis" : "En"]able Zoom Mode")
	log_message("Toggled zoom mode.")
	if(zoom)
		occupant.client.view = 12
		occupant << sound('sound/mecha/voice/image_enh.ogg', volume = 50)
	else
		occupant.client.view = world.view//world.view - default mob view size

/obj/mecha/combat/marauder/go_out()
	if(isnotnull(occupant?.client))
		occupant.client.view = world.view
		zoom = 0
	. = ..()

/obj/mecha/combat/marauder/get_stats_part()
	. = ..()
	. += {"<b>Thrusters:</b> [thrusters ? "enabled" : "disabled"]
		<br>
		<b>Smoke:</b> [smoke]
	"}

/obj/mecha/combat/marauder/get_commands()
	. = {"<div class='wr'>
		<div class='header'>Special</div>
		<div class='links'>
		<a href='byond://?src=\ref[src];thrusters=1'><span id="thrusters_command">[thrusters ? "Dis" : "En"]able Thrusters</span></a><br>
		<a href='byond://?src=\ref[src];zoom=1'><span id="zoom_command">[zoom ? "Dis" : "En"]able Zoom Mode</span></a><br>
		<a href='byond://?src=\ref[src];smoke=1'>Smoke</a>
		</div>
		</div>
	"}
	. += ..()

/obj/mecha/combat/marauder/Topic(href, href_list)
	. = ..()
	if(href_list["thrusters"])
		toggle_thrusters()
	if(href_list["zoom"])
		zoom()
	if(href_list["smoke"])
		smoke()

/obj/mecha/combat/marauder/add_cell(obj/item/cell/C = null)
	if(isnotnull(C))
		C.forceMove(src)
		cell = C
		return
	cell = new /obj/item/cell/hyper(src)

// Equipped variant
/obj/mecha/combat/marauder/equipped
	starts_with = list(
		/obj/item/mecha_equipment/weapon/energy/pulse, /obj/item/mecha_equipment/weapon/ballistic/launcher/missile_rack,
		/obj/item/mecha_equipment/tesla_energy_relay, /obj/item/mecha_equipment/ranged_armour_booster
	)

// Seraph
/obj/mecha/combat/marauder/seraph
	name = "\improper Seraph"
	desc = "Heavy-duty, command-type exosuit. This is a custom model, utilized only by high-ranking military personnel."
	icon_state = "seraph"

	force = 55

	step_in = 3
	health = 550
	internal_damage_threshold = 20

	operation_req_access = list(ACCESS_CENT_CREED)

	max_equip = 5

	wreckage = /obj/structure/mecha_wreckage/seraph

// Equipped variant
/obj/mecha/combat/marauder/seraph/equipped
	starts_with = list(
		/obj/item/mecha_equipment/weapon/ballistic/scattershot, /obj/item/mecha_equipment/weapon/ballistic/launcher/missile_rack,
		/obj/item/mecha_equipment/teleporter, /obj/item/mecha_equipment/tesla_energy_relay, /obj/item/mecha_equipment/ranged_armour_booster
	)

// Mauler
/obj/mecha/combat/marauder/mauler
	name = "\improper Mauler"
	desc = "Heavy-duty, combat exosuit, developed off of the existing Marauder model."
	icon_state = "mauler"

	operation_req_access = list(ACCESS_SYNDICATE)

	wreckage = /obj/structure/mecha_wreckage/mauler

// Equipped variant
/obj/mecha/combat/marauder/mauler/equipped
	starts_with = list(
		/obj/item/mecha_equipment/weapon/energy/pulse, /obj/item/mecha_equipment/weapon/ballistic/launcher/missile_rack,
		/obj/item/mecha_equipment/tesla_energy_relay, /obj/item/mecha_equipment/ranged_armour_booster
	)