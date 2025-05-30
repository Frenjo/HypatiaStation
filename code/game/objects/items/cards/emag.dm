/*
 * Cryptographic Sequencer
 *
 * More commonly known as an emag or emag card.
 */
/obj/item/card/emag
	name = "cryptographic sequencer"
	desc = "It's a card with a magnetic strip attached to some circuitry."
	icon_state = "emag"
	item_state = "card-id"

	origin_tech = alist(/decl/tech/magnets = 2, /decl/tech/syndicate = 2)
	item_flags = ITEM_FLAG_NO_BLUDGEON

	var/uses = 10
	// List of devices that cost a use to emag.
	// TODO: Gradually convert these to use attack_emag and remove them from the list as they're converted.
	var/static/list/devices = list(
		/obj/item/storage/lockbox,
		/obj/item/storage/secure,
		/obj/item/eftpos,
		/obj/structure/closet/crate/secure,
		/obj/structure/closet/secure,
		/obj/machinery/suspension_gen
	)

// This is the new way.
/obj/item/card/emag/handle_attack(atom/thing, mob/source)
	. = thing.attack_emag(src, source, uses)
	if(!.) // If we didn't succesfully emag the thing, then pass down the attack chain.
		return ..(thing, source)

	uses--
	if(uses < 1)
		source.visible_message(SPAN_WARNING("[src] fizzles and sparks - it seems it's been used once too often, and is now broken."))
		source.drop_item()
		var/obj/item/card/emag_broken/junk = new /obj/item/card/emag_broken(source.loc)
		junk.add_fingerprint(source)
		qdel(src)

// This needs to be replaced with the new system.
/obj/item/card/emag/afterattack(obj/item/O, mob/user)
	for(var/type in devices)
		if(istype(O, type))
			uses--
			break

	if(uses < 1)
		user.visible_message("[src] fizzles and sparks - it seems it's been used once too often, and is now broken.")
		user.drop_item()
		var/obj/item/card/emag_broken/junk = new(user.loc)
		junk.add_fingerprint(user)
		qdel(src)
		return

	. = ..()

// Broken
/obj/item/card/emag_broken
	name = "broken cryptographic sequencer"
	desc = "It's a card with a magnetic strip attached to some circuitry. It looks too busted to be used for anything but salvage."
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = alist(/decl/tech/magnets = 2, /decl/tech/syndicate = 2)