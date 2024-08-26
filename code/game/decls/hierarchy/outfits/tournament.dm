/*
 * Tournament Gear
 */
/decl/hierarchy/outfit/tournament
	suit = /obj/item/clothing/suit/armor/vest

	head = /obj/item/clothing/head/helmet/thunderdome
	shoes = /obj/item/clothing/shoes/black

	r_pocket = /obj/item/grenade/smokebomb

	r_hand = /obj/item/gun/energy/pulse_rifle/destroyer
	l_hand = /obj/item/kitchenknife

	flags = OUTFIT_HIDE_IF_CATEGORY

/*
 * Standard
 *
 * We think stun weapons are too overpowered to use in tournaments.
 */
/decl/hierarchy/outfit/tournament/red
	name = "Tournament Standard Red"

	uniform = /obj/item/clothing/under/color/red

/decl/hierarchy/outfit/tournament/green
	name = "Tournament Standard Green"

	uniform = /obj/item/clothing/under/color/green

/*
 * Gangster
 *
 * Supposed to fight eachother.
 */
/decl/hierarchy/outfit/tournament/gangster
	name = "Tournament Gangster"

	uniform = /obj/item/clothing/under/det
	suit = /obj/item/clothing/suit/storage/det_suit

	head = /obj/item/clothing/head/det_hat
	glasses = /obj/item/clothing/glasses/thermal/monocle

	r_pocket = /obj/item/cloaking_device
	l_pocket = /obj/item/ammo_magazine/a357

	r_hand = /obj/item/gun/projectile
	l_hand = null

/*
 * Chef
 *
 * Steven Seagal ftw.
 */
/decl/hierarchy/outfit/tournament/chef
	name = "Tournament Chef"

	uniform = /obj/item/clothing/under/rank/chef
	suit = /obj/item/clothing/suit/chef

	head = /obj/item/clothing/head/chefhat

	r_pocket = /obj/item/kitchenknife
	l_pocket = /obj/item/kitchenknife

	r_hand = /obj/item/kitchen/rollingpin
	l_hand = /obj/item/kitchenknife

/*
 * Janitor
 */
/decl/hierarchy/outfit/tournament/janitor
	name = "Tournament Janitor"

	uniform = /obj/item/clothing/under/rank/janitor
	suit = null
	back = /obj/item/storage/backpack

	head = null

	r_pocket = /obj/item/grenade/chemical/cleaner
	l_pocket = /obj/item/grenade/chemical/cleaner

	r_hand = /obj/item/mop
	l_hand = /obj/item/reagent_holder/glass/bucket

	backpack_contents = list(/obj/item/stack/tile/metal/grey = 7)

/decl/hierarchy/outfit/tournament/janitor/post_equip(mob/living/carbon/human/user)
	. = ..()
	var/obj/item/reagent_holder/glass/bucket/water_bucket = locate(/obj/item/reagent_holder/glass/bucket) in user
	if(isnotnull(water_bucket))
		water_bucket.reagents.add_reagent("water", 70)