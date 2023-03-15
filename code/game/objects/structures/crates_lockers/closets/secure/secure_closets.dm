/obj/structure/closet/secure_closet
	name = "secure locker"
	desc = "It's an immobile card-locked storage unit."
	icon = 'icons/obj/closet.dmi'
	icon_state = "secure1"
	density = TRUE
	opened = 0

	icon_closed = "secure"
	icon_opened = "secureopen"

	wall_mounted = FALSE //never solid (You can always pass over it)
	health = 200

	var/locked = 1
	var/broken = 0
	var/large = 1

	var/icon_locked = "secure1"
	var/icon_broken = "securebroken"
	var/icon_off = "secureoff"

/obj/structure/closet/secure_closet/can_open()
	if(src.locked)
		return 0
	return ..()

/obj/structure/closet/secure_closet/close()
	if(..())
		if(broken)
			icon_state = src.icon_off
		return 1
	else
		return 0

/obj/structure/closet/secure_closet/emp_act(severity)
	for(var/obj/O in src)
		O.emp_act(severity)
	if(!broken)
		if(prob(50 / severity))
			src.locked = !src.locked
			src.update_icon()
		if(prob(20 / severity) && !opened)
			if(!locked)
				open()
			else
				src.req_access = list()
				src.req_access.Add(pick(get_all_accesses()))
	..()

/obj/structure/closet/secure_closet/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(src.opened)
		if(istype(W, /obj/item/weapon/grab))
			if(src.large)
				src.MouseDrop_T(W:affecting, user)	//act like they were dragged onto the closet
			else
				to_chat(user, SPAN_NOTICE("The locker is too small to stuff [W:affecting] into!"))
		if(isrobot(user))
			return
		user.drop_item()
		if(W)
			W.loc = src.loc
	else if((istype(W, /obj/item/weapon/card/emag)||istype(W, /obj/item/weapon/melee/energy/blade)) && !src.broken)
		broken = 1
		locked = 0
		desc = "It appears to be broken."
		icon_state = icon_off
		flick(icon_broken, src)
		if(istype(W, /obj/item/weapon/melee/energy/blade))
			var/datum/effect/system/spark_spread/spark_system = new /datum/effect/system/spark_spread()
			spark_system.set_up(5, 0, src.loc)
			spark_system.start()
			playsound(src, 'sound/weapons/blade1.ogg', 50, 1)
			playsound(src, "sparks", 50, 1)
			for(var/mob/O in viewers(user, 3))
				O.show_message(SPAN_WARNING("The locker has been sliced open by [user] with an energy blade!"), 1, "You hear metal being sliced and sparks flying.", 2)
		else
			for(var/mob/O in viewers(user, 3))
				O.show_message(SPAN_WARNING("The locker has been broken by [user] with an electromagnetic card!"), 1, "You hear a faint electrical spark.", 2)
	else if(istype(W, /obj/item/weapon/package_wrap) || istype(W, /obj/item/weapon/weldingtool))
		return ..(W, user)
	else
		togglelock(user)

/obj/structure/closet/secure_closet/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	if(src.locked)
		src.togglelock(user)
	else
		src.toggle(user)

/obj/structure/closet/secure_closet/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/closet/secure_closet/update_icon()//Putting the welded stuff in updateicon() so it's easy to overwrite for special cases (Fridges, cabinets, and whatnot)
	overlays.Cut()
	if(!opened)
		if(locked)
			icon_state = icon_locked
		else
			icon_state = icon_closed
		if(welded)
			overlays.Add("welded")
	else
		icon_state = icon_opened

/obj/structure/closet/secure_closet/proc/togglelock(mob/user as mob)
	if(src.opened)
		to_chat(user, SPAN_NOTICE("Close the locker first."))
		return
	if(src.broken)
		to_chat(user, SPAN_WARNING("The locker appears to be broken."))
		return
	if(user.loc == src)
		to_chat(user, SPAN_NOTICE("You can't reach the lock from inside."))
		return
	if(src.allowed(user))
		src.locked = !src.locked
		for(var/mob/O in viewers(user, 3))
			if((O.client && !(O.blinded)))
				to_chat(O, SPAN_NOTICE("The locker has been [locked ? null : "un"]locked by [user]."))
		update_icon()
	else
		to_chat(user, FEEDBACK_ACCESS_DENIED)

/obj/structure/closet/secure_closet/verb/verb_togglelock()
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