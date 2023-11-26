//Floorbot assemblies
/obj/item/toolbox_tiles
	desc = "It's a toolbox with tiles sticking out the top"
	name = "tiles and toolbox"
	icon = 'icons/obj/aibots.dmi'
	icon_state = "toolbox_tiles"
	force = 3.0
	throwforce = 10.0
	throw_speed = 2
	throw_range = 5
	w_class = 3.0

	var/created_name = "Floorbot"

/obj/item/toolbox_tiles_sensor
	desc = "It's a toolbox with tiles sticking out the top and a sensor attached"
	name = "tiles, toolbox and sensor arrangement"
	icon = 'icons/obj/aibots.dmi'
	icon_state = "toolbox_tiles_sensor"
	force = 3.0
	throwforce = 10.0
	throw_speed = 2
	throw_range = 5
	w_class = 3.0

	var/created_name = "Floorbot"

//Floorbot
/obj/machinery/bot/floorbot
	name = "Floorbot"
	desc = "A little floor repairing robot, he looks so excited!"
	icon = 'icons/obj/aibots.dmi'
	icon_state = "floorbot0"
	layer = 5
	density = FALSE
	anchored = FALSE
	health = 25
	maxhealth = 25
	//weight = 1.0E7

	req_access = list(ACCESS_CONSTRUCTION)

	var/amount = 10
	var/repairing = FALSE
	var/improvefloors = 0
	var/eattiles = 0
	var/maketiles = 0
	var/turf/target
	var/turf/oldtarget
	var/oldloc = null
	var/list/path = list()
	var/targetdirection

/obj/machinery/bot/floorbot/New()
	. = ..()
	updateicon()

/obj/machinery/bot/floorbot/turn_on()
	. = ..()
	updateicon()
	updateUsrDialog()

/obj/machinery/bot/floorbot/turn_off()
	. = ..()
	target = null
	oldtarget = null
	oldloc = null
	updateicon()
	path = list()
	updateUsrDialog()

/obj/machinery/bot/floorbot/attack_hand(mob/user as mob)
	. = ..()
	if(.)
		return
	usr.set_machine(src)
	interact(user)

/obj/machinery/bot/floorbot/interact(mob/user as mob)
	var/dat
	dat += "<TT><B>Automatic Station Floor Repairer v1.0</B></TT><BR><BR>"
	dat += "Status: <A href='?src=\ref[src];operation=start'>[on ? "On" : "Off"]</A><BR>"
	dat += "Maintenance panel panel is [open ? "opened" : "closed"]<BR>"
	dat += "Tiles left: [amount]<BR>"
	dat += "Behvaiour controls are [locked ? "locked" : "unlocked"]<BR>"
	if(!locked || issilicon(user))
		dat += "Improves floors: <A href='?src=\ref[src];operation=improve'>[improvefloors ? "Yes" : "No"]</A><BR>"
		dat += "Finds tiles: <A href='?src=\ref[src];operation=tiles'>[eattiles ? "Yes" : "No"]</A><BR>"
		dat += "Make singles pieces of metal into tiles when empty: <A href='?src=\ref[src];operation=make'>[maketiles ? "Yes" : "No"]</A><BR>"
		var/bmode
		if(targetdirection)
			bmode = dir2text(targetdirection)
		else
			bmode = "Disabled"
		dat += "<BR><BR>Bridge Mode : <A href='?src=\ref[src];operation=bridgemode'>[bmode]</A><BR>"

	user << browse("<HEAD><TITLE>Repairbot v1.0 controls</TITLE></HEAD>[dat]", "window=autorepair")
	onclose(user, "autorepair")

/obj/machinery/bot/floorbot/attackby(obj/item/W , mob/user as mob)
	if(istype(W, /obj/item/stack/tile/plasteel))
		var/obj/item/stack/tile/plasteel/T = W
		if(amount >= 50)
			return
		var/loaded = min(50 - amount, T.amount)
		T.use(loaded)
		amount += loaded
		to_chat(user, SPAN_INFO("You load [loaded] tiles into the floorbot. He now contains [amount] tiles."))
		updateicon()
	else if(istype(W, /obj/item/card/id)||istype(W, /obj/item/device/pda))
		if(allowed(usr) && !open && !emagged)
			locked = !locked
			FEEDBACK_TOGGLE_CONTROLS_LOCK(user, locked)
		else
			if(emagged)
				FEEDBACK_ERROR_GENERIC(user)
			if(open)
				to_chat(user, SPAN_WARNING("Please close the access panel before locking it."))
			else
				FEEDBACK_ACCESS_DENIED(user)
		updateUsrDialog()
	else
		..()

/obj/machinery/bot/floorbot/Emag(mob/user as mob)
	..()
	if(open && !locked)
		if(isnotnull(user))
			to_chat(user, SPAN_NOTICE("The [src] buzzes and beeps."))

