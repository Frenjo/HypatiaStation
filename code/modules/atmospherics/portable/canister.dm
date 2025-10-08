#define CANISTER_FLAG_NONE				BITFLAG(0) // No update needed.
#define CANISTER_FLAG_HOLDING			BITFLAG(1) // holding
#define CANISTER_FLAG_CONNECTED			BITFLAG(2) // connected_port
#define CANISTER_FLAG_PRESSURE_10		BITFLAG(3) // tank_pressure < 10
#define CANISTER_FLAG_PRESSURE_ATMOS	BITFLAG(4) // tank_pressure < ONE_ATMOS
#define CANISTER_FLAG_PRESSURE_15_ATMOS	BITFLAG(5) // tank_pressure < (15 * ONE_ATMOS)
#define CANISTER_FLAG_PRESSURE_BOOM		BITFLAG(6) // tank_pressure go boom.
/obj/machinery/portable_atmospherics/canister
	name = "canister"
	icon = 'icons/obj/atmospherics/canister.dmi'
	icon_state = "yellow"
	density = TRUE
	obj_flags = OBJ_FLAG_CONDUCT

	pressure_resistance = 7 * ONE_ATMOSPHERE
	volume = 1000

	power_state = USE_POWER_OFF

	var/health = 100.0

	var/valve_open = FALSE
	var/release_pressure = ONE_ATMOSPHERE

	var/canister_color = "yellow"
	var/can_label = TRUE
	var/filled = 0.5
	var/temperature_resistance = 1000 + T0C
	var/release_log = ""
	var/update_flags = CANISTER_FLAG_NONE

	var/static/list/all_colours = list(
		"\[O2\]" = "bluews",
		"\[N2\]" = "red",
		"\[Air\]" = "grey",
		"\[H2\]" = "green",
		"\[CO2\]" = "black",
		"\[Toxin (Bio)\]" = "orange",
		"\[O2/TOX\]" = "orangews2",
		"\[O2-Agent-B\]" = "orangebs",
		"\[N2O\]" = "redws2",
		"\[CAUTION\]" = "yellow",
		"\[Blue\]" = "blue",
		"\[Blue 2Stripe\]" = "bluews2",
		"\[Cyan\]" = "cyan",
		"\[Cyan 1Stripe\]" = "cyanws",
		"\[Red 1Stripe\]" = "redws",
		"\[Orange 1Stripe\]" = "orangews",
		"\[Orange 2Stripe-B\]" = "orangebs2",
		"\[Light Purple\]" = "lightpurple",
		"\[Medium Purple\]" = "medpurple",
		"\[Dark Purple\]" = "darkpurple",
		"\[Rainbow\]" = "rainbow",
	)

/obj/machinery/portable_atmospherics/canister/proc/check_change()
	var/old_flag = update_flags
	update_flags = CANISTER_FLAG_NONE
	if(isnotnull(holding))
		update_flags |= CANISTER_FLAG_HOLDING
	if(connected_port)
		update_flags |= CANISTER_FLAG_CONNECTED

	var/tank_pressure = air_contents.return_pressure()
	if(tank_pressure < 10)
		update_flags |= CANISTER_FLAG_PRESSURE_10
	else if(tank_pressure < ONE_ATMOSPHERE)
		update_flags |= CANISTER_FLAG_PRESSURE_ATMOS
	else if(tank_pressure < (15 * ONE_ATMOSPHERE))
		update_flags |= CANISTER_FLAG_PRESSURE_15_ATMOS
	else
		update_flags |= CANISTER_FLAG_PRESSURE_BOOM

	if(update_flags == old_flag)
		return FALSE
	else
		return TRUE

/obj/machinery/portable_atmospherics/canister/update_icon()
	if(destroyed)
		cut_overlays()
		icon_state = "[canister_color]-1"
		return

	if(icon_state != "[canister_color]")
		icon_state = "[canister_color]"

	if(!check_change()) // Returns FALSE if no change to icons is needed.
		return

	cut_overlays()

	if(update_flags & CANISTER_FLAG_HOLDING)
		add_overlay("can-open")
	if(update_flags & CANISTER_FLAG_CONNECTED)
		add_overlay("can-connector")
	if(update_flags & CANISTER_FLAG_PRESSURE_10)
		add_overlay("can-o0")
	if(update_flags & CANISTER_FLAG_PRESSURE_ATMOS)
		add_overlay("can-o1")
	else if(update_flags & CANISTER_FLAG_PRESSURE_15_ATMOS)
		add_overlay("can-o2")
	else if(update_flags & CANISTER_FLAG_PRESSURE_BOOM)
		add_overlay("can-o3")
