//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
/*
 * Computer Frame
 */
/obj/structure/computerframe
	name = "computer-frame"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "0"

	density = TRUE
	anchored = FALSE

	var/state = 0
	var/obj/item/weapon/circuitboard/circuit = null
//	weight = 1.0E8

/obj/structure/computerframe/attackby(obj/item/P as obj, mob/user as mob)
	switch(state)
		if(0)
			if(istype(P, /obj/item/weapon/wrench))
				playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
				if(do_after(user, 20))
					to_chat(user, SPAN_INFO("You wrench the frame into place."))
					anchored = TRUE
					state = 1
			if(istype(P, /obj/item/weapon/weldingtool))
				var/obj/item/weapon/weldingtool/WT = P
				if(!WT.remove_fuel(0, user))
					to_chat(user, SPAN_WARNING("The welding tool must be on to complete this task."))
					return
				playsound(src, 'sound/items/Welder.ogg', 50, 1)
				if(do_after(user, 20))
					if(isnull(src) || !WT.isOn())
						return
					to_chat(user, SPAN_INFO("You deconstruct the frame."))
					new /obj/item/stack/sheet/metal(src.loc, 5)
					qdel(src)
		if(1)
			if(istype(P, /obj/item/weapon/wrench))
				playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
				if(do_after(user, 20))
					to_chat(user, SPAN_INFO("You unfasten the frame."))
					anchored = FALSE
					state = 0
			if(istype(P, /obj/item/weapon/circuitboard) && !circuit)
				var/obj/item/weapon/circuitboard/B = P
				if(B.board_type == "computer")
					playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
					to_chat(user, SPAN_INFO("You place the circuit board inside the frame."))
					icon_state = "1"
					circuit = P
					user.drop_item()
					P.loc = src
				else
					to_chat(user, SPAN_WARNING("This frame does not accept circuit boards of this type!"))
			if(istype(P, /obj/item/weapon/screwdriver) && circuit)
				playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
				to_chat(user, SPAN_INFO("You screw the circuit board into place."))
				state = 2
				icon_state = "2"
			if(istype(P, /obj/item/weapon/crowbar) && circuit)
				playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
				to_chat(user, SPAN_INFO("You remove the circuit board."))
				state = 1
				icon_state = "0"
				circuit.loc = src.loc
				circuit = null
		if(2)
			if(istype(P, /obj/item/weapon/screwdriver) && circuit)
				playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
				to_chat(user, SPAN_INFO("You unfasten the circuit board."))
				state = 1
				icon_state = "1"
			if(istype(P, /obj/item/stack/cable_coil))
				if(P:amount >= 5)
					playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
					if(do_after(user, 20))
						if(P)
							P:amount -= 5
							if(!P:amount)
								qdel(P)
							to_chat(user, SPAN_INFO("You add cables to the frame."))
							state = 3
							icon_state = "3"
		if(3)
			if(istype(P, /obj/item/weapon/wirecutters))
				playsound(src, 'sound/items/Wirecutter.ogg', 50, 1)
				to_chat(user, SPAN_INFO("You remove the cables."))
				state = 2
				icon_state = "2"
				var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil(loc)
				A.amount = 5

			if(istype(P, /obj/item/stack/sheet/glass))
				if(P:amount >= 2)
					playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
					if(do_after(user, 20))
						if(P)
							P:use(2)
							to_chat(user, SPAN_INFO("You put in the glass panel."))
							state = 4
							icon_state = "4"
		if(4)
			if(istype(P, /obj/item/weapon/crowbar))
				playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
				to_chat(user, SPAN_INFO("You remove the glass panel."))
				state = 3
				icon_state = "3"
				new /obj/item/stack/sheet/glass(loc, 2)
			if(istype(P, /obj/item/weapon/screwdriver))
				playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
				to_chat(user, SPAN_INFO("You connect the monitor."))
				var/B = new src.circuit.build_path(loc)
				if(circuit.powernet)
					B:powernet = circuit.powernet
				if(circuit.id)
					B:id = circuit.id
				if(circuit.records)
					B:records = circuit.records
				if(circuit.frequency)
					B:frequency = circuit.frequency
				if(istype(circuit, /obj/item/weapon/circuitboard/supplycomp))
					var/obj/machinery/computer/supplycomp/SC = B
					var/obj/item/weapon/circuitboard/supplycomp/C = circuit
					SC.can_order_contraband = C.contraband_enabled
				else if(istype(circuit, /obj/item/weapon/circuitboard/security))
					var/obj/machinery/computer/security/C = B
					var/obj/item/weapon/circuitboard/security/CB = circuit
					C.network = CB.network
				qdel(src)

