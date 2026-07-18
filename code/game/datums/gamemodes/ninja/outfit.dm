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

/decl/hierarchy/outfit/space_ninja/post_equip(mob/living/carbon/human/user)
	. = ..()

	user.internal = user.suit_store
	user.internals?.icon_state = "internal1"

	var/obj/item/clothing/suit/space/space_ninja/ninja_suit = user.wear_suit
	if(istype(ninja_suit))
		initialize_suit(user, ninja_suit)

/decl/hierarchy/outfit/space_ninja/proc/initialize_suit(mob/living/carbon/human/user, obj/item/clothing/suit/space/space_ninja/ninja_suit)
	set waitfor = FALSE

	ninja_suit.randomize_param()
	ninja_suit.ninitialize(1 SECONDS, user)
