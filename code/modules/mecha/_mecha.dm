#define MECHA_INT_FIRE 1
#define MECHA_INT_TEMP_CONTROL 2
#define MECHA_INT_SHORT_CIRCUIT 4
#define MECHA_INT_TANK_BREACH 8
#define MECHA_INT_CONTROL_LOST 16

#define MELEE 1
#define RANGED 2

// Changed all the mecha code 'filter' to 'new_filter' because
// Filter somehow became a reserved proc/makes BYOND confused
// -Frenjo


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
	var/list/equipment = list()
	var/obj/item/mecha_part/equipment/selected
	var/max_equip = 3

	// Actuator Overload
	var/overload_capable = FALSE
	var/overload = FALSE
	var/overload_coeff = 2

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
	if(!overload_capable)
		verbs.Remove(/obj/mecha/verb/overload)
	log_message("[src.name] created.")
	loc.Entered(src)
	GLOBL.mechas_list.Add(src) //global mech list

/obj/mecha/Destroy()
	go_out()
	GLOBL.mechas_list.Remove(src) //global mech list
	return ..()

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
	if(hasInternalDamage(MECHA_INT_CONTROL_LOST))
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

///////////////////////////////////
////////  Internal damage  ////////
///////////////////////////////////

/obj/mecha/proc/check_for_internal_damage(list/possible_int_damage, ignore_threshold = null)
	if(!islist(possible_int_damage) || isemptylist(possible_int_damage))
		return
	if(prob(20))
		if(ignore_threshold || src.health * 100 / initial(src.health) < src.internal_damage_threshold)
			for(var/T in possible_int_damage)
				if(internal_damage & T)
					possible_int_damage -= T
			var/int_dam_flag = safepick(possible_int_damage)
			if(int_dam_flag)
				setInternalDamage(int_dam_flag)
	if(prob(5))
		if(ignore_threshold || src.health * 100 / initial(src.health) < src.internal_damage_threshold)
			var/obj/item/mecha_part/equipment/destr = safepick(equipment)
			if(destr)
				destr.destroy()
	return

/obj/mecha/proc/hasInternalDamage(int_dam_flag = null)
	return int_dam_flag ? internal_damage&int_dam_flag : internal_damage

/obj/mecha/proc/setInternalDamage(int_dam_flag)
	internal_damage |= int_dam_flag
	pr_internal_damage.start()
	log_append_to_last("Internal damage of type [int_dam_flag].", 1)
	occupant << sound('sound/machines/warning-buzzer.ogg', wait = 0)
	return

/obj/mecha/proc/clearInternalDamage(int_dam_flag)
	internal_damage &= ~int_dam_flag
	switch(int_dam_flag)
		if(MECHA_INT_TEMP_CONTROL)
			occupant_message("<font color='blue'><b>Life support system reactivated.</b></font>")
			pr_int_temp_processor.start()
		if(MECHA_INT_FIRE)
			occupant_message("<font color='blue'><b>Internal fire extinquished.</b></font>")
		if(MECHA_INT_TANK_BREACH)
			occupant_message("<font color='blue'><b>Damaged internal tank has been sealed.</b></font>")
	return

////////////////////////////////////////
////////  Health related procs  ////////
////////////////////////////////////////

/obj/mecha/proc/take_damage(amount, type = "brute")
	if(amount)
		var/damage = absorbDamage(amount, type)
		health -= damage
		update_health()
		log_append_to_last("Took [damage] points of damage. Damage type: \"[type]\".",1)
	return

/obj/mecha/proc/absorbDamage(damage, damage_type)
	return call((proc_res["dynabsorbdamage"]||src), "dynabsorbdamage")(damage, damage_type)

/obj/mecha/proc/dynabsorbdamage(damage, damage_type)
	return damage*(listgetindex(damage_absorption, damage_type) || 1)

/obj/mecha/proc/update_health()
	if(src.health > 0)
		src.spark_system.start()
	else
		src.destroy()
	return

/obj/mecha/hitby(atom/movable/A) //wrapper
	src.log_message("Hit by [A].", 1)
	call((proc_res["dynhitby"]||src), "dynhitby")(A)
	return

