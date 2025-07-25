// Disposal bin
// Holds items for disposal into pipe system
// Draws air from turf, gradually charges internal reservoir
// Once full (~1 atm), uses air resv to flush items into the pipes
// Automatically recharges air (unless off), will flush when ready if pre-set
// Can hold items and human size things, no other draggables
// Toilets are a type of disposal bin for small objects only and work on magic. By magic, I mean torque rotation
#define SEND_PRESSURE 0.05 * ONE_ATMOSPHERE

/obj/machinery/disposal
	name = "disposal unit"
	desc = "A pneumatic waste disposal unit."
	icon = 'icons/obj/pipes/disposal.dmi'
	icon_state = "disposal"
	anchored = TRUE
	density = TRUE

	power_usage = alist(
		USE_POWER_IDLE = 100,
		USE_POWER_ACTIVE = 600
	)

	var/datum/gas_mixture/air_contents	// internal reservoir
	var/mode = 1	// item mode 0=off 1=charging 2=charged
	var/flush = 0	// true if flush handle is pulled
	var/obj/structure/disposalpipe/trunk/trunk = null // the attached pipe trunk
	var/flushing = 0	// true if flushing in progress
	var/flush_every_ticks = 30 //Every 30 ticks it will look whether it is ready to flush
	var/flush_count = 0 //this var adds 1 once per tick. When it reaches flush_every_ticks it resets and tries to flush.
	var/last_sound = 0

// create a new disposal
// find the attached trunk (if present) and init gas resvr.
/obj/machinery/disposal/initialise()
	. = ..()
	trunk = locate() in loc
	if(!trunk)
		mode = 0
		flush = 0
	else
		trunk.linked = src	// link the pipe trunk to self

	air_contents = new/datum/gas_mixture(1.05 * MOLES_CELLSTANDARD)
	update()

/obj/machinery/disposal/Destroy()
	eject()
	trunk?.linked = null
	return ..()

// attack by item places it in to disposal
/obj/machinery/disposal/attackby(obj/item/I, mob/user)
	if(stat & BROKEN || !I || !user)
		return

	if(isrobot(user) && !istype(I, /obj/item/storage/bag/trash))
		return
	src.add_fingerprint(user)
	if(mode <= 0) // It's off
		if(isscrewdriver(I))
			if(length(contents))
				to_chat(user, "Eject the items first!")
				return
			if(mode == 0) // It's off but still not unscrewed
				mode = -1 // Set it to doubleoff l0l
				playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
				to_chat(user, "You remove the screws around the power connection.")
				return
			else if(mode == -1)
				mode = 0
				playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
				to_chat(user, "You attach the screws around the power connection.")
				return
		else if(iswelder(I) && mode == -1)
			if(length(contents))
				to_chat(user, "Eject the items first!")
				return
			var/obj/item/weldingtool/W = I
			if(W.remove_fuel(0, user))
				playsound(src, 'sound/items/Welder2.ogg', 100, 1)
				to_chat(user, "You start slicing the floorweld off the disposal unit.")

				if(do_after(user, 20))
					if(!src || !W.isOn())
						return
					to_chat(user, "You sliced the floorweld off the disposal unit.")
					var/obj/structure/disposalconstruct/C = new(src.loc)
					src.transfer_fingerprints_to(C)
					C.ptype = 6 // 6 = disposal unit
					C.anchored = TRUE
					C.density = TRUE
					C.update()
					qdel(src)
				return
			else
				return

	if(istype(I, /obj/item/melee/energy/blade))
		to_chat(user, "You can't place that item inside the disposal unit.")
		return

	if(istype(I, /obj/item/storage/bag/trash))
		var/obj/item/storage/bag/trash/T = I
		to_chat(user, SPAN_INFO("You empty the bag."))
		for(var/obj/item/O in T.contents)
			T.remove_from_storage(O, src)
		T.update_icon()
		update()
		return

	var/obj/item/grab/G = I
	if(istype(G))	// handle grabbed mob
		if(ismob(G.affecting))
			var/mob/GM = G.affecting
			for(var/mob/V in viewers(usr))
				V.show_message("[usr] starts putting [GM.name] into the disposal.", 3)
			if(do_after(usr, 20))
				if(GM.client)
					GM.client.perspective = EYE_PERSPECTIVE
					GM.client.eye = src
				GM.forceMove(src)
				for(var/mob/C in viewers(src))
					C.show_message(SPAN_WARNING("[GM.name] has been placed in the [src] by [user]."), 3)
				qdel(G)
				usr.attack_log += "\[[time_stamp()]\] <font color='red'>Has placed [GM.name] ([GM.ckey]) in disposals.</font>"
				GM.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been placed in disposals by [usr.name] ([usr.ckey])</font>"
				msg_admin_attack("[usr] ([usr.ckey]) placed [GM] ([GM.ckey]) in a disposals unit. (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)")
		return

	if(!I)
		return

	user.drop_item()
	if(I)
		I.forceMove(src)

	to_chat(user, "You place \the [I] into the [src].")
	for(var/mob/M in viewers(src))
		if(M == user)
			continue
		M.show_message("[user.name] places \the [I] into the [src].", 3)

	update()

