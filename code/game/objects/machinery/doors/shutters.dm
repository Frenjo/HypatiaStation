/obj/machinery/door/poddoor/shutters
	name = "Shutters"
	icon = 'icons/obj/doors/pod/poddoor_single.dmi'
	icon_state = "shutter1"
	power_channel = ENVIRON

/obj/machinery/door/poddoor/shutters/New()
	..()
	layer = 3.1

/obj/machinery/door/poddoor/shutters/attackby(obj/item/C as obj, mob/user as mob)
	add_fingerprint(user)
	if(!istype(C, /obj/item/crowbar || (istype(C, /obj/item/twohanded/fireaxe) && C:wielded == 1)))
		return
	if(density && (stat & NOPOWER) && !operating)
		operating = 1
		spawn(-1)
			flick("shutterc0", src)
			icon_state = "shutter0"
			sleep(15)
			density = FALSE
			set_opacity(0)
			operating = 0
			return
	return

/obj/machinery/door/poddoor/shutters/open()
	if(operating == 1) //doors can still open when emag-disabled
		return
	if(!global.CTticker)
		return 0
	if(!operating) //in case of emag
		operating = 1
	flick("shutterc0", src)
	icon_state = "shutter0"
	sleep(10)
	density = FALSE
	set_opacity(0)
	update_nearby_tiles()

	if(operating == 1) //emag again
		operating = 0
	if(autoclose)
		spawn(150)
			autoclose()		//TODO: note to self: look into this ~Carn
	return 1

/obj/machinery/door/poddoor/shutters/close()
	if(operating)
		return
	operating = 1
	flick("shutterc1", src)
	icon_state = "shutter1"
	density = TRUE
	if(visible)
		set_opacity(1)
	update_nearby_tiles()

	sleep(10)
	operating = 0
	return