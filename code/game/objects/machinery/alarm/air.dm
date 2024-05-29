/proc/RandomAAlarmWires()
	//to make this not randomize the wires, just set index to 1 and increment it in the flag for loop (after doing everything else).
	var/list/AAlarmwires = list(0, 0, 0, 0, 0)
	AAlarmIndexToFlag = list(0, 0, 0, 0, 0)
	AAlarmIndexToWireColor = list(0, 0, 0, 0, 0)
	AAlarmWireColorToIndex = list(0, 0, 0, 0, 0)
	var/flagIndex = 1
	for(var/flag = 1, flag < 32, flag += flag)
		var/valid = 0
		while(!valid)
			var/colorIndex = rand(1, 5)
			if(AAlarmwires[colorIndex] == 0)
				valid = 1
				AAlarmwires[colorIndex] = flag
				AAlarmIndexToFlag[flagIndex] = flag
				AAlarmIndexToWireColor[flagIndex] = colorIndex
				AAlarmWireColorToIndex[colorIndex] = flagIndex
		flagIndex += 1
	return AAlarmwires

/*
 * AIR ALARM CIRCUIT
 * Just an object used in constructing air alarms.
*/
/obj/item/airalarm_electronics
	name = "air alarm electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	desc = "Looks like a circuit. Probably is."
	w_class = 2.0
	matter_amounts = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)

//all air alarms in area are connected via magic
/area
	var/obj/machinery/alarm/master_air_alarm
	var/list/air_vent_names = list()
	var/list/air_scrub_names = list()
	var/list/air_vent_info = list()
	var/list/air_scrub_info = list()

/*
 * Air Alarm
 */
/obj/machinery/alarm
	name = "alarm"
	icon = 'icons/obj/machines/monitors.dmi'
	icon_state = "alarm0"
	anchored = TRUE

	power_channel = ENVIRON
	power_usage = list(
		USE_POWER_IDLE = 4,
		USE_POWER_ACTIVE = 8
	)

	req_one_access = list(ACCESS_ATMOSPHERICS, ACCESS_ENGINE_EQUIP)

	var/frequency = 1439
	//var/skipprocess = 0 //Experimenting
	var/alarm_frequency = 1437
	var/remote_control = FALSE
	var/rcon_setting = 2
	var/rcon_time = 0
	var/locked = TRUE
	var/wiresexposed = FALSE // If it's been screwdrivered open.
	var/aidisabled = FALSE
	var/AAlarmwires = 31
	var/shorted = FALSE

	var/static/list/available_modes = list(
		/decl/air_alarm_mode/scrubbing,
		/decl/air_alarm_mode/replacement,
		/decl/air_alarm_mode/panic,
		/decl/air_alarm_mode/cycle,
		/decl/air_alarm_mode/fill,
		/decl/air_alarm_mode/off
	)
	var/decl/air_alarm_mode/mode // The current mode of the air alarm. Set to scrubbing by default.
	var/screen = AIR_ALARM_SCREEN_MAIN
	var/area_uid
	var/area/alarm_area
	var/buildstage = 2 //2 is built, 1 is building, 0 is frame.

	var/target_temperature = T0C + 20
	var/regulating_temperature = 0

	var/datum/radio_frequency/radio_connection

	var/list/TLV = list()

	var/danger_level = 0
	var/pressure_dangerlevel = 0
	var/oxygen_dangerlevel = 0
	var/co2_dangerlevel = 0
	var/plasma_dangerlevel = 0
	var/temperature_dangerlevel = 0
	var/other_dangerlevel = 0

/obj/machinery/alarm/server/New()
	. = ..()
	req_access = list(ACCESS_RD, ACCESS_ATMOSPHERICS, ACCESS_ENGINE_EQUIP)
	TLV[/decl/xgm_gas/oxygen] =			list(-1.0, -1.0,-1.0,-1.0) // Partial pressure, kpa
	TLV[/decl/xgm_gas/carbon_dioxide] =	list(-1.0, -1.0,   5,  10) // Partial pressure, kpa
	TLV[/decl/xgm_gas/plasma] =			list(-1.0, -1.0, 0.2, 0.5) // Partial pressure, kpa
	TLV["other"] =						list(-1.0, -1.0, 0.5, 1.0) // Partial pressure, kpa
	TLV["pressure"] =					list(0,ONE_ATMOSPHERE * 0.10, ONE_ATMOSPHERE * 1.40, ONE_ATMOSPHERE * 1.60) /* kpa */
	TLV["temperature"] =				list(20, 40, 140, 160) // K
	target_temperature = 90

/obj/machinery/alarm/New(loc, dir, building = 0)
	. = ..()
	mode = GET_DECL_INSTANCE(/decl/air_alarm_mode/scrubbing) // Sets the alarm to scrubbing by default.
	if(building)
		if(isnotnull(loc))
			src.loc = loc

		if(isnotnull(dir))
			set_dir(dir)

		buildstage = 0
		wiresexposed = TRUE
		pixel_x = (dir & 3) ? 0 : (dir == 4 ? -24 : 24)
		pixel_y = (dir & 3) ? (dir == 1 ? -24 : 24) : 0
		update_icon()
		return

	first_run()

/obj/machinery/alarm/initialise()
	. = ..()
	radio_connection = register_radio(src, null, frequency, RADIO_TO_AIRALARM)
	if(!master_is_operating())
		elect_master()

/obj/machinery/alarm/Destroy()
	unregister_radio(src, frequency)
	return ..()

