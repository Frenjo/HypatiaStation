/decl/hierarchy/outfit/wizard
	name = "Space Wizard"

	uniform = /obj/item/clothing/under/lightpurple
	suit = /obj/item/clothing/suit/wizrobe

	head = /obj/item/clothing/head/wizard
	shoes = /obj/item/clothing/shoes/sandal

	l_ear = /obj/item/radio/headset

	r_pocket = /obj/item/teleportation_scroll

	//l_hand = /obj/item/scrying_gem
	r_hand = /obj/item/spellbook

	backpack_contents = list(
		/obj/item/storage/box = 1
	)

/decl/hierarchy/outfit/wizard/pre_equip(mob/living/carbon/human/user)
	. = ..()
	switch(user.backbag)
		if(2)
			back = /obj/item/storage/backpack
		if(3)
			back = /obj/item/storage/satchel/norm
		if(4)
			back = /obj/item/storage/satchel