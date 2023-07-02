/*
	The global hud:
	Uses the same visual objects for all players.
*/
GLOBAL_GLOBL_NEW(global_hud, /datum/global_hud)

GLOBAL_GLOBL_LIST_INIT(global_huds, list(
	GLOBL.global_hud.druggy,
	GLOBL.global_hud.blurry,
	GLOBL.global_hud.vimpaired,
	GLOBL.global_hud.darkMask,
	GLOBL.global_hud.nvg,
	GLOBL.global_hud.scig,
	GLOBL.global_hud.thermal,
	GLOBL.global_hud.meson
))

/datum/hud/var/obj/screen/grab_intent
/datum/hud/var/obj/screen/hurt_intent
/datum/hud/var/obj/screen/disarm_intent
/datum/hud/var/obj/screen/help_intent

/datum/global_hud
	var/obj/screen/druggy
	var/obj/screen/blurry
	var/list/vimpaired
	var/list/darkMask
	var/obj/screen/nvg
	// Overlay for purple effects from science goggles.
	var/obj/screen/scig
	var/obj/screen/thermal
	var/obj/screen/meson

	// Overlay for radiation effects from rad storms.
	var/obj/screen/radstorm
	// Overlay for ionic effects from ion storms.
	var/obj/screen/ionstorm
	// Overlay for electrical effects from electrical storms.
	var/obj/screen/electricalstorm

/datum/global_hud/proc/setup_overlay(icon_state)
	var/obj/screen/screen = new /obj/screen()
	screen.screen_loc = "1,1"
	screen.icon = 'icons/obj/hud_full.dmi'
	screen.icon_state = icon_state
	screen.layer = 17
	screen.mouse_opacity = FALSE

	return screen

/datum/global_hud/New()
	//420erryday psychedellic colours screen overlay for when you are high
	druggy = new /obj/screen()
	druggy.screen_loc = "WEST,SOUTH to EAST,NORTH"
	druggy.icon_state = "druggy"
	druggy.layer = 17
	druggy.mouse_opacity = FALSE

	//that white blurry effect you get when you eyes are damaged
	blurry = new /obj/screen()
	blurry.screen_loc = "WEST,SOUTH to EAST,NORTH"
	blurry.icon_state = "blurry"
	blurry.layer = 17
	blurry.mouse_opacity = FALSE

	nvg = setup_overlay("nvg_hud")
	// Overlay for purple effects from science goggles.
	scig = setup_overlay("scig_hud")
	thermal = setup_overlay("thermal_hud")
	meson = setup_overlay("meson_hud")

	// Overlay for radiation effects from rad storms.
	radstorm = new /obj/screen()
	radstorm.screen_loc = "WEST,SOUTH to EAST,NORTH"
	radstorm.icon = 'icons/effects/effects.dmi'
	radstorm.icon_state = "mfoam"
	//radstorm.color = "#0099ff"
	radstorm.color = "#0066ff"
	radstorm.alpha = 65
	radstorm.layer = 17
	radstorm.blend_mode = BLEND_SUBTRACT
	radstorm.mouse_opacity = FALSE

	// Overlay for ionic effects from ion storms.
	ionstorm = new /obj/screen()
	ionstorm.screen_loc = "WEST,SOUTH to EAST,NORTH"
	ionstorm.icon = 'icons/effects/effects.dmi'
	ionstorm.icon_state = "mfoam"
	//ionstorm.color = "#ffc400"
	ionstorm.color = "#ffdb60"
	ionstorm.alpha = 65
	ionstorm.layer = 17
	ionstorm.blend_mode = BLEND_SUBTRACT
	ionstorm.mouse_opacity = FALSE

	// Overlay for electrical effects from electrical storms.
	electricalstorm = new /obj/screen()
	electricalstorm.screen_loc = "WEST,SOUTH to EAST,NORTH"
	electricalstorm.icon = 'icons/effects/effects.dmi'
	electricalstorm.icon_state = "mfoam"
	electricalstorm.color = "#00ffcc"
	electricalstorm.alpha = 65
	electricalstorm.layer = 17
	electricalstorm.blend_mode = BLEND_SUBTRACT
	electricalstorm.mouse_opacity = FALSE

	var/obj/screen/O
	var/i
	//that nasty looking dither you  get when you're short-sighted
	vimpaired = newlist(/obj/screen, /obj/screen, /obj/screen, /obj/screen)
	O = vimpaired[1]
	O.screen_loc = "1,1 to 5,15"
	O = vimpaired[2]
	O.screen_loc = "5,1 to 10,5"
	O = vimpaired[3]
	O.screen_loc = "6,11 to 10,15"
	O = vimpaired[4]
	O.screen_loc = "11,1 to 15,15"

	//welding mask overlay black/dither
	darkMask = newlist(/obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen, /obj/screen)
	O = darkMask[1]
	O.screen_loc = "3,3 to 5,13"
	O = darkMask[2]
	O.screen_loc = "5,3 to 10,5"
	O = darkMask[3]
	O.screen_loc = "6,11 to 10,13"
	O = darkMask[4]
	O.screen_loc = "11,3 to 13,13"
	O = darkMask[5]
	O.screen_loc = "1,1 to 15,2"
	O = darkMask[6]
	O.screen_loc = "1,3 to 2,15"
	O = darkMask[7]
	O.screen_loc = "14,3 to 15,15"
	O = darkMask[8]
	O.screen_loc = "3,14 to 13,15"

	for(i = 1, i <= 4, i++)
		O = vimpaired[i]
		O.icon_state = "dither50"
		O.layer = 17
		O.mouse_opacity = FALSE

		O = darkMask[i]
		O.icon_state = "dither50"
		O.layer = 17
		O.mouse_opacity = FALSE

	for(i = 5, i <= 8, i++)
		O = darkMask[i]
		O.icon_state = "black"
		O.layer = 17
		O.mouse_opacity = FALSE