/obj/machinery/alarm/proc/first_run()
	alarm_area = get_area(src)
	area_uid = alarm_area.uid
	if(name in list(
		"north bump", "south bump", "east bump", "west bump",
		"server north bump", "server south bump", "server east bump", "server west bump",
		"freezer north bump", "freezer south bump", "freezer east bump", "freezer west bump"
	))
		name = "[alarm_area.name] Air Alarm"

	// breathable air according to human/Life()
	TLV[/decl/xgm_gas/oxygen] =			list(16, 19, 135, 140) // Partial pressure, kpa
	TLV[/decl/xgm_gas/carbon_dioxide] =	list(-1.0, -1.0, 5, 10) // Partial pressure, kpa
	TLV[/decl/xgm_gas/plasma] =			list(-1.0, -1.0, 0.2, 0.5) // Partial pressure, kpa
	TLV["other"] =						list(-1.0, -1.0, 0.5, 1.0) // Partial pressure, kpa
	TLV["pressure"] =					list(ONE_ATMOSPHERE * 0.80, ONE_ATMOSPHERE * 0.90, ONE_ATMOSPHERE * 1.10, ONE_ATMOSPHERE * 1.20) /* kpa */
	TLV["temperature"] =				list(T0C - 26, T0C, T0C + 40, T0C + 66) // K

/obj/machinery/alarm/process()
	if((stat & (NOPOWER | BROKEN)) || shorted || buildstage != 2)
		return

	var/turf/simulated/location = loc
	if(!istype(location))
		return//returns if loc is not simulated

	var/datum/gas_mixture/environment = location.return_air()

	//Handle temperature adjustment here.
	if(environment.temperature < target_temperature - 2 || environment.temperature > target_temperature + 2 || regulating_temperature)
		//If it goes too far, we should adjust ourselves back before stopping.
		if(get_danger_level(target_temperature, TLV["temperature"]))
			return

		if(!regulating_temperature)
			regulating_temperature = TRUE
			visible_message(
				"\The [src] clicks as it starts [environment.temperature > target_temperature ? "cooling" : "heating"] the room.",
				"You hear a click and a faint electronic hum."
			)

		if(target_temperature > T0C + AIR_ALARM_MAX_TEMPERATURE)
			target_temperature = T0C + AIR_ALARM_MAX_TEMPERATURE

		if(target_temperature < T0C + AIR_ALARM_MIN_TEMPERATURE)
			target_temperature = T0C + AIR_ALARM_MIN_TEMPERATURE

		var/datum/gas_mixture/gas = location.remove_air(0.25 * environment.total_moles)
		if(isnotnull(gas))
			var/heat_capacity = gas.heat_capacity()
			if(heat_capacity)
				if(gas.temperature <= target_temperature)	//gas heating
					var/energy_used = min(gas.get_thermal_energy_change(target_temperature), AIR_ALARM_MAX_ENERGY_CHANGE)

					gas.add_thermal_energy(energy_used)
					use_power(energy_used, ENVIRON)
				else	//gas cooling
					var/heat_transfer = min(abs(gas.get_thermal_energy_change(target_temperature)), AIR_ALARM_MAX_ENERGY_CHANGE)

					//Assume the heat is being pumped into the hull which is fixed at 20 C
					//none of this is really proper thermodynamics but whatever
					var/cop = gas.temperature / T20C	//coefficient of performance -> power used = heat_transfer/cop

					heat_transfer = min(heat_transfer, cop * AIR_ALARM_MAX_ENERGY_CHANGE)	//this ensures that we don't use more than MAX_ENERGY_CHANGE amount of power - the machine can only do so much cooling

					heat_transfer = -gas.add_thermal_energy(-heat_transfer)	//get the actual heat transfer

					use_power(heat_transfer / cop, ENVIRON)

				environment.merge(gas)

				if(abs(environment.temperature - target_temperature) <= 0.5)
					regulating_temperature = FALSE
					visible_message(
						"\The [src] clicks quietly as it stops [environment.temperature > target_temperature ? "cooling" : "heating"] the room.",
						"You hear a click as a faint electronic humming stops."
					)

	var/old_level = danger_level
	danger_level = overall_danger_level()

	if(old_level != danger_level)
		refresh_danger_level()
		update_icon()

	if(istype(mode, /decl/air_alarm_mode/cycle) && environment.return_pressure() < ONE_ATMOSPHERE * 0.05)
		apply_mode(/decl/air_alarm_mode/fill)


	//atmos computer remote controll stuff
	switch(rcon_setting)
		if(AIR_ALARM_RCON_NO)
			remote_control = FALSE
		if(AIR_ALARM_RCON_AUTO)
			if(danger_level == 2)
				remote_control = TRUE
			else
				remote_control = FALSE
		if(AIR_ALARM_RCON_YES)
			remote_control = TRUE

	updateDialog()

/obj/machinery/alarm/proc/overall_danger_level()
	var/turf/simulated/location = loc
	if(!istype(location))
		return//returns if loc is not simulated

	var/datum/gas_mixture/environment = location.return_air()

	var/partial_pressure = R_IDEAL_GAS_EQUATION * environment.temperature / environment.volume
	var/environment_pressure = environment.return_pressure()
	//var/other_moles = 0.0
	//for(var/datum/gas/G in environment.trace_gases)
	//	other_moles+=G.moles

	var/pressure_dangerlevel = get_danger_level(environment_pressure, TLV["pressure"])
	var/oxygen_dangerlevel = get_danger_level(environment.gas[/decl/xgm_gas/oxygen] * partial_pressure, TLV[/decl/xgm_gas/oxygen])
	var/co2_dangerlevel = get_danger_level(environment.gas[/decl/xgm_gas/carbon_dioxide] * partial_pressure, TLV[/decl/xgm_gas/carbon_dioxide])
	var/plasma_dangerlevel = get_danger_level(environment.gas[/decl/xgm_gas/plasma] * partial_pressure, TLV[/decl/xgm_gas/plasma])
	var/temperature_dangerlevel = get_danger_level(environment.temperature, TLV["temperature"])
	//var/other_dangerlevel = get_danger_level(other_moles*partial_pressure, TLV["other"])

	return max(
		pressure_dangerlevel,
		oxygen_dangerlevel,
		co2_dangerlevel,
		plasma_dangerlevel,
		//other_dangerlevel,
		temperature_dangerlevel
	)

/obj/machinery/alarm/proc/master_is_operating()
	return isnotnull(alarm_area.master_air_alarm) && !(alarm_area.master_air_alarm.stat & (NOPOWER | BROKEN))

