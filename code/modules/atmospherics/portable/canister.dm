/obj/machinery/portable_atmospherics/canister
	name = "canister"
	icon = 'icons/obj/canister.dmi'
	icon_state = "yellow"
	density = TRUE
	flags = CONDUCT

	pressure_resistance = 7 * ONE_ATMOSPHERE
	volume = 1000
	use_power = FALSE

	var/health = 100.0

	var/valve_open = FALSE
	var/release_pressure = ONE_ATMOSPHERE

	var/canister_color = "yellow"
	var/can_label = TRUE
	var/filled = 0.5
	var/temperature_resistance = 1000 + T0C
	var/release_log = ""
	var/update_flag = 0

/obj/machinery/portable_atmospherics/canister/proc/check_change()
	var/old_flag = update_flag
	update_flag = 0
	if(holding)
		update_flag |= 1
	if(connected_port)
		update_flag |= 2

	var/tank_pressure = air_contents.return_pressure()
	if(tank_pressure < 10)
		update_flag |= 4
	else if(tank_pressure < ONE_ATMOSPHERE)
		update_flag |= 8
	else if(tank_pressure < 15 * ONE_ATMOSPHERE)
		update_flag |= 16
	else
		update_flag |= 32

	if(update_flag == old_flag)
		return 1
	else
		return 0

/obj/machinery/portable_atmospherics/canister/update_icon()
/*
update_flag
1 = holding
2 = connected_port
4 = tank_pressure < 10
8 = tank_pressure < ONE_ATMOS
16 = tank_pressure < 15*ONE_ATMOS
32 = tank_pressure go boom.
*/

	if(src.destroyed)
		src.overlays = 0
		src.icon_state = "[src.canister_color]-1"

	if(icon_state != "[canister_color]")
		icon_state = "[canister_color]"

	if(check_change()) //Returns 1 if no change needed to icons.
		return

	src.overlays = 0

	if(update_flag & 1)
		overlays.Add("can-open")
	if(update_flag & 2)
		overlays.Add("can-connector")
	if(update_flag & 4)
		overlays.Add("can-o0")
	if(update_flag & 8)
		overlays.Add("can-o1")
	else if(update_flag & 16)
		overlays.Add("can-o2")
	else if(update_flag & 32)
		overlays.Add("can-o3")
	return

/obj/machinery/portable_atmospherics/canister/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > temperature_resistance)
		health -= 5
		healthcheck()

/obj/machinery/portable_atmospherics/canister/proc/healthcheck()
	if(destroyed)
		return 1

	if(src.health <= 10)
		var/atom/location = src.loc
		location.assume_air(air_contents)

		src.destroyed = TRUE
		playsound(src, 'sound/effects/spray.ogg', 10, 1, -3)
		src.density = FALSE
		update_icon()

		if(src.holding)
			src.holding.loc = src.loc
			src.holding = null

		return 1
	else
		return 1

/obj/machinery/portable_atmospherics/canister/process()
	if(destroyed)
		return

	..()

	if(valve_open)
		var/datum/gas_mixture/environment
		if(holding)
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

			if(holding)
				environment.merge(removed)
			else
				loc.assume_air(removed)
			src.update_icon()

	if(air_contents.return_pressure() < 1)
		can_label = TRUE
	else
		can_label = FALSE

	if(air_contents.temperature > PLASMA_FLASHPOINT)
		air_contents.zburn()
	return

/obj/machinery/portable_atmospherics/canister/return_air()
	return air_contents

/obj/machinery/portable_atmospherics/canister/proc/return_temperature()
	var/datum/gas_mixture/GM = src.return_air()
	if(GM && GM.volume > 0)
		return GM.temperature
	return 0

/obj/machinery/portable_atmospherics/canister/proc/return_pressure()
	var/datum/gas_mixture/GM = src.return_air()
	if(GM && GM.volume > 0)
		return GM.return_pressure()
	return 0

/obj/machinery/portable_atmospherics/canister/blob_act()
	src.health -= 200
	healthcheck()
	return

/obj/machinery/portable_atmospherics/canister/bullet_act(obj/item/projectile/Proj)
	if(Proj.damage)
		src.health -= round(Proj.damage / 2)
		healthcheck()
	..()

/obj/machinery/portable_atmospherics/canister/meteorhit(obj/O as obj)
	src.health = 0
	healthcheck()
	return

