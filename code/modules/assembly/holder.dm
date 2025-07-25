/obj/item/assembly_holder
	name = "Assembly"
	icon = 'icons/obj/items/assemblies/new_assemblies.dmi'
	icon_state = "holder"
	item_state = "assembly"
	obj_flags = OBJ_FLAG_CONDUCT
	throwforce = 5
	w_class = 2.0
	throw_speed = 3
	throw_range = 10

	var/secured = 0
	var/obj/item/assembly/a_left = null
	var/obj/item/assembly/a_right = null
	var/obj/special_assembly = null

/obj/item/assembly_holder/proc/attach(obj/item/D, obj/item/D2, mob/user)
	return

/obj/item/assembly_holder/proc/attach_special(obj/O, mob/user)
	return

/obj/item/assembly_holder/proc/process_activation(obj/item/D)
	return

/obj/item/assembly_holder/proc/detached()
	return

/obj/item/assembly_holder/IsAssemblyHolder()
	return 1

/obj/item/assembly_holder/attach(obj/item/D, obj/item/D2, mob/user)
	if(!D || !D2)
		return 0
	if(!isassembly(D) || !isassembly(D2))
		return 0
	if(D:secured || D2:secured)
		return 0
	if(user)
		user.remove_from_mob(D)
		user.remove_from_mob(D2)
	D:holder = src
	D2:holder = src
	D.forceMove(src)
	D2.forceMove(src)
	a_left = D
	a_right = D2
	name = "[D.name]-[D2.name] assembly"
	update_icon()
	usr.put_in_hands(src)

	return 1

/obj/item/assembly_holder/attach_special(obj/O, mob/user)
	if(!O)
		return
	if(!O.IsSpecialAssembly())
		return 0

/*	if(O:Attach_Holder())
		special_assembly = O
		update_icon()
		src.name = "[a_left.name] [a_right.name] [special_assembly.name] assembly"
*/
	return

/obj/item/assembly_holder/update_icon()
	cut_overlays()
	if(a_left)
		add_overlay("[a_left.icon_state]_left")
		for(var/O in a_left.attached_overlays)
			add_overlay("[O]_l")
	if(a_right)
		add_overlay("[a_right.icon_state]_right")
		for(var/O in a_right.attached_overlays)
			add_overlay("[O]_r")
	if(master)
		master.update_icon()

/*	if(special_assembly)
		special_assembly.update_icon()
		if(special_assembly:small_icon_state)
			add_overlay(special_assembly:small_icon_state)
			for(var/O in special_assembly:small_icon_state_overlays)
				add_overlay(O)
*/

/obj/item/assembly_holder/examine()
	set src in view()
	..()
	if((in_range(src, usr) || src.loc == usr))
		if(src.secured)
			to_chat(usr, "\The [src] is ready!")
		else
			to_chat(usr, "\The [src] can be attached!")
	return

/obj/item/assembly_holder/HasProximity(atom/movable/AM)
	if(a_left)
		a_left.HasProximity(AM)
	if(a_right)
		a_right.HasProximity(AM)
	if(special_assembly)
		special_assembly.HasProximity(AM)

/obj/item/assembly_holder/Crossed(atom/movable/AM)
	if(a_left)
		a_left.Crossed(AM)
	if(a_right)
		a_right.Crossed(AM)
	if(special_assembly)
		special_assembly.Crossed(AM)

/obj/item/assembly_holder/on_found(mob/finder)
	if(a_left)
		a_left.on_found(finder)
	if(a_right)
		a_right.on_found(finder)
	if(special_assembly)
		if(isitem(special_assembly))
			var/obj/item/S = special_assembly
			S.on_found(finder)

/obj/item/assembly_holder/Move()
	..()
	if(a_left && a_right)
		a_left.holder_movement()
		a_right.holder_movement()
//	if(special_assembly)
//		special_assembly:holder_movement()
	return

/obj/item/assembly_holder/attack_hand()	//Perhapse this should be a holder_pickup proc instead, can add if needbe I guess
	if(a_left && a_right)
		a_left.holder_movement()
		a_right.holder_movement()
//	if(special_assembly)
//		special_assembly:Holder_Movement()
	..()
	return