/obj/machinery/alarm/proc/elect_master()
	for(var/obj/machinery/alarm/AA in alarm_area)
		if(!(AA.stat & (NOPOWER | BROKEN)))
			alarm_area.master_air_alarm = AA

/obj/machinery/alarm/proc/get_danger_level(current_value, list/danger_levels)
	if((current_value >= danger_levels[4] && danger_levels[4] > 0) || current_value <= danger_levels[1])
		return 2
	if((current_value >= danger_levels[3] && danger_levels[3] > 0) || current_value <= danger_levels[2])
		return 1
	return 0

/obj/machinery/alarm/update_icon()
	if(wiresexposed)
		icon_state = "alarmx"
		return
	if((stat & (NOPOWER|BROKEN)) || shorted)
		icon_state = "alarmp"
		return
	switch(max(danger_level, alarm_area.atmos_alarm))
		if(0)
			icon_state = "alarm0"
		if(1)
			icon_state = "alarm2" //yes, alarm2 is yellow alarm
		if(2)
			icon_state = "alarm1"

/obj/machinery/alarm/receive_signal(datum/signal/signal)
	if(stat & (NOPOWER|BROKEN))
		return

	if(alarm_area.master_air_alarm != src)
		if(master_is_operating())
			return
		elect_master()
		if(alarm_area.master_air_alarm != src)
			return

	if(isnull(signal) || signal.encryption)
		return

	var/id_tag = signal.data["tag"]
	if(isnull(id_tag))
		return
	if(signal.data["area"] != area_uid)
		return
	if(signal.data["sigtype"] != "status")
		return

	var/dev_type = signal.data["device"]
	if(!(id_tag in alarm_area.air_scrub_names) && !(id_tag in alarm_area.air_vent_names))
		register_env_machine(id_tag, dev_type)
	if(dev_type == "AScr")
		alarm_area.air_scrub_info[id_tag] = signal.data
	else if(dev_type == "AVP")
		alarm_area.air_vent_info[id_tag] = signal.data

/obj/machinery/alarm/proc/register_env_machine(m_id, device_type)
	var/new_name
	if(device_type == "AVP")
		new_name = "[alarm_area.name] Vent Pump #[length(alarm_area.air_vent_names) + 1]"
		alarm_area.air_vent_names[m_id] = new_name
	else if(device_type == "AScr")
		new_name = "[alarm_area.name] Air Scrubber #[length(alarm_area.air_scrub_names) + 1]"
		alarm_area.air_scrub_names[m_id] = new_name
	else
		return
	spawn(10)
		send_signal(m_id, list("init" = new_name))

/obj/machinery/alarm/proc/refresh_all()
	for(var/id_tag in alarm_area.air_vent_names)
		var/list/I = alarm_area.air_vent_info[id_tag]
		if(I && I["timestamp"] + AIR_ALARM_REPORT_TIMEOUT / 2 > world.time)
			continue
		send_signal(id_tag, list("status"))
	for(var/id_tag in alarm_area.air_scrub_names)
		var/list/I = alarm_area.air_scrub_info[id_tag]
		if(I && I["timestamp"] + AIR_ALARM_REPORT_TIMEOUT / 2 > world.time)
			continue
		send_signal(id_tag, list("status"))

/obj/machinery/alarm/proc/send_signal(target, list/command)//sends signal 'command' to 'target'. Returns FALSE if no radio connection, TRUE otherwise
	if(isnull(radio_connection))
		return FALSE

	var/datum/signal/signal = new /datum/signal()
	signal.transmission_method = TRANSMISSION_RADIO
	signal.source = src

	signal.data = command
	signal.data["tag"] = target
	signal.data["sigtype"] = "command"

	radio_connection.post_signal(src, signal, RADIO_FROM_AIRALARM)
	//to_world("Signal [command] Broadcasted to [target]")

	return TRUE

/obj/machinery/alarm/proc/apply_mode(mode_type)
	var/current_pressures = TLV["pressure"]
	var/target_pressure = (current_pressures[2] + current_pressures[3]) / 2
	mode = GET_DECL_INSTANCE(mode_type)
	mode.apply(src, alarm_area, target_pressure)

/obj/machinery/alarm/proc/apply_danger_level(new_danger_level)
	if(alarm_area.atmos_alert(new_danger_level))
		post_alert(new_danger_level)

	for(var/area/A in alarm_area)
		for(var/obj/machinery/alarm/AA in A)
			if(!(AA.stat & (NOPOWER | BROKEN)) && !AA.shorted && AA.danger_level != new_danger_level)
				AA.update_icon()

	if(danger_level > 1)
		air_doors_close(0)
	else
		air_doors_open(0)

	update_icon()

/obj/machinery/alarm/proc/post_alert(alert_level)
	var/datum/radio_frequency/frequency = global.CTradio.return_frequency(alarm_frequency)
	if(isnull(frequency))
		return

	var/datum/signal/alert_signal = new /datum/signal()
	alert_signal.source = src
	alert_signal.transmission_method = TRANSMISSION_RADIO
	alert_signal.data["zone"] = alarm_area.name
	alert_signal.data["type"] = "Atmospheric"

	if(alert_level == 2)
		alert_signal.data["alert"] = "severe"
	else if(alert_level == 1)
		alert_signal.data["alert"] = "minor"
	else if(alert_level == 0)
		alert_signal.data["alert"] = "clear"

	frequency.post_signal(src, alert_signal)

/obj/machinery/alarm/proc/refresh_danger_level()
	var/level = 0
	for(var/obj/machinery/alarm/AA in alarm_area)
		if(!(AA.stat & (NOPOWER|BROKEN)) && !AA.shorted)
			if(AA.danger_level > level)
				level = AA.danger_level
	apply_danger_level(level)

/obj/machinery/alarm/proc/air_doors_close(manual)
	var/area/A = get_area(src)
	if(!A.air_doors_activated)
		A.air_doors_activated = TRUE
		for(var/obj/machinery/door/firedoor/E in A.all_doors)
			if(istype(E, /obj/machinery/door/firedoor))
				if(!E:blocked)
					if(E.operating)
						E:nextstate = DOOR_CLOSED
					else if(!E.density)
						spawn(0)
							E.close()
				continue

