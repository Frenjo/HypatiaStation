/obj/effect/mapping_helper/airlock/late_initialise()
	. = ..()
	var/obj/machinery/door/airlock/target = locate(/obj/machinery/door/airlock) in loc
	if(isnotnull(target))
		payload(target)

	qdel(src)

/obj/effect/mapping_helper/airlock/proc/payload(obj/machinery/door/airlock/target)
	return

/obj/effect/mapping_helper/airlock/lock
	name = "airlock lock helper"
	icon_state = "airlock_locked"

/obj/effect/mapping_helper/airlock/lock/payload(obj/machinery/door/airlock/target)
	target.locked = TRUE
	target.update_icon()

/obj/effect/mapping_helper/airlock/autoname
	name = "airlock autoname helper"
	icon_state = "airlock_autoname"

/obj/effect/mapping_helper/airlock/autoname/payload(obj/machinery/door/airlock/target)
	var/area/target_area = GET_AREA(target)
	target.name = target_area.name