#undef CANISTER_FLAG_PRESSURE_BOOM
#undef CANISTER_FLAG_PRESSURE_15_ATMOS
#undef CANISTER_FLAG_PRESSURE_ATMOS
#undef CANISTER_FLAG_PRESSURE_10
#undef CANISTER_FLAG_CONNECTED
#undef CANISTER_FLAG_HOLDING
#undef CANISTER_FLAG_NONE

/obj/machinery/portable_atmospherics/canister/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > temperature_resistance)
		health -= 5
		healthcheck()

/obj/machinery/portable_atmospherics/canister/proc/healthcheck()
	if(destroyed)
		return

	if(health <= 10)
		var/atom/location = loc
		location.assume_air(air_contents)

		destroyed = TRUE
		playsound(src, 'sound/effects/spray.ogg', 10, 1, -3)
		density = FALSE
		update_icon()

		if(isnotnull(holding))
			holding.forceMove(loc)
			holding = null

/obj/machinery/portable_atmospherics/canister/process()
	if(destroyed)
		return PROCESS_KILL

	..()

	if(valve_open)
		var/datum/gas_mixture/environment
		if(isnotnull(holding))
			environment = holding.air_contents
		else
			environment = loc.return_air()

		var/env_pressure = environment.return_pressure()
		var/pressure_delta = min(release_pressure - env_pressure, (air_contents.return_pressure() - env_pressure) / 2)
		//Can not have a pressure delta that would cause environment pressure > tank pressure

		var/transfer_moles = 0
		if(air_contents.temperature > 0 && pressure_delta > 0)
			transfer_moles = pressure_delta * environment.volume / (air_contents.temperature * R_IDEAL_GAS_EQUATION)

			//Actually transfer the gas
			var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)

			if(isnotnull(holding))
				environment.merge(removed)
			else
				loc.assume_air(removed)
			update_icon()

	if(air_contents.return_pressure() < 1)
		can_label = TRUE
	else
		can_label = FALSE

	if(air_contents.temperature > PLASMA_FLASHPOINT)
		air_contents.zburn()

/obj/machinery/portable_atmospherics/canister/return_air()
	return air_contents

/obj/machinery/portable_atmospherics/canister/proc/return_temperature()
	var/datum/gas_mixture/air = return_air()
	if(air?.volume > 0)
		return air.temperature
	return 0

/obj/machinery/portable_atmospherics/canister/proc/return_pressure()
	var/datum/gas_mixture/air = return_air()
	if(air?.volume > 0)
		return air.return_pressure()
	return 0

/obj/machinery/portable_atmospherics/canister/blob_act()
	health -= 200
	healthcheck()

/obj/machinery/portable_atmospherics/canister/bullet_act(obj/projectile/bullet)
	if(bullet.damage_type == BRUTE || bullet.damage_type == BURN)
		if(bullet.damage)
			health -= round(bullet.damage / 2)
			healthcheck()
	return ..()

/obj/machinery/portable_atmospherics/canister/meteorhit(obj/O)
	health = 0
	healthcheck()

/obj/machinery/portable_atmospherics/canister/attackby(obj/item/W, mob/user)
	if(!iswrench(W) && !istype(W, /obj/item/tank) && !istype(W, /obj/item/gas_analyser) && !istype(W, /obj/item/pda))
		visible_message(SPAN_WARNING("[user] hits the [src] with a [W]!"))
		health -= W.force
		add_fingerprint(user)
		healthcheck()

	if(isrobot(user) && istype(W, /obj/item/tank/jetpack))
		var/datum/gas_mixture/thejetpack = W:air_contents
		var/env_pressure = thejetpack.return_pressure()
		var/pressure_delta = min(10 * ONE_ATMOSPHERE - env_pressure, (air_contents.return_pressure() - env_pressure) / 2)
		//Can not have a pressure delta that would cause environment pressure > tank pressure
		var/transfer_moles = 0
		if((air_contents.temperature > 0) && (pressure_delta > 0))
			transfer_moles = pressure_delta * thejetpack.volume / (air_contents.temperature * R_IDEAL_GAS_EQUATION)//Actually transfer the gas
			var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)
			thejetpack.merge(removed)
			to_chat(user, "You pulse-pressurize your jetpack from the tank.")
		return

	..()

	global.PCnanoui.update_uis(src) // Update all NanoUIs attached to src