/*				if(istype(E, /obj/machinery/door/airlock))
				if((!E:arePowerSystemsOn()) || (E.stat & NOPOWER) || E:air_locked) continue
				if(!E.density)
					spawn(0)
						E.close()
						spawn(10)
							if(E.density)
								E:air_locked = E.req_access
								E:req_access = list(ACCESS_ENGINE, ACCESS_ATMOSPHERICS)
								E.update_icon()
				else if(E.operating)
					spawn(10)
						E.close()
						if(E.density)
							E:air_locked = E.req_access
							E:req_access = list(ACCESS_ENGINE, ACCESS_ATMOSPHERICS)
							E.update_icon()
				else if(!E:locked) //Don't lock already bolted doors.
					E:air_locked = E.req_access
					E:req_access = list(ACCESS_ENGINE, ACCESS_ATMOSPHERICS)
					E.update_icon()*/

/obj/machinery/alarm/proc/air_doors_open(manual)
	var/area/A = get_area(loc)
	if(A.air_doors_activated)
		A.air_doors_activated = FALSE
		for(var/obj/machinery/door/firedoor/E in A.all_doors)
			if(istype(E, /obj/machinery/door/firedoor))
				if(!E:blocked)
					if(E.operating)
						E:nextstate = OPEN
					else if(E.density)
						spawn(0)
							E.open()
				continue

/*				if(istype(E, /obj/machinery/door/airlock))
				if((!E:arePowerSystemsOn()) || (E.stat & NOPOWER)) continue
				if(isnotnull(E:air_locked)) //Don't mess with doors locked for other reasons.
					E:req_access = E:air_locked
					E:air_locked = null
					E.update_icon()*/

///////////
//HACKING//
///////////
/obj/machinery/alarm/proc/isWireColorCut(wireColor)
	var/wireFlag = AAlarmWireColorToFlag[wireColor]
	return ((AAlarmwires & wireFlag) == 0)

/obj/machinery/alarm/proc/isWireCut(wireIndex)
	var/wireFlag = AAlarmIndexToFlag[wireIndex]
	return ((AAlarmwires & wireFlag) == 0)

/obj/machinery/alarm/proc/allWiresCut()
	var/i = 1
	while(i <= 5)
		if(AAlarmwires & AAlarmIndexToFlag[i])
			return 0
		i++
	return 1

/obj/machinery/alarm/proc/cut(wireColor)
	var/wireFlag = AAlarmWireColorToFlag[wireColor]
	var/wireIndex = AAlarmWireColorToIndex[wireColor]
	AAlarmwires &= ~wireFlag
	switch(wireIndex)
		if(AIR_ALARM_WIRE_IDSCAN)
			locked = TRUE

		if(AIR_ALARM_WIRE_POWER)
			shock(usr, 50)
			shorted = TRUE
			update_icon()

		if(AIR_ALARM_WIRE_AI_CONTROL)
			if(!aidisabled)
				aidisabled = TRUE

		if(AIR_ALARM_WIRE_SYPHON)
			apply_mode(/decl/air_alarm_mode/panic)

		if(AIR_ALARM_WIRE_AALARM)
			if(alarm_area.atmos_alert(2))
				apply_danger_level(2)
			spawn(1)
				updateUsrDialog()
			update_icon()

	updateDialog()

/obj/machinery/alarm/proc/mend(wireColor)
	var/wireFlag = AAlarmWireColorToFlag[wireColor]
	var/wireIndex = AAlarmWireColorToIndex[wireColor] //not used in this function
	AAlarmwires |= wireFlag
	switch(wireIndex)
		if(AIR_ALARM_WIRE_IDSCAN)

		if(AIR_ALARM_WIRE_POWER)
			shorted = FALSE
			shock(usr, 50)
			update_icon()

		if(AIR_ALARM_WIRE_AI_CONTROL)
			if(aidisabled)
				aidisabled = FALSE

	updateDialog()

/obj/machinery/alarm/proc/pulse(wireColor)
	//var/wireFlag = AAlarmWireColorToFlag[wireColor] //not used in this function
	var/wireIndex = AAlarmWireColorToIndex[wireColor]
	switch(wireIndex)
		if(AIR_ALARM_WIRE_IDSCAN)			//unlocks for 30 seconds, if you have a better way to hack I'm all ears
			locked = FALSE
			spawn(300)
				locked = TRUE

		if(AIR_ALARM_WIRE_POWER)
			if(!shorted)
				shorted = TRUE
				update_icon()

			spawn(1200)
				if(shorted)
					shorted = FALSE
					update_icon()


		if(AIR_ALARM_WIRE_AI_CONTROL)
			if(!aidisabled)
				aidisabled = TRUE
			updateDialog()
			spawn(10)
				if(aidisabled)
					aidisabled = FALSE
				updateDialog()

		if(AIR_ALARM_WIRE_SYPHON)
			apply_mode(/decl/air_alarm_mode/replacement)

		if(AIR_ALARM_WIRE_AALARM)
			if(alarm_area.atmos_alert(0))
				apply_danger_level(0)
			spawn(1)
				updateUsrDialog()
			update_icon()

	updateDialog()

/obj/machinery/alarm/proc/shock(mob/user, prb)
	if((stat & NOPOWER))		// unpowered, no shock
		return 0
	if(!prob(prb))
		return 0 //you lucked out, no shock for you
	make_sparks(5, TRUE, src)
	if(electrocute_mob(user, get_area(src), src))
		return 1
	else
		return 0
///////////////
//END HACKING//
///////////////

/obj/machinery/alarm/attack_ai(mob/user)
	return interact(user)

/obj/machinery/alarm/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	return interact(user)

