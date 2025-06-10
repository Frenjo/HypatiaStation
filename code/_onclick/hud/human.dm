/datum/hud/human
	var/hotkey_ui_hidden = FALSE	// This is to hide the buttons that can be used via hotkeys. (hotkey_buttons list of buttons)
	var/list/atom/movable/screen/hotkey_buttons // These can be disabled for hotkey users.

	// A list containing the item action button objects.
	var/list/atom/movable/screen/item_action/item_actions

	var/inventory_shown = TRUE // The inventory.

/datum/hud/human/New(mob/living/carbon/human/owner)
	hotkey_buttons = list()
	item_actions = list()
	. = ..(owner)

// Pass the player UI style chosen in preferences.
/datum/hud/human/setup(ui_style = 'icons/hud/screen1_White.dmi', ui_colour = "#ffffff", ui_alpha = 255)
	var/mob/living/carbon/human/H = owner
	var/datum/hud_data/hud_data = H.species.hud
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
		using = setup_screen_object("act_intent", ui_style, "intent_" + H.a_intent, UI_ACTI)
		using.set_dir(SOUTHWEST)
		using.color = ui_colour
		using.alpha = ui_alpha
		adding.Add(using)
		action_intent = using
		hud_elements |= using

		// Small action intent boxes.
		adding.Add(
			new /atom/movable/screen/action_intent/help(src, ui_style, ui_alpha),
			new /atom/movable/screen/action_intent/disarm(src, ui_style, ui_alpha),
			new /atom/movable/screen/action_intent/grab(src, ui_style, ui_alpha),
			new /atom/movable/screen/action_intent/harm(src, ui_style, ui_alpha)
		)
		// End small action intent boxes.

	if(hud_data.has_m_intent)
		using = new /atom/movable/screen/move_intent()
		using.icon = ui_style
		using.icon_state = H.move_intent.hud_icon_state
		using.color = ui_colour
		using.alpha = ui_alpha
		adding.Add(using)
		move_intent = using

	if(hud_data.has_drop)
		using = new /atom/movable/screen/action/drop(ui_style, UI_DROP_THROW)
		using.color = ui_colour
		using.alpha = ui_alpha
		hotkey_buttons.Add(using)

	if(hud_data.has_hands)
		using = new /atom/movable/screen/equip(ui_style)
		using.color = ui_colour
		using.alpha = ui_alpha
		adding.Add(using)

		inv_box = new /atom/movable/screen/inventory()
		inv_box.name = "r_hand"
		inv_box.set_dir(WEST)
		inv_box.icon = ui_style
		inv_box.icon_state = "hand_inactive"
		if(isnotnull(H) && !H.hand)	//This being 0 or null means the right hand is in use
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
		if(isnotnull(H) && H.hand)	//This being 1 means the left hand is in use
			inv_box.icon_state = "hand_active"
		inv_box.screen_loc = UI_LHAND
		inv_box.slot_id = SLOT_ID_L_HAND
		inv_box.color = ui_colour
		inv_box.alpha = ui_alpha
		l_hand_hud_object = inv_box
		adding.Add(inv_box)

		using = new /atom/movable/screen/swap_hands(ui_style, "hand1", UI_SWAPHAND1)
		using.color = ui_colour
		using.alpha = ui_alpha
		adding.Add(using)

		using = new /atom/movable/screen/swap_hands(ui_style, "hand2", UI_SWAPHAND2)
		using.color = ui_colour
		using.alpha = ui_alpha
		adding.Add(using)

	if(hud_data.has_resist)
		using = new /atom/movable/screen/action/resist(ui_style, UI_PULL_RESIST)
		using.color = ui_colour
		using.alpha = ui_alpha
		hotkey_buttons.Add(using)

	if(hud_data.has_throw)
		H.throw_icon = new /atom/movable/screen/action/throw_icon(ui_style, UI_DROP_THROW)
		H.throw_icon.color = ui_colour
		H.throw_icon.alpha = ui_alpha
		hotkey_buttons.Add(H.throw_icon)
		hud_elements |= H.throw_icon

		H.pullin = new /atom/movable/screen/action/pull(ui_style, UI_PULL_RESIST)
		hotkey_buttons.Add(H.pullin)
		hud_elements |= H.pullin

	if(hud_data.has_internals)
		H.internals = new /atom/movable/screen/internals(ui_style)
		hud_elements |= H.internals

	if(hud_data.has_warnings)
		H.oxygen = setup_screen_object("oxygen", ui_style, "oxy0", UI_OXYGEN)
		hud_elements |= H.oxygen

		H.toxin = setup_screen_object("toxin", ui_style, "tox0", UI_TOXIN)
		hud_elements |= H.toxin

		H.fire = setup_screen_object("fire", ui_style, "fire0", UI_FIRE)
		hud_elements |= H.fire

		H.healths = setup_screen_object("health", ui_style, "health0", UI_HEALTH)
		hud_elements |= H.healths

	if(hud_data.has_pressure)
		H.pressure = setup_screen_object("pressure", ui_style, "pressure0", UI_PRESSURE)
		hud_elements |= H.pressure

	if(hud_data.has_bodytemp)
		H.bodytemp = setup_screen_object("body temperature", ui_style, "temp1", UI_TEMP)
		hud_elements |= H.bodytemp

	if(hud_data.has_nutrition)
		H.nutrition_icon = setup_screen_object("nutrition", ui_style, "nutrition0", UI_NUTRITION)
		hud_elements |= H.nutrition_icon

	H.blind = new /atom/movable/screen()
	H.blind.icon = 'icons/hud/screen1_full.dmi'
	H.blind.icon_state = "blackimageoverlay"
	H.blind.name = " "
	H.blind.screen_loc = "1,1"
	H.blind.mouse_opacity = FALSE
	H.blind.invisibility = INVISIBILITY_MAXIMUM // Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo
	hud_elements |= H.blind

	H.damageoverlay = new /atom/movable/screen()
	H.damageoverlay.icon = 'icons/hud/screen1_full.dmi'
	H.damageoverlay.icon_state = "oxydamageoverlay0"
	H.damageoverlay.name = "dmg"
	H.damageoverlay.screen_loc = "1,1"
	H.damageoverlay.mouse_opacity = FALSE
	H.damageoverlay.layer = 18.1 //The black screen overlay sets layer to 18 to display it, this one has to be just on top.
	hud_elements |= H.damageoverlay

	H.flash = new /atom/movable/screen()
	H.flash.icon = ui_style
	H.flash.icon_state = "blank"
	H.flash.name = "flash"
	H.flash.screen_loc = "WEST,SOUTH to EAST,NORTH"
	H.flash.mouse_opacity = FALSE
	H.flash.plane = FULLSCREEN_PLANE
	hud_elements |= H.flash

	H.pain = new /atom/movable/screen(null)

	H.zone_sel = new /atom/movable/screen/zone_sel()
	H.zone_sel.icon = ui_style
	H.zone_sel.color = ui_colour
	H.zone_sel.alpha = ui_alpha
	H.zone_sel.update_icon()
	hud_elements |= H.zone_sel

	//Handle the gun settings buttons
	H.gun_setting_icon = new /atom/movable/screen/gun/mode()
	hud_elements |= H.gun_setting_icon
	if(isnotnull(H.client))
		if(H.client.gun_mode) // If in aim mode, correct the sprite
			H.gun_setting_icon.set_dir(2)
	for(var/obj/item/gun/G in H) // If targeting someone, display other buttons
		if(isnotnull(G.aim_targets))
			H.item_use_icon = new /atom/movable/screen/gun/item()
			if(H.client.target_can_click)
				H.item_use_icon.set_dir(1)
			adding.Add(H.item_use_icon)
			H.gun_move_icon = new /atom/movable/screen/gun/move()
			if(H.client.target_can_move)
				H.gun_move_icon.set_dir(1)
				H.gun_run_icon = new /atom/movable/screen/gun/run()
				if(H.client.target_can_run)
					H.gun_run_icon.set_dir(1)
				adding.Add(H.gun_run_icon)
			adding.Add(H.gun_move_icon)

	. = ..()
	H.client.screen.Add(hud_elements)
	H.client.screen.Add(hotkey_buttons)
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
		return

	var/mob/living/carbon/human/H = owner
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
		return

	var/mob/living/carbon/human/H = owner
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
	set category = PANEL_PREFERENCES
	set name = "Toggle Hotkey Buttons"
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