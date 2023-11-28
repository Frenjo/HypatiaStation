/obj/machinery/door/poddoor
	name = "Podlock"
	desc = "Why it no open!!!"
	icon = 'icons/obj/doors/pod/poddoor_single.dmi'
	icon_state = "pdoor1"
	layer = 3
	open_layer = 3
	closed_layer = 3.3
	dir = 1
	explosion_resistance = 25

	var/id = 1.0

/obj/machinery/door/poddoor/Bumped(atom/AM)
	if(!density)
		return ..()
	else
		return 0

/obj/machinery/door/poddoor/attackby(obj/item/C as obj, mob/user as mob)
	add_fingerprint(user)
	if(!istype(C, /obj/item/crowbar || (istype(C, /obj/item/twohanded/fireaxe) && C:wielded == 1)))
		return
	if(density && (stat & NOPOWER) && !operating)
		spawn(0)
			operating = 1
			flick("pdoorc0", src)
			icon_state = "pdoor0"
			set_opacity(0)
			sleep(15)
			density = FALSE
			operating = 0
			return
	return

/obj/machinery/door/poddoor/open()
	if(operating == 1) //doors can still open when emag-disabled
		return
	if(!global.CTticker)
		return 0
	if(!operating) //in case of emag
		operating = 1
	flick("pdoorc0", src)
	icon_state = "pdoor0"
	set_opacity(0)
	sleep(10)
	reset_plane_and_layer()
	density = FALSE
	update_nearby_tiles()

	if(operating == 1) //emag again
		operating = 0
	if(autoclose)
		spawn(150)
			autoclose()
	return 1

/obj/machinery/door/poddoor/close()
	if(operating)
		return
	operating = 1
	layer = closed_layer
	flick("pdoorc1", src)
	icon_state = "pdoor1"
	density = TRUE
	set_opacity(initial(opacity))
	update_nearby_tiles()

	sleep(10)
	operating = 0
	return

