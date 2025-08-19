////FIELD GEN START //shameless copypasta from fieldgen, powersink, and grille
#define SHIELD_GENERATOR_MAX_STORED_POWER 500
/obj/machinery/shieldwallgen
	name = "shield wall generator"
	desc = "A shield wall generator."
	icon_state = "Shield_Gen"
	anchored = FALSE
	density = TRUE
	obj_flags = OBJ_FLAG_CONDUCT

	power_state = USE_POWER_OFF

	req_access = list(ACCESS_TELEPORTER)

	var/active = 0
	var/power = 0
	var/state = 0
	var/steps = 0
	var/last_check = 0
	var/check_delay = 10
	var/recalc = 0
	var/locked = 1
	var/destroyed = 0
	var/directwired = 1
//	var/maxshieldload = 200
	var/obj/structure/cable/attached		// the attached cable
	var/storedpower = 0

/obj/machinery/shieldwallgen/Destroy()
	attached = null
	for(var/dir in GLOBL.cardinal)
		cleanup(dir)
	return ..()

/obj/machinery/shieldwallgen/proc/power()
	if(!anchored)
		power = 0
		return 0
	var/turf/T = loc

	var/obj/structure/cable/C = T.get_cable_node()
	var/datum/powernet/PN
	if(C)
		PN = C.powernet		// find the powernet of the connected cable

	if(!PN)
		power = 0
		return 0

	var/surplus = max(PN.avail - PN.load, 0)
	var/shieldload = min(rand(50, 200), surplus)
	if(shieldload == 0 && !storedpower)		// no cable or no power, and no power stored
		power = 0
		return 0
	else
		power = 1	// IVE GOT THE POWER!
		if(PN) //runtime errors fixer. They were caused by PN.newload trying to access missing network in case of working on stored power.
			storedpower += shieldload
			PN.draw_power(shieldload) //uses powernet power.
//		message_admins("[PN.load]", 1)
//		use_power(250) //uses APC power

/obj/machinery/shieldwallgen/attack_hand(mob/user)
	if(state != 1)
		to_chat(user, SPAN_WARNING("\The [src] needs to be firmly secured to the floor first."))
		return 1
	if(locked && !issilicon(user))
		FEEDBACK_CONTROLS_LOCKED(user)
		return 1
	if(power != 1)
		to_chat(user, SPAN_WARNING("\The [src] needs to be powered by wire underneath."))
		return 1

	if(active >= 1)
		active = 0
		icon_state = "Shield_Gen"

		user.visible_message(
			SPAN_INFO("[user] turned \the [src] off."),
			SPAN_INFO("You turn off \the [src]."),
			SPAN_INFO("You hear heavy droning fade out.")
		)
		for(var/dir in GLOBL.cardinal)
			cleanup(dir)
	else
		active = 1
		icon_state = "Shield_Gen +a"
		user.visible_message(
			SPAN_INFO("[user] turned \the [src] on."),
			SPAN_INFO("You turn on \the [src]."),
			SPAN_INFO("You hear heavy droning.")
		)
		START_PROCESSING(PCobj, src)
	add_fingerprint(user)

/obj/machinery/shieldwallgen/process()
	power()
	if(power)
		storedpower -= 50 //this way it can survive longer and survive at all
	if(storedpower >= SHIELD_GENERATOR_MAX_STORED_POWER)
		storedpower = SHIELD_GENERATOR_MAX_STORED_POWER
	if(storedpower <= 0)
		storedpower = 0
//	if(shieldload >= maxshieldload) //there was a loop caused by specifics of process(), so this was needed.
//		shieldload = maxshieldload

	if(active == 1)
		if(!state == 1)
			active = 0
			return
		spawn(1)
			setup_field(1)
		spawn(2)
			setup_field(2)
		spawn(3)
			setup_field(4)
		spawn(4)
			setup_field(8)
		active = 2
	if(active >= 1)
		if(power == 0)
			visible_message(
				SPAN_WARNING("\The [src] shuts down due to lack of power!"),
				SPAN_INFO("You hear heavy droning fade out.")
			)
			icon_state = "Shield_Gen"
			active = 0
			for(var/dir in GLOBL.cardinal)
				cleanup(dir)