// mouse drop another mob or self
/obj/machinery/disposal/MouseDrop_T(mob/target, mob/user)
	if(!istype(target) || target.buckled || get_dist(user, src) > 1 || get_dist(user, target) > 1 || user.stat || isAI(user))
		return
	if(issimple(user) && target != user)
		return //animals cannot put mobs other than themselves into disposal
	src.add_fingerprint(user)
	var/target_loc = target.loc
	var/msg
	for(var/mob/V in viewers(usr))
		if(target == user && !user.stat && !user.weakened && !user.stunned && !user.paralysis)
			V.show_message("[usr] starts climbing into the disposal.", 3)
		if(target != user && !user.restrained() && !user.stat && !user.weakened && !user.stunned && !user.paralysis)
			if(target.anchored)
				return
			V.show_message("[usr] starts stuffing [target.name] into the disposal.", 3)
	if(!do_after(usr, 20))
		return
	if(target_loc != target.loc)
		return
	if(target == user && !user.stat && !user.weakened && !user.stunned && !user.paralysis)	// if drop self, then climbed in
																							// must be awake, not stunned or whatever
		msg = "[user.name] climbs into the [src]."
		to_chat(user, "You climb into the [src].")
	else if(target != user && !user.restrained() && !user.stat && !user.weakened && !user.stunned && !user.paralysis)
		msg = "[user.name] stuffs [target.name] into the [src]!"
		to_chat(user, "You stuff [target.name] into the [src]!")

		user.attack_log += "\[[time_stamp()]\] <font color='red'>Has placed [target.name] ([target.ckey]) in disposals.</font>"
		target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been placed in disposals by [user.name] ([user.ckey])</font>"
		msg_admin_attack("[user] ([user.ckey]) placed [target] ([target.ckey]) in a disposals unit. (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")
	else
		return
	if(target.client)
		target.client.perspective = EYE_PERSPECTIVE
		target.client.eye = src
	target.forceMove(src)

	for(var/mob/C in viewers(src))
		if(C == user)
			continue
		C.show_message(msg, 3)

	update()
	return

// can breath normally in the disposal
/obj/machinery/disposal/alter_health()
	return GET_TURF(src)

// attempt to move while inside
/obj/machinery/disposal/relaymove(mob/user)
	if(user.stat || src.flushing)
		return
	src.go_out(user)
	return

// leave the disposal
/obj/machinery/disposal/proc/go_out(mob/user)
	if(user.client)
		user.client.eye = user.client.mob
		user.client.perspective = MOB_PERSPECTIVE
	user.forceMove(loc)
	update()
	return

// monkeys can only pull the flush lever
/obj/machinery/disposal/attack_paw(mob/user)
	if(stat & BROKEN)
		return

	flush = !flush
	update()
	return

// ai as human but can't flush
/obj/machinery/disposal/attack_ai(mob/user)
	interact(user, 1)

// human interact with machine
/obj/machinery/disposal/attack_hand(mob/user)
	if(user && user.loc == src)
		to_chat(user, SPAN_WARNING("You cannot reach the controls from inside."))
		return
	/*
	if(mode == -1)
		to_chat(user, SPAN_WARNING("The disposal unit's power is disabled."))
		return
	*/
	interact(user, 0)

// user interaction
/obj/machinery/disposal/interact(mob/user, ai = 0)
	src.add_fingerprint(user)
	if(stat & BROKEN)
		user.unset_machine()
		return

	var/dat = "<head><title>Waste Disposal Unit</title></head><body><TT><B>Waste Disposal Unit</B><HR>"

	if(!ai)  // AI can't pull flush handle
		if(flush)
			dat += "Disposal handle: <A href='byond://?src=\ref[src];handle=0'>Disengage</A> <B>Engaged</B>"
		else
			dat += "Disposal handle: <B>Disengaged</B> <A href='byond://?src=\ref[src];handle=1'>Engage</A>"
		dat += "<BR><HR><A href='byond://?src=\ref[src];eject=1'>Eject contents</A><HR>"

	if(mode <= 0)
		dat += "Pump: <B>Off</B> <A href='byond://?src=\ref[src];pump=1'>On</A><BR>"
	else if(mode == 1)
		dat += "Pump: <A href='byond://?src=\ref[src];pump=0'>Off</A> <B>On</B> (pressurizing)<BR>"
	else
		dat += "Pump: <A href='byond://?src=\ref[src];pump=0'>Off</A> <B>On</B> (idle)<BR>"

	var/per = 100 * air_contents.return_pressure() / (SEND_PRESSURE)

	dat += "Pressure: [round(per, 1)]%<BR></body>"

	user.set_machine(src)
	user << browse(dat, "window=disposal;size=360x170")
	onclose(user, "disposal")

// handle machine interaction
/obj/machinery/disposal/Topic(href, href_list)
	if(usr.loc == src)
		to_chat(usr, SPAN_WARNING("You cannot reach the controls from inside."))
		return

	if(mode == -1 && !href_list["eject"]) // only allow ejecting if mode is -1
		to_chat(usr, SPAN_WARNING("The disposal unit's power is disabled."))
		return
	..()
	src.add_fingerprint(usr)
	if(stat & BROKEN)
		return
	if(usr.stat || usr.restrained() || src.flushing)
		return

	if(in_range(src, usr) && isturf(src.loc))
		usr.set_machine(src)

		if(href_list["close"])
			usr.unset_machine()
			usr << browse(null, "window=disposal")
			return

		if(href_list["pump"])
			if(text2num(href_list["pump"]))
				mode = 1
			else
				mode = 0
			update()

		if(href_list["handle"])
			flush = text2num(href_list["handle"])
			update()

		if(href_list["eject"])
			eject()
	else
		usr << browse(null, "window=disposal")
		usr.unset_machine()
		return
	return

// eject the contents of the disposal unit
/obj/machinery/disposal/proc/eject()
	var/turf/T = GET_TURF(src)
	for_no_type_check(var/atom/movable/mover, src)
		mover.forceMove(T)
		mover.pipe_eject(0)
	update()

// update the icon & overlays to reflect mode & status
/obj/machinery/disposal/proc/update()
	cut_overlays()
	if(stat & BROKEN)
		icon_state = "disposal-broken"
		mode = 0
		flush = 0
		return

	// flush handle
	if(flush)
		add_overlay("dispover-handle")

	// only handle is shown if no power
	if(stat & NOPOWER || mode == -1)
		return

	// 	check for items in disposal - occupied light
	if(length(contents))
		add_overlay("dispover-full")

	// charging and ready light
	if(mode == 1)
		add_overlay("dispover-charge")
	else if(mode == 2)
		add_overlay("dispover-ready")

