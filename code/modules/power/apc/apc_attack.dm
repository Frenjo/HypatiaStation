// attack with hand - remove cell (if cover open) or interact with the APC
/obj/machinery/power/apc/attack_hand(mob/user)
	if(!user)
		return
	src.add_fingerprint(user)

	//Synthetic human mob goes here.
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.species.flags & IS_SYNTHETIC && H.a_intent == "grab")
			if(emagged || stat & BROKEN)
				var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
				s.set_up(3, 1, src)
				s.start()
				to_chat(H, SPAN_WARNING("The APC power currents surge eratically, damaging your chassis!"))
				H.adjustFireLoss(10, 0)
			else if(src.cell && src.cell.charge > 0)
				if(H.nutrition < 450)
					if(src.cell.charge >= 500)
						H.nutrition += 50
						src.cell.charge -= 500
					else
						H.nutrition += src.cell.charge / 10
						src.cell.charge = 0

					to_chat(H, SPAN_INFO("You slot your fingers into the APC interface and siphon off some of the stored charge for your own use."))
					if(src.cell.charge < 0)
						src.cell.charge = 0
					if(H.nutrition > 500)
						H.nutrition = 500
					src.charging = 1

				else
					to_chat(H, SPAN_INFO("You are already fully charged."))
			else
				to_chat(H, "There is no charge to draw from that APC.")
			return

	if(usr == user && opened && !issilicon(user))
		if(cell)
			user.put_in_hands(cell)
			cell.add_fingerprint(user)
			cell.updateicon()

			src.cell = null
			user.visible_message(
				SPAN_WARNING("[user.name] removes the power cell from [src.name]!"),
				SPAN_NOTICE("You remove the power cell.")
			)
			charging = 0
			src.update_icon()
		return
	if(stat & (BROKEN|MAINT))
		return

	// do APC interaction
	src.interact(user)

