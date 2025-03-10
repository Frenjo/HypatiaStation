/obj/machinery/washing_machine
	name = "washing machine"
	icon = 'icons/obj/machines/washing_machine.dmi'
	icon_state = "wm_10"
	density = TRUE
	anchored = TRUE
	var/state = 1
	//1 = empty, open door
	//2 = empty, closed door
	//3 = full, open door
	//4 = full, closed door
	//5 = running
	//6 = blood, open door
	//7 = blood, closed door
	//8 = blood, running
	var/panel = 0
	//0 = closed
	//1 = open
	var/hacked = 1 //Bleh, screw hacking, let's have it hacked by default.
	//0 = not hacked
	//1 = hacked
	var/gibs_ready = 0
	var/obj/crayon

/obj/machinery/washing_machine/verb/start()
	set category = PANEL_OBJECT
	set name = "Start Washing"
	set src in oview(1)

	if(!isliving(usr)) //ew ew ew usr, but it's the only way to check.
		return

	if( state != 4 )
		usr << "The washing machine cannot run in this state."
		return

	if( locate(/mob,contents) )
		state = 8
	else
		state = 5
	update_icon()
	sleep(200)
	for(var/atom/A in contents)
		A.clean_blood()

	for(var/obj/item/I in contents)
		I.decontaminate()

	//Tanning!
	for(var/obj/item/stack/sheet/hairlesshide/HH in contents)
		var/obj/item/stack/sheet/wetleather/WL = new(src)
		WL.amount = HH.amount
		qdel(HH)


	if(crayon)
		var/wash_color
		if(istype(crayon,/obj/item/toy/crayon))
			var/obj/item/toy/crayon/CR = crayon
			wash_color = CR.colourName
		else if(istype(crayon,/obj/item/stamp))
			var/obj/item/stamp/ST = crayon
			wash_color = ST.item_color

		if(wash_color)
			var/new_jumpsuit_icon_state = ""
			var/new_jumpsuit_item_state = ""
			var/new_jumpsuit_name = ""
			var/new_glove_icon_state = ""
			var/new_glove_item_state = ""
			var/new_glove_name = ""
			var/new_shoe_icon_state = ""
			var/new_shoe_name = ""
			var/new_sheet_icon_state = ""
			var/new_sheet_name = ""
			var/new_softcap_icon_state = ""
			var/new_softcap_name = ""
			var/new_desc = "The colors are a bit dodgy."
			for(var/T in typesof(/obj/item/clothing/under))
				var/obj/item/clothing/under/J = new T
				//to_world("DEBUG: [color] == [J.color]")
				if(wash_color == J.item_color)
					new_jumpsuit_icon_state = J.icon_state
					new_jumpsuit_item_state = J.item_state
					new_jumpsuit_name = J.name
					qdel(J)
					//to_world("DEBUG: YUP! [new_icon_state] and [new_item_state]")
					break
				qdel(J)
			for(var/T in typesof(/obj/item/clothing/gloves))
				var/obj/item/clothing/gloves/G = new T
				//to_world("DEBUG: [color] == [J.color]")
				if(wash_color == G.item_color)
					new_glove_icon_state = G.icon_state
					new_glove_item_state = G.item_state
					new_glove_name = G.name
					qdel(G)
					//to_world("DEBUG: YUP! [new_icon_state] and [new_item_state]")
					break
				qdel(G)
			for(var/T in typesof(/obj/item/clothing/shoes))
				var/obj/item/clothing/shoes/S = new T
				//to_world("DEBUG: [color] == [J.color]")
				if(wash_color == S.item_color)
					new_shoe_icon_state = S.icon_state
					new_shoe_name = S.name
					qdel(S)
					//to_world("DEBUG: YUP! [new_icon_state] and [new_item_state]")
					break
				qdel(S)
			for(var/T in typesof(/obj/item/bedsheet))
				var/obj/item/bedsheet/B = new T
				//to_world("DEBUG: [color] == [J.color]")
				if(wash_color == B.item_color)
					new_sheet_icon_state = B.icon_state
					new_sheet_name = B.name
					qdel(B)
					//to_world("DEBUG: YUP! [new_icon_state] and [new_item_state]")
					break
				qdel(B)
			for(var/T in typesof(/obj/item/clothing/head/soft))
				var/obj/item/clothing/head/soft/H = new T
				//to_world("DEBUG: [color] == [J.color]")
				if(wash_color == H.item_color)
					new_softcap_icon_state = H.icon_state
					new_softcap_name = H.name
					qdel(H)
					//to_world("DEBUG: YUP! [new_icon_state] and [new_item_state]")
					break
				qdel(H)
			if(new_jumpsuit_icon_state && new_jumpsuit_item_state && new_jumpsuit_name)
				for(var/obj/item/clothing/under/J in contents)
					//to_world("DEBUG: YUP! FOUND IT!")
					J.item_state = new_jumpsuit_item_state
					J.icon_state = new_jumpsuit_icon_state
					J.item_color = wash_color
					J.name = new_jumpsuit_name
					J.desc = new_desc
			if(new_glove_icon_state && new_glove_item_state && new_glove_name)
				for(var/obj/item/clothing/gloves/G in contents)
					//to_world("DEBUG: YUP! FOUND IT!")
					G.item_state = new_glove_item_state
					G.icon_state = new_glove_icon_state
					G.item_color = wash_color
					G.name = new_glove_name
					G.desc = new_desc
			if(new_shoe_icon_state && new_shoe_name)
				for(var/obj/item/clothing/shoes/S in contents)
					//to_world("DEBUG: YUP! FOUND IT!")
					if (S.chained == 1)
						S.chained = 0
						S.slowdown = SHOES_SLOWDOWN
						new /obj/item/handcuffs( src )
					S.icon_state = new_shoe_icon_state
					S.item_color = wash_color
					S.name = new_shoe_name
					S.desc = new_desc
			if(new_sheet_icon_state && new_sheet_name)
				for(var/obj/item/bedsheet/B in contents)
					//to_world("DEBUG: YUP! FOUND IT!")
					B.icon_state = new_sheet_icon_state
					B.item_color = wash_color
					B.name = new_sheet_name
					B.desc = new_desc
			if(new_softcap_icon_state && new_softcap_name)
				for(var/obj/item/clothing/head/soft/H in contents)
					//to_world("DEBUG: YUP! FOUND IT!")
					H.icon_state = new_softcap_icon_state
					H.item_color = wash_color
					H.name = new_softcap_name
					H.desc = new_desc
		qdel(crayon)
		crayon = null


	if( locate(/mob,contents) )
		state = 7
		gibs_ready = 1
	else
		state = 4
	update_icon()

