
/**********************Ore box**************************/
/obj/structure/ore_box
	name = "ore box"
	desc = "A heavy box used for storing ore."
	icon = 'icons/obj/mining.dmi'
	icon_state = "orebox0"
	density = TRUE

	var/amt_gold = 0
	var/amt_silver = 0
	var/amt_diamond = 0
	var/amt_glass = 0
	var/amt_iron = 0
	var/amt_phoron = 0
	var/amt_uranium = 0
	var/amt_bananium = 0
	var/amt_strange = 0
	var/last_update = 0

/obj/structure/ore_box/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/ore))
		contents += W
	if(istype(W, /obj/item/storage))
		var/obj/item/storage/S = W
		S.hide_from(usr)
		for(var/obj/item/ore/O in S.contents)
			S.remove_from_storage(O, src) // This will move the item to this item's contents
		to_chat(user, SPAN_INFO("You empty the satchel into the box."))

/obj/structure/ore_box/attack_hand(obj, mob/user)
	var/amt_gold = 0
	var/amt_silver = 0
	var/amt_diamond = 0
	var/amt_glass = 0
	var/amt_iron = 0
	var/amt_plasma = 0
	var/amt_uranium = 0
	var/amt_clown = 0
	var/amt_strange = 0

	for(var/obj/item/ore/C in contents)
		if(istype(C, /obj/item/ore/diamond))
			amt_diamond++
		if(istype(C, /obj/item/ore/glass))
			amt_glass++
		if(istype(C, /obj/item/ore/plasma))
			amt_plasma++
		if(istype(C, /obj/item/ore/iron))
			amt_iron++
		if(istype(C, /obj/item/ore/silver))
			amt_silver++
		if(istype(C, /obj/item/ore/gold))
			amt_gold++
		if(istype(C, /obj/item/ore/uranium))
			amt_uranium++
		if(istype(C, /obj/item/ore/bananium))
			amt_bananium++
		if(istype(C, /obj/item/ore/strangerock))
			amt_strange++

	var/dat = "<b>The contents of the ore box reveal...</b><br>"
	if(amt_gold)
		dat += "Gold ore: [amt_gold]<br>"
	if(amt_silver)
		dat += "Silver ore: [amt_silver]<br>"
	if(amt_iron)
		dat += "Metal ore: [amt_iron]<br>"
	if(amt_glass)
		dat += "Sand: [amt_glass]<br>"
	if(amt_diamond)
		dat += "Diamond ore: [amt_diamond]<br>"
	if(amt_plasma)
		dat += "Plasma ore: [amt_plasma]<br>"
	if(amt_uranium)
		dat += "Uranium ore: [amt_uranium]<br>"
	if(amt_clown)
		dat += "Bananium ore: [amt_bananium]<br>"
	if(amt_strange)
		dat += "Strange rocks: [amt_strange]<br>"

	dat += "<br><br><A href='byond://?src=\ref[src];removeall=1'>Empty box</A>"
	user << browse("[dat]", "window=orebox")

/obj/structure/ore_box/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)
	if(href_list["removeall"])
		for(var/obj/item/ore/O in contents)
			contents -= O
			O.forceMove(loc)
		to_chat(usr, SPAN_INFO("You empty the box."))
	updateUsrDialog()