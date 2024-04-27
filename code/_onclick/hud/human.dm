/datum/hud/human
	var/hotkey_ui_hidden = FALSE	// This is to hide the buttons that can be used via hotkeys. (hotkey_buttons list of buttons)
	var/list/atom/movable/screen/hotkey_buttons // These can be disabled for hotkey users.

	// A list containing the item action button objects.
	var/list/atom/movable/screen/item_action/item_actions

/datum/hud/human/New(mob/living/carbon/human/owner)
	hotkey_buttons = list()
	item_actions = list()
	. = ..(owner)

// Pass the player UI style chosen in preferences.
/datum/hud/human/setup(ui_style = 'icons/mob/screen/screen1_White.dmi', ui_colour = "#ffffff", ui_alpha = 255)
	var/mob/living/carbon/human/owner = mymob
	var/datum/hud_data/hud_data = owner.species.hud
	if(hud_data.icon)
		ui_style = hud_data.icon

	var/list/hud_elements = list()
	var/atom/movable/screen/using
	var/atom/movable/screen/inventory/inv_box

	// Draw the various inventory equipment slots.
	var/has_hidden_gear
	for(var/gear_slot in hud_data.gear)
		inv_box = new /atom/movable/screen/inventory()
		inv_box.icon = ui_style
		inv_box.color = ui_colour
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
		using = new /atom/movable/screen/inventory_toggle()
		using.icon = ui_style
		using.color = ui_colour
		using.alpha = ui_alpha
		adding.Add(using)

	// Draw the attack intent dialogue.
	if(hud_data.has_a_intent)
		using = new /atom/movable/screen()
		using.name = "act_intent"
		using.set_dir(SOUTHWEST)
		using.icon = ui_style
		using.icon_state = "intent_" + mymob.a_intent
		using.screen_loc = UI_ACTI
		using.color = ui_colour
		using.alpha = ui_alpha
		adding.Add(using)
		action_intent = using

		hud_elements |= using

		// Small action intent boxes.
		using = new /atom/movable/screen/action_intent/help(src, ui_style)
		using.alpha = ui_alpha
		adding.Add(using)
		intent_buttons["help"] = using

		using = new /atom/movable/screen/action_intent/disarm(src, ui_style)
		using.alpha = ui_alpha
		adding.Add(using)
		intent_buttons["disarm"] = using

		using = new /atom/movable/screen/action_intent/grab(src, ui_style)
		using.alpha = ui_alpha
		adding.Add(using)
		intent_buttons["grab"] = using

		using = new /atom/movable/screen/action_intent/harm(src, ui_style)
		using.alpha = ui_alpha
		adding.Add(using)
		intent_buttons["harm"] = using
		// End small action intent boxes.

	if(hud_data.has_m_intent)
		using = new /atom/movable/screen/move_intent()
		using.icon = ui_style
		using.icon_state = mymob.move_intent.hud_icon_state
		using.color = ui_colour
		using.alpha = ui_alpha
		adding.Add(using)
		move_intent = using

	if(hud_data.has_drop)
		using = new /atom/movable/screen()
		using.name = "drop"
		using.icon = ui_style
		using.icon_state = "act_drop"
		using.screen_loc = UI_DROP_THROW
		using.color = ui_colour
		using.alpha = ui_alpha
		hotkey_buttons.Add(using)

	if(hud_data.has_hands)
		using = new /atom/movable/screen()
		using.name = "equip"
		using.icon = ui_style
		using.icon_state = "act_equip"
		using.screen_loc = UI_EQUIP
		using.color = ui_colour
		using.alpha = ui_alpha
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
		inv_box.color = ui_colour
		inv_box.alpha = ui_alpha

		r_hand_hud_object = inv_box
		adding.Add(inv_box)

		inv_box = new /atom/movable/screen/inventory()
		inv_box.name = "l_hand"
		inv_box.set_dir(EAST)
		inv_box.icon = ui_style
		inv_box.icon_state = "hand_inactive"
		if(isnotnull(mymob) && mymob.hand)	//This being 1 means the left hand is in use
			inv_box.icon_state = "hand_active"
		inv_box.screen_loc = UI_LHAND
		inv_box.slot_id = SLOT_ID_L_HAND
		inv_box.color = ui_colour
		inv_box.alpha = ui_alpha
		l_hand_hud_object = inv_box
		adding.Add(inv_box)

		using = new /atom/movable/screen/inventory()
		using.name = "hand"
		using.set_dir(SOUTH)
		using.icon = ui_style
		using.icon_state = "hand1"
		using.screen_loc = UI_SWAPHAND1
		using.color = ui_colour
		using.alpha = ui_alpha
		adding.Add(using)

		using = new /atom/movable/screen/inventory()
		using.name = "hand"
		using.set_dir(SOUTH)
		using.icon = ui_style
		using.icon_state = "hand2"
		using.screen_loc = UI_SWAPHAND2
		using.color = ui_colour
		using.alpha = ui_alpha
		adding.Add(using)

	if(hud_data.has_resist)
		using = new /atom/movable/screen()
		using.name = "resist"
		using.icon = ui_style
		using.icon_state = "act_resist"
		using.screen_loc = UI_PULL_RESIST
		using.color = ui_colour
		using.alpha = ui_alpha
		hotkey_buttons.Add(using)

	if(hud_data.has_throw)
		mymob.throw_icon = new /atom/movable/screen()
		mymob.throw_icon.icon = ui_style
		mymob.throw_icon.icon_state = "act_throw_off"
		mymob.throw_icon.name = "throw"
		mymob.throw_icon.screen_loc = UI_DROP_THROW
		mymob.throw_icon.color = ui_colour
		mymob.throw_icon.alpha = ui_alpha
		hotkey_buttons.Add(mymob.throw_icon)
		hud_elements |= mymob.throw_icon

		mymob.pullin = new /atom/movable/screen()
		mymob.pullin.icon = ui_style
		mymob.pullin.icon_state = "pull0"
		mymob.pullin.name = "pull"
		mymob.pullin.screen_loc = UI_PULL_RESIST
		hotkey_buttons.Add(mymob.pullin)
		hud_elements |= mymob.pullin

	if(hud_data.has_internals)
		mymob.internals = new /atom/movable/screen()
		mymob.internals.icon = ui_style
		mymob.internals.icon_state = "internal0"
		mymob.internals.name = "internal"
		mymob.internals.screen_loc = UI_INTERNAL
		hud_elements |= mymob.internals

	if(hud_data.has_warnings)
		mymob.oxygen = new /atom/movable/screen()
		mymob.oxygen.icon = ui_style
		mymob.oxygen.icon_state = "oxy0"
		mymob.oxygen.name = "oxygen"
		mymob.oxygen.screen_loc = UI_OXYGEN
		hud_elements |= mymob.oxygen

		mymob.toxin = new /atom/movable/screen()
		mymob.toxin.icon = ui_style
		mymob.toxin.icon_state = "tox0"
		mymob.toxin.name = "toxin"
		mymob.toxin.screen_loc = UI_TOXIN
		hud_elements |= mymob.toxin

		mymob.fire = new /atom/movable/screen()
		mymob.fire.icon = ui_style
		mymob.fire.icon_state = "fire0"
		mymob.fire.name = "fire"
		mymob.fire.screen_loc = UI_FIRE
		hud_elements |= mymob.fire

		mymob.healths = new /atom/movable/screen()
		mymob.healths.icon = ui_style
		mymob.healths.icon_state = "health0"
		mymob.healths.name = "health"
		mymob.healths.screen_loc = UI_HEALTH
		hud_elements |= mymob.healths

	if(hud_data.has_pressure)
		mymob.pressure = new /atom/movable/screen()
		mymob.pressure.icon = ui_style
		mymob.pressure.icon_state = "pressure0"
		mymob.pressure.name = "pressure"
		mymob.pressure.screen_loc = UI_PRESSURE
		hud_elements |= mymob.pressure

	if(hud_data.has_bodytemp)
		mymob.bodytemp = new /atom/movable/screen()
		mymob.bodytemp.icon = ui_style
		mymob.bodytemp.icon_state = "temp1"
		mymob.bodytemp.name = "body temperature"
		mymob.bodytemp.screen_loc = UI_TEMP
		hud_elements |= mymob.bodytemp

	if(hud_data.has_nutrition)
		mymob.nutrition_icon = new /atom/movable/screen()
		mymob.nutrition_icon.icon = ui_style
		mymob.nutrition_icon.icon_state = "nutrition0"
		mymob.nutrition_icon.name = "nutrition"
		mymob.nutrition_icon.screen_loc = UI_NUTRITION
		hud_elements |= mymob.nutrition_icon

	mymob.blind = new /atom/movable/screen()
	mymob.blind.icon = 'icons/mob/screen/screen1_full.dmi'
	mymob.blind.icon_state = "blackimageoverlay"
	mymob.blind.name = " "
	mymob.blind.screen_loc = "1,1"
	mymob.blind.mouse_opacity = FALSE
	mymob.blind.invisibility = INVISIBILITY_MAXIMUM // Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo
	hud_elements |= mymob.blind

	mymob.damageoverlay = new /atom/movable/screen()
	mymob.damageoverlay.icon = 'icons/mob/screen/screen1_full.dmi'
	mymob.damageoverlay.icon_state = "oxydamageoverlay0"
	mymob.damageoverlay.name = "dmg"
	mymob.damageoverlay.screen_loc = "1,1"
	mymob.damageoverlay.mouse_opacity = FALSE
	mymob.damageoverlay.layer = 18.1 //The black screen overlay sets layer to 18 to display it, this one has to be just on top.
	hud_elements |= mymob.damageoverlay

	mymob.flash = new /atom/movable/screen()
	mymob.flash.icon = ui_style
	mymob.flash.icon_state = "blank"
	mymob.flash.name = "flash"
	mymob.flash.screen_loc = "1,1 to 15,15"
	mymob.flash.mouse_opacity = FALSE
	mymob.flash.plane = FULLSCREEN_PLANE
	hud_elements |= mymob.flash

	mymob.pain = new /atom/movable/screen(null)

	mymob.zone_sel = new /atom/movable/screen/zone_sel()
	mymob.zone_sel.icon = ui_style
	mymob.zone_sel.color = ui_colour
	mymob.zone_sel.alpha = ui_alpha
	mymob.zone_sel.update_icon()
	hud_elements |= mymob.zone_sel

	//Handle the gun settings buttons
	mymob.gun_setting_icon = new /atom/movable/screen/gun/mode()
	hud_elements |= mymob.gun_setting_icon
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
	mymob.client.screen.Add(hud_elements)
	mymob.client.screen.Add(adding + hotkey_buttons)
	inventory_shown = FALSE

	return TRUE

