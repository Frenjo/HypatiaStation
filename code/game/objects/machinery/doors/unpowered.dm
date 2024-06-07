/obj/machinery/door/unpowered
	//autoclose = 0
	autoclose = 1 // Fixes shuttle doors not automatically closing themselves.
	var/welded = 0 // ...HOPEFULLY... -Frenjo
	var/locked = 0

/obj/machinery/door/unpowered/Bumped(atom/AM)
	if(locked)
		return
	..()
	return

/obj/machinery/door/unpowered/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/card/emag) || istype(I, /obj/item/melee/energy/blade))
		return
	if(locked)
		return
	..()
	return

/obj/machinery/door/unpowered/shuttle
	icon = 'icons/turf/shuttle.dmi'
	name = "door"
	icon_state = "door1"
	opacity = TRUE
	density = TRUE

// Play a sound for the shuttle doors because they don't already. -Frenjo
/obj/machinery/door/unpowered/shuttle/open()
	playsound(src, 'sound/machines/windowdoor.ogg', 100, 1)
	return ..()

/obj/machinery/door/unpowered/shuttle/close()
	playsound(src, 'sound/machines/windowdoor.ogg', 100, 1)
	return ..()