/obj/mecha/proc/dynhitby(atom/movable/A)
	if(istype(A, /obj/item/mecha_part/tracking))
		A.forceMove(src)
		src.visible_message("The [A] fastens firmly to [src].")
		return
	if(prob(src.deflect_chance) || ismob(A))
		src.occupant_message("\blue The [A] bounces off the armor.")
		src.visible_message("The [A] bounces off the [src.name] armor")
		src.log_append_to_last("Armor saved.")
		if(isliving(A))
			var/mob/living/M = A
			M.take_organ_damage(10)
	else if(isobj(A))
		var/obj/O = A
		if(O.throwforce)
			src.take_damage(O.throwforce)
			src.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL, MECHA_INT_TANK_BREACH, MECHA_INT_CONTROL_LOST))
	return

/obj/mecha/bullet_act(var/obj/item/projectile/Proj) //wrapper
	src.log_message("Hit by projectile. Type: [Proj.name]([Proj.flag]).", 1)
	call((proc_res["dynbulletdamage"]||src), "dynbulletdamage")(Proj) //calls equipment
	..()
	return

/obj/mecha/proc/dynbulletdamage(var/obj/item/projectile/Proj)
	if(prob(src.deflect_chance))
		src.occupant_message("\blue The armor deflects incoming projectile.")
		src.visible_message("The [src.name] armor deflects the projectile")
		src.log_append_to_last("Armor saved.")
		return
	var/ignore_threshold
	if(Proj.flag == "taser")
		use_power(200)
		return
	if(istype(Proj, /obj/item/projectile/energy/beam/pulse))
		ignore_threshold = 1
	src.take_damage(Proj.damage,Proj.flag)
	src.check_for_internal_damage(list(MECHA_INT_FIRE, MECHA_INT_TEMP_CONTROL, MECHA_INT_TANK_BREACH, MECHA_INT_CONTROL_LOST, MECHA_INT_SHORT_CIRCUIT), ignore_threshold)
	Proj.on_hit(src)
	return

/obj/mecha/proc/destroy()
	spawn()
		go_out()
		var/turf/T = GET_TURF(src)
		tag = "\ref[src]" //better safe then sorry
		if(loc)
			loc.Exited(src)
		loc = null
		if(isnotnull(T))
			if(istype(src, /obj/mecha/working/ripley))
				var/obj/mecha/working/ripley/R = src
				if(R.cargo)
					for(var/obj/O in R.cargo) //Dump contents of stored cargo
						O.loc = T
						R.cargo -= O
						T.Entered(O)

			if(prob(30))
				explosion(T, 0, 0, 1, 3)
			spawn(0)
				if(wreckage)
					var/obj/structure/mecha_wreckage/WR = new wreckage(T)
					for(var/obj/item/mecha_part/equipment/E in equipment)
						if(E.salvageable && prob(30))
							WR.crowbar_salvage += E
							E.forceMove(WR)
							E.equip_ready = 1
							E.reliability = round(rand(E.reliability / 3, E.reliability))
						else
							E.forceMove(T)
							E.destroy()
					if(cell)
						WR.crowbar_salvage += cell
						cell.forceMove(WR)
						cell.charge = rand(0, cell.charge)
					if(internal_tank)
						WR.crowbar_salvage += internal_tank
						internal_tank.forceMove(WR)
				else
					for(var/obj/item/mecha_part/equipment/E in equipment)
						E.forceMove(T)
						E.destroy()
		spawn(0)
			qdel(src)
	return