#define SET_SCREEN_LOC(VAR, LOC) \
if(isnotnull(VAR)) \
	VAR.screen_loc = LOC
#define UNSET_SCREEN_LOC(VAR) \
if(isnotnull(VAR)) \
	VAR.screen_loc = null
/datum/hud/human/hidden_inventory_update()
	. = ..()
	if(!.)
		return .

	var/mob/living/carbon/human/H = mymob
	if(inventory_shown && hud_shown)
		SET_SCREEN_LOC(H.wear_mask, UI_MASK)
		// Head
		SET_SCREEN_LOC(H.head, UI_HEAD)
		SET_SCREEN_LOC(H.glasses, UI_GLASSES)
		SET_SCREEN_LOC(H.l_ear, UI_L_EAR)
		SET_SCREEN_LOC(H.r_ear, UI_R_EAR)
		// Uniform
		SET_SCREEN_LOC(H.wear_uniform, UI_ICLOTHING)
		// Suit
		SET_SCREEN_LOC(H.wear_suit, UI_OCLOTHING)
		SET_SCREEN_LOC(H.suit_store, UI_SSTORE1)
		// Other
		SET_SCREEN_LOC(H.gloves, UI_GLOVES)
		SET_SCREEN_LOC(H.shoes, UI_SHOES)
	else
		UNSET_SCREEN_LOC(H.wear_mask)
		// Head
		UNSET_SCREEN_LOC(H.head)
		UNSET_SCREEN_LOC(H.glasses)
		UNSET_SCREEN_LOC(H.l_ear)
		UNSET_SCREEN_LOC(H.r_ear)
		// Uniform
		UNSET_SCREEN_LOC(H.wear_uniform)
		// Suit
		UNSET_SCREEN_LOC(H.wear_suit)
		UNSET_SCREEN_LOC(H.suit_store)
		// Other
		UNSET_SCREEN_LOC(H.gloves)
		UNSET_SCREEN_LOC(H.shoes)

