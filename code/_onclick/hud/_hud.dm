/*
 * The hud datum.
 *
 * Used to show and hide huds for all the different mob types,
 * including inventories and item quick actions.
 */
/datum/hud
	var/mob/mymob = null

	var/hud_shown = TRUE			// Used for the HUD toggle (F12).
	var/inventory_shown = TRUE		// The inventory.
	var/show_intent_icons = 0
	var/hotkey_ui_hidden = FALSE	// This is to hide the buttons that can be used via hotkeys. (hotkeybuttons list of buttons)

	/*
	 * Intents
	 */
	var/obj/screen/move_intent
	var/obj/screen/action_intent
	// An associative list containing the small action intent button objects, indexed by intent name.
	var/list/obj/screen/intent_buttons = list()

	/*
	 * Hands
	 */
	var/obj/screen/r_hand_hud_object
	var/obj/screen/l_hand_hud_object

	var/obj/screen/lingchemdisplay
	// Blob health and power display objects.
	var/obj/screen/blob_health_display
	var/obj/screen/blob_power_display

	var/list/adding
	var/list/other
	var/list/obj/screen/hotkeybuttons

	// A list containing the item action button objects.
	var/list/obj/screen/item_action/item_action_list = list()

/datum/hud/New(mob/owner)
	. = ..()
	mymob = owner
	instantiate()

#define SET_SCREEN_LOC(VAR, LOC) \
if(isnotnull(VAR)) \
	VAR.screen_loc = LOC
#define UNSET_SCREEN_LOC(VAR) \
if(isnotnull(VAR)) \
	VAR.screen_loc = null
/datum/hud/proc/hidden_inventory_update()
	if(isnull(mymob))
		return

	if(ishuman(mymob))
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

/datum/hud/proc/persistent_inventory_update()
	if(isnull(mymob))
		return

	if(ishuman(mymob))
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

/datum/hud/proc/instantiate()
	if(!ismob(mymob))
		return
	if(isnull(mymob.client))
		return

	var/ui_style = ui_style2icon(mymob.client.prefs.UI_style)
	var/ui_color = mymob.client.prefs.UI_style_color
	var/ui_alpha = mymob.client.prefs.UI_style_alpha

	if(ishuman(mymob))
		human_hud(ui_style, ui_color, ui_alpha, mymob) // Pass the player the UI style chosen in preferences
	else if(ismonkey(mymob))
		monkey_hud(ui_style)
	else if(isbrain(mymob))
		brain_hud(ui_style)
	else if(islarva(mymob) || isalien(mymob))
		larva_hud()
	else if(isAI(mymob))
		ai_hud()
	else if(isrobot(mymob))
		robot_hud()
	else if(isobserver(mymob))
		ghost_hud()

//Triggered when F12 is pressed (Unless someone changed something in the DMF)
/mob/verb/button_pressed_F12(full = FALSE as null)
	set name = "F12"
	set hidden = 1

	if(hud_used)
		if(ishuman(src))
			if(isnull(client))
				return
			if(client.view != world.view)
				return

			hud_used.hud_shown = !hud_used.hud_shown
			if(!hud_used.hud_shown)
				if(isnotnull(hud_used.adding))
					client.screen.Remove(hud_used.adding)
				if(isnotnull(hud_used.other))
					client.screen.Remove(hud_used.other)
				if(isnotnull(hud_used.hotkeybuttons))
					client.screen.Remove(hud_used.hotkeybuttons)
				if(isnotnull(hud_used.item_action_list))
					client.screen.Remove(hud_used.item_action_list)

				//Due to some poor coding some things need special treatment:
				//These ones are a part of 'adding', 'other' or 'hotkeybuttons' but we want them to stay
				if(!full)
					client.screen.Add(hud_used.l_hand_hud_object)	//we want the hands to be visible
					client.screen.Add(hud_used.r_hand_hud_object)	//we want the hands to be visible
					client.screen.Add(hud_used.action_intent)		//we want the intent swticher visible
					hud_used.action_intent.screen_loc = UI_ACTI_ALT	//move this to the alternative position, where zone_select usually is.
				else
					client.screen.Remove(healths)
					client.screen.Remove(internals)
					client.screen.Remove(gun_setting_icon)

				//These ones are not a part of 'adding', 'other' or 'hotkeybuttons' but we want them gone.
				client.screen.Remove(zone_sel)	//zone_sel is a mob variable for some reason.

			else
				if(isnotnull(hud_used.adding))
					client.screen.Add(hud_used.adding)
				if(isnotnull(hud_used.other) && hud_used.inventory_shown)
					client.screen.Add(hud_used.other)
				if(isnotnull(hud_used.hotkeybuttons) && !hud_used.hotkey_ui_hidden)
					client.screen.Add(hud_used.hotkeybuttons)
				if(isnotnull(healths))
					client.screen |= healths
				if(isnotnull(internals))
					client.screen |= internals
				if(isnotnull(gun_setting_icon))
					client.screen |= gun_setting_icon

				hud_used.action_intent.screen_loc = UI_ACTI //Restore intent selection to the original position
				client.screen.Add(zone_sel)				//This one is a special snowflake

			hud_used.hidden_inventory_update()
			hud_used.persistent_inventory_update()
			update_action_buttons()
		else
			to_chat(usr, SPAN_WARNING("Inventory hiding is currently only supported for human mobs, sorry."))
	else
		to_chat(usr, SPAN_WARNING("This mob type does not use a HUD."))