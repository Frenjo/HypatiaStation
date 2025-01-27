#define MECHA_INT_FIRE 1
#define MECHA_INT_TEMP_CONTROL 2
#define MECHA_INT_SHORT_CIRCUIT 4
#define MECHA_INT_TANK_BREACH 8
#define MECHA_INT_CONTROL_LOST 16

#define MELEE 1
#define RANGED 2


/obj/mecha
	name = "mecha"
	desc = "Exosuit"
	icon = 'icons/obj/mecha/mecha.dmi'
	layer = MOB_LAYER
	infra_luminosity = 15 // BYOND implementation is bugged.

	density = TRUE // Dense. To raise the heat.
	anchored = TRUE // No pulling around.
	unacidable = TRUE // And no deleting hoomans inside.

	var/initial_icon = null // Mech type for resetting icon. Only used for reskinning kits (see custom items)
	var/entry_direction = SOUTH // Which direction the exosuit faces when entered. I only recently realised some are entered from the back not the front!
	var/can_move = TRUE
	var/mob/living/carbon/occupant = null

	// Stats
	var/health = 300
	var/step_in = 10 // Makes a step every (step_in / 10) sec.
	var/step_energy_drain = 10
	var/max_temperature = 25000
	var/deflect_chance = 10 // Chance to deflect incoming projectiles, hits, or lesser the effect of ex_act.
	// The values in this list show how much damage will pass through, not how much will be absorbed.
	var/list/damage_absorption = list("brute" = 0.8, "fire" = 1.2, "bullet" = 0.9, "laser" = 1, "energy" = 1, "bomb" = 1)
	var/internal_damage_threshold = 50 // Health percentage below which internal damage is possible.
	var/internal_damage = 0 // Contains bitflags.

	// Sounds
	var/step_sound = 'sound/mecha/mechstep.ogg'
	var/step_sound_volume = 40
	var/turn_sound = 'sound/mecha/mechturn.ogg'
	var/turn_sound_volume = 40

	// Access
	var/list/operation_req_access = list() // Required access level for mecha operation.
	var/list/internals_req_access = list(ACCESS_ENGINE, ACCESS_ROBOTICS) // Required access level to open cell compartment.
	var/add_req_access = TRUE
	var/maint_access = TRUE

	var/state = 0
	var/list/log = list()
	var/last_message = 0
	var/dna	//dna-locking the mech
	var/list/proc_res = list() //stores proc owners, like proc_res["functionname"] = owner reference
	var/datum/effect/system/spark_spread/spark_system = new /datum/effect/system/spark_spread()

	// Lights
	var/lights = FALSE
	var/lights_power = 6

	//inner atmos
	var/use_internal_tank = 0
	var/internal_tank_valve = ONE_ATMOSPHERE
	var/obj/machinery/portable_atmospherics/canister/internal_tank
	var/datum/gas_mixture/cabin_air
	var/obj/machinery/atmospherics/unary/portables_connector/connected_port = null

	var/obj/item/radio/radio = null

	var/datum/global_iterator/pr_int_temp_processor //normalizes internal air mixture temperature
	var/datum/global_iterator/pr_inertial_movement //controls inertial movement in spesss
	var/datum/global_iterator/pr_give_air //moves air from tank to cabin
	var/datum/global_iterator/pr_internal_damage //processes internal damage

	var/wreckage

	// Equipment
	var/obj/item/cell/cell
	var/list/excluded_equipment = list() // A list of equipment typepaths this exosuit CANNOT equip.
	var/list/obj/item/mecha_part/equipment/equipment = list()
	var/obj/item/mecha_part/equipment/selected
	var/max_equip = 3

	var/datum/events/events

/obj/mecha/New()
	. = ..()
	events = new /datum/events()
	icon_state += "-open"
	add_radio()
	add_cabin()
	if(!add_airtank()) //we check this here in case mecha does not have an internal tank available by default - WIP
		verbs.Remove(/obj/mecha/verb/connect_to_port)
		verbs.Remove(/obj/mecha/verb/toggle_internal_tank)
	spark_system.set_up(2, 0, src)
	spark_system.attach(src)
	add_cell()
	add_iterators()
	verbs.Remove(/obj/mecha/verb/disconnect_from_port)
	verbs.Remove(/atom/movable/verb/pull)
	log_message("[name] created.")
	loc.Entered(src)
	GLOBL.mechas_list.Add(src) //global mech list