/obj/mecha/ex_act(severity)
	src.log_message("Affected by explosion of severity: [severity].", 1)
	if(prob(src.deflect_chance))
		severity++
		src.log_append_to_last("Armor saved, changing severity to [severity].")
	switch(severity)
		if(1.0)
			src.destroy()
		if(2.0)
			if (prob(30))
				src.destroy()
			else
				src.take_damage(initial(src.health)/2)
				src.check_for_internal_damage(list(MECHA_INT_FIRE, MECHA_INT_TEMP_CONTROL, MECHA_INT_TANK_BREACH, MECHA_INT_CONTROL_LOST, MECHA_INT_SHORT_CIRCUIT), 1)
		if(3.0)
			if (prob(5))
				src.destroy()
			else
				src.take_damage(initial(src.health)/5)
				src.check_for_internal_damage(list(MECHA_INT_FIRE, MECHA_INT_TEMP_CONTROL, MECHA_INT_TANK_BREACH, MECHA_INT_CONTROL_LOST, MECHA_INT_SHORT_CIRCUIT), 1)
	return

/*Will fix later -Sieve
/obj/mecha/attack_blob(mob/user)
	src.log_message("Attack by blob. Attacker - [user].",1)
	if(!prob(src.deflect_chance))
		src.take_damage(6)
		src.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL,MECHA_INT_TANK_BREACH,MECHA_INT_CONTROL_LOST))
		playsound(src.loc, 'sound/effects/blobattack.ogg', 50, 1, -1)
		user << "\red You smash at the armored suit!"
		for (var/mob/V in viewers(src))
			if(V.client && !(V.blinded))
				V.show_message("\red The [user] smashes against [src.name]'s armor!", 1)
	else
		src.log_append_to_last("Armor saved.")
		playsound(src.loc, 'sound/effects/blobattack.ogg', 50, 1, -1)
		user << "\green Your attack had no effect!"
		src.occupant_message("\blue The [user]'s attack is stopped by the armor.")
		for (var/mob/V in viewers(src))
			if(V.client && !(V.blinded))
				V.show_message("\blue The [user] rebounds off the [src.name] armor!", 1)
	return
*/

//TODO
/obj/mecha/meteorhit()
	return ex_act(rand(1, 3))//should do for now

/obj/mecha/emp_act(severity)
	if(get_charge())
		use_power((cell.charge / 2) / severity)
		take_damage(50 / severity, "energy")
	src.log_message("EMP detected", 1)
	check_for_internal_damage(list(MECHA_INT_FIRE, MECHA_INT_TEMP_CONTROL, MECHA_INT_CONTROL_LOST, MECHA_INT_SHORT_CIRCUIT), 1)
	return

/obj/mecha/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > src.max_temperature)
		src.log_message("Exposed to dangerous temperature.", 1)
		src.take_damage(5, "fire")
		src.check_for_internal_damage(list(MECHA_INT_FIRE, MECHA_INT_TEMP_CONTROL))
	return

/obj/mecha/proc/dynattackby(obj/item/W, mob/user)
	src.log_message("Attacked by [W]. Attacker - [user]")
	if(prob(src.deflect_chance))
		user << "\red \The [W] bounces off [src.name]."
		src.log_append_to_last("Armor saved.")
/*
		for (var/mob/V in viewers(src))
			if(V.client && !(V.blinded))
				V.show_message("The [W] bounces off [src.name] armor.", 1)
*/
	else
		src.occupant_message("<font color='red'><b>[user] hits [src] with [W].</b></font>")
		user.visible_message("<font color='red'><b>[user] hits [src] with [W].</b></font>", "<font color='red'><b>You hit [src] with [W].</b></font>")
		src.take_damage(W.force, W.damtype)
		src.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL, MECHA_INT_TANK_BREACH, MECHA_INT_CONTROL_LOST))
	return

/////////////////////////////////////
////////  Atmospheric stuff  ////////
/////////////////////////////////////

/obj/mecha/proc/get_turf_air()
	var/turf/T = GET_TURF(src)
	if(isnotnull(T))
		. = T.return_air()

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
		. =  cabin_air.return_pressure()
	else
		var/datum/gas_mixture/t_air = get_turf_air()
		if(t_air)
			. = t_air.return_pressure()
	return

//skytodo: //No idea what you want me to do here, mate.
/obj/mecha/proc/return_temperature()
	. = 0
	if(use_internal_tank)
		. = cabin_air.temperature
	else
		var/datum/gas_mixture/t_air = get_turf_air()
		if(t_air)
			. = t_air.temperature
	return