/obj/machinery/portable_atmospherics/canister/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/portable_atmospherics/canister/attack_paw(mob/user)
	return attack_hand(user)

/obj/machinery/portable_atmospherics/canister/attack_hand(mob/user)
	return ui_interact(user)

/obj/machinery/portable_atmospherics/canister/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null)
	if(destroyed)
		return

	// this is the data which will be sent to the ui
	var/alist/data = alist(
		"name" = name,
		"canLabel" = can_label,
		"portConnected" = isnotnull(connected_port),
		"tankPressure" = round(air_contents.return_pressure()),
		"releasePressure" = round(release_pressure),
		"minReleasePressure" = round(ONE_ATMOSPHERE / 10),
		"maxReleasePressure" = round(10 * ONE_ATMOSPHERE),
		"valveOpen" = valve_open,
		"hasHoldingTank" = isnotnull(holding)
	)
	if(isnotnull(holding))
		data["holdingTank"] = alist("name" = holding.name, "tankPressure" = round(holding.air_contents.return_pressure()))

	// update the ui if it exists, returns null if no ui is passed/found
	ui = global.PCnanoui.try_update_ui(user, src, ui_key, ui, data)
	if(isnull(ui))
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new /datum/nanoui(user, src, ui_key, "canister.tmpl", "Canister", 480, 400)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update()

/obj/machinery/portable_atmospherics/canister/handle_topic(mob/user, datum/topic_input/topic)
	. = ..()
	// Do not use "if(!.) return FALSE" here or canisters will stop working in unpowered areas like space or on the derelict!
	if(!isturf(loc))
		return FALSE

	if(topic.has("toggle"))
		if(valve_open)
			if(isnotnull(holding))
				release_log += "Valve was <b>closed</b> by [user] ([user.ckey]), stopping the transfer into the [holding]<br>"
			else
				release_log += "Valve was <b>closed</b> by [user] ([user.ckey]), stopping the transfer into the [SPAN_DANGER("air")]<br>"
		else
			if(isnotnull(holding))
				release_log += "Valve was <b>opened</b> by [user] ([user.ckey]), starting the transfer into the [holding]<br>"
			else
				release_log += "Valve was <b>opened</b> by [user] ([user.ckey]), starting the transfer into the [SPAN_DANGER("air")]<br>"
		valve_open = !valve_open

	if(topic.has("remove_tank"))
		if(isnotnull(holding))
			if(istype(holding, /obj/item/tank))
				holding.manipulated_by = user.real_name
			holding.forceMove(loc)
			holding = null

	if(topic.has("pressure_adj"))
		var/diff = topic.get_num("pressure_adj")
		if(diff > 0)
			release_pressure = min(10 * ONE_ATMOSPHERE, release_pressure + diff)
		else
			release_pressure = max(ONE_ATMOSPHERE / 10, release_pressure + diff)

	if(topic.has("relabel"))
		if(can_label)
			var/label = input("Choose canister label", "Gas Canister") as null | anything in all_colours
			if(isnotnull(label))
				canister_color = all_colours[label]
				icon_state = all_colours[label]
				name = "Canister: [label]"

	add_fingerprint(user)
	update_icon()

// Edited canister icon names to be more consistent, and added a few more. -Frenjo
// Oxygen
/obj/machinery/portable_atmospherics/canister/oxygen
	name = "canister: \[O2\]"
	icon_state = "bluews"
	canister_color = "bluews"
	can_label = FALSE

/obj/machinery/portable_atmospherics/canister/oxygen/initialise()
	. = ..()
	air_contents.adjust_gas(/decl/xgm_gas/oxygen, (maximum_pressure * filled) * air_contents.volume / (R_IDEAL_GAS_EQUATION * air_contents.temperature))
	update_icon()

// Nitrogen
/obj/machinery/portable_atmospherics/canister/nitrogen
	name = "canister: \[N2\]"
	icon_state = "red"
	canister_color = "red"
	can_label = FALSE

/obj/machinery/portable_atmospherics/canister/nitrogen/initialise()
	. = ..()
	air_contents.adjust_gas(/decl/xgm_gas/nitrogen, (maximum_pressure * filled) * air_contents.volume / (R_IDEAL_GAS_EQUATION * air_contents.temperature))
	update_icon()

