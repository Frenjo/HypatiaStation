/*
 * Assistant
 */
/decl/hierarchy/outfit/job/assistant
	name = "Assistant"

/*
 * Internal Affairs Agent
 *
 * This needs to be moved to a Security or a Command job in future.
 */
/decl/hierarchy/outfit/job/internal_affairs
	name = "Internal Affairs Agent"

	uniform = /obj/item/clothing/under/rank/internalaffairs
	suit = /obj/item/clothing/suit/storage/internalaffairs

	glasses = /obj/item/clothing/glasses/sunglasses/big
	shoes = /obj/item/clothing/shoes/brown

	l_ear = /obj/item/radio/headset/sec

	l_hand = /obj/item/storage/briefcase

	pda_type = /obj/item/pda/lawyer

/*
 * Service
 */
/decl/hierarchy/outfit/job/service
	l_ear = /obj/item/radio/headset/service

	flags = OUTFIT_HIDE_IF_CATEGORY

/*
 * Bartender
 */
/decl/hierarchy/outfit/job/service/bartender
	name = "Bartender"

	uniform = /obj/item/clothing/under/rank/bartender

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
		/obj/item/reagent_containers/food/snacks/grown/banana,
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
		/obj/item/reagent_containers/food/drinks/bottle/nothing
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