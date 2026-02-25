/* Tables and Racks
 * Contains:
 *		Tables
 *		Wooden tables
 *		Reinforced tables
 *		Racks
 */


/*
 * Tables
 */
/obj/structure/table
	name = "table"
	desc = "A square piece of metal standing on four metal legs. It can not move."
	icon = 'icons/obj/structures/tables.dmi'
	icon_state = "table"
	density = TRUE
	anchored = TRUE
	layer = 2.8
	throwpass = 1	//You can throw objects over this, despite it's density.")
	climbable = 1
	breakable = 1

	parts = /obj/item/table_parts

	var/flipped = 0
	var/health = 100

/obj/structure/table/proc/update_adjacent()
	for(var/direction in list(1, 2, 4, 8, 5, 6, 9, 10))
		if(locate(/obj/structure/table, get_step(src, direction)))
			var/obj/structure/table/T = locate(/obj/structure/table, get_step(src, direction))
			T.update_icon()

/obj/structure/table/initialise()
	. = ..()
	for(var/obj/structure/table/T in src.loc)
		if(T != src)
			qdel(T)
	update_icon()
	update_adjacent()

/obj/structure/table/Destroy()
	update_adjacent()
	return ..()

/obj/structure/table/update_icon()
	spawn(2) //So it properly updates when deleting
		if(flipped)
			var/type = 0
			var/tabledirs = 0
			for(var/direction in list(turn(dir, 90), turn(dir, -90)))
				var/obj/structure/table/T = locate(/obj/structure/table, get_step(src, direction))
				if(T && T.flipped && T.dir == src.dir)
					type++
					tabledirs |= direction
			var/base = "table"
			if(istype(src, /obj/structure/table/woodentable))
				base = "wood"
			if(istype(src, /obj/structure/table/reinforced))
				base = "rtable"

			icon_state = "[base]flip[type]"
			if(type == 1)
				if(tabledirs & turn(dir, 90))
					icon_state = icon_state + "-"
				if(tabledirs & turn(dir, -90))
					icon_state = icon_state + "+"
			return

		var/dir_sum = 0
		for(var/direction in list(1, 2, 4, 8, 5, 6, 9, 10))
			var/skip_sum = 0
			for(var/obj/structure/window/W in src.loc)
				if(W.dir == direction) //So smooth tables don't go smooth through windows
					skip_sum = 1
					continue
			var/inv_direction //inverse direction
			switch(direction)
				if(1)
					inv_direction = 2
				if(2)
					inv_direction = 1
				if(4)
					inv_direction = 8
				if(8)
					inv_direction = 4
				if(5)
					inv_direction = 10
				if(6)
					inv_direction = 9
				if(9)
					inv_direction = 6
				if(10)
					inv_direction = 5
			for(var/obj/structure/window/W in get_step(src, direction))
				if(W.dir == inv_direction) //So smooth tables don't go smooth through windows when the window is on the other table's tile
					skip_sum = 1
					continue
			if(!skip_sum) //means there is a window between the two tiles in this direction
				var/obj/structure/table/T = locate(/obj/structure/table, get_step(src, direction))
				if(T && !T.flipped)
					if(direction <5)
						dir_sum += direction
					else
						if(direction == 5)	//This permits the use of all table directions. (Set up so clockwise around the central table is a higher value, from north)
							dir_sum += 16
						if(direction == 6)
							dir_sum += 32
						if(direction == 8)	//Aherp and Aderp.  Jezes I am stupid.  -- SkyMarshal
							dir_sum += 8
						if(direction == 10)
							dir_sum += 64
						if(direction == 9)
							dir_sum += 128

		var/table_type = 0 //stand_alone table
		if((dir_sum % 16) in GLOBL.cardinal)
			table_type = 1 //endtable
			dir_sum %= 16
		if((dir_sum % 16) in list(3,12))
			table_type = 2 //1 tile thick, streight table
			if(dir_sum % 16 == 3) //3 doesn't exist as a dir
				dir_sum = 2
			if(dir_sum % 16 == 12) //12 doesn't exist as a dir.
				dir_sum = 4
		if((dir_sum % 16) in list(5, 6, 9, 10))
			if(locate(/obj/structure/table,get_step(src.loc, dir_sum % 16)))
				table_type = 3 //full table (not the 1 tile thick one, but one of the 'tabledir' tables)
			else
				table_type = 2 //1 tile thick, corner table (treated the same as streight tables in code later on)
			dir_sum %= 16
		if((dir_sum % 16) in list(13, 14, 7, 11)) //Three-way intersection
			table_type = 5 //full table as three-way intersections are not sprited, would require 64 sprites to handle all combinations.  TOO BAD -- SkyMarshal
			switch(dir_sum % 16)	//Begin computation of the special type tables.  --SkyMarshal
				if(7)
					if(dir_sum == 23)
						table_type = 6
						dir_sum = 8
					else if(dir_sum == 39)
						dir_sum = 4
						table_type = 6
					else if(dir_sum == 55 || dir_sum == 119 || dir_sum == 247 || dir_sum == 183)
						dir_sum = 4
						table_type = 3
					else
						dir_sum = 4
				if(11)
					if(dir_sum == 75)
						dir_sum = 5
						table_type = 6
					else if(dir_sum == 139)
						dir_sum = 9
						table_type = 6
					else if(dir_sum == 203 || dir_sum == 219 || dir_sum == 251 || dir_sum == 235)
						dir_sum = 8
						table_type = 3
					else
						dir_sum = 8
				if(13)
					if(dir_sum == 29)
						dir_sum = 10
						table_type = 6
					else if(dir_sum == 141)
						dir_sum = 6
						table_type = 6
					else if(dir_sum == 189 || dir_sum == 221 || dir_sum == 253 || dir_sum == 157)
						dir_sum = 1
						table_type = 3
					else
						dir_sum = 1
				if(14)
					if(dir_sum == 46)
						dir_sum = 1
						table_type = 6
					else if(dir_sum == 78)
						dir_sum = 2
						table_type = 6
					else if(dir_sum == 110 || dir_sum == 254 || dir_sum == 238 || dir_sum == 126)
						dir_sum = 2
						table_type = 3
					else
						dir_sum = 2 //These translate the dir_sum to the correct dirs from the 'tabledir' icon_state.
		if(dir_sum % 16 == 15)
			table_type = 4 //4-way intersection, the 'middle' table sprites will be used.

		if(istype(src, /obj/structure/table/reinforced))
			switch(table_type)
				if(0)
					icon_state = "reinf_table"
				if(1)
					icon_state = "reinf_1tileendtable"
				if(2)
					icon_state = "reinf_1tilethick"
				if(3)
					icon_state = "reinf_tabledir"
				if(4)
					icon_state = "reinf_middle"
				if(5)
					icon_state = "reinf_tabledir2"
				if(6)
					icon_state = "reinf_tabledir3"
		else if(istype(src, /obj/structure/table/woodentable))
			switch(table_type)
				if(0)
					icon_state = "wood_table"
				if(1)
					icon_state = "wood_1tileendtable"
				if(2)
					icon_state = "wood_1tilethick"
				if(3)
					icon_state = "wood_tabledir"
				if(4)
					icon_state = "wood_middle"
				if(5)
					icon_state = "wood_tabledir2"
				if(6)
					icon_state = "wood_tabledir3"
		else
			switch(table_type)
				if(0)
					icon_state = "table"
				if(1)
					icon_state = "table_1tileendtable"
				if(2)
					icon_state = "table_1tilethick"
				if(3)
					icon_state = "tabledir"
				if(4)
					icon_state = "table_middle"
				if(5)
					icon_state = "tabledir2"
				if(6)
					icon_state = "tabledir3"
		if(dir_sum in list(1, 2, 4, 8, 5, 6, 9, 10))
			dir = dir_sum
		else
			dir = 2

