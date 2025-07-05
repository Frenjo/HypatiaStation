/*
 * Plastic
 */
/obj/structure/closet/crate/plastic
	name = "plastic crate"
	desc = "A rectangular plastic crate."
	icon_state = "plasticcrate"
	icon_opened = "plasticcrateopen"
	icon_closed = "plasticcrate"

/*
 * Internals
 */
/obj/structure/closet/crate/internals
	desc = "A internals crate."
	name = "internals crate"
	icon_state = "o2crate"
	icon_opened = "o2crateopen"
	icon_closed = "o2crate"

/*
 * Trash Cart
 */
/obj/structure/closet/crate/trashcart
	desc = "A heavy, metal trashcart with wheels."
	name = "trash cart"
	icon_state = "trashcart"
	icon_opened = "trashcartopen"
	icon_closed = "trashcart"

/*these aren't needed anymore
/obj/structure/closet/crate/hat
	desc = "A crate filled with Valuable Collector's Hats!."
	name = "hat crate"
	icon_state = "crate"
	icon_opened = "crateopen"
	icon_closed = "crate"

/obj/structure/closet/crate/contraband
	name = "poster crate"
	desc = "A random assortment of posters manufactured by providers NOT listed under Nanotrasen's whitelist."
	icon_state = "crate"
	icon_opened = "crateopen"
	icon_closed = "crate"
*/

/*
 * Medical
 */
/obj/structure/closet/crate/medical
	desc = "A medical crate."
	name = "medical crate"
	icon_state = "medicalcrate"
	icon_opened = "medicalcrateopen"
	icon_closed = "medicalcrate"

/*
 * RCD
 */
/obj/structure/closet/crate/rcd
	desc = "A crate for the storage of the RCD."
	name = "\improper RCD crate"
	icon_state = "crate"
	icon_opened = "crateopen"
	icon_closed = "crate"

	starts_with = list(
		/obj/item/rcd_ammo,
		/obj/item/rcd_ammo,
		/obj/item/rcd_ammo,
		/obj/item/rcd
	)

/*
 * Solar
 */
/obj/structure/closet/crate/solar
	name = "solar pack crate"

	starts_with = list(
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/solar_assembly,
		/obj/item/circuitboard/solar_control,
		/obj/item/tracker_electronics,
		/obj/item/paper/solar
	)

/*
 * Freezer
 */
/obj/structure/closet/crate/freezer
	desc = "A freezer."
	name = "freezer"
	icon_state = "freezer"
	icon_opened = "freezeropen"
	icon_closed = "freezer"

	var/target_temp = T0C - 40
	var/cooling_power = 40

/obj/structure/closet/crate/freezer/return_air()
	var/datum/gas_mixture/gas = (..())
	if(!gas)
		return null
	var/datum/gas_mixture/newgas = new/datum/gas_mixture()
	newgas.copy_from(gas)
	newgas.temperature = gas.temperature
	if(newgas.temperature <= target_temp)
		return

	if((newgas.temperature - cooling_power) > target_temp)
		newgas.temperature -= cooling_power
	else
		newgas.temperature = target_temp
	return newgas

/*
 * Rations Freezer
 */
/obj/structure/closet/crate/freezer/rations //Fpr use in the escape shuttle
	desc = "A crate of emergency rations."
	name = "emergency rations"

	starts_with = list(
		/obj/item/storage/box/donkpockets,
		/obj/item/storage/box/donkpockets
	)

/*
 * Bin
 */
/obj/structure/closet/crate/bin
	desc = "A large bin."
	name = "large bin"
	icon_state = "largebin"
	icon_opened = "largebinopen"
	icon_closed = "largebin"

/*
 * Radiation
 */
/obj/structure/closet/crate/radiation
	name = "radioactive gear crate"
	desc = "A crate with a radiation sign on it. For the love of god, use protection."
	icon_state = "radiation"
	icon_opened = "radiationopen"
	icon_closed = "radiation"

	starts_with = list(
		/obj/item/clothing/suit/radiation,
		/obj/item/clothing/suit/radiation,
		/obj/item/clothing/suit/radiation,
		/obj/item/clothing/suit/radiation,
		/obj/item/clothing/suit/radiation,
		/obj/item/clothing/suit/radiation,
		/obj/item/clothing/suit/radiation,
		/obj/item/clothing/suit/radiation
	)

/*
 * Large
 */
/obj/structure/closet/crate/large
	name = "large crate"
	desc = "A hefty metal crate."
	icon_state = "largemetal"
	icon_opened = "largemetalopen"
	icon_closed = "largemetal"

/obj/structure/closet/crate/large/close()
	. = ..()
	if(.)//we can hold up to one large item
		var/found = 0
		for(var/obj/structure/S in src.loc)
			if(S == src)
				continue
			if(!S.anchored)
				found = 1
				S.forceMove(src)
				break
		if(!found)
			for(var/obj/machinery/M in src.loc)
				if(!M.anchored)
					M.forceMove(src)
					break
	return

/*
 * Hydroponics
 */
/obj/structure/closet/crate/hydroponics
	name = "hydroponics crate"
	desc = "All you need to destroy those pesky weeds and pests."
	icon_state = "hydrocrate"
	icon_opened = "hydrocrateopen"
	icon_closed = "hydrocrate"

/obj/structure/closet/crate/hydroponics/prespawned
	//This exists so the prespawned hydro crates spawn with their contents.
	starts_with = list(
		/obj/item/reagent_holder/spray/plantbgone,
		/obj/item/reagent_holder/spray/plantbgone,
		/obj/item/minihoe,
	//	/obj/item/weedspray,
	//	/obj/item/weedspray,
	//	/obj/item/pestspray,
	//	/obj/item/pestspray,
	//	/obj/item/pestspray
	)