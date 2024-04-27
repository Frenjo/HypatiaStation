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

	/*
	 * Intents
	 */
	var/atom/movable/screen/move_intent/move_intent
	var/atom/movable/screen/action_intent
	// An associative list containing the small action intent button objects, indexed by intent name.
	var/list/atom/movable/screen/action_intent/intent_buttons = list()

	/*
	 * Hands
	 */
	var/atom/movable/screen/r_hand_hud_object
	var/atom/movable/screen/l_hand_hud_object

	var/atom/movable/screen/lingchemdisplay

	var/list/adding
	var/list/other

/datum/hud/New(mob/owner)
	if(!ismob(owner))
		return
	if(isnull(owner.client))
		return

	. = ..()
	mymob = owner
	adding = list()
	other = list()
	setup(ui_style2icon(mymob.client.prefs.UI_style), mymob.client.prefs.UI_style_color, mymob.client.prefs.UI_style_alpha)

// ui_colour and ui_alpha can be safely ignored if not needed.
/datum/hud/proc/setup(ui_style, ui_colour, ui_alpha)
	return

/datum/hud/proc/hidden_inventory_update()
	SHOULD_CALL_PARENT(TRUE)

	if(isnull(mymob))
		return FALSE
	return TRUE

/datum/hud/proc/persistent_inventory_update()
	SHOULD_CALL_PARENT(TRUE)

	if(isnull(mymob))
		return FALSE
	return TRUE

//Triggered when F12 is pressed (Unless someone changed something in the DMF)
/mob/verb/button_pressed_F12(full = FALSE as null)
	set name = "F12"
	set hidden = TRUE
	SHOULD_CALL_PARENT(FALSE)

	if(hud_used)
		to_chat(usr, SPAN_WARNING("Inventory hiding is currently only supported for human mobs, sorry."))
	else
		to_chat(usr, SPAN_WARNING("This mob type does not use a HUD."))