/obj/structure/table/attack_tk() // no telehulk sorry
	return

/obj/structure/table/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(air_group || height == 0)
		return TRUE
	if(istype(mover, /obj/projectile))
		return (check_cover(mover, target))
	if(istype(mover) && HAS_PASS_FLAGS(mover, PASS_FLAG_TABLE))
		return TRUE
	if(flipped)
		if(get_dir(loc, target) == dir)
			return !density
		else
			return TRUE
	return FALSE

//checks if projectile 'P' from turf 'from' can hit whatever is behind the table. Returns 1 if it can, 0 if bullet stops.
/obj/structure/table/proc/check_cover(obj/projectile/P, turf/from)
	var/turf/cover = flipped ? GET_TURF(src) : get_step(loc, get_dir(from, loc))
	if(get_dist(P.starting, loc) <= 1) //Tables won't help you if people are THIS close
		return 1
	if(GET_TURF(P.original) == cover)
		var/chance = 20
		if(ismob(P.original))
			var/mob/M = P.original
			if(M.lying)
				chance += 20				//Lying down lets you catch less bullets
		if(flipped)
			if(get_dir(loc, from) == dir)	//Flipped tables catch mroe bullets
				chance += 20
			else
				return 1					//But only from one side
		if(prob(chance))
			health -= P.damage / 2
			if(health > 0)
				visible_message(SPAN_WARNING("[P] hits \the [src]!"))
				return 0
			else
				visible_message(SPAN_WARNING("[src] breaks down!"))
				qdel(src)
				return 1
	return 1

