/*
 * The 'fancy' path is for objects like donut boxes that show how many items are in the storage item on the sprite itself
 * .. Sorry for the shitty path name, I couldnt think of a better one.
 *
 * WARNING: var/icon_type is used for both examine text and sprite name. Please look at the procs below and adjust your sprite names accordingly
 *		TODO: Cigarette boxes should be ported to this standard
 *
 * Contains:
 *		Donut Box
 *		Egg Box
 *		Candle Box
 *		Crayon Box
 *		Cigarette Box
 */
/obj/item/storage/fancy
	name = "donut box"
	icon = 'icons/obj/items/food.dmi'
	icon_state = "donutbox6"

	var/icon_type = "donut"

/obj/item/storage/fancy/New()
	. = ..()
	update_icon()

/obj/item/storage/fancy/update_icon(itemremoved = 0)
	var/total_contents = length(contents) - itemremoved
	icon_state = "[icon_type]box[total_contents]"

/obj/item/storage/fancy/examine()
	set src in oview(1)

	..()
	if(length(contents) <= 0)
		usr << "There are no [icon_type]s left in the box."
	else if(length(contents) == 1)
		usr << "There is one [icon_type] left in the box."
	else
		usr << "There are [length(contents)] [icon_type]s in the box."

/*
 * Donut Box
 */
/obj/item/storage/fancy/donut_box
	icon = 'icons/obj/items/food.dmi'
	icon_state = "donutbox6"
	icon_type = "donut"
	name = "donut box"
	storage_slots = 6
	can_hold = list(/obj/item/reagent_containers/food/snacks/donut)

	starts_with = list(
		/obj/item/reagent_containers/food/snacks/donut/normal = 6
	)

/obj/item/storage/fancy/donut_box/empty
	starts_with = null

/*
 * Egg Box
 */
/obj/item/storage/fancy/egg_box
	icon = 'icons/obj/items/food.dmi'
	icon_state = "eggbox"
	icon_type = "egg"
	name = "egg box"
	storage_slots = 12
	can_hold = list(/obj/item/reagent_containers/food/snacks/egg)

	starts_with = list(
		/obj/item/reagent_containers/food/snacks/egg = 12
	)

/*
 * Candle Box
 */
/obj/item/storage/fancy/candle_box
	name = "candle pack"
	desc = "A pack of red candles."
	icon = 'icons/obj/items/candle.dmi'
	icon_state = "candlebox5"
	icon_type = "candle"
	item_state = "candlebox5"
	storage_slots = 5
	throwforce = 2
	slot_flags = SLOT_BELT

	starts_with = list(
		/obj/item/candle = 5
	)

/*
 * Crayon Box
 */
/obj/item/storage/fancy/crayons
	name = "box of crayons"
	desc = "A box of crayons for all your rune drawing needs."
	icon = 'icons/obj/items/crayons.dmi'
	icon_state = "crayonbox"
	w_class = 2.0
	storage_slots = 6
	icon_type = "crayon"
	can_hold = list(/obj/item/toy/crayon)

	starts_with = list(
		/obj/item/toy/crayon/red,
		/obj/item/toy/crayon/orange,
		/obj/item/toy/crayon/yellow,
		/obj/item/toy/crayon/green,
		/obj/item/toy/crayon/blue,
		/obj/item/toy/crayon/purple
	)

/obj/item/storage/fancy/crayons/update_icon()
	overlays = list() //resets list
	overlays.Add(image('icons/obj/items/crayons.dmi', "crayonbox"))
	for(var/obj/item/toy/crayon/crayon in contents)
		overlays.Add(image('icons/obj/items/crayons.dmi', crayon.colourName))

/obj/item/storage/fancy/crayons/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/toy/crayon))
		switch(W:colourName)
			if("mime")
				usr << "This crayon is too sad to be contained in this box."
				return
			if("rainbow")
				usr << "This crayon is too powerful to be contained in this box."
				return
	..()

