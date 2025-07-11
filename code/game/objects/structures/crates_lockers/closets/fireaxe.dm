//I still dont think this should be a closet but whatever
/obj/structure/closet/fireaxecabinet
	name = "fire axe cabinet"
	desc = "There is small label that reads \"For Emergency use only\" along with details for safe use of the axe. As if."
	var/obj/item/twohanded/fireaxe/fireaxe
	icon_state = "fireaxe1000"
	icon_closed = "fireaxe1000"
	icon_opened = "fireaxe1100"
	anchored = TRUE
	density = FALSE
	var/localopened = 0 //Setting this to keep it from behaviouring like a normal closet and obstructing movement in the map. -Agouri
	opened = 1
	var/hitstaken = 0
	var/locked = 1
	var/smashed = 0

/obj/structure/closet/fireaxecabinet/New()
	..()
	fireaxe = new /obj/item/twohanded/fireaxe(src)

/obj/structure/closet/fireaxecabinet/attackby(obj/item/O, mob/user)  //Marker -Agouri
	//..() //That's very useful, Erro
	var/hasaxe = 0       //gonna come in handy later~
	if(fireaxe)
		hasaxe = 1

	if(isrobot(usr) || src.locked)
		if(ismultitool(O))
			to_chat(user, SPAN_WARNING("Resetting circuitry..."))
			playsound(user, 'sound/machines/lockreset.ogg', 50, 1)
			sleep(50) // Sleeping time~
			src.locked = 0
			to_chat(user, SPAN_INFO("You disable the locking modules."))
			update_icon()
			return
		else if(isitem(O))
			var/obj/item/W = O
			if(src.smashed || src.localopened)
				if(localopened)
					localopened = 0
					icon_state = "fireaxe[hasaxe][localopened][hitstaken][smashed]closing"
					spawn(10)
						update_icon()
				return
			else
				playsound(user, 'sound/effects/glass/glass_hit.ogg', 100, 1) //We don't want this playing every time
			if(W.force < 15)
				to_chat(user, SPAN_INFO("The cabinet's protective glass glances off the hit."))
			else
				src.hitstaken++
				if(src.hitstaken == 4)
					playsound(user, 'sound/effects/glass/glass_break3.ogg', 100, 1) //Break cabinet, receive goodies. Cabinet's fucked for life after that.
					src.smashed = 1
					src.locked = 0
					src.localopened = 1
			update_icon()
		return
	if(istype(O, /obj/item/twohanded/fireaxe) && src.localopened)
		if(!fireaxe)
			if(O:wielded)
				to_chat(user, SPAN_WARNING("Unwield the axe first."))
				return
			fireaxe = O
			user.drop_item(O)
			src.contents.Add(O)
			to_chat(user, SPAN_INFO("You place the fire axe back in the [src.name]."))
			update_icon()
		else
			if(src.smashed)
				return
			else
				localopened = !localopened
				if(localopened)
					icon_state = "fireaxe[hasaxe][localopened][hitstaken][smashed]opening"
					spawn(10)
						update_icon()
				else
					icon_state = "fireaxe[hasaxe][localopened][hitstaken][smashed]closing"
					spawn(10)
						update_icon()
	else
		if(src.smashed)
			return
		if(ismultitool(O))
			if(localopened)
				localopened = 0
				icon_state = "fireaxe[hasaxe][localopened][hitstaken][smashed]closing"
				spawn(10) update_icon()
				return
			else
				to_chat(user, SPAN_WARNING("Resetting circuitry..."))
				sleep(50)
				src.locked = 1
				to_chat(user, SPAN_INFO("You re-enable the locking modules."))
				playsound(user, 'sound/machines/lockenable.ogg', 50, 1)
				return
		else
			localopened = !localopened
			if(localopened)
				icon_state = "fireaxe[hasaxe][localopened][hitstaken][smashed]opening"
				spawn(10)
					update_icon()
			else
				icon_state = "fireaxe[hasaxe][localopened][hitstaken][smashed]closing"
				spawn(10)
					update_icon()

