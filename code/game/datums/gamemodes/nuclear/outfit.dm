/decl/hierarchy/outfit/syndicate/nuclear
	name = "Nuclear Operative"

	uniform = /obj/item/clothing/under/syndicate
	suit = /obj/item/clothing/suit/space/rig/syndi
	belt = /obj/item/gun/projectile/automatic/c20r

	head = /obj/item/clothing/head/helmet/space/rig/syndi
	gloves = /obj/item/clothing/gloves/swat
	shoes = /obj/item/clothing/shoes/black

	l_ear = /obj/item/radio/headset/syndicate

	backpack_contents = list(
		/obj/item/storage/box/survival/engineer = 1,
		/obj/item/reagent_holder/pill/cyanide = 1,
		/obj/item/ammo_magazine/a12mm = 2
	)

	id_slot = SLOT_ID_ID_STORE
	id_type = /obj/item/card/id/syndicate

/decl/hierarchy/outfit/syndicate/nuclear/pre_equip(mob/living/carbon/human/user)
	. = ..()
	switch(user.backbag)
		if(2)
			back = /obj/item/storage/backpack
		if(3)
			back = /obj/item/storage/satchel/norm
		if(4)
			back = /obj/item/storage/satchel

/decl/hierarchy/outfit/syndicate/nuclear/post_equip(mob/living/carbon/human/user)
	. = ..()
	var/obj/item/radio/headset/syndicate/radio = user.l_ear
	radio.radio_connection = register_radio(radio, null, FREQUENCY_SYNDICATE, RADIO_CHAT)

	var/species = user.get_species()
	var/obj/item/clothing/suit/space/rig/syndi/new_suit = user.wear_suit
	new_suit.species_restricted = list(species)
	var/obj/item/clothing/head/helmet/space/rig/syndi/new_helmet = user.head
	new_helmet.species_restricted = list(species)

	var/obj/item/implant/explosive/E = new/obj/item/implant/explosive(user)
	E.imp_in = user
	E.implanted = TRUE
	user.update_icons()