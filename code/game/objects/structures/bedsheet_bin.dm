/*
CONTAINS:
BEDSHEETS
LINEN BINS
*/
/obj/item/bedsheet
	name = "bedsheet"
	desc = "A surprisingly soft linen bedsheet."
	icon = 'icons/obj/items/bedsheets.dmi'
	icon_state = "white"
	item_state = "bedsheet"
	layer = 4.0
	throwforce = 1
	throw_speed = 1
	throw_range = 2
	w_class = 1.0
	item_color = "white"

/obj/item/bedsheet/attack_self(mob/user)
	user.drop_item()
	if(layer == initial(layer))
		layer = 5
	else
		reset_plane_and_layer()
	add_fingerprint(user)
	return

/obj/item/bedsheet/blue
	icon_state = "blue"
	item_color = "blue"

/obj/item/bedsheet/green
	icon_state = "green"
	item_color = "green"

/obj/item/bedsheet/orange
	icon_state = "orange"
	item_color = "orange"

/obj/item/bedsheet/purple
	icon_state = "purple"
	item_color = "purple"

/obj/item/bedsheet/rainbow
	icon_state = "rainbow"
	item_color = "rainbow"

/obj/item/bedsheet/red
	icon_state = "red"
	item_color = "red"

/obj/item/bedsheet/yellow
	icon_state = "yellow"
	item_color = "yellow"

/obj/item/bedsheet/mime
	icon_state = "mime"
	item_color = "mime"

/obj/item/bedsheet/clown
	icon_state = "clown"
	item_color = "clown"

/obj/item/bedsheet/captain
	icon_state = "captain"
	item_color = "captain"

/obj/item/bedsheet/rd
	icon_state = "rd"
	item_color = "director"

/obj/item/bedsheet/medical
	icon_state = "medical"
	item_color = "medical"

/obj/item/bedsheet/hos
	icon_state = "hos"
	item_color = "hosred"

/obj/item/bedsheet/hop
	icon_state = "hop"
	item_color = "hop"

/obj/item/bedsheet/ce
	icon_state = "ce"
	item_color = "chief"

/obj/item/bedsheet/brown
	icon_state = "brown"
	item_color = "brown"

#define STARTING_LINEN_AMOUNT 20
/obj/structure/bedsheetbin
	name = "linen bin"
	desc = "A linen bin. It looks rather cosy."
	icon_state = "linenbin-full"
	anchored = TRUE

	var/amount = STARTING_LINEN_AMOUNT
	var/list/sheets = list()
	var/obj/item/hidden = null

/obj/structure/bedsheetbin/get_examine_text()
	. = ..()
	if(amount < 1)
		. += "There are no bed sheets in the bin."
		return
	if(amount == 1)
		. += "There is one bed sheet in the bin."
		return
	. += "There are [amount] bed sheets in the bin."

/obj/structure/bedsheetbin/update_icon()
	switch(amount)
		if(0)
			icon_state = "linenbin-empty"
		if(1 to (STARTING_LINEN_AMOUNT / 2))
			icon_state = "linenbin-half"
		else
			icon_state = "linenbin-full"
#undef STARTING_LINEN_AMOUNT

/obj/structure/bedsheetbin/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/bedsheet))
		user.drop_item()
		I.forceMove(src)
		sheets.Add(I)
		amount++
		to_chat(user, SPAN_NOTICE("You put [I] in [src]."))
	else if(amount && !hidden && I.w_class < 4)	//make sure there's sheets to hide it among, make sure nothing else is hidden in there.
		user.drop_item()
		I.forceMove(src)
		hidden = I
		to_chat(user, SPAN_NOTICE("You hide [I] among the sheets."))

/obj/structure/bedsheetbin/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/bedsheetbin/attack_hand(mob/user)
	if(amount >= 1)
		amount--

		var/obj/item/bedsheet/B
		if(length(sheets))
			B = sheets[length(sheets)]
			sheets.Remove(B)

		else
			B = new /obj/item/bedsheet(loc)

		B.forceMove(user.loc)
		user.put_in_hands(B)
		to_chat(user, SPAN_NOTICE("You take [B] out of [src]."))

		if(hidden)
			hidden.forceMove(user.loc)
			to_chat(user, SPAN_NOTICE("[hidden] falls out of [B]!"))
			hidden = null

	add_fingerprint(user)

/obj/structure/bedsheetbin/attack_tk(mob/user)
	if(amount >= 1)
		amount--

		var/obj/item/bedsheet/B
		if(length(sheets))
			B = sheets[length(sheets)]
			sheets.Remove(B)

		else
			B = new /obj/item/bedsheet(loc)

		B.forceMove(loc)
		to_chat(user, SPAN_NOTICE("You telekinetically remove [B] from [src]."))
		update_icon()

		if(hidden)
			hidden.forceMove(loc)
			hidden = null

	add_fingerprint(user)