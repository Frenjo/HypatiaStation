/obj/structure/dispenser
	name = "tank storage unit"
	desc = "A simple yet bulky storage device for gas tanks. Has room for up to ten oxygen tanks, and ten plasma tanks."
	icon = 'icons/obj/objects.dmi'
	icon_state = "dispenser"
	density = TRUE
	anchored = TRUE
	var/oxygentanks = 10
	var/plasmatanks = 10
	var/list/oxytanks = list()	//sorry for the similar var names
	var/list/platanks = list()

/obj/structure/dispenser/oxygen
	plasmatanks = 0

/obj/structure/dispenser/plasma
	oxygentanks = 0

/obj/structure/dispenser/New()
	. = ..()
	update_icon()

/obj/structure/dispenser/update_icon()
	overlays.Cut()
	switch(oxygentanks)
		if(1 to 3)
			overlays += "oxygen-[oxygentanks]"
		if(4 to INFINITY)
			overlays += "oxygen-4"
	switch(plasmatanks)
		if(1 to 4)
			overlays += "plasma-[plasmatanks]"
		if(5 to INFINITY)
			overlays += "plasma-5"

/obj/structure/dispenser/attack_hand(mob/user as mob)
	user.set_machine(src)
	var/dat = "[src]<br><br>"
	dat += "Oxygen tanks: [oxygentanks] - [oxygentanks ? "<A href='byond://?src=\ref[src];oxygen=1'>Dispense</A>" : "empty"]<br>"
	dat += "Plasma tanks: [plasmatanks] - [plasmatanks ? "<A href='byond://?src=\ref[src];plasma=1'>Dispense</A>" : "empty"]"
	user << browse(dat, "window=dispenser")
	onclose(user, "dispenser")
	return

/obj/structure/dispenser/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/tank/oxygen) || istype(I, /obj/item/tank/air) || istype(I, /obj/item/tank/anesthetic))
		if(oxygentanks < 10)
			user.drop_item()
			I.loc = src
			oxytanks.Add(I)
			oxygentanks++
			to_chat(user, SPAN_NOTICE("You put [I] in [src]."))
		else
			to_chat(user, SPAN_NOTICE("[src] is full."))
		updateUsrDialog()
		return
	if(istype(I, /obj/item/tank/plasma))
		if(plasmatanks < 10)
			user.drop_item()
			I.loc = src
			platanks.Add(I)
			plasmatanks++
			to_chat(user, SPAN_NOTICE("You put [I] in [src]."))
		else
			to_chat(user, SPAN_NOTICE("[src] is full."))
		updateUsrDialog()
		return
	if(istype(I, /obj/item/wrench))
		if(anchored)
			to_chat(user, SPAN_NOTICE("You lean down and unwrench [src]."))
			anchored = FALSE
		else
			to_chat(user, SPAN_NOTICE("You wrench [src] into place."))
			anchored = TRUE
		return

/obj/structure/dispenser/Topic(href, href_list)
	if(usr.stat || usr.restrained())
		return
	if(Adjacent(usr))
		usr.set_machine(src)
		if(href_list["oxygen"])
			if(oxygentanks > 0)
				var/obj/item/tank/oxygen/O
				if(length(oxytanks) == oxygentanks)
					O = oxytanks[1]
					oxytanks.Remove(O)
				else
					O = new /obj/item/tank/oxygen(loc)
				O.loc = loc
				to_chat(usr, SPAN_NOTICE("You take [O] out of [src]."))
				oxygentanks--
				update_icon()
		if(href_list["plasma"])
			if(plasmatanks > 0)
				var/obj/item/tank/plasma/P
				if(length(platanks) == plasmatanks)
					P = platanks[1]
					platanks.Remove(P)
				else
					P = new /obj/item/tank/plasma(loc)
				P.loc = loc
				to_chat(usr, SPAN_NOTICE("You take [P] out of [src]."))
				plasmatanks--
				update_icon()
		add_fingerprint(usr)
		updateUsrDialog()
	else
		usr << browse(null, "window=dispenser")
		return
	return