////////////////////////////////////////
//CONTAINS: Air Alarms and Fire Alarms//
////////////////////////////////////////

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

#define AALARM_WIRE_IDSCAN		1	//Added wires
#define AALARM_WIRE_POWER		2
#define AALARM_WIRE_SYPHON		3
#define AALARM_WIRE_AI_CONTROL	4
#define AALARM_WIRE_AALARM		5

#define AALARM_MODE_SCRUBBING	1
#define AALARM_MODE_REPLACEMENT	2 //like scrubbing, but faster.
#define AALARM_MODE_PANIC		3 //constantly sucks all air
#define AALARM_MODE_CYCLE		4 //sucks off all air, then refill and switches to scrubbing
#define AALARM_MODE_FILL		5 //emergency fill
#define AALARM_MODE_OFF			6 //Shuts it all down.

#define AALARM_SCREEN_MAIN		1
#define AALARM_SCREEN_VENT		2
#define AALARM_SCREEN_SCRUB		3
#define AALARM_SCREEN_MODE		4
#define AALARM_SCREEN_SENSORS	5

#define AALARM_REPORT_TIMEOUT 100

#define RCON_NO		1
#define RCON_AUTO	2
#define RCON_YES	3

//1000 joules equates to about 1 degree every 2 seconds for a single tile of air.
#define MAX_ENERGY_CHANGE 1000

#define MAX_TEMPERATURE 90
#define MIN_TEMPERATURE -40

//all air alarms in area are connected via magic
/area
	var/obj/machinery/alarm/master_air_alarm
	var/list/air_vent_names = list()
	var/list/air_scrub_names = list()
	var/list/air_vent_info = list()
	var/list/air_scrub_info = list()

/obj/machinery/alarm
	name = "alarm"
	icon = 'icons/obj/monitors.dmi'
	icon_state = "alarm0"
	anchored = TRUE
	use_power = 1
	idle_power_usage = 4
	active_power_usage = 8
	power_channel = ENVIRON
	req_one_access = list(ACCESS_ATMOSPHERICS, ACCESS_ENGINE_EQUIP)

	var/frequency = 1439
	//var/skipprocess = 0 //Experimenting
	var/alarm_frequency = 1437
	var/remote_control = 0
	var/rcon_setting = 2
	var/rcon_time = 0
	var/locked = 1
	var/wiresexposed = 0 // If it's been screwdrivered open.
	var/aidisabled = 0
	var/AAlarmwires = 31
	var/shorted = 0

	var/mode = AALARM_MODE_SCRUBBING
	var/screen = AALARM_SCREEN_MAIN
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
	..()
	req_access = list(ACCESS_RD, ACCESS_ATMOSPHERICS, ACCESS_ENGINE_EQUIP)
	TLV[GAS_OXYGEN] =			list(-1.0, -1.0,-1.0,-1.0) // Partial pressure, kpa
	TLV[GAS_CARBON_DIOXIDE] = list(-1.0, -1.0,   5,  10) // Partial pressure, kpa
	TLV[GAS_PLASMA] =			list(-1.0, -1.0, 0.2, 0.5) // Partial pressure, kpa
	TLV["other"] =			list(-1.0, -1.0, 0.5, 1.0) // Partial pressure, kpa
	TLV["pressure"] =		list(0,ONE_ATMOSPHERE * 0.10, ONE_ATMOSPHERE * 1.40, ONE_ATMOSPHERE * 1.60) /* kpa */
	TLV["temperature"] =	list(20, 40, 140, 160) // K
	target_temperature = 90

/obj/machinery/alarm/New(loc, dir, building = 0)
	..()
	if(building)
		if(loc)
			src.loc = loc

		if(dir)
			src.set_dir(dir)

		buildstage = 0
		wiresexposed = 1
		pixel_x = (dir & 3) ? 0 : (dir == 4 ? -24 : 24)
		pixel_y = (dir & 3) ? (dir == 1 ? -24 : 24) : 0
		update_icon()
		return

	first_run()