// timed process
// charge the gas reservoir and perform flush if ready
/obj/machinery/disposal/process()
	update_power_state(USE_POWER_OFF)
	if(stat & BROKEN)			// nothing can happen if broken
		return

	if(!air_contents) // Potentially causes a runtime otherwise (if this is really shitty, blame pete //Donkie)
		return

	flush_count++
	if(flush_count >= flush_every_ticks)
		if(length(contents))
			if(mode == 2)
				spawn(0)
					feedback_inc("disposal_auto_flush",1)
					flush()
		flush_count = 0

	src.updateDialog()

	if(flush && air_contents.return_pressure() >= SEND_PRESSURE)	// flush can happen even without power
		flush()

	if(stat & NOPOWER)			// won't charge if no power
		return

	update_power_state(USE_POWER_IDLE)

	if(mode != 1)		// if off or ready, no need to charge
		return

	// otherwise charge
	update_power_state(USE_POWER_ACTIVE)

	var/atom/L = loc						// recharging from loc turf

	var/datum/gas_mixture/env = L.return_air()
	var/pressure_delta = (SEND_PRESSURE * 1.01) - air_contents.return_pressure()

	if(env.temperature > 0)
		var/transfer_moles = 0.1 * pressure_delta * air_contents.volume/(env.temperature * R_IDEAL_GAS_EQUATION)

		//Actually transfer the gas
		var/datum/gas_mixture/removed = env.remove(transfer_moles)
		air_contents.merge(removed)


	// if full enough, switch to ready mode
	if(air_contents.return_pressure() >= SEND_PRESSURE)
		mode = 2
		update()
	return

// perform a flush
/obj/machinery/disposal/proc/flush()
	flushing = 1
	flick("[icon_state]-flush", src)

	var/wrapcheck = 0
	var/obj/structure/disposalholder/H = new()	// virtual holder object which actually
												// travels through the pipes.

	//Hacky test to get drones to mail themselves through disposals.
	for(var/mob/living/silicon/robot/drone/D in src)
		wrapcheck = 1

	for(var/obj/item/small_delivery/O in src)
		wrapcheck = 1

	if(wrapcheck == 1)
		H.tomail = 1

	sleep(10)
	if(last_sound < world.time + 1)
		playsound(src, 'sound/machines/disposalflush.ogg', 50, 0, 0)
		last_sound = world.time
	sleep(5) // wait for animation to finish

	H.init(src, air_contents)	// copy the contents of disposer to holder
	air_contents = new(1.05 * MOLES_CELLSTANDARD) // new empty gas resv.

	H.start(src) // start the holder processing movement
	flushing = 0
	// now reset disposal state
	flush = 0
	if(mode == 2)	// if was ready,
		mode = 1	// switch to charging
	update()
	return

// called when area power changes
/obj/machinery/disposal/power_change()
	..()	// do default setting/reset of stat NOPOWER bit
	update()	// update icon
	return

// called when holder is expelled from a disposal
// should usually only occur if the pipe network is modified
/obj/machinery/disposal/proc/expel(obj/structure/disposalholder/H)
	var/turf/target
	playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)
	if(isnotnull(H)) // Somehow, someone managed to flush a window which broke mid-transit and caused the disposal to go in an infinite loop trying to expel null, hopefully this fixes it.
		for_no_type_check(var/atom/movable/mover, H)
			target = get_offset_target_turf(src.loc, rand(5) - rand(5), rand(5) - rand(5))

			mover.forceMove(loc)
			mover.pipe_eject(0)
			if(!isdrone(mover)) //Poor drones kept smashing windows and taking system damage being fired out of disposals. ~Z
				spawn(1)
					if(mover)
						mover.throw_at(target, 5, 1)

		H.vent_gas(loc)
		qdel(H)

/obj/machinery/disposal/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(isitem(mover) && mover.throwing)
		var/obj/item/I = mover
		if(istype(I, /obj/item/projectile))
			return
		if(prob(75))
			I.forceMove(src)
			for(var/mob/M in viewers(src))
				M.show_message("\the [I] lands in \the [src].", 3)
		else
			for(var/mob/M in viewers(src))
				M.show_message("\the [I] bounces off of \the [src]'s rim!.", 3)
		return 0
	else
		return ..(mover, target, height, air_group)


// virtual disposal object
// travels through pipes in lieu of actual items
// contents will be items flushed by the disposal
// this allows the gas flushed to be tracked
/obj/structure/disposalholder
	invisibility = INVISIBILITY_MAXIMUM
	dir = 0

	var/datum/gas_mixture/gas = null	// gas used to flush, will appear at exit point
	var/active = 0	// true if the holder is moving, otherwise inactive

	var/count = 1000	//*** can travel 1000 steps before going inactive (in case of loops)
	var/has_fat_guy = 0	// true if contains a fat person
	var/destinationTag = 0 // changes if contains a delivery container
	var/tomail = 0 //changes if contains wrapped package
	var/hasmob = 0 //If it contains a mob

/obj/structure/disposalholder/Destroy()
	QDEL_NULL(gas)
	active = 0
	return ..()