////////////
//CIG PACK//
////////////
/obj/item/storage/fancy/cigarettes
	name = "cigarette packet"
	desc = "The most popular brand of Space Cigarettes, sponsors of the Space Olympics."
	icon = 'icons/obj/items/cigarettes.dmi'
	icon_state = "cigpacket"
	item_state = "cigpacket"
	w_class = 1
	throwforce = 2
	slot_flags = SLOT_BELT
	storage_slots = 6
	can_hold = list(/obj/item/clothing/mask/cigarette)
	icon_type = "cigarette"

/obj/item/storage/fancy/cigarettes/New()
	..()
	flags |= NOREACT
	for(var/i = 1 to storage_slots)
		new /obj/item/clothing/mask/cigarette(src)
	create_reagents(15 * storage_slots)//so people can inject cigarettes without opening a packet, now with being able to inject the whole one

/obj/item/storage/fancy/cigarettes/Destroy()
	qdel(reagents)
	return ..()

/obj/item/storage/fancy/cigarettes/update_icon()
	icon_state = "[initial(icon_state)][length(contents)]"
	desc = "There are [length(contents)] cig\s left!"

/obj/item/storage/fancy/cigarettes/remove_from_storage(obj/item/W as obj, atom/new_location)
	var/obj/item/clothing/mask/cigarette/C = W
	if(!istype(C))
		return // what
	reagents.trans_to(C, (reagents.total_volume / length(contents)))
	..()

/obj/item/storage/fancy/cigarettes/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!ismob(M))
		return

	if(M == user && user.zone_sel.selecting == "mouth" && length(contents) && !user.wear_mask)
		var/obj/item/clothing/mask/cigarette/W = new /obj/item/clothing/mask/cigarette(user)
		reagents.trans_to(W, (reagents.total_volume / length(contents)))
		user.equip_to_slot_if_possible(W, SLOT_ID_WEAR_MASK)
		reagents.maximum_volume = 15 * length(contents)
		contents.len--
		to_chat(user, SPAN_NOTICE("You take a cigarette out of the pack."))
		update_icon()
	else
		..()

/obj/item/storage/fancy/cigarettes/dromedaryco
	name = "\improper DromedaryCo packet"
	desc = "A packet of six imported DromedaryCo cancer sticks. A label on the packaging reads, \"Wouldn't a slow death make a change?\""
	icon_state = "Dpacket"
	item_state = "Dpacket"

/*
 * Vial Box
 */
/obj/item/storage/fancy/vials
	icon = 'icons/obj/items/vialbox.dmi'
	icon_state = "vialbox6"
	icon_type = "vial"
	name = "vial storage box"
	storage_slots = 6
	can_hold = list(/obj/item/reagent_containers/glass/beaker/vial)

	starts_with = list(
		/obj/item/reagent_containers/glass/beaker/vial = 6
	)

/obj/item/storage/lockbox/vials
	name = "secure vial storage box"
	desc = "A locked box for keeping things away from children."
	icon = 'icons/obj/items/vialbox.dmi'
	icon_state = "vialbox0"
	item_state = "syringe_kit"
	max_w_class = 3
	can_hold = list(/obj/item/reagent_containers/glass/beaker/vial)
	max_combined_w_class = 14 //The sum of the w_classes of all the items in this storage item.
	storage_slots = 6
	req_access = list(ACCESS_VIROLOGY)

/obj/item/storage/lockbox/vials/update_icon(itemremoved = 0)
	var/total_contents = length(contents) - itemremoved
	icon_state = "vialbox[total_contents]"
	overlays.Cut()
	if(!broken)
		overlays.Add(image(icon, src, "led[locked]"))
		if(locked)
			overlays.Add(image(icon, src, "cover"))
	else
		overlays.Add(image(icon, src, "ledb"))

/obj/item/storage/lockbox/vials/attackby(obj/item/W as obj, mob/user as mob)
	. = ..()
	update_icon()