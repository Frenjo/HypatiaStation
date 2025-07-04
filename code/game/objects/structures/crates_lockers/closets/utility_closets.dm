/* Utility Closets
 * Contains:
 *		Emergency Closet
 *		Fire Closet
 *		Tool Closet
 *		Radiation Closet
 *		Bombsuit Closet
 *		Hydrant
 *		First Aid
 */

/*
 * Emergency Closet
 */
/obj/structure/closet/emergency
	name = "emergency closet"
	desc = "It's a storage unit for emergency breathmasks and o2 tanks."
	icon_state = "emergency"
	icon_closed = "emergency"
	icon_opened = "emergencyopen"

/obj/structure/closet/emergency/New()
	switch(pickweight(list("small" = 55, "aid" = 25, "tank" = 10, "both" = 10, "nothing" = 0, "delete" = 0)))
		if("small")
			starts_with = list(
				/obj/item/tank/emergency/oxygen,
				/obj/item/tank/emergency/oxygen,
				/obj/item/clothing/mask/breath,
				/obj/item/clothing/mask/breath
			)
		if("aid")
			starts_with = list(
				/obj/item/tank/emergency/oxygen,
				/obj/item/storage/toolbox/emergency,
				/obj/item/clothing/mask/breath,
				/obj/item/storage/firstaid/o2
			)
		if("tank")
			starts_with = list(
				/obj/item/tank/emergency/oxygen/engi,
				/obj/item/clothing/mask/breath,
				/obj/item/tank/emergency/oxygen/engi,
				/obj/item/clothing/mask/breath
			)
		if("both")
			starts_with = list(
				/obj/item/storage/toolbox/emergency,
				/obj/item/tank/emergency/oxygen/engi,
				/obj/item/clothing/mask/breath,
				/obj/item/storage/firstaid/o2
			)
		if("nothing")
			// doot

		// teehee - Ah, tg coders...
		if("delete")
			qdel(src)

		//If you want to re-add fire, just add "fire" = 15 to the pick list.
		/*if ("fire")
			new /obj/structure/closet/fire_safety(src.loc)
			del(src)*/

	. = ..()

/obj/structure/closet/emergency_legacy
	name = "emergency closet"
	desc = "It's a storage unit for emergency breathmasks and o2 tanks."
	icon_state = "emergency"
	icon_closed = "emergency"
	icon_opened = "emergencyopen"

	starts_with = list(
		/obj/item/tank/oxygen,
		/obj/item/clothing/mask/gas
	)

/*
 * Fire Closet
 */
/obj/structure/closet/fire_safety
	name = "fire-safety closet"
	desc = "It's a storage unit for fire-fighting supplies."
	icon_state = "firecloset"
	icon_closed = "firecloset"
	icon_opened = "fireclosetopen"

	starts_with = list(
		/obj/item/clothing/suit/fire/firefighter,
		/obj/item/clothing/mask/gas,
		/obj/item/tank/oxygen/red,
		/obj/item/fire_extinguisher,
		/obj/item/clothing/head/hardhat/red
	)

/obj/structure/closet/fire_safety/full
	starts_with = list(
		/obj/item/clothing/suit/fire/firefighter,
		/obj/item/clothing/mask/gas,
		/obj/item/flashlight,
		/obj/item/tank/oxygen/red,
		/obj/item/fire_extinguisher,
		/obj/item/clothing/head/hardhat/red
	)

/obj/structure/closet/fire_safety/update_icon()
	if(!opened)
		icon_state = icon_closed
	else
		icon_state = icon_opened

/*
 * Tool Closet
 */
/obj/structure/closet/tool
	name = "tool closet"
	desc = "It's a storage unit for tools."
	icon_state = "toolcloset"
	icon_closed = "toolcloset"
	icon_opened = "toolclosetopen"

