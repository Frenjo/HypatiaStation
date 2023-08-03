/*
 *	The common cardboard box and everything derived from it.
 *	Basically everything except the original is a kit (starts full).
 *
 *	Contained in boxes.dm:
 *		Empty box,
 *		Latex glove and sterile mask boxes,
 *		Syringe, beaker, dna injector boxes,
 *		Blanks, flashbangs, and EMP grenade boxes,
 *		Tracking, chemical and death alarm implant boxes,
 *		Prescription glasses and drinking glass boxes,
 *		Condiment bottle and silly cup boxes,
 *		Donkpocket and monkeycube boxes,
 *		ID and security PDA cart boxes,
 *		Handcuff, mousetrap, and pillbottle boxes,
 *		Snap-pops and matchboxes,
 *		Replacement light boxes,
 *		Circuit boxes.
 *
 *		For syndicate call-ins see uplink_kits.dm.
 *		For starter boxes see survival_kits.dm.
 */
/obj/item/storage/box
	name = "box"
	desc = "It's just an ordinary box."
	icon = 'icons/obj/storage/box.dmi'
	icon_state = "box"
	item_state = "syringe_kit"
	foldable = /obj/item/stack/sheet/cardboard	//BubbleWrap

	// An associative list of typepaths of things the item will spawn with.
	// If an entry isn't associative, the value is assumed to be one.
	var/list/starts_with = null

/obj/item/storage/box/New()
	SHOULD_CALL_PARENT(TRUE)

	. = ..()
	// Spawns the items in the starts_with list.
	if(isnotnull(starts_with))
		for(var/type in starts_with)
			// If the entry isn't associative, then assume we just want a single one.
			var/count = starts_with[type]
			if(isnull(count))
				new type(src)
			else
				for(var/i = 0; i < count; i++)
					new type(src)