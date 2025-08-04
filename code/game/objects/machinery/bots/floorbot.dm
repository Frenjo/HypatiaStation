// Floorbot
/obj/machinery/bot/floorbot
	name = "floorbot"
	desc = "A little floor repairing robot. He looks so excited!"
	icon = 'icons/mob/bot/floorbot.dmi'
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

/obj/machinery/bot/floorbot/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	usr.set_machine(src)
	interact(user)

/obj/machinery/bot/floorbot/interact(mob/user)
	var/dat
	dat += "<TT><B>Automatic Station Floor Repairer v1.0</B></TT><BR><BR>"
	dat += "Status: <A href='byond://?src=\ref[src];operation=start'>[on ? "On" : "Off"]</A><BR>"
	dat += "Maintenance panel panel is [open ? "opened" : "closed"]<BR>"
	dat += "Tiles left: [amount]<BR>"
	dat += "Behvaiour controls are [locked ? "locked" : "unlocked"]<BR>"
	if(!locked || issilicon(user))
		dat += "Improves floors: <A href='byond://?src=\ref[src];operation=improve'>[improvefloors ? "Yes" : "No"]</A><BR>"
		dat += "Finds tiles: <A href='byond://?src=\ref[src];operation=tiles'>[eattiles ? "Yes" : "No"]</A><BR>"
		dat += "Make singles pieces of metal into tiles when empty: <A href='byond://?src=\ref[src];operation=make'>[maketiles ? "Yes" : "No"]</A><BR>"
		var/bmode
		if(targetdirection)
			bmode = dir2text(targetdirection)
		else
			bmode = "Disabled"
		dat += "<BR><BR>Bridge Mode : <A href='byond://?src=\ref[src];operation=bridgemode'>[bmode]</A><BR>"

	SHOW_BROWSER(user, "<HEAD><TITLE>Repairbot v1.0 controls</TITLE></HEAD>[dat]", "window=autorepair")
	onclose(user, "autorepair")

/obj/machinery/bot/floorbot/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stack/tile/metal/grey))
		var/obj/item/stack/tile/metal/grey/T = W
		if(amount >= 50)
			return
		var/loaded = min(50 - amount, T.amount)
		T.use(loaded)
		amount += loaded
		to_chat(user, SPAN_INFO("You load [loaded] tiles into the floorbot. He now contains [amount] tiles."))
		updateicon()
	else if(istype(W, /obj/item/card/id)||istype(W, /obj/item/pda))
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

/obj/machinery/bot/floorbot/Emag(mob/user)
	. = ..()
	if(open && !locked)
		if(isnotnull(user))
			to_chat(user, SPAN_NOTICE("\The [src] buzzes and beeps."))

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
			for(var/obj/item/stack/tile/metal/grey/T in view(7, src))
				if(T != oldtarget && !(target in floorbottargets))
					oldtarget = T
					target = T
					break
		if(target == null || !target)
			if(maketiles)
				if(target == null || !target)
					for(var/obj/item/stack/sheet/steel/M in view(7, src))
						if(!(M in floorbottargets) && M != oldtarget && M.amount == 1 && !(istype(M.loc, /turf/closed/wall)))
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
			for(var/turf/open/floor/F in view(7, src))
				if(!(F in floorbottargets) && F != oldtarget && F.icon_state == "Floor1" && !(istype(F, /turf/open/floor/plating/metal)))
					oldtarget = F
					target = F
					break
		if((!target || target == null) && eattiles)
			for(var/obj/item/stack/tile/metal/grey/T in view(7, src))
				if(!(T in floorbottargets) && T != oldtarget)
					oldtarget = T
					target = T
					break

	if((!target || target == null) && emagged == 2)
		if(!target || target == null)
			for(var/turf/open/floor/D in view(7, src))
				if(!(D in floorbottargets) && D != oldtarget && D.tile_path)
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
		if(istype(target, /obj/item/stack/tile/metal/grey))
			eattile(target)
		else if(istype(target, /obj/item/stack/sheet/steel))
			maketile(target)
		else if(istype(target, /turf/) && emagged < 2)
			repair(target)
		else if(emagged == 2 && isfloorturf(target))
			var/turf/open/floor/F = target
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
	else if(!isfloorturf(target))
		return
	if(amount <= 0)
		return
	anchored = TRUE
	icon_state = "floorbot-c"
	if(isspace(target))
		visible_message(SPAN_NOTICE("[src] begins to repair the hole."))
		var/obj/item/stack/tile/metal/grey/T = new /obj/item/stack/tile/metal/grey()
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

