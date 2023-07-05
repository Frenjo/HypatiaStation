/*
 * Standard Space Gear
 */
/decl/hierarchy/outfit/standard_space_gear
	name = "Standard Space Gear"

	uniform = /obj/item/clothing/under/color/grey
	suit = /obj/item/clothing/suit/space
	back = /obj/item/weapon/tank/jetpack/oxygen

	head = /obj/item/clothing/head/helmet/space
	mask = /obj/item/clothing/mask/breath

	flags = OUTFIT_HAS_JETPACK

/*
 * Soviet Soldier
 */
/decl/hierarchy/outfit/soviet_soldier
	name = "Soviet Soldier"

	uniform = /obj/item/clothing/under/soviet

	head = /obj/item/clothing/head/ushanka
	shoes = /obj/item/clothing/shoes/black

/*
 * Soviet Admiral
 */
/decl/hierarchy/outfit/soviet_admiral
	name = "Soviet Admiral"

	uniform = /obj/item/clothing/under/soviet
	suit = /obj/item/clothing/suit/hgpirate
	back = /obj/item/weapon/storage/satchel
	belt = /obj/item/weapon/gun/projectile/mateba

	head = /obj/item/clothing/head/hgpiratecap
	glasses = /obj/item/clothing/glasses/thermal/eyepatch
	gloves = /obj/item/clothing/gloves/combat
	shoes = /obj/item/clothing/shoes/combat

	l_ear = /obj/item/device/radio/headset/heads/captain

	id_slot = SLOT_ID_WEAR_ID
	id_type = /obj/item/weapon/card/id/centcom/station
	id_pda_assignment = "Admiral"