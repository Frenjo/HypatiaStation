//Most of these are defined at this level to reduce on checks elsewhere in the code.
//Having them here also makes for a nice reference list of the various overlay-updating procs available

/mob/proc/regenerate_icons()		//TODO: phase this out completely if possible
	return

/mob/proc/update_icons()
	return

/mob/proc/update_hud()
	return

/mob/proc/update_inv_handcuffed()
	return

/mob/proc/update_inv_legcuffed()
	return

/mob/proc/update_inv_back()
	return

/mob/proc/update_inv_l_hand()
	return

/mob/proc/update_inv_r_hand()
	return

/mob/proc/update_inv_wear_mask()
	return

/mob/proc/update_inv_wear_suit()
	return

/mob/proc/update_inv_wear_uniform()
	return

/mob/proc/update_inv_belt()
	return

/mob/proc/update_inv_head()
	return

/mob/proc/update_inv_gloves()
	return

/mob/proc/update_mutations()
	return

/mob/proc/update_inv_id_store()
	return

/mob/proc/update_inv_shoes()
	return

/mob/proc/update_inv_glasses()
	return

/mob/proc/update_inv_suit_store()
	return

/mob/proc/update_inv_pockets()
	return

/mob/proc/update_inv_ears()
	return

/mob/proc/update_targeted()
	return

// Updates the size of a mob by resize amount.
/mob/proc/update_transform(resize = RESIZE_DEFAULT_SIZE)
	if(resize == RESIZE_DEFAULT_SIZE)
		return

	var/matrix/new_transform = matrix(transform) //aka transform.Copy()
	var/current_translation = get_transform_translation_size(current_size)
	var/changed = FALSE

	if(resize != RESIZE_DEFAULT_SIZE)
		changed = TRUE
		var/new_translation = get_transform_translation_size(resize * current_size)
		if(current_translation) // Scaling also affects translation, so undo the old one beforehand.
			new_transform.Translate(0, -current_translation)
		// Applies the new translation.
		new_transform.Scale(resize)
		current_size *= resize
		if(new_translation)
			new_transform.Translate(0, new_translation)

	if(!changed) // If nothing changed, we don't need to go any further!
		return

	animate(src, transform = new_transform, time = 2, easing = EASE_IN | EASE_OUT)

// Calculates how far vertically the mob's transform should translate according to its size.
/mob/proc/get_transform_translation_size(size)
	return (size - RESIZE_DEFAULT_SIZE) * 16