/obj/machinery/bot/floorbot/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)
	switch(href_list["operation"])
		if("start")
			if(on)
				turn_off()
			else
				turn_on()
		if("improve")
			improvefloors = !improvefloors
			updateUsrDialog()
		if("tiles")
			eattiles = !eattiles
			updateUsrDialog()
		if("make")
			maketiles = !maketiles
			updateUsrDialog()
		if("bridgemode")
			switch(targetdirection)
				if(null)
					targetdirection = 1
				if(1)
					targetdirection = 2
				if(2)
					targetdirection = 4
				if(4)
					targetdirection = 8
				if(8)
					targetdirection = null
				else
					targetdirection = null
			updateUsrDialog()

/obj/machinery/bot/floorbot/process()
	set background = BACKGROUND_ENABLED

	if(!on)
		return
	if(repairing)
		return
	var/list/floorbottargets = list()
	if(amount <= 0 && ((target == null) || !target))
		if(eattiles)
			for(var/obj/item/stack/tile/plasteel/T in view(7, src))
				if(T != oldtarget && !(target in floorbottargets))
					oldtarget = T
					target = T
					break
		if(target == null || !target)
			if(maketiles)
				if(target == null || !target)
					for(var/obj/item/stack/sheet/metal/M in view(7, src))
						if(!(M in floorbottargets) && M != oldtarget && M.amount == 1 && !(istype(M.loc, /turf/simulated/wall)))
							oldtarget = M
							target = M
							break
		else
			return
	if(prob(5))
		visible_message(
			SPAN_INFO("[src] makes an excited booping beeping sound!"),
			SPAN_INFO("You hear an excited beeping and booping.")
		)

	if((!target || target == null) && emagged < 2)
		if(targetdirection != null)
			/*
			for (var/turf/space/D in view(7,src))
				if(!(D in floorbottargets) && D != oldtarget)			// Added for bridging mode -- TLE
					if(get_dir(src, D) == targetdirection)
						oldtarget = D
						target = D
						break
			*/
			var/turf/T = get_step(src, targetdirection)
			if(isspace(T))
				oldtarget = T
				target = T
		if(!target || target == null)
			for(var/turf/space/D in view(7, src))
				if(!(D in floorbottargets) && D != oldtarget && (D.loc.name != "Space"))
					oldtarget = D
					target = D
					break
		if((!target || target == null ) && improvefloors)
			for(var/turf/simulated/floor/F in view(7, src))
				if(!(F in floorbottargets) && F != oldtarget && F.icon_state == "Floor1" && !(istype(F, /turf/simulated/floor/plating)))
					oldtarget = F
					target = F
					break
		if((!target || target == null) && eattiles)
			for(var/obj/item/stack/tile/plasteel/T in view(7, src))
				if(!(T in floorbottargets) && T != oldtarget)
					oldtarget = T
					target = T
					break

	if((!target || target == null) && emagged == 2)
		if(!target || target == null)
			for(var/turf/simulated/floor/D in view(7, src))
				if(!(D in floorbottargets) && D != oldtarget && D.floor_type)
					oldtarget = D
					target = D
					break

	if(!target || target == null)
		if(loc != oldloc)
			oldtarget = null
		return

	if(target && (target != null) && !length(path))
		spawn(0)
			if(!isturf(target))
				path = AStar(loc, target.loc, /turf/proc/AdjacentTurfsSpace, /turf/proc/Distance, 0, 30, id = botcard)
			else
				path = AStar(loc, target, /turf/proc/AdjacentTurfsSpace, /turf/proc/Distance, 0, 30, id = botcard)
			if(!path)
				path = list()
			if(!length(path))
				oldtarget = target
				target = null
		return
	if(length(path) && target && (target != null))
		step_to(src, path[1])
		path -= path[1]
	else if(length(path) == 1)
		step_to(src, target)
		path = list()

	if(loc == target || loc == target.loc)
		if(istype(target, /obj/item/stack/tile/plasteel))
			eattile(target)
		else if(istype(target, /obj/item/stack/sheet/metal))
			maketile(target)
		else if(istype(target, /turf/) && emagged < 2)
			repair(target)
		else if(emagged == 2 && istype(target,/turf/simulated/floor))
			var/turf/simulated/floor/F = target
			anchored = TRUE
			repairing = TRUE
			if(prob(90))
				F.break_tile_to_plating()
			else
				F.ReplaceWithLattice()
			visible_message(
				SPAN_NOTICE("[src] makes an excited booping sound."),
				SPAN_NOTICE("You hear an excited booping.")
			)
			spawn(50)
				amount ++
				anchored = FALSE
				repairing = FALSE
				target = null
		path = list()
		return

	oldloc = loc

/obj/machinery/bot/floorbot/proc/repair(turf/target)
	if(isspace(target))
		if(istype(target.loc, /area/space))
			return
	else if(!istype(target, /turf/simulated/floor))
		return
	if(amount <= 0)
		return
	anchored = TRUE
	icon_state = "floorbot-c"
	if(isspace(target))
		visible_message(SPAN_NOTICE("[src] begins to repair the hole."))
		var/obj/item/stack/tile/plasteel/T = new /obj/item/stack/tile/plasteel()
		repairing = TRUE
		spawn(50)
			T.build(loc)
			repairing = FALSE
			amount -= 1
			updateicon()
			anchored = FALSE
			target = null
	else
		visible_message(SPAN_NOTICE("[src] begins to improve the floor."))
		repairing = TRUE
		spawn(50)
			loc.icon_state = "floor"
			repairing = FALSE
			amount -= 1
			updateicon()
			anchored = FALSE
			target = null

