/decl/hierarchy/outfit/vox
	name = "Vox - Basic"

	uniform = /obj/item/clothing/under/vox/vox_robes
	back = /obj/item/tank/nitrogen

	mask = /obj/item/clothing/mask/breath/vox
	// REPLACE THESE WITH CODED VOX ALTERNATIVES.
	gloves = /obj/item/clothing/gloves/yellow/vox
	shoes = /obj/item/clothing/shoes/magboots/vox

	l_ear = /obj/item/radio/headset/syndicate

	r_pocket = /obj/item/flashlight

/decl/hierarchy/outfit/vox/post_equip(mob/living/carbon/human/user)
	. = ..()
	var/obj/item/radio/headset/syndicate/radio = user.l_ear
	radio.radio_connection = register_radio(radio, null, FREQUENCY_SYNDICATE, RADIO_CHAT) // Same frequency as the syndicate team in Nuke mode.

// Vox Raider
/decl/hierarchy/outfit/vox/raider
	name = "Vox Raider"

	suit = /obj/item/clothing/suit/space/vox/carapace
	belt = /obj/item/melee/telebaton

	head = /obj/item/clothing/head/helmet/space/vox/carapace
	glasses = /obj/item/clothing/glasses/thermal/monocle // REPLACE WITH CODED VOX ALTERNATIVE.

	l_pocket = /obj/item/chameleon

	l_hand = /obj/item/stack/rods
	r_hand = /obj/item/crossbow

/decl/hierarchy/outfit/vox/raider/post_equip(mob/living/carbon/human/user)
	. = ..()
	var/obj/item/stack/rods/ammo = user.l_hand
	ammo.amount = 20

	var/obj/item/crossbow/bow = user.r_hand
	qdel(bow.cell)
	bow.cell = new /obj/item/cell/crap(bow)

// Vox Engineer
/decl/hierarchy/outfit/vox/engineer
	name = "Vox Engineer"

	suit = /obj/item/clothing/suit/space/vox/pressure
	belt = /obj/item/storage/belt/utility/full

	head = /obj/item/clothing/head/helmet/space/vox/pressure
	glasses =/obj/item/clothing/glasses/meson // REPLACE WITH CODED VOX ALTERNATIVE.

	l_hand = /obj/item/multitool
	r_hand = /obj/item/storage/box/emps

// Vox Saboteur
/decl/hierarchy/outfit/vox/saboteur
	name = "Vox Saboteur"

	suit = /obj/item/clothing/suit/space/vox/stealth
	belt = /obj/item/storage/belt/utility/full

	head = /obj/item/clothing/head/helmet/space/vox/stealth
	glasses = /obj/item/clothing/glasses/thermal/monocle // REPLACE WITH CODED VOX ALTERNATIVE.

	l_pocket = /obj/item/card/emag

	l_hand = /obj/item/multitool
	r_hand = /obj/item/gun/dartgun/vox/raider

// Vox Medic
/decl/hierarchy/outfit/vox/medic
	name = "Vox Medic"

	suit = /obj/item/clothing/suit/space/vox/medic
	belt = /obj/item/storage/belt/utility/full // Who needs actual surgical tools?

	head = /obj/item/clothing/head/helmet/space/vox/medic
	glasses = /obj/item/clothing/glasses/hud/health // REPLACE WITH CODED VOX ALTERNATIVE.

	r_hand = /obj/item/gun/dartgun/vox/medical

	l_pocket = /obj/item/circular_saw