/obj/mecha/Destroy()
	go_out()
	remove_iterators()
	var/turf/T = GET_TURF(src)
	tag = "\ref[src]" //better safe then sorry
	if(isnotnull(loc))
		loc.Exited(src)
		loc = null
	if(isnotnull(T))
		if(prob(30))
			explosion(T, 0, 0, 1, 3)

		if(isnull(wreckage))
			for_no_type_check(var/obj/item/mecha_part/equipment/equip, equipment)
				equip.forceMove(T)
				qdel(equip)
		else
			var/obj/structure/mecha_wreckage/wreck = new wreckage(T)
			for_no_type_check(var/obj/item/mecha_part/equipment/equip, equipment)
				if(equip.salvageable && prob(30))
					wreck.crowbar_salvage.Add(equip)
					equip.forceMove(wreck)
					equip.equip_ready = TRUE
					equip.reliability = round(rand(equip.reliability / 3, equip.reliability))
				else
					equip.forceMove(T)
					qdel(equip)
			if(isnotnull(cell))
				wreck.crowbar_salvage.Add(cell)
				cell.forceMove(wreck)
				cell.charge = rand(0, cell.charge)
			if(isnotnull(internal_tank))
				wreck.crowbar_salvage.Add(internal_tank)
				internal_tank.forceMove(wreck)
	QDEL_NULL(radio)
	cell = null
	QDEL_NULL(events)
	GLOBL.mechas_list.Remove(src) //global mech list
	return ..()

/obj/mecha/proc/reset_icon()
	if(isnotnull(initial_icon))
		icon_state = initial_icon
	else
		icon_state = initial(icon_state)
	return icon_state

////////////////////////////
///// Action processing ////
////////////////////////////
/*
/atom/DblClick(object,location,control,params)
	var/mob/M = src.mob
	if(M && M.in_contents_of(/obj/mecha))

		if(mech_click == world.time) return
		mech_click = world.time

		if(!isatom(object))
			return
		if(istype(object, /atom/movable/screen))
			var/atom/movable/screen/using = object
			if(using.screen_loc == ui_acti || using.screen_loc == ui_iarrowleft || using.screen_loc == ui_iarrowright)//ignore all HUD objects save 'intent' and its arrows
				return ..()
			else
				return
		var/obj/mecha/Mech = M.loc
		spawn() //this helps prevent clickspam fest.
			if (Mech)
				Mech.click_action(object,M)
//	else
//		return ..()
*/

/obj/mecha/proc/click_action(atom/target, mob/user)
	if(!src.occupant || src.occupant != user)
		return
	if(user.stat)
		return
	if(state)
		occupant_message("<font color='red'>Maintenance protocols in effect</font>")
		return
	if(!get_charge())
		return
	if(src == target)
		return

	var/dir_to_target = get_dir(src, target)
	if(dir_to_target && !(dir_to_target & src.dir))//wrong direction
		return
	if(internal_damage & MECHA_INT_CONTROL_LOST)
		target = safepick(view(3, target))
		if(!target)
			return
	if(!target.Adjacent(src))
		if(selected && selected.is_ranged())
			selected.action(target)
	else if(selected && selected.is_melee())
		selected.action(target)
	else
		src.melee_action(target)
	return

/obj/mecha/proc/melee_action(atom/target)
	return

/obj/mecha/proc/range_action(atom/target)
	return

/////////////////////////////////////
////////  Atmospheric stuff  ////////
/////////////////////////////////////

/obj/mecha/proc/get_turf_air()
	var/turf/T = GET_TURF(src)
	. = T?.return_air()

/obj/mecha/remove_air(amount)
	if(use_internal_tank)
		return cabin_air.remove(amount)
	else
		var/turf/T = GET_TURF(src)
		if(isnotnull(T))
			return T.remove_air(amount)
	return

/obj/mecha/return_air()
	if(use_internal_tank)
		return cabin_air
	return get_turf_air()

/obj/mecha/proc/return_pressure()
	. = 0
	if(use_internal_tank)
		. = cabin_air.return_pressure()
	else
		var/datum/gas_mixture/t_air = get_turf_air()
		if(isnotnull(t_air))
			. = t_air.return_pressure()

//skytodo: //No idea what you want me to do here, mate.
/obj/mecha/proc/return_temperature()
	. = 0
	if(use_internal_tank)
		. = cabin_air.temperature
	else
		var/datum/gas_mixture/t_air = get_turf_air()
		if(isnotnull(t_air))
			. = t_air.temperature

/obj/mecha/proc/connect(obj/machinery/atmospherics/unary/portables_connector/new_port)
	//Make sure not already connected to something else
	if(isnotnull(connected_port) || isnull(new_port) || new_port.connected_device)
		return FALSE

	//Make sure are close enough for a valid connection
	if(new_port.loc != loc)
		return FALSE

	//Perform the connection
	connected_port = new_port
	connected_port.connected_device = src

	//Actually enforce the air sharing
	var/datum/pipe_network/network = connected_port.return_network(src)
	if(isnotnull(network) && !(internal_tank.return_air() in network.gases))
		network.gases.Add(internal_tank.return_air())
		network.update = 1
	log_message("Connected to gas port.")
	return TRUE

