GLOBAL_GLOBL_INIT(vox_tick, 1)

/mob/living/carbon/human/proc/equip_vox_raider()

	var/obj/item/device/radio/R = new /obj/item/device/radio/headset/syndicate(src)
	R.radio_connection = register_radio(R, null, FREQUENCY_SYNDICATE, RADIO_CHAT) //Same frequency as the syndicate team in Nuke mode.
	equip_to_slot_or_del(R, SLOT_ID_L_EAR)

	equip_to_slot_or_del(new /obj/item/clothing/under/vox/vox_robes(src), SLOT_ID_W_UNIFORM)
	equip_to_slot_or_del(new /obj/item/clothing/shoes/magboots/vox(src), SLOT_ID_SHOES) // REPLACE THESE WITH CODED VOX ALTERNATIVES.
	equip_to_slot_or_del(new /obj/item/clothing/gloves/yellow/vox(src), SLOT_ID_GLOVES) // AS ABOVE.

	switch(GLOBL.vox_tick)
		if(1) // Vox raider!
			equip_to_slot_or_del(new /obj/item/clothing/suit/space/vox/carapace(src), SLOT_ID_WEAR_SUIT)
			equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/vox/carapace(src), SLOT_ID_HEAD)
			equip_to_slot_or_del(new /obj/item/weapon/melee/telebaton(src), SLOT_ID_BELT)
			equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/monocle(src), SLOT_ID_GLASSES) // REPLACE WITH CODED VOX ALTERNATIVE.
			equip_to_slot_or_del(new /obj/item/device/chameleon(src), SLOT_ID_L_STORE)

			var/obj/item/weapon/crossbow/W = new(src)
			W.cell = new /obj/item/weapon/cell/crap(W)
			W.cell.charge = 500
			equip_to_slot_or_del(W, SLOT_ID_R_HAND)

			var/obj/item/stack/rods/A = new(src)
			A.amount = 20
			equip_to_slot_or_del(A, SLOT_ID_L_HAND)

		if(2) // Vox engineer!
			equip_to_slot_or_del(new /obj/item/clothing/suit/space/vox/pressure(src), SLOT_ID_WEAR_SUIT)
			equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/vox/pressure(src), SLOT_ID_HEAD)
			equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(src), SLOT_ID_BELT)
			equip_to_slot_or_del(new /obj/item/clothing/glasses/meson(src), SLOT_ID_GLASSES) // REPLACE WITH CODED VOX ALTERNATIVE.
			equip_to_slot_or_del(new /obj/item/weapon/storage/box/emps(src), SLOT_ID_R_HAND)
			equip_to_slot_or_del(new /obj/item/device/multitool(src), SLOT_ID_L_HAND)


		if(3) // Vox saboteur!
			equip_to_slot_or_del(new /obj/item/clothing/suit/space/vox/stealth(src), SLOT_ID_WEAR_SUIT)
			equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/vox/stealth(src), SLOT_ID_HEAD)
			equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(src), SLOT_ID_BELT)
			equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal/monocle(src), SLOT_ID_GLASSES) // REPLACE WITH CODED VOX ALTERNATIVE.
			equip_to_slot_or_del(new /obj/item/weapon/card/emag(src), SLOT_ID_L_STORE)
			equip_to_slot_or_del(new /obj/item/weapon/gun/dartgun/vox/raider(src), SLOT_ID_R_HAND)
			equip_to_slot_or_del(new /obj/item/device/multitool(src), SLOT_ID_L_HAND)

		if(4) // Vox medic!
			equip_to_slot_or_del(new /obj/item/clothing/suit/space/vox/medic(src), SLOT_ID_WEAR_SUIT)
			equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/vox/medic(src), SLOT_ID_HEAD)
			equip_to_slot_or_del(new /obj/item/weapon/storage/belt/utility/full(src), SLOT_ID_BELT) // Who needs actual surgical tools?
			equip_to_slot_or_del(new /obj/item/clothing/glasses/hud/health(src), SLOT_ID_GLASSES) // REPLACE WITH CODED VOX ALTERNATIVE.
			equip_to_slot_or_del(new /obj/item/weapon/circular_saw(src), SLOT_ID_L_STORE)
			equip_to_slot_or_del(new /obj/item/weapon/gun/dartgun/vox/medical, SLOT_ID_R_HAND)

	equip_to_slot_or_del(new /obj/item/clothing/mask/breath/vox(src), SLOT_ID_WEAR_MASK)
	equip_to_slot_or_del(new /obj/item/weapon/tank/nitrogen(src), SLOT_ID_BACK)
	equip_to_slot_or_del(new /obj/item/device/flashlight(src), SLOT_ID_R_STORE)

	var/obj/item/weapon/card/id/syndicate/C = new(src)
	C.name = "[real_name]'s Legitimate Human ID Card"
	C.icon_state = "id"
	C.access = list(ACCESS_SYNDICATE)
	C.assignment = "Trader"
	C.registered_name = real_name
	C.registered_user = src
	var/obj/item/weapon/storage/wallet/W = new(src)
	W.handle_item_insertion(C)
	spawn_money(rand(50,150)*10,W)
	equip_to_slot_or_del(W, SLOT_ID_WEAR_ID)
	GLOBL.vox_tick++
	if(GLOBL.vox_tick > 4)
		GLOBL.vox_tick = 1

	return 1