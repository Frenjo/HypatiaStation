/obj/hud/proc/amorph_hud(var/ui_style='icons/hud/screen1_old.dmi')

	src.adding = list(  )
	src.other = list(  )
	src.intents = list(  )
	src.mon_blo = list(  )
	src.m_ints = list(  )
	src.mov_int = list(  )
	src.vimpaired = list(  )
	src.darkMask = list(  )
	src.intent_small_hud_objects = list(  )

	src.g_dither = new /atom/movable/screen( src )
	src.g_dither.screen_loc = "WEST,SOUTH to EAST,NORTH"
	src.g_dither.name = "Mask"
	src.g_dither.icon = ui_style
	src.g_dither.icon_state = "dither12g"
	src.g_dither.layer = 18
	src.g_dither.mouse_opacity = FALSE

	src.alien_view = new /atom/movable/screen(src)
	src.alien_view.screen_loc = "WEST,SOUTH to EAST,NORTH"
	src.alien_view.name = "Alien"
	src.alien_view.icon = ui_style
	src.alien_view.icon_state = "alien"
	src.alien_view.layer = 18
	src.alien_view.mouse_opacity = FALSE

	src.blurry = new /atom/movable/screen( src )
	src.blurry.screen_loc = "WEST,SOUTH to EAST,NORTH"
	src.blurry.name = "Blurry"
	src.blurry.icon = ui_style
	src.blurry.icon_state = "blurry"
	src.blurry.layer = 17
	src.blurry.mouse_opacity = FALSE

	src.druggy = new /atom/movable/screen( src )
	src.druggy.screen_loc = "WEST,SOUTH to EAST,NORTH"
	src.druggy.name = "Druggy"
	src.druggy.icon = ui_style
	src.druggy.icon_state = "druggy"
	src.druggy.layer = 17
	src.druggy.mouse_opacity = FALSE

	var/atom/movable/screen/using

	using = new /atom/movable/screen( src )
	using.name = "act_intent"
	using.dir = SOUTHWEST
	using.icon = ui_style
	using.icon_state = (mymob.a_intent == "hurt" ? "harm" : mymob.a_intent)
	using.screen_loc = ui_acti
	src.adding += using
	action_intent = using

	// Small action intent boxes.
	using = new /atom/movable/screen/action_intent/help(src, ui_style)
	src.adding += using
	help_intent = using

	using = new /atom/movable/screen/action_intent/disarm(src, ui_style)
	src.adding += using
	disarm_intent = using

	using = new /atom/movable/screen/action_intent/grab(src, ui_style)
	src.adding += using
	grab_intent = using

	using = new /atom/movable/screen/action_intent/harm(src, ui_style)
	src.adding += using
	hurt_intent = using
	// End small action intent boxes.

	using = new /atom/movable/screen/move_intent()
	using.icon = ui_style
	using.icon_state = (mymob.m_intent == "run" ? "running" : "walking")
	src.adding += using
	move_intent = using

	using = new /atom/movable/screen( src )
	using.name = "drop"
	using.icon = ui_style
	using.icon_state = "act_drop"
	using.screen_loc = ui_dropbutton
	src.adding += using

	using = new /atom/movable/screen( src )
	using.name = "r_hand"
	using.dir = WEST
	using.icon = ui_style
	using.icon_state = "hand_inactive"
	if(mymob && !mymob.hand)	//This being 0 or null means the right hand is in use
		using.icon_state = "hand_active"
	using.screen_loc = ui_rhand
	src.r_hand_hud_object = using
	src.adding += using

	using = new /atom/movable/screen( src )
	using.name = "l_hand"
	using.dir = EAST
	using.icon = ui_style
	using.icon_state = "hand_inactive"
	if(mymob && mymob.hand)	//This being 1 means the left hand is in use
		using.icon_state = "hand_active"
	using.screen_loc = ui_lhand
	src.l_hand_hud_object = using
	src.adding += using

	using = new /atom/movable/screen/swap_hands(ui_style, "hand1", UI_SWAPHAND1)
	src.adding += using

	using = new /atom/movable/screen/swap_hands(ui_style, "hand2", UI_SWAPHAND2)
	src.adding += using

	using = new /atom/movable/screen( src )
	using.name = "mask"
	using.dir = NORTH
	using.icon = ui_style
	using.icon_state = "equip"
	using.screen_loc = ui_monkey_mask
	src.adding += using

	using = new /atom/movable/screen( src )
	using.name = "back"
	using.dir = NORTHEAST
	using.icon = ui_style
	using.icon_state = "equip"
	using.screen_loc = ui_back
	src.adding += using

	using = new /atom/movable/screen( src )
	using.name = null
	using.icon = ui_style
	using.icon_state = "dither50"
	using.screen_loc = "1,1 to 5,15"
	using.plane = FULLSCREEN_PLANE
	using.mouse_opacity = FALSE
	src.vimpaired += using
	using = new /atom/movable/screen( src )
	using.name = null
	using.icon = ui_style
	using.icon_state = "dither50"
	using.screen_loc = "5,1 to 10,5"
	using.plane = FULLSCREEN_PLANE
	using.mouse_opacity = FALSE
	src.vimpaired += using
	using = new /atom/movable/screen( src )
	using.name = null
	using.icon = ui_style
	using.icon_state = "dither50"
	using.screen_loc = "6,11 to 10,15"
	using.plane = FULLSCREEN_PLANE
	using.mouse_opacity = FALSE
	src.vimpaired += using
	using = new /atom/movable/screen( src )
	using.name = null
	using.icon = ui_style
	using.icon_state = "dither50"
	using.screen_loc = "11,1 to 15,15"
	using.plane = FULLSCREEN_PLANE
	using.mouse_opacity = FALSE
	src.vimpaired += using

	mymob.throw_icon = new /atom/movable/screen/action/throw_toggle(ui_style, UI_THROW)

	mymob.oxygen = new /atom/movable/screen( null )
	mymob.oxygen.icon = ui_style
	mymob.oxygen.icon_state = "oxy0"
	mymob.oxygen.name = "oxygen"
	mymob.oxygen.screen_loc = ui_oxygen

	mymob.pressure = new /atom/movable/screen( null )
	mymob.pressure.icon = ui_style
	mymob.pressure.icon_state = "pressure0"
	mymob.pressure.name = "pressure"
	mymob.pressure.screen_loc = ui_pressure

	mymob.toxin = new /atom/movable/screen( null )
	mymob.toxin.icon = ui_style
	mymob.toxin.icon_state = "tox0"
	mymob.toxin.name = "toxin"
	mymob.toxin.screen_loc = ui_toxin

	mymob.internals = new /atom/movable/screen( null )
	mymob.internals.icon = ui_style
	mymob.internals.icon_state = "internal0"
	mymob.internals.name = "internal"
	mymob.internals.screen_loc = ui_internal

	mymob.fire = new /atom/movable/screen( null )
	mymob.fire.icon = ui_style
	mymob.fire.icon_state = "fire0"
	mymob.fire.name = "fire"
	mymob.fire.screen_loc = ui_fire

	mymob.bodytemp = new /atom/movable/screen( null )
	mymob.bodytemp.icon = ui_style
	mymob.bodytemp.icon_state = "temp1"
	mymob.bodytemp.name = "body temperature"
	mymob.bodytemp.screen_loc = ui_temp

	mymob.healths = new /atom/movable/screen( null )
	mymob.healths.icon = ui_style
	mymob.healths.icon_state = "health0"
	mymob.healths.name = "health"
	mymob.healths.screen_loc = ui_health

	mymob.pullin = new /atom/movable/screen/action/pull(ui_style, UI_PULL)

	mymob.blind = new /atom/movable/screen( null )
	mymob.blind.icon = ui_style
	mymob.blind.icon_state = "blackanimate"
	mymob.blind.name = " "
	mymob.blind.screen_loc = "1,1 to 15,15"
	mymob.blind.layer = 0
	mymob.blind.mouse_opacity = FALSE

	mymob.flash = new /atom/movable/screen( null )
	mymob.flash.icon = ui_style
	mymob.flash.icon_state = "blank"
	mymob.flash.name = "flash"
	mymob.flash.screen_loc = "1,1 to 15,15"
	mymob.flash.layer = 17

	mymob.zone_sel = new /atom/movable/screen/zone_sel( null )
	mymob.zone_sel.overlays = null
	mymob.zone_sel.add_overlay(image(icon = 'icons/hud/zone_sel.dmi', icon_state = "[mymob.zone_sel.selecting]"))

	//Handle the gun settings buttons
	mymob.gun_setting_icon = new /atom/movable/screen/gun/mode(null)
	if (mymob.client)
		if (mymob.client.gun_mode) // If in aim mode, correct the sprite
			mymob.gun_setting_icon.dir = 2
	for(var/obj/item/gun/G in mymob) // If targeting someone, display other buttons
		if (G.target)
			mymob.item_use_icon = new /atom/movable/screen/gun/item(null)
			if (mymob.client.target_can_click)
				mymob.item_use_icon.dir = 1
			src.adding += mymob.item_use_icon
			mymob.gun_move_icon = new /atom/movable/screen/gun/move(null)
			if (mymob.client.target_can_move)
				mymob.gun_move_icon.dir = 1
				mymob.gun_run_icon = new /atom/movable/screen/gun/run(null)
				if (mymob.client.target_can_run)
					mymob.gun_run_icon.dir = 1
				src.adding += mymob.gun_run_icon
			src.adding += mymob.gun_move_icon

	mymob.client.screen.Cut()
	//, mymob.i_select, mymob.m_select
	mymob.client.screen += list(
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
	) //, mymob.hands, mymob.rest, mymob.sleep, mymob.mach, mymob.hands, )
	mymob.client.screen += src.adding + src.other

	//if(ismonkey(mymob)) mymob.client.screen += src.mon_blo

	return