/obj/machinery/alarm/initialize()
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
	TLV[GAS_OXYGEN] =			list(16, 19, 135, 140) // Partial pressure, kpa
	TLV[GAS_CARBON_DIOXIDE] = list(-1.0, -1.0, 5, 10) // Partial pressure, kpa
	TLV[GAS_PLASMA] =			list(-1.0, -1.0, 0.2, 0.5) // Partial pressure, kpa
	TLV["other"] =			list(-1.0, -1.0, 0.5, 1.0) // Partial pressure, kpa
	TLV["pressure"] =		list(ONE_ATMOSPHERE * 0.80, ONE_ATMOSPHERE * 0.90, ONE_ATMOSPHERE * 1.10, ONE_ATMOSPHERE * 1.20) /* kpa */
	TLV["temperature"] =	list(T0C - 26, T0C, T0C + 40, T0C + 66) // K

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
			regulating_temperature = 1
			visible_message(
				"\The [src] clicks as it starts [environment.temperature > target_temperature ? "cooling" : "heating"] the room.",
				"You hear a click and a faint electronic hum."
			)

		if(target_temperature > T0C + MAX_TEMPERATURE)
			target_temperature = T0C + MAX_TEMPERATURE

		if(target_temperature < T0C + MIN_TEMPERATURE)
			target_temperature = T0C + MIN_TEMPERATURE

		var/datum/gas_mixture/gas
		gas = location.remove_air(0.25 * environment.total_moles)
		if(gas)
			var/heat_capacity = gas.heat_capacity()
			if(heat_capacity)
				if(gas.temperature <= target_temperature)	//gas heating
					var/energy_used = min(gas.get_thermal_energy_change(target_temperature), MAX_ENERGY_CHANGE)

					gas.add_thermal_energy(energy_used)
					use_power(energy_used, ENVIRON)
				else	//gas cooling
					var/heat_transfer = min(abs(gas.get_thermal_energy_change(target_temperature)), MAX_ENERGY_CHANGE)

					//Assume the heat is being pumped into the hull which is fixed at 20 C
					//none of this is really proper thermodynamics but whatever
					var/cop = gas.temperature/T20C	//coefficient of performance -> power used = heat_transfer/cop

					heat_transfer = min(heat_transfer, cop * MAX_ENERGY_CHANGE)	//this ensures that we don't use more than MAX_ENERGY_CHANGE amount of power - the machine can only do so much cooling

					heat_transfer = -gas.add_thermal_energy(-heat_transfer)	//get the actual heat transfer

					use_power(heat_transfer / cop, ENVIRON)

				environment.merge(gas)

				if(abs(environment.temperature - target_temperature) <= 0.5)
					regulating_temperature = 0
					visible_message(
						"\The [src] clicks quietly as it stops [environment.temperature > target_temperature ? "cooling" : "heating"] the room.",
						"You hear a click as a faint electronic humming stops."
					)

	var/old_level = danger_level
	danger_level = overall_danger_level()

	if(old_level != danger_level)
		refresh_danger_level()
		update_icon()

	if(mode == AALARM_MODE_CYCLE && environment.return_pressure() < ONE_ATMOSPHERE * 0.05)
		mode = AALARM_MODE_FILL
		apply_mode()


	//atmos computer remote controll stuff
	switch(rcon_setting)
		if(RCON_NO)
			remote_control = 0
		if(RCON_AUTO)
			if(danger_level == 2)
				remote_control = 1
			else
				remote_control = 0
		if(RCON_YES)
			remote_control = 1

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
	var/oxygen_dangerlevel = get_danger_level(environment.gas[GAS_OXYGEN] * partial_pressure, TLV[GAS_OXYGEN])
	var/co2_dangerlevel = get_danger_level(environment.gas[GAS_CARBON_DIOXIDE] * partial_pressure, TLV[GAS_CARBON_DIOXIDE])
	var/plasma_dangerlevel = get_danger_level(environment.gas[GAS_PLASMA] * partial_pressure, TLV[GAS_PLASMA])
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
	return alarm_area.master_air_alarm && !(alarm_area.master_air_alarm.stat & (NOPOWER | BROKEN))

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
	switch(max(danger_level, alarm_area.atmosalm))
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
	if(!signal || signal.encryption)
		return
	var/id_tag = signal.data["tag"]
	if(!id_tag)
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
		if(I && I["timestamp"] + AALARM_REPORT_TIMEOUT / 2 > world.time)
			continue
		send_signal(id_tag, list("status"))
	for(var/id_tag in alarm_area.air_scrub_names)
		var/list/I = alarm_area.air_scrub_info[id_tag]
		if(I && I["timestamp"] + AALARM_REPORT_TIMEOUT / 2 > world.time)
			continue
		send_signal(id_tag, list("status"))

/obj/machinery/alarm/proc/send_signal(target, list/command)//sends signal 'command' to 'target'. Returns 0 if no radio connection, 1 otherwise
	if(isnull(radio_connection))
		return 0

	var/datum/signal/signal = new /datum/signal()
	signal.transmission_method = TRANSMISSION_RADIO
	signal.source = src

	signal.data = command
	signal.data["tag"] = target
	signal.data["sigtype"] = "command"

	radio_connection.post_signal(src, signal, RADIO_FROM_AIRALARM)
//			world << text("Signal [] Broadcasted to []", command, target)

	return 1

