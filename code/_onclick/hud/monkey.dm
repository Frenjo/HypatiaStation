/datum/hud/proc/monkey_hud(ui_style = 'icons/mob/screen/screen1_old.dmi')
	adding = list()
	other = list()

	var/atom/movable/screen/using
	var/atom/movable/screen/inventory/inv_box

	using = new /atom/movable/screen()
	using.name = "act_intent"
	using.set_dir(SOUTHWEST)
	using.icon = ui_style
	using.icon_state = (mymob.a_intent == "hurt" ? "harm" : mymob.a_intent)
	using.screen_loc = UI_ACTI
	adding.Add(using)
	action_intent = using

	// Small action intent boxes.
	using = new /atom/movable/screen/action_intent/help(src, ui_style)
	adding.Add(using)
	intent_buttons["help"] = using

	using = new /atom/movable/screen/action_intent/disarm(src, ui_style)
	adding.Add(using)
	intent_buttons["disarm"] = using

	using = new /atom/movable/screen/action_intent/grab(src, ui_style)
	adding.Add(using)
	intent_buttons["grab"] = using

	using = new /atom/movable/screen/action_intent/harm(src, ui_style)
	adding.Add(using)
	intent_buttons["harm"] = using
	// End small action intent boxes.

	using = new /atom/movable/screen/move_intent()
	using.icon = ui_style
	using.icon_state = mymob.move_intent.hud_icon_state
	adding.Add(using)
	move_intent = using

	using = new /atom/movable/screen()
	using.name = "drop"
	using.icon = ui_style
	using.icon_state = "act_drop"
	using.screen_loc = UI_DROP_THROW
	adding.Add(using)

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "r_hand"
	inv_box.set_dir(WEST)
	inv_box.icon = ui_style
	inv_box.icon_state = "hand_inactive"
	if(isnotnull(mymob) && !mymob.hand)	//This being 0 or null means the right hand is in use
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
	if(mymob && mymob.hand)	//This being 1 means the left hand is in use
		inv_box.icon_state = "hand_active"
	inv_box.screen_loc = UI_LHAND
	inv_box.slot_id = SLOT_ID_L_HAND
	l_hand_hud_object = inv_box
	adding.Add(inv_box)

	using = new /atom/movable/screen()
	using.name = "hand"
	using.set_dir(SOUTH)
	using.icon = ui_style
	using.icon_state = "hand1"
	using.screen_loc = UI_SWAPHAND1
	adding.Add(using)

	using = new /atom/movable/screen()
	using.name = "hand"
	using.set_dir(SOUTH)
	using.icon = ui_style
	using.icon_state = "hand2"
	using.screen_loc = UI_SWAPHAND2
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

	mymob.throw_icon = new /atom/movable/screen()
	mymob.throw_icon.icon = ui_style
	mymob.throw_icon.icon_state = "act_throw_off"
	mymob.throw_icon.name = "throw"
	mymob.throw_icon.screen_loc = UI_DROP_THROW

	mymob.oxygen = new /atom/movable/screen()
	mymob.oxygen.icon = ui_style
	mymob.oxygen.icon_state = "oxy0"
	mymob.oxygen.name = "oxygen"
	mymob.oxygen.screen_loc = UI_OXYGEN

	mymob.pressure = new /atom/movable/screen()
	mymob.pressure.icon = ui_style
	mymob.pressure.icon_state = "pressure0"
	mymob.pressure.name = "pressure"
	mymob.pressure.screen_loc = UI_PRESSURE

	mymob.toxin = new /atom/movable/screen()
	mymob.toxin.icon = ui_style
	mymob.toxin.icon_state = "tox0"
	mymob.toxin.name = "toxin"
	mymob.toxin.screen_loc = UI_TOXIN

	mymob.internals = new /atom/movable/screen()
	mymob.internals.icon = ui_style
	mymob.internals.icon_state = "internal0"
	mymob.internals.name = "internal"
	mymob.internals.screen_loc = UI_INTERNAL

	mymob.fire = new /atom/movable/screen()
	mymob.fire.icon = ui_style
	mymob.fire.icon_state = "fire0"
	mymob.fire.name = "fire"
	mymob.fire.screen_loc = UI_FIRE

	mymob.bodytemp = new /atom/movable/screen()
	mymob.bodytemp.icon = ui_style
	mymob.bodytemp.icon_state = "temp1"
	mymob.bodytemp.name = "body temperature"
	mymob.bodytemp.screen_loc = UI_TEMP

	mymob.healths = new /atom/movable/screen()
	mymob.healths.icon = ui_style
	mymob.healths.icon_state = "health0"
	mymob.healths.name = "health"
	mymob.healths.screen_loc = UI_HEALTH

	mymob.pullin = new /atom/movable/screen()
	mymob.pullin.icon = ui_style
	mymob.pullin.icon_state = "pull0"
	mymob.pullin.name = "pull"
	mymob.pullin.screen_loc = UI_PULL_RESIST

	mymob.blind = new /atom/movable/screen()
	mymob.blind.icon = 'icons/mob/screen/screen1_full.dmi'
	mymob.blind.icon_state = "blackimageoverlay"
	mymob.blind.name = " "
	mymob.blind.screen_loc = "1,1"
	mymob.blind.invisibility = INVISIBILITY_MAXIMUM // Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo

	mymob.flash = new /atom/movable/screen()
	mymob.flash.icon = ui_style
	mymob.flash.icon_state = "blank"
	mymob.flash.name = "flash"
	mymob.flash.screen_loc = "1,1 to 15,15"
	mymob.flash.plane = FULLSCREEN_PLANE

	mymob.zone_sel = new /atom/movable/screen/zone_sel()
	mymob.zone_sel.icon = ui_style
	mymob.zone_sel.update_icon()

	//Handle the gun settings buttons
	mymob.gun_setting_icon = new /atom/movable/screen/gun/mode()
	if(isnotnull(mymob.client))
		if(mymob.client.gun_mode) // If in aim mode, correct the sprite
			mymob.gun_setting_icon.set_dir(2)
	for(var/obj/item/gun/G in mymob) // If targeting someone, display other buttons
		if(isnotnull(G.target))
			mymob.item_use_icon = new /atom/movable/screen/gun/item()
			if(mymob.client.target_can_click)
				mymob.item_use_icon.set_dir(1)
			adding.Add(mymob.item_use_icon)
			mymob.gun_move_icon = new /atom/movable/screen/gun/move()
			if(mymob.client.target_can_move)
				mymob.gun_move_icon.set_dir(1)
				mymob.gun_run_icon = new /atom/movable/screen/gun/run()
				if(mymob.client.target_can_run)
					mymob.gun_run_icon.set_dir(1)
				adding.Add(mymob.gun_run_icon)
			adding.Add(mymob.gun_move_icon)

	mymob.client.screen.Cut()
	mymob.client.screen.Add(list(
		mymob.throw_icon,
		mymob.zone_sel,
		mymob.oxygen,
		mymob.pressure,
		mymob.toxin,
		mymob.bodytemp,
		mymob.internals,
		mymob.fire,
		mymob.healths,
		mymob.pullin,
		mymob.blind,
		mymob.flash,
		mymob.gun_setting_icon
	)) //, mymob.hands, mymob.rest, mymob.sleep, mymob.mach )
	mymob.client.screen.Add(adding + other)