/*
 * Circuit Board
 */
/obj/item/weapon/circuitboard
	name = "circuit board"
	icon = 'icons/obj/module.dmi'
	icon_state = "id_mod"
	item_state = "electronic"

	density = FALSE
	anchored = FALSE

	w_class = 2.0

	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2)

	var/id = null
	var/frequency = null
	var/build_path = null
	var/board_type = "computer"
	var/list/req_components = null
	var/powernet = null
	var/list/records = null
	var/frame_desc = null
	var/contain_parts = TRUE

/*
 * Circuit Board Types
 */
/obj/item/weapon/circuitboard/message_monitor
	name = "circuit board (Message Monitor)"
	build_path = /obj/machinery/computer/message_monitor
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3)

/obj/item/weapon/circuitboard/security
	name = "circuit board (Security)"
	req_access = list(ACCESS_SECURITY)
	build_path = /obj/machinery/computer/security

	var/network = list("SS13")
	var/locked = TRUE
	var/emagged = FALSE

/obj/item/weapon/circuitboard/security/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/card/emag))
		if(emagged)
			user << "Circuit lock is already removed."
			return
		user << "\blue You override the circuit lock and open controls."
		emagged = TRUE
		locked = FALSE
	else if(istype(I, /obj/item/weapon/card/id))
		if(emagged)
			user << "\red Circuit lock does not respond."
			return
		if(check_access(I))
			locked = !locked
			user << "\blue You [locked ? "" : "un"]lock the circuit controls."
		else
			FEEDBACK_ACCESS_DENIED(user)
	else if(istype(I, /obj/item/device/multitool))
		if(locked)
			user << "\red Circuit controls are locked."
			return
		var/existing_networks = jointext(network,",")
		var/input = strip_html(input(usr, "Which networks would you like to connect this camera console circuit to? Seperate networks with a comma. No Spaces!\nFor example: SS13,Security,Secret ", "Multitool-Circuitboard interface", existing_networks))
		if(!input)
			usr << "No input found please hang up and try your call again."
			return
		var/list/tempnetwork = splittext(input, ",")
		tempnetwork = difflist(tempnetwork, GLOBL.restricted_camera_networks, 1)
		if(!length(tempnetwork))
			usr << "No network found please hang up and try your call again."
			return
		network = tempnetwork

/obj/item/weapon/circuitboard/aicore
	name = "circuit board (AI core)"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_BIOTECH = 2)
	board_type = "other"

/obj/item/weapon/circuitboard/aiupload
	name = "circuit board (AI Upload)"
	build_path = /obj/machinery/computer/aiupload
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 4)

/obj/item/weapon/circuitboard/borgupload
	name = "circuit board (Cyborg Upload)"
	build_path = /obj/machinery/computer/borgupload
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 4)

/obj/item/weapon/circuitboard/med_data
	name = "circuit board (Medical Records)"
	build_path = /obj/machinery/computer/med_data

/obj/item/weapon/circuitboard/pandemic
	name = "circuit board (PanD.E.M.I.C. 2200)"
	build_path = /obj/machinery/computer/pandemic
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_BIOTECH = 2)

/obj/item/weapon/circuitboard/scan_consolenew
	name = "circuit board (DNA Machine)"
	build_path = /obj/machinery/computer/scan_consolenew
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_BIOTECH = 2)

/obj/item/weapon/circuitboard/communications
	name = "circuit board (Communications)"
	build_path = /obj/machinery/computer/communications
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_MAGNETS = 2)

/obj/item/weapon/circuitboard/communications/Destroy()
	for(var/obj/machinery/computer/communications/commconsole in world)
		if(isturf(commconsole.loc))
			return ..()

	for(var/obj/item/weapon/circuitboard/communications/commboard in world)
		if((isturf(commboard.loc) || istype(commboard.loc, /obj/item/weapon/storage)) && commboard != src)
			return ..()

	for(var/mob/living/silicon/ai/shuttlecaller in GLOBL.player_list)
		if(!shuttlecaller.stat && shuttlecaller.client && isturf(shuttlecaller.loc))
			return ..()

	if(IS_GAME_MODE(/datum/game_mode/revolution) || IS_GAME_MODE(/datum/game_mode/malfunction) || GLOBL.sent_strike_team)
		return ..()

	global.CTemergency.call_evac()
	log_game("All the AIs, comm consoles and boards are destroyed. Shuttle called.")
	message_admins("All the AIs, comm consoles and boards are destroyed. Shuttle called.", 1)

	return ..()