/obj/machinery/alarm/proc/apply_mode()
	var/current_pressures = TLV["pressure"]
	var/target_pressure = (current_pressures[2] + current_pressures[3])/2
	switch(mode)
		if(AALARM_MODE_SCRUBBING)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("power" = 1, "co2_scrub" = 1, "scrubbing" = 1, "panic_siphon" = 0))
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("power" = 1, "checks" = 1, "set_external_pressure" = target_pressure))

		if(AALARM_MODE_PANIC, AALARM_MODE_CYCLE)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("power" = 1, "panic_siphon" = 1))
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("power" = 0) )

		if(AALARM_MODE_REPLACEMENT)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("power" = 1, "panic_siphon" = 1))
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("power" = 1, "checks" = 1, "set_external_pressure" = target_pressure))

		if(AALARM_MODE_FILL)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("power" = 0))
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("power" = 1, "checks" = 1, "set_external_pressure" = target_pressure))

		if(AALARM_MODE_OFF)
			for(var/device_id in alarm_area.air_scrub_names)
				send_signal(device_id, list("power" = 0))
			for(var/device_id in alarm_area.air_vent_names)
				send_signal(device_id, list("power" = 0))

/obj/machinery/alarm/proc/apply_danger_level(new_danger_level)
	if(alarm_area.atmosalert(new_danger_level))
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
				if(!isnull(E:air_locked)) //Don't mess with doors locked for other reasons.
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
		if(AALARM_WIRE_IDSCAN)
			locked = 1

		if(AALARM_WIRE_POWER)
			shock(usr, 50)
			shorted = 1
			update_icon()

		if(AALARM_WIRE_AI_CONTROL)
			if(aidisabled == 0)
				aidisabled = 1

		if(AALARM_WIRE_SYPHON)
			mode = AALARM_MODE_PANIC
			apply_mode()

		if(AALARM_WIRE_AALARM)
			if(alarm_area.atmosalert(2))
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
		if(AALARM_WIRE_IDSCAN)

		if(AALARM_WIRE_POWER)
			shorted = 0
			shock(usr, 50)
			update_icon()

		if(AALARM_WIRE_AI_CONTROL)
			if(aidisabled == 1)
				aidisabled = 0

	updateDialog()

/obj/machinery/alarm/proc/pulse(wireColor)
	//var/wireFlag = AAlarmWireColorToFlag[wireColor] //not used in this function
	var/wireIndex = AAlarmWireColorToIndex[wireColor]
	switch(wireIndex)
		if(AALARM_WIRE_IDSCAN)			//unlocks for 30 seconds, if you have a better way to hack I'm all ears
			locked = 0
			spawn(300)
				locked = 1

		if(AALARM_WIRE_POWER)
			if(shorted == 0)
				shorted = 1
				update_icon()

			spawn(1200)
				if(shorted == 1)
					shorted = 0
					update_icon()


		if(AALARM_WIRE_AI_CONTROL)
			if(aidisabled == 0)
				aidisabled = 1
			updateDialog()
			spawn(10)
				if(aidisabled == 1)
					aidisabled = 0
				updateDialog()

		if(AALARM_WIRE_SYPHON)
			mode = AALARM_MODE_REPLACEMENT
			apply_mode()

		if(AALARM_WIRE_AALARM)
			if(alarm_area.atmosalert(0))
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
	var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
	s.set_up(5, 1, src)
	s.start() //sparks always.
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

	if(get_dist(src, user) > 1)
		if(!issilicon(user))
			user.machine = null
			user << browse(null, "window=air_alarm")
			user << browse(null, "window=AAlarmwires")
			return


		else if(issilicon(user) && aidisabled)
			user << "AI control for this Air Alarm interface has been disabled."
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
		output += "<font color='red'><b>Warning: Cannot obtain air sample for analysis.</b></font>"
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

	current_settings = TLV[GAS_OXYGEN]
	var/oxygen_dangerlevel = get_danger_level(environment.gas[GAS_OXYGEN] * partial_pressure, current_settings)
	var/oxygen_percent = round(environment.gas[GAS_OXYGEN] / total * 100, 2)

	current_settings = TLV[GAS_CARBON_DIOXIDE]
	var/co2_dangerlevel = get_danger_level(environment.gas[GAS_CARBON_DIOXIDE] * partial_pressure, current_settings)
	var/co2_percent = round(environment.gas[GAS_CARBON_DIOXIDE] / total * 100, 2)

	current_settings = TLV[GAS_PLASMA]
	var/plasma_dangerlevel = get_danger_level(environment.gas[GAS_PLASMA] * partial_pressure, current_settings)
	var/plasma_percent = round(environment.gas[GAS_PLASMA] / total * 100, 2)

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
			if(alarm_area.atmosalm)
				output += {"<span class='dl1'>Caution: Atmos alert in area</span>"}
			else
				output += {"<span class='dl0'>Optimal</span>"}

	return output

