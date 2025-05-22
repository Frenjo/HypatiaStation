/*
 * Assistant
 */
/decl/hierarchy/outfit/job/assistant
	name = "Assistant"

/*
 * Service
 */
/decl/hierarchy/outfit/job/service
	l_ear = /obj/item/radio/headset/service

/*
 * Bartender
 */
/decl/hierarchy/outfit/job/service/bartender
	name = "Bartender"

	uniform = /obj/item/clothing/under/rank/bartender

	backpack_contents = list(/obj/item/storage/box/survival/bartender = 1)

	pda_type = /obj/item/pda/bar

/*
 * Chef
 */
/decl/hierarchy/outfit/job/service/chef
	name = "Chef"

	uniform = /obj/item/clothing/under/rank/chef
	suit = /obj/item/clothing/suit/chef

	head = /obj/item/clothing/head/chefhat

	pda_type = /obj/item/pda/chef

/*
 * Botanist
 */
/decl/hierarchy/outfit/job/service/botanist
	name = "Botanist"

	uniform = /obj/item/clothing/under/rank/hydroponics
	suit = /obj/item/clothing/suit/apron

	gloves = /obj/item/clothing/gloves/botanic_leather

	suit_store = /obj/item/plant_analyser

	pda_type = /obj/item/pda/botanist

	satchel_one = /obj/item/storage/satchel/hyd

/*
 * Clown
 */
/decl/hierarchy/outfit/job/service/clown
	name = "Clown"

	uniform = /obj/item/clothing/under/rank/clown
	back = /obj/item/storage/backpack/clown

	mask = /obj/item/clothing/mask/gas/clown_hat
	shoes = /obj/item/clothing/shoes/clown_shoes

	backpack_contents = list(
		/obj/item/reagent_holder/food/snacks/grown/banana,
		/obj/item/bikehorn,
		/obj/item/stamp/clown,
		/obj/item/toy/crayon/rainbow,
		/obj/item/storage/fancy/crayons,
		/obj/item/toy/waterflower
	)

	pda_type = /obj/item/pda/clown

/*
 * Mime
 */
/decl/hierarchy/outfit/job/service/mime
	name = "Mime"

	uniform = /obj/item/clothing/under/mime
	suit = /obj/item/clothing/suit/suspenders

	head = /obj/item/clothing/head/beret
	mask = /obj/item/clothing/mask/gas/mime
	gloves = /obj/item/clothing/gloves/white

	backpack_contents = list(
		/obj/item/toy/crayon/mime,
		/obj/item/reagent_holder/food/drinks/bottle/nothing
	)

	pda_type = /obj/item/pda/mime

/*
 * Janitor
 */
/decl/hierarchy/outfit/job/service/janitor
	name = "Janitor"

	uniform = /obj/item/clothing/under/rank/janitor

	pda_type = /obj/item/pda/janitor

/*
 * Librarian
 */
/decl/hierarchy/outfit/job/service/librarian
	name = "Librarian"

	uniform = /obj/item/clothing/under/suit_jacket/red

	l_hand = /obj/item/barcodescanner

	pda_type = /obj/item/pda/librarian

/*
 * Chaplain
 */
/decl/hierarchy/outfit/job/service/chaplain
	name = "Chaplain"

	uniform = /obj/item/clothing/under/rank/chaplain

	l_hand = /obj/item/storage/bible

	pda_type = /obj/item/pda/chaplain

/*
 * Lawyer
 */
/decl/hierarchy/outfit/job/service/lawyer
	name = "Lawyer"

	uniform = /obj/item/clothing/under/lawyer/bluesuit
	suit = /obj/item/clothing/suit/storage/lawyer/bluejacket

	glasses = /obj/item/clothing/glasses/sunglasses/big
	shoes = /obj/item/clothing/shoes/brown

	l_ear = /obj/item/radio/headset/sec

	l_hand = /obj/item/storage/briefcase
	r_hand = /obj/item/encryptionkey/service

	pda_type = /obj/item/pda/lawyer

	// First lawyer gets the default blue suit, another that joins gets the purple one.
	var/static/use_purple_suit = FALSE

/decl/hierarchy/outfit/job/service/lawyer/pre_equip(mob/living/carbon/human/user)
	. = ..()
	if(use_purple_suit)
		uniform = /obj/item/clothing/under/lawyer/purpsuit
		suit = /obj/item/clothing/suit/storage/lawyer/purpjacket
	else
		use_purple_suit = TRUE