/datum/hud/human/persistent_inventory_update()
	. = ..()
	if(!.)
		return .

	var/mob/living/carbon/human/H = mymob
	if(hud_shown)
		SET_SCREEN_LOC(H.back, UI_BACK)
		// Uniform
		SET_SCREEN_LOC(H.id_store, UI_ID_STORE)
		SET_SCREEN_LOC(H.l_pocket, UI_STORAGE1)
		SET_SCREEN_LOC(H.r_pocket, UI_STORAGE2)
		// Other
		SET_SCREEN_LOC(H.belt, UI_BELT)
	else
		UNSET_SCREEN_LOC(H.back)
		// Uniform
		UNSET_SCREEN_LOC(H.id_store)
		UNSET_SCREEN_LOC(H.l_pocket)
		UNSET_SCREEN_LOC(H.r_pocket)
		// Other
		UNSET_SCREEN_LOC(H.belt)
#undef UNSET_SCREEN_LOC
#undef SET_SCREEN_LOC

/mob/living/carbon/human/verb/toggle_hotkey_verbs()
	set category = PANEL_OOC
	set name = "Toggle hotkey buttons"
	set desc = "This disables or enables the user interface buttons which can be used with hotkeys."

	var/datum/hud/human/human_hud = hud_used
	if(human_hud.hotkey_ui_hidden)
		client.screen.Add(human_hud.hotkey_buttons)
	else
		client.screen.Remove(human_hud.hotkey_buttons)
	human_hud.hotkey_ui_hidden = !human_hud.hotkey_ui_hidden

