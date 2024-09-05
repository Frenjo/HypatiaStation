/*
 * Move Intent Switcher
 */
/atom/movable/screen/move_intent
	name = "move intent"
	dir = SOUTHWEST
	screen_loc = UI_MOVI

/atom/movable/screen/move_intent/Click(location, control, params)
	if(!iscarbon(usr))
		return FALSE

	var/mob/living/carbon/C = usr
	if(isnotnull(C.legcuffed))
		to_chat(C, SPAN_NOTICE("You are legcuffed! You cannot run until you get [C.legcuffed] removed!"))
		C.set_move_intent(/decl/move_intent/walk) // Just in case.
	else
		var/next_move_intent = next_in_list(C.move_intent.type, C.move_intents)
		C.set_move_intent(next_move_intent)
	return TRUE

/*
 * Action Intent Buttons
 *
 * These were originally called "attack" intents.
 */
/atom/movable/screen/action_intent
	screen_loc = UI_ACTI

/atom/movable/screen/action_intent/New(loc, intent, icon/ico, ui_alpha)
	name = intent
	icon = ico
	alpha = ui_alpha
	. = ..(loc)

/atom/movable/screen/action_intent/Click(location, control, params)
	usr.a_intent = name
	usr.hud_used.action_intent.icon_state = "intent_[name]"

// This is a lot of duplicated code but icon operations refuse to work any other way.
// It's also WAY LESS duplicated code than before.
/atom/movable/screen/action_intent/help/New(loc, ui_style, ui_alpha = 255)
	var/icon/ico = new /icon(ui_style, "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255, 255, 255, 1), 1, ico.Height() / 2, ico.Width() / 2, ico.Height())
	. = ..(loc, "help", ico, ui_alpha)

/atom/movable/screen/action_intent/disarm/New(loc, ui_style, ui_alpha = 255)
	var/icon/ico = new /icon(ui_style, "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255, 255, 255, 1), ico.Width() / 2, ico.Height() / 2, ico.Width(), ico.Height())
	. = ..(loc, "disarm", ico, ui_alpha)

/atom/movable/screen/action_intent/grab/New(loc, ui_style, ui_alpha = 255)
	var/icon/ico = new /icon(ui_style, "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255, 255, 255, 1), ico.Width() / 2, 1, ico.Width(), ico.Height() / 2)
	. = ..(loc, "grab", ico, ui_alpha)

/atom/movable/screen/action_intent/harm/New(loc, ui_style, ui_alpha = 255)
	var/icon/ico = new /icon(ui_style, "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255, 255, 255, 1), 1, 1, ico.Width() / 2, ico.Height() / 2)
	. = ..(loc, "hurt", ico, ui_alpha) // TODO: Refactor and rename back to "harm" again.