/obj/item/weapon/circuitboard/card
	name = "circuit board (ID Computer)"
	build_path = /obj/machinery/computer/card

/obj/item/weapon/circuitboard/card/centcom
	name = "circuit board (CentCom ID Computer)"
	build_path = /obj/machinery/computer/card/centcom

//obj/item/weapon/circuitboard/shield
//	name = "circuit board (Shield Control)"
//	build_path = /obj/machinery/computer/stationshield

/obj/item/weapon/circuitboard/teleporter
	name = "circuit board (Teleporter)"
	build_path = /obj/machinery/computer/teleporter
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_BLUESPACE = 2)

/obj/item/weapon/circuitboard/secure_data
	name = "circuit board (Security Records)"
	build_path = /obj/machinery/computer/secure_data

/obj/item/weapon/circuitboard/skills
	name = "circuit board (Employment Records)"
	build_path = /obj/machinery/computer/skills

/obj/item/weapon/circuitboard/stationalert
	name = "circuit board (Station Alerts)"
	build_path = /obj/machinery/computer/station_alert

/obj/item/weapon/circuitboard/atmospheresiphonswitch
	name = "circuit board (Atmosphere siphon control)"
//	build_path = /obj/machinery/computer/atmosphere/siphonswitch

/obj/item/weapon/circuitboard/air_management
	name = "circuit board (Atmospheric monitor)"
	build_path = /obj/machinery/computer/general_air_control

/obj/item/weapon/circuitboard/injector_control
	name = "circuit board (Injector control)"
	build_path = /obj/machinery/computer/general_air_control/fuel_injection

/obj/item/weapon/circuitboard/atmos_alert
	name = "circuit board (Atmospheric Alert)"
	build_path = /obj/machinery/computer/atmos_alert

/obj/item/weapon/circuitboard/pod
	name = "circuit board (Massdriver control)"
	build_path = /obj/machinery/computer/pod

/obj/item/weapon/circuitboard/robotics
	name = "circuit board (Robotics Control)"
	build_path = /obj/machinery/computer/robotics
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3)

/obj/item/weapon/circuitboard/cloning
	name = "circuit board (Cloning)"
	build_path = /obj/machinery/computer/cloning
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_BIOTECH = 3)

/obj/item/weapon/circuitboard/arcade
	name = "circuit board (Arcade)"
	build_path = /obj/machinery/computer/arcade
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 1)

/obj/item/weapon/circuitboard/turbine_control
	name = "circuit board (Turbine control)"
	build_path = /obj/machinery/computer/turbine_control

/obj/item/weapon/circuitboard/solar_control
	name = "circuit board (Solar Control)"	//name fixed 250810
	build_path = /obj/machinery/power/solar_control
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_POWERSTORAGE = 2)

/obj/item/weapon/circuitboard/powermonitor
	name = "circuit board (Power Monitor)"	//name fixed 250810
	build_path = /obj/machinery/power/monitor

/obj/item/weapon/circuitboard/olddoor
	name = "circuit board (DoorMex)"
	build_path = /obj/machinery/computer/pod/old

/obj/item/weapon/circuitboard/syndicatedoor
	name = "circuit board (ProComp Executive)"
	build_path = /obj/machinery/computer/pod/old/syndicate

/obj/item/weapon/circuitboard/swfdoor
	name = "circuit board (Magix)"
	build_path = /obj/machinery/computer/pod/old/swf

/obj/item/weapon/circuitboard/prisoner
	name = "circuit board (Prisoner Management)"
	build_path = /obj/machinery/computer/prisoner

/obj/item/weapon/circuitboard/rdconsole
	name = "circuit board (RD Console)"
	build_path = /obj/machinery/computer/rdconsole/core

/obj/item/weapon/circuitboard/rdconsole/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/screwdriver))
		user.visible_message(
			SPAN_INFO("\the [user] adjusts the jumper on the [src]'s access protocol pins."),
			SPAN_INFO("You adjust the jumper on the access protocol pins.")
		)
		if(ispath(build_path, /obj/machinery/computer/rdconsole/core))
			name = "circuit board (RD Console - Robotics)"
			build_path = /obj/machinery/computer/rdconsole/robotics
			to_chat(user, SPAN_INFO("Access protocols set to robotics."))
		else
			name = "circuit board (RD Console)"
			build_path = /obj/machinery/computer/rdconsole/core
			to_chat(user, SPAN_INFO("Access protocols defaulted."))

/obj/item/weapon/circuitboard/mecha_control
	name = "circuit board (Exosuit Control Console)"
	build_path = /obj/machinery/computer/mecha

