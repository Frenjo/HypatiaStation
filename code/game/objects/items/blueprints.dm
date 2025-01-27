/obj/item/blueprints
	name = "station blueprints"
	desc = "Blueprints of the station. There is a \"Classified\" stamp and several coffee stains on it."
	icon = 'icons/obj/items.dmi'
	icon_state = "blueprints"
	attack_verb = list("attacked", "bapped", "hit")
	var/const/AREA_ERRNONE =	0
	var/const/AREA_STATION =	1
	var/const/AREA_SPACE =		2
	var/const/AREA_SPECIAL =	3

	var/const/BORDER_ERROR =	0
	var/const/BORDER_NONE =		1
	var/const/BORDER_BETWEEN =	2
	var/const/BORDER_2NDTILE =	3
	var/const/BORDER_SPACE =	4

	var/const/ROOM_ERR_LOLWAT =		0
	var/const/ROOM_ERR_SPACE =		-1
	var/const/ROOM_ERR_TOOLARGE =	-2

/obj/item/blueprints/attack_self(mob/M)
	if(!ishuman(M))
		to_chat(M, "This stack of blue paper means nothing to you.") //monkeys cannot into projecting
		return
	interact()
	return

/obj/item/blueprints/Topic(href, href_list)
	..()
	if((usr.restrained() || usr.stat || usr.get_active_hand() != src))
		return
	if(!href_list["action"])
		return
	switch(href_list["action"])
		if("create_area")
			if(get_area_type() != AREA_SPACE)
				interact()
				return
			create_area()
		if("edit_area")
			if(get_area_type() != AREA_STATION)
				interact()
				return
			edit_area()