/obj/machinery/portable_atmospherics/canister/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(!istype(W, /obj/item/weapon/wrench) && !istype(W, /obj/item/weapon/tank) && !istype(W, /obj/item/device/analyzer) && !istype(W, /obj/item/device/pda))
		visible_message(SPAN_WARNING("[user] hits the [src] with a [W]!"))
		src.health -= W.force
		src.add_fingerprint(user)
		healthcheck()

	if(isrobot(user) && istype(W, /obj/item/weapon/tank/jetpack))
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

	nanomanager.update_uis(src) // Update all NanoUIs attached to src

/obj/machinery/portable_atmospherics/canister/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/portable_atmospherics/canister/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/portable_atmospherics/canister/attack_hand(mob/user as mob)
	return src.ui_interact(user)

/obj/machinery/portable_atmospherics/canister/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null)
	if(src.destroyed)
		return

	// this is the data which will be sent to the ui
	var/list/data = list()
	data["name"] = name
	data["canLabel"] = can_label ? TRUE : FALSE
	data["portConnected"] = connected_port ? TRUE : FALSE
	data["tankPressure"] = round(air_contents.return_pressure() ? air_contents.return_pressure() : 0)
	data["releasePressure"] = round(release_pressure ? release_pressure : 0)
	data["minReleasePressure"] = round(ONE_ATMOSPHERE / 10)
	data["maxReleasePressure"] = round(10 * ONE_ATMOSPHERE)
	data["valveOpen"] = valve_open ? TRUE : FALSE

	data["hasHoldingTank"] = holding ? TRUE : FALSE
	if(holding)
		data["holdingTank"] = list("name" = holding.name, "tankPressure" = round(holding.air_contents.return_pressure()))

	// update the ui if it exists, returns null if no ui is passed/found
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data)
	if(isnull(ui))
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "canister.tmpl", "Canister", 480, 400)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update()