/obj/structure/table/CheckExit(atom/movable/mover, turf/target)
	if(istype(mover) && HAS_PASS_FLAGS(mover, PASS_FLAG_TABLE))
		return 1
	if(flipped)
		if(get_dir(loc, target) == dir)
			return !density
		else
			return 1
	return 1

/obj/structure/table/MouseDrop_T(obj/O, mob/user)
	if(!isitem(O) || user.get_active_hand() != O)
		return
	if(isrobot(user))
		return
	user.drop_item()
	if(O.loc != src.loc)
		step(O, get_dir(O, src))
	return

/obj/structure/table/attack_grab(obj/item/grab/grab, mob/user, mob/grabbed)
	if(get_dist(src, user) > 2)
		return FALSE
	if(isliving(grabbed))
		var/mob/living/living_grabbed = grabbed
		if(grab.state < 2)
			if(user.a_intent == "hurt")
				if(prob(15))
					living_grabbed.Weaken(5)
				living_grabbed.apply_damage(8, def_zone = "head")
				visible_message(SPAN_WARNING("[user] slams \the [living_grabbed]'s face against \the [src]!"))
				playsound(src, 'sound/weapons/melee/tablehit1.ogg', 50, 1)
			else
				to_chat(user, SPAN_WARNING("You need a better grip to do that!"))
			return TRUE

	grabbed.forceMove(loc)
	grabbed.Weaken(5)
	visible_message(SPAN_WARNING("[user] puts \the [grabbed] on \the [src]."))
	qdel(grab)
	return TRUE

/obj/structure/table/attack_tool(obj/item/tool, mob/user)
	if(iswrench(tool))
		to_chat(user, SPAN_INFO("Now disassembling \the [src]..."))
		playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, 5 SECONDS))
			qdel(src)
		return TRUE
	return ..()

/obj/structure/table/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/melee/energy/blade))
		make_sparks(5, FALSE, loc)
		playsound(src, 'sound/weapons/melee/blade1.ogg', 50, 1)
		playsound(src, "sparks", 50, 1)
		user.visible_message(
			SPAN_WARNING("[user] slices \the [src] apart!"),
			SPAN_WARNING("You slice \the [src] apart!"),
			SPAN_WARNING("You hear \the [src] coming apart.")
		)
		qdel(src)
		return TRUE

	if(!isrobot(user))
		user.drop_item(src)
		return TRUE

	return ..()

/obj/structure/table/proc/straight_table_check(direction)
	var/obj/structure/table/T
	for(var/angle in list(-90, 90))
		T = locate() in get_step(src.loc, turn(direction, angle))
		if(T && !T.flipped)
			return 0
	T = locate() in get_step(src.loc, direction)
	if(!T || T.flipped)
		return 1
	if(istype(T, /obj/structure/table/reinforced))
		var/obj/structure/table/reinforced/R = T
		if(R.status == 2)
			return 0
	return T.straight_table_check(direction)

/obj/structure/table/verb/do_flip()
	set category = null
	set name = "Flip Table"
	set desc = "Flips a non-reinforced table"
	set src in oview(1)

	if(!can_touch(usr) || ismouse(usr))
		return

	if(!flip(get_cardinal_dir(usr, src)))
		to_chat(usr, SPAN_NOTICE("It won't budge."))
		return

	usr.visible_message(SPAN_WARNING("[usr] flips \the [src]!"))

	if(climbable)
		structure_shaken()

	return

/obj/structure/table/proc/unflipping_check(direction)
	for(var/mob/M in oview(src,0))
		return 0

	var/list/L = list()
	if(direction)
		L.Add(direction)
	else
		L.Add(turn(src.dir, -90))
		L.Add(turn(src.dir, 90))
	for(var/new_dir in L)
		var/obj/structure/table/T = locate() in get_step(src.loc,new_dir)
		if(T)
			if(T.flipped && T.dir == src.dir && !T.unflipping_check(new_dir))
				return 0
	return 1

/obj/structure/table/proc/do_put()
	set category = null
	set name = "Put Table Back"
	set desc = "Puts flipped table back"
	set src in oview(1)

	if(!can_touch(usr))
		return

	if(!unflipping_check())
		to_chat(usr, SPAN_NOTICE("It won't budge."))
		return
	unflip()

