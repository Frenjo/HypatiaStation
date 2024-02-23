/obj/item/clothing/mask/breath
	desc = "A close-fitting mask that can be connected to an air supply."
	name = "breath mask"
	icon_state = "breath"
	item_state = "breath"
	icon_action_button = "action_mask"
	item_flags = ITEM_FLAG_AIRTIGHT | ITEM_FLAG_COVERS_MOUTH
	w_class = 2
	gas_transfer_coefficient = 0.10
	permeability_coefficient = 0.50
	var/hanging = 0

/obj/item/clothing/mask/breath/attack_self(mob/user)
	if(user.canmove && !user.stat && !user.restrained())
		if(!hanging)
			hanging = !hanging
			gas_transfer_coefficient = 1 //gas is now escaping to the turf and vice versa
			UNSET_ITEM_FLAGS(src, (ITEM_FLAG_AIRTIGHT | ITEM_FLAG_COVERS_MOUTH))
			icon_state = "breathdown"
			to_chat(user, "Your mask is now hanging on your neck.")

		else
			hanging = !hanging
			gas_transfer_coefficient = 0.10
			SET_ITEM_FLAGS(src, (ITEM_FLAG_AIRTIGHT | ITEM_FLAG_COVERS_MOUTH))
			icon_state = "breath"
			to_chat(user, "You pull the mask up to cover your face.")
		user.update_inv_wear_mask()

/obj/item/clothing/mask/breath/medical
	desc = "A close-fitting sterile mask that can be connected to an air supply."
	name = "medical mask"
	icon_state = "medical"
	item_state = "medical"
	permeability_coefficient = 0.01

/obj/item/clothing/mask/breath/vox
	desc = "A weirdly-shaped breath mask."
	name = "vox breath mask"
	icon_state = "voxmask"
	item_state = "voxmask"
	permeability_coefficient = 0.01
	species_restricted = list(SPECIES_VOX, SPECIES_VOX_ARMALIS)
	sprite_sheets = list(
		SPECIES_VOX = 'icons/mob/species/vox/mask.dmi',
		SPECIES_VOX_ARMALIS = 'icons/mob/species/armalis/mask.dmi',
	)

/obj/item/clothing/mask/breath/vox/attack_self(mob/user)
	to_chat(user, "You can't really adjust this mask - it's moulded to your beak!")

/obj/item/clothing/mask/breath/vox/mob_can_equip(M as mob, slot)
	var/mob/living/carbon/human/V = M
	if(V.species.name != SPECIES_VOX)
		to_chat(V, SPAN_WARNING("This clearly isn't designed for your species!"))
		return 0

	return ..()