// initialize a holder from the contents of a disposal unit
/obj/structure/disposalholder/proc/init(obj/machinery/disposal/D, datum/gas_mixture/flush_gas)
	gas = flush_gas // transfer gas resv. into holder object

	//Check for any living mobs trigger hasmob.
	//hasmob effects whether the package goes to cargo or its tagged destination.
	for(var/mob/living/M in D)
		if(M && M.stat != DEAD && !isdrone(M))
			hasmob = 1

	//Checks 1 contents level deep. This means that players can be sent through disposals...
	//...but it should require a second person to open the package. (i.e. person inside a wrapped locker)
	for(var/obj/O in D)
		if(O.contents)
			for(var/mob/living/M in O.contents)
				if(M && M.stat != DEAD && !isdrone(M))
					hasmob = 1

	// now everything inside the disposal gets put into the holder
	// note AM since can contain mobs or objs
	for_no_type_check(var/atom/movable/mover, D)
		mover.forceMove(src)
		if(ishuman(mover))
			var/mob/living/carbon/human/H = mover
			if(MUTATION_FAT in H.mutations)		// is a human and fat?
				has_fat_guy = 1			// set flag on holder
		if(istype(mover, /obj/structure/big_delivery) && !hasmob)
			var/obj/structure/big_delivery/T = mover
			src.destinationTag = T.sortTag
		if(istype(mover, /obj/item/small_delivery) && !hasmob)
			var/obj/item/small_delivery/T = mover
			src.destinationTag = T.sortTag
		//Drones can mail themselves through maint.
		if(isdrone(mover))
			var/mob/living/silicon/robot/drone/drone = mover
			src.destinationTag = drone.mail_destination

// start the movement process
// argument is the disposal unit the holder started in
/obj/structure/disposalholder/proc/start(obj/machinery/disposal/D)
	if(!D.trunk)
		D.expel(src)	// no trunk connected, so expel immediately
		return

	loc = D.trunk
	active = 1
	dir = DOWN
	spawn(1)
		move()		// spawn off the movement process

	return

// movement process, persists while holder is moving through pipes
/obj/structure/disposalholder/proc/move()
	var/obj/structure/disposalpipe/last
	while(active)
		sleep(1)		// was 1
		if(!loc)
			return // check if we got GC'd

		if(hasmob && prob(3))
			for(var/mob/living/L in src)
				// This is probably a terrible way to do this, but...
				// Check if mob is wearing the mailman's voidsuit and helmet to avoid damage.
				// Otherwise... What the other guy said below this. -Frenjo
				if(!isdrone(L)) //Drones use the mailing code to move through the disposal system,
					if(ishuman(L))
						var/mob/living/carbon/human/H = L
						if(!istype(H.wear_suit, /obj/item/clothing/suit/space/mailmanvoid) || !istype(H.head, /obj/item/clothing/head/helmet/space/mailmanvoid))
							L.take_overall_damage(20, 0, "Blunt Trauma")//horribly maim any living creature jumping down disposals.  c'est la vie
					else
						L.take_overall_damage(20, 0, "Blunt Trauma")//horribly maim any living creature jumping down disposals.  c'est la vie

		if(has_fat_guy && prob(2)) // chance of becoming stuck per segment if contains a fat guy
			active = 0
			// find the fat guys
			for(var/mob/living/carbon/human/H in src)
				break
		var/obj/structure/disposalpipe/curr = loc
		last = curr
		curr = curr.transfer(src)

		if(!loc)
			return //side effects

		if(!curr)
			last.expel(src, loc, dir)
		//
		if(!(count--))
			active = 0
	return

// find the turf which should contain the next pipe
/obj/structure/disposalholder/proc/nextloc()
	return get_step(loc, dir)

// find a matching pipe on a turf
/obj/structure/disposalholder/proc/findpipe(turf/T)
	if(!T)
		return null

	var/fdir = turn(dir, 180)	// flip the movement direction
	for(var/obj/structure/disposalpipe/P in T)
		if(fdir & P.dpdir)		// find pipe direction mask that matches flipped dir
			return P
	// if no matching pipe, return null
	return null

	// merge two holder objects
	// used when a a holder meets a stuck holder
/obj/structure/disposalholder/proc/merge(obj/structure/disposalholder/other)
	for_no_type_check(var/atom/movable/mover, other)
		mover.forceMove(src)		// move everything in other holder to this one
		if(ismob(mover))
			var/mob/M = mover
			if(isnotnull(M.client))	// if a client mob, update eye to follow this holder
				M.client.eye = src

	if(other.has_fat_guy)
		has_fat_guy = 1
	qdel(other)

// called when player tries to move while in a pipe
/obj/structure/disposalholder/relaymove(mob/user)
	if(user.stat)
		return
	if(src.loc)
		for(var/mob/M in hearers(src.loc.loc))
			to_chat(M, "<FONT size=[max(0, 5 - get_dist(src, M))]>CLONG, clong!</FONT>")

	playsound(src, 'sound/effects/clang.ogg', 50, 0, 0)

// called to vent all gas in holder to a location
/obj/structure/disposalholder/proc/vent_gas(atom/location)
	location.assume_air(gas)  // vent all gas to turf
	return


// Disposal pipes
/obj/structure/disposalpipe
	icon = 'icons/obj/pipes/disposal.dmi'
	name = "disposal pipe"
	desc = "An underfloor disposal pipe."
	anchored = TRUE
	density = FALSE

	level = 1			// underfloor only
	var/dpdir = 0		// bitmask of pipe directions
	dir = 0				// dir will contain dominant direction for junction pipes
	var/health = 10 	// health points 0-10
	layer = 2.3			// slightly lower than wires and other pipes
	var/base_icon_state	// initial icon state on map

// new pipe, set the icon_state as on map
/obj/structure/disposalpipe/initialise()
	. = ..()
	base_icon_state = icon_state

// pipe is deleted
// ensure if holder is present, it is expelled
/obj/structure/disposalpipe/Destroy()
	var/obj/structure/disposalholder/H = locate() in src
	if(isnotnull(H))
		// holder was present
		H.active = 0
		var/turf/T = loc
		if(T.density)
			// deleting pipe is inside a dense turf (wall)
			// this is unlikely, but just dump out everything into the turf in case
			for_no_type_check(var/atom/movable/mover, H)
				mover.forceMove(T)
				mover.pipe_eject(0)
			qdel(H)
			return ..()

		// otherwise, do normal expel from turf
		if(isnotnull(H))
			expel(H, T, 0)
	return ..()