/obj/structure/table/proc/flip(direction)
	if(!straight_table_check(turn(direction, 90)) || !straight_table_check(turn(direction, -90)))
		return 0

	verbs -=/obj/structure/table/verb/do_flip
	verbs +=/obj/structure/table/proc/do_put

	var/list/targets = list(get_step(src, dir), get_step(src, turn(dir, 45)), get_step(src, turn(dir, -45)))
	for_no_type_check(var/atom/movable/mover, GET_TURF(src))
		if(!mover.anchored)
			spawn(0)
				mover.throw_at(pick(targets), 1, 1)

	dir = direction
	if(dir != NORTH)
		layer = 5
	flipped = 1
	SET_ATOM_FLAGS(src, ATOM_FLAG_ON_BORDER)
	for(var/D in list(turn(direction, 90), turn(direction, -90)))
		var/obj/structure/table/T = locate() in get_step(src, D)
		if(T && !T.flipped)
			T.flip(direction)
	update_icon()
	update_adjacent()

	return 1

/obj/structure/table/proc/unflip()
	verbs -=/obj/structure/table/proc/do_put
	verbs +=/obj/structure/table/verb/do_flip

	reset_plane_and_layer()
	flipped = 0
	UNSET_ATOM_FLAGS(src, ATOM_FLAG_ON_BORDER)
	for(var/D in list(turn(dir, 90), turn(dir, -90)))
		var/obj/structure/table/T = locate() in get_step(src.loc, D)
		if(T && T.flipped && T.dir == src.dir)
			T.unflip()
	update_icon()
	update_adjacent()

	return 1

/*
 * Wooden tables
 */
/obj/structure/table/woodentable
	name = "wooden table"
	desc = "Do not apply fire to this. Rumour says it burns easily."
	icon_state = "wood_table"
	parts = /obj/item/table_parts/wood
	health = 50

/*
 * Reinforced tables
 */
/obj/structure/table/reinforced
	name = "reinforced table"
	desc = "A version of the four legged table. It is stronger."
	icon_state = "reinf_table"
	health = 200
	var/status = 2
	parts = /obj/item/table_parts/reinforced

/obj/structure/table/reinforced/flip(direction)
	if(status == 2)
		return 0
	else
		return ..()

/obj/structure/table/reinforced/attackby(obj/item/W, mob/user)
	if(iswelder(W))
		var/obj/item/welding_torch/WT = W
		if(WT.remove_fuel(0, user))
			if(src.status == 2)
				to_chat(user, SPAN_INFO("Now weakening the reinforced table."))
				playsound(src, 'sound/items/Welder.ogg', 50, 1)
				if(do_after(user, 50))
					if(!src || !WT.isOn())
						return
					to_chat(user, SPAN_INFO("Table weakened."))
					src.status = 1
			else
				to_chat(user, SPAN_INFO("Now strengthening the reinforced table."))
				playsound(src, 'sound/items/Welder.ogg', 50, 1)
				if(do_after(user, 50))
					if(!src || !WT.isOn())
						return
					to_chat(user, SPAN_INFO("Table strengthened."))
					src.status = 2
			return
		return

	if(iswrench(W))
		if(src.status == 2)
			return
	..()

/*
 * Racks
 */
/obj/structure/rack
	name = "rack"
	desc = "Different from the Middle Ages version."
	icon = 'icons/obj/structures/tables.dmi'
	icon_state = "rack"
	density = TRUE
	anchored = TRUE
	throwpass = 1	//You can throw objects over this, despite it's density.
	breakable = 1
	parts = /obj/item/rack_parts

/obj/structure/rack/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(air_group || height == 0)
		return TRUE
	if(density == 0) //Because broken racks -Agouri |TODO: SPRITE!|
		return TRUE
	if(istype(mover) && HAS_PASS_FLAGS(mover, PASS_FLAG_TABLE))
		return TRUE
	else
		return FALSE

/obj/structure/rack/MouseDrop_T(obj/O, mob/user)
	if(!isitem(O) || user.get_active_hand() != O)
		return
	if(isrobot(user))
		return
	user.drop_item()
	if(O.loc != src.loc)
		step(O, get_dir(O, src))
	return

/obj/structure/rack/attackby(obj/item/W, mob/user)
	if(iswrench(W))
		new /obj/item/rack_parts(src.loc)
		playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
		qdel(src)
		return
	if(isrobot(user))
		return
	user.drop_item()
	if(W && W.loc)
		W.forceMove(loc)
	return