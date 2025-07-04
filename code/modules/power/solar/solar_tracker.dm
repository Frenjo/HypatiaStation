//Solar tracker

//Machine that tracks the sun and reports it's direction to the solar controllers
//As long as this is working, solar panels on same powernet will track automatically

/obj/machinery/power/tracker
	name = "solar tracker"
	desc = "A solar directional tracker."
	icon = 'icons/obj/power.dmi'
	icon_state = "tracker"
	anchored = TRUE
	density = TRUE

	var/id = 0
	var/sun_angle = 0 // sun angle as set by sun datum
	var/obj/machinery/power/solar_control/control = null

/obj/machinery/power/tracker/New(turf/loc, obj/item/solar_assembly/assembly)
	. = ..(loc)
	make_tracker(assembly)
	connect_to_network()

/obj/machinery/power/tracker/Destroy()
	unset_control() // Removes ourselves from the attached control computer.
	return ..()

/obj/machinery/power/tracker/attack_tool(obj/item/tool, mob/user)
	if(iscrowbar(tool))
		user.visible_message(
			SPAN_NOTICE("[user] begins to take the glass off of \the [src]."),
			SPAN_NOTICE("You begin to take the glass off of \the [src].")
		)
		playsound(src, 'sound/machines/click.ogg', 50, 1)
		if(do_after(user, 5 SECONDS))
			var/obj/item/solar_assembly/assembly = locate() in src
			if(isnotnull(assembly))
				assembly.forceMove(GET_TURF(src))
				assembly.give_glass()
			playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
			user.visible_message(SPAN_NOTICE("[user] takes the glass off of \the [src]."))
			qdel(src)
		return TRUE
	return ..()

//set the control of the tracker to a given computer if closer than SOLAR_MAX_DIST
/obj/machinery/power/tracker/proc/set_control(obj/machinery/power/solar_control/solar_control)
	if(solar_control && (get_dist(src, solar_control) > SOLAR_MAX_DIST))
		return 0
	control = solar_control
	return 1

//set the control of the tracker to null and removes it from the previous control computer if needed
/obj/machinery/power/tracker/proc/unset_control()
	control?.connected_tracker = null
	control = null

/obj/machinery/power/tracker/proc/make_tracker(obj/item/solar_assembly/assembly)
	if(isnull(assembly))
		assembly = new /obj/item/solar_assembly(src)
		assembly.glass_type = /obj/item/stack/sheet/glass
		assembly.tracker = TRUE
		assembly.anchored = TRUE
	assembly.forceMove(src)
	update_icon()

//updates the tracker icon and the facing angle for the control computer
/obj/machinery/power/tracker/proc/set_angle(angle)
	sun_angle = angle

	//set icon dir to show sun illumination
	dir = turn(NORTH, -angle - 22.5)	// 22.5 deg bias ensures, e.g. 67.5-112.5 is EAST

	if((powernet == control.powernet)) //update if we're still in the same powernet
		control.cdir = angle