/obj/mecha/proc/connect(obj/machinery/atmospherics/unary/portables_connector/new_port)
	//Make sure not already connected to something else
	if(connected_port || !new_port || new_port.connected_device)
		return 0

	//Make sure are close enough for a valid connection
	if(new_port.loc != src.loc)
		return 0

	//Perform the connection
	connected_port = new_port
	connected_port.connected_device = src

	//Actually enforce the air sharing
	var/datum/pipe_network/network = connected_port.return_network(src)
	if(network && !(internal_tank.return_air() in network.gases))
		network.gases += internal_tank.return_air()
		network.update = 1
	log_message("Connected to gas port.")
	return 1

/obj/mecha/proc/disconnect()
	if(!connected_port)
		return 0

	var/datum/pipe_network/network = connected_port.return_network(src)
	if(network)
		network.gases -= internal_tank.return_air()

	connected_port.connected_device = null
	connected_port = null
	src.log_message("Disconnected from gas port.")
	return 1

/////////////////////////
////// Access stuff /////
/////////////////////////

/obj/mecha/proc/operation_allowed(mob/living/carbon/human/H)
	for(var/ID in list(H.get_active_hand(), H.id_store, H.belt))
		if(src.check_access(ID, src.operation_req_access))
			return 1
	return 0


/obj/mecha/proc/internals_access_allowed(mob/living/carbon/human/H)
	for(var/atom/ID in list(H.get_active_hand(), H.id_store, H.belt))
		if(src.check_access(ID, src.internals_req_access))
			return 1
	return 0


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

/////////////////
///// Topic /////
/////////////////

