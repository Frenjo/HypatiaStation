#define NEXT_PAGE_ID "__next__"

/atom/movable/screen/radial
	icon = 'icons/hud/radial.dmi'
	layer = HUD_ABOVE_ITEM_LAYER
	mouse_over_pointer = MOUSE_HAND_POINTER

	var/datum/radial_menu/parent

/atom/movable/screen/radial/slice
	icon_state = "radial_slice"

	var/choice
	var/next_page = FALSE

/atom/movable/screen/radial/slice/MouseEntered(location, control, params)
	. = ..()
	icon_state = "radial_slice_focus"

/atom/movable/screen/radial/slice/MouseExited(location, control, params)
	. = ..()
	icon_state = "radial_slice"

/atom/movable/screen/radial/slice/Click(location, control, params)
	if(usr.client == parent.current_user)
		if(next_page)
			parent.next_page()
		else
			parent.element_chosen(choice, usr)

/atom/movable/screen/radial/centre
	name = "Close Menu"
	icon_state = "radial_centre"

/atom/movable/screen/radial/centre/MouseEntered(location, control, params)
	. = ..()
	icon_state = "radial_centre_focus"

/atom/movable/screen/radial/centre/MouseExited(location, control, params)
	. = ..()
	icon_state = "radial_centre"

/atom/movable/screen/radial/centre/Click(location, control, params)
	if(usr.client == parent.current_user)
		parent.finished = TRUE

/datum/radial_menu
	var/list/choices = list() //List of choice id's
	var/list/choices_icons = list() //choice_id -> icon
	var/list/choices_values = list() //choice_id -> choice
	var/list/page_data = list() //list of choices per page

	var/selected_choice
	var/list/atom/movable/screen/radial/elements = list()
	var/atom/movable/screen/radial/centre/close_button
	var/client/current_user
	var/atom/anchor
	var/image/menu_holder
	var/finished = FALSE

	var/radius = 32
	var/starting_angle = 0
	var/ending_angle = 360
	var/zone = 360
	var/min_angle = 45 //Defaults are setup for this value, if you want to make the menu more dense these will need changes.
	var/max_elements
	var/pages = 1
	var/current_page = 1

	var/hudfix_method = TRUE //TRUE to change anchor to user, FALSE to shift by py_shift
	var/py_shift = 0
	var/entry_animation = TRUE

//If we swap to vis_contens inventory these will need a redo
/datum/radial_menu/proc/check_screen_border(mob/user)
	var/atom/movable/mover = anchor
	if(!istype(mover) || !mover.screen_loc)
		return
	if(mover in user.client.screen)
		if(hudfix_method)
			anchor = user
		else
			py_shift = 32
			restrict_to_dir(NORTH) //I was going to parse screen loc here but that's more effort than it's worth.

//Sets defaults
//These assume 45 deg min_angle
/datum/radial_menu/proc/restrict_to_dir(dir)
	switch(dir)
		if(NORTH)
			starting_angle = 270
			ending_angle = 135
		if(SOUTH)
			starting_angle = 90
			ending_angle = 315
		if(EAST)
			starting_angle = 0
			ending_angle = 225
		if(WEST)
			starting_angle = 180
			ending_angle = 45

/datum/radial_menu/proc/setup_menu()
	if(ending_angle > starting_angle)
		zone = ending_angle - starting_angle
	else
		zone = 360 - starting_angle + ending_angle

	max_elements = round(zone / min_angle)
	var/paged = max_elements < length(choices)
	if(length(elements) < max_elements)
		var/elements_to_add = max_elements - length(elements)
		for(var/i in 1 to elements_to_add) //Create all elements
			var/atom/movable/screen/radial/new_element = new /atom/movable/screen/radial/slice()
			new_element.parent = src
			elements.Add(new_element)

	var/page = 1
	page_data = list(null)
	var/list/current = list()
	var/list/choices_left = choices.Copy()
	while(length(choices_left))
		if(length(current) == max_elements)
			page_data[page] = current
			page++
			page_data.len++
			current = list()
		if(paged && length(current) == max_elements - 1)
			current.Add(NEXT_PAGE_ID)
			continue
		else
			current.Add(popleft(choices_left))
	if(paged && length(current) < max_elements)
		current.Add(NEXT_PAGE_ID)

	page_data[page] = current
	pages = page
	current_page = 1
	update_screen_objects(anim = entry_animation)

/datum/radial_menu/proc/update_screen_objects(anim = FALSE)
	var/list/page_choices = page_data[current_page]
	var/angle_per_element = round(zone / length(page_choices))
	for(var/i in 1 to length(elements))
		var/atom/movable/screen/radial/E = elements[i]
		var/angle = WRAP(starting_angle + (i - 1) * angle_per_element, 0, 360)
		if(i > length(page_choices))
			HideElement(E)
		else
			SetElement(E, page_choices[i], angle, anim = anim, anim_order = i)

