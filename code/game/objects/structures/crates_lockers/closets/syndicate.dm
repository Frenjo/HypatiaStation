/*
 * Syndicate
 */
/obj/structure/closet/syndicate
	name = "armoury closet"
	desc = "Why is this here?"
	icon_state = "syndicate"
	icon_closed = "syndicate"
	icon_opened = "syndicateopen"

/*
 * Syndicate Personal
 */
/obj/structure/closet/syndicate/personal
	desc = "It's a storage unit for operative gear."

	starts_with = list(
		/obj/item/tank/jetpack/oxygen,
		/obj/item/clothing/mask/gas/syndicate,
		/obj/item/clothing/under/syndicate,
		/obj/item/clothing/head/helmet/space/rig/syndi,
		/obj/item/clothing/suit/space/rig/syndi,
		/obj/item/crowbar/red,
		/obj/item/cell/high,
		/obj/item/card/id/syndicate,
		/obj/item/multitool,
		/obj/item/shield/energy,
		/obj/item/clothing/shoes/magboots
	)

/*
 * Syndicate Nuclear
 */
/obj/structure/closet/syndicate/nuclear
	desc = "It's a storage unit for nuclear-operative gear."

	starts_with = list(
		/obj/item/ammo_magazine/a12mm,
		/obj/item/ammo_magazine/a12mm,
		/obj/item/ammo_magazine/a12mm,
		/obj/item/ammo_magazine/a12mm,
		/obj/item/ammo_magazine/a12mm,
		/obj/item/storage/box/handcuffs,
		/obj/item/storage/box/flashbangs,
		/obj/item/gun/energy/gun,
		/obj/item/gun/energy/gun,
		/obj/item/gun/energy/gun,
		/obj/item/gun/energy/gun,
		/obj/item/gun/energy/gun,
		/obj/item/pinpointer/nukeop,
		/obj/item/pinpointer/nukeop,
		/obj/item/pinpointer/nukeop,
		/obj/item/pinpointer/nukeop,
		/obj/item/pinpointer/nukeop,
		/obj/item/pda/syndicate
	)

/obj/structure/closet/syndicate/nuclear/New()
	. = ..()
	var/obj/item/radio/uplink/U = new(src)
	U.hidden_uplink.uses = 40

/*
 * Syndicate Resources
 */
/obj/structure/closet/syndicate/resources
	desc = "An old, dusty locker."

/*
 * Syndicate Resources (Random)
 */
/obj/structure/closet/syndicate/resources/random/New()
	. = ..()
	var/common_min = 30	//Minimum amount of minerals in the stack for common minerals
	var/common_max = 50	//Maximum amount of HONK in the stack for HONK common minerals
	var/rare_min = 5	//Minimum HONK of HONK in the stack HONK HONK rare minerals
	var/rare_max = 20	//Maximum HONK HONK HONK in the HONK for HONK rare HONK

	var/pickednum = rand(1, 50)

	//Sad trombone
	if(pickednum == 1)
		var/obj/item/paper/P = new /obj/item/paper(src)
		P.name = "IOU"
		P.info = "Sorry man, we needed the money so we sold your stash. It's ok, we'll double our money for sure this time!"

	//Metal (common ore)
	if(pickednum >= 2)
		new /obj/item/stack/sheet/metal(src, rand(common_min, common_max))

	//Glass (common ore)
	if(pickednum >= 5)
		new /obj/item/stack/sheet/glass(src, rand(common_min, common_max))

	//Plasteel (common ore) Because it has a million more uses then plasma
	if(pickednum >= 10)
		new /obj/item/stack/sheet/plasteel(src, rand(common_min, common_max))

	//Plasma (rare ore)
	if(pickednum >= 15)
		new /obj/item/stack/sheet/plasma(src, rand(rare_min, rare_max))

	//Silver (rare ore)
	if(pickednum >= 20)
		new /obj/item/stack/sheet/silver(src, rand(rare_min, rare_max))

	//Gold (rare ore)
	if(pickednum >= 30)
		new /obj/item/stack/sheet/gold(src, rand(rare_min, rare_max))

	//Uranium (rare ore)
	if(pickednum >= 40)
		new /obj/item/stack/sheet/uranium(src, rand(rare_min, rare_max))

	//Diamond (rare HONK)
	if(pickednum >= 45)
		new /obj/item/stack/sheet/diamond(src, rand(rare_min, rare_max))

	//Jetpack (You hit the jackpot!)
	if(pickednum == 50)
		new /obj/item/tank/jetpack/carbon_dioxide(src)

/*
 * Syndicate Resources (Everything)
 */
/obj/structure/closet/syndicate/resources/everything
	desc = "It's an emergency storage closet for repairs."

/obj/structure/closet/syndicate/resources/everything/New()
	. = ..()
	var/list/resources = list(
		/obj/item/stack/sheet/metal,
		/obj/item/stack/sheet/glass,
		/obj/item/stack/sheet/gold,
		/obj/item/stack/sheet/silver,
		/obj/item/stack/sheet/plasma,
		/obj/item/stack/sheet/uranium,
		/obj/item/stack/sheet/diamond,
		/obj/item/stack/sheet/bananium,
		/obj/item/stack/sheet/plasteel,
		/obj/item/stack/rods
	)

	for(var/i = 0, i < 2, i++)
		for(var/res in resources)
			var/obj/item/stack/R = new res(src)
			R.amount = R.max_amount