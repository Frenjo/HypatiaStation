/datum/hud/monkey/setup(ui_style = 'icons/hud/screen1_old.dmi')
	var/mob/living/carbon/monkey/M = owner
	var/atom/movable/screen/using
	var/atom/movable/screen/inventory/inv_box

	using = setup_screen_object("act_intent", ui_style, (M.a_intent == "hurt" ? "harm" : M.a_intent), UI_ACTI)
	using.set_dir(SOUTHWEST)
	adding.Add(using)
	action_intent = using

	// Small action intent boxes.
	adding.Add(
		new /atom/movable/screen/action_intent/help(src, ui_style),
		new /atom/movable/screen/action_intent/disarm(src, ui_style),
		new /atom/movable/screen/action_intent/grab(src, ui_style),
		new /atom/movable/screen/action_intent/harm(src, ui_style)
	)
	// End small action intent boxes.

	using = new /atom/movable/screen/move_intent()
	using.icon = ui_style
	using.icon_state = M.move_intent.hud_icon_state
	adding.Add(using)
	move_intent = using

	adding.Add(new /atom/movable/screen/action/drop(ui_style, UI_DROP_THROW))

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "r_hand"
	inv_box.set_dir(WEST)
	inv_box.icon = ui_style
	inv_box.icon_state = "hand_inactive"
	if(isnotnull(M) && !M.hand)	//This being 0 or null means the right hand is in use
		inv_box.icon_state = "hand_active"
	inv_box.screen_loc = UI_RHAND
	inv_box.slot_id = SLOT_ID_R_HAND
	r_hand_hud_object = inv_box
	adding.Add(inv_box)

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "l_hand"
	inv_box.set_dir(EAST)
	inv_box.icon = ui_style
	inv_box.icon_state = "hand_inactive"
	if(M && M.hand)	//This being 1 means the left hand is in use
		inv_box.icon_state = "hand_active"
	inv_box.screen_loc = UI_LHAND
	inv_box.slot_id = SLOT_ID_L_HAND
	l_hand_hud_object = inv_box
	adding.Add(inv_box)

	using = new /atom/movable/screen/swap_hands(ui_style, "hand1", UI_SWAPHAND1)
	adding.Add(using)

	using = new /atom/movable/screen/swap_hands(ui_style, "hand2", UI_SWAPHAND2)
	adding.Add(using)

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "mask"
	inv_box.set_dir(NORTH)
	inv_box.icon = ui_style
	inv_box.icon_state = "equip"
	inv_box.screen_loc = UI_MONKEY_MASK
	inv_box.slot_id = SLOT_ID_WEAR_MASK
	adding.Add(inv_box)

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "back"
	inv_box.set_dir(NORTHEAST)
	inv_box.icon = ui_style
	inv_box.icon_state = "equip"
	inv_box.screen_loc = UI_BACK
	inv_box.slot_id = SLOT_ID_BACK
	adding.Add(inv_box)

	M.throw_icon = new /atom/movable/screen/action/throw_icon(ui_style, UI_DROP_THROW)
	M.pullin = new /atom/movable/screen/action/pull(ui_style, UI_PULL_RESIST)

	M.oxygen = setup_screen_object("oxygen", ui_style, "oxy0", UI_OXYGEN)
	M.pressure = setup_screen_object("pressure", ui_style, "pressure0", UI_PRESSURE)
	M.toxin = setup_screen_object("toxin", ui_style, "tox0", UI_TOXIN)
	M.internals = new /atom/movable/screen/internals(ui_style)
	M.fire = setup_screen_object("fire", ui_style, "fire0", UI_FIRE)
	M.bodytemp = setup_screen_object("body temperature", ui_style, "temp1", UI_TEMP)
	M.healths = setup_screen_object("health", ui_style, "health0", UI_HEALTH)

	M.blind = new /atom/movable/screen()
	M.blind.icon = 'icons/hud/screen1_full.dmi'
	M.blind.icon_state = "blackimageoverlay"
	M.blind.name = " "
	M.blind.screen_loc = "WEST,SOUTH"
	M.blind.invisibility = INVISIBILITY_MAXIMUM // Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo

	M.flash = new /atom/movable/screen()
	M.flash.icon = ui_style
	M.flash.icon_state = "blank"
	M.flash.name = "flash"
	M.flash.screen_loc = "WEST,SOUTH to EAST,NORTH"
	M.flash.plane = FULLSCREEN_PLANE

	M.zone_sel = new /atom/movable/screen/zone_sel()
	M.zone_sel.icon = ui_style
	M.zone_sel.update_icon()

	//Handle the gun settings buttons
	M.gun_setting_icon = new /atom/movable/screen/gun/mode()
	if(isnotnull(M.client))
		if(M.client.gun_mode) // If in aim mode, correct the sprite
			M.gun_setting_icon.set_dir(2)
	for(var/obj/item/gun/G in M) // If targeting someone, display other buttons
		if(isnotnull(G.aim_targets))
			M.item_use_icon = new /atom/movable/screen/gun/item()
			if(M.client.target_can_click)
				M.item_use_icon.set_dir(1)
			adding.Add(M.item_use_icon)
			M.gun_move_icon = new /atom/movable/screen/gun/move()
			if(M.client.target_can_move)
				M.gun_move_icon.set_dir(1)
				M.gun_run_icon = new /atom/movable/screen/gun/run()
				if(M.client.target_can_run)
					M.gun_run_icon.set_dir(1)
				adding.Add(M.gun_run_icon)
			adding.Add(M.gun_move_icon)

	. = ..()
	M.client.screen.Add(list(
		M.throw_icon,
		M.zone_sel,
		M.oxygen,
		M.pressure,
		M.toxin,
		M.bodytemp,
		M.internals,
		M.fire,
		M.healths,
		M.pullin,
		M.blind,
		M.flash,
		M.gun_setting_icon
	)) //, M.hands, M.rest, M.sleep, M.mach )