/obj/mecha/Topic(href, href_list)
	..()
	if(href_list["update_content"])
		if(usr != src.occupant)	return
		send_byjax(src.occupant,"exosuit.browser", "content", src.get_stats_part())
		return
	if(href_list["close"])
		return
	if(usr.stat > 0)
		return
	var/datum/topic_input/new_filter = new /datum/topic_input(href, href_list)
	if(href_list["toggle_leg_overload"])
		overload()
	if(href_list["select_equip"])
		if(usr != src.occupant)
			return
		var/obj/item/mecha_part/equipment/equip = new_filter.getObj("select_equip")
		if(equip)
			src.selected = equip
			src.occupant_message("You switch to [equip]")
			src.visible_message("[src] raises [equip]")
			send_byjax(src.occupant,"exosuit.browser", "eq_list", src.get_equipment_list())
		return
	if(href_list["eject"])
		if(usr != src.occupant)
			return
		src.eject()
		return
	if(href_list["toggle_lights"])
		if(usr != src.occupant)
			return
		src.toggle_lights()
		return
	if(href_list["toggle_airtank"])
		if(usr != src.occupant)
			return
		src.toggle_internal_tank()
		return
	if(href_list["rmictoggle"])
		if(usr != src.occupant)
			return
		radio.broadcasting = !radio.broadcasting
		send_byjax(src.occupant, "exosuit.browser", "rmicstate", (radio.broadcasting ? "Engaged" : "Disengaged"))
		return
	if(href_list["rspktoggle"])
		if(usr != src.occupant)
			return
		radio.listening = !radio.listening
		send_byjax(src.occupant, "exosuit.browser", "rspkstate", (radio.listening ? "Engaged" : "Disengaged"))
		return
	if(href_list["rfreq"])
		if(usr != src.occupant)
			return
		var/new_frequency = (radio.frequency + new_filter.getNum("rfreq"))
		if(!radio.freerange || (radio.frequency < 1200 || radio.frequency > 1600))
			new_frequency = sanitize_frequency(new_frequency)
		radio.radio_connection = register_radio(radio, new_frequency, new_frequency, RADIO_CHAT)
		send_byjax(src.occupant, "exosuit.browser", "rfreq", "[format_frequency(radio.frequency)]")
		return
	if(href_list["port_disconnect"])
		if(usr != src.occupant)
			return
		src.disconnect_from_port()
		return
	if(href_list["port_connect"])
		if(usr != src.occupant)
			return
		src.connect_to_port()
		return
	if(href_list["view_log"])
		if(usr != src.occupant)
			return
		src.occupant << browse(src.get_log_html(), "window=exosuit_log")
		onclose(occupant, "exosuit_log")
		return
	if(href_list["change_name"])
		if(usr != src.occupant)
			return
		var/newname = strip_html_simple(input(occupant, "Choose new exosuit name", "Rename exosuit", initial(name)) as text, MAX_NAME_LEN)
		if(newname && trim(newname))
			name = newname
		else
			alert(occupant, "nope.avi")
		return
	if(href_list["toggle_id_upload"])
		if(usr != src.occupant)
			return
		add_req_access = !add_req_access
		send_byjax(src.occupant, "exosuit.browser", "t_id_upload", "[add_req_access ? "L" : "Unl"]ock ID upload panel")
		return
	if(href_list["toggle_maint_access"])
		if(usr != src.occupant)
			return
		if(state)
			occupant_message("<font color='red'>Maintenance protocols in effect</font>")
			return
		maint_access = !maint_access
		send_byjax(src.occupant, "exosuit.browser", "t_maint_access", "[maint_access ? "Forbid" : "Permit"] maintenance protocols")
		return
	if(href_list["req_access"] && add_req_access)
		if(!in_range(src, usr))
			return
		output_access_dialog(new_filter.getObj("id_card"), new_filter.getMob("user"))
		return
	if(href_list["maint_access"] && maint_access)
		if(!in_range(src, usr))
			return
		var/mob/user = new_filter.getMob("user")
		if(user)
			if(state == 0)
				state = 1
				user << "The securing bolts are now exposed."
			else if(state == 1)
				state = 0
				user << "The securing bolts are now hidden."
			output_maintenance_dialog(new_filter.getObj("id_card"), user)
		return
	if(href_list["set_internal_tank_valve"] && state >= 1)
		if(!in_range(src, usr))
			return
		var/mob/user = new_filter.getMob("user")
		if(user)
			var/new_pressure = input(user, "Input new output pressure", "Pressure setting", internal_tank_valve) as num
			if(new_pressure)
				internal_tank_valve = new_pressure
				user << "The internal pressure valve has been set to [internal_tank_valve]kPa."
	if(href_list["add_req_access"] && add_req_access && new_filter.getObj("id_card"))
		if(!in_range(src, usr))
			return
		operation_req_access += new_filter.getNum("add_req_access")
		output_access_dialog(new_filter.getObj("id_card"), new_filter.getMob("user"))
		return
	if(href_list["del_req_access"] && add_req_access && new_filter.getObj("id_card"))
		if(!in_range(src, usr))
			return
		operation_req_access -= new_filter.getNum("del_req_access")
		output_access_dialog(new_filter.getObj("id_card"), new_filter.getMob("user"))
		return
	if(href_list["finish_req_access"])
		if(!in_range(src, usr))
			return
		add_req_access = 0
		var/mob/user = new_filter.getMob("user")
		user << browse(null,"window=exosuit_add_access")
		return
	if(href_list["dna_lock"])
		if(usr != src.occupant)
			return
		if(isbrain(occupant))
			occupant_message("You are a brain. No.")
			return
		if(src.occupant)
			src.dna = src.occupant.dna.unique_enzymes
			src.occupant_message("You feel a prick as the needle takes your DNA sample.")
		return
	if(href_list["reset_dna"])
		if(usr != src.occupant)
			return
		src.dna = null
	if(href_list["repair_int_control_lost"])
		if(usr != src.occupant)
			return
		src.occupant_message("Recalibrating coordination system.")
		src.log_message("Recalibration of coordination system started.")
		var/T = src.loc
		if(delay_for(100))
			if(T == src.loc)
				src.clearInternalDamage(MECHA_INT_CONTROL_LOST)
				src.occupant_message("<font color='blue'>Recalibration successful.</font>")
				src.log_message("Recalibration of coordination system finished with 0 errors.")
			else
				src.occupant_message("<font color='red'>Recalibration failed.</font>")
				src.log_message("Recalibration of coordination system failed with 1 error.",1)

	//debug
	/*
	if(href_list["debug"])
		if(href_list["set_i_dam"])
			setInternalDamage(filter.getNum("set_i_dam"))
		if(href_list["clear_i_dam"])
			clearInternalDamage(filter.getNum("clear_i_dam"))
		return
	*/