/obj/machinery/alarm/proc/rcon_text()
	var/dat = "<table width=\"100%\"><td align=\"center\"><b>Remote Control:</b><br>"
	if(rcon_setting == RCON_NO)
		dat += "<b>Off</b>"
	else
		dat += "<a href='?src=\ref[src];rcon=[RCON_NO]'>Off</a>"
	dat += " | "
	if(rcon_setting == RCON_AUTO)
		dat += "<b>Auto</b>"
	else
		dat += "<a href='?src=\ref[src];rcon=[RCON_AUTO]'>Auto</a>"
	dat += " | "
	if(rcon_setting == RCON_YES)
		dat += "<b>On</b>"
	else
		dat += "<a href='?src=\ref[src];rcon=[RCON_YES]'>On</a></td>"

	//Hackish, I know.  I didn't feel like bothering to rework all of this.
	dat += "<td align=\"center\"><b>Thermostat:</b><br><a href='?src=\ref[src];temperature=1'>[target_temperature - T0C]C</a></td></table>"

	return dat

/obj/machinery/alarm/proc/return_controls()
	var/output = ""//"<B>[alarm_zone] Air [name]</B><HR>"

	switch(screen)
		if(AALARM_SCREEN_MAIN)
			if(alarm_area.atmosalm)
				output += "<a href='?src=\ref[src];atmos_reset=1'>Reset - Atmospheric Alarm</a><hr>"
			else
				output += "<a href='?src=\ref[src];atmos_alarm=1'>Activate - Atmospheric Alarm</a><hr>"

			output += {"
<a href='?src=\ref[src];screen=[AALARM_SCREEN_SCRUB]'>Scrubbers Control</a><br>
<a href='?src=\ref[src];screen=[AALARM_SCREEN_VENT]'>Vents Control</a><br>
<a href='?src=\ref[src];screen=[AALARM_SCREEN_MODE]'>Set environmentals mode</a><br>
<a href='?src=\ref[src];screen=[AALARM_SCREEN_SENSORS]'>Sensor Settings</a><br>
<HR>
"}
			if(mode == AALARM_MODE_PANIC)
				output += "<font color='red'><B>PANIC SYPHON ACTIVE</B></font><br><A href='?src=\ref[src];mode=[AALARM_MODE_SCRUBBING]'>Turn syphoning off</A>"
			else
				output += "<A href='?src=\ref[src];mode=[AALARM_MODE_PANIC]'><font color='red'>ACTIVATE PANIC SYPHON IN AREA</font></A>"


		if(AALARM_SCREEN_VENT)
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
			output = {"<a href='?src=\ref[src];screen=[AALARM_SCREEN_MAIN]'>Main menu</a><br>[sensor_data]"}
		if(AALARM_SCREEN_SCRUB)
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
			output = {"<a href='?src=\ref[src];screen=[AALARM_SCREEN_MAIN]'>Main menu</a><br>[sensor_data]"}

		if(AALARM_SCREEN_MODE)
			output += "<a href='?src=\ref[src];screen=[AALARM_SCREEN_MAIN]'>Main menu</a><br><b>Air machinery mode for the area:</b><ul>"
			var/list/modes = list(AALARM_MODE_SCRUBBING   = "Filtering - Scrubs out contaminants",\
				AALARM_MODE_REPLACEMENT	= "<font color='blue'>Replace Air - Siphons out air while replacing</font>",\
				AALARM_MODE_PANIC		= "<font color='red'>Panic - Siphons air out of the room</font>",\
				AALARM_MODE_CYCLE		= "<font color='red'>Cycle - Siphons air before replacing</font>",\
				AALARM_MODE_FILL		= "<font color='green'>Fill - Shuts off scrubbers and opens vents</font>",\
				AALARM_MODE_OFF			= "<font color='blue'>Off - Shuts off vents and scrubbers</font>",)
			for(var/m = 1, m <= length(modes), m++)
				if(mode == m)
					output += "<li><A href='?src=\ref[src];mode=[m]'><b>[modes[m]]</b></A> (selected)</li>"
				else
					output += "<li><A href='?src=\ref[src];mode=[m]'>[modes[m]]</A></li>"
			output += "</ul>"

		if(AALARM_SCREEN_SENSORS)
			output += {"
<a href='?src=\ref[src];screen=[AALARM_SCREEN_MAIN]'>Main menu</a><br>
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
				GAS_OXYGEN			= "O<sub>2</sub>",
				GAS_CARBON_DIOXIDE	= "CO<sub>2</sub>",
				GAS_PLASMA			= "Toxin",
				"other"				= "Other"
			)

			var/list/selected
			for(var/g in gases)
				output += "<TR><th>[gases[g]]</th>"
				selected = TLV[g]
				for(var/i = 1, i <= 4, i++)
					output += "<td><A href='?src=\ref[src];command=set_threshold;env=[g];var=[i]'>[selected[i] >= 0 ? selected[i] :"OFF"]</A></td>"
				output += "</TR>"

			selected = TLV["pressure"]
			output += "	<TR><th>Pressure</th>"
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

	if(get_dist(src, usr) > 1)
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
				var/newval = input("Enter [thresholds[threshold]] for [env]", "Alarm triggers", selected[threshold]) as null|num
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
		if(alarm_area.atmosalert(2))
			apply_danger_level(2)
		update_icon()

	if(href_list["atmos_reset"])
		if(alarm_area.atmosalert(0))
			apply_danger_level(0)
		update_icon()

	if(href_list["mode"])
		mode = text2num(href_list["mode"])
		apply_mode()

	if(href_list["temperature"])
		var/list/selected = TLV["temperature"]
		var/max_temperature = min(selected[3] - T0C, MAX_TEMPERATURE)
		var/min_temperature = max(selected[2] - T0C, MIN_TEMPERATURE)
		var/input_temperature = input("What temperature would you like the system to mantain? (Capped between [min_temperature]C and [max_temperature]C)", "Thermostat Controls") as num|null
		if(isnull(input_temperature) || input_temperature > max_temperature || input_temperature < min_temperature)
			to_chat(usr, "Temperature must be between [min_temperature]C and [max_temperature]C.")
		else
			target_temperature = input_temperature + T0C

	if(href_list["AAlarmwires"])
		var/t1 = text2num(href_list["AAlarmwires"])
		if(!(istype(usr.equipped(), /obj/item/weapon/wirecutters)))
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
		if(!istype(usr.equipped(), /obj/item/device/multitool))
			to_chat(usr, "You need a multitool!")
			return
		if(isWireColorCut(t1))
			to_chat(usr, "You can't pulse a cut wire.")
			return
		else
			pulse(t1)

	updateUsrDialog()

/obj/machinery/alarm/attackby(obj/item/W as obj, mob/user as mob)
/*	if (istype(W, /obj/item/weapon/wirecutters))
		stat ^= BROKEN
		add_fingerprint(user)
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red [] has []activated []!", user, (stat&BROKEN) ? "de" : "re", src), 1)
		update_icon()
		return
*/
	src.add_fingerprint(user)

	switch(buildstage)
		if(2)
			if(istype(W, /obj/item/weapon/screwdriver))  // Opening that Air Alarm up.
				//user << "You pop the Air Alarm's maintence panel open."
				wiresexposed = !wiresexposed
				to_chat(user, "The wires have been [wiresexposed ? "exposed" : "unexposed"].")
				update_icon()
				return

			if(wiresexposed && (istype(W, /obj/item/device/multitool) || istype(W, /obj/item/weapon/wirecutters)))
				return attack_hand(user)

			if(istype(W, /obj/item/weapon/card/id) || istype(W, /obj/item/device/pda))// trying to unlock the interface with an ID card
				if(stat & (NOPOWER|BROKEN))
					to_chat(user, "It does nothing.")
					return
				else
					if(allowed(usr) && !isWireCut(AALARM_WIRE_IDSCAN))
						locked = !locked
						to_chat(user, SPAN_INFO("You [locked ? "lock" : "unlock"] the Air Alarm interface."))
						updateUsrDialog()
					else
						to_chat(user, SPAN_WARNING("Access denied."))
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

			else if(istype(W, /obj/item/weapon/crowbar))
				to_chat(user, "You start prying out the circuit.")
				playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
				if(do_after(user, 20))
					to_chat(user, "You pry out the circuit!")
					var/obj/item/weapon/airalarm_electronics/circuit = new /obj/item/weapon/airalarm_electronics()
					circuit.loc = user.loc
					buildstage = 0
					update_icon()
				return
		if(0)
			if(istype(W, /obj/item/weapon/airalarm_electronics))
				to_chat(user, "You insert the circuit!")
				qdel(W)
				buildstage = 1
				update_icon()
				return

			else if(istype(W, /obj/item/weapon/wrench))
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
	..()
	if(buildstage < 2)
		to_chat(usr, "It is not wired.")
	if(buildstage < 1)
		to_chat(usr, "The circuit is missing.")
/*
AIR ALARM CIRCUIT
Just a object used in constructing air alarms
*/
/obj/item/weapon/airalarm_electronics
	name = "air alarm electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	desc = "Looks like a circuit. Probably is."
	w_class = 2.0
	matter_amounts = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)