/obj/machinery/bot/floorbot/proc/eattile(obj/item/stack/tile/metal/grey/T)
	if(!istype(T, /obj/item/stack/tile/metal/grey))
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

/obj/machinery/bot/floorbot/proc/maketile(obj/item/stack/sheet/steel/M)
	if(!istype(M, /obj/item/stack/sheet/steel))
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
		var/obj/item/stack/tile/metal/grey/T = new /obj/item/stack/tile/metal/grey(M.loc)
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

	var/turf/T = GET_TURF(src)
	var/obj/item/storage/toolbox/mechanical/N = new /obj/item/storage/toolbox/mechanical(T)
	N.contents = list()
	new /obj/item/assembly/prox_sensor(T)
	if(prob(50))
		new /obj/item/robot_part/l_arm(T)

	while(amount)//Dumps the tiles into the appropriate sized stacks
		if(amount >= 16)
			var/obj/item/stack/tile/metal/grey/tile = new /obj/item/stack/tile/metal/grey(T)
			tile.amount = 16
			amount -= 16
		else
			var/obj/item/stack/tile/metal/grey/tile = new /obj/item/stack/tile/metal/grey(T)
			tile.amount = amount
			amount = 0

	make_sparks(3, TRUE, src)
	return ..()

// Floorbot Assembly
/obj/item/storage/toolbox/mechanical/attack_by(obj/item/I, mob/user)
	if(!istype(I, /obj/item/stack/tile/metal/grey))
		return ..()
	if(length(contents))
		to_chat(user, SPAN_WARNING("\The [I] won't fit as there is already stuff inside."))
		return TRUE
	user.s_active?.close(user)
	qdel(I)
	var/obj/item/floorbot_assembly/assembly = new /obj/item/floorbot_assembly()
	user.put_in_hands(assembly)
	to_chat(user, SPAN_INFO("You add the tiles into the empty toolbox. They protrude from the top."))
	user.drop_from_inventory(src)
	qdel(src)
	return TRUE

/obj/item/floorbot_assembly
	name = "tiles and toolbox"
	desc = "It's a toolbox with tiles sticking out of the top."
	icon = 'icons/mob/bot/floorbot.dmi'
	icon_state = "toolbox_tiles"

	w_class = 3

	force = 3
	throwforce = 10
	throw_speed = 2
	throw_range = 5

	var/created_name = "Floorbot"
	var/has_sensor = FALSE

/obj/item/floorbot_assembly/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/pen))
		var/t = copytext(stripped_input(user, "Enter new robot name", name, created_name), 1, MAX_NAME_LEN)
		if(isnull(t))
			return
		if(!in_range(src, usr) && loc != usr)
			return
		created_name = t
		return TRUE

	if(!has_sensor && isprox(I))
		qdel(I)
		has_sensor = TRUE
		name = "tiles, toolbox and sensor arrangement"
		desc = "It's a toolbox with tiles sticking out of the top and a sensor attached."
		icon_state = "toolbox_tiles_sensor"
		to_chat(user, SPAN_INFO("You add the sensor to the toolbox and tiles!"))
		user.put_in_hands(src)
		return TRUE

	if(has_sensor && (istype(I, /obj/item/robot_part/l_arm) || istype(I, /obj/item/robot_part/r_arm)))
		qdel(I)
		var/obj/machinery/bot/floorbot/bot = new /obj/machinery/bot/floorbot(GET_TURF(src))
		bot.name = created_name
		to_chat(user, SPAN_INFO("You add the robot arm to the odd looking toolbox assembly! Boop beep!"))
		user.drop_from_inventory(src)
		qdel(src)
		return TRUE

	return ..()