/*

	if (href_list["ai_take_control"])
		var/mob/living/silicon/ai/AI = locate(href_list["ai_take_control"])
		var/duration = text2num(href_list["duration"])
		var/mob/living/silicon/ai/O = new /mob/living/silicon/ai(src)
		var/cur_occupant = src.occupant
		O.invisibility = 0
		O.canmove = TRUE
		O.name = AI.name
		O.real_name = AI.real_name
		O.anchored = TRUE
		O.aiRestorePowerRoutine = 0
		O.control_disabled = 1 // Can't control things remotely if you're stuck in a card!
		O.laws = AI.laws
		O.stat = AI.stat
		O.oxyloss = AI.getOxyLoss()
		O.fireloss = AI.getFireLoss()
		O.bruteloss = AI.getBruteLoss()
		O.toxloss = AI.toxloss
		O.updatehealth()
		src.occupant = O
		if(AI.mind)
			AI.mind.transfer_to(O)
		AI.name = "Inactive AI"
		AI.real_name = "Inactive AI"
		AI.icon_state = "ai-empty"
		spawn(duration)
			AI.name = O.name
			AI.real_name = O.real_name
			if(O.mind)
				O.mind.transfer_to(AI)
			AI.control_disabled = 0
			AI.laws = O.laws
			AI.oxyloss = O.getOxyLoss()
			AI.fireloss = O.getFireLoss()
			AI.bruteloss = O.getBruteLoss()
			AI.toxloss = O.toxloss
			AI.updatehealth()
			del(O)
			if (!AI.stat)
				AI.icon_state = "ai"
			else
				AI.icon_state = "ai-crash"
			src.occupant = cur_occupant
*/
	return

///////////////////////
///// Power stuff /////
///////////////////////

/obj/mecha/proc/has_charge(amount)
	return (get_charge()>=amount)

/obj/mecha/proc/get_charge()
	return call((proc_res["dyngetcharge"]||src), "dyngetcharge")()

/obj/mecha/proc/dyngetcharge()//returns null if no powercell, else returns cell.charge
	if(!src.cell)
		return
	return max(0, src.cell.charge)

/obj/mecha/proc/use_power(amount)
	return call((proc_res["dynusepower"]||src), "dynusepower")(amount)

/obj/mecha/proc/dynusepower(amount)
	if(get_charge())
		cell.use(amount)
		return 1
	return 0

/obj/mecha/proc/give_power(amount)
	if(isnotnull(get_charge()))
		cell.give(amount)
		return 1
	return 0

/obj/mecha/proc/reset_icon()
	if (initial_icon)
		icon_state = initial_icon
	else
		icon_state = initial(icon_state)
	return icon_state

//////////////////////////////////////////
////////  Mecha global iterators  ////////
//////////////////////////////////////////

/datum/global_iterator/mecha_preserve_temp  //normalizing cabin air temperature to 20 degrees celsium
	delay = 20

/datum/global_iterator/mecha_preserve_temp/process(obj/mecha/mecha)
	if(mecha.cabin_air && mecha.cabin_air.volume > 0)
		var/delta = mecha.cabin_air.temperature - T20C
		mecha.cabin_air.temperature -= max(-10, min(10, round(delta / 4, 0.1)))
	return

/datum/global_iterator/mecha_tank_give_air
	delay = 15