/obj/machinery/bot/floorbot/proc/eattile(obj/item/stack/tile/plasteel/T)
	if(!istype(T, /obj/item/stack/tile/plasteel))
		return
	visible_message(SPAN_NOTICE("[src] begins to collect tiles."))
	repairing = TRUE
	spawn(20)
		if(isnull(T))
			target = null
			repairing = FALSE
			return
		if(amount + T.amount > 50)
			var/i = 50 - amount
			amount += i
			T.amount -= i
		else
			amount += T.amount
			qdel(T)
		updateicon()
		target = null
		repairing = FALSE

/obj/machinery/bot/floorbot/proc/maketile(obj/item/stack/sheet/metal/M)
	if(!istype(M, /obj/item/stack/sheet/metal))
		return
	if(M.amount > 1)
		return
	visible_message(SPAN_NOTICE("[src] begins to create tiles."))
	repairing = TRUE
	spawn(20)
		if(isnull(M))
			target = null
			repairing = FALSE
			return
		var/obj/item/stack/tile/plasteel/T = new /obj/item/stack/tile/plasteel(M.loc)
		T.amount = 4
		qdel(M)
		target = null
		repairing = FALSE

/obj/machinery/bot/floorbot/proc/updateicon()
	if(amount > 0)
		icon_state = "floorbot[on]"
	else
		icon_state = "floorbot[on]e"

/obj/machinery/bot/floorbot/explode()
	on = FALSE
	visible_message(SPAN_DANGER("[src] blows apart!"))
	var/turf/T = get_turf(src)

	var/obj/item/storage/toolbox/mechanical/N = new /obj/item/storage/toolbox/mechanical(T)
	N.contents = list()

	new /obj/item/device/assembly/prox_sensor(T)

	if(prob(50))
		new /obj/item/robot_parts/l_arm(T)

	while(amount)//Dumps the tiles into the appropriate sized stacks
		if(amount >= 16)
			var/obj/item/stack/tile/plasteel/tile = new /obj/item/stack/tile/plasteel(T)
			tile.amount = 16
			amount -= 16
		else
			var/obj/item/stack/tile/plasteel/tile = new /obj/item/stack/tile/plasteel(T)
			tile.amount = amount
			amount = 0

	var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread()
	s.set_up(3, 1, src)
	s.start()
	qdel(src)

/obj/item/storage/toolbox/mechanical/attackby(obj/item/stack/tile/plasteel/T, mob/user as mob)
	if(!istype(T, /obj/item/stack/tile/plasteel))
		..()
		return
	if(length(contents))
		to_chat(user, SPAN_NOTICE("They won't fit as there is already stuff inside."))
		return
	if(user.s_active)
		user.s_active.close(user)
	qdel(T)
	var/obj/item/toolbox_tiles/B = new /obj/item/toolbox_tiles()
	user.put_in_hands(B)
	to_chat(user, SPAN_INFO("You add the tiles into the empty toolbox. They protrude from the top."))
	user.drop_from_inventory(src)
	qdel(src)

/obj/item/toolbox_tiles/attackby(obj/item/W, mob/user as mob)
	..()
	if(isprox(W))
		qdel(W)
		var/obj/item/toolbox_tiles_sensor/B = new /obj/item/toolbox_tiles_sensor()
		B.created_name = created_name
		user.put_in_hands(B)
		to_chat(user, SPAN_INFO("You add the sensor to the toolbox and tiles!"))
		user.drop_from_inventory(src)
		qdel(src)

	else if(istype(W, /obj/item/pen))
		var/t = copytext(stripped_input(user, "Enter new robot name", name, created_name), 1, MAX_NAME_LEN)
		if(isnull(t))
			return
		if(!in_range(src, usr) && loc != usr)
			return

		created_name = t

/obj/item/toolbox_tiles_sensor/attackby(obj/item/W, mob/user as mob)
	..()
	if(istype(W, /obj/item/robot_parts/l_arm) || istype(W, /obj/item/robot_parts/r_arm))
		qdel(W)
		var/turf/T = get_turf(user.loc)
		var/obj/machinery/bot/floorbot/A = new /obj/machinery/bot/floorbot(T)
		A.name = created_name
		to_chat(user, SPAN_INFO("You add the robot arm to the odd looking toolbox assembly! Boop beep!"))
		user.drop_from_inventory(src)
		qdel(src)

	else if(istype(W, /obj/item/pen))
		var/t = stripped_input(user, "Enter new robot name", name, created_name)
		if(isnull(t))
			return
		if(!in_range(src, usr) && loc != usr)
			return

		created_name = t