// returns the direction of the next pipe object, given the entrance dir
// by default, returns the bitmask of remaining directions
/obj/structure/disposalpipe/proc/nextdir(fromdir)
	return dpdir & (~turn(fromdir, 180))

// transfer the holder through this pipe segment
// overriden for special behaviour
//
/obj/structure/disposalpipe/proc/transfer(obj/structure/disposalholder/H)
	var/nextdir = nextdir(H.dir)
	H.set_dir(nextdir)
	var/turf/T = H.nextloc()
	var/obj/structure/disposalpipe/P = H.findpipe(T)

	if(P)
		// find other holder in next loc, if inactive merge it with current
		var/obj/structure/disposalholder/H2 = locate() in P
		if(H2 && !H2.active)
			H.merge(H2)

		H.forceMove(P)
	else			// if wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return null

	return P

// update the icon_state to reflect hidden status
/obj/structure/disposalpipe/proc/update()
	var/turf/T = src.loc
	hide(T.intact && !isspace(T))	// space never hides pipes

// hide called by levelupdate if turf intact status changes
// change visibility status and force update of icon
/obj/structure/disposalpipe/hide(intact)
	invisibility = intact ? 101: 0	// hide if floor is intact
	updateicon()

// update actual icon_state depending on visibility
// if invisible, append "f" to icon_state to show faded version
// this will be revealed if a T-scanner is used
// if visible, use regular icon_state
/obj/structure/disposalpipe/proc/updateicon()
	if(invisibility)
		icon_state = "[base_icon_state]f"
	else
		icon_state = base_icon_state
	return


// expel the held objects into a turf
// called when there is a break in the pipe
//
/obj/structure/disposalpipe/proc/expel(obj/structure/disposalholder/H, turf/T, direction)
	var/turf/target

	if(T.density)		// dense ouput turf, so stop holder
		H.active = 0
		H.forceMove(src)
		return
	if(T.intact && isfloorturf(T)) //intact floor, pop the tile
		var/turf/open/floor/F = T
		//F.health	= 100
		F.burnt	= 1
		F.intact	= 0
		F.levelupdate()
		new /obj/item/stack/tile(H)	// add to holder so it will be thrown with other stuff
		F.icon_state = "Floor[F.burnt ? "1" : ""]"

	if(direction)		// direction is specified
		if(isspace(T)) // if ended in space, then range is unlimited
			target = get_edge_target_turf(T, direction)
		else						// otherwise limit to 10 tiles
			target = get_ranged_target_turf(T, direction, 10)

		playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)
		if(isnotnull(H))
			for_no_type_check(var/atom/movable/mover, H)
				mover.forceMove(T)
				mover.pipe_eject(direction)
				spawn(1)
					if(mover)
						mover.throw_at(target, 100, 1)
			H.vent_gas(T)
			qdel(H)

	else	// no specified direction, so throw in random direction
		playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)
		if(isnotnull(H))
			for_no_type_check(var/atom/movable/mover, H)
				target = get_offset_target_turf(T, rand(5) - rand(5), rand(5) - rand(5))

				mover.forceMove(T)
				mover.pipe_eject(0)
				spawn(1)
					if(mover)
						mover.throw_at(target, 5, 1)

			H.vent_gas(T)	// all gas vent to turf
			qdel(H)

	return

// call to break the pipe
// will expel any holder inside at the time
// then delete the pipe
// remains : set to leave broken pipe pieces in place
/obj/structure/disposalpipe/proc/broken(remains = 0)
	if(remains)
		for(var/D in GLOBL.cardinal)
			if(D & dpdir)
				var/obj/structure/disposalpipe/broken/P = new(src.loc)
				P.set_dir(D)

	src.invisibility = INVISIBILITY_MAXIMUM	// make invisible (since we won't delete the pipe immediately)
	var/obj/structure/disposalholder/H = locate() in src
	if(isnotnull(H))
		// holder was present
		H.active = 0
		var/turf/T = src.loc
		if(T.density)
			// broken pipe is inside a dense turf (wall)
			// this is unlikely, but just dump out everything into the turf in case
			for_no_type_check(var/atom/movable/mover, H)
				mover.forceMove(T)
				mover.pipe_eject(0)
			qdel(H)
			return

		// otherwise, do normal expel from turf
		if(isnotnull(H))
			expel(H, T, 0)

	spawn(2)	// delete pipe after 2 ticks to ensure expel proc finished
		qdel(src)

// pipe affected by explosion
/obj/structure/disposalpipe/ex_act(severity)
	switch(severity)
		if(1.0)
			broken(0)
			return
		if(2.0)
			health -= rand(5, 15)
			healthcheck()
			return
		if(3.0)
			health -= rand(0, 15)
			healthcheck()
			return

// test health for brokenness
/obj/structure/disposalpipe/proc/healthcheck()
	if(health < -2)
		broken(0)
	else if(health < 1)
		broken(1)
	return

//attack by item
//weldingtool: unfasten and convert to obj/disposalconstruct
/obj/structure/disposalpipe/attackby(obj/item/I, mob/user)
	var/turf/T = src.loc
	if(T.intact)
		return		// prevent interaction with T-scanner revealed pipes
	src.add_fingerprint(user)
	if(iswelder(I))
		var/obj/item/weldingtool/W = I

		if(W.remove_fuel(0, user))
			playsound(src, 'sound/items/Welder2.ogg', 100, 1)
			// check if anything changed over 2 seconds
			var/turf/uloc = user.loc
			var/atom/wloc = W.loc
			to_chat(user, "Slicing the disposal pipe.")
			sleep(30)
			if(!W.isOn())
				return
			if(user.loc == uloc && wloc == W.loc)
				welded()
			else
				to_chat(user, "You must stay still while welding the pipe.")
		else
			return

