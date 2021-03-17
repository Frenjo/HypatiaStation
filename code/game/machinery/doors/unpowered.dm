/obj/machinery/door/unpowered
	//autoclose = 0
	autoclose = 1 // Fixes shuttle doors not automatically closing themselves.
	var/welded = 0 // ...HOPEFULLY... -Frenjo
	var/locked = 0


	Bumped(atom/AM)
		if(src.locked)
			return
		..()
		return


	attackby(obj/item/I as obj, mob/user as mob)
		if(istype(I, /obj/item/weapon/card/emag)||istype(I, /obj/item/weapon/melee/energy/blade))	return
		if(src.locked)	return
		..()
		return



/obj/machinery/door/unpowered/shuttle
	icon = 'icons/turf/shuttle.dmi'
	name = "door"
	icon_state = "door1"
	opacity = 1
	density = 1

// Play a sound for the shuttle doors because they don't already. -Frenjo
/obj/machinery/door/unpowered/shuttle/open()
	playsound(src, 'sound/machines/windowdoor.ogg', 100, 1)
	return ..()

/obj/machinery/door/unpowered/shuttle/close()
	playsound(src, 'sound/machines/windowdoor.ogg', 100, 1)
	return ..()