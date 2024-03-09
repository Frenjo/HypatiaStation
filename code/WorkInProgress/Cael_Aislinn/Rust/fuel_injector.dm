
/obj/machinery/power/rust_fuel_injector
	name = "Fuel Injector"
	icon = 'code/WorkInProgress/Cael_Aislinn/Rust/rust.dmi'
	icon_state = "injector0"

	density = TRUE
	anchored = FALSE

	power_state = USE_POWER_IDLE
	power_usage = list(
		USE_POWER_IDLE = 10,
		USE_POWER_ACTIVE = 500
	)

	req_access = list(ACCESS_ENGINE)

	var/state = 0
	var/locked = 0

	var/obj/item/fuel_assembly/cur_assembly
	var/fuel_usage = 0.0001			//percentage of available fuel to use per cycle
	var/id_tag = "One"
	var/injecting = 0
	var/trying_to_swap_fuel = 0

	var/remote_access_enabled = 1
	var/cached_power_avail = 0
	var/emergency_insert_ready = 0

/obj/machinery/power/rust_fuel_injector/process()
	if(injecting)
		if(stat & (BROKEN|NOPOWER))
			StopInjecting()
		else
			Inject()

	cached_power_avail = avail()

/obj/machinery/power/rust_fuel_injector/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(stat & (BROKEN | NOPOWER))
		FEEDBACK_MACHINE_UNRESPONSIVE(user)
		return FALSE
	if(emagged)
		FEEDBACK_ALREADY_EMAGGED(user)
		return FALSE

	user.visible_message(
		SPAN_WARNING("[user] emags \the [src]."),
		SPAN_WARNING("You short out the lock on \the [src].")
	)
	emagged = TRUE
	locked = FALSE
	return TRUE

