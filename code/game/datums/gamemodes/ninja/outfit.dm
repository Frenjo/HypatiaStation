/decl/hierarchy/outfit/space_ninja
	name = "Space Ninja"

	suit = /obj/item/clothing/suit/space/space_ninja
	belt = /obj/item/flashlight

	head = /obj/item/clothing/head/helmet/space/space_ninja
	mask = /obj/item/clothing/mask/gas/voice/space_ninja
	gloves = /obj/item/clothing/gloves/space_ninja
	shoes = /obj/item/clothing/shoes/space_ninja

	l_ear = /obj/item/radio/headset

	suit_store = /obj/item/tank/oxygen
	l_pocket = /obj/item/plastique
	r_pocket = /obj/item/plastique

/decl/hierarchy/outfit/space_ninja/pre_equip(mob/living/carbon/human/user)
	. = ..()
	if(user.gender == FEMALE)
		back = /obj/item/clothing/under/color/blackf
	else
		back = /obj/item/clothing/under/color/black