/obj/mecha/proc/disconnect()
	if(isnull(connected_port))
		return FALSE

	var/datum/pipe_network/network = connected_port.return_network(src)
	network?.gases.Remove(internal_tank.return_air())

	connected_port.connected_device = null
	connected_port = null
	log_message("Disconnected from gas port.")
	return TRUE

/////////////////////////
////// Access stuff /////
/////////////////////////

/obj/mecha/proc/operation_allowed(mob/living/carbon/human/H)
	for(var/ID in list(H.get_active_hand(), H.id_store, H.belt))
		if(check_access(ID, operation_req_access))
			return TRUE
	return FALSE

/obj/mecha/proc/internals_access_allowed(mob/living/carbon/human/H)
	for(var/atom/ID in list(H.get_active_hand(), H.id_store, H.belt))
		if(check_access(ID, internals_req_access))
			return TRUE
	return FALSE

/obj/mecha/check_access(obj/item/card/id/I, list/access_list)
	if(!istype(access_list))
		return 1
	if(!length(access_list)) //no requirements
		return 1
	if(istype(I, /obj/item/pda))
		var/obj/item/pda/pda = I
		I = pda.id
	if(!istype(I) || !I.access) //not ID or no access
		return 0
	if(access_list == src.operation_req_access)
		for(var/req in access_list)
			if(!(req in I.access)) //doesn't have this access
				return 0
	else if(access_list == src.internals_req_access)
		for(var/req in access_list)
			if(req in I.access)
				return 1
	return 1

////////////////////////////////
/////// Messages and Log ///////
////////////////////////////////

/obj/mecha/proc/occupant_message(message as text)
	if(message)
		if(src.occupant && src.occupant.client)
			src.occupant << "\icon[src] [message]"
	return

/obj/mecha/proc/log_message(message as text, red = null)
	log.len++
	log[length(log)] = list("time" = world.timeofday, "message" = "[red ? "<font color='red'>" : null][message][red ? "</font>" : null]")
	return length(log)

/obj/mecha/proc/log_append_to_last(message as text, red = null)
	var/list/last_entry = src.log[length(log)]
	last_entry["message"] += "<br>[red ? "<font color='red'>" : null][message][red ? "</font>" : null]"
	return

/////////////

//debug
/*
/obj/mecha/verb/test_int_damage()
	set name = "Test internal damage"
	set category = "Exosuit Interface"
	set src in view(0)
	if(!occupant) return
	if(usr!=occupant)
		return
	var/output = {"<html>
						<head>
						</head>
						<body>
						<h3>Set:</h3>
						<a href='byond://?src=\ref[src];debug=1;set_i_dam=[MECHA_INT_FIRE]'>MECHA_INT_FIRE</a><br />
						<a href='byond://?src=\ref[src];debug=1;set_i_dam=[MECHA_INT_TEMP_CONTROL]'>MECHA_INT_TEMP_CONTROL</a><br />
						<a href='byond://?src=\ref[src];debug=1;set_i_dam=[MECHA_INT_SHORT_CIRCUIT]'>MECHA_INT_SHORT_CIRCUIT</a><br />
						<a href='byond://?src=\ref[src];debug=1;set_i_dam=[MECHA_INT_TANK_BREACH]'>MECHA_INT_TANK_BREACH</a><br />
						<a href='byond://?src=\ref[src];debug=1;set_i_dam=[MECHA_INT_CONTROL_LOST]'>MECHA_INT_CONTROL_LOST</a><br />
						<hr />
						<h3>Clear:</h3>
						<a href='byond://?src=\ref[src];debug=1;clear_i_dam=[MECHA_INT_FIRE]'>MECHA_INT_FIRE</a><br />
						<a href='byond://?src=\ref[src];debug=1;clear_i_dam=[MECHA_INT_TEMP_CONTROL]'>MECHA_INT_TEMP_CONTROL</a><br />
						<a href='byond://?src=\ref[src];debug=1;clear_i_dam=[MECHA_INT_SHORT_CIRCUIT]'>MECHA_INT_SHORT_CIRCUIT</a><br />
						<a href='byond://?src=\ref[src];debug=1;clear_i_dam=[MECHA_INT_TANK_BREACH]'>MECHA_INT_TANK_BREACH</a><br />
						<a href='byond://?src=\ref[src];debug=1;clear_i_dam=[MECHA_INT_CONTROL_LOST]'>MECHA_INT_CONTROL_LOST</a><br />
 					   </body>
						</html>"}

	occupant << browse(output, "window=ex_debug")
	//src.health = initial(src.health)/2.2
	//src.check_for_internal_damage(list(MECHA_INT_FIRE,MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
	return
*/
