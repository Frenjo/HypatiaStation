/*
 * Wardrobe
 */
/obj/structure/closet/wardrobe
	name = "wardrobe"
	desc = "It's a storage unit for standard-issue NanoTrasen attire."
	icon_state = "blue"
	icon_closed = "blue"

/*
 * Security (Red)
 */
/obj/structure/closet/wardrobe/red
	name = "security wardrobe"
	icon_state = "red"
	icon_closed = "red"

	starts_with = list(
		/obj/item/clothing/under/rank/security,
		/obj/item/clothing/under/rank/security,
		/obj/item/clothing/under/rank/security,
		/obj/item/clothing/under/rank/security2,
		/obj/item/clothing/under/rank/security2,
		/obj/item/clothing/under/rank/security2,
		/obj/item/clothing/shoes/jackboots,
		/obj/item/clothing/shoes/jackboots,
		/obj/item/clothing/shoes/jackboots,
		/obj/item/clothing/head/soft/sec,
		/obj/item/clothing/head/soft/sec,
		/obj/item/clothing/head/soft/sec,
		/obj/item/clothing/head/beret/sec,
		/obj/item/clothing/head/beret/sec,
		/obj/item/clothing/head/beret/sec
	)

/*
 * Pink
 */
/obj/structure/closet/wardrobe/pink
	name = "pink wardrobe"
	icon_state = "pink"
	icon_closed = "pink"

	starts_with = list(
		/obj/item/clothing/under/color/pink,
		/obj/item/clothing/under/color/pink,
		/obj/item/clothing/under/color/pink,
		/obj/item/clothing/shoes/brown,
		/obj/item/clothing/shoes/brown,
		/obj/item/clothing/shoes/brown
	)

/*
 * Black
 */
/obj/structure/closet/wardrobe/black
	name = "black wardrobe"
	icon_state = "black"
	icon_closed = "black"

	starts_with = list(
		/obj/item/clothing/under/color/black,
		/obj/item/clothing/under/color/black,
		/obj/item/clothing/under/color/black,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/head/that,
		/obj/item/clothing/head/that,
		/obj/item/clothing/head/that
	)

/*
 * Chaplain
 */
/obj/structure/closet/wardrobe/chaplain
	name = "chapel wardrobe"
	desc = "It's a storage unit for NanoTrasen-approved religious attire."
	icon_state = "black"
	icon_closed = "black"

	starts_with = list(
		/obj/item/clothing/under/rank/chaplain,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/suit/nun,
		/obj/item/clothing/head/nun_hood,
		/obj/item/clothing/suit/chaplain_hoodie,
		/obj/item/clothing/head/chaplain_hood,
		/obj/item/clothing/suit/holidaypriest,
		/obj/item/clothing/under/wedding/bride_white,
		/obj/item/storage/backpack/cultpack,
		/obj/item/storage/fancy/candle_box,
		/obj/item/storage/fancy/candle_box
	)

/*
 * Green
 */
/obj/structure/closet/wardrobe/green
	name = "green wardrobe"
	icon_state = "green"
	icon_closed = "green"

	starts_with = list(
		/obj/item/clothing/under/color/green,
		/obj/item/clothing/under/color/green,
		/obj/item/clothing/under/color/green,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/shoes/black
	)

/*
 * Xenos
 */
/obj/structure/closet/wardrobe/xenos
	name = "xenos wardrobe"
	icon_state = "green"
	icon_closed = "green"

	starts_with = list(
		/obj/item/clothing/suit/soghun/mantle,
		/obj/item/clothing/suit/soghun/robe,
		/obj/item/clothing/shoes/sandal,
		/obj/item/clothing/shoes/sandal,
		/obj/item/clothing/shoes/sandal
	)

/*
 * Prison (Orange)
 */
