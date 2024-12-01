/*
 * Command
 */
/decl/hierarchy/outfit/job/command
	shoes = /obj/item/clothing/shoes/brown

/*
 * Captain
 */
/decl/hierarchy/outfit/job/command/captain
	name = "Captain"

	uniform = /obj/item/clothing/under/rank/captain

	head = /obj/item/clothing/head/caphat
	glasses = /obj/item/clothing/glasses/sunglasses

	l_ear = /obj/item/radio/headset/heads/captain

	backpack_contents = list(
		/obj/item/storage/box/ids
	)

	id_type = /obj/item/card/id/gold
	pda_type = /obj/item/pda/captain

	backpack = /obj/item/storage/backpack/captain
	satchel_one = /obj/item/storage/satchel/cap

/decl/hierarchy/outfit/job/command/captain/post_equip(mob/living/carbon/human/user)
	. = ..()
	if(user.age > 49)
		var/obj/item/clothing/under/uniform = user.wear_uniform
		if(isnotnull(uniform))
			uniform.hastie = new /obj/item/clothing/tie/medal/gold/captain(uniform)

/*
 * Head of Personnel
 */
/decl/hierarchy/outfit/job/command/hop
	name = "Head of Personnel"

	uniform = /obj/item/clothing/under/rank/head_of_personnel

	l_ear = /obj/item/radio/headset/heads/hop

	backpack_contents = list(
		/obj/item/storage/box/ids
	)

	id_type = /obj/item/card/id/silver
	pda_type = /obj/item/pda/heads/hop

/*
 * Internal Affairs Agent
 */
/decl/hierarchy/outfit/job/command/internal_affairs
	name = "Internal Affairs Agent"

	uniform = /obj/item/clothing/under/rank/internalaffairs
	suit = /obj/item/clothing/suit/storage/internalaffairs

	glasses = /obj/item/clothing/glasses/sunglasses

	l_ear = /obj/item/radio/headset/sec

	l_hand = /obj/item/storage/briefcase
	r_hand = /obj/item/encryptionkey/com

	id_type = /obj/item/card/id/silver
	pda_type = /obj/item/pda/lawyer