// called when pipe is cut with welder
/obj/structure/disposalpipe/proc/welded()
	var/obj/structure/disposalconstruct/C = new(src.loc)
	switch(base_icon_state)
		if("pipe-s")
			C.ptype = 0
		if("pipe-c")
			C.ptype = 1
		if("pipe-j1")
			C.ptype = 2
		if("pipe-j2")
			C.ptype = 3
		if("pipe-y")
			C.ptype = 4
		if("pipe-t")
			C.ptype = 5
		if("pipe-j1s")
			C.ptype = 9
		if("pipe-j2s")
			C.ptype = 10
///// Z-Level stuff
		if("pipe-u")
			C.ptype = 11
		if("pipe-d")
			C.ptype = 12
///// Z-Level stuff
	src.transfer_fingerprints_to(C)
	C.set_dir(dir)
	C.density = FALSE
	C.anchored = TRUE
	C.update()

	qdel(src)

// *** TEST verb
//client/verb/dispstop()
//	for(var/obj/structure/disposalholder/H in GLOBL.movable_atom_list)
//		H.active = 0

// a straight or bent segment
/obj/structure/disposalpipe/segment
	icon_state = "pipe-s"

/obj/structure/disposalpipe/segment/initialise()
	. = ..()
	if(icon_state == "pipe-s")
		dpdir = dir | turn(dir, 180)
	else
		dpdir = dir | turn(dir, -90)

	update()

///// Z-Level stuff
/obj/structure/disposalpipe/up
	icon_state = "pipe-u"

/obj/structure/disposalpipe/up/initialise()
	. = ..()
	dpdir = dir
	update()

/obj/structure/disposalpipe/up/nextdir(fromdir)
	var/nextdir
	if(fromdir == 11)
		nextdir = dir
	else
		nextdir = 12
	return nextdir

/obj/structure/disposalpipe/up/transfer(obj/structure/disposalholder/H)
	var/nextdir = nextdir(H.dir)
	H.set_dir(nextdir)

	var/turf/T
	var/obj/structure/disposalpipe/P

	if(nextdir == 12)
		var/turf/controllerlocation = locate(1, 1, src.z)
		for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
			if(controller.up)
				T = locate(src.x, src.y, controller.up_target)
		if(!T)
			H.forceMove(loc)
			return
		else
			for(var/obj/structure/disposalpipe/down/F in T)
				P = F

	else
		T = get_step(src.loc, H.dir)
		P = H.findpipe(T)

	if(P)
		// find other holder in next loc, if inactive merge it with current
		var/obj/structure/disposalholder/H2 = locate() in P
		if(H2 && !H2.active)
			H.merge(H2)

		H.forceMove(P)
	else			// if wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return null

	return P

/obj/structure/disposalpipe/down
	icon_state = "pipe-d"

/obj/structure/disposalpipe/down/initialise()
	. = ..()
	dpdir = dir
	update()

/obj/structure/disposalpipe/down/nextdir(fromdir)
	var/nextdir
	if(fromdir == 12)
		nextdir = dir
	else
		nextdir = 11
	return nextdir

/obj/structure/disposalpipe/down/transfer(obj/structure/disposalholder/H)
	var/nextdir = nextdir(H.dir)
	H.set_dir(nextdir)

	var/turf/T
	var/obj/structure/disposalpipe/P

	if(nextdir == 11)
		var/turf/controllerlocation = locate(1, 1, src.z)
		for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
			if(controller.down)
				T = locate(src.x, src.y, controller.down_target)
		if(!T)
			H.forceMove(loc)
			return
		else
			for(var/obj/structure/disposalpipe/up/F in T)
				P = F

	else
		T = get_step(src.loc, H.dir)
		P = H.findpipe(T)

	if(P)
		// find other holder in next loc, if inactive merge it with current
		var/obj/structure/disposalholder/H2 = locate() in P
		if(H2 && !H2.active)
			H.merge(H2)

		H.forceMove(P)
	else			// if wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return null

	return P
///// Z-Level stuff

//a three-way junction with dir being the dominant direction
/obj/structure/disposalpipe/junction
	icon_state = "pipe-j1"

/obj/structure/disposalpipe/junction/initialise()
	. = ..()
	if(icon_state == "pipe-j1")
		dpdir = dir | turn(dir, -90) | turn(dir,180)
	else if(icon_state == "pipe-j2")
		dpdir = dir | turn(dir, 90) | turn(dir,180)
	else // pipe-y
		dpdir = dir | turn(dir,90) | turn(dir, -90)
	update()

// next direction to move
// if coming in from secondary dirs, then next is primary dir
// if coming in from primary dir, then next is equal chance of other dirs
/obj/structure/disposalpipe/junction/nextdir(fromdir)
	var/flipdir = turn(fromdir, 180)
	if(flipdir != dir)	// came from secondary dir
		return dir		// so exit through primary
	else				// came from primary
						// so need to choose either secondary exit
		var/mask = ..(fromdir)

		// find a bit which is set
		var/setbit = 0
		if(mask & NORTH)
			setbit = NORTH
		else if(mask & SOUTH)
			setbit = SOUTH
		else if(mask & EAST)
			setbit = EAST
		else
			setbit = WEST

		if(prob(50))	// 50% chance to choose the found bit or the other one
			return setbit
		else
			return mask & (~setbit)

//a three-way junction that sorts objects
/obj/structure/disposalpipe/sortjunction
	icon_state = "pipe-j1s"
	var/sortType = 0	//Look at the list called tagger_locations in _global_vars/lists/objects.dm
	var/posdir = 0
	var/negdir = 0
	var/sortdir = 0

