/datum/hud/robot/setup()
	var/mob/living/silicon/robot/owner = mymob
	var/atom/movable/screen/using

//Radio
	using = new /atom/movable/screen()
	using.name = "radio"
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/mob/screen/screen1_robot.dmi'
	using.icon_state = "radio"
	using.screen_loc = UI_MOVI
	adding.Add(using)

//Module select
	using = new /atom/movable/screen()
	using.name = "module1"
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/mob/screen/screen1_robot.dmi'
	using.icon_state = "inv1"
	using.screen_loc = UI_INV1
	adding.Add(using)
	owner.inv1 = using

	using = new /atom/movable/screen()
	using.name = "module2"
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/mob/screen/screen1_robot.dmi'
	using.icon_state = "inv2"
	using.screen_loc = UI_INV2
	adding.Add(using)
	owner.inv2 = using

	using = new /atom/movable/screen()
	using.name = "module3"
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/mob/screen/screen1_robot.dmi'
	using.icon_state = "inv3"
	using.screen_loc = UI_INV3
	adding.Add(using)
	owner.inv3 = using

//End of module select

//Intent
	using = new /atom/movable/screen()
	using.name = "act_intent"
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/mob/screen/screen1_robot.dmi'
	using.icon_state = (mymob.a_intent == "hurt" ? "harm" : mymob.a_intent)
	using.screen_loc = UI_ACTI
	adding.Add(using)
	action_intent = using

//Cell
	owner.cells = new /atom/movable/screen()
	owner.cells.icon = 'icons/mob/screen/screen1_robot.dmi'
	owner.cells.icon_state = "charge-empty"
	owner.cells.name = "cell"
	owner.cells.screen_loc = UI_TOXIN

//Health
	mymob.healths = new /atom/movable/screen()
	mymob.healths.icon = 'icons/mob/screen/screen1_robot.dmi'
	mymob.healths.icon_state = "health0"
	mymob.healths.name = "health"
	mymob.healths.screen_loc = UI_BORG_HEALTH

//Installed Module
	mymob.hands = new /atom/movable/screen()
	mymob.hands.icon = 'icons/mob/screen/screen1_robot.dmi'
	mymob.hands.icon_state = "nomod"
	mymob.hands.name = "module"
	mymob.hands.screen_loc = UI_BORG_MODULE

//Module Panel
	using = new /atom/movable/screen()
	using.name = "panel"
	using.icon = 'icons/mob/screen/screen1_robot.dmi'
	using.icon_state = "panel"
	using.screen_loc = UI_BORG_PANEL
	adding.Add(using)

//Store
	mymob.throw_icon = new /atom/movable/screen()
	mymob.throw_icon.icon = 'icons/mob/screen/screen1_robot.dmi'
	mymob.throw_icon.icon_state = "store"
	mymob.throw_icon.name = "store"
	mymob.throw_icon.screen_loc = UI_BORG_STORE

//Temp
	mymob.bodytemp = new /atom/movable/screen()
	mymob.bodytemp.icon_state = "temp0"
	mymob.bodytemp.name = "body temperature"
	mymob.bodytemp.screen_loc = UI_TEMP


	mymob.oxygen = new /atom/movable/screen()
	mymob.oxygen.icon = 'icons/mob/screen/screen1_robot.dmi'
	mymob.oxygen.icon_state = "oxy0"
	mymob.oxygen.name = "oxygen"
	mymob.oxygen.screen_loc = UI_OXYGEN

	mymob.fire = new /atom/movable/screen()
	mymob.fire.icon = 'icons/mob/screen/screen1_robot.dmi'
	mymob.fire.icon_state = "fire0"
	mymob.fire.name = "fire"
	mymob.fire.screen_loc = UI_FIRE

	mymob.pullin = new /atom/movable/screen()
	mymob.pullin.icon = 'icons/mob/screen/screen1_robot.dmi'
	mymob.pullin.icon_state = "pull0"
	mymob.pullin.name = "pull"
	mymob.pullin.screen_loc = UI_BORG_PULL

	mymob.blind = new /atom/movable/screen()
	mymob.blind.icon = 'icons/mob/screen/screen1_full.dmi'
	mymob.blind.icon_state = "blackimageoverlay"
	mymob.blind.name = " "
	mymob.blind.screen_loc = "1,1"
	mymob.blind.invisibility = INVISIBILITY_MAXIMUM // Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo

	mymob.flash = new /atom/movable/screen()
	mymob.flash.icon = 'icons/mob/screen/screen1_robot.dmi'
	mymob.flash.icon_state = "blank"
	mymob.flash.name = "flash"
	mymob.flash.screen_loc = "1,1 to 15,15"
	mymob.flash.plane = FULLSCREEN_PLANE

	mymob.zone_sel = new /atom/movable/screen/zone_sel()
	mymob.zone_sel.icon = 'icons/mob/screen/screen1_robot.dmi'
	mymob.zone_sel.update_icon()

	//Handle the gun settings buttons
	mymob.gun_setting_icon = new /atom/movable/screen/gun/mode()
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
	mymob.client.screen.Add(list(
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
		mymob.gun_setting_icon
	)) //, mymob.rest, mymob.sleep, mymob.mach )
	mymob.client.screen.Add(adding + other)