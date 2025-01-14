/obj/item/pai_cable
	name = "data cable"
	desc = "A flexible coated cable with a universal jack on one end."
	icon = 'icons/obj/power.dmi'
	icon_state = "wire1"

	var/obj/machinery/machine

/obj/item/pai_cable/proc/plugin(obj/machinery/M, mob/user)
	if(!istype(M, /obj/machinery/door) && !istype(M, /obj/machinery/camera))
		user.visible_message(
			SPAN_WARNING("[user] dumbly fumbles to find a place on \the [M] to plug in \the [src]."),
			SPAN_WARNING("There aren't any ports on \the [M] that match the jack belonging to \the [src].")
		)
		return FALSE

	user.visible_message(
		SPAN_NOTICE("[user] inserts \the [src] into a data port on \the [M]."),
		SPAN_NOTICE("You insert \the [src] into a data port on \the [M]."),
		SPAN_INFO("You hear the satisfying click of a wire jack fastening into place.")
	)
	user.drop_item()
	loc = M
	machine = M
	return TRUE

/obj/item/pai_cable/attack(obj/machinery/M, mob/user)
	plugin(M, user)