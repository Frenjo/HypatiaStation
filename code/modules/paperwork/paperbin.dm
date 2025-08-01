/obj/item/paper_bin
	name = "paper bin"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper_bin1"
	item_state = "sheet-metal"
	throwforce = 1
	w_class = 3
	throw_speed = 3
	throw_range = 7
	pressure_resistance = 10
	var/amount = 30					//How much paper is in the bin.
	var/list/papers = list()	//List of papers put in the bin for reference.


/obj/item/paper_bin/MouseDrop(mob/user)
	if((user == usr && (!(usr.restrained()) && (!(usr.stat) && (usr.contents.Find(src) || in_range(src, usr))))))
		if(!isslime(usr) && !issimple(usr))
			if(!usr.get_active_hand())		//if active hand is empty
				attack_hand(usr, 1, 1)

	return


/obj/item/paper_bin/attack_paw(mob/user)
	return attack_hand(user)


/obj/item/paper_bin/attack_hand(mob/user)
	if(hasorgans(user))
		var/datum/organ/external/temp = user:organs_by_name["r_hand"]
		if(user.hand)
			temp = user:organs_by_name["l_hand"]
		if(temp && !temp.is_usable())
			to_chat(user, SPAN_NOTICE("You try to move your [temp.display_name], but cannot!"))
			return
	if(amount >= 1)
		amount--
		if(amount == 0)
			update_icon()

		var/obj/item/paper/P
		if(length(papers))	//If there's any custom paper on the stack, use that instead of creating a new paper.
			P = papers[length(papers)]
			papers.Remove(P)
		else
			P = new /obj/item/paper
			if(CONFIG_GET(/decl/configuration_entry/holiday_name) == "April Fool's Day")
				if(prob(30))
					P.info = "<font face=\"[P.crayonfont]\" color=\"red\"><b>HONK HONK HONK HONK HONK HONK HONK<br>HOOOOOOOOOOOOOOOOOOOOOONK<br>APRIL FOOLS</b></font>"
					P.rigged = 1
					P.updateinfolinks()

		P.forceMove(user.loc)
		user.put_in_hands(P)
		to_chat(user, SPAN_NOTICE("You take [P] out of the [src]."))
	else
		to_chat(user, SPAN_NOTICE("[src] is empty!"))

	add_fingerprint(user)
	return


/obj/item/paper_bin/attackby(obj/item/paper/i, mob/user)
	if(!istype(i))
		return

	user.drop_item()
	i.forceMove(src)
	to_chat(user, SPAN_NOTICE("You put [i] in [src]."))
	papers.Add(i)
	amount++

/obj/item/paper_bin/get_examine_text(mob/user)
	. = ..()
	if(!in_range(src, user))
		return

	if(amount)
		. += SPAN_NOTICE("There " + (amount > 1 ? "are [amount] papers" : "is one paper") + " in the bin.")
	else
		. += SPAN_NOTICE("There are no papers in the bin.")

/obj/item/paper_bin/update_icon()
	if(amount < 1)
		icon_state = "paper_bin0"
	else
		icon_state = "paper_bin1"
