/datum/hud/proc/human_hud(ui_style = 'icons/mob/screen/screen1_White.dmi', ui_color = "#ffffff", ui_alpha = 255, mob/living/carbon/human/target)
	var/datum/hud_data/hud_data
	if(!istype(target))
		hud_data = new /datum/hud_data()
	else
		hud_data = target.species.hud

	if(hud_data.icon)
		ui_style = hud_data.icon

	adding = list()
	other = list()
	hotkeybuttons = list() //These can be disabled for hotkey usersx

	var/list/hud_elements = list()
	var/obj/screen/using
	var/obj/screen/inventory/inv_box

	// Draw the various inventory equipment slots.
	var/has_hidden_gear
	for(var/gear_slot in hud_data.gear)
		inv_box = new /obj/screen/inventory()
		inv_box.icon = ui_style
		inv_box.color = ui_color
		inv_box.alpha = ui_alpha

		var/list/slot_data = hud_data.gear[gear_slot]
		inv_box.name = gear_slot
		inv_box.screen_loc = slot_data["loc"]
		inv_box.slot_id = slot_data["slot"]
		inv_box.icon_state = slot_data["state"]

		if(slot_data["dir"])
			inv_box.set_dir(slot_data["dir"])

		if(slot_data["toggle"])
			other.Add(inv_box)
			has_hidden_gear = 1
		else
			adding.Add(inv_box)

	if(has_hidden_gear)
		using = new /obj/screen()
		using.name = "toggle"
		using.icon = ui_style
		using.icon_state = "other"
		using.screen_loc = UI_INVENTORY
		using.color = ui_color
		using.alpha = ui_alpha
		adding.Add(using)

	// Draw the attack intent dialogue.
	if(hud_data.has_a_intent)
		using = new /obj/screen()
		using.name = "act_intent"
		using.set_dir(SOUTHWEST)
		using.icon = ui_style
		using.icon_state = "intent_" + mymob.a_intent
		using.screen_loc = UI_ACTI
		using.color = ui_color
		using.alpha = ui_alpha
		adding.Add(using)
		action_intent = using

		hud_elements |= using

		//intent small hud objects
		var/icon/ico

		ico = new /icon(ui_style, "black")
		ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
		ico.DrawBox(rgb(255, 255, 255, 1), 1, ico.Height() / 2, ico.Width() / 2, ico.Height())
		using = new /obj/screen(src)
		using.name = "help"
		using.icon = ico
		using.screen_loc = UI_ACTI
		using.alpha = ui_alpha
		adding.Add(using)
		intent_buttons["help"] = using

		ico = new /icon(ui_style, "black")
		ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
		ico.DrawBox(rgb(255, 255, 255, 1), ico.Width() / 2, ico.Height() / 2, ico.Width(), ico.Height())
		using = new /obj/screen(src)
		using.name = "disarm"
		using.icon = ico
		using.screen_loc = UI_ACTI
		using.alpha = ui_alpha
		adding.Add(using)
		intent_buttons["disarm"] = using

		ico = new /icon(ui_style, "black")
		ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
		ico.DrawBox(rgb(255, 255, 255, 1), ico.Width() / 2, 1, ico.Width(), ico.Height() / 2)
		using = new /obj/screen(src)
		using.name = "grab"
		using.icon = ico
		using.screen_loc = UI_ACTI
		using.alpha = ui_alpha
		adding.Add(using)
		intent_buttons["grab"] = using

		ico = new /icon(ui_style, "black")
		ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
		ico.DrawBox(rgb(255, 255, 255, 1), 1, 1, ico.Width() / 2, ico.Height() / 2)
		using = new /obj/screen(src)
		using.name = "harm"
		using.icon = ico
		using.screen_loc = UI_ACTI
		using.alpha = ui_alpha
		adding.Add(using)
		intent_buttons["harm"] = using
		//end intent small hud objects

	if(hud_data.has_m_intent)
		using = new /obj/screen()
		using.name = "mov_intent"
		using.set_dir(SOUTHWEST)
		using.icon = ui_style
		using.icon_state = mymob.move_intent.hud_icon_state
		using.screen_loc = UI_MOVI
		using.color = ui_color
		using.alpha = ui_alpha
		adding.Add(using)
		move_intent = using

	if(hud_data.has_drop)
		using = new /obj/screen()
		using.name = "drop"
		using.icon = ui_style
		using.icon_state = "act_drop"
		using.screen_loc = UI_DROP_THROW
		using.color = ui_color
		using.alpha = ui_alpha
		hotkeybuttons.Add(using)

	if(hud_data.has_hands)
		using = new /obj/screen()
		using.name = "equip"
		using.icon = ui_style
		using.icon_state = "act_equip"
		using.screen_loc = UI_EQUIP
		using.color = ui_color
		using.alpha = ui_alpha
		adding.Add(using)

		inv_box = new /obj/screen/inventory()
		inv_box.name = "r_hand"
		inv_box.set_dir(WEST)
		inv_box.icon = ui_style
		inv_box.icon_state = "hand_inactive"
		if(isnotnull(mymob) && !mymob.hand)	//This being 0 or null means the right hand is in use
			inv_box.icon_state = "hand_active"
		inv_box.screen_loc = UI_RHAND
		inv_box.slot_id = SLOT_ID_R_HAND
		inv_box.color = ui_color
		inv_box.alpha = ui_alpha

		r_hand_hud_object = inv_box
		adding.Add(inv_box)

		inv_box = new /obj/screen/inventory()
		inv_box.name = "l_hand"
		inv_box.set_dir(EAST)
		inv_box.icon = ui_style
		inv_box.icon_state = "hand_inactive"
		if(isnotnull(mymob) && mymob.hand)	//This being 1 means the left hand is in use
			inv_box.icon_state = "hand_active"
		inv_box.screen_loc = UI_LHAND
		inv_box.slot_id = SLOT_ID_L_HAND
		inv_box.color = ui_color
		inv_box.alpha = ui_alpha
		l_hand_hud_object = inv_box
		adding.Add(inv_box)

		using = new /obj/screen/inventory()
		using.name = "hand"
		using.set_dir(SOUTH)
		using.icon = ui_style
		using.icon_state = "hand1"
		using.screen_loc = UI_SWAPHAND1
		using.color = ui_color
		using.alpha = ui_alpha
		adding.Add(using)

		using = new /obj/screen/inventory()
		using.name = "hand"
		using.set_dir(SOUTH)
		using.icon = ui_style
		using.icon_state = "hand2"
		using.screen_loc = UI_SWAPHAND2
		using.color = ui_color
		using.alpha = ui_alpha
		adding.Add(using)

	if(hud_data.has_resist)
		using = new /obj/screen()
		using.name = "resist"
		using.icon = ui_style
		using.icon_state = "act_resist"
		using.screen_loc = UI_PULL_RESIST
		using.color = ui_color
		using.alpha = ui_alpha
		hotkeybuttons.Add(using)

	if(hud_data.has_throw)
		mymob.throw_icon = new /obj/screen()
		mymob.throw_icon.icon = ui_style
		mymob.throw_icon.icon_state = "act_throw_off"
		mymob.throw_icon.name = "throw"
		mymob.throw_icon.screen_loc = UI_DROP_THROW
		mymob.throw_icon.color = ui_color
		mymob.throw_icon.alpha = ui_alpha
		hotkeybuttons.Add(mymob.throw_icon)
		hud_elements |= mymob.throw_icon

		mymob.pullin = new /obj/screen()
		mymob.pullin.icon = ui_style
		mymob.pullin.icon_state = "pull0"
		mymob.pullin.name = "pull"
		mymob.pullin.screen_loc = UI_PULL_RESIST
		hotkeybuttons.Add(mymob.pullin)
		hud_elements |= mymob.pullin

	if(hud_data.has_internals)
		mymob.internals = new /obj/screen()
		mymob.internals.icon = ui_style
		mymob.internals.icon_state = "internal0"
		mymob.internals.name = "internal"
		mymob.internals.screen_loc = UI_INTERNAL
		hud_elements |= mymob.internals

	if(hud_data.has_warnings)
		mymob.oxygen = new /obj/screen()
		mymob.oxygen.icon = ui_style
		mymob.oxygen.icon_state = "oxy0"
		mymob.oxygen.name = "oxygen"
		mymob.oxygen.screen_loc = UI_OXYGEN
		hud_elements |= mymob.oxygen

		mymob.toxin = new /obj/screen()
		mymob.toxin.icon = ui_style
		mymob.toxin.icon_state = "tox0"
		mymob.toxin.name = "toxin"
		mymob.toxin.screen_loc = UI_TOXIN
		hud_elements |= mymob.toxin

		mymob.fire = new /obj/screen()
		mymob.fire.icon = ui_style
		mymob.fire.icon_state = "fire0"
		mymob.fire.name = "fire"
		mymob.fire.screen_loc = UI_FIRE
		hud_elements |= mymob.fire

		mymob.healths = new /obj/screen()
		mymob.healths.icon = ui_style
		mymob.healths.icon_state = "health0"
		mymob.healths.name = "health"
		mymob.healths.screen_loc = UI_HEALTH
		hud_elements |= mymob.healths

	if(hud_data.has_pressure)
		mymob.pressure = new /obj/screen()
		mymob.pressure.icon = ui_style
		mymob.pressure.icon_state = "pressure0"
		mymob.pressure.name = "pressure"
		mymob.pressure.screen_loc = UI_PRESSURE
		hud_elements |= mymob.pressure

	if(hud_data.has_bodytemp)
		mymob.bodytemp = new /obj/screen()
		mymob.bodytemp.icon = ui_style
		mymob.bodytemp.icon_state = "temp1"
		mymob.bodytemp.name = "body temperature"
		mymob.bodytemp.screen_loc = UI_TEMP
		hud_elements |= mymob.bodytemp

	if(hud_data.has_nutrition)
		mymob.nutrition_icon = new /obj/screen()
		mymob.nutrition_icon.icon = ui_style
		mymob.nutrition_icon.icon_state = "nutrition0"
		mymob.nutrition_icon.name = "nutrition"
		mymob.nutrition_icon.screen_loc = UI_NUTRITION
		hud_elements |= mymob.nutrition_icon

	mymob.blind = new /obj/screen()
	mymob.blind.icon = 'icons/mob/screen/screen1_full.dmi'
	mymob.blind.icon_state = "blackimageoverlay"
	mymob.blind.name = " "
	mymob.blind.screen_loc = "1,1"
	mymob.blind.mouse_opacity = FALSE
	mymob.blind.invisibility = INVISIBILITY_MAXIMUM // Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo
	hud_elements |= mymob.blind

	mymob.damageoverlay = new /obj/screen()
	mymob.damageoverlay.icon = 'icons/mob/screen/screen1_full.dmi'
	mymob.damageoverlay.icon_state = "oxydamageoverlay0"
	mymob.damageoverlay.name = "dmg"
	mymob.damageoverlay.screen_loc = "1,1"
	mymob.damageoverlay.mouse_opacity = FALSE
	mymob.damageoverlay.layer = 18.1 //The black screen overlay sets layer to 18 to display it, this one has to be just on top.
	hud_elements |= mymob.damageoverlay

	mymob.flash = new /obj/screen()
	mymob.flash.icon = ui_style
	mymob.flash.icon_state = "blank"
	mymob.flash.name = "flash"
	mymob.flash.screen_loc = "1,1 to 15,15"
	mymob.flash.mouse_opacity = FALSE
	mymob.flash.plane = FULLSCREEN_PLANE
	hud_elements |= mymob.flash

	mymob.pain = new /obj/screen(null)

	mymob.zone_sel = new /obj/screen/zone_sel()
	mymob.zone_sel.icon = ui_style
	mymob.zone_sel.color = ui_color
	mymob.zone_sel.alpha = ui_alpha
	mymob.zone_sel.update_icon()
	hud_elements |= mymob.zone_sel

	//Handle the gun settings buttons
	mymob.gun_setting_icon = new /obj/screen/gun/mode()
	hud_elements |= mymob.gun_setting_icon
	if(isnotnull(mymob.client))
		if(mymob.client.gun_mode) // If in aim mode, correct the sprite
			mymob.gun_setting_icon.set_dir(2)
	for(var/obj/item/gun/G in mymob) // If targeting someone, display other buttons
		if(isnotnull(G.target))
			mymob.item_use_icon = new /obj/screen/gun/item()
			if(mymob.client.target_can_click)
				mymob.item_use_icon.set_dir(1)
			adding.Add(mymob.item_use_icon)
			mymob.gun_move_icon = new /obj/screen/gun/move()
			if(mymob.client.target_can_move)
				mymob.gun_move_icon.set_dir(1)
				mymob.gun_run_icon = new /obj/screen/gun/run()
				if(mymob.client.target_can_run)
					mymob.gun_run_icon.set_dir(1)
				adding.Add(mymob.gun_run_icon)
			adding.Add(mymob.gun_move_icon)

	mymob.client.screen.Cut()
	mymob.client.screen.Add(hud_elements)
	mymob.client.screen.Add(adding + hotkeybuttons)
	inventory_shown = FALSE