/*
FIRE ALARM
*/
/obj/machinery/firealarm
	name = "fire alarm"
	desc = "<i>\"Pull this in case of emergency\"</i>. Thus, keep pulling it forever."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "fire0"

	anchored = TRUE
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 6
	power_channel = ENVIRON

	var/detecting = 1.0
	var/working = 1.0
	var/time = 10.0
	var/timing = 0.0
	var/lockdownbyai = 0

	var/last_process = 0
	var/wiresexposed = 0
	var/buildstage = 2 // 2 = complete, 1 = no wires,  0 = circuit gone

/obj/machinery/firealarm/update_icon()
	if(wiresexposed)
		switch(buildstage)
			if(2)
				icon_state = "fire_b2"
			if(1)
				icon_state = "fire_b1"
			if(0)
				icon_state = "fire_b0"

		return

	if(stat & BROKEN)
		icon_state = "firex"
	else if(stat & NOPOWER)
		icon_state = "firep"
	else if(!src.detecting)
		icon_state = "fire1"
	else
		icon_state = "fire0"

/obj/machinery/firealarm/fire_act(datum/gas_mixture/air, temperature, volume)
	if(src.detecting)
		if(temperature > T0C + 200)
			src.alarm()			// added check of detector status here

/obj/machinery/firealarm/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/firealarm/bullet_act(BLAH)
	return src.alarm()

