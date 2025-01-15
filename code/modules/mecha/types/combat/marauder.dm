/obj/mecha/combat/marauder
	name = "\improper Marauder"
	desc = "Heavy-duty, combat exosuit, developed after the Durand model. Rarely found among civilian populations."
	icon_state = "marauder"
	infra_luminosity = 3
	initial_icon = "marauder"

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

	wreckage = /obj/structure/mecha_wreckage/marauder

	var/zoom = 0
	var/thrusters = 0
	var/smoke = 5
	var/smoke_ready = TRUE
	var/smoke_cooldown = 100
	var/datum/effect/system/smoke_spread/smoke_system

/obj/mecha/combat/marauder/New()
	. = ..()
	var/obj/item/mecha_part/equipment/ME = new /obj/item/mecha_part/equipment/weapon/energy/pulse(src)
	ME.attach(src)
	ME = new /obj/item/mecha_part/equipment/weapon/ballistic/launcher/missile_rack(src)
	ME.attach(src)
	ME = new /obj/item/mecha_part/equipment/tesla_energy_relay(src)
	ME.attach(src)
	ME = new /obj/item/mecha_part/equipment/ranged_armour_booster(src)
	ME.attach(src)
	smoke_system = new /datum/effect/system/smoke_spread(src)
	smoke_system.set_up(3, 0, src)
	smoke_system.attach(src)

/obj/mecha/combat/marauder/relaymove(mob/user, direction)
	if(user != occupant) //While not "realistic", this piece is player friendly.
		user.loc = GET_TURF(src)
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
		log_message("Toggled thrusters.")
		occupant_message(SPAN(thrusters ? "info" : "warning", "Thrusters [thrusters ? "en" : "dis"]abled."))

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
	log_message("Toggled zoom mode.")
	occupant_message(SPAN(zoom ? "info" : "warning", "Zoom mode [zoom ? "en" : "dis"]abled."))
	if(zoom)
		occupant.client.view = 12
		occupant << sound('sound/mecha/imag_enh.ogg', volume = 50)
	else
		occupant.client.view = world.view//world.view - default mob view size

/obj/mecha/combat/marauder/go_out()
	if(isnotnull(occupant?.client))
		occupant.client.view = world.view
		zoom = 0
	. = ..()

/obj/mecha/combat/marauder/get_stats_part()
	. = ..()
	. += {"<b>Smoke:</b> [smoke]
					<br>
					<b>Thrusters:</b> [thrusters?"on":"off"]
					"}

/obj/mecha/combat/marauder/get_commands()
	. = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='byond://?src=\ref[src];toggle_thrusters=1'>Toggle thrusters</a><br>
						<a href='byond://?src=\ref[src];toggle_zoom=1'>Toggle zoom mode</a><br>
						<a href='byond://?src=\ref[src];smoke=1'>Smoke</a>
						</div>
						</div>
						"}
	. += ..()

/obj/mecha/combat/marauder/Topic(href, href_list)
	. = ..()
	if(href_list["toggle_thrusters"])
		toggle_thrusters()
	if(href_list["smoke"])
		smoke()
	if(href_list["toggle_zoom"])
		zoom()

/obj/mecha/combat/marauder/add_cell(obj/item/cell/C = null)
	if(isnotnull(C))
		C.forceMove(src)
		cell = C
		return
	cell = new /obj/item/cell/hyper(src)

/obj/mecha/combat/marauder/seraph
	name = "\improper Seraph"
	desc = "Heavy-duty, command-type exosuit. This is a custom model, utilized only by high-ranking military personnel."
	icon_state = "seraph"

	initial_icon = "seraph"
	operation_req_access = list(ACCESS_CENT_CREED)
	step_in = 3
	health = 550
	wreckage = /obj/structure/mecha_wreckage/seraph
	internal_damage_threshold = 20
	force = 55
	max_equip = 5

/obj/mecha/combat/marauder/seraph/New()
	. = ..()//Let it equip whatever is needed.
	var/obj/item/mecha_part/equipment/ME
	if(length(equipment))//Now to remove it and equip anew.
		for(ME in equipment)
			equipment -= ME
			qdel(ME)
	ME = new /obj/item/mecha_part/equipment/weapon/ballistic/scattershot(src)
	ME.attach(src)
	ME = new /obj/item/mecha_part/equipment/weapon/ballistic/launcher/missile_rack(src)
	ME.attach(src)
	ME = new /obj/item/mecha_part/equipment/teleporter(src)
	ME.attach(src)
	ME = new /obj/item/mecha_part/equipment/tesla_energy_relay(src)
	ME.attach(src)
	ME = new /obj/item/mecha_part/equipment/ranged_armour_booster(src)
	ME.attach(src)

/obj/mecha/combat/marauder/mauler
	name = "\improper Mauler"
	desc = "Heavy-duty, combat exosuit, developed off of the existing Marauder model."
	icon_state = "mauler"

	initial_icon = "mauler"
	operation_req_access = list(ACCESS_SYNDICATE)
	wreckage = /obj/structure/mecha_wreckage/mauler