/obj/machinery/washing_machine/verb/climb_out()
	set category = PANEL_OBJECT
	set name = "Climb out"
	set src in usr.loc

	sleep(20)
	if(state in list(1,3,6) )
		usr.forceMove(loc)


/obj/machinery/washing_machine/update_icon()
	icon_state = "wm_[state][panel]"

/obj/machinery/washing_machine/attackby(obj/item/W, mob/user)
	/*if(isscrewdriver(W))
		panel = !panel
		user << "\blue you [panel ? "open" : "close"] the [src]'s maintenance panel"*/
	if(istype(W, /obj/item/toy/crayon) ||istype(W, /obj/item/stamp))
		if(state in list(1, 3, 6))
			if(!crayon)
				user.drop_item()
				crayon = W
				crayon.forceMove(src)
			else
				..()
		else
			..()
	else if(istype(W,/obj/item/grab))
		if((state == 1) && hacked)
			var/obj/item/grab/G = W
			if(ishuman(G.assailant) && iscorgi(G.affecting))
				G.affecting.forceMove(src)
				qdel(G)
				state = 3
		else
			..()
	else if(istype(W, /obj/item/stack/sheet/hairlesshide) || \
		istype(W, /obj/item/clothing/under) || \
		istype(W, /obj/item/clothing/mask) || \
		istype(W, /obj/item/clothing/head) || \
		istype(W, /obj/item/clothing/gloves) || \
		istype(W, /obj/item/clothing/shoes) || \
		istype(W, /obj/item/clothing/suit) || \
		istype(W, /obj/item/bedsheet))

		//YES, it's hardcoded... saves a var/can_be_washed for every single clothing item.
		if(istype(W, /obj/item/clothing/suit/space))
			user << "This item does not fit."
			return
		if(istype(W, /obj/item/clothing/suit/syndicatefake))
			user << "This item does not fit."
			return
//		if ( istype(W,/obj/item/clothing/suit/powered ) )
//			user << "This item does not fit."
//			return
		if(istype(W, /obj/item/clothing/suit/cyborg_suit))
			user << "This item does not fit."
			return
		if(istype(W, /obj/item/clothing/suit/bomb_suit))
			user << "This item does not fit."
			return
		if(istype(W, /obj/item/clothing/suit/armor))
			user << "This item does not fit."
			return
		if(istype(W, /obj/item/clothing/suit/armor))
			user << "This item does not fit."
			return
		if(istype(W, /obj/item/clothing/mask/gas))
			user << "This item does not fit."
			return
		if(istype(W, /obj/item/clothing/mask/cigarette))
			user << "This item does not fit."
			return
		if(istype(W, /obj/item/clothing/head/syndicatefake))
			user << "This item does not fit."
			return
//		if ( istype(W,/obj/item/clothing/head/powered ) )
//			user << "This item does not fit."
//			return
		if(istype(W, /obj/item/clothing/head/helmet))
			user << "This item does not fit."
			return

		if(length(contents) < 5)
			if(state in list(1, 3))
				user.drop_item()
				W.forceMove(src)
				state = 3
			else
				user << "\blue You can't put the item in right now."
		else
			user << "\blue The washing machine is full."
	else
		..()
	update_icon()

/obj/machinery/washing_machine/attack_hand(mob/user)
	switch(state)
		if(1)
			state = 2
		if(2)
			state = 1
			for_no_type_check(var/atom/movable/mover, src)
				mover.forceMove(loc)
		if(3)
			state = 4
		if(4)
			state = 3
			for_no_type_check(var/atom/movable/mover, src)
				mover.forceMove(loc)
			crayon = null
			state = 1
		if(5)
			user << "\red The [src] is busy."
		if(6)
			state = 7
		if(7)
			if(gibs_ready)
				gibs_ready = 0
				if(locate(/mob, contents))
					var/mob/living/L = locate(/mob/living, contents)
					L.gib()
			for_no_type_check(var/atom/movable/mover, src)
				mover.forceMove(loc)
			crayon = null
			state = 1


	update_icon()