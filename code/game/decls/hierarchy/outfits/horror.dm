/*
 * Tunnel Clown
 *
 * Tunnel clowns rule!
 */
/decl/hierarchy/outfit/tunnel_clown
	name = "Tunnel Clown"

	uniform = /obj/item/clothing/under/rank/clown
	suit = /obj/item/clothing/suit/chaplain_hoodie

	head = /obj/item/clothing/head/chaplain_hood
	glasses = /obj/item/clothing/glasses/thermal/monocle
	mask = /obj/item/clothing/mask/gas/clown_hat
	gloves = /obj/item/clothing/gloves/black
	shoes = /obj/item/clothing/shoes/clown_shoes

	l_ear = /obj/item/radio/headset

	r_pocket = /obj/item/bikehorn
	l_pocket = /obj/item/reagent_holder/food/snacks/grown/banana

	r_hand = /obj/item/twohanded/fireaxe

	id_slot = SLOT_ID_ID_STORE
	id_type = /obj/item/card/id/centcom/station
	id_pda_assignment = "Tunnel Clown!"

/*
 * Masked Killer
 */
/decl/hierarchy/outfit/masked_killer
	name = "Masked Killer"

	uniform = /obj/item/clothing/under/overalls
	suit = /obj/item/clothing/suit/apron

	head = /obj/item/clothing/head/welding
	glasses = /obj/item/clothing/glasses/thermal/monocle
	mask = /obj/item/clothing/mask/surgical
	gloves = /obj/item/clothing/gloves/latex
	shoes = /obj/item/clothing/shoes/white

	l_ear = /obj/item/radio/headset

	r_pocket = /obj/item/scalpel
	l_pocket = /obj/item/kitchenknife

	r_hand = /obj/item/twohanded/fireaxe

/decl/hierarchy/outfit/masked_killer/post_equip(mob/living/carbon/human/user)
	. = ..()
	for(var/obj/item/carried_item in user.contents)
		if(!istype(carried_item, /obj/item/implant)) // If it's not an implant.
			carried_item.add_blood(user) // Oh yes, there will be blood...

/*
 * Assassin
 */
/decl/hierarchy/outfit/assassin
	name = "Assassin"

	uniform = /obj/item/clothing/under/suit_jacket
	suit = /obj/item/clothing/suit/wcoat

	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/black
	shoes = /obj/item/clothing/shoes/black

	l_ear = /obj/item/radio/headset

	r_pocket = /obj/item/cloaking_device
	l_pocket = /obj/item/melee/energy/sword

	l_hand = /obj/item/storage/secure/briefcase

	id_slot = SLOT_ID_ID_STORE
	id_type = /obj/item/card/id/syndicate/station_access
	pda_slot = SLOT_ID_BELT
	pda_type = /obj/item/pda/heads
	id_pda_assignment = "Reaper"

/decl/hierarchy/outfit/assassin/post_equip(mob/living/carbon/human/user)
	. = ..()
	var/obj/item/storage/secure/briefcase/case = locate(/obj/item/storage/secure/briefcase) in user
	if(isnotnull(case))
		for(var/obj/item/item in case)
			qdel(item)
		for(var/i = 0; i < 3; i++)
			new /obj/item/cash/c1000(case)
		new /obj/item/gun/energy/crossbow(case)
		new /obj/item/gun/projectile/mateba(case)
		new /obj/item/ammo_magazine/a357(case)
		new /obj/item/plastique(case)