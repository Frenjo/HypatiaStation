// The monolithic updateicon() method.
/mob/living/silicon/robot/updateicon()
	overlays.Cut()
	if(!custom_sprite)
		if(isnotnull(model?.sprite_path))
			icon = model.sprite_path
		else
			icon = initial(icon)

	if(stat == CONSCIOUS)
		// Sets up the robot's eye overlay appearance if not done already.
		if(isnull(eye_lights))
			eye_lights = new /mutable_appearance()
		eye_lights.icon = icon
		eye_lights.icon_state = "eyes-[icon_state]"
		eye_lights.plane = ABOVE_DEFAULT_PLANE
		eye_lights.color = COLOR_WHITE
		eye_lights.appearance_flags = PIXEL_SCALE
		overlays.Add(eye_lights)
	else
		overlays.Remove(eye_lights)

	if(opened && custom_sprite) // Custom borgs also have custom panels, heh.
		if(wiresexposed)
			overlays.Add("[ckey]-openpanel +w")
		else if(cell)
			overlays.Add("[ckey]-openpanel +c")
		else
			overlays.Add("[ckey]-openpanel -c")

	if(opened)
		if(wiresexposed)
			overlays.Add(image('icons/mob/silicon/robot/overlays.dmi', "ov-openpanel +w"))
		else if(cell)
			overlays.Add(image('icons/mob/silicon/robot/overlays.dmi', "ov-openpanel +c"))
		else
			overlays.Add(image('icons/mob/silicon/robot/overlays.dmi', "ov-openpanel -c"))

	if(module_active && istype(module_active, /obj/item/robot_module/combat_shield))
		overlays.Add("[icon_state]-shield")

	if(istype(model, /obj/item/robot_model/combat))
		var/base_icon = ""
		base_icon = icon_state
		if(module_active && istype(module_active, /obj/item/robot_module/combat_mobility))
			icon_state = "[icon_state]-roll"
		else
			icon_state = base_icon

	if(istype(model, /obj/item/robot_model/miner) && isnotnull(internals))
		overlays.Add("jetpack-[icon_state]")

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