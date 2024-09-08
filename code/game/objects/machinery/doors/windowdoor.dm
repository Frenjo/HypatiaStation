/obj/machinery/door/window
	name = "interior door"
	desc = "A strong door."
	icon = 'icons/obj/doors/windoor.dmi'
	icon_state = "left"

	opacity = FALSE
	visible = FALSE
	atom_flags = ATOM_FLAG_ON_BORDER

	power_state = USE_POWER_OFF

	explosion_resistance = 5
	air_properties_vary_with_direction = 1

	var/obj/item/airlock_electronics/electronics = null

	var/base_state = "left"
	var/health = 150.0 //If you change this, consiter changing ../door/window/brigdoor/ health at the bottom of this .dm file

/obj/machinery/door/window/update_nearby_tiles(need_rebuild)
	global.PCair?.mark_for_update(GET_TURF(src))

/obj/machinery/door/window/initialise()
	. = ..()
	if(length(req_access))
		icon_state = "[icon_state]"
		base_state = icon_state

/obj/machinery/door/window/Destroy()
	density = FALSE
	return ..()

/obj/machinery/door/window/Bumped(atom/movable/AM)
	if(!ismob(AM))
		var/obj/machinery/bot/bot = AM
		if(istype(bot))
			if(density && check_access(bot.botcard))
				open()
				sleep(50)
				close()
		else if(ismecha(AM))
			var/obj/mecha/mecha = AM
			if(density)
				if(mecha.occupant && allowed(mecha.occupant))
					open()
					sleep(50)
					close()
		return
	if(!global.PCticker)
		return
	if(operating)
		return
	if(density && allowed(AM))
		open()
		if(check_access(null))
			sleep(50)
		else //secure doors close faster
			sleep(20)
		close()
	return

/obj/machinery/door/window/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(istype(mover) && HAS_PASS_FLAGS(mover, PASS_FLAG_GLASS))
		return TRUE
	if(get_dir(loc, target) == dir) //Make sure looking at appropriate border
		if(air_group)
			return FALSE
		return !density
	else
		return TRUE

/obj/machinery/door/window/CheckExit(atom/movable/mover, turf/target)
	if(istype(mover) && HAS_PASS_FLAGS(mover, PASS_FLAG_GLASS))
		return 1
	if(get_dir(loc, target) == dir)
		return !density
	else
		return 1

/obj/machinery/door/window/open()
	if(operating == 1) //doors can still open when emag-disabled
		return 0
	if(!global.PCticker)
		return 0
	if(!operating) //in case of emag
		operating = 1
	flick("[base_state]opening", src)
	playsound(src, 'sound/machines/windowdoor.ogg', 100, 1)
	icon_state = "[base_state]open"
	sleep(10)

	explosion_resistance = 0
	density = FALSE
//	sd_SetOpacity(0)	//TODO: why is this here? Opaque windoors? ~Carn
	update_nearby_tiles()

	if(operating == 1) //emag again
		operating = 0
	return 1

/obj/machinery/door/window/close()
	if(operating)
		return 0
	operating = 1
	flick("[base_state]closing", src)
	playsound(src, 'sound/machines/windowdoor.ogg', 100, 1)
	icon_state = base_state

	density = TRUE
	explosion_resistance = initial(explosion_resistance)
//	if(visible)
//		SetOpacity(1)	//TODO: why is this here? Opaque windoors? ~Carn
	update_nearby_tiles()

	sleep(10)

	operating = 0
	return 1

/obj/machinery/door/window/proc/take_damage(damage)
	health = max(0, health - damage)
	if(health <= 0)
		new /obj/item/shard(loc)
		var/obj/item/stack/cable_coil/CC = new /obj/item/stack/cable_coil(loc)
		CC.amount = 2
		var/obj/item/airlock_electronics/ae
		if(!electronics)
			ae = new/obj/item/airlock_electronics(loc)
			if(!req_access)
				check_access()
			if(length(req_access))
				ae.conf_access = req_access
			else if(length(req_one_access))
				ae.conf_access = req_one_access
				ae.one_access = 1
		else
			ae = electronics
			electronics = null
			ae.loc = loc
		if(operating == -1)
			ae.icon_state = "door_electronics_smoked"
			operating = 0
		density = FALSE
		playsound(src, "shatter", 70, 1)
		qdel(src)
		return

/obj/machinery/door/window/bullet_act(obj/item/projectile/Proj)
	if(Proj.damage)
		take_damage(round(Proj.damage / 2))
	..()

//When an object is thrown at the window
/obj/machinery/door/window/hitby(atom/movable/AM)
	..()
	visible_message(SPAN_DANGER("The glass door was hit by [AM]."), 1)
	var/tforce = 0
	if(ismob(AM))
		tforce = 40
	else
		tforce = AM:throwforce
	playsound(src, 'sound/effects/Glasshit.ogg', 100, 1)
	take_damage(tforce)
	//..() //Does this really need to be here twice? The parent proc doesn't even do anything yet. - Nodrak
	return