/obj/structure/closet/wardrobe/orange
	name = "prison wardrobe"
	desc = "It's a storage unit for NanoTrasen-regulation prisoner attire."
	icon_state = "orange"
	icon_closed = "orange"

	starts_with = list(
		/obj/item/clothing/under/color/orange,
		/obj/item/clothing/under/color/orange,
		/obj/item/clothing/under/color/orange,
		/obj/item/clothing/shoes/orange,
		/obj/item/clothing/shoes/orange,
		/obj/item/clothing/shoes/orange
	)

/*
 * Yellow
 */
/obj/structure/closet/wardrobe/yellow
	name = "yellow wardrobe"
	icon_state = "yellow"
	icon_closed = "yellow"

	starts_with = list(
		/obj/item/clothing/under/color/yellow,
		/obj/item/clothing/under/color/yellow,
		/obj/item/clothing/under/color/yellow,
		/obj/item/clothing/shoes/orange,
		/obj/item/clothing/shoes/orange,
		/obj/item/clothing/shoes/orange
	)

/*
 * Atmospherics
 */
/obj/structure/closet/wardrobe/atmospherics
	name = "atmospherics wardrobe"
	icon_state = "yellow"
	icon_closed = "yellow"

	starts_with = list(
		/obj/item/clothing/under/rank/atmospheric_technician,
		/obj/item/clothing/under/rank/atmospheric_technician,
		/obj/item/clothing/under/rank/atmospheric_technician,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/head/hardhat/red,
		/obj/item/clothing/head/hardhat/red,
		/obj/item/clothing/head/hardhat/red,
		/obj/item/clothing/head/beret/eng,
		/obj/item/clothing/head/beret/eng,
		/obj/item/clothing/head/beret/eng
	)

/*
 * Engineering
 */
/obj/structure/closet/wardrobe/engineering
	name = "engineering wardrobe"
	icon_state = "yellow"
	icon_closed = "yellow"

	starts_with = list(
		/obj/item/clothing/under/rank/engineer,
		/obj/item/clothing/under/rank/engineer,
		/obj/item/clothing/under/rank/engineer,
		/obj/item/clothing/shoes/orange,
		/obj/item/clothing/shoes/orange,
		/obj/item/clothing/shoes/orange,
		/obj/item/clothing/head/hardhat,
		/obj/item/clothing/head/hardhat,
		/obj/item/clothing/head/hardhat,
		/obj/item/clothing/head/beret/eng,
		/obj/item/clothing/head/beret/eng,
		/obj/item/clothing/head/beret/eng
	)

/*
 * White
 */
/obj/structure/closet/wardrobe/white
	name = "white wardrobe"
	icon_state = "white"
	icon_closed = "white"

	starts_with = list(
		/obj/item/clothing/under/color/white,
		/obj/item/clothing/under/color/white,
		/obj/item/clothing/under/color/white,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/shoes/white
	)

/*
 * Pyjamas
 */
/obj/structure/closet/wardrobe/pjs
	name = "pajama wardrobe"
	icon_state = "white"
	icon_closed = "white"

	starts_with = list(
		/obj/item/clothing/under/pj/red,
		/obj/item/clothing/under/pj/red,
		/obj/item/clothing/under/pj/blue,
		/obj/item/clothing/under/pj/blue,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/shoes/slippers,
		/obj/item/clothing/shoes/slippers
	)

/*
 * Toxins
 */
/obj/structure/closet/wardrobe/toxins
	name = "toxins wardrobe"
	icon_state = "white"
	icon_closed = "white"

	starts_with = list(
		/obj/item/clothing/under/rank/scientist,
		/obj/item/clothing/under/rank/scientist,
		/obj/item/clothing/under/rank/scientist,
		/obj/item/clothing/suit/storage/labcoat,
		/obj/item/clothing/suit/storage/labcoat,
		/obj/item/clothing/suit/storage/labcoat,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/shoes/white
	)

/*
 * Robotics
 */
/obj/structure/closet/wardrobe/robotics
	name = "robotics wardrobe"
	icon_state = "black"
	icon_closed = "black"

	starts_with = list(
		/obj/item/clothing/under/rank/roboticist,
		/obj/item/clothing/under/rank/roboticist,
		/obj/item/clothing/suit/storage/labcoat,
		/obj/item/clothing/suit/storage/labcoat,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/gloves/black
	)