/*
	The hud datum
	Used to show and hide huds for all the different mob types,
	including inventories and item quick actions.
*/

/datum/hud
	var/mob/mymob = null

	var/hud_shown = TRUE		//Used for the HUD toggle (F12)
	var/inventory_shown = TRUE	//the inventory
	var/show_intent_icons = 0
	var/hotkey_ui_hidden = 0	//This is to hide the buttons that can be used via hotkeys. (hotkeybuttons list of buttons)

	var/obj/screen/lingchemdisplay
	var/obj/screen/blobpwrdisplay
	var/obj/screen/blobhealthdisplay
	var/obj/screen/r_hand_hud_object
	var/obj/screen/l_hand_hud_object
	var/obj/screen/action_intent
	var/obj/screen/move_intent

	var/list/adding
	var/list/other
	var/list/obj/screen/hotkeybuttons

	var/list/obj/screen/item_action/item_action_list = list()	//Used for the item action ui buttons.

/datum/hud/New(mob/owner)
	. = ..()
	mymob = owner
	instantiate()

/datum/hud/proc/hidden_inventory_update()
	if(isnull(mymob))
		return

	if(ishuman(mymob))
		var/mob/living/carbon/human/H = mymob
		if(inventory_shown && hud_shown)
			if(isnotnull(H.shoes))
				H.shoes.screen_loc = UI_SHOES
			if(isnotnull(H.gloves))
				H.gloves.screen_loc = UI_GLOVES
			if(isnotnull(H.l_ear))
				H.l_ear.screen_loc = UI_L_EAR
			if(isnotnull(H.r_ear))
				H.r_ear.screen_loc = UI_R_EAR
			if(isnotnull(H.glasses))
				H.glasses.screen_loc = UI_GLASSES
			if(isnotnull(H.w_uniform))
				H.w_uniform.screen_loc = UI_ICLOTHING
			if(isnotnull(H.wear_suit))
				H.wear_suit.screen_loc = UI_OCLOTHING
			if(isnotnull(H.wear_mask))
				H.wear_mask.screen_loc = UI_MASK
			if(isnotnull(H.head))
				H.head.screen_loc = UI_HEAD
		else
			if(isnotnull(H.shoes))
				H.shoes.screen_loc = null
			if(isnotnull(H.gloves))
				H.gloves.screen_loc = null
			if(isnotnull(H.l_ear))
				H.l_ear.screen_loc = null
			if(isnotnull(H.r_ear))
				H.r_ear.screen_loc = null
			if(isnotnull(H.glasses))
				H.glasses.screen_loc = null
			if(isnotnull(H.w_uniform))
				H.w_uniform.screen_loc = null
			if(isnotnull(H.wear_suit))
				H.wear_suit.screen_loc = null
			if(isnotnull(H.wear_mask))
				H.wear_mask.screen_loc = null
			if(isnotnull(H.head))
				H.head.screen_loc = null

/datum/hud/proc/persistant_inventory_update()
	if(isnull(mymob))
		return

	if(ishuman(mymob))
		var/mob/living/carbon/human/H = mymob
		if(hud_shown)
			if(isnotnull(H.s_store))
				H.s_store.screen_loc = UI_SSTORE1
			if(isnotnull(H.wear_id))
				H.wear_id.screen_loc = UI_ID
			if(isnotnull(H.belt))
				H.belt.screen_loc = UI_BELT
			if(isnotnull(H.back))
				H.back.screen_loc = UI_BACK
			if(isnotnull(H.l_store))
				H.l_store.screen_loc = UI_STORAGE1
			if(isnotnull(H.r_store))
				H.r_store.screen_loc = UI_STORAGE2
		else
			if(isnotnull(H.s_store))
				H.s_store.screen_loc = null
			if(isnotnull(H.wear_id))
				H.wear_id.screen_loc = null
			if(isnotnull(H.belt))
				H.belt.screen_loc = null
			if(isnotnull(H.back))
				H.back.screen_loc = null
			if(isnotnull(H.l_store))
				H.l_store.screen_loc = null
			if(isnotnull(H.r_store))
				H.r_store.screen_loc = null

/datum/hud/proc/instantiate()
	if(!ismob(mymob))
		return 0
	if(isnull(mymob.client))
		return 0

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
			hud_used.persistant_inventory_update()
			update_action_buttons()
		else
			to_chat(usr, SPAN_WARNING("Inventory hiding is currently only supported for human mobs, sorry."))
	else
		to_chat(usr, SPAN_WARNING("This mob type does not use a HUD."))