/*
/obj/machinery/door/poddoor/two_tile_hor/open()
	if (operating == 1) //doors can still open when emag-disabled
		return
	if (!ticker)
		return 0
	if(!operating) //in case of emag
		operating = 1
	flick("pdoorc0", src)
	icon_state = "pdoor0"
	SetOpacity(0)
	f1.SetOpacity(0)
	f2.SetOpacity(0)

	sleep(10)
	density = FALSE
	f1.density = FALSE
	f2.density = FALSE

	update_nearby_tiles()

	if(operating == 1) //emag again
		operating = 0
	if(autoclose)
		spawn(150)
			autoclose()
	return 1

/obj/machinery/door/poddoor/two_tile_hor/close()
	if (operating)
		return
	operating = 1
	flick("pdoorc1", src)
	icon_state = "pdoor1"

	density = TRUE
	f1.density = TRUE
	f2.density = TRUE

	sleep(10)
	SetOpacity(initial(opacity))
	f1.SetOpacity(initial(opacity))
	f2.SetOpacity(initial(opacity))

	update_nearby_tiles()

	operating = 0
	return

/obj/machinery/door/poddoor/four_tile_hor/open()
	if (operating == 1) //doors can still open when emag-disabled
		return
	if (!ticker)
		return 0
	if(!operating) //in case of emag
		operating = 1
	flick("pdoorc0", src)
	icon_state = "pdoor0"
	sleep(10)
	density = FALSE
	sd_SetOpacity(0)

	f1.density = FALSE
	f1.sd_SetOpacity(0)
	f2.density = FALSE
	f2.sd_SetOpacity(0)
	f3.density = FALSE
	f3.sd_SetOpacity(0)
	f4.density = FALSE
	f4.sd_SetOpacity(0)

	update_nearby_tiles()

	if(operating == 1) //emag again
		operating = 0
	if(autoclose)
		spawn(150)
			autoclose()
	return 1

/obj/machinery/door/poddoor/four_tile_hor/close()
	if (operating)
		return
	operating = 1
	flick("pdoorc1", src)
	icon_state = "pdoor1"
	density = TRUE

	f1.density = TRUE
	f1.sd_SetOpacity(1)
	f2.density = TRUE
	f2.sd_SetOpacity(1)
	f3.density = TRUE
	f3.sd_SetOpacity(1)
	f4.density = TRUE
	f4.sd_SetOpacity(1)

	if (visible)
		sd_SetOpacity(1)
	update_nearby_tiles()

	sleep(10)
	operating = 0
	return

/obj/machinery/door/poddoor/two_tile_ver/open()
	if (operating == 1) //doors can still open when emag-disabled
		return
	if (!ticker)
		return 0
	if(!operating) //in case of emag
		operating = 1
	flick("pdoorc0", src)
	icon_state = "pdoor0"
	sleep(10)
	density = FALSE
	sd_SetOpacity(0)

	f1.density = FALSE
	f1.sd_SetOpacity(0)
	f2.density = FALSE
	f2.sd_SetOpacity(0)

	update_nearby_tiles()

	if(operating == 1) //emag again
		operating = 0
	if(autoclose)
		spawn(150)
			autoclose()
	return 1

/obj/machinery/door/poddoor/two_tile_ver/close()
	if (operating)
		return
	operating = 1
	flick("pdoorc1", src)
	icon_state = "pdoor1"
	density = TRUE

	f1.density = TRUE
	f1.sd_SetOpacity(1)
	f2.density = TRUE
	f2.sd_SetOpacity(1)

	if (visible)
		sd_SetOpacity(1)
	update_nearby_tiles()

	sleep(10)
	operating = 0
	return

/obj/machinery/door/poddoor/four_tile_ver/open()
	if (operating == 1) //doors can still open when emag-disabled
		return
	if (!ticker)
		return 0
	if(!operating) //in case of emag
		operating = 1
	flick("pdoorc0", src)
	icon_state = "pdoor0"
	sleep(10)
	density = FALSE
	sd_SetOpacity(0)

	f1.density = FALSE
	f1.sd_SetOpacity(0)
	f2.density = FALSE
	f2.sd_SetOpacity(0)
	f3.density = FALSE
	f3.sd_SetOpacity(0)
	f4.density = FALSE
	f4.sd_SetOpacity(0)

	update_nearby_tiles()

	if(operating == 1) //emag again
		operating = 0
	if(autoclose)
		spawn(150)
			autoclose()
	return 1

/obj/machinery/door/poddoor/four_tile_ver/close()
	if (operating)
		return
	operating = 1
	flick("pdoorc1", src)
	icon_state = "pdoor1"
	density = TRUE

	f1.density = TRUE
	f1.sd_SetOpacity(1)
	f2.density = TRUE
	f2.sd_SetOpacity(1)
	f3.density = TRUE
	f3.sd_SetOpacity(1)
	f4.density = TRUE
	f4.sd_SetOpacity(1)

	if (visible)
		sd_SetOpacity(1)
	update_nearby_tiles()

	sleep(10)
	operating = 0
	return




/obj/machinery/door/poddoor/two_tile_hor
	var/obj/machinery/door/poddoor/filler_object/f1
	var/obj/machinery/door/poddoor/filler_object/f2
	icon = 'icons/obj/doors/1x2blast_hor.dmi'

	New()
		..()
		f1 = new/obj/machinery/door/poddoor/filler_object (loc)
		f2 = new/obj/machinery/door/poddoor/filler_object (get_step(src,EAST))
		f1.density = density
		f2.density = density
		f1.sd_SetOpacity(opacity)
		f2.sd_SetOpacity(opacity)

	Del()
		del f1
		del f2
		..()

/obj/machinery/door/poddoor/two_tile_ver
	var/obj/machinery/door/poddoor/filler_object/f1
	var/obj/machinery/door/poddoor/filler_object/f2
	icon = 'icons/obj/doors/1x2blast_vert.dmi'

	New()
		..()
		f1 = new/obj/machinery/door/poddoor/filler_object (loc)
		f2 = new/obj/machinery/door/poddoor/filler_object (get_step(src,NORTH))
		f1.density = density
		f2.density = density
		f1.sd_SetOpacity(opacity)
		f2.sd_SetOpacity(opacity)

	Del()
		del f1
		del f2
		..()

/obj/machinery/door/poddoor/four_tile_hor
	var/obj/machinery/door/poddoor/filler_object/f1
	var/obj/machinery/door/poddoor/filler_object/f2
	var/obj/machinery/door/poddoor/filler_object/f3
	var/obj/machinery/door/poddoor/filler_object/f4
	icon = 'icons/obj/doors/1x4blast_hor.dmi'

	New()
		..()
		f1 = new/obj/machinery/door/poddoor/filler_object (loc)
		f2 = new/obj/machinery/door/poddoor/filler_object (get_step(f1,EAST))
		f3 = new/obj/machinery/door/poddoor/filler_object (get_step(f2,EAST))
		f4 = new/obj/machinery/door/poddoor/filler_object (get_step(f3,EAST))
		f1.density = density
		f2.density = density
		f3.density = density
		f4.density = density
		f1.sd_SetOpacity(opacity)
		f2.sd_SetOpacity(opacity)
		f4.sd_SetOpacity(opacity)
		f3.sd_SetOpacity(opacity)

	Del()
		del f1
		del f2
		del f3
		del f4
		..()

/obj/machinery/door/poddoor/four_tile_ver
	var/obj/machinery/door/poddoor/filler_object/f1
	var/obj/machinery/door/poddoor/filler_object/f2
	var/obj/machinery/door/poddoor/filler_object/f3
	var/obj/machinery/door/poddoor/filler_object/f4
	icon = 'icons/obj/doors/1x4blast_vert.dmi'

	New()
		..()
		f1 = new/obj/machinery/door/poddoor/filler_object (loc)
		f2 = new/obj/machinery/door/poddoor/filler_object (get_step(f1,NORTH))
		f3 = new/obj/machinery/door/poddoor/filler_object (get_step(f2,NORTH))
		f4 = new/obj/machinery/door/poddoor/filler_object (get_step(f3,NORTH))
		f1.density = density
		f2.density = density
		f3.density = density
		f4.density = density
		f1.sd_SetOpacity(opacity)
		f2.sd_SetOpacity(opacity)
		f4.sd_SetOpacity(opacity)
		f3.sd_SetOpacity(opacity)

	Del()
		del f1
		del f2
		del f3
		del f4
		..()
*/

/obj/machinery/door/poddoor/filler_object
	name = ""
	icon_state = ""