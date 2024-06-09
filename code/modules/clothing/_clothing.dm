/obj/item/clothing
	name = "clothing"

	var/list/species_restricted = null //Only these species can wear this kit.

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