/obj/machinery/firealarm/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/firealarm/emp_act(severity)
	if(prob(50 / severity))
		alarm()
	..()

/obj/machinery/firealarm/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)

	if(istype(W, /obj/item/weapon/screwdriver) && buildstage == 2)
		wiresexposed = !wiresexposed
		update_icon()
		return

	if(wiresexposed)
		switch(buildstage)
			if(2)
				if(istype(W, /obj/item/device/multitool))
					src.detecting = !(src.detecting)
					if(src.detecting)
						user.visible_message(SPAN_WARNING("[user] has reconnected [src]'s detecting unit!"), "You have reconnected [src]'s detecting unit.")
					else
						user.visible_message(SPAN_WARNING("[user] has disconnected [src]'s detecting unit!"), "You have disconnected [src]'s detecting unit.")
			if(1)
				if(istype(W, /obj/item/stack/cable_coil))
					var/obj/item/stack/cable_coil/coil = W
					if(coil.amount < 5)
						to_chat(user, "You need more cable for this!")
						return

					coil.use(5)

					buildstage = 2
					to_chat(user, "You wire \the [src]!")
					update_icon()

				else if(istype(W, /obj/item/weapon/crowbar))
					user << "You pry out the circuit!"
					playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
					spawn(20)
						var/obj/item/weapon/firealarm_electronics/circuit = new /obj/item/weapon/firealarm_electronics()
						circuit.loc = user.loc
						buildstage = 0
						update_icon()
			if(0)
				if(istype(W, /obj/item/weapon/firealarm_electronics))
					to_chat(user, "You insert the circuit!")
					qdel(W)
					buildstage = 1
					update_icon()

				else if(istype(W, /obj/item/weapon/wrench))
					to_chat(user, "You remove the fire alarm assembly from the wall!")
					var/obj/item/frame/firealarm/frame = new /obj/item/frame/firealarm()
					frame.loc = user.loc
					playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
					qdel(src)
		return

	src.alarm()

/obj/machinery/firealarm/process()//Note: this processing was mostly phased out due to other code, and only runs when needed
	if(stat & (NOPOWER|BROKEN))
		return

	if(src.timing)
		if(src.time > 0)
			src.time = src.time - ((world.timeofday - last_process)/10)
		else
			src.alarm()
			src.time = 0
			src.timing = 0
			GLOBL.processing_objects.Remove(src)
		src.updateDialog()
	last_process = world.timeofday

	if(locate(/obj/fire) in loc)
		alarm()

/obj/machinery/firealarm/power_change()
	if(powered(ENVIRON))
		stat &= ~NOPOWER
		update_icon()
	else
		spawn(rand(0, 15))
			stat |= NOPOWER
			update_icon()

