/datum/hud/proc/larva_hud()
	adding = list()
	other = list()

	var/atom/movable/screen/using

	using = new /atom/movable/screen()
	using.name = "act_intent"
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/mob/screen/screen1_alien.dmi'
	using.icon_state = (mymob.a_intent == "hurt" ? "harm" : mymob.a_intent)
	using.screen_loc = UI_ACTI
	adding.Add(using)
	action_intent = using

	using = new /atom/movable/screen/move_intent()
	using.icon = 'icons/mob/screen/screen1_alien.dmi'
	using.icon_state = mymob.move_intent.hud_icon_state
	adding.Add(using)
	move_intent = using

	mymob.oxygen = new /atom/movable/screen()
	mymob.oxygen.icon = 'icons/mob/screen/screen1_alien.dmi'
	mymob.oxygen.icon_state = "oxy0"
	mymob.oxygen.name = "oxygen"
	mymob.oxygen.screen_loc = UI_ALIEN_OXYGEN

	mymob.toxin = new /atom/movable/screen()
	mymob.toxin.icon = 'icons/mob/screen/screen1_alien.dmi'
	mymob.toxin.icon_state = "tox0"
	mymob.toxin.name = "toxin"
	mymob.toxin.screen_loc = UI_ALIEN_TOXIN


	mymob.fire = new /atom/movable/screen()
	mymob.fire.icon = 'icons/mob/screen/screen1_alien.dmi'
	mymob.fire.icon_state = "fire0"
	mymob.fire.name = "fire"
	mymob.fire.screen_loc = UI_ALIEN_FIRE


	mymob.healths = new /atom/movable/screen()
	mymob.healths.icon = 'icons/mob/screen/screen1_alien.dmi'
	mymob.healths.icon_state = "health0"
	mymob.healths.name = "health"
	mymob.healths.screen_loc = UI_ALIEN_HEALTH

	mymob.pullin = new /atom/movable/screen()
	mymob.pullin.icon = 'icons/mob/screen/screen1_alien.dmi'
	mymob.pullin.icon_state = "pull0"
	mymob.pullin.name = "pull"
	mymob.pullin.screen_loc = UI_PULL_RESIST

	mymob.blind = new /atom/movable/screen()
	mymob.blind.icon = 'icons/mob/screen/screen1_full.dmi'
	mymob.blind.icon_state = "blackimageoverlay"
	mymob.blind.name = " "
	mymob.blind.screen_loc = "1,1"
	mymob.blind.invisibility = INVISIBILITY_MAXIMUM // Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo

	mymob.flash = new /atom/movable/screen()
	mymob.flash.icon = 'icons/mob/screen/screen1_alien.dmi'
	mymob.flash.icon_state = "blank"
	mymob.flash.name = "flash"
	mymob.flash.screen_loc = "1,1 to 15,15"
	mymob.flash.plane = FULLSCREEN_PLANE

	mymob.zone_sel = new /atom/movable/screen/zone_sel()
	mymob.zone_sel.update_icon()

	mymob.client.screen.Cut()
	mymob.client.screen.Add(list(
		mymob.zone_sel,
		mymob.oxygen,
		mymob.toxin,
		mymob.fire,
		mymob.healths,
		mymob.pullin,
		mymob.blind,
		mymob.flash
	)) //, mymob.rest, mymob.sleep, mymob.mach )
	mymob.client.screen.Add(adding + other)