/obj/machinery/alarm/interact(mob/user)
	user.set_machine(src)

	if(buildstage != 2)
		return

	if(!in_range(src, user))
		if(!issilicon(user))
			user.machine = null
			user << browse(null, "window=air_alarm")
			user << browse(null, "window=AAlarmwires")
			return


		else if(issilicon(user) && aidisabled)
			to_chat(user, "AI control for this Air Alarm interface has been disabled.")
			user << browse(null, "window=air_alarm")
			return

	if(wiresexposed && (!issilicon(user)))
		var/t1 = "<html><head><title>[alarm_area.name] Air Alarm Wires</title></head><body><B>Access Panel</B><br>\n"
		var/list/wirecolors = list(
			"Orange" = 1,
			"Dark red" = 2,
			"White" = 3,
			"Yellow" = 4,
			"Black" = 5,
		)
		for(var/wiredesc in wirecolors)
			var/is_uncut = AAlarmwires & AAlarmWireColorToFlag[wirecolors[wiredesc]]
			t1 += "[wiredesc] wire: "
			if(!is_uncut)
				t1 += "<a href='?src=\ref[src];AAlarmwires=[wirecolors[wiredesc]]'>Mend</a>"

			else
				t1 += "<a href='?src=\ref[src];AAlarmwires=[wirecolors[wiredesc]]'>Cut</a> "
				t1 += "<a href='?src=\ref[src];pulse=[wirecolors[wiredesc]]'>Pulse</a> "

			t1 += "<br>"
		t1 += "<br>\n[(locked ? "The Air Alarm is locked." : "The Air Alarm is unlocked.")]<br>\n[((shorted || (stat & (NOPOWER|BROKEN))) ? "The Air Alarm is offline." : "The Air Alarm is working properly!")]<br>\n[(aidisabled ? "The 'AI control allowed' light is off." : "The 'AI control allowed' light is on.")]"
		t1 += "<p><a href='?src=\ref[src];close2=1'>Close</a></p></body></html>"
		user << browse(t1, "window=AAlarmwires")
		onclose(user, "AAlarmwires")

	if(!shorted)
		user << browse(return_text(user),"window=air_alarm")
		onclose(user, "air_alarm")

/obj/machinery/alarm/proc/return_text(mob/user)
	if(issilicon(user) && locked)
		return "<html><head><title>\The [src]</title></head><body>[return_status()]<hr>[rcon_text()]<hr><i>(Swipe ID card to unlock interface)</i></body></html>"
	else
		return "<html><head><title>\The [src]</title></head><body>[return_status()]<hr>[rcon_text()]<hr>[return_controls()]</body></html>"