/*
 * Chemistry
 */
/obj/structure/closet/wardrobe/chemistry
	name = "chemistry wardrobe"
	icon_state = "white"
	icon_closed = "white"

	starts_with = list(
		/obj/item/clothing/under/rank/chemist,
		/obj/item/clothing/under/rank/chemist,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/suit/storage/labcoat/chemist,
		/obj/item/clothing/suit/storage/labcoat/chemist
	)

/*
 * Genetics
 */
/obj/structure/closet/wardrobe/genetics
	name = "genetics wardrobe"
	icon_state = "white"
	icon_closed = "white"

	starts_with = list(
		/obj/item/clothing/under/rank/geneticist,
		/obj/item/clothing/under/rank/geneticist,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/suit/storage/labcoat/genetics,
		/obj/item/clothing/suit/storage/labcoat/genetics
	)

/*
 * Virology
 */
/obj/structure/closet/wardrobe/virology
	name = "virology wardrobe"
	icon_state = "white"
	icon_closed = "white"

	starts_with = list(
		/obj/item/clothing/under/rank/virologist,
		/obj/item/clothing/under/rank/virologist,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/suit/storage/labcoat/virologist,
		/obj/item/clothing/suit/storage/labcoat/virologist,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/mask/surgical
	)

/*
 * Medical
 */
/obj/structure/closet/wardrobe/medical
	name = "medical wardrobe"
	icon_state = "white"
	icon_closed = "white"

	starts_with = list(
		/obj/item/clothing/under/rank/medical,
		/obj/item/clothing/under/rank/medical,
		/obj/item/clothing/under/rank/medical/blue,
		/obj/item/clothing/under/rank/medical/green,
		/obj/item/clothing/under/rank/medical/purple,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/suit/storage/labcoat,
		/obj/item/clothing/suit/storage/labcoat,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/mask/surgical
	)

/*
 * Grey
 */
/obj/structure/closet/wardrobe/grey
	name = "grey wardrobe"
	icon_state = "grey"
	icon_closed = "grey"

	starts_with = list(
		/obj/item/clothing/under/color/grey,
		/obj/item/clothing/under/color/grey,
		/obj/item/clothing/under/color/grey,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/head/soft/grey,
		/obj/item/clothing/head/soft/grey,
		/obj/item/clothing/head/soft/grey
	)

/*
 * Mixed
 */
/obj/structure/closet/wardrobe/mixed
	name = "mixed wardrobe"
	icon_state = "mixed"
	icon_closed = "mixed"

	starts_with = list(
		/obj/item/clothing/under/color/blue,
		/obj/item/clothing/under/color/yellow,
		/obj/item/clothing/under/color/green,
		/obj/item/clothing/under/color/orange,
		/obj/item/clothing/under/color/pink,
		/obj/item/clothing/under/dress/plaid_blue,
		/obj/item/clothing/under/dress/plaid_red,
		/obj/item/clothing/under/dress/plaid_purple,
		/obj/item/clothing/shoes/blue,
		/obj/item/clothing/shoes/yellow,
		/obj/item/clothing/shoes/green,
		/obj/item/clothing/shoes/orange,
		/obj/item/clothing/shoes/purple,
		/obj/item/clothing/shoes/red,
		/obj/item/clothing/shoes/leather
	)

/*
 * Tactical
 */
/obj/structure/closet/wardrobe/tactical
	name = "tactical equipment"
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1open"

	starts_with = list(
		/obj/item/clothing/under/tactical,
		/obj/item/clothing/suit/armor/tactical,
		/obj/item/clothing/head/helmet/tactical,
		/obj/item/clothing/mask/balaclava/tactical,
		/obj/item/clothing/glasses/sunglasses/sechud/tactical,
		/obj/item/storage/belt/security/tactical,
		/obj/item/clothing/shoes/jackboots,
		/obj/item/clothing/gloves/black
	)