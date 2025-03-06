////////////////////HOLOSIGN///////////////////////////////////////
/obj/machinery/holosign
	name = "holosign"
	desc = "Small wall-mounted holographic projector"
	icon = 'icons/obj/machines/holosign.dmi'
	icon_state = "sign_off"
	layer = 4

	power_usage = alist(
		USE_POWER_IDLE = 2,
		USE_POWER_ACTIVE = 4
	)

	var/lit = 0
	var/id = null
	var/on_icon = "sign_on"

/obj/machinery/holosign/proc/toggle()
	if(stat & (BROKEN | NOPOWER))
		return
	lit = !lit
	update_icon()

/obj/machinery/holosign/update_icon()
	if(!lit)
		icon_state = "sign_off"
	else
		icon_state = on_icon

/obj/machinery/holosign/power_change()
	if(stat & NOPOWER)
		lit = 0
	update_icon()


/obj/machinery/holosign/surgery
	name = "surgery holosign"
	desc = "Small wall-mounted holographic projector. This one reads SURGERY."
	on_icon = "surgery"


/obj/machinery/holosign/emergency_exit
	name = "emergency exit holosign"
	desc = "Small wall-mounted holographic projector. This one reads EXIT, with a helpful little arrow showing the direction."
	on_icon = "emergency_exit"

////////////////////SWITCH///////////////////////////////////////
/obj/machinery/holosign_switch
	name = "holosign switch"
	icon = 'icons/obj/power.dmi'
	icon_state = "light0"
	desc = "A remote control switch for a holosign."
	anchored = TRUE

	power_usage = alist(
		USE_POWER_IDLE = 2
	)

	var/id = null
	var/active = 0

/obj/machinery/holosign_switch/attack_ai(mob/user)
	return src.attack_hand(user)

/obj/machinery/holosign_switch/attack_paw(mob/user)
	return src.attack_hand(user)

/obj/machinery/holosign_switch/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/detective_scanner))
		return
	return src.attack_hand(user)

/obj/machinery/holosign_switch/attack_hand(mob/user)
	src.add_fingerprint(usr)
	if(stat & (NOPOWER | BROKEN))
		return
	add_fingerprint(user)

	use_power(5)

	active = !active
	if(active)
		icon_state = "light1"
	else
		icon_state = "light0"

	for(var/obj/machinery/holosign/M in GLOBL.machines)
		if(M.id == src.id)
			spawn(0)
				M.toggle()
				return

	return