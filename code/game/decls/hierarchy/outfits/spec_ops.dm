/*
 * Emergency Response Team
 */
/decl/hierarchy/outfit/ert
	name = "Emergency Response Team"

	uniform = /obj/item/clothing/under/rank/centcom_officer
	back = /obj/item/storage/satchel
	belt = /obj/item/gun/energy/gun

	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/swat
	shoes = /obj/item/clothing/shoes/swat

	l_ear = /obj/item/radio/headset/ert

	id_slot = SLOT_ID_WEAR_ID
	id_type = /obj/item/card/id/centcom/station
	id_pda_assignment = "Emergency Response Team"

/decl/hierarchy/outfit/special_ops_officer
	name = "Special Ops Officer"

	uniform = /obj/item/clothing/under/syndicate/combat
	suit = /obj/item/clothing/suit/armor/swat/officer
	back = /obj/item/storage/satchel
	belt = /obj/item/gun/energy/pulse_rifle/M1911

	head = /obj/item/clothing/head/helmet/space/deathsquad/beret
	glasses = /obj/item/clothing/glasses/thermal/eyepatch
	mask = /obj/item/clothing/mask/cigarette/cigar/havana
	gloves = /obj/item/clothing/gloves/combat
	shoes = /obj/item/clothing/shoes/combat

	l_ear = /obj/item/radio/headset/heads/captain

	r_pocket = /obj/item/lighter/zippo

	id_slot = SLOT_ID_WEAR_ID
	id_type = /obj/item/card/id/centcom/station
	id_pda_assignment = "Special Operations Officer"

/*
 * Death Commando Common
 */
/decl/hierarchy/outfit/death_commando
	suit = /obj/item/clothing/suit/armor/swat
	back = /obj/item/storage/backpack/security
	belt = /obj/item/gun/projectile/mateba

	head = /obj/item/clothing/head/helmet/space/deathsquad
	glasses = /obj/item/clothing/glasses/thermal
	mask = /obj/item/clothing/mask/gas/swat
	gloves = /obj/item/clothing/gloves/swat
	shoes = /obj/item/clothing/shoes/swat

	l_ear = /obj/item/radio/headset

	suit_store = /obj/item/tank/emergency/oxygen
	l_pocket = /obj/item/melee/energy/sword
	r_pocket = /obj/item/grenade/flashbang

	r_hand = /obj/item/gun/energy/pulse_rifle

	id_slot = SLOT_ID_WEAR_ID
	id_type = /obj/item/card/id/centcom/station
	id_pda_assignment = "Death Commando"

	backpack_contents = list(
		/obj/item/storage/box,
		/obj/item/ammo_magazine/a357,
		/obj/item/storage/firstaid/regular,
		/obj/item/storage/box/flashbangs,
		/obj/item/flashlight
	)

	flags = OUTFIT_HIDE_IF_CATEGORY

/decl/hierarchy/outfit/death_commando/post_equip(mob/living/carbon/human/user)
	. = ..()
	var/obj/item/radio/headset/radio = locate(/obj/item/radio/headset) in user
	if(isnotnull(radio))
		radio.radio_connection = register_radio(radio, null, FREQUENCY_DEATHSQUAD, RADIO_CHAT)

	var/obj/item/implant/loyalty/loyalty_implant = new /obj/item/implant/loyalty(src)
	loyalty_implant.imp_in = src
	loyalty_implant.implanted = TRUE

/*
 * Death Commando Standard
 */
/decl/hierarchy/outfit/death_commando/standard
	name = "Death Commando"

	uniform = /obj/item/clothing/under/color/green

/decl/hierarchy/outfit/death_commando/standard/New()
	backpack_contents.Add(/obj/item/plastique)
	. = ..()

/*
 * Death Commando Leader
 */
/decl/hierarchy/outfit/death_commando/leader
	name = "Death Commando Leader"

	uniform = /obj/item/clothing/under/rank/centcom_officer

/decl/hierarchy/outfit/death_commando/leader/New()
	backpack_contents.Add(/obj/item/pinpointer, /obj/item/disk/nuclear)
	. = ..()

/*
 * Syndicate Commando Common
 */
/decl/hierarchy/outfit/syndicate_commando
	uniform = /obj/item/clothing/under/syndicate
	back = /obj/item/storage/backpack/security
	belt = /obj/item/gun/projectile/silenced

	glasses = /obj/item/clothing/glasses/thermal
	mask = /obj/item/clothing/mask/gas/syndicate
	gloves = /obj/item/clothing/gloves/swat
	shoes = /obj/item/clothing/shoes/swat

	suit_store = /obj/item/tank/emergency/oxygen
	l_pocket = /obj/item/melee/energy/sword
	r_pocket = /obj/item/grenade/empgrenade

	l_ear = /obj/item/radio/headset/syndicate

	r_hand = /obj/item/gun/energy/pulse_rifle // Will change to something different at a later time -- Superxpdude

	// They get full station access because obviously the syndicate has HAAAX, and can make special IDs for their most elite members.
	id_slot = SLOT_ID_WEAR_ID
	id_type = /obj/item/card/id/syndicate/station_access
	id_pda_assignment = "Syndicate Commando"

	backpack_contents = list(
		/obj/item/storage/box = 1,
		/obj/item/ammo_magazine/c45 = 1,
		/obj/item/storage/firstaid/regular = 1,
		/obj/item/flashlight = 1
	)

/*
 * Syndicate Commando Standard
 */
/decl/hierarchy/outfit/syndicate_commando/standard
	name = "Syndicate Commando"

	suit = /obj/item/clothing/suit/space/syndicate/black

	head = /obj/item/clothing/head/helmet/space/syndicate/black

/decl/hierarchy/outfit/syndicate_commando/standard/New()
	backpack_contents.Add(list(/obj/item/plastique = 2))
	. = ..()

/*
 * Syndicate Commando Leader
 */
/decl/hierarchy/outfit/syndicate_commando/leader
	name = "Syndicate Commando Leader"

	suit = /obj/item/clothing/suit/space/syndicate/black/red

	head = /obj/item/clothing/head/helmet/space/syndicate/black/red

/decl/hierarchy/outfit/syndicate_commando/leader/New()
	backpack_contents.Add(/obj/item/plastique, /obj/item/pinpointer, /obj/item/disk/nuclear)
	. = ..()