/obj/structure/disposalpipe/sortjunction/proc/updatedesc()
	desc = "An underfloor disposal pipe with a package sorting mechanism."
	if(sortType > 0)
		var/tag = uppertext(GLOBL.tagger_locations[sortType])
		desc += "\nIt's tagged with [tag]"

/obj/structure/disposalpipe/sortjunction/proc/updatedir()
	posdir = dir
	negdir = turn(posdir, 180)

	if(icon_state == "pipe-j1s")
		sortdir = turn(posdir, -90)
	else
		icon_state = "pipe-j2s"
		sortdir = turn(posdir, 90)

	dpdir = sortdir | posdir | negdir

/obj/structure/disposalpipe/sortjunction/initialise()
	. = ..()
	updatedir()
	updatedesc()
	update()

/obj/structure/disposalpipe/sortjunction/attackby(obj/item/I, mob/user)
	if(..())
		return

	if(istype(I, /obj/item/dest_tagger))
		var/obj/item/dest_tagger/O = I

		if(O.currTag > 0)// Tag set
			sortType = O.currTag
			playsound(src, 'sound/machines/twobeep.ogg', 100, 1)
			var/tag = uppertext(GLOBL.tagger_locations[O.currTag])
			to_chat(user, SPAN_INFO("Changed filter to [tag]."))
			updatedesc()


// next direction to move
// if coming in from negdir, then next is primary dir or sortdir
// if coming in from posdir, then flip around and go back to posdir
// if coming in from sortdir, go to posdir
/obj/structure/disposalpipe/sortjunction/nextdir(fromdir, sortTag)
	//var/flipdir = turn(fromdir, 180)
	if(fromdir != sortdir)	// probably came from the negdir

		if(src.sortType == sortTag) //if destination matches filtered type...
			return sortdir		// exit through sortdirection
		else
			return posdir
	else				// came from sortdir
						// so go with the flow to positive direction
		return posdir

/obj/structure/disposalpipe/sortjunction/transfer(obj/structure/disposalholder/H)
	var/nextdir = nextdir(H.dir, H.destinationTag)
	H.set_dir(nextdir)
	var/turf/T = H.nextloc()
	var/obj/structure/disposalpipe/P = H.findpipe(T)

	if(P)
		// find other holder in next loc, if inactive merge it with current
		var/obj/structure/disposalholder/H2 = locate() in P
		if(H2 && !H2.active)
			H.merge(H2)

		H.forceMove(P)
	else			// if wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return null

	return P

//a three-way junction that sorts objects destined for the mail office mail table (tomail = 1)
/obj/structure/disposalpipe/wrapsortjunction
	desc = "An underfloor disposal pipe which sorts wrapped and unwrapped objects."
	icon_state = "pipe-j1s"
	var/posdir = 0
	var/negdir = 0
	var/sortdir = 0

/obj/structure/disposalpipe/wrapsortjunction/initialise()
	. = ..()
	posdir = dir
	if(icon_state == "pipe-j1s")
		sortdir = turn(posdir, -90)
		negdir = turn(posdir, 180)
	else
		icon_state = "pipe-j2s"
		sortdir = turn(posdir, 90)
		negdir = turn(posdir, 180)
	dpdir = sortdir | posdir | negdir

	update()

// next direction to move
// if coming in from negdir, then next is primary dir or sortdir
// if coming in from posdir, then flip around and go back to posdir
// if coming in from sortdir, go to posdir
/obj/structure/disposalpipe/wrapsortjunction/nextdir(fromdir, istomail)
	//var/flipdir = turn(fromdir, 180)
	if(fromdir != sortdir)	// probably came from the negdir

		if(istomail) //if destination matches filtered type...
			return sortdir		// exit through sortdirection
		else
			return posdir
	else				// came from sortdir
						// so go with the flow to positive direction
		return posdir

/obj/structure/disposalpipe/wrapsortjunction/transfer(obj/structure/disposalholder/H)
	var/nextdir = nextdir(H.dir, H.tomail)
	H.set_dir(nextdir)
	var/turf/T = H.nextloc()
	var/obj/structure/disposalpipe/P = H.findpipe(T)

	if(P)
		// find other holder in next loc, if inactive merge it with current
		var/obj/structure/disposalholder/H2 = locate() in P
		if(H2 && !H2.active)
			H.merge(H2)

		H.forceMove(P)
	else			// if wasn't a pipe, then set loc to turf
		H.forceMove(T)
		return null

	return P


//a trunk joining to a disposal bin or outlet on the same turf
/obj/structure/disposalpipe/trunk
	icon_state = "pipe-t"
	var/obj/linked 	// the linked obj/machinery/disposal or obj/disposaloutlet

/obj/structure/disposalpipe/trunk/initialise()
	. = ..()
	dpdir = dir
	spawn(1)
		getlinked()

	update()

/obj/structure/disposalpipe/trunk/proc/getlinked()
	linked = null
	var/obj/machinery/disposal/D = locate() in src.loc
	if(D)
		linked = D
		if(!D.trunk)
			D.trunk = src

	var/obj/structure/disposaloutlet/O = locate() in src.loc
	if(O)
		linked = O

	update()
	return

