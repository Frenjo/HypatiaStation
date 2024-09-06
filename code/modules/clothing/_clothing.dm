/obj/item/clothing
	name = "clothing"

	var/list/species_restricted = null // Only these species can wear this kit.

	var/can_remove = TRUE // Mostly for Ninja code at this point but basically will not allow the item to be removed if set to FALSE. /N

	var/heat_protection = 0 //flags which determine which body parts are protected from heat. Use the HEAD, UPPER_TORSO, LOWER_TORSO, etc. flags. See setup.dm
	var/cold_protection = 0 //flags which determine which body parts are protected from cold. Use the HEAD, UPPER_TORSO, LOWER_TORSO, etc. flags. See setup.dm
	var/max_heat_protection_temperature //Set this variable to determine up to which temperature (IN KELVIN) the item protects against heat damage. Keep at null to disable protection. Only protects areas set by heat_protection flags
	var/min_cold_protection_temperature //Set this variable to determine down to which temperature (IN KELVIN) the item protects against cold damage. 0 is NOT an acceptable number due to if(varname) tests!! Keep at null to disable protection. Only protects areas set by cold_protection flags

	var/armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)

	var/slowdown = 0 // How much this clothing slows you down. Negative values speed you up.

	//var/heat_transfer_coefficient = 1 //0 prevents all transfers, 1 is invisible
	var/gas_transfer_coefficient = 1 // for leaking gas from turf to mask and vice-versa (for masks right now, but at some point, i'd like to include space helmets)
	var/permeability_coefficient = 1 // for chemicals/diseases
	var/siemens_coefficient = 1 // for electrical admittance/conductance (electrocution checks and shit)

//BS12: Species-restricted clothing check.
/obj/item/clothing/mob_can_equip(mob/M, slot)
	if(species_restricted && ishuman(M))
		var/wearable = FALSE
		var/exclusive = FALSE
		var/mob/living/carbon/human/H = M

		if("exclude" in species_restricted)
			exclusive = TRUE

		if(isnotnull(H.species))
			if(exclusive)
				if(!(H.species.name in species_restricted))
					wearable = TRUE
			else
				if(H.species.name in species_restricted)
					wearable = TRUE

			if(!wearable && (slot != SLOT_ID_L_POCKET && slot != SLOT_ID_R_POCKET)) // Pockets.
				to_chat(M, SPAN_WARNING("Your species cannot wear [src]."))
				return 0

	return ..()