/obj/structure/closet/fireaxecabinet/attack_hand(mob/user)
	var/hasaxe = 0
	if(fireaxe)
		hasaxe = 1

	if(src.locked)
		to_chat(user, SPAN_WARNING("The cabinet won't budge!"))
		return
	if(localopened)
		if(fireaxe)
			user.put_in_hands(fireaxe)
			fireaxe = null
			to_chat(user, SPAN_INFO("You take the fire axe from the [name]."))
			src.add_fingerprint(user)
			update_icon()
		else
			if(src.smashed)
				return
			else
				localopened = !localopened
				if(localopened)
					src.icon_state = "fireaxe[hasaxe][localopened][hitstaken][smashed]opening"
					spawn(10)
						update_icon()
				else
					src.icon_state = "fireaxe[hasaxe][localopened][hitstaken][smashed]closing"
					spawn(10)
						update_icon()

	else
		localopened = !localopened //I'm pretty sure we don't need an if(src.smashed) in here. In case I'm wrong and it fucks up teh cabinet, **MARKER**. -Agouri
		if(localopened)
			src.icon_state = "fireaxe[hasaxe][localopened][hitstaken][smashed]opening"
			spawn(10)
				update_icon()
		else
			src.icon_state = "fireaxe[hasaxe][localopened][hitstaken][smashed]closing"
			spawn(10)
				update_icon()

/obj/structure/closet/fireaxecabinet/attack_tk(mob/user)
	if(localopened && fireaxe)
		fireaxe.forceMove(loc)
		to_chat(user, SPAN_INFO("You telekinetically remove the fire axe."))
		fireaxe = null
		update_icon()
		return
	attack_hand(user)

/obj/structure/closet/fireaxecabinet/verb/toggle_openness() //nice name, huh? HUH?! -Erro //YEAH -Agouri
	set category = PANEL_OBJECT
	set name = "Open/Close"

	if(isrobot(usr) || src.locked || src.smashed)
		if(src.locked)
			to_chat(usr, SPAN_WARNING("The cabinet won't budge!"))
		else if(src.smashed)
			to_chat(usr, SPAN_INFO("The protective glass is broken!"))
		return

	localopened = !localopened
	update_icon()

/obj/structure/closet/fireaxecabinet/verb/remove_fire_axe()
	set category = PANEL_OBJECT
	set name = "Remove Fire Axe"

	if(isrobot(usr))
		return

	if(localopened)
		if(fireaxe)
			usr.put_in_hands(fireaxe)
			fireaxe = null
			to_chat(usr, SPAN_INFO("You take the fire axe from the [name]."))
		else
			to_chat(usr, SPAN_INFO("The [src.name] is empty."))
	else
		to_chat(usr, SPAN_INFO("The [src.name] is closed."))
	update_icon()

/obj/structure/closet/fireaxecabinet/attack_paw(mob/user)
	attack_hand(user)
	return

/obj/structure/closet/fireaxecabinet/attack_ai(mob/user)
	if(src.smashed)
		to_chat(user, SPAN_WARNING("The security of the cabinet is compromised."))
		return
	else
		locked = !locked
		if(locked)
			to_chat(user, SPAN_WARNING("Cabinet locked."))
		else
			to_chat(user, SPAN_INFO("Cabinet unlocked."))
		return

/obj/structure/closet/fireaxecabinet/update_icon() //Template: fireaxe[has fireaxe][is opened][hits taken][is smashed]. If you want the opening or closing animations, add "opening" or "closing" right after the numbers
	var/hasaxe = 0
	if(fireaxe)
		hasaxe = 1
	icon_state = "fireaxe[hasaxe][localopened][hitstaken][smashed]"

/obj/structure/closet/fireaxecabinet/open()
	return

/obj/structure/closet/fireaxecabinet/close()
	return