/obj/item/blueprints/interact()
	var/area/A = GET_AREA(src)
	var/text = {"<HTML><head><title>[src]</title></head><BODY>
<h2>[station_name()] blueprints</h2>
<small>Property of NanoTrasen. For heads of staff only. Store in high-secure storage.</small><hr>
"}
	switch(get_area_type())
		if(AREA_SPACE)
			text += {"
<p>According the blueprints, you are now in <b>outer space</b>.  Hold your breath.</p>
<p><a href='byond://?src=\ref[src];action=create_area'>Mark this place as new area.</a></p>
"}
		if(AREA_STATION)
			text += {"
<p>According the blueprints, you are now in <b>\"[A.name]\"</b>.</p>
<p>You may <a href='byond://?src=\ref[src];action=edit_area'>
move an amendment</a> to the drawing.</p>
"}
		if(AREA_SPECIAL)
			text += {"
<p>This place isn't noted on the blueprint.</p>
"}
		else
			return
	text += "</BODY></HTML>"
	usr << browse(text, "window=blueprints")
	onclose(usr, "blueprints")

/obj/item/blueprints/proc/get_area_type(area/A = GET_AREA(src))
	if(istype(A, /area/space))
		return AREA_SPACE

	var/list/SPECIALS = list(
		/area/shuttle,
		/area/centcom,
		/area/external/asteroid,
		/area/enemy/syndicate_station,
		/area/enemy/wizard_station,
		/area/external/prison
		// /area/external/abandoned/derelict //commented out, all hail derelict-rebuilders!
	)
	for(var/type in SPECIALS)
		if(istype(A, type))
			return AREA_SPECIAL
	return AREA_STATION

/obj/item/blueprints/proc/create_area()
	//to_world("DEBUG: create_area")
	var/res = detect_room(GET_TURF(usr))
	if(!islist(res))
		switch(res)
			if(ROOM_ERR_SPACE)
				to_chat(usr, SPAN_WARNING("The new area must be completely airtight!"))
				return
			if(ROOM_ERR_TOOLARGE)
				to_chat(usr, SPAN_WARNING("The new area is too large!"))
				return
			else
				to_chat(usr, SPAN_WARNING("Error! Please notify administration!"))
				return
	var/list/turf/turfs = res
	var/str = trim(stripped_input(usr, "New area name:", "Blueprint Editing", "", MAX_NAME_LEN))
	if(!str || !length(str)) //cancel
		return
	if(length(str) > 50)
		to_chat(usr, SPAN_WARNING("Name too long."))
		return
	var/area/A = new
	A.name = str
	A.tag = "[A.type]_[md5(str)]" // without this dynamic light system ruin everithing
	//var/ma
	//ma = A.master ? "[A.master]" : "(null)"
	//to_world("DEBUG: create_area: <br>A.name=[A.name]<br>A.tag=[A.tag]<br>A.master=[ma]")
	for(var/channel in A.power_channels)
		A.power_channels[channel] = FALSE
	A.always_unpowered = FALSE
	move_turfs_to_area(turfs, A)

	//for_no_type_check(var/turf/T, A.turf_list)
	//	T.lighting_changed = 1
	//	lighting_controller.changed_turfs += T

	spawn(5)
		//ma = A.master ? "[A.master]" : "(null)"
		//to_world("DEBUG: create_area(5): <br>A.name=[A.name]<br>A.tag=[A.tag]<br>A.master=[ma]")
		interact()
	return

/obj/item/blueprints/proc/move_turfs_to_area(list/turf/turfs, area/A)
	A.contents.Add(turfs)
	//oldarea.contents.Remove(usr.loc) // not needed
	//T.forceMove(A) //error: cannot change constant value

/obj/item/blueprints/proc/edit_area()
	var/area/A = GET_AREA(src)
	//to_world("DEBUG: edit_area")
	var/prevname = "[A.name]"
	var/str = trim(stripped_input(usr, "New area name:", "Blueprint Editing", prevname, MAX_NAME_LEN))
	if(!str || !length(str) || str == prevname) //cancel
		return
	if(length(str) > 50)
		to_chat(usr, SPAN_WARNING("Text too long."))
		return
	set_area_machinery_title(A, str, prevname)
	//for(var/area/RA in A.related)
		//RA.name = str
	A.name = str
	to_chat(usr, SPAN_INFO("You set the area '[prevname]' title to '[str]'."))
	interact()
	return

/obj/item/blueprints/proc/set_area_machinery_title(area/A, title, oldtitle)
	if(!oldtitle) // or replacetextx goes to infinite loop
		return
	//for(var/area/RA in A.related)
	//	for(var/obj/machinery/air_alarm/M in RA)
	//		M.name = replacetextx(M.name,oldtitle,title)
	//	for(var/obj/machinery/power/apc/M in RA)
	//		M.name = replacetextx(M.name,oldtitle,title)
	//	for(var/obj/machinery/atmospherics/unary/vent_scrubber/M in RA)
	//		M.name = replacetextx(M.name,oldtitle,title)
	//	for(var/obj/machinery/atmospherics/unary/vent_pump/M in RA)
	//		M.name = replacetextx(M.name,oldtitle,title)
	//	for(var/obj/machinery/door/M in RA)
	//		M.name = replacetextx(M.name,oldtitle,title)
	//TODO: much much more. Unnamed airlocks, cameras, etc.

	for(var/obj/machinery/air_alarm/M in A)
		M.name = replacetext(M.name, oldtitle, title)
	for(var/obj/machinery/power/apc/M in A)
		M.name = replacetext(M.name, oldtitle, title)
	for(var/obj/machinery/atmospherics/unary/vent_scrubber/M in A)
		M.name = replacetext(M.name, oldtitle, title)
	for(var/obj/machinery/atmospherics/unary/vent_pump/M in A)
		M.name = replacetext(M.name, oldtitle, title)
	for(var/obj/machinery/door/M in A)
		M.name = replacetext(M.name, oldtitle, title)
	//TODO: much much more. Unnamed airlocks, cameras, etc.

/obj/item/blueprints/proc/check_tile_is_border(turf/T2, dir)
	if(isspace(T2))
		return BORDER_SPACE //omg hull breach we all going to die here
	if(istype(T2, /turf/closed/wall/shuttle) || istype(T2, /turf/open/floor/shuttle))
		return BORDER_SPACE
	if(get_area_type(T2.loc) != AREA_SPACE)
		return BORDER_BETWEEN
	if(istype(T2, /turf/closed/wall))
		return BORDER_2NDTILE
	if(!isopenturf(T2))
		return BORDER_BETWEEN

	for(var/obj/structure/window/W in T2)
		if(turn(dir, 180) == W.dir)
			return BORDER_BETWEEN
		if(W.dir in list(NORTHEAST, SOUTHEAST, NORTHWEST, SOUTHWEST))
			return BORDER_2NDTILE
	for(var/obj/machinery/door/window/D in T2)
		if(turn(dir, 180) == D.dir)
			return BORDER_BETWEEN
	if(locate(/obj/machinery/door) in T2)
		return BORDER_2NDTILE
	if(locate(/obj/structure/falsewall) in T2)
		return BORDER_2NDTILE

	return BORDER_NONE

/obj/item/blueprints/proc/detect_room(turf/first)
	var/list/turf/found = new
	var/list/turf/pending = list(first)
	while(length(pending))
		if(length(found) + length(pending) > 300)
			return ROOM_ERR_TOOLARGE
		var/turf/T = pending[1] //why byond havent list::pop()?
		pending -= T
		for(var/dir in GLOBL.cardinal)
			var/skip = 0
			for(var/obj/structure/window/W in T)
				if(dir == W.dir || (W.dir in list(NORTHEAST, SOUTHEAST, NORTHWEST, SOUTHWEST)))
					skip = 1
					break
			if(skip)
				continue
			for(var/obj/machinery/door/window/D in T)
				if(dir == D.dir)
					skip = 1
					break
			if(skip)
				continue

			var/turf/NT = get_step(T,dir)
			if(!isturf(NT) || (NT in found) || (NT in pending))
				continue

			switch(check_tile_is_border(NT,dir))
				if(BORDER_NONE)
					pending += NT
				if(BORDER_BETWEEN)
					//do nothing, may be later i'll add 'rejected' list as optimization
				if(BORDER_2NDTILE)
					found += NT //tile included to new area, but we dont seek more
				if(BORDER_SPACE)
					return ROOM_ERR_SPACE
		found += T
	return found