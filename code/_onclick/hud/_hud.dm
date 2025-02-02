/*
 * The hud datum.
 *
 * Used to show and hide huds for all the different mob types,
 * including inventories and item quick actions.
 */
/datum/hud
	var/mob/owner = null

	var/hud_shown = TRUE			// Used for the HUD toggle (F12).
	var/inventory_shown = TRUE		// The inventory.
	var/show_intent_icons = 0

	/*
	 * Intents
	 */
	var/atom/movable/screen/move_intent/move_intent
	var/atom/movable/screen/action_intent

	/*
	 * Hands
	 */
	var/atom/movable/screen/r_hand_hud_object
	var/atom/movable/screen/l_hand_hud_object

	/*
	 * Screentips
	 */
	// UI for screentips that appear when you mouse over things.
	var/atom/movable/screen/screentip/screentip_text

	var/atom/movable/screen/lingchemdisplay

	var/list/adding
	var/list/other

/datum/hud/New(mob/target)
	if(!ismob(target))
		return
	if(isnull(target.client))
		return

	. = ..()
	owner = target
	screentip_text = new /atom/movable/screen/screentip(src)
	adding = list(screentip_text)
	other = list()
	setup(ui_style2icon(owner.client.prefs.UI_style), owner.client.prefs.UI_style_color, owner.client.prefs.UI_style_alpha)

/datum/hud/Destroy()
	owner = null
	QDEL_NULL(screentip_text)
	return ..()

/*
 * Factory proc for generic screen objects.
 */
/datum/hud/proc/setup_screen_object(name, icon, icon_state, screen_loc)
	RETURN_TYPE(/atom/movable/screen)

	var/atom/movable/screen/screen = new /atom/movable/screen(src)
	screen.name = name
	screen.icon = icon
	screen.icon_state = icon_state
	screen.screen_loc = screen_loc

	return screen

// ui_colour and ui_alpha can be safely ignored if not needed.
/datum/hud/proc/setup(ui_style, ui_colour, ui_alpha)
	return

/datum/hud/proc/hidden_inventory_update()
	SHOULD_CALL_PARENT(TRUE)

	if(isnull(owner))
		return FALSE
	return TRUE

/datum/hud/proc/persistent_inventory_update()
	SHOULD_CALL_PARENT(TRUE)

	if(isnull(owner))
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