/obj/machinery/power/rust_fuel_injector/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/wrench))
		if(injecting)
			user << "Turn off the [src] first."
			return
		switch(state)
			if(0)
				state = 1
				playsound(src, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message("[user.name] secures [src.name] to the floor.", \
					"You secure the external reinforcing bolts to the floor.", \
					"You hear a ratchet")
				src.anchored = TRUE
			if(1)
				state = 0
				playsound(src, 'sound/items/Ratchet.ogg', 75, 1)
				user.visible_message("[user.name] unsecures [src.name] reinforcing bolts from the floor.", \
					"You undo the external reinforcing bolts.", \
					"You hear a ratchet")
				src.anchored = FALSE
			if(2)
				user << "\red The [src.name] needs to be unwelded from the floor."
		return

	if(istype(W, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = W
		if(injecting)
			user << "Turn off the [src] first."
			return
		switch(state)
			if(0)
				user << "\red The [src.name] needs to be wrenched to the floor."
			if(1)
				if (WT.remove_fuel(0,user))
					playsound(src, 'sound/items/Welder2.ogg', 50, 1)
					user.visible_message(
						"[user.name] starts to weld the [name] to the floor.",
						"You start to weld the [src] to the floor.",
						SPAN_WARNING("You hear welding.")
					)
					if (do_after(user,20))
						if(!src || !WT.isOn()) return
						state = 2
						user << "You weld the [src] to the floor."
						connect_to_network()
						//src.directwired = 1
				else
					FEEDBACK_NOT_ENOUGH_WELDING_FUEL(user)
			if(2)
				if (WT.remove_fuel(0,user))
					playsound(src, 'sound/items/Welder2.ogg', 50, 1)
					user.visible_message(
						"[user.name] starts to cut the [name] free from the floor.",
						"You start to cut the [src] free from the floor.",
						SPAN_WARNING("You hear welding.")
					)
					if (do_after(user,20))
						if(!src || !WT.isOn()) return
						state = 1
						user << "You cut the [src] free from the floor."
						disconnect_from_network()
						//src.directwired = 0
				else
					FEEDBACK_NOT_ENOUGH_WELDING_FUEL(user)
		return

	if(istype(W, /obj/item/card/id) || istype(W, /obj/item/pda))
		if(emagged)
			user << "\red The lock seems to be broken"
			return
		if(src.allowed(user))
			src.locked = !src.locked
			user << "The controls are now [src.locked ? "locked." : "unlocked."]"
		else
			FEEDBACK_ACCESS_DENIED(user)
		return

	if(istype(W, /obj/item/fuel_assembly) && !cur_assembly)
		if(emergency_insert_ready)
			cur_assembly = W
			user.drop_item()
			W.loc = src
			emergency_insert_ready = 0
			return

	. = ..()

/obj/machinery/power/rust_fuel_injector/attack_ai(mob/user)
	attack_hand(user)

/obj/machinery/power/rust_fuel_injector/attack_hand(mob/user)
	add_fingerprint(user)
	interact(user)

/obj/machinery/power/rust_fuel_injector/interact(mob/user)
	if(stat & BROKEN)
		user.unset_machine()
		user << browse(null, "window=fuel_injector")
		return
	if(!in_range(src, user))
		if(!issilicon(user))
			user.unset_machine()
			user << browse(null, "window=fuel_injector")
			return

	var/dat = ""
	if (stat & NOPOWER || locked || state != 2)
		dat += "<i>The console is dark and nonresponsive.</i>"
	else
		dat += "<B>Reactor Core Fuel Injector</B><hr>"
		dat += "<b>Device ID tag:</b> [id_tag] <a href='?src=\ref[src];modify_tag=1'>\[Modify\]</a><br>"
		dat += "<b>Status:</b> [injecting ? "<font color=green>Active</font> <a href='?src=\ref[src];toggle_injecting=1'>\[Disable\]</a>" : "<font color=blue>Standby</font> <a href='?src=\ref[src];toggle_injecting=1'>\[Enable\]</a>"]<br>"
		dat += "<b>Fuel usage:</b> [fuel_usage*100]% <a href='?src=\ref[src];fuel_usage=1'>\[Modify\]</a><br>"
		dat += "<b>Fuel assembly port:</b> "
		dat += "<a href='?src=\ref[src];fuel_assembly=1'>\[[cur_assembly ? "Eject assembly to port" : "Draw assembly from port"]\]</a> "
		if(cur_assembly)
			dat += "<a href='?src=\ref[src];emergency_fuel_assembly=1'>\[Emergency eject\]</a><br>"
		else
			dat += "<a href='?src=\ref[src];emergency_fuel_assembly=1'>\[[emergency_insert_ready ? "Cancel emergency insertion" : "Emergency insert"]\]</a><br>"
		var/font_colour = "green"
		var/active_power_usage = power_usage[USE_POWER_ACTIVE]
		if(cached_power_avail < active_power_usage)
			font_colour = "red"
		else if(cached_power_avail < active_power_usage * 2)
			font_colour = "orange"
		dat += "<b>Power status:</b> <font color=[font_colour]>[active_power_usage]/[cached_power_avail] W</font><br>"
		dat += "<a href='?src=\ref[src];toggle_remote=1'>\[[remote_access_enabled ? "Disable remote access" : "Enable remote access"]\]</a><br>"

		dat += "<hr>"
		dat += "<A href='?src=\ref[src];refresh=1'>Refresh</A> "
		dat += "<A href='?src=\ref[src];close=1'>Close</A><BR>"

	user << browse(dat, "window=fuel_injector;size=500x300")
	onclose(user, "fuel_injector")
	user.set_machine(src)

/obj/machinery/power/rust_fuel_injector/Topic(href, href_list)
	..()

	if( href_list["modify_tag"] )
		id_tag = input("Enter new ID tag", "Modifying ID tag") as text|null

	if( href_list["fuel_assembly"] )
		attempt_fuel_swap()

	if( href_list["emergency_fuel_assembly"] )
		if(cur_assembly)
			cur_assembly.loc = src.loc
			cur_assembly = null
			//irradiate!
		else
			emergency_insert_ready = !emergency_insert_ready

	if( href_list["toggle_injecting"] )
		if(injecting)
			StopInjecting()
		else
			BeginInjecting()

	if( href_list["toggle_remote"] )
		remote_access_enabled = !remote_access_enabled

	if( href_list["fuel_usage"] )
		var/new_usage = text2num(input("Enter new fuel usage (0.01% - 100%)", "Modifying fuel usage", fuel_usage * 100))
		if(!new_usage)
			usr << "\red That's not a valid number."
			return
		new_usage = max(new_usage, 0.01)
		new_usage = min(new_usage, 100)
		fuel_usage = new_usage / 100
		power_usage[USE_POWER_ACTIVE] = 500 + 1000 * fuel_usage

	if( href_list["update_extern"] )
		var/obj/machinery/computer/rust_fuel_control/C = locate(href_list["update_extern"])
		if(C)
			C.updateDialog()

	if( href_list["close"] )
		usr << browse(null, "window=fuel_injector")
		usr.unset_machine()

	updateDialog()

/obj/machinery/power/rust_fuel_injector/proc/BeginInjecting()
	if(!injecting && cur_assembly)
		icon_state = "injector1"
		injecting = 1
		update_power_state(USE_POWER_IDLE)

/obj/machinery/power/rust_fuel_injector/proc/StopInjecting()
	if(injecting)
		injecting = 0
		icon_state = "injector0"
		update_power_state(USE_POWER_OFF)

/obj/machinery/power/rust_fuel_injector/proc/Inject()
	if(!injecting)
		return
	if(cur_assembly)
		var/amount_left = 0
		for(var/reagent in cur_assembly.rod_quantities)
			//to_world("checking [reagent]")
			if(cur_assembly.rod_quantities[reagent] > 0)
				//to_world("	rods left: [cur_assembly.rod_quantities[reagent]]")
				var/amount = cur_assembly.rod_quantities[reagent] * fuel_usage
				var/numparticles = round(amount * 1000)
				if(numparticles < 1)
					numparticles = 1
				//to_world("	amount: [amount]")
				//to_world("	numparticles: [numparticles]")
				//

				var/obj/effect/accelerated_particle/A = new/obj/effect/accelerated_particle(get_turf(src), dir)
				A.particle_type = reagent
				A.additional_particles = numparticles - 1
				//A.target = target_field
				//
				cur_assembly.rod_quantities[reagent] -= amount
				amount_left += cur_assembly.rod_quantities[reagent]
		cur_assembly.percent_depleted = amount_left / 300
		flick("injector-emitting",src)
	else
		StopInjecting()

/obj/machinery/power/rust_fuel_injector/proc/attempt_fuel_swap()
	var/rev_dir = reverse_direction(dir)
	var/turf/mid = get_step(src, rev_dir)
	var/success = 0
	for(var/obj/machinery/rust_fuel_assembly_port/check_port in get_step(mid, rev_dir))
		if(cur_assembly)
			if(!check_port.cur_assembly)
				check_port.cur_assembly = cur_assembly
				cur_assembly.loc = check_port
				cur_assembly = null
				check_port.icon_state = "port1"
				success = 1
		else
			if(check_port.cur_assembly)
				cur_assembly = check_port.cur_assembly
				cur_assembly.loc = src
				check_port.cur_assembly = null
				check_port.icon_state = "port0"
				success = 1

		break
	if(success)
		src.visible_message("\blue \icon[src] a green light flashes on [src].")
		updateDialog()
	else
		src.visible_message("\red \icon[src] a red light flashes on [src].")

/obj/machinery/power/rust_fuel_injector/verb/rotate_clock()
	set category = PANEL_OBJECT
	set name = "Rotate Generator (Clockwise)"
	set src in view(1)

	if(usr.stat || usr.restrained()  || anchored)
		return

	src.set_dir(turn(src.dir, 90))

/obj/machinery/power/rust_fuel_injector/verb/rotate_anticlock()
	set category = PANEL_OBJECT
	set name = "Rotate Generator (Counterclockwise)"
	set src in view(1)

	if(usr.stat || usr.restrained()  || anchored)
		return

	src.set_dir(turn(src.dir, -90))