/obj/item/weapon/circuitboard/rdservercontrol
	name = "circuit board (R&D Server Control)"
	build_path = /obj/machinery/computer/rdservercontrol

/obj/item/weapon/circuitboard/crew
	name = "circuit board (Crew monitoring computer)"
	build_path = /obj/machinery/computer/crew
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_BIOTECH = 2, RESEARCH_TECH_MAGNETS = 2)

/obj/item/weapon/circuitboard/mech_bay_power_console
	name = "circuit board (Mech Bay Power Control Console)"
	build_path = /obj/machinery/computer/mech_bay_power_console
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_POWERSTORAGE = 3)

/obj/item/weapon/circuitboard/ordercomp
	name = "circuit board (Supply ordering console)"
	build_path = /obj/machinery/computer/ordercomp
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2)

/obj/item/weapon/circuitboard/supplycomp
	name = "circuit board (Supply shuttle console)"
	build_path = /obj/machinery/computer/supplycomp
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3)

	var/contraband_enabled = FALSE

/obj/item/weapon/circuitboard/supplycomp/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/device/multitool))
		var/catastasis = contraband_enabled
		var/opposite_catastasis
		if(catastasis)
			opposite_catastasis = "STANDARD"
			catastasis = "BROAD"
		else
			opposite_catastasis = "BROAD"
			catastasis = "STANDARD"

		switch(alert("Current receiver spectrum is set to: [catastasis]", "Multitool-Circuitboard interface", "Switch to [opposite_catastasis]","Cancel"))
		//switch( alert("Current receiver spectrum is set to: " {(src.contraband_enabled) ? ("BROAD") : ("STANDARD")} , "Multitool-Circuitboard interface" , "Switch to " {(src.contraband_enabled) ? ("STANDARD") : ("BROAD")}, "Cancel") )
			if("Switch to STANDARD", "Switch to BROAD")
				contraband_enabled = !contraband_enabled

			if("Cancel")
				return
			else
				user << "DERP! BUG! Report this (And what you were doing to cause it) to Agouri"

/obj/item/weapon/circuitboard/operating
	name = "circuit board (Operating Computer)"
	build_path = /obj/machinery/computer/operating
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_BIOTECH = 2)

/obj/item/weapon/circuitboard/comm_monitor
	name = "circuit board (Telecommunications Monitor)"
	build_path = /obj/machinery/computer/telecoms/monitor
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3)

/obj/item/weapon/circuitboard/comm_server
	name = "circuit board (Telecommunications Server Monitor)"
	build_path = /obj/machinery/computer/telecoms/server
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3)

/obj/item/weapon/circuitboard/comm_traffic
	name = "circuit board (Telecommunications Traffic Control)"
	build_path = /obj/machinery/computer/telecoms/traffic
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3)

/obj/item/weapon/circuitboard/curefab
	name = "circuit board (Cure fab)"
	build_path = /obj/machinery/computer/curer
/obj/item/weapon/circuitboard/splicer
	name = "circuit board (Disease Splicer)"
	build_path = /obj/machinery/computer/diseasesplicer

/obj/item/weapon/circuitboard/mining_shuttle
	name = "circuit board (Mining Shuttle)"
	build_path = /obj/machinery/computer/shuttle_control/mining
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2)

/obj/item/weapon/circuitboard/research_shuttle
	name = "circuit board (Research Shuttle)"
	build_path = /obj/machinery/computer/shuttle_control/research
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2)

// Added engineering shuttle to make use of the 'Ruskie DJ Station'. -Frenjo
/obj/item/weapon/circuitboard/engineering_shuttle
	name = "circuit board (Engineering Shuttle)"
	build_path = /obj/machinery/computer/shuttle_control/engineering
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2)

/obj/item/weapon/circuitboard/HolodeckControl // Not going to let people get this, but it's just here for future
	name = "circuit board (Holodeck Control)"
	build_path = /obj/machinery/computer/holodeck_control
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 4)

/obj/item/weapon/circuitboard/aifixer
	name = "circuit board (AI Integrity Restorer)"
	build_path = /obj/machinery/computer/aifixer
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_BIOTECH = 2)

/obj/item/weapon/circuitboard/area_atmos
	name = "circuit board (Area Air Control)"
	build_path = /obj/machinery/computer/area_atmos
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2)

/obj/item/weapon/circuitboard/prison_shuttle
	name = "circuit board (Prison Shuttle)"
	build_path = /obj/machinery/computer/shuttle_control/prison
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2)