// Mixed Air
/obj/machinery/portable_atmospherics/canister/air
	name = "canister \[Air\]"
	icon_state = "grey"
	canister_color = "grey"
	can_label = FALSE

/obj/machinery/portable_atmospherics/canister/air/initialise()
	. = ..()
	air_contents.adjust_multi(
		/decl/xgm_gas/oxygen, (O2STANDARD * maximum_pressure * filled) * air_contents.volume / (R_IDEAL_GAS_EQUATION * air_contents.temperature),
		/decl/xgm_gas/nitrogen, (N2STANDARD * maximum_pressure * filled) * air_contents.volume / (R_IDEAL_GAS_EQUATION * air_contents.temperature)
	)
	update_icon()

// Hydrogen
/obj/machinery/portable_atmospherics/canister/hydrogen
	name = "canister: \[H2\]"
	icon_state = "green"
	canister_color = "green"
	can_label = FALSE

/obj/machinery/portable_atmospherics/canister/hydrogen/initialise()
	. = ..()
	air_contents.adjust_gas(/decl/xgm_gas/hydrogen, (maximum_pressure * filled) * air_contents.volume / (R_IDEAL_GAS_EQUATION * air_contents.temperature))
	update_icon()

// Carbon Dioxide
/obj/machinery/portable_atmospherics/canister/carbon_dioxide
	name = "canister \[CO2\]"
	icon_state = "black"
	canister_color = "black"
	can_label = FALSE

/obj/machinery/portable_atmospherics/canister/carbon_dioxide/initialise()
	. = ..()
	air_contents.adjust_gas(/decl/xgm_gas/carbon_dioxide, (maximum_pressure * filled) * air_contents.volume / (R_IDEAL_GAS_EQUATION * air_contents.temperature))
	update_icon()

// Plasma
/obj/machinery/portable_atmospherics/canister/toxins
	name = "canister \[Toxin (Bio)\]"
	icon_state = "orange"
	canister_color = "orange"
	can_label = FALSE

/obj/machinery/portable_atmospherics/canister/toxins/initialise()
	. = ..()
	air_contents.adjust_gas(/decl/xgm_gas/plasma, (maximum_pressure * filled) * air_contents.volume / (R_IDEAL_GAS_EQUATION * air_contents.temperature))
	update_icon()

// Oxygen + Plasma Mix
// Added this because of updated atmos stuff. -Frenjo
/obj/machinery/portable_atmospherics/canister/oxygen_toxins
	name = "canister \[O2/TOX\]"
	icon_state = "orangews2"
	canister_color = "orangews2"
	can_label = FALSE

/obj/machinery/portable_atmospherics/canister/oxygen_toxins/initialise()
	. = ..()
	// This has a 75/25 plasma/oxygen mixture. -Frenjo
	air_contents.adjust_multi(
		/decl/xgm_gas/oxygen, (maximum_pressure * filled / 0.25) * air_contents.volume / (R_IDEAL_GAS_EQUATION * air_contents.temperature),
		/decl/xgm_gas/plasma, (maximum_pressure * filled / 0.75) * air_contents.volume / (R_IDEAL_GAS_EQUATION * air_contents.temperature)
	)
	update_icon()

// Oxygen Agent-B
// Added this because I'm curious. -Frenjo
/obj/machinery/portable_atmospherics/canister/oxygen_agent_b
	name = "canister \[Oxygen Agent-B\]"
	icon_state = "orangebs"
	canister_color = "orangebs"
	can_label = FALSE

/obj/machinery/portable_atmospherics/canister/oxygen_agent_b/initialise()
	. = ..()
	air_contents.adjust_gas(/decl/xgm_gas/oxygen_agent_b, (maximum_pressure * filled) * air_contents.volume / (R_IDEAL_GAS_EQUATION * air_contents.temperature))
	update_icon()

// Nitrous Oxide
/obj/machinery/portable_atmospherics/canister/nitrous_oxide
	name = "canister: \[N2O\]"
	icon_state = "redws2"
	canister_color = "redws2"
	can_label = FALSE

/obj/machinery/portable_atmospherics/canister/nitrous_oxide/initialise()
	. = ..()
	air_contents.adjust_gas(/decl/xgm_gas/nitrous_oxide, (maximum_pressure * filled) * air_contents.volume / (R_IDEAL_GAS_EQUATION * air_contents.temperature))
	update_icon()