// The monolithic updateicon() method.
/mob/living/silicon/robot/updateicon()
	cut_overlays()
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
		add_overlay(eye_lights)
	else
		remove_overlay(eye_lights)

	if(opened && custom_sprite) // Custom borgs also have custom panels, heh.
		if(wiresexposed)
			add_overlay("[ckey]-openpanel +w")
		else if(cell)
			add_overlay("[ckey]-openpanel +c")
		else
			add_overlay("[ckey]-openpanel -c")

	if(opened)
		if(wiresexposed)
			add_overlay(image('icons/mob/silicon/robot/overlays.dmi', "ov-openpanel +w"))
		else if(cell)
			add_overlay(image('icons/mob/silicon/robot/overlays.dmi', "ov-openpanel +c"))
		else
			add_overlay(image('icons/mob/silicon/robot/overlays.dmi', "ov-openpanel -c"))

	if(module_active && istype(module_active, /obj/item/robot_module/combat_shield))
		add_overlay("[icon_state]-shield")

	if(istype(model, /obj/item/robot_model/combat))
		var/base_icon = ""
		base_icon = icon_state
		if(module_active && istype(module_active, /obj/item/robot_module/combat_mobility))
			icon_state = "[icon_state]-roll"
		else
			icon_state = base_icon

	if(istype(model, /obj/item/robot_model/miner) && isnotnull(internals))
		add_overlay("jetpack-[icon_state]")