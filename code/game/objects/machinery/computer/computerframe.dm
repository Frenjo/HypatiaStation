//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
/*
 * Computer Frame
 */
/obj/structure/computerframe
	name = "computer frame"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "0"

	density = TRUE
	anchored = FALSE

	var/state = 0
	var/obj/item/circuitboard/circuit = null
//	weight = 1.0E8

/obj/structure/computerframe/attackby(obj/item/P, mob/user)
	switch(state)
		if(0)
			if(iswrench(P))
				playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
				if(do_after(user, 20))
					to_chat(user, SPAN_INFO("You wrench the frame into place."))
					anchored = TRUE
					state = 1
			if(iswelder(P))
				var/obj/item/welding_torch/WT = P
				if(!WT.remove_fuel(0, user))
					to_chat(user, SPAN_WARNING("\The [WT] must be on to complete this task."))
					return
				playsound(src, 'sound/items/Welder.ogg', 50, 1)
				if(do_after(user, 20))
					if(isnull(src) || !WT.isOn())
						return
					to_chat(user, SPAN_INFO("You deconstruct the frame."))
					new /obj/item/stack/sheet/steel(loc, 5)
					qdel(src)
		if(1)
			if(iswrench(P))
				playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
				if(do_after(user, 20))
					to_chat(user, SPAN_INFO("You unfasten the frame."))
					anchored = FALSE
					state = 0
			if(istype(P, /obj/item/circuitboard) && !circuit)
				var/obj/item/circuitboard/B = P
				if(B.board_type == "computer")
					playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
					to_chat(user, SPAN_INFO("You place the circuit board inside the frame."))
					icon_state = "1"
					circuit = P
					user.drop_item()
					P.forceMove(src)
				else
					to_chat(user, SPAN_WARNING("This frame does not accept circuit boards of this type!"))
			if(isscrewdriver(P) && circuit)
				playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
				to_chat(user, SPAN_INFO("You screw the circuit board into place."))
				state = 2
				icon_state = "2"
			if(iscrowbar(P) && circuit)
				playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
				to_chat(user, SPAN_INFO("You remove the circuit board."))
				state = 1
				icon_state = "0"
				circuit.forceMove(loc)
				circuit = null
		if(2)
			if(isscrewdriver(P) && circuit)
				playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
				to_chat(user, SPAN_INFO("You unfasten the circuit board."))
				state = 1
				icon_state = "1"
			if(iscable(P))
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
			if(iswirecutter(P))
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
			if(iscrowbar(P))
				playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
				to_chat(user, SPAN_INFO("You remove the glass panel."))
				state = 3
				icon_state = "3"
				new /obj/item/stack/sheet/glass(loc, 2)
			if(isscrewdriver(P))
				playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
				to_chat(user, SPAN_INFO("You connect the monitor."))
				var/B = new circuit.build_path(loc)
				if(circuit.powernet)
					B:powernet = circuit.powernet
				if(circuit.id)
					B:id = circuit.id
				if(circuit.records)
					B:records = circuit.records
				if(circuit.frequency)
					B:frequency = circuit.frequency
				if(istype(circuit, /obj/item/circuitboard/supplycomp))
					var/obj/machinery/computer/supplycomp/SC = B
					var/obj/item/circuitboard/supplycomp/C = circuit
					SC.can_order_contraband = C.contraband_enabled
				else if(istype(circuit, /obj/item/circuitboard/security))
					var/obj/machinery/computer/security/C = B
					var/obj/item/circuitboard/security/CB = circuit
					C.network = CB.network
				qdel(src)