/mob/living/carbon/human/verb/toggle_hotkey_verbs()
	set category = PANEL_OOC
	set name = "Toggle hotkey buttons"
	set desc = "This disables or enables the user interface buttons which can be used with hotkeys."

	if(hud_used.hotkey_ui_hidden)
		client.screen.Add(hud_used.hotkeybuttons)
	else
		client.screen.Remove(hud_used.hotkeybuttons)
	hud_used.hotkey_ui_hidden = !hud_used.hotkey_ui_hidden

/mob/living/carbon/human/update_action_buttons()
	var/num = 1
	if(isnull(hud_used))
		return
	if(isnull(client))
		return
	if(!hud_used.hud_shown)	//Hud toggled to minimal
		return

	client.screen.Remove(hud_used.item_action_list)

	hud_used.item_action_list = list()
	for(var/obj/item/I in src)
		if(isnotnull(I.icon_action_button))
			var/obj/screen/item_action/A = new /obj/screen/item_action(I)
			//A.icon = 'icons/mob/screen/screen1_action.dmi'
			//A.icon_state = I.icon_action_button
			A.icon = ui_style2icon(client.prefs.UI_style)
			A.icon_state = "template"
			var/image/img = image(I.icon, A, I.icon_state)
			img.pixel_x = 0
			img.pixel_y = 0
			A.overlays.Add(img)

			if(isnotnull(I.action_button_name))
				A.name = I.action_button_name
			else
				A.name = "Use [I.name]"
			hud_used.item_action_list.Add(A)
			switch(num)
				if(1)
					A.screen_loc = UI_ACTION_SLOT1
				if(2)
					A.screen_loc = UI_ACTION_SLOT2
				if(3)
					A.screen_loc = UI_ACTION_SLOT3
				if(4)
					A.screen_loc = UI_ACTION_SLOT4
				if(5)
					A.screen_loc = UI_ACTION_SLOT5
					break //5 slots available, so no more can be added.
			num++
	client.screen.Add(hud_used.item_action_list)