/datum/radial_menu/proc/HideElement(atom/movable/screen/radial/slice/E)
	E.cut_overlays()
	E.alpha = 0
	E.name = "None"
	E.maptext = null
	E.mouse_opacity = FALSE
	E.choice = null
	E.next_page = FALSE

/datum/radial_menu/proc/SetElement(atom/movable/screen/radial/slice/E, choice_id, angle, anim, anim_order)
	//Position
	var/py = round(cos(angle) * radius) + py_shift
	var/px = round(sin(angle) * radius)
	if(anim)
		var/timing = anim_order * 0.5
		var/matrix/starting = matrix()
		starting.Scale(0.1, 0.1)
		E.transform = starting
		var/matrix/TM = matrix()
		animate(E, pixel_x = px, pixel_y = py, transform = TM, time = timing)
	else
		E.pixel_y = py
		E.pixel_x = px

	//Visuals
	E.alpha = 255
	E.mouse_opacity = TRUE
	E.cut_overlays()
	if(choice_id == NEXT_PAGE_ID)
		E.name = "Next Page"
		E.next_page = TRUE
		E.add_overlay("radial_next")
	else
		if(istext(choices_values[choice_id]))
			E.name = choices_values[choice_id]
		else
			var/atom/movable/mover = choices_values[choice_id] //Movables only
			E.name = mover.name
		E.choice = choice_id
		E.maptext = null
		E.next_page = FALSE
		if(choices_icons[choice_id])
			E.add_overlay(choices_icons[choice_id])

/datum/radial_menu/New()
	close_button = new /atom/movable/screen/radial/centre()
	close_button.parent = src

/datum/radial_menu/proc/Reset()
	choices.Cut()
	choices_icons.Cut()
	choices_values.Cut()
	current_page = 1

/datum/radial_menu/proc/element_chosen(choice_id, mob/user)
	selected_choice = choices_values[choice_id]

/datum/radial_menu/proc/get_next_id()
	return "c_[length(choices)]"

/datum/radial_menu/proc/set_choices(list/new_choices)
	if(length(choices))
		Reset()
	for(var/E in new_choices)
		var/id = get_next_id()
		choices.Add(id)
		choices_values[id] = E
		if(isnotnull(new_choices[E]))
			var/I = extract_image(new_choices[E])
			if(isnotnull(I))
				choices_icons[id] = I
	setup_menu()

/datum/radial_menu/proc/extract_image(E)
	var/mutable_appearance/mut = new /mutable_appearance(E)
	if(isnotnull(mut))
		mut.plane = HUD_PLANE
		mut.layer = HUD_ABOVE_ITEM_LAYER
		mut.appearance_flags |= RESET_TRANSFORM
	return mut

/datum/radial_menu/proc/next_page()
	if(pages > 1)
		current_page = WRAP(current_page + 1, 1, pages + 1)
		update_screen_objects()

/datum/radial_menu/proc/show_to(mob/M)
	if(isnotnull(current_user))
		hide()
	if(isnull(M.client) || isnull(anchor))
		return
	current_user = M.client
	//Blank
	menu_holder = image(icon = 'icons/effects/effects.dmi', loc = anchor, icon_state = "nothing", layer = HUD_ABOVE_ITEM_LAYER)
	menu_holder.plane = HUD_PLANE
	menu_holder.appearance_flags |= RESET_TRANSFORM | KEEP_APART
	menu_holder.vis_contents.Add(elements + close_button)
	current_user.images.Add(menu_holder)

/datum/radial_menu/proc/hide()
	current_user?.images.Remove(menu_holder)

/datum/radial_menu/proc/wait()
	while(isnotnull(current_user) && !finished && !selected_choice)
		stoplag(1)

/datum/radial_menu/Destroy()
	Reset()
	hide()
	. = ..()
/*
	Presents radial menu to user anchored to anchor (or user if the anchor is currently in users screen)
	Choices should be a list where list keys are movables or text used for element names and return value
	and list values are movables/icons/images used for element icons
*/
/proc/show_radial_menu(mob/user, atom/anchor, list/choices)
	var/datum/radial_menu/menu = new /datum/radial_menu()
	if(isnull(user))
		user = usr
	menu.anchor = anchor
	menu.check_screen_border(user) //Do what's needed to make it look good near borders or on hud
	menu.set_choices(choices)
	menu.show_to(user)
	menu.wait()
	var/answer = menu.selected_choice
	qdel(menu)
	return answer