/obj/structure/closet/tool/New()
	starts_with = list()
	if(prob(40))
		starts_with.Add(/obj/item/clothing/suit/storage/hazardvest)
	if(prob(70))
		starts_with.Add(/obj/item/flashlight)
	if(prob(70))
		starts_with.Add(/obj/item/screwdriver)
	if(prob(70))
		starts_with.Add(/obj/item/wrench)
	if(prob(70))
		starts_with.Add(/obj/item/weldingtool)
	if(prob(70))
		starts_with.Add(/obj/item/crowbar)
	if(prob(70))
		starts_with.Add(/obj/item/wirecutters)
	if(prob(70))
		starts_with.Add(/obj/item/t_scanner)
	if(prob(20))
		starts_with.Add(/obj/item/storage/belt/utility)
	if(prob(30))
		starts_with.Add(/obj/item/stack/cable_coil/random)
	if(prob(30))
		starts_with.Add(/obj/item/stack/cable_coil/random)
	if(prob(30))
		starts_with.Add(/obj/item/stack/cable_coil/random)
	if(prob(20))
		starts_with.Add(/obj/item/multitool)
	if(prob(5))
		starts_with.Add(/obj/item/clothing/gloves/yellow)
	if(prob(40))
		starts_with.Add(/obj/item/clothing/head/hardhat)
	. = ..()

/*
 * Radiation Closet
 */
/obj/structure/closet/radiation
	name = "radiation suit closet"
	desc = "It's a storage unit for rad-protective suits."
	icon_state = "radsuitcloset"
	icon_opened = "toolclosetopen"
	icon_closed = "radsuitcloset"

	starts_with = list(
		/obj/item/clothing/suit/radiation,
		/obj/item/clothing/head/radiation,
		/obj/item/clothing/suit/radiation,
		/obj/item/clothing/head/radiation
	)

/*
 * Bombsuit closet
 */
/obj/structure/closet/bomb_suit
	name = "\improper EOD closet"
	desc = "It's a storage unit for explosion-protective suits."
	icon_state = "bombsuit"
	icon_closed = "bombsuit"
	icon_opened = "bombsuitopen"

	starts_with = list(
		/obj/item/clothing/suit/bomb_suit,
		/obj/item/clothing/under/color/black,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/head/bomb_hood
	)

/obj/structure/closet/bomb_suit/security
	icon_state = "bombsuitsec"
	icon_closed = "bombsuitsec"
	icon_opened = "bombsuitsecopen"

	starts_with = list(
		/obj/item/clothing/suit/bomb_suit/security,
		/obj/item/clothing/under/rank/security,
		/obj/item/clothing/shoes/brown,
		/obj/item/clothing/head/bomb_hood/security
	)

/*
 * Hydrant
 */
/obj/structure/closet/hydrant //wall mounted fire closet
	name = "fire-safety closet"
	desc = "It's a storage unit for fire-fighting supplies."
	icon_state = "hydrant"
	icon_closed = "hydrant"
	icon_opened = "hydrant_open"
	anchored = TRUE
	density = FALSE
	wall_mounted = TRUE

	starts_with = list(
		/obj/item/clothing/suit/fire/firefighter,
		/obj/item/clothing/mask/gas,
		/obj/item/flashlight,
		/obj/item/tank/oxygen/red,
		/obj/item/fire_extinguisher,
		/obj/item/clothing/head/hardhat/red
	)

/*
 * First Aid
 */
/obj/structure/closet/medical_wall //wall mounted medical closet
	name = "first-aid closet"
	desc = "It's wall-mounted storage unit for first aid supplies."
	icon_state = "medical_wall"
	icon_closed = "medical_wall"
	icon_opened = "medical_wall_open"
	anchored = TRUE
	density = FALSE
	wall_mounted = TRUE

	starts_with = list(
		/obj/item/reagent_holder/syringe/inaprovaline,
		/obj/item/stack/medical/ointment,
		/obj/item/stack/medical/ointment,
		/obj/item/stack/medical/ointment,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/bruise_pack
	)

/obj/structure/closet/medical_wall/update_icon()
	if(!opened)
		icon_state = icon_closed
	else
		icon_state = icon_opened