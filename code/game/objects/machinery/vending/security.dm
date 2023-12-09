/*
 * Vending Machine Types
 *
 * These contain Security things.
 */
/obj/machinery/vending/security
	name = "SecTech"
	desc = "A security equipment vendor."
	icon_state = "sec"
	icon_deny = "sec-deny"

	req_access = list(ACCESS_SECURITY)

	products = list(
		/obj/item/handcuffs = 8, /obj/item/grenade/flashbang = 4, /obj/item/flash = 5,
		/obj/item/reagent_containers/food/snacks/donut/normal = 12, /obj/item/storage/box/evidence = 6
	)
	contraband = list(/obj/item/clothing/glasses/sunglasses = 2, /obj/item/storage/fancy/donut_box = 2)

	ad_list = list(
		"Crack capitalist skulls!", "Beat some heads in!", "Don't forget - harm is good!",
		"Your weapons are right here.", "Handcuffs!", "Freeze, scumbag!",
		"Don't tase me bro!", "Tase them, bro.", "Why not have a donut?"
	)