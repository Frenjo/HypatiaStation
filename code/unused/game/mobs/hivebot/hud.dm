
/obj/hud/proc/hivebot_hud()

	src.adding = list(  )
	src.other = list(  )
	src.intents = list(  )
	src.mon_blo = list(  )
	src.m_ints = list(  )
	src.mov_int = list(  )
	src.vimpaired = list(  )
	src.darkMask = list(  )

	src.g_dither = new src.h_type( src )
	src.g_dither.screen_loc = "WEST,SOUTH to EAST,NORTH"
	src.g_dither.name = "Mask"
	src.g_dither.icon_state = "dither12g"
	src.g_dither.layer = 18
	src.g_dither.mouse_opacity = FALSE

	src.alien_view = new src.h_type(src)
	src.alien_view.screen_loc = "WEST,SOUTH to EAST,NORTH"
	src.alien_view.name = "Alien"
	src.alien_view.icon_state = "alien"
	src.alien_view.layer = 18
	src.alien_view.mouse_opacity = FALSE

	src.blurry = new src.h_type( src )
	src.blurry.screen_loc = "WEST,SOUTH to EAST,NORTH"
	src.blurry.name = "Blurry"
	src.blurry.icon_state = "blurry"
	src.blurry.layer = 17
	src.blurry.mouse_opacity = FALSE

	src.druggy = new src.h_type( src )
	src.druggy.screen_loc = "WEST,SOUTH to EAST,NORTH"
	src.druggy.name = "Druggy"
	src.druggy.icon_state = "druggy"
	src.druggy.layer = 17
	src.druggy.mouse_opacity = FALSE

	// station explosion cinematic
	src.station_explosion = new src.h_type( src )
	src.station_explosion.icon = 'icons/effects/station_explosion.dmi'
	src.station_explosion.icon_state = "start"
	src.station_explosion.plane = HUD_PLANE
	src.station_explosion.layer = HUD_ABOVE_ITEM_LAYER
	src.station_explosion.mouse_opacity = FALSE
	src.station_explosion.screen_loc = "1,3"

	var/atom/movable/screen/using


//Radio
	src.adding += new /atom/movable/screen/robot/radio()

//Generic overlays

	using = new src.h_type(src) //Right hud bar
	using.dir = SOUTH
	using.icon = 'icons/hud/robot/robot.dmi'
	using.screen_loc = "EAST+1,SOUTH to EAST+1,NORTH"
	src.adding += using

	using = new src.h_type(src) //Lower hud bar
	using.dir = EAST
	using.icon = 'icons/hud/robot/robot.dmi'
	using.screen_loc = "WEST,SOUTH-1 to EAST,SOUTH-1"
	src.adding += using

	using = new src.h_type(src) //Corner Button
	using.dir = NORTHWEST
	using.icon = 'icons/hud/robot/robot.dmi'
	using.screen_loc = "EAST+1,SOUTH-1"
	src.adding += using


//Module select

	using = new src.h_type( src )
	using.name = "module1"
	using.dir = SOUTHWEST
	using.icon = 'icons/hud/robot/robot.dmi'
	using.icon_state = "inv1"
	using.screen_loc = ui_inv1
	src.adding += using
	mymob:inv1 = using

	using = new src.h_type( src )
	using.name = "module2"
	using.dir = SOUTHWEST
	using.icon = 'icons/hud/robot/robot.dmi'
	using.icon_state = "inv2"
	using.screen_loc = ui_inv2
	src.adding += using
	mymob:inv2 = using

	using = new src.h_type( src )
	using.name = "module3"
	using.dir = SOUTHWEST
	using.icon = 'icons/hud/robot/robot.dmi'
	using.icon_state = "inv3"
	using.screen_loc = ui_inv3
	src.adding += using
	mymob:inv3 = using

//End of module select

//Intent
	using = new src.h_type( src )
	using.name = "act_intent"
	using.dir = SOUTHWEST
	using.icon = 'icons/hud/robot/robot.dmi'
	using.icon_state = (mymob.a_intent == "hurt" ? "harm" : mymob.a_intent)
	using.screen_loc = ui_acti
	src.adding += using
	action_intent = using

	using = new src.h_type( src )
	using.name = "arrowleft"
	using.icon = 'icons/hud/robot/robot.dmi'
	using.icon_state = "s_arrow"
	using.dir = WEST
	using.screen_loc = ui_iarrowleft
	src.adding += using

	using = new src.h_type( src )
	using.name = "arrowright"
	using.icon = 'icons/hud/robot/robot.dmi'
	using.icon_state = "s_arrow"
	using.dir = EAST
	using.screen_loc = ui_iarrowright
	src.adding += using
//End of Intent

//Cell
	mymob:cells = new /atom/movable/screen( null )
	mymob:cells.icon = 'icons/hud/robot/robot.dmi'
	mymob:cells.icon_state = "charge-empty"
	mymob:cells.name = "cell"
	mymob:cells.screen_loc = ui_toxin

//Health
	mymob.healths = new /atom/movable/screen( null )
	mymob.healths.icon = 'icons/hud/robot/robot.dmi'
	mymob.healths.icon_state = "health0"
	mymob.healths.name = "health"
	mymob.healths.screen_loc = ui_health

	// Installed model
	mymob.hands = new /atom/movable/screen/robot/installed_model(_screen_loc = UI_DROPBUTTON)

//Module Panel
	src.adding += new /atom/movable/screen/robot/panel(_screen_loc = UI_THROW)

//Store
	mymob.throw_icon = new /atom/movable/screen/robot/store_module(_screen_loc = UI_HAND)

//Temp
	mymob.bodytemp = new /atom/movable/screen( null )
	mymob.bodytemp.icon_state = "temp0"
	mymob.bodytemp.name = "body temperature"
	mymob.bodytemp.screen_loc = ui_temp

//does nothing (fire and oxy)
	mymob.oxygen = new /atom/movable/screen( null )
	mymob.oxygen.icon = 'icons/hud/robot/robot.dmi'
	mymob.oxygen.icon_state = "oxy0"
	mymob.oxygen.name = "oxygen"
	mymob.oxygen.screen_loc = ui_oxygen

	mymob.fire = new /atom/movable/screen( null )
	mymob.fire.icon = 'icons/hud/robot/robot.dmi'
	mymob.fire.icon_state = "fire0"
	mymob.fire.name = "fire"
	mymob.fire.screen_loc = ui_fire



	mymob.pullin = new /atom/movable/screen/action/pull('icons/hud/robot/robot.dmi', UI_PULL)

	mymob.blind = new /atom/movable/screen( null )
	mymob.blind.icon = 'icons/hud/screen1_full.dmi''
	mymob.blind.icon_state = "blackimageoverlay"
	mymob.blind.name = " "
	mymob.blind.screen_loc = "1,1"
	mymob.blind.layer = 0
	mymob.blind.mouse_opacity = FALSE

	mymob.flash = new /atom/movable/screen( null )
	mymob.flash.icon = 'icons/hud/robot/robot.dmi'
	mymob.flash.icon_state = "blank"
	mymob.flash.name = "flash"
	mymob.flash.screen_loc = "1,1 to 15,15"
	mymob.flash.layer = 17

	mymob.sleep = new /atom/movable/screen( null )
	mymob.sleep.icon = 'icons/hud/robot/robot.dmi'
	mymob.sleep.icon_state = "sleep0"
	mymob.sleep.name = "sleep"
	mymob.sleep.screen_loc = ui_sleep

	mymob.rest = new /atom/movable/screen( null )
	mymob.rest.icon = 'icons/hud/robot/robot.dmi'
	mymob.rest.icon_state = "rest0"
	mymob.rest.name = "rest"
	mymob.rest.screen_loc = ui_rest


	mymob.zone_sel = new /atom/movable/screen/zone_sel( null )
	mymob.zone_sel.cut_overlays()
	mymob.zone_sel.add_overlay(image(icon = 'icons/hud/zone_sel.dmi', icon_state = "[mymob.zone_sel.selecting]"))

	mymob.client.screen.Cut()
	mymob.client.screen += list(
		mymob.throw_icon,
		mymob.zone_sel,
		mymob.oxygen,
		mymob.fire,
		mymob.hands,
		mymob.healths,
		mymob:cells,
		mymob.pullin,
		mymob.blind,
		mymob.flash,
		mymob.rest,
		mymob.sleep
	) //, mymob.mach)
	mymob.client.screen += src.adding + src.other

	return
