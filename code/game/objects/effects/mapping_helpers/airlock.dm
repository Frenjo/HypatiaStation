/obj/effect/mapping_helper/airlock/initialise()
	. = ..()
	var/obj/machinery/door/airlock/target = locate(/obj/machinery/door/airlock) in loc
	if(isnotnull(target))
		payload(target)

	qdel(src)

/obj/effect/mapping_helper/airlock/proc/payload(obj/machinery/door/airlock/target)
	return

/obj/effect/mapping_helper/airlock/lock
	name = "airlock lock helper"
	icon_state = "airlock_locked_helper"

/obj/effect/mapping_helper/airlock/lock/payload(obj/machinery/door/airlock/target)
	target.locked = TRUE
	target.update_icon()