//attack with an item - open/close cover, insert cell, or (un)lock interface
/obj/machinery/power/apc/attackby(obj/item/W, mob/user)
	if(issilicon(user) && get_dist(src, user) > 1)
		return src.attack_hand(user)
	src.add_fingerprint(user)
	if(istype(W, /obj/item/crowbar) && opened)
		if(has_electronics == 1)
			if(terminal)
				to_chat(user, SPAN_WARNING("Disconnect wires first."))
				return
			playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
			to_chat(user, "You are trying to remove the power control board...")	//lpeters - fixed grammar issues
			if(do_after(user, 50))
				if(has_electronics == 1)
					has_electronics = 0
					if((stat & BROKEN) || malfhack)
						user.visible_message(
							SPAN_WARNING("[user.name] has broken the power control board inside [src.name]!"),
							SPAN_NOTICE("You broke the charred power control board and remove the remains."),
							"You hear a crack!"
						)
						//ticker.mode:apcs-- //XSI said no and I agreed. -rastaf0
					else
						user.visible_message(
							SPAN_WARNING("[user.name] has removed the power control board from [src.name]!"),
							SPAN_NOTICE("You remove the power control board.")
						)
						new /obj/item/module/power_control(loc)
		else if(opened != 2) //cover isn't removed
			opened = 0
			update_icon()
	else if(istype(W, /obj/item/crowbar) && !((stat & BROKEN) || malfhack))
		if(coverlocked && !(stat & MAINT))
			to_chat(user, SPAN_WARNING("The cover is locked and cannot be opened."))
			return
		else
			opened = 1
			update_icon()
	else if(istype(W, /obj/item/cell) && opened)	// trying to put a cell inside
		if(cell)
			to_chat(user, "There is a power cell already installed.")
			return
		else
			if(stat & MAINT)
				to_chat(user, SPAN_WARNING("There is no connector for your power cell."))
				return
			user.drop_item()
			W.loc = src
			cell = W
			user.visible_message(
				SPAN_WARNING("[user.name] has inserted the power cell to [src.name]!"),
				SPAN_NOTICE("You insert the power cell.")
			)
			chargecount = 0
			update_icon()
	else if(istype(W, /obj/item/screwdriver))	// haxing
		if(opened)
			if(cell)
				to_chat(user, SPAN_WARNING("Close the APC first."))	//Less hints more mystery!
				return
			else
				if(has_electronics == 1 && terminal)
					has_electronics = 2
					stat &= ~MAINT
					playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
					to_chat(user, "You screw the circuit electronics into place.")
				else if(has_electronics == 2)
					has_electronics = 1
					stat |= MAINT
					playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
					to_chat(user, "You unfasten the electronics.")
				else /* has_electronics==0 */
					to_chat(user, SPAN_WARNING("There is nothing to secure."))
					return
				update_icon()
		else if(emagged)
			to_chat(user, "The interface is broken.")
		else
			wiresexposed = !wiresexposed
			to_chat(user, "The wires have been [wiresexposed ? "exposed" : "unexposed"].")
			update_icon()

	else if(istype(W, /obj/item/card/id)||istype(W, /obj/item/pda))			// trying to unlock the interface with an ID card
		if(emagged)
			to_chat(user, "The interface is broken.")
		else if(opened)
			to_chat(user, "You must close the cover to swipe an ID card.")
		else if(wiresexposed)
			to_chat(user, "You must close the panel.")
		else if(stat & (BROKEN|MAINT))
			to_chat(user, "Nothing happens.")
		else
			if(src.allowed(usr) && !isWireCut(APC_WIRE_IDSCAN))
				locked = !locked
				to_chat(user, "You [locked ? "lock" : "unlock"] the APC interface.")
				update_icon()
			else
				FEEDBACK_ACCESS_DENIED(user)
	else if(istype(W, /obj/item/card/emag) && !(emagged || malfhack))		// trying to unlock with an emag card
		if(opened)
			to_chat(user, "You must close the cover to swipe an ID card.")
		else if(wiresexposed)
			to_chat(user, "You must close the panel first.")
		else if(stat & (BROKEN|MAINT))
			to_chat(user, "Nothing happens.")
		else
			flick("apc-spark", src)
			if(do_after(user, 6))
				if(prob(50))
					emagged = 1
					locked = 0
					to_chat(user, "You emag the APC interface.")
					update_icon()
				else
					to_chat(user, SPAN_WARNING("You fail to [locked ? "unlock" : "lock"] the APC interface."))
	else if(istype(W, /obj/item/stack/cable_coil) && !terminal && opened && has_electronics != 2)
		if(src.loc:intact)
			to_chat(user, SPAN_WARNING("You must remove the floor plating in front of the APC first."))
			return
		var/obj/item/stack/cable_coil/C = W
		if(C.amount < 10)
			to_chat(user, SPAN_WARNING("You need ten lengths of cable for APC."))
			return
		to_chat(user, "You start adding cables to the APC frame...")
		playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 20))
			if(C.amount >= 10 && !terminal && opened && has_electronics != 2)
				var/turf/T = get_turf(src)
				var/obj/structure/cable/N = T.get_cable_node()
				if(prob(50) && electrocute_mob(usr, N, N))
					var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
					s.set_up(5, 1, src)
					s.start()
					return
				C.use(10)
			user.visible_message(
				SPAN_WARNING("[user.name] adds cables to the APC frame."),
				"You start adding cables to the APC frame..."
			)
			make_terminal()
			terminal.connect_to_network()
	else if(istype(W, /obj/item/wirecutters) && terminal && opened && has_electronics != 2)
		if(src.loc:intact)
			to_chat(user, SPAN_WARNING("You must remove the floor plating in front of the APC first."))
			return
		to_chat(user, "You begin to cut the cables...")
		playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 50))
			if(terminal && opened && has_electronics != 2)
				if(prob(50) && electrocute_mob(usr, terminal.powernet, terminal))
					var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
					s.set_up(5, 1, src)
					s.start()
					return
				new /obj/item/stack/cable_coil(loc, 10)
				to_chat(user, SPAN_NOTICE("You cut the cables and dismantle the power terminal."))
				qdel(terminal)
	else if(istype(W, /obj/item/module/power_control) && opened && has_electronics == 0 && !((stat & BROKEN) || malfhack))
		user.visible_message(
			SPAN_WARNING("[user.name] inserts the power control board into [src]."),
			"You start to insert the power control board into the frame..."
		)
		playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 10))
			if(has_electronics == 0)
				has_electronics = 1
				to_chat(user, SPAN_NOTICE("You place the power control board inside the frame."))
				qdel(W)
	else if(istype(W, /obj/item/module/power_control) && opened && has_electronics == 0 && ((stat & BROKEN) || malfhack))
		to_chat(user, SPAN_WARNING("You cannot put the board inside, the frame is damaged."))
		return
	else if(istype(W, /obj/item/weldingtool) && opened && has_electronics == 0 && !terminal)
		var/obj/item/weldingtool/WT = W
		if(WT.get_fuel() < 3)
			to_chat(user, SPAN_INFO("You need more welding fuel to complete this task."))
			return
		user.visible_message(
			SPAN_WARNING("[user.name] welds [src]."),
			"You start welding the APC frame...",
			"You hear welding."
		)
		playsound(src, 'sound/items/Welder.ogg', 50, 1)
		if(do_after(user, 50))
			if(!src || !WT.remove_fuel(3, user))
				return
			if(emagged || malfhack || (stat & BROKEN) || opened == 2)
				new /obj/item/stack/sheet/metal(loc)
				user.visible_message(
					SPAN_WARNING("[src] has been cut apart by [user.name] with the weldingtool."),
					SPAN_NOTICE("You disassembled the broken APC frame.</span>"),
					"You hear welding."
				)
			else
				new /obj/item/apc_frame(loc)
				user.visible_message(
					SPAN_WARNING("[src] has been cut from the wall by [user.name] with the weldingtool."),
					SPAN_NOTICE("You cut the APC frame from the wall.</span>"),
					"You hear welding."
				)
			qdel(src)
			return
	else if(istype(W, /obj/item/apc_frame) && opened && emagged)
		emagged = 0
		if(opened == 2)
			opened = 1
		user.visible_message(
			SPAN_WARNING("[user.name] has replaced the damaged APC frontal panel with a new one."),
			SPAN_NOTICE("You replace the damaged APC frontal panel with a new one.</span>")
		)
		qdel(W)
		update_icon()
	else if(istype(W, /obj/item/apc_frame) && opened && ((stat & BROKEN) || malfhack))
		if(has_electronics)
			to_chat(user, SPAN_WARNING("You cannot repair this APC until you remove the electronics still inside."))
			return
		user.visible_message(
			SPAN_WARNING("[user.name] replaces the damaged APC frame with a new one."),
			"You begin to replace the damaged APC frame..."
		)
		if(do_after(user, 50))
			user.visible_message(
				SPAN_NOTICE("[user.name] has replaced the damaged APC frame with a new one."),
				"You replace the damaged APC frame with a new one."
			)
			qdel(W)
			stat &= ~BROKEN
			malfai = null
			malfhack = 0
			if(opened == 2)
				opened = 1
			update_icon()
	else
		if(((stat & BROKEN) || malfhack) \
				&& !opened \
				&& W.force >= 5 \
				&& W.w_class >= 3.0 \
				&& prob(20))
			opened = 2
			user.visible_message(
				SPAN_DANGER("The APC cover was knocked down with the [W.name] by [user.name]!"),
				SPAN_DANGER("You knock down the APC cover with your [W.name]!"),
				"You hear a bang."
			)
			update_icon()
		else
			if(issilicon(user))
				return src.attack_hand(user)
			if(!opened && wiresexposed && \
				(istype(W, /obj/item/multitool) || \
				istype(W, /obj/item/wirecutters) || istype(W, /obj/item/assembly/signaler)))
				return src.attack_hand(user)
			user.visible_message(
				SPAN_WARNING("The [src.name] has been hit with the [W.name] by [user.name]!"),
				SPAN_WARNING("You hit the [src.name] with your [W.name]!"),
				"You hear a bang."
			)