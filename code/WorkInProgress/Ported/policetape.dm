//Define all tape types in policetape.dm
/obj/item/taperoll
	name = "tape roll"
	icon = 'icons/policetape.dmi'
	icon_state = "rollstart"
	w_class = WEIGHT_CLASS_TINY
	var/turf/start
	var/turf/end
	var/tape_type = /obj/item/tape
	var/icon_base

/obj/item/tape
	name = "tape"
	icon = 'icons/policetape.dmi'
	anchored = TRUE
	density = TRUE
	var/icon_base

/obj/item/taperoll/police
	name = "police tape"
	desc = "A roll of police tape used to block off crime scenes from the public."
	icon_state = "police_start"
	tape_type = /obj/item/tape/police
	icon_base = "police"

/obj/item/tape/police
	name = "police tape"
	desc = "A length of police tape.  Do not cross."
	req_access = list(ACCESS_SECURITY)
	icon_base = "police"

/obj/item/taperoll/engineering
	name = "engineering tape"
	desc = "A roll of engineering tape used to block off working areas from the public."
	icon_state = "engineering_start"
	tape_type = /obj/item/tape/engineering
	icon_base = "engineering"

/obj/item/tape/engineering
	name = "engineering tape"
	desc = "A length of engineering tape. Better not cross it."
	req_one_access = list(ACCESS_ENGINE, ACCESS_ATMOSPHERICS)
	icon_base = "engineering"

/obj/item/taperoll/attack_self(mob/user)
	if(icon_state == "[icon_base]_start")
		start = GET_TURF(src)
		to_chat(user, SPAN_INFO("You place the first end of \the [src]."))
		icon_state = "[icon_base]_stop"
	else
		icon_state = "[icon_base]_start"
		end = GET_TURF(src)
		if(start.y != end.y && start.x != end.x || start.z != end.z)
			to_chat(user, SPAN_WARNING("\The [src] can only be laid horizontally or vertically."))
			return

		var/turf/cur = start
		var/dir
		if (start.x == end.x)
			var/d = end.y-start.y
			if(d) d = d/abs(d)
			end = locate(end.x, end.y + d, end.z)
			dir = "v"
		else
			var/d = end.x-start.x
			if(d) d = d/abs(d)
			end = locate(end.x + d, end.y, end.z)
			dir = "h"

		var/can_place = 1
		while (cur!=end && can_place)
			if(cur.density == 1)
				can_place = 0
			else if(isspace(cur))
				can_place = 0
			else
				for(var/obj/O in cur)
					if(!istype(O, /obj/item/tape) && O.density)
						can_place = 0
						break
			cur = get_step_towards(cur,end)
		if (!can_place)
			to_chat(user, SPAN_WARNING("You can't run \the [src] through that!"))
			return

		cur = start
		var/tapetest = 0
		while (cur!=end)
			for(var/obj/item/tape/Ptest in cur)
				if(Ptest.icon_state == "[Ptest.icon_base]_[dir]")
					tapetest = 1
			if(tapetest != 1)
				var/obj/item/tape/P = new tape_type(cur)
				P.icon_state = "[P.icon_base]_[dir]"
			cur = get_step_towards(cur,end)
	//is_blocked_turf(var/turf/T)
		to_chat(user, SPAN_INFO("You finish placing \the [src]."))

/obj/item/taperoll/afterattack(atom/A, mob/user)
	if(istype(A, /obj/machinery/door/airlock))
		var/turf/T = GET_TURF(A)
		var/obj/item/tape/P = new tape_type(T.x,T.y,T.z)
		P.forceMove(locate(T.x,T.y,T.z))
		P.icon_state = "[src.icon_base]_door"
		P.layer = 3.2
		to_chat(user, SPAN_INFO("You finish placing \the [src]."))

/obj/item/tape/Bumped(atom/movable/AM)
	if(ismob(AM))
		var/mob/M = AM
		if(src.allowed(M))
			M.forceMove(GET_TURF(src))

/obj/item/tape/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(!density)
		return TRUE
	if(air_group || height == 0)
		return TRUE

	// This was originally just checking flag "2". I have no idea what that was but based on context I assume it's PASS_FLAG_TABLE.
	if(HAS_PASS_FLAGS(mover, PASS_FLAG_TABLE) || istype(mover, /obj/effect/meteor) || mover.throwing)
		return TRUE
	else
		return FALSE

/obj/item/tape/attack_by(obj/item/item, mob/user)
	if(breaktape(item, user))
		return TRUE
	return ..()

/obj/item/tape/attack_hand(mob/user as mob)
	if (user.a_intent == "help" && src.allowed(user))
		user.show_viewers("\blue [user] lifts [src], allowing passage.")
		src.density = FALSE
		spawn(200)
			src.density = TRUE
	else
		breaktape(null, user)

/obj/item/tape/attack_paw(mob/user as mob)
	breaktape(/obj/item/wirecutters,user)

/obj/item/tape/proc/breaktape(obj/item/W, mob/user)
	if(user.a_intent == "help" && (!can_puncture(W) && allowed(user)))
		to_chat(user, SPAN_WARNING("You can't break \the [src] with that!"))
		return FALSE
	user.visible_message(
		SPAN_INFO("[user] breaks \the [src]!"),
		SPAN_INFO("You break \the [src]."),
		SPAN_INFO("You hear tape flapping.")
	)

	var/dir[2]
	var/icon_dir = icon_state
	if(icon_dir == "[icon_base]_h")
		dir[1] = EAST
		dir[2] = WEST
	if(icon_dir == "[icon_base]_v")
		dir[1] = NORTH
		dir[2] = SOUTH

	for(var/i = 1; i < 3; i++)
		var/N = 0
		var/turf/cur = get_step(src, dir[i])
		while(N != 1)
			N = 1
			for(var/obj/item/tape/P in cur)
				if(P.icon_state == icon_dir)
					N = 0
					qdel(P)
			cur = get_step(cur, dir[i])

	qdel(src)
	return TRUE