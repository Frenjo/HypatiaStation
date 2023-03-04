/obj/structure/closet/crate/secure
	desc = "A secure crate."
	name = "Secure crate"
	icon_state = "securecrate"
	icon_opened = "securecrateopen"
	icon_closed = "securecrate"

	var/redlight = "securecrater"
	var/greenlight = "securecrateg"
	var/sparks = "securecratesparks"
	var/emag = "securecrateemag"
	var/broken = 0
	var/locked = 1

/obj/structure/closet/crate/secure/New()
	. = ..()
	if(locked)
		overlays.Cut()
		overlays.Add(redlight)
	else
		overlays.Cut()
		overlays.Add(greenlight)

/obj/structure/closet/crate/secure/can_open()
	return !locked

/obj/structure/closet/crate/secure/proc/togglelock(mob/user as mob)
	if(src.opened)
		to_chat(user, SPAN_NOTICE("Close the crate first."))
		return
	if(src.broken)
		to_chat(user, SPAN_WARNING("The crate appears to be broken."))
		return
	if(src.allowed(user))
		src.locked = !src.locked
		for(var/mob/O in viewers(user, 3))
			if(O.client && !O.blinded)
				to_chat(O, SPAN_NOTICE("The crate has been [locked ? null : "un"]locked by [user]."))
		overlays.Cut()
		overlays.Add(locked ? redlight : greenlight)
	else
		to_chat(user, SPAN_NOTICE("Access denied."))

/obj/structure/closet/crate/secure/verb/verb_togglelock()
	set src in oview(1) // One square distance
	set category = "Object"
	set name = "Toggle Lock"

	if(!usr.canmove || usr.stat || usr.restrained()) // Don't use it if you're not able to! Checks for stuns, ghost and restrain
		return

	if(ishuman(usr))
		src.add_fingerprint(usr)
		src.togglelock(usr)
	else
		to_chat(usr, SPAN_WARNING("This mob type can't use this verb."))

/obj/structure/closet/crate/secure/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	if(locked)
		src.togglelock(user)
	else
		src.toggle(user)

/obj/structure/closet/crate/secure/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(is_type_in_list(W, list(/obj/item/weapon/package_wrap, /obj/item/stack/cable_coil, /obj/item/device/radio/electropack, /obj/item/weapon/wirecutters)))
		return ..()
	if(locked && (istype(W, /obj/item/weapon/card/emag) || istype(W, /obj/item/weapon/melee/energy/blade)))
		overlays.Cut()
		overlays.Add(emag)
		overlays.Add(sparks)
		spawn(6)
			overlays.Remove(sparks) //Tried lots of stuff but nothing works right. so i have to use this *sadface*
		playsound(src, "sparks", 60, 1)
		src.locked = 0
		src.broken = 1
		to_chat(user, SPAN_NOTICE("You unlock \the [src]."))
		return
	if(!opened)
		src.togglelock(user)
		return
	return ..()

/obj/structure/closet/crate/secure/emp_act(severity)
	for(var/obj/O in src)
		O.emp_act(severity)
	if(!broken && !opened  && prob(50 / severity))
		if(!locked)
			src.locked = 1
			overlays.Cut()
			overlays.Add(redlight)
		else
			overlays.Cut()
			overlays.Add(emag)
			overlays.Add(sparks)
			spawn(6)
				overlays.Remove(sparks) //Tried lots of stuff but nothing works right. so i have to use this *sadface*
			playsound(src, 'sound/effects/sparks4.ogg', 75, 1)
			src.locked = 0
	if(!opened && prob(20 / severity))
		if(!locked)
			open()
		else
			src.req_access = list()
			src.req_access.Add(pick(get_all_accesses()))
	..()