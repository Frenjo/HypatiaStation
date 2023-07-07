/*
 * Base Job Outfit
 */
/decl/hierarchy/outfit/job
	name = "Default Job Gear"

	uniform = /obj/item/clothing/under/color/grey

	shoes = /obj/item/clothing/shoes/black

	l_ear = /obj/item/device/radio/headset

	id_slot = SLOT_ID_WEAR_ID
	id_type = /obj/item/weapon/card/id
	pda_slot = SLOT_ID_BELT
	pda_type = /obj/item/device/pda

	flags = OUTFIT_HIDE_IF_CATEGORY

	var/backpack = /obj/item/weapon/storage/backpack
	var/satchel_one = /obj/item/weapon/storage/satchel/norm
	var/satchel_two = /obj/item/weapon/storage/satchel

/decl/hierarchy/outfit/job/pre_equip(mob/living/carbon/human/user)
	. = ..()
	if(isnull(back))
		switch(user.backbag)
			if(2)
				back = backpack
			if(3)
				back = satchel_one
			if(4)
				back = satchel_two