/obj/item/assembly_holder/attackby(obj/item/W, mob/user)
	if(isscrewdriver(W))
		if(!a_left || !a_right)
			to_chat(user, SPAN_WARNING("BUG:Assembly part missing, please report this!"))
			return
		a_left.toggle_secure()
		a_right.toggle_secure()
		secured = !secured
		if(secured)
			to_chat(user, SPAN_INFO("\The [src] is ready!"))
		else
			to_chat(user, SPAN_INFO("\The [src] can now be taken apart!"))
		update_icon()
		return
	else if(W.IsSpecialAssembly())
		attach_special(W, user)
	else
		..()
	return

/obj/item/assembly_holder/attack_self(mob/user)
	src.add_fingerprint(user)
	if(src.secured)
		if(!a_left || !a_right)
			to_chat(user, SPAN_WARNING("Assembly part missing!"))
			return
		if(istype(a_left, a_right.type))	//If they are the same type it causes issues due to window code
			switch(alert("Which side would you like to use?", , "Left", "Right"))
				if("Left")
					a_left.attack_self(user)
				if("Right")
					a_right.attack_self(user)
			return
		else
			if(!istype(a_left, /obj/item/assembly/igniter))
				a_left.attack_self(user)
			if(!istype(a_right, /obj/item/assembly/igniter))
				a_right.attack_self(user)
	else
		var/turf/T = GET_TURF(src)
		if(isnull(T))
			return 0
		if(a_left)
			a_left:holder = null
			a_left.forceMove(T)
		if(a_right)
			a_right:holder = null
			a_right.forceMove(T)
		spawn(0)
			qdel(src)
	return

/obj/item/assembly_holder/process_activation(obj/D, normal = 1, special = 1)
	if(!D)
		return 0
	if(!secured)
		visible_message("\icon[src] *beep* *beep*", "*beep* *beep*")
	if(normal && a_right && a_left)
		if(a_right != D)
			a_right.pulsed(0)
		if(a_left != D)
			a_left.pulsed(0)
	if(master)
		master.receive_signal()
//	if(special && special_assembly)
//		if(!special_assembly == D)
//			special_assembly.dothings()
	return 1


/obj/item/assembly_holder/timer_igniter
	name = "timer-igniter assembly"

/obj/item/assembly_holder/timer_igniter/New()
	. = ..()
	var/obj/item/assembly/igniter/ign = new(src)
	ign.secured = 1
	ign.holder = src
	var/obj/item/assembly/timer/tmr = new(src)
	tmr.time = 5
	tmr.secured = 1
	tmr.holder = src
	a_left = tmr
	a_right = ign
	secured = 1

	update_icon()
	name = initial(name) + " ([tmr.time] secs)"

	loc.verbs += /obj/item/assembly_holder/timer_igniter/verb/configure

/obj/item/assembly_holder/timer_igniter/initialise()
	. = ..()
	START_PROCESSING(PCobj, a_left)

/obj/item/assembly_holder/timer_igniter/detached()
	loc.verbs -= /obj/item/assembly_holder/timer_igniter/verb/configure
	..()

/obj/item/assembly_holder/timer_igniter/verb/configure()
	set category = PANEL_OBJECT
	set name = "Set Timer"
	set src in usr

	if(!(usr.stat || usr.restrained()))
		var/obj/item/assembly_holder/holder
		if(istype(src, /obj/item/grenade/chemical))
			var/obj/item/grenade/chemical/gren = src
			holder = gren.detonator
		var/obj/item/assembly/timer/tmr = holder.a_left
		if(!istype(tmr, /obj/item/assembly/timer))
			tmr = holder.a_right
		if(!istype(tmr, /obj/item/assembly/timer))
			to_chat(usr, SPAN_NOTICE("This detonator has no timer."))
			return

		if(tmr.timing)
			to_chat(usr, SPAN_NOTICE("Clock is ticking already."))
		else
			var/ntime = input("Enter desired time in seconds", "Time", "5") as num
			if(ntime > 0 && ntime < 1000)
				tmr.time = ntime
				name = initial(name) + "([tmr.time] secs)"
				to_chat(usr, SPAN_NOTICE("Timer set to [tmr.time] seconds."))
			else
				to_chat(usr, SPAN_NOTICE("Timer can't be [ntime <=0 ? "negative" : "more than 1000 seconds"]."))
	else
		to_chat(usr, SPAN_NOTICE("You cannot do this while [usr.stat ? "unconscious/dead" : "restrained"]."))