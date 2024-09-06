//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/constructable_frame //Made into a seperate type to make future revisions easier.
	name = "machine frame"
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "box_0"
	density = TRUE
	anchored = TRUE

	power_state = USE_POWER_OFF

	var/obj/item/circuitboard/circuit = null
	var/list/components = null
	var/list/req_components = null
	var/list/req_component_names = null
	var/state = 1

/obj/machinery/constructable_frame/proc/update_desc()
	var/D
	if(req_components)
		D = "Requires "
		var/first = 1
		for(var/I in req_components)
			if(req_components[I] > 0)
				D += "[first?"":", "][num2text(req_components[I])] [req_component_names[I]]"
				first = 0
		if(first) // nothing needs to be added, then
			D += "nothing"
		D += "."
	desc = D

/obj/machinery/constructable_frame/machine_frame/attackby(obj/item/P, mob/user)
	if(P.crit_fail)
		to_chat(user, SPAN_WARNING("This part is faulty, you cannot add this to the machine!"))
		return
	switch(state)
		if(1)
			if(iscable(P))
				var/obj/item/stack/cable_coil/C = P
				if(C.amount >= 5)
					playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
					to_chat(user, SPAN_INFO("You start to add cables to the frame."))
					if(do_after(user, 20))
						if(C)
							C.use(5)
							to_chat(user, SPAN_INFO("You add cables to the frame."))
							state = 2
							icon_state = "box_1"
			else
				if(iswrench(P))
					playsound(src, 'sound/items/Ratchet.ogg', 75, 1)
					to_chat(user, SPAN_INFO("You dismantle the frame."))
					new /obj/item/stack/sheet/steel(loc, 5)
					qdel(src)
		if(2)
			if(istype(P, /obj/item/circuitboard))
				var/obj/item/circuitboard/B = P
				if(B.board_type == "machine")
					playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
					to_chat(user, SPAN_INFO("You add the circuit board to the frame."))
					circuit = P
					user.drop_item()
					P.loc = src
					icon_state = "box_2"
					state = 3
					components = list()
					req_components = circuit.req_components.Copy()
					for(var/A in circuit.req_components)
						req_components[A] = circuit.req_components[A]
					req_component_names = circuit.req_components.Copy()
					for(var/A in req_components)
						var/cp = A
						var/obj/ct = new cp() // have to quickly instantiate it get name
						req_component_names[A] = ct.name
					if(circuit.frame_desc)
						desc = circuit.frame_desc
					else
						update_desc()
					user << desc
				else
					to_chat(user, SPAN_WARNING("This frame does not accept circuit boards of this type!"))
			else
				if(iswirecutter(P))
					playsound(src, 'sound/items/Wirecutter.ogg', 50, 1)
					to_chat(user, SPAN_INFO("You remove the cables."))
					state = 1
					icon_state = "box_0"
					var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil(loc)
					A.amount = 5

		if(3)
			if(iscrowbar(P))
				playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
				state = 2
				circuit.loc = loc
				circuit = null
				if(!length(components))
					to_chat(user, SPAN_INFO("You remove the circuit board."))
				else
					to_chat(user, SPAN_INFO("You remove the circuit board and other components."))
					for(var/obj/item/W in components)
						W.loc = loc
				desc = initial(desc)
				req_components = null
				components = null
				icon_state = "box_1"
			else
				if(isscrewdriver(P))
					var/component_check = 1
					for(var/R in req_components)
						if(req_components[R] > 0)
							component_check = 0
							break
					if(component_check)
						playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
						var/obj/machinery/new_machine = new circuit.build_path(loc)
						for(var/obj/O in new_machine.component_parts)
							qdel(O)
						new_machine.component_parts = list()
						for(var/obj/O in src)
							if(circuit.contain_parts) // things like disposal don't want their parts in them
								O.loc = new_machine
							else
								O.loc = null
							new_machine.component_parts.Add(O)
						if(circuit.contain_parts)
							circuit.loc = new_machine
						else
							circuit.loc = null
						new_machine.RefreshParts()
						qdel(src)
				else
					if(isitem(P))
						for(var/I in req_components)
							if(istype(P, I) && (req_components[I] > 0))
								playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
								if(iscable(P))
									var/obj/item/stack/cable_coil/CP = P
									if(CP.amount > 1)
										var/camt = min(CP.amount, req_components[I]) // amount of cable to take, idealy amount required, but limited by amount provided
										var/obj/item/stack/cable_coil/CC = new /obj/item/stack/cable_coil(src)
										CC.amount = camt
										CC.update_icon()
										CP.use(camt)
										components.Add(CC)
										req_components[I] -= camt
										update_desc()
										break
								user.drop_item()
								P.loc = src
								components.Add(P)
								req_components[I]--
								update_desc()
								break
						user << desc
						if(P && P.loc != src && !iscable(P))
							to_chat(user, SPAN_WARNING("You cannot add that component to the machine!"))