/obj/machinery/portable_atmospherics/canister/Topic(href, href_list)
	//Do not use "if(..()) return" here, canisters will stop working in unpowered areas like space or on the derelict.
	if(!isturf(src.loc))
		return 0

	if(href_list["toggle"])
		if(valve_open)
			if(holding)
				release_log += "Valve was <b>closed</b> by [usr] ([usr.ckey]), stopping the transfer into the [holding]<br>"
			else
				release_log += "Valve was <b>closed</b> by [usr] ([usr.ckey]), stopping the transfer into the <font color='red'><b>air</b></font><br>"
		else
			if(holding)
				release_log += "Valve was <b>opened</b> by [usr] ([usr.ckey]), starting the transfer into the [holding]<br>"
			else
				release_log += "Valve was <b>opened</b> by [usr] ([usr.ckey]), starting the transfer into the <font color='red'><b>air</b></font><br>"
		valve_open = !valve_open

	if(href_list["remove_tank"])
		if(holding)
			if(istype(holding, /obj/item/weapon/tank))
				holding.manipulated_by = usr.real_name
			holding.loc = loc
			holding = null

	if(href_list["pressure_adj"])
		var/diff = text2num(href_list["pressure_adj"])
		if(diff > 0)
			release_pressure = min(10 * ONE_ATMOSPHERE, release_pressure + diff)
		else
			release_pressure = max(ONE_ATMOSPHERE / 10, release_pressure + diff)

	if(href_list["relabel"])
		if(can_label)
			// Edited these to be consistent with above changes.
			// And add the new options. -Frenjo
			var/list/colors = list(
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
			var/label = input("Choose canister label", "Gas Canister") as null | anything in colors
			if(label)
				src.canister_color = colors[label]
				src.icon_state = colors[label]
				src.name = "Canister: [label]"

	src.add_fingerprint(usr)
	update_icon()

	return 1

// Edited canister icon names to be more consistent, and added a few more. -Frenjo
// Oxygen
/obj/machinery/portable_atmospherics/canister/oxygen
	name = "Canister: \[O2\]"
	icon_state = "bluews"
	canister_color = "bluews"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/oxygen/New()
	..()
	src.air_contents.adjust_gas(GAS_OXYGEN, (src.maximum_pressure * filled) * air_contents.volume / (R_IDEAL_GAS_EQUATION * air_contents.temperature))
	src.update_icon()

// Nitrogen
/obj/machinery/portable_atmospherics/canister/nitrogen
	name = "Canister: \[N2\]"
	icon_state = "red"
	canister_color = "red"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/nitrogen/New()
	..()
	src.air_contents.adjust_gas(GAS_NITROGEN, (src.maximum_pressure * filled) * air_contents.volume / (R_IDEAL_GAS_EQUATION * air_contents.temperature))
	src.update_icon()

// Mixed Air
/obj/machinery/portable_atmospherics/canister/air
	name = "Canister \[Air\]"
	icon_state = "grey"
	canister_color = "grey"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/air/New()
	..()
	src.air_contents.adjust_multi(
		GAS_OXYGEN, (O2STANDARD * src.maximum_pressure * filled) * air_contents.volume / (R_IDEAL_GAS_EQUATION * air_contents.temperature),
		GAS_NITROGEN, (N2STANDARD * src.maximum_pressure * filled) * air_contents.volume / (R_IDEAL_GAS_EQUATION * air_contents.temperature)
	)
	src.update_icon()

// Hydrogen
/obj/machinery/portable_atmospherics/canister/hydrogen
	name = "Canister: \[H2\]"
	icon_state = "green"
	canister_color = "green"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/hydrogen/New()
	..()
	src.air_contents.adjust_gas(GAS_HYDROGEN, (src.maximum_pressure * filled) * air_contents.volume / (R_IDEAL_GAS_EQUATION * air_contents.temperature))
	src.update_icon()

// Carbon Dioxide
/obj/machinery/portable_atmospherics/canister/carbon_dioxide
	name = "Canister \[CO2\]"
	icon_state = "black"
	canister_color = "black"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/carbon_dioxide/New()
	..()
	src.air_contents.adjust_gas(GAS_CARBON_DIOXIDE, (src.maximum_pressure * filled) * air_contents.volume / (R_IDEAL_GAS_EQUATION * air_contents.temperature))
	src.update_icon()

// Plasma
/obj/machinery/portable_atmospherics/canister/toxins
	name = "Canister \[Toxin (Bio)\]"
	icon_state = "orange"
	canister_color = "orange"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/toxins/New()
	..()
	src.air_contents.adjust_gas(GAS_PLASMA, (src.maximum_pressure * filled) * air_contents.volume / (R_IDEAL_GAS_EQUATION * air_contents.temperature))
	src.update_icon()

// Oxygen + Plasma Mix
// Added this because of updated atmos stuff. -Frenjo
/obj/machinery/portable_atmospherics/canister/oxygen_toxins
	name = "Canister \[O2/TOX\]"
	icon_state = "orangews2"
	canister_color = "orangews2"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/oxygen_toxins/New()
	..()
	// This has a 75/25 plasma/oxygen mixture. -Frenjo
	src.air_contents.adjust_multi(
		GAS_OXYGEN, (src.maximum_pressure * filled / 0.25) * air_contents.volume / (R_IDEAL_GAS_EQUATION * air_contents.temperature),
		GAS_PLASMA, (src.maximum_pressure * filled / 0.75) * air_contents.volume / (R_IDEAL_GAS_EQUATION * air_contents.temperature)
	)
	src.update_icon()

// Oxygen Agent-B
// Added this because I'm curious. -Frenjo
/obj/machinery/portable_atmospherics/canister/oxygen_agent_b
	name = "Canister \[Oxygen Agent-B\]"
	icon_state = "orangebs"
	canister_color = "orangebs"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/oxygen_agent_b/New()
	..()
	air_contents.adjust_gas(GAS_OXYGEN_AGENT_B, (src.maximum_pressure * filled) * air_contents.volume / (R_IDEAL_GAS_EQUATION * air_contents.temperature))
	src.update_icon()

// Nitrous Oxide
/obj/machinery/portable_atmospherics/canister/sleeping_agent
	name = "Canister: \[N2O\]"
	icon_state = "redws2"
	canister_color = "redws2"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/sleeping_agent/New()
	..()
	air_contents.adjust_gas(GAS_SLEEPING_AGENT, (src.maximum_pressure * filled) * air_contents.volume / (R_IDEAL_GAS_EQUATION * air_contents.temperature))
	src.update_icon()

//Dirty way to fill room with gas. However it is a bit easier to do than creating some floor/engine/n2o -rastaf0
/obj/machinery/portable_atmospherics/canister/sleeping_agent/roomfiller/New()
	..()
	air_contents.gas[GAS_SLEEPING_AGENT] = 9 * 4000
	src.update_icon()

/obj/machinery/portable_atmospherics/canister/sleep_agent/roomfiller/initialize()
	. = ..()
	var/turf/simulated/location = src.loc
	if(istype(src.loc))
		while(!location.air)
			sleep(10)
		location.assume_air(air_contents)
		air_contents = new