// Override attackby so we disallow trunkremoval when somethings ontop
/obj/structure/disposalpipe/trunk/attackby(obj/item/I, mob/user)
	//Disposal bins or chutes
	/*
	These shouldn't be required
	var/obj/machinery/disposal/D = locate() in src.loc
	if(D && D.anchored)
		return

	//Disposal outlet
	var/obj/structure/disposaloutlet/O = locate() in src.loc
	if(O && O.anchored)
		return
	*/

	//Disposal constructors
	var/obj/structure/disposalconstruct/C = locate() in src.loc
	if(C && C.anchored)
		return

	var/turf/T = src.loc
	if(T.intact)
		return		// prevent interaction with T-scanner revealed pipes
	src.add_fingerprint(user)
	if(iswelder(I))
		var/obj/item/weldingtool/W = I

		if(W.remove_fuel(0, user))
			playsound(src, 'sound/items/Welder2.ogg', 100, 1)
			// check if anything changed over 2 seconds
			var/turf/uloc = user.loc
			var/atom/wloc = W.loc
			to_chat(user, "Slicing the disposal pipe.")
			sleep(30)
			if(!W.isOn())
				return
			if(user.loc == uloc && wloc == W.loc)
				welded()
			else
				to_chat(user, "You must stay still while welding the pipe.")
		else
			return

// would transfer to next pipe segment, but we are in a trunk
// if not entering from disposal bin,
// transfer to linked object (outlet or bin)
/obj/structure/disposalpipe/trunk/transfer(obj/structure/disposalholder/H)
	if(H.dir == DOWN)		// we just entered from a disposer
		return ..()		// so do base transfer proc
	// otherwise, go to the linked object
	if(linked)
		var/obj/structure/disposaloutlet/O = linked
		if(istype(O) && (H))
			O.expel(H)	// expel at outlet
		else
			var/obj/machinery/disposal/D = linked
			if(H)
				D.expel(H)	// expel at disposal
	else
		if(H)
			src.expel(H, src.loc, 0)	// expel at turf
	return null

// nextdir
/obj/structure/disposalpipe/trunk/nextdir(fromdir)
	if(fromdir == DOWN)
		return dir
	else
		return 0


// a broken pipe
/obj/structure/disposalpipe/broken
	icon_state = "pipe-b"
	dpdir = 0		// broken pipes have dpdir=0 so they're not found as 'real' pipes
					// i.e. will be treated as an empty turf
	desc = "A broken piece of disposal pipe."

/obj/structure/disposalpipe/broken/initialise()
	. = ..()
	update()

// called when welded
// for broken pipe, remove and turn into scrap
/obj/structure/disposalpipe/broken/welded()
//	var/obj/item/scrap/S = new(src.loc)
//	S.set_components(200,0,0)
	qdel(src)


// the disposal outlet machine
/obj/structure/disposaloutlet
	name = "disposal outlet"
	desc = "An outlet for the pneumatic disposal system."
	icon = 'icons/obj/pipes/disposal.dmi'
	icon_state = "outlet"
	density = TRUE
	anchored = TRUE

	var/active = 0
	var/turf/target	// this will be where the output objects are 'thrown' to.
	var/mode = 0

/obj/structure/disposaloutlet/initialise()
	. = ..()
	target = get_ranged_target_turf(src, dir, 10)

	var/obj/structure/disposalpipe/trunk/trunk = locate() in loc
	if(trunk)
		trunk.linked = src	// link the pipe trunk to self

// expel the contents of the holder object, then delete it
// called when the holder exits the outlet
/obj/structure/disposaloutlet/proc/expel(obj/structure/disposalholder/H)
	flick("outlet-open", src)
	playsound(src, 'sound/machines/warning-buzzer.ogg', 50, 0, 0)
	sleep(20)	//wait until correct animation frame
	playsound(src, 'sound/machines/hiss.ogg', 50, 0, 0)

	if(isnotnull(H))
		for_no_type_check(var/atom/movable/mover, H)
			mover.forceMove(loc)
			mover.pipe_eject(dir)
			if(!isdrone(mover)) //Drones keep smashing windows from being fired out of chutes. Bad for the station. ~Z
				spawn(5)
					mover.throw_at(target, 3, 1)
		H.vent_gas(src.loc)
		qdel(H)

	return

/obj/structure/disposaloutlet/attackby(obj/item/I, mob/user)
	if(!I || !user)
		return
	src.add_fingerprint(user)
	if(isscrewdriver(I))
		if(mode == 0)
			mode = 1
			playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
			to_chat(user, "You remove the screws around the power connection.")
			return
		else if(mode == 1)
			mode = 0
			playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
			to_chat(user, "You attach the screws around the power connection.")
			return
	else if(iswelder(I) && mode == 1)
		var/obj/item/weldingtool/W = I
		if(W.remove_fuel(0, user))
			playsound(src, 'sound/items/Welder2.ogg', 100, 1)
			to_chat(user, "You start slicing the floorweld off the disposal outlet.")
			if(do_after(user, 20))
				if(!src || !W.isOn())
					return
				to_chat(user, "You sliced the floorweld off the disposal outlet.")
				var/obj/structure/disposalconstruct/C = new(src.loc)
				src.transfer_fingerprints_to(C)
				C.ptype = 7 // 7 =  outlet
				C.update()
				C.anchored = TRUE
				C.density = TRUE
				qdel(src)
			return
		else
			return

// called when movable is expelled from a disposal pipe or outlet
// by default does nothing, override for special behaviour
/atom/movable/proc/pipe_eject(direction)
	return

// check if mob has client, if so restore client view on eject
/mob/pipe_eject(direction)
	if(src.client)
		src.client.perspective = MOB_PERSPECTIVE
		src.client.eye = src

	return

/obj/effect/decal/cleanable/blood/gibs/pipe_eject(direction)
	var/list/dirs
	if(direction)
		dirs = list(direction, turn(direction, -45), turn(direction, 45))
	else
		dirs = GLOBL.alldirs.Copy()

	src.streak(dirs)

/obj/effect/decal/cleanable/blood/gibs/robot/pipe_eject(direction)
	var/list/dirs
	if(direction)
		dirs = list(direction, turn(direction, -45), turn(direction, 45))
	else
		dirs = GLOBL.alldirs.Copy()

	src.streak(dirs)