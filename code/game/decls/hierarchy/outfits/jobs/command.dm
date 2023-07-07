/*
 * Command
 */
/decl/hierarchy/outfit/job/command
	shoes = /obj/item/clothing/shoes/brown

	flags = OUTFIT_HIDE_IF_CATEGORY

/*
 * Captain
 */
/decl/hierarchy/outfit/job/command/captain
	name = "Captain"

	uniform = /obj/item/clothing/under/rank/captain

	head = /obj/item/clothing/head/caphat
	glasses = /obj/item/clothing/glasses/sunglasses

	l_ear = /obj/item/device/radio/headset/heads/captain

	backpack_contents = list(
		/obj/item/weapon/storage/box/ids = 1
	)

	id_type = /obj/item/weapon/card/id/gold
	pda_type = /obj/item/device/pda/captain

	backpack = /obj/item/weapon/storage/backpack/captain
	satchel_one = /obj/item/weapon/storage/satchel/cap

/decl/hierarchy/outfit/job/command/captain/post_equip(mob/living/carbon/human/user)
	. = ..()
	if(user.age > 49)
		var/obj/item/clothing/under/uniform = user.w_uniform
		if(isnotnull(uniform))
			uniform.hastie = new /obj/item/clothing/tie/medal/gold/captain(uniform)

/*
 * Head of Personnel
 */
/decl/hierarchy/outfit/job/command/hop
	name = "Head of Personnel"

	uniform = /obj/item/clothing/under/rank/head_of_personnel

	l_ear = /obj/item/device/radio/headset/heads/hop

	backpack_contents = list(
		/obj/item/weapon/storage/box/ids = 1
	)

	id_type = /obj/item/weapon/card/id/silver
	pda_type = /obj/item/device/pda/heads/hop