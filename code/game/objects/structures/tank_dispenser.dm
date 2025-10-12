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

/obj/structure/dispenser/initialise()
	. = ..()
	update_icon()

/obj/structure/dispenser/update_icon()
	cut_overlays()
	switch(oxygentanks)
		if(1 to 3)
			add_overlay("oxygen-[oxygentanks]")
		if(4 to INFINITY)
			add_overlay("oxygen-4")
	switch(plasmatanks)
		if(1 to 4)
			add_overlay("plasma-[plasmatanks]")
		if(5 to INFINITY)
			add_overlay("plasma-5")

/obj/structure/dispenser/attack_hand(mob/user)
	user.set_machine(src)
	var/dat = "<html><body>[src]<br><br>"
	dat += "Oxygen tanks: [oxygentanks] - [oxygentanks ? "<A href='byond://?src=\ref[src];oxygen=1'>Dispense</A>" : "empty"]<br>"
	dat += "Plasma tanks: [plasmatanks] - [plasmatanks ? "<A href='byond://?src=\ref[src];plasma=1'>Dispense</A>" : "empty"]</body></html>"
	SHOW_BROWSER(user, dat, "window=dispenser")
	onclose(user, "dispenser")
	return

/obj/structure/dispenser/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/tank/oxygen) || istype(I, /obj/item/tank/air) || istype(I, /obj/item/tank/anesthetic))
		if(oxygentanks < 10)
			user.drop_item()
			I.forceMove(src)
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
			I.forceMove(src)
			platanks.Add(I)
			plasmatanks++
			to_chat(user, SPAN_NOTICE("You put [I] in [src]."))
		else
			to_chat(user, SPAN_NOTICE("[src] is full."))
		updateUsrDialog()
		return
	if(iswrench(I))
		if(anchored)
			to_chat(user, SPAN_NOTICE("You lean down and unwrench [src]."))
			anchored = FALSE
		else
			to_chat(user, SPAN_NOTICE("You wrench [src] into place."))
			anchored = TRUE
		return

/obj/structure/dispenser/handle_topic(mob/user, datum/topic_input/topic, topic_result)
	. = ..()
	if(!.)
		return FALSE
	if(user.stat || user.restrained())
		return FALSE
	if(!Adjacent(user))
		CLOSE_BROWSER(user, "window=dispenser")
		return FALSE

	user.set_machine(src)
	add_fingerprint(user)
	if(topic.has("oxygen"))
		if(oxygentanks > 0)
			var/obj/item/tank/oxygen/O
			if(length(oxytanks) == oxygentanks)
				O = oxytanks[1]
				oxytanks.Remove(O)
			else
				O = new /obj/item/tank/oxygen(loc)
			O.forceMove(loc)
			to_chat(user, SPAN_NOTICE("You take [O] out of [src]."))
			oxygentanks--
			update_icon()

	if(topic.has("plasma"))
		if(plasmatanks > 0)
			var/obj/item/tank/plasma/P
			if(length(platanks) == plasmatanks)
				P = platanks[1]
				platanks.Remove(P)
			else
				P = new /obj/item/tank/plasma(loc)
			P.forceMove(loc)
			to_chat(user, SPAN_NOTICE("You take [P] out of [src]."))
			plasmatanks--
			update_icon()

	updateUsrDialog()