/obj/machinery/shieldwallgen/proc/setup_field(NSEW = 0)
	var/turf/T = loc
	var/turf/T2 = loc
	var/obj/machinery/shieldwallgen/G
	var/steps = 0
	var/oNSEW = 0

	if(!NSEW)//Make sure its ran right
		return

	if(NSEW == 1)
		oNSEW = 2
	else if(NSEW == 2)
		oNSEW = 1
	else if(NSEW == 4)
		oNSEW = 8
	else if(NSEW == 8)
		oNSEW = 4

	for(var/dist in 0 to 9) // checks out to 8 tiles away for another generator
		T = get_step(T2, NSEW)
		T2 = T
		steps += 1
		if(locate(/obj/machinery/shieldwallgen) in T)
			G = (locate(/obj/machinery/shieldwallgen) in T)
			steps -= 1
			if(!G.active)
				return
			G.cleanup(oNSEW)
			break

	if(isnull(G))
		return

	T2 = loc

	for(var/dist = 0, dist < steps, dist += 1) // creates each field tile
		var/field_dir = get_dir(T2, get_step(T2, NSEW))
		T = get_step(T2, NSEW)
		T2 = T
		var/obj/effect/shield_wall/CF = new /obj/effect/shield_wall/(src, G) //(ref to this gen, ref to connected gen)
		CF.forceMove(T)
		CF.set_dir(field_dir)

/obj/machinery/shieldwallgen/attack_tool(obj/item/tool, mob/user)
	if(iswrench(tool))
		if(active)
			FEEDBACK_TURN_OFF_FIRST(user)
			return TRUE

		if(state == 0)
			state = 1
			playsound(src, 'sound/items/Ratchet.ogg', 75, 1)
			user.visible_message(
				SPAN_NOTICE("[user.name] secures \the [src]'s reinforcing bolts to the floor."),
				SPAN_NOTICE("You secure the external reinforcing bolts to the floor."),
				SPAN_INFO("You hear a ratchet.")
			)
			anchored = TRUE
			return TRUE

		if(state == 1)
			state = 0
			playsound(src, 'sound/items/Ratchet.ogg', 75, 1)
			user.visible_message(
				SPAN_NOTICE("[user.name] unsecures \the [src]'s reinforcing bolts from the floor."),
				SPAN_NOTICE("You undo the external reinforcing bolts."),
				SPAN_INFO("You hear a ratchet.")
			)
			anchored = FALSE
			return TRUE

	return ..()

/obj/machinery/shieldwallgen/attack_by(obj/item/W, mob/user)
	if(istype(W, /obj/item/card/id) || istype(W, /obj/item/pda))
		if(allowed(user))
			locked = !locked
			FEEDBACK_TOGGLE_CONTROLS_LOCK(user, locked)
		else
			FEEDBACK_ACCESS_DENIED(user)
		return TRUE

	return ..()

/obj/machinery/shieldwallgen/proc/cleanup(NSEW)
	var/obj/effect/shield_wall/F
	var/obj/machinery/shieldwallgen/G
	var/turf/T = loc
	var/turf/T2 = loc

	for(var/dist in 0 to 9) // checks out to 8 tiles away for fields
		T = get_step(T2, NSEW)
		T2 = T
		if(locate(/obj/effect/shield_wall) in T)
			F = (locate(/obj/effect/shield_wall) in T)
			qdel(F)

		if(locate(/obj/machinery/shieldwallgen) in T)
			G = (locate(/obj/machinery/shieldwallgen) in T)
			if(!G.active)
				break

/obj/machinery/shieldwallgen/bullet_act(obj/projectile/Proj)
	storedpower -= Proj.damage
	..()

#undef SHIELD_GENERATOR_MAX_STORED_POWER