/datum/global_iterator/mecha_tank_give_air/process(obj/mecha/mecha)
	if(mecha.internal_tank)
		var/datum/gas_mixture/tank_air = mecha.internal_tank.return_air()
		var/datum/gas_mixture/cabin_air = mecha.cabin_air

		var/release_pressure = mecha.internal_tank_valve
		var/cabin_pressure = cabin_air.return_pressure()
		var/pressure_delta = min(release_pressure - cabin_pressure, (tank_air.return_pressure() - cabin_pressure) / 2)
		var/transfer_moles = 0
		if(pressure_delta > 0) //cabin pressure lower than release pressure
			if(tank_air.temperature > 0)
				transfer_moles = pressure_delta * cabin_air.volume / (cabin_air.temperature * R_IDEAL_GAS_EQUATION)
				var/datum/gas_mixture/removed = tank_air.remove(transfer_moles)
				cabin_air.merge(removed)
		else if(pressure_delta < 0) //cabin pressure higher than release pressure
			var/datum/gas_mixture/t_air = mecha.get_turf_air()
			pressure_delta = cabin_pressure - release_pressure
			if(t_air)
				pressure_delta = min(cabin_pressure - t_air.return_pressure(), pressure_delta)
			if(pressure_delta > 0) //if location pressure is lower than cabin pressure
				transfer_moles = pressure_delta * cabin_air.volume / (cabin_air.temperature * R_IDEAL_GAS_EQUATION)
				var/datum/gas_mixture/removed = cabin_air.remove(transfer_moles)
				if(t_air)
					t_air.merge(removed)
				else //just delete the cabin gas, we're in space or some shit
					qdel(removed)
	else
		return stop()
	return

/datum/global_iterator/mecha_inertial_movement //inertial movement in space
	delay = 7

/datum/global_iterator/mecha_inertial_movement/process(obj/mecha/mecha, direction)
	if(direction)
		if(!step(mecha, direction)||mecha.check_for_support())
			src.stop()
	else
		src.stop()
	return

/datum/global_iterator/mecha_internal_damage // processing internal damage

/datum/global_iterator/mecha_internal_damage/process(obj/mecha/mecha)
	if(!mecha.hasInternalDamage())
		return stop()
	if(mecha.hasInternalDamage(MECHA_INT_FIRE))
		if(!mecha.hasInternalDamage(MECHA_INT_TEMP_CONTROL) && prob(5))
			mecha.clearInternalDamage(MECHA_INT_FIRE)
		if(mecha.internal_tank)
			if(mecha.internal_tank.return_pressure()>mecha.internal_tank.maximum_pressure && !(mecha.hasInternalDamage(MECHA_INT_TANK_BREACH)))
				mecha.setInternalDamage(MECHA_INT_TANK_BREACH)
			var/datum/gas_mixture/int_tank_air = mecha.internal_tank.return_air()
			if(int_tank_air && int_tank_air.volume > 0) //heat the air_contents
				int_tank_air.temperature = min(6000 + T0C, int_tank_air.temperature + rand(10, 15))
		if(mecha.cabin_air && mecha.cabin_air.volume>0)
			mecha.cabin_air.temperature = min(6000 + T0C, mecha.cabin_air.temperature + rand(10, 15))
			if(mecha.cabin_air.temperature>mecha.max_temperature / 2)
				mecha.take_damage(4 / round(mecha.max_temperature / mecha.cabin_air.temperature, 0.1), "fire")
	if(mecha.hasInternalDamage(MECHA_INT_TEMP_CONTROL)) //stop the mecha_preserve_temp loop datum
		mecha.pr_int_temp_processor.stop()
	if(mecha.hasInternalDamage(MECHA_INT_TANK_BREACH)) //remove some air from internal tank
		if(mecha.internal_tank)
			var/datum/gas_mixture/int_tank_air = mecha.internal_tank.return_air()
			var/datum/gas_mixture/leaked_gas = int_tank_air.remove_ratio(0.10)
			if(mecha.loc && hascall(mecha.loc, "assume_air"))
				mecha.loc.assume_air(leaked_gas)
			else
				qdel(leaked_gas)
	if(mecha.hasInternalDamage(MECHA_INT_SHORT_CIRCUIT))
		if(mecha.get_charge())
			mecha.spark_system.start()
			mecha.cell.charge -= min(20, mecha.cell.charge)
			mecha.cell.maxcharge -= min(20, mecha.cell.maxcharge)
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