/obj/machinery/firealarm/attack_hand(mob/user as mob)
	if(user.stat || stat & (NOPOWER|BROKEN))
		return

	if(buildstage != 2)
		return

	user.set_machine(src)
	var/area/A = src.loc
	var/d1
	var/d2
	if(ishuman(user) || issilicon(user))
		A = A.loc
		if(A.fire)
			d1 = "<A href='?src=\ref[src];reset=1'>Reset - Lockdown</A>"
		else
			d1 = "<A href='?src=\ref[src];alarm=1'>Alarm - Lockdown</A>"
		if(src.timing)
			d2 = "<A href='?src=\ref[src];time=0'>Stop Time Lock</A>"
		else
			d2 = "<A href='?src=\ref[src];time=1'>Initiate Time Lock</A>"
		var/second = round(src.time) % 60
		var/minute = (round(src.time) - second) / 60
		var/dat = "<HTML><HEAD></HEAD><BODY><TT><B>Fire alarm</B> [d1]\n<HR>The current alert level is: [GLOBL.security_level.name]</b><br><br>\nTimer System: [d2]<BR>\nTime Left: [(minute ? "[minute]:" : null)][second] <A href='?src=\ref[src];tp=-30'>-</A> <A href='?src=\ref[src];tp=-1'>-</A> <A href='?src=\ref[src];tp=1'>+</A> <A href='?src=\ref[src];tp=30'>+</A>\n</TT></BODY></HTML>"
		user << browse(dat, "window=firealarm")
		onclose(user, "firealarm")
	else
		A = A.loc
		if(A.fire)
			d1 = "<A href='?src=\ref[src];reset=1'>[stars("Reset - Lockdown")]</A>"
		else
			d1 = "<A href='?src=\ref[src];alarm=1'>[stars("Alarm - Lockdown")]</A>"
		if(src.timing)
			d2 = "<A href='?src=\ref[src];time=0'>[stars("Stop Time Lock")]</A>"
		else
			d2 = "<A href='?src=\ref[src];time=1'>[stars("Initiate Time Lock")]</A>"
		var/second = round(src.time) % 60
		var/minute = (round(src.time) - second) / 60
		var/dat = "<HTML><HEAD></HEAD><BODY><TT><B>[stars("Fire alarm")]</B> [d1]\n<HR><b>The current alert level is: [stars(GLOBL.security_level.name)]</b><br><br>\nTimer System: [d2]<BR>\nTime Left: [(minute ? "[minute]:" : null)][second] <A href='?src=\ref[src];tp=-30'>-</A> <A href='?src=\ref[src];tp=-1'>-</A> <A href='?src=\ref[src];tp=1'>+</A> <A href='?src=\ref[src];tp=30'>+</A>\n</TT></BODY></HTML>"
		user << browse(dat, "window=firealarm")
		onclose(user, "firealarm")

/obj/machinery/firealarm/Topic(href, href_list)
	..()
	if(usr.stat || stat & (BROKEN|NOPOWER))
		return

	if(buildstage != 2)
		return

	if((usr.contents.Find(src) || (get_dist(src, usr) <= 1 && isturf(src.loc))) || issilicon(usr))
		usr.set_machine(src)
		if(href_list["reset"])
			src.reset()
		else if(href_list["alarm"])
			src.alarm()
		else if(href_list["time"])
			src.timing = text2num(href_list["time"])
			last_process = world.timeofday
			GLOBL.processing_objects.Add(src)
		else if(href_list["tp"])
			var/tp = text2num(href_list["tp"])
			src.time += tp
			src.time = min(max(round(src.time), 0), 120)

		src.updateUsrDialog()

		src.add_fingerprint(usr)
	else
		usr << browse(null, "window=firealarm")
		return

/obj/machinery/firealarm/proc/reset()
	if(!src.working)
		return
	var/area/A = src.loc
	A = A.loc
	if(!isarea(A))
		return
	A.firereset()
	update_icon()

/obj/machinery/firealarm/proc/alarm()
	if(!src.working)
		return
	var/area/A = src.loc
	A = A.loc
	if(!isarea(A))
		return
	A.firealert()
	update_icon()
	//playsound(src, 'sound/ambience/signal.ogg', 75, 0)

/obj/machinery/firealarm/New(loc, dir, building)
	..()
	if(loc)
		src.loc = loc

	if(dir)
		src.set_dir(dir)

	if(building)
		buildstage = 0
		wiresexposed = 1
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -24 : 24)
		pixel_y = (dir & 3)? (dir ==1 ? -24 : 24) : 0

/obj/machinery/firealarm/initialize()
	. = ..()
	if(isContactLevel(z))
		if(!isnull(GLOBL.security_level))
			src.overlays.Add(image('icons/obj/monitors.dmi', "overlay_[GLOBL.security_level.name]"))
		else
			src.overlays.Add(image('icons/obj/monitors.dmi', "overlay_green"))

	update_icon()

/*
FIRE ALARM CIRCUIT
Just a object used in constructing fire alarms
*/
/obj/item/weapon/firealarm_electronics
	name = "fire alarm electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	desc = "A circuit. It has a label on it, it says \"Can handle heat levels up to 40 degrees celsius!\""
	w_class = 2.0
	matter_amounts = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)


