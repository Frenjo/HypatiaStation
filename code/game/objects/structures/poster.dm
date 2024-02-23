//############################## THE ACTUAL DECALS ###########################
/obj/structure/sign/poster
	name = "poster"
	desc = "A large piece of space-resistant printed paper. "
	icon = 'icons/obj/contraband.dmi'
	anchored = TRUE

	var/serial_number	//Will hold the value of src.loc if nobody initialises it
	var/ruined = FALSE

/obj/structure/sign/poster/New(serial)
	serial_number = serial

	if(serial_number == loc)
		serial_number = rand(1, length(GLOBL.all_poster_designs)) // This is for the mappers that want individual posters without having to use rolled posters.

	var/decl/poster_design/design = GLOBL.all_poster_designs[serial_number]
	name += " - [design.name]"
	desc += " [design.desc]"
	icon_state = design.icon_state // poster[serial_number]
	. = ..()

/obj/structure/sign/poster/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/wirecutters))
		playsound(loc, 'sound/items/Wirecutter.ogg', 100, 1)
		if(ruined)
			to_chat(user, SPAN_NOTICE("You remove the remnants of the poster."))
			qdel(src)
		else
			to_chat(usr, SPAN_NOTICE("You carefully remove the poster from the wall."))
			roll_and_drop(user.loc)
		return

/obj/structure/sign/poster/attack_hand(mob/user as mob)
	if(ruined)
		return
	var/temp_loc = user.loc
	switch(alert("Do I want to rip the poster from the wall?", "You think...", "Yes", "No"))
		if("Yes")
			if(user.loc != temp_loc)
				return
			visible_message(SPAN_WARNING("[user] rips [src] in a single, decisive motion!"))
			playsound(src, 'sound/items/poster_ripped.ogg', 100, 1)
			ruined = TRUE
			icon_state = "poster_ripped"
			name = "ripped poster"
			desc = "You can't make out anything from the poster's original print. It's ruined."
			add_fingerprint(user)
		if("No")
			return

/obj/structure/sign/poster/proc/roll_and_drop(turf/newloc)
	var/obj/item/contraband/poster/P = new(src, serial_number)
	P.loc = newloc
	src.loc = P
	qdel(src)


//separated to reduce code duplication. Moved here for ease of reference and to unclutter r_wall/attackby()
/turf/simulated/wall/proc/place_poster(obj/item/contraband/poster/P, mob/user)
	if(!istype(src, /turf/simulated/wall))
		to_chat(user, SPAN_WARNING("You can't place this here!"))
		return

	var/stuff_on_wall = 0
	for(var/obj/O in contents) //Let's see if it already has a poster on it or too much stuff
		if(istype(O, /obj/structure/sign/poster))
			to_chat(user, SPAN_NOTICE("The wall is far too cluttered to place a poster!"))
			return
		stuff_on_wall++
		if(stuff_on_wall == 3)
			to_chat(user, SPAN_NOTICE("The wall is far too cluttered to place a poster!"))
			return

	to_chat(user, SPAN_NOTICE("You start placing the poster on the wall...")) //Looks like it's uncluttered enough. Place the poster.

	//declaring D because otherwise if P gets 'deconstructed' we lose our reference to P.resulting_poster
	var/obj/structure/sign/poster/D = new(P.serial_number)

	var/temp_loc = user.loc
	flick("poster_being_set",D)
	D.loc = src
	qdel(P)	//delete it now to cut down on sanity checks afterwards. Agouri's code supports rerolling it anyway
	playsound(D.loc, 'sound/items/poster_being_created.ogg', 100, 1)

	sleep(17)
	if(!D)
		return

	if(istype(src, /turf/simulated/wall) && user && user.loc == temp_loc)//Let's check if everything is still there
		to_chat(user, SPAN_NOTICE("You place the poster!"))
	else
		D.roll_and_drop(temp_loc)
	return