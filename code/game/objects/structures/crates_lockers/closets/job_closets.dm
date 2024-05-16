/* Closets for specific jobs
 * Contains:
 *		Bartender
 *		Janitor
 *		Lawyer
 */

/*
 * Bartender
 */
// This one should maybe go under /obj/structure/closet/wardrobe/formal and be renamed to "formal wardrobe" for consistency.
/obj/structure/closet/formal
	name = "formal closet"
	desc = "It's a storage unit for formal clothing."
	icon_state = "black"
	icon_closed = "black"

	starts_with = list(
		/obj/item/clothing/head/that,
		/obj/item/clothing/head/that,
		/obj/item/clothing/head/hairflower,
		/obj/item/clothing/under/sl_suit,
		/obj/item/clothing/under/sl_suit,
		/obj/item/clothing/under/rank/bartender,
		/obj/item/clothing/under/rank/bartender,
		/obj/item/clothing/under/dress/dress_saloon,
		/obj/item/clothing/suit/wcoat,
		/obj/item/clothing/suit/wcoat,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/shoes/black
	)

/*
 * Janitor
 */
/obj/structure/closet/janitor
	name = "custodial closet"
	desc = "It's a storage unit for janitorial clothes and gear."
	icon_state = "mixed"
	icon_closed = "mixed"

	starts_with = list(
		/obj/item/clothing/under/rank/janitor,
		/obj/item/cartridge/janitor,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/head/soft/purple,
		/obj/item/flashlight,
		/obj/item/caution,
		/obj/item/caution,
		/obj/item/caution,
		/obj/item/caution,
		/obj/item/lightreplacer,
		/obj/item/storage/bag/trash,
		/obj/item/clothing/shoes/galoshes
	)

/*
 * Lawyer
 */
/obj/structure/closet/lawyer
	name = "legal closet"
	desc = "It's a storage unit for courtroom apparel and items."
	icon_state = "blue"
	icon_closed = "blue"

	starts_with = list(
		/obj/item/clothing/under/lawyer/female,
		/obj/item/clothing/under/lawyer/black,
		/obj/item/clothing/under/lawyer/red,
		/obj/item/clothing/under/lawyer/bluesuit,
		/obj/item/clothing/suit/storage/lawyer/bluejacket,
		/obj/item/clothing/under/lawyer/purpsuit,
		/obj/item/clothing/suit/storage/lawyer/purpjacket,
		/obj/item/clothing/shoes/brown,
		/obj/item/clothing/shoes/black
	)