/obj/machinery/partyalarm
	name = "\improper PARTY BUTTON"
	desc = "Cuban Pete is in the house!"
	icon = 'icons/obj/monitors.dmi'
	icon_state = "fire0"

	anchored = TRUE
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 6

	var/detecting = 1.0
	var/working = 1.0
	var/time = 10.0
	var/timing = 0.0
	var/lockdownbyai = 0

/obj/machinery/partyalarm/attack_paw(mob/user as mob)
	return attack_hand(user)

/obj/machinery/partyalarm/attack_hand(mob/user as mob)
	if(user.stat || stat & (NOPOWER|BROKEN))
		return

	usr.set_machine(src)
	var/area/A = get_area(src)
	ASSERT(isarea(A))
	//if(A.master)
		//A = A.master
	var/d1
	var/d2
	if(ishuman(user) || issilicon(user))
		if(A.party)
			d1 = "<A href='?src=\ref[src];reset=1'>No Party :(</A>"
		else
			d1 = "<A href='?src=\ref[src];alarm=1'>PARTY!!!</A>"
		if(timing)
			d2 = "<A href='?src=\ref[src];time=0'>Stop Time Lock</A>"
		else
			d2 = "<A href='?src=\ref[src];time=1'>Initiate Time Lock</A>"
		var/second = time % 60
		var/minute = (time - second) / 60
		var/dat = "<HTML><HEAD></HEAD><BODY><TT><B>Party Button</B> [d1]\n<HR>\nTimer System: [d2]<BR>\nTime Left: [(minute ? "[minute]:" : null)][second] <A href='?src=\ref[src];tp=-30'>-</A> <A href='?src=\ref[src];tp=-1'>-</A> <A href='?src=\ref[src];tp=1'>+</A> <A href='?src=\ref[src];tp=30'>+</A>\n</TT></BODY></HTML>"
		user << browse(dat, "window=partyalarm")
		onclose(user, "partyalarm")
	else
		if(A.fire)
			d1 = "<A href='?src=\ref[src];reset=1'>[stars("No Party :(")]</A>"
		else
			d1 = "<A href='?src=\ref[src];alarm=1'>[stars("PARTY!!!")]</A>"
		if(timing)
			d2 = "<A href='?src=\ref[src];time=0'>[stars("Stop Time Lock")]</A>"
		else
			d2 = "<A href='?src=\ref[src];time=1'>[stars("Initiate Time Lock")]</A>"
		var/second = time % 60
		var/minute = (time - second) / 60
		var/dat = "<HTML><HEAD></HEAD><BODY><TT><B>[stars("Party Button")]</B> [d1]\n<HR>\nTimer System: [d2]<BR>\nTime Left: [(minute ? "[minute]:" : null)][second] <A href='?src=\ref[src];tp=-30'>-</A> <A href='?src=\ref[src];tp=-1'>-</A> <A href='?src=\ref[src];tp=1'>+</A> <A href='?src=\ref[src];tp=30'>+</A>\n</TT></BODY></HTML>"
		user << browse(dat, "window=partyalarm")
		onclose(user, "partyalarm")

/obj/machinery/partyalarm/proc/reset()
	if(!working)
		return
	var/area/A = get_area(src)
	ASSERT(isarea(A))
	//if(A.master)
		//A = A.master
	A.partyreset()

/obj/machinery/partyalarm/proc/alarm()
	if(!working)
		return
	var/area/A = get_area(src)
	ASSERT(isarea(A))
	//if(A.master)
		//A = A.master
	A.partyalert()

/obj/machinery/partyalarm/Topic(href, href_list)
	..()
	if(usr.stat || stat & (BROKEN|NOPOWER))
		return
	if((usr.contents.Find(src) || (get_dist(src, usr) <= 1 && isturf(loc))) || issilicon(usr))
		usr.machine = src
		if(href_list["reset"])
			reset()
		else
			if(href_list["alarm"])
				alarm()
			else
				if(href_list["time"])
					timing = text2num(href_list["time"])
				else
					if(href_list["tp"])
						var/tp = text2num(href_list["tp"])
						time += tp
						time = min(max(round(time), 0), 120)
		updateUsrDialog()

		add_fingerprint(usr)
	else
		usr << browse(null, "window=partyalarm")
		return

#undef MAX_TEMPERATURE
#undef MIN_TEMPERATURE

#undef MAX_ENERGY_CHANGE

#undef RCON_NO
#undef RCON_AUTO
#undef RCON_YES

#undef AALARM_MODE_REPLACEMENT
#undef AALARM_MODE_CYCLE
#undef AALARM_MODE_FILL
#undef AALARM_MODE_OFF

#undef AALARM_WIRE_IDSCAN
#undef AALARM_WIRE_POWER
#undef AALARM_WIRE_SYPHON
#undef AALARM_WIRE_AI_CONTROL
#undef AALARM_WIRE_AALARM