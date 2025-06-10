/datum/hud/alien_larva/setup()
	var/atom/movable/screen/using

	using = setup_screen_object("act_intent", 'icons/hud/screen1_alien.dmi', (owner.a_intent == "hurt" ? "harm" : owner.a_intent), UI_ACTI)
	using.set_dir(SOUTHWEST)
	adding.Add(using)
	action_intent = using

	using = new /atom/movable/screen/move_intent()
	using.icon = 'icons/hud/screen1_alien.dmi'
	using.icon_state = owner.move_intent.hud_icon_state
	adding.Add(using)
	move_intent = using

	owner.oxygen = setup_screen_object("oxygen", 'icons/hud/screen1_alien.dmi', "oxy0", UI_ALIEN_OXYGEN)
	owner.toxin = setup_screen_object("toxin", 'icons/hud/screen1_alien.dmi', "tox0", UI_ALIEN_TOXIN)
	owner.fire = setup_screen_object("fire", 'icons/hud/screen1_alien.dmi', "fire0", UI_ALIEN_FIRE)
	owner.healths = setup_screen_object("health", 'icons/hud/screen1_alien.dmi', "health0", UI_ALIEN_HEALTH)
	owner.pullin = new /atom/movable/screen/action/pull('icons/hud/screen1_alien.dmi', UI_PULL_RESIST)

	owner.blind = new /atom/movable/screen()
	owner.blind.icon = 'icons/hud/screen1_full.dmi'
	owner.blind.icon_state = "blackimageoverlay"
	owner.blind.name = " "
	owner.blind.screen_loc = "WEST,SOUTH"
	owner.blind.invisibility = INVISIBILITY_MAXIMUM // Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo

	owner.flash = new /atom/movable/screen()
	owner.flash.icon = 'icons/hud/screen1_alien.dmi'
	owner.flash.icon_state = "blank"
	owner.flash.name = "flash"
	owner.flash.screen_loc = "WEST,SOUTH to EAST,NORTH"
	owner.flash.plane = FULLSCREEN_PLANE

	owner.zone_sel = new /atom/movable/screen/zone_sel()
	owner.zone_sel.update_icon()

	. = ..()
	owner.client.screen.Add(list(
		owner.zone_sel,
		owner.oxygen,
		owner.toxin,
		owner.fire,
		owner.healths,
		owner.pullin,
		owner.blind,
		owner.flash
	)) //, owner.rest, owner.sleep, owner.mach )