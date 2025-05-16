// This is currently only used for expander modules but will be updated and generalised later.
/mob/living/silicon/robot/proc/update_transform(resize = RESIZE_DEFAULT_SIZE)
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
/mob/living/silicon/robot/proc/get_transform_translation_size(size)
	return (size - RESIZE_DEFAULT_SIZE) * 16