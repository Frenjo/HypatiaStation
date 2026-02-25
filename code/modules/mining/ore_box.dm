/**********************Ore box**************************/
/obj/structure/ore_box
	name = "ore box"
	desc = "A heavy box used for storing ore."
	icon = 'icons/obj/mining.dmi'
	icon_state = "orebox0"
	density = TRUE

	var/amt_iron = 0
	var/amt_coal = 0
	var/amt_glass = 0
	var/amt_silver = 0
	var/amt_gold = 0
	var/amt_diamond = 0
	var/amt_plasma = 0
	var/amt_uranium = 0
	var/amt_bananium = 0
	var/amt_strange = 0

/obj/structure/ore_box/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/ore))
		user.drop_item()
		contents.Add(I)
		return TRUE

	if(istype(I, /obj/item/storage))
		var/obj/item/storage/S = I
		S.hide_from(usr)
		for(var/obj/item/ore/O in S)
			S.remove_from_storage(O, src) // This will move the item to this item's contents
		to_chat(user, SPAN_INFO("You empty the satchel into the box."))
		return TRUE

	return ..()

/obj/structure/ore_box/attack_hand(mob/user)
	amt_iron = 0
	amt_coal = 0
	amt_glass = 0
	amt_silver = 0
	amt_gold = 0
	amt_diamond = 0
	amt_plasma = 0
	amt_uranium = 0
	amt_bananium = 0
	amt_strange = 0

	for_no_type_check(var/obj/item/ore/C, src)
		if(istype(C, /obj/item/ore/iron))
			amt_iron++
			continue
		if(istype(C, /obj/item/ore/coal))
			amt_coal++
			continue
		if(istype(C, /obj/item/ore/glass))
			amt_glass++
			continue
		if(istype(C, /obj/item/ore/silver))
			amt_silver++
			continue
		if(istype(C, /obj/item/ore/gold))
			amt_gold++
			continue
		if(istype(C, /obj/item/ore/diamond))
			amt_diamond++
			continue
		if(istype(C, /obj/item/ore/plasma))
			amt_plasma++
			continue
		if(istype(C, /obj/item/ore/uranium))
			amt_uranium++
			continue
		if(istype(C, /obj/item/ore/bananium))
			amt_bananium++
			continue
		if(istype(C, /obj/item/ore/strangerock))
			amt_strange++
			continue

	var/dat = "<b>The contents of the ore box reveal...</b><br>"
	if(amt_iron)
		dat += "Iron ore: [amt_iron]<br>"
	if(amt_coal)
		dat += "Coal: [amt_coal]<br>"
	if(amt_glass)
		dat += "Sand: [amt_glass]<br>"
	if(amt_silver)
		dat += "Silver ore: [amt_silver]<br>"
	if(amt_gold)
		dat += "Gold ore: [amt_gold]<br>"
	if(amt_diamond)
		dat += "Diamond ore: [amt_diamond]<br>"
	if(amt_plasma)
		dat += "Plasma ore: [amt_plasma]<br>"
	if(amt_uranium)
		dat += "Uranium ore: [amt_uranium]<br>"
	if(amt_bananium)
		dat += "Bananium ore: [amt_bananium]<br>"
	if(amt_strange)
		dat += "Strange rocks: [amt_strange]<br>"

	dat += "<br><br><A href='byond://?src=\ref[src];removeall=1'>Empty Box</A>"
	SHOW_BROWSER(user, dat, "window=orebox")

/obj/structure/ore_box/handle_topic(mob/user, datum/topic_input/topic, topic_result)
	. = ..()
	if(!.)
		return FALSE

	user.set_machine(src)
	add_fingerprint(user)
	if(topic.has("removeall"))
		for_no_type_check(var/obj/item/ore/O, src)
			contents.Remove(O)
			O.forceMove(loc)
		to_chat(user, SPAN_INFO("You empty \the [src]."))
	updateUsrDialog()