/mob/living/carbon/human/button_pressed_F12(full = FALSE as null)
	set name = "F12"
	set hidden = TRUE

	if(isnull(client))
		return
	if(client.view != world.view)
		return
	if(isnull(hud_used))
		return
	var/datum/hud/human/human_hud = hud_used

	human_hud.hud_shown = !human_hud.hud_shown
	if(!human_hud.hud_shown)
		if(isnotnull(human_hud.adding))
			client.screen.Remove(human_hud.adding)
		if(isnotnull(human_hud.other))
			client.screen.Remove(human_hud.other)
		if(isnotnull(human_hud.hotkey_buttons))
			client.screen.Remove(human_hud.hotkey_buttons)
		if(isnotnull(human_hud.item_actions))
			client.screen.Remove(human_hud.item_actions)

		//Due to some poor coding some things need special treatment:
		//These ones are a part of 'adding', 'other' or 'hotkey_buttons' but we want them to stay
		if(!full)
			client.screen.Add(human_hud.l_hand_hud_object)	//we want the hands to be visible
			client.screen.Add(human_hud.r_hand_hud_object)	//we want the hands to be visible
			client.screen.Add(human_hud.action_intent)		//we want the intent swticher visible
			human_hud.action_intent.screen_loc = UI_ACTI_ALT	//move this to the alternative position, where zone_select usually is.
		else
			client.screen.Remove(healths)
			client.screen.Remove(internals)
			client.screen.Remove(gun_setting_icon)

		//These ones are not a part of 'adding', 'other' or 'hotkey_buttons' but we want them gone.
		client.screen.Remove(zone_sel)	//zone_sel is a mob variable for some reason.

	else
		if(isnotnull(human_hud.adding))
			client.screen.Add(human_hud.adding)
		if(isnotnull(human_hud.other) && human_hud.inventory_shown)
			client.screen.Add(human_hud.other)
		if(isnotnull(human_hud.hotkey_buttons) && !human_hud.hotkey_ui_hidden)
			client.screen.Add(human_hud.hotkey_buttons)
		if(isnotnull(healths))
			client.screen |= healths
		if(isnotnull(internals))
			client.screen |= internals
		if(isnotnull(gun_setting_icon))
			client.screen |= gun_setting_icon

		human_hud.action_intent.screen_loc = UI_ACTI //Restore intent selection to the original position
		client.screen.Add(zone_sel)				//This one is a special snowflake

	human_hud.hidden_inventory_update()
	human_hud.persistent_inventory_update()
	update_action_buttons()