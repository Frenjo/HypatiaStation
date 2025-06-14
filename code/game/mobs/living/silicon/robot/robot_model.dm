/mob/living/silicon/robot/proc/pick_model()
	if(!istype(model, /obj/item/robot_model/default))
		return

	var/static/list/models = list(
		"Standard" = /obj/item/robot_model/standard,
		"Engineering" = /obj/item/robot_model/engineering,
		"Medical" = /obj/item/robot_model/medical,
		"Miner" = /obj/item/robot_model/miner,
		"Janitor" = /obj/item/robot_model/janitor,
		"Service" = /obj/item/robot_model/service,
		"Security" = /obj/item/robot_model/security,
		"Peacekeeper" = /obj/item/robot_model/peacekeeper
	)
	if(crisis && IS_SEC_LEVEL(/decl/security_level/red)) // Leaving this in until it's balanced appropriately.
		to_chat(src, SPAN_WARNING("Crisis mode active. Combat model available."))
		models["Combat"] = /obj/item/robot_model/combat

	var/static/list/radial_models = null
	if(isnull(radial_models))
		radial_models = list()
		for(var/model_type in models)
			var/obj/item/robot_model/temp_model = models[model_type]
			var/temp_sprite_path = temp_model::sprite_path
			var/temp_state = temp_model::model_select_sprite
			var/image/radial_button = image(icon = temp_sprite_path, icon_state = temp_state)
			radial_button.add_overlay(image(icon = temp_sprite_path, icon_state = "eyes-[temp_state]"))
			radial_models[model_type] = radial_button
	var/input_model = show_radial_menu(src, src, radial_models)
	if(isnull(input_model))
		return

	transform_to_model(models[input_model])

/mob/living/silicon/robot/proc/transform_to_model(model_path)
	model = new model_path(src)

	// Resets pass flags, currently only modified by swarmer borgs.
	pass_flags = initial(pass_flags)

	// Performs model-specific on-transform actions.
	model.on_transform_to(src)

	// Camera networks
	if(isnotnull(camera) && ("Robots" in camera.network))
		for(var/network in model.camera_networks)
			camera.network.Add(network)

	// Languages
	model.add_languages(src)

	// Pushable status
	if(!model.can_be_pushed)
		status_flags &= ~CANPUSH

	// Displays the playstyle string if applicable.
	var/playstyle_string = model.get_playstyle_string()
	if(isnotnull(playstyle_string))
		to_chat(src, playstyle_string)

	// Custom_sprite check and entry.
	if(custom_sprite)
		model.sprites["Custom"] = "[ckey]-[model.display_name]"

	// If the model's icon is set explicitly then use that, otherwise use the display name.
	var/model_icon = model.model_icon
	if(isnull(model_icon))
		model_icon = lowertext(model.display_name)
	hands?.icon_state = model_icon
	feedback_inc("cyborg_[lowertext(model.display_name)]", 1)
	updatename()

	icon_state = model.sprites[model.sprites[1]]
	choose_icon(model.sprites)
	radio.config(model.channels)

/mob/living/silicon/robot/proc/choose_icon(list/model_sprites)
	set waitfor = FALSE
	if(!length(model_sprites))
		to_chat(src, "Something is badly wrong with the sprite selection. Harass a coder.")
		return

	var/icontype
	if(custom_sprite)
		icontype = "Custom"
	else
		var/list/options = list()
		for(var/sprite_name in model_sprites)
			var/image/radial_button = image(icon = model.sprite_path, icon_state = model_sprites[sprite_name])
			radial_button.add_overlay(image(icon = model.sprite_path, icon_state = "eyes-[model_sprites[sprite_name]]"))
			options[sprite_name] = radial_button
		icontype = show_radial_menu(src, src, options)

	if(icontype)
		icon_state = model_sprites[icontype]
	else
		icon_state = model_sprites[model_sprites[1]]

	remove_overlay("eyes")
	updateicon()
	to_chat(src, "Your icon has been set. You now require a model reset to change it.")

/mob/living/silicon/robot/proc/installed_modules()
	if(weapon_lock)
		to_chat(src, SPAN_WARNING("Weapon lock active, unable to use modules! Count: [weaponlock_time]."))
		return

	if(istype(model, /obj/item/robot_model/default))
		pick_model()
		return
	var/dat = "<HEAD><TITLE>Modules</TITLE><META HTTP-EQUIV='Refresh' CONTENT='10'></HEAD><BODY>\n"
	dat += {"<A href='byond://?src=\ref[src];mach_close=robotmod'>Close</A>
	<BR>
	<BR>
	<B>Activated Modules</B>
	<BR>
	Module 1: [module_state_1 ? "<A href='byond://?src=\ref[src];mod=\ref[module_state_1]'>[module_state_1]</A>" : "No Module"]<BR>
	Module 2: [module_state_2 ? "<A href='byond://?src=\ref[src];mod=\ref[module_state_2]'>[module_state_2]</A>" : "No Module"]<BR>
	Module 3: [module_state_3 ? "<A href='byond://?src=\ref[src];mod=\ref[module_state_3]'>[module_state_3]</A>" : "No Module"]<BR>
	<BR>
	<B>Installed Modules</B><BR><BR>"}

	for(var/obj in model.modules)
		if(!obj)
			dat += "<B>Resource depleted</B><BR>"
		else if(activated(obj))
			dat += "[obj]: <B>Activated</B><BR>"
		else
			dat += "[obj]: <A href='byond://?src=\ref[src];act=\ref[obj]'>Activate</A><BR>"

	src << browse(dat, "window=robotmod&can_close=0")