/obj/machinery/alarm/proc/return_status()
	var/turf/location = get_turf(src)
	var/datum/gas_mixture/environment = location.return_air()
	var/total = environment.total_moles
	var/output = "<b>Air Status:</b><br>"

	if(total == 0)
		output += SPAN_DANGER("Warning: Cannot obtain air sample for analysis.")
		return output

	output += {"
<style>
.dl0 { color: green; }
.dl1 { color: orange; }
.dl2 { color: red; font-weght: bold;}
</style>
"}

	var/partial_pressure = R_IDEAL_GAS_EQUATION * environment.temperature / environment.volume

	var/list/current_settings = TLV["pressure"]
	var/environment_pressure = environment.return_pressure()
	var/pressure_dangerlevel = get_danger_level(environment_pressure, current_settings)

	current_settings = TLV[/decl/xgm_gas/oxygen]
	var/oxygen_dangerlevel = get_danger_level(environment.gas[/decl/xgm_gas/oxygen] * partial_pressure, current_settings)
	var/oxygen_percent = round(environment.gas[/decl/xgm_gas/oxygen] / total * 100, 2)

	current_settings = TLV[/decl/xgm_gas/carbon_dioxide]
	var/co2_dangerlevel = get_danger_level(environment.gas[/decl/xgm_gas/carbon_dioxide] * partial_pressure, current_settings)
	var/co2_percent = round(environment.gas[/decl/xgm_gas/carbon_dioxide] / total * 100, 2)

	current_settings = TLV[/decl/xgm_gas/plasma]
	var/plasma_dangerlevel = get_danger_level(environment.gas[/decl/xgm_gas/plasma] * partial_pressure, current_settings)
	var/plasma_percent = round(environment.gas[/decl/xgm_gas/plasma] / total * 100, 2)

	//current_settings = TLV["other"]
	//var/other_moles = 0.0
	//for(var/datum/gas/G in environment.trace_gases)
	//	other_moles+=G.moles
	//var/other_dangerlevel = get_danger_level(other_moles*partial_pressure, current_settings)

	current_settings = TLV["temperature"]
	var/temperature_dangerlevel = get_danger_level(environment.temperature, current_settings)

	output += {"
Pressure: <span class='dl[pressure_dangerlevel]'>[environment_pressure]</span>kPa<br>
Oxygen: <span class='dl[oxygen_dangerlevel]'>[oxygen_percent]</span>%<br>
Carbon dioxide: <span class='dl[co2_dangerlevel]'>[co2_percent]</span>%<br>
Toxins: <span class='dl[plasma_dangerlevel]'>[plasma_percent]</span>%<br>
"}
	//if (other_dangerlevel==2)
	//	output += "Notice: <span class='dl2'>High Concentration of Unknown Particles Detected</span><br>"
	//else if (other_dangerlevel==1)
	//	output += "Notice: <span class='dl1'>Low Concentration of Unknown Particles Detected</span><br>"

	output += "Temperature: <span class='dl[temperature_dangerlevel]'>[environment.temperature]</span>K ([round(environment.temperature - T0C, 0.1)]C)<br>"

	//Overall status
	output += "Local Status: "
	switch(max(pressure_dangerlevel, oxygen_dangerlevel, co2_dangerlevel, plasma_dangerlevel, other_dangerlevel, temperature_dangerlevel))
		if(2)
			output += "<span class='dl2'>DANGER: Internals Required</span>"
		if(1)
			output += "<span class='dl1'>Caution</span>"
		if(0)
			if(alarm_area.atmos_alarm)
				output += {"<span class='dl1'>Caution: Atmos alert in area</span>"}
			else
				output += {"<span class='dl0'>Optimal</span>"}

	return output

/obj/machinery/alarm/proc/rcon_text()
	var/dat = "<table width=\"100%\"><td align=\"center\"><b>Remote Control:</b><br>"
	if(rcon_setting == AIR_ALARM_RCON_NO)
		dat += "<b>Off</b>"
	else
		dat += "<a href='?src=\ref[src];rcon=[AIR_ALARM_RCON_NO]'>Off</a>"
	dat += " | "
	if(rcon_setting == AIR_ALARM_RCON_AUTO)
		dat += "<b>Auto</b>"
	else
		dat += "<a href='?src=\ref[src];rcon=[AIR_ALARM_RCON_AUTO]'>Auto</a>"
	dat += " | "
	if(rcon_setting == AIR_ALARM_RCON_YES)
		dat += "<b>On</b>"
	else
		dat += "<a href='?src=\ref[src];rcon=[AIR_ALARM_RCON_YES]'>On</a></td>"

	//Hackish, I know.  I didn't feel like bothering to rework all of this.
	dat += "<td align=\"center\"><b>Thermostat:</b><br><a href='?src=\ref[src];temperature=1'>[target_temperature - T0C]C</a></td></table>"

	return dat

/obj/machinery/alarm/proc/return_controls()
	var/output = ""//"<B>[alarm_zone] Air [name]</B><HR>"

	switch(screen)
		if(AIR_ALARM_SCREEN_MAIN)
			if(alarm_area.atmos_alarm)
				output += "<a href='?src=\ref[src];atmos_reset=1'>Reset - Atmospheric Alarm</a><hr>"
			else
				output += "<a href='?src=\ref[src];atmos_alarm=1'>Activate - Atmospheric Alarm</a><hr>"

			output += {"
<a href='?src=\ref[src];screen=[AIR_ALARM_SCREEN_SCRUB]'>Scrubbers Control</a><br>
<a href='?src=\ref[src];screen=[AIR_ALARM_SCREEN_VENT]'>Vents Control</a><br>
<a href='?src=\ref[src];screen=[AIR_ALARM_SCREEN_MODE]'>Set environmentals mode</a><br>
<a href='?src=\ref[src];screen=[AIR_ALARM_SCREEN_SENSORS]'>Sensor Settings</a><br>
<HR>
"}
			if(istype(mode, /decl/air_alarm_mode/panic))
				output += "<font color='red'><B>PANIC SYPHON ACTIVE</B></font><br><A href='?src=\ref[src];mode=[/decl/air_alarm_mode/scrubbing]'>Turn syphoning off</A>"
			else
				output += "<A href='?src=\ref[src];mode=[/decl/air_alarm_mode/panic]'><font color='red'>ACTIVATE PANIC SYPHON IN AREA</font></A>"


		if(AIR_ALARM_SCREEN_VENT)
			var/sensor_data = ""
			if(length(alarm_area.air_vent_names))
				for(var/id_tag in alarm_area.air_vent_names)
					var/long_name = alarm_area.air_vent_names[id_tag]
					var/list/data = alarm_area.air_vent_info[id_tag]
					if(isnull(data))
						continue;
					var/state = ""

					sensor_data += {"
<B>[long_name]</B>[state]<BR>
<B>Operating:</B>
<A href='?src=\ref[src];id_tag=[id_tag];command=power;val=[!data["power"]]'>[data["power"]?"on":"off"]</A>
<BR>
<B>Pressure checks:</B>
<A href='?src=\ref[src];id_tag=[id_tag];command=checks;val=[data["checks"]^1]' [(data["checks"]&1)?"style='font-weight:bold;'":""]>external</A>
<A href='?src=\ref[src];id_tag=[id_tag];command=checks;val=[data["checks"]^2]' [(data["checks"]&2)?"style='font-weight:bold;'":""]>internal</A>
<BR>
<B>External pressure bound:</B>
<A href='?src=\ref[src];id_tag=[id_tag];command=adjust_external_pressure;val=-1000'>-</A>
<A href='?src=\ref[src];id_tag=[id_tag];command=adjust_external_pressure;val=-100'>-</A>
<A href='?src=\ref[src];id_tag=[id_tag];command=adjust_external_pressure;val=-10'>-</A>
<A href='?src=\ref[src];id_tag=[id_tag];command=adjust_external_pressure;val=-1'>-</A>
[data["external"]]
<A href='?src=\ref[src];id_tag=[id_tag];command=adjust_external_pressure;val=+1'>+</A>
<A href='?src=\ref[src];id_tag=[id_tag];command=adjust_external_pressure;val=+10'>+</A>
<A href='?src=\ref[src];id_tag=[id_tag];command=adjust_external_pressure;val=+100'>+</A>
<A href='?src=\ref[src];id_tag=[id_tag];command=adjust_external_pressure;val=+1000'>+</A>
<A href='?src=\ref[src];id_tag=[id_tag];command=set_external_pressure;val=[ONE_ATMOSPHERE]'> (reset) </A>
<BR>
"}
					if(data["direction"] == "siphon")
						sensor_data += {"
<B>Direction:</B>
siphoning
<BR>
"}
					sensor_data += {"<HR>"}
			else
				sensor_data = "No vents connected.<BR>"
			output = {"<a href='?src=\ref[src];screen=[AIR_ALARM_SCREEN_MAIN]'>Main menu</a><br>[sensor_data]"}
		if(AIR_ALARM_SCREEN_SCRUB)
			var/sensor_data = ""
			if(length(alarm_area.air_scrub_names))
				for(var/id_tag in alarm_area.air_scrub_names)
					var/long_name = alarm_area.air_scrub_names[id_tag]
					var/list/data = alarm_area.air_scrub_info[id_tag]
					if(isnull(data))
						continue;
					var/state = ""

					sensor_data += {"
<B>[long_name]</B>[state]<BR>
<B>Operating:</B>
<A href='?src=\ref[src];id_tag=[id_tag];command=power;val=[!data["power"]]'>[data["power"]?"on":"off"]</A><BR>
<B>Type:</B>
<A href='?src=\ref[src];id_tag=[id_tag];command=scrubbing;val=[!data["scrubbing"]]'>[data["scrubbing"]?"scrubbing":"syphoning"]</A><BR>
"}

					if(data["scrubbing"])
						sensor_data += {"
<B>Filtering:</B>
Carbon Dioxide
<A href='?src=\ref[src];id_tag=[id_tag];command=co2_scrub;val=[!data["filter_co2"]]'>[data["filter_co2"]?"on":"off"]</A>;
Toxins
<A href='?src=\ref[src];id_tag=[id_tag];command=tox_scrub;val=[!data["filter_toxins"]]'>[data["filter_toxins"]?"on":"off"]</A>;
Nitrous Oxide
<A href='?src=\ref[src];id_tag=[id_tag];command=n2o_scrub;val=[!data["filter_n2o"]]'>[data["filter_n2o"]?"on":"off"]</A>
<BR>
"}
					sensor_data += {"
<B>Panic syphon:</B> [data["panic"]?"<font color='red'><B>PANIC SYPHON ACTIVATED</B></font>":""]
<A href='?src=\ref[src];id_tag=[id_tag];command=panic_siphon;val=[!data["panic"]]'><font color='[(data["panic"]?"blue'>Dea":"red'>A")]ctivate</font></A><BR>
<HR>
"}
			else
				sensor_data = "No scrubbers connected.<BR>"
			output = {"<a href='?src=\ref[src];screen=[AIR_ALARM_SCREEN_MAIN]'>Main menu</a><br>[sensor_data]"}

		if(AIR_ALARM_SCREEN_MODE)
			output += "<a href='?src=\ref[src];screen=[AIR_ALARM_SCREEN_MAIN]'>Main menu</a><br><b>Air machinery mode for the area:</b><ul>"
			for(var/mode_type in available_modes)
				var/decl/air_alarm_mode/iterated_mode = GET_DECL_INSTANCE(mode_type)
				if(istype(mode, mode_type))
					output += "<li><A href='?src=\ref[src];mode=[mode_type]'><b>[iterated_mode.description]</b></A> (selected)</li>"
				else
					output += "<li><A href='?src=\ref[src];mode=[mode_type]'>[iterated_mode.description]</A></li>"
			output += "</ul>"

		if(AIR_ALARM_SCREEN_SENSORS)
			output += {"
<a href='?src=\ref[src];screen=[AIR_ALARM_SCREEN_MAIN]'>Main menu</a><br>
<b>Alarm thresholds:</b><br>
Partial pressure for gases
<style>/* some CSS woodoo here. Does not work perfect in ie6 but who cares? */
table td { border-left: 1px solid black; border-top: 1px solid black;}
table tr:first-child th { border-left: 1px solid black;}
table th:first-child { border-top: 1px solid black; font-weight: normal;}
table tr:first-child th:first-child { border: none;}
.dl0 { color: green; }
.dl1 { color: orange; }
.dl2 { color: red; font-weght: bold;}
</style>
<table cellspacing=0>
<TR><th></th><th class=dl2>min2</th><th class=dl1>min1</th><th class=dl1>max1</th><th class=dl2>max2</th></TR>
"}
			var/list/gases = list(
				/decl/xgm_gas/oxygen			= "O<sub>2</sub>",
				/decl/xgm_gas/carbon_dioxide	= "CO<sub>2</sub>",
				/decl/xgm_gas/plasma			= "Toxin",
				"other"							= "Other"
			)

			var/list/selected
			for(var/g in gases)
				output += "<TR><th>[gases[g]]</th>"
				selected = TLV[g]
				for(var/i = 1, i <= 4, i++)
					output += "<td><A href='?src=\ref[src];command=set_threshold;env=[g];var=[i]'>[selected[i] >= 0 ? selected[i] :"OFF"]</A></td>"
				output += "</TR>"

			selected = TLV["pressure"]
			output += "<TR><th>Pressure</th>"
			for(var/i = 1, i <= 4, i++)
				output += "<td><A href='?src=\ref[src];command=set_threshold;env=pressure;var=[i]'>[selected[i] >= 0 ? selected[i] :"OFF"]</A></td>"
			output += "</TR>"

			selected = TLV["temperature"]
			output += "<TR><th>Temperature</th>"
			for(var/i = 1, i <= 4, i++)
				output += "<td><A href='?src=\ref[src];command=set_threshold;env=temperature;var=[i]'>[selected[i] >= 0 ? selected[i] :"OFF"]</A></td>"
			output += "</TR></table>"

	return output

/obj/machinery/alarm/Topic(href, href_list)
	if(href_list["rcon"])
		rcon_setting = text2num(href_list["rcon"])

	if(!in_range(src, usr))
		if(!issilicon(usr))
			usr.unset_machine()
			usr << browse(null, "window=air_alarm")
			usr << browse(null, "window=AAlarmwires")
			return

	add_fingerprint(usr)
	usr.set_machine(src)

	if(href_list["command"])
		var/device_id = href_list["id_tag"]
		switch(href_list["command"])
			if(
				"power",
				"adjust_external_pressure",
				"set_external_pressure",
				"checks",
				"co2_scrub",
				"tox_scrub",
				"n2o_scrub",
				"panic_siphon",
				"scrubbing"
			)
				send_signal(device_id, list(href_list["command"] = text2num(href_list["val"])))

			if("set_threshold")
				var/env = href_list["env"]
				var/threshold = text2num(href_list["var"])
				var/list/selected = TLV[env]
				var/list/thresholds = list("lower bound", "low warning", "high warning", "upper bound")
				var/newval = input("Enter [thresholds[threshold]] for [env]", "Alarm triggers", selected[threshold]) as null | num
				if(isnull(newval) || ..() || (locked && issilicon(usr)))
					return
				if(newval < 0)
					selected[threshold] = -1.0
				else if(env == "temperature" && newval > 5000)
					selected[threshold] = 5000
				else if(env == "pressure" && newval > 50 * ONE_ATMOSPHERE)
					selected[threshold] = 50 * ONE_ATMOSPHERE
				else if(env != "temperature" && env != "pressure" && newval > 200)
					selected[threshold] = 200
				else
					newval = round(newval, 0.01)
					selected[threshold] = newval
				if(threshold == 1)
					if(selected[1] > selected[2])
						selected[2] = selected[1]
					if(selected[1] > selected[3])
						selected[3] = selected[1]
					if(selected[1] > selected[4])
						selected[4] = selected[1]
				if(threshold == 2)
					if(selected[1] > selected[2])
						selected[1] = selected[2]
					if(selected[2] > selected[3])
						selected[3] = selected[2]
					if(selected[2] > selected[4])
						selected[4] = selected[2]
				if(threshold == 3)
					if(selected[1] > selected[3])
						selected[1] = selected[3]
					if(selected[2] > selected[3])
						selected[2] = selected[3]
					if(selected[3] > selected[4])
						selected[4] = selected[3]
				if(threshold == 4)
					if(selected[1] > selected[4])
						selected[1] = selected[4]
					if(selected[2] > selected[4])
						selected[2] = selected[4]
					if(selected[3] > selected[4])
						selected[3] = selected[4]

				apply_mode()

	if(href_list["screen"])
		screen = text2num(href_list["screen"])

	if(href_list["atmos_unlock"])
		switch(href_list["atmos_unlock"])
			if("0")
				air_doors_close(1)
			if("1")
				air_doors_open(1)

	if(href_list["atmos_alarm"])
		if(alarm_area.atmos_alert(2))
			apply_danger_level(2)
		update_icon()

	if(href_list["atmos_reset"])
		if(alarm_area.atmos_alert(0))
			apply_danger_level(0)
		update_icon()

	if(href_list["mode"])
		apply_mode(text2path(href_list["mode"]))

	if(href_list["temperature"])
		var/list/selected = TLV["temperature"]
		var/max_temperature = min(selected[3] - T0C, AIR_ALARM_MAX_TEMPERATURE)
		var/min_temperature = max(selected[2] - T0C, AIR_ALARM_MIN_TEMPERATURE)
		var/input_temperature = input("What temperature would you like the system to mantain? (Capped between [min_temperature]C and [max_temperature]C)", "Thermostat Controls") as num|null
		if(isnull(input_temperature) || input_temperature > max_temperature || input_temperature < min_temperature)
			to_chat(usr, "Temperature must be between [min_temperature]C and [max_temperature]C.")
		else
			target_temperature = input_temperature + T0C

	if(href_list["AAlarmwires"])
		var/t1 = text2num(href_list["AAlarmwires"])
		if(!(istype(usr.get_active_hand(), /obj/item/wirecutters)))
			to_chat(usr, "You need wirecutters!")
			return
		if(isWireColorCut(t1))
			mend(t1)
		else
			cut(t1)
			if(AAlarmwires == 0)
				to_chat(usr, SPAN_NOTICE("You cut the last of the wires inside [src]."))
				update_icon()
				buildstage = 1
			return

	else if(href_list["pulse"])
		var/t1 = text2num(href_list["pulse"])
		if(!istype(usr.get_active_hand(), /obj/item/multitool))
			to_chat(usr, "You need a multitool!")
			return
		if(isWireColorCut(t1))
			to_chat(usr, "You can't pulse a cut wire.")
			return
		else
			pulse(t1)

	updateUsrDialog()

/obj/machinery/alarm/attackby(obj/item/W as obj, mob/user as mob)
/*	if (istype(W, /obj/item/wirecutters))
		stat ^= BROKEN
		add_fingerprint(user)
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red [] has []activated []!", user, (stat&BROKEN) ? "de" : "re", src), 1)
		update_icon()
		return
*/
	add_fingerprint(user)

	switch(buildstage)
		if(2)
			if(istype(W, /obj/item/screwdriver))  // Opening that Air Alarm up.
				//user << "You pop the Air Alarm's maintence panel open."
				wiresexposed = !wiresexposed
				to_chat(user, "The wires have been [wiresexposed ? "exposed" : "unexposed"].")
				update_icon()
				return

			if(wiresexposed && (istype(W, /obj/item/multitool) || istype(W, /obj/item/wirecutters)))
				return attack_hand(user)

			if(istype(W, /obj/item/card/id) || istype(W, /obj/item/pda))// trying to unlock the interface with an ID card
				if(stat & (NOPOWER|BROKEN))
					to_chat(user, "It does nothing.")
					return
				else
					if(allowed(usr) && !isWireCut(AIR_ALARM_WIRE_IDSCAN))
						locked = !locked
						to_chat(user, SPAN_INFO("You [locked ? "lock" : "unlock"] the Air Alarm interface."))
						updateUsrDialog()
					else
						FEEDBACK_ACCESS_DENIED(user)
			return

		if(1)
			if(istype(W, /obj/item/stack/cable_coil))
				var/obj/item/stack/cable_coil/coil = W
				if(coil.amount < 5)
					to_chat(user, "You need more cable for this!")
					return

				to_chat(user, "You wire \the [src]!")
				coil.use(5)

				buildstage = 2
				update_icon()
				first_run()
				return

			else if(istype(W, /obj/item/crowbar))
				to_chat(user, "You start prying out the circuit.")
				playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
				if(do_after(user, 20))
					to_chat(user, "You pry out the circuit!")
					var/obj/item/airalarm_electronics/circuit = new /obj/item/airalarm_electronics()
					circuit.loc = user.loc
					buildstage = 0
					update_icon()
				return
		if(0)
			if(istype(W, /obj/item/airalarm_electronics))
				to_chat(user, "You insert the circuit!")
				qdel(W)
				buildstage = 1
				update_icon()
				return

			else if(istype(W, /obj/item/wrench))
				to_chat(user, "You remove the fire alarm assembly from the wall!")
				var/obj/item/frame/alarm/frame = new /obj/item/frame/alarm()
				frame.loc = user.loc
				playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
				qdel(src)

	return ..()

/obj/machinery/alarm/power_change()
	if(powered(power_channel))
		stat &= ~NOPOWER
	else
		stat |= NOPOWER
	spawn(rand(0, 15))
		update_icon()

/obj/machinery/alarm/examine()
	. = ..()
	if(buildstage < 2)
		to_chat(usr, "It is not wired.")
	if(buildstage < 1)
		to_chat(usr, "The circuit is missing.")