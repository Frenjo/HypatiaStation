GLOBAL_GLOBL_LIST_NEW(obj/machinery/doppler_array/doppler_arrays)

/obj/machinery/doppler_array
	name = "tachyon-doppler array"
	desc = "A highly precise directional sensor array which measures the release of quants from decaying tachyons. The doppler shifting of the mirror-image formed by these quants can reveal the size, location and temporal affects of energetic disturbances within a large radius ahead of the array."
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "doppler"

	density = TRUE
	anchored = TRUE

/obj/machinery/doppler_array/initialise()
	. = ..()
	GLOBL.doppler_arrays.Add(src)

/obj/machinery/doppler_array/Destroy()
	GLOBL.doppler_arrays.Remove(src)
	return ..()

/obj/machinery/doppler_array/process()
	return PROCESS_KILL

/obj/machinery/doppler_array/attack_tool(obj/item/tool, mob/user)
	if(iswrench(tool))
		anchored = !anchored
		user.visible_message(
			SPAN_NOTICE("[user] [anchored ? "attaches" : "detaches"] \the [src] [anchored ? "to" : "from"] the ground."),
			SPAN_NOTICE("You [anchored ? "attach" : "detach"] \the [src] [anchored ? "to" : "from"] the ground."),
			SPAN_INFO("You hear a ratchet.")
		)
		playsound(src, 'sound/items/Ratchet.ogg', 75, 1)
		return TRUE
	return ..()

/obj/machinery/doppler_array/verb/rotate()
	set category = null
	set name = "Rotate (Clockwise)"
	set src in oview(1)

	if(isnull(usr) || !isturf(usr.loc))
		return
	if(usr.stat || usr.restrained())
		return

	set_dir(turn(dir, 90))

/obj/machinery/doppler_array/proc/sense_explosion(x0, y0, z0, devastation_range, heavy_impact_range, light_impact_range, took)
	if(stat & (BROKEN | NOPOWER))
		return
	if(z != z0)
		return

	var/dx = abs(x0 - x)
	var/dy = abs(y0 - y)
	var/distance
	var/direct

	if(dx > dy)
		distance = dx
		if(x0 > x)
			direct = EAST
		else
			direct = WEST
	else
		distance = dy
		if(y0 > y)
			direct = NORTH
		else
			direct = SOUTH

	if(distance > 100)
		return
	if(!(direct & dir))
		return

	var/message = "Explosive disturbance detected - Epicenter at: grid ([x0],[y0])."
	message += " Epicenter radius: [devastation_range]. Outer radius: [heavy_impact_range]. Shockwave radius: [light_impact_range]."
	message += " Temporal displacement of tachyons: [took] seconds."

	for(var/mob/O in hearers(src, null))
		O.show_message("<span class='game say'><span class='name'>[src]</span> states coldly, \"[message]\"", 2)

/obj/machinery/doppler_array/power_change()
	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
	else
		if(powered() && anchored)
			icon_state = initial(icon_state)
			stat &= ~NOPOWER
		else
			icon_state = "[initial(icon_state)]-off"
			stat |= NOPOWER