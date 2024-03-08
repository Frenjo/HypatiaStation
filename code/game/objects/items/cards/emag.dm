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
	origin_tech = list(RESEARCH_TECH_MAGNETS = 2, RESEARCH_TECH_SYNDICATE = 2)

	var/uses = 10
	// List of devices that cost a use to emag.
	var/static/list/devices = list(
		/obj/item/robot_parts,
		/obj/item/storage/lockbox,
		/obj/item/storage/secure,
		/obj/item/circuitboard,
		/obj/item/eftpos,
		/obj/item/lightreplacer,
		/obj/item/taperecorder,
		/obj/item/hailer,
		/obj/item/megaphone,
		/obj/item/clothing/tie/holobadge,
		/obj/structure/closet/crate/secure,
		/obj/structure/closet/secure,
		/obj/machinery/librarycomp,
		/obj/machinery/computer,
		/obj/machinery/power,
		/obj/machinery/suspension_gen,
		/obj/machinery/shield_capacitor,
		/obj/machinery/shield_gen,
		/obj/machinery/zero_point_emitter,
		/obj/machinery/clonepod,
		/obj/machinery/deployable,
		/obj/machinery/door_control,
		/obj/machinery/porta_turret,
		/obj/machinery/shieldgen,
		/obj/machinery/turretid,
		/obj/machinery/vending,
		/obj/machinery/bot,
		/obj/machinery/door,
		/obj/machinery/telecoms,
		/obj/machinery/mecha_part_fabricator
	)

/obj/item/card/emag/afterattack(obj/item/O as obj, mob/user as mob)
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
	origin_tech = list(RESEARCH_TECH_MAGNETS = 2, RESEARCH_TECH_SYNDICATE = 2)