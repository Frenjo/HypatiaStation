/obj/machinery/rust_fuel_assembly_port
	name = "fuel assembly port"
	icon = 'code/WorkInProgress/Cael_Aislinn/Rust/rust.dmi'
	icon_state = "port2"
	density = FALSE
	anchored = TRUE

	var/obj/item/fuel_assembly/cur_assembly
	var/busy = 0

	var/opened = 1 //0=closed, 1=opened
	var/has_electronics = 0 // 0 - none, bit 1 - circuitboard, bit 2 - wires

/obj/machinery/rust_fuel_assembly_port/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/fuel_assembly) && !opened)
		if(isnotnull(cur_assembly))
			to_chat(user, SPAN_WARNING("There is already a fuel rod assembly inside!"))
			return TRUE
		cur_assembly = I
		user.drop_item()
		I.forceMove(src)
		icon_state = "port1"
		to_chat(user, SPAN_INFO("You insert \the [I] into \the [src]. Touch the panel again to insert \the [I] into the injector."))
		return TRUE
	return ..()

/obj/machinery/rust_fuel_assembly_port/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER) || opened)
		return

	if(cur_assembly)
		if(try_insert_assembly())
			user << "\blue \icon[src] [src] inserts it's fuel rod assembly into an injector."
		else
			if(eject_assembly())
				user << "\red \icon[src] [src] ejects it's fuel assembly. Check the fuel injector status."
			else if(try_draw_assembly())
				user << "\blue \icon[src] [src] draws a fuel rod assembly from an injector."
	else if(try_draw_assembly())
		user << "\blue \icon[src] [src] draws a fuel rod assembly from an injector."
	else
		user << "\red \icon[src] [src] was unable to draw a fuel rod assembly from an injector."

/obj/machinery/rust_fuel_assembly_port/proc/try_insert_assembly()
	var/success = 0
	if(cur_assembly)
		var/turf/check_turf = get_step(GET_TURF(src), src.dir)
		check_turf = get_step(check_turf, src.dir)
		for(var/obj/machinery/power/rust_fuel_injector/I in check_turf)
			if(I.stat & (BROKEN|NOPOWER))
				break
			if(I.cur_assembly)
				break
			if(I.state != 2)
				break

			I.cur_assembly = cur_assembly
			cur_assembly.forceMove(I)
			cur_assembly = null
			icon_state = "port0"
			success = 1

	return success

/obj/machinery/rust_fuel_assembly_port/proc/eject_assembly()
	if(cur_assembly)
		cur_assembly.forceMove(loc)//get_step(GET_TURF(src), src.dir)
		cur_assembly = null
		icon_state = "port0"
		return 1

/obj/machinery/rust_fuel_assembly_port/proc/try_draw_assembly()
	var/success = 0
	if(!cur_assembly)
		var/turf/check_turf = get_step(GET_TURF(src), src.dir)
		check_turf = get_step(check_turf, src.dir)
		for(var/obj/machinery/power/rust_fuel_injector/I in check_turf)
			if(I.stat & (BROKEN|NOPOWER))
				break
			if(!I.cur_assembly)
				break
			if(I.injecting)
				break
			if(I.state != 2)
				break

			cur_assembly = I.cur_assembly
			cur_assembly.forceMove(src)
			I.cur_assembly = null
			icon_state = "port1"
			success = 1
			break

	return success

/obj/machinery/rust_fuel_assembly_port/verb/eject_assembly_verb()
	set category = PANEL_OBJECT
	set name = "Eject assembly from port"
	set src in oview(1)

	eject_assembly()