/obj/machinery/door/window/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/door/window/attack_hand(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			playsound(src, 'sound/effects/Glasshit.ogg', 75, 1)
			visible_message(SPAN_DANGER("[user] smashes against the [name]."), 1)
			take_damage(25)
			return

	return attackby(user, user)

/obj/machinery/door/window/attackby(obj/item/I, mob/user)
	//If it's in the process of opening/closing, ignore the click
	if(operating == 1)
		return

	//Emags and ninja swords? You may pass.
	if(density && (istype(I, /obj/item/card/emag) || istype(I, /obj/item/melee/energy/blade)))
		operating = -1
		if(istype(I, /obj/item/melee/energy/blade))
			make_sparks(5, FALSE, loc)
			playsound(src, "sparks", 50, 1)
			playsound(src, 'sound/weapons/blade1.ogg', 50, 1)
			visible_message(SPAN_INFO("The glass door was sliced open by [user]!"))
		flick("[base_state]spark", src)
		sleep(6)
		open()
		return 1

	//If it's emagged, crowbar can pry electronics out.
	if(operating == -1 && iscrowbar(I))
		playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
		user.visible_message("[user] removes the electronics from the windoor.", "You start to remove electronics from the windoor.")
		if(do_after(user, 40))
			to_chat(user, SPAN_INFO("You removed the windoor electronics!"))

			var/obj/structure/windoor_assembly/wa = new/obj/structure/windoor_assembly(loc)
			if(istype(src, /obj/machinery/door/window/brigdoor))
				wa.secure = "secure_"
				wa.name = "Secure Wired Windoor Assembly"
			else
				wa.name = "Wired Windoor Assembly"
			if(base_state == "right" || base_state == "rightsecure")
				wa.facing = "r"
			wa.set_dir(dir)
			wa.state = "02"
			wa.update_icon()

			var/obj/item/airlock_electronics/ae
			if(!electronics)
				ae = new/obj/item/airlock_electronics(loc)
				if(!req_access)
					check_access()
				if(length(req_access))
					ae.conf_access = req_access
				else if(length(req_one_access))
					ae.conf_access = req_one_access
					ae.one_access = 1
			else
				ae = electronics
				electronics = null
				ae.loc = loc
			ae.icon_state = "door_electronics_smoked"

			operating = 0
			qdel(src)
			return

	//If it's a weapon, smash windoor. Unless it's an id card, agent card, ect.. then ignore it (Cards really shouldnt damage a door anyway)
	if(density && isitem(I) && !istype(I, /obj/item/card))
		var/aforce = I.force
		playsound(src, 'sound/effects/Glasshit.ogg', 75, 1)
		visible_message(SPAN_DANGER("[src] was hit by [I]."))
		if(I.damtype == BRUTE || I.damtype == BURN)
			take_damage(aforce)
		return

	add_fingerprint(user)
	if(!requiresID())
		//don't care who they are or what they have, act as if they're NOTHING
		user = null

	if(allowed(user))
		if(density)
			open()
		else
			close()

	else if(density)
		flick("[base_state]deny", src)
	return


/obj/machinery/door/window/brigdoor
	name = "Secure Door"
	icon = 'icons/obj/doors/windoor.dmi'
	icon_state = "leftsecure"
	base_state = "leftsecure"
	req_access = list(ACCESS_SECURITY)
	var/id = null
	health = 300.0 //Stronger doors for prison (regular window door health is 150)


/obj/machinery/door/window/northleft
	dir = NORTH

/obj/machinery/door/window/eastleft
	dir = EAST

/obj/machinery/door/window/westleft
	dir = WEST

/obj/machinery/door/window/southleft
	dir = SOUTH

/obj/machinery/door/window/northright
	dir = NORTH
	icon_state = "right"
	base_state = "right"

/obj/machinery/door/window/eastright
	dir = EAST
	icon_state = "right"
	base_state = "right"

/obj/machinery/door/window/westright
	dir = WEST
	icon_state = "right"
	base_state = "right"

/obj/machinery/door/window/southright
	dir = SOUTH
	icon_state = "right"
	base_state = "right"

/obj/machinery/door/window/brigdoor/northleft
	dir = NORTH

/obj/machinery/door/window/brigdoor/eastleft
	dir = EAST

/obj/machinery/door/window/brigdoor/westleft
	dir = WEST

/obj/machinery/door/window/brigdoor/southleft
	dir = SOUTH

/obj/machinery/door/window/brigdoor/northright
	dir = NORTH
	icon_state = "rightsecure"
	base_state = "rightsecure"

/obj/machinery/door/window/brigdoor/eastright
	dir = EAST
	icon_state = "rightsecure"
	base_state = "rightsecure"

/obj/machinery/door/window/brigdoor/westright
	dir = WEST
	icon_state = "rightsecure"
	base_state = "rightsecure"

/obj/machinery/door/window/brigdoor/southright
	dir = SOUTH
	icon_state = "rightsecure"
	base_state = "rightsecure"