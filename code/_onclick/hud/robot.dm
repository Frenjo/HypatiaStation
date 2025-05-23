/datum/hud/robot/setup()
	var/mob/living/silicon/robot/R = owner

	// Lights
	adding.Add(new /atom/movable/screen/robot/lights())

	// Radio
	adding.Add(new /atom/movable/screen/robot/radio())

	// Module selection.
	R.inv1 = new /atom/movable/screen/robot/active_module(1, UI_INV1)
	adding.Add(R.inv1)

	R.inv2 = new /atom/movable/screen/robot/active_module(2, UI_INV2)
	adding.Add(R.inv2)

	R.inv3 = new /atom/movable/screen/robot/active_module(3, UI_INV3)
	adding.Add(R.inv3)
	// End of module selection.

	// Action intent
	action_intent = new /atom/movable/screen/robot/action_intent()
	adding.Add(action_intent)

//Cell
	R.cells = setup_screen_object("cell", 'icons/hud/robot/robot.dmi', "charge-empty", UI_TOXIN)

//Health
	R.healths = setup_screen_object("health", 'icons/hud/robot/robot.dmi', "health0", UI_BORG_HEALTH)

	// Installed model
	R.hands = new /atom/movable/screen/robot/installed_model(_screen_loc = UI_BORG_MODEL)

	// Module panel
	adding.Add(new /atom/movable/screen/robot/panel(_screen_loc = UI_BORG_PANEL))

	// Store module
	R.throw_icon = new /atom/movable/screen/robot/store_module(_screen_loc = UI_BORG_STORE)

//Temp
	R.bodytemp = setup_screen_object("body temperature", 'icons/hud/screen1.dmi', "temp0", UI_TEMP)
	R.oxygen = setup_screen_object("oxygen", 'icons/hud/robot/robot.dmi', "oxy0", UI_OXYGEN)
	R.fire = setup_screen_object("fire", 'icons/hud/robot/robot.dmi', "fire0", UI_FIRE)
	R.pullin = new /atom/movable/screen/action/pull('icons/hud/robot/robot.dmi', UI_BORG_PULL)

	R.blind = new /atom/movable/screen()
	R.blind.icon = 'icons/hud/screen1_full.dmi'
	R.blind.icon_state = "blackimageoverlay"
	R.blind.name = " "
	R.blind.screen_loc = "WEST,SOUTH"
	R.blind.invisibility = INVISIBILITY_MAXIMUM // Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo

	R.flash = new /atom/movable/screen()
	R.flash.icon = 'icons/hud/robot/robot.dmi'
	R.flash.icon_state = "blank"
	R.flash.name = "flash"
	R.flash.screen_loc = "WEST,SOUTH to EAST,NORTH"
	R.flash.plane = FULLSCREEN_PLANE

	R.zone_sel = new /atom/movable/screen/zone_sel()
	R.zone_sel.icon = 'icons/hud/robot/robot.dmi'
	R.zone_sel.update_icon()

	//Handle the gun settings buttons
	R.gun_setting_icon = new /atom/movable/screen/gun/mode()
	if(isnotnull(R.client))
		if(R.client.gun_mode) // If in aim mode, correct the sprite
			R.gun_setting_icon.set_dir(2)
	for(var/obj/item/gun/G in R) // If targeting someone, display other buttons
		if(isnotnull(G.target))
			R.item_use_icon = new /atom/movable/screen/gun/item()
			if(R.client.target_can_click)
				R.item_use_icon.set_dir(1)
			adding.Add(R.item_use_icon)
			R.gun_move_icon = new /atom/movable/screen/gun/move()
			if(R.client.target_can_move)
				R.gun_move_icon.set_dir(1)
				R.gun_run_icon = new /atom/movable/screen/gun/run()
				if(R.client.target_can_run)
					R.gun_run_icon.set_dir(1)
				adding.Add(R.gun_run_icon)
			adding.Add(R.gun_move_icon)

	R.client.screen.Cut()
	R.client.screen.Add(list(
		R.throw_icon,
		R.zone_sel,
		R.oxygen,
		R.fire,
		R.hands,
		R.healths,
		R.cells,
		R.pullin,
		R.blind,
		R.flash,
		R.gun_setting_icon
	)) //, R.rest, R.sleep, R.mach )
	R.client.screen.Add(adding + other)