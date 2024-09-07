/datum/hud/alien/setup()
	var/atom/movable/screen/using
	var/atom/movable/screen/inventory/inv_box

	using = setup_screen_object("act_intent", 'icons/mob/screen/screen1_alien.dmi', (owner.a_intent == "hurt" ? "harm" : owner.a_intent), UI_ACTI)
	using.set_dir(SOUTHWEST)
	adding.Add(using)
	action_intent = using

	// Small action intent boxes.
	adding.Add(
		new /atom/movable/screen/action_intent/help(src, 'icons/mob/screen/screen1_alien.dmi'),
		new /atom/movable/screen/action_intent/disarm(src, 'icons/mob/screen/screen1_alien.dmi'),
		new /atom/movable/screen/action_intent/grab(src, 'icons/mob/screen/screen1_alien.dmi'),
		new /atom/movable/screen/action_intent/harm(src, 'icons/mob/screen/screen1_alien.dmi')
	)
	// End small action intent boxes.

	using = new /atom/movable/screen/move_intent()
	using.icon = 'icons/mob/screen/screen1_alien.dmi'
	using.icon_state = owner.move_intent.hud_icon_state
	adding.Add(using)
	move_intent = using

	adding.Add(new /atom/movable/screen/action/drop('icons/mob/screen/screen1_alien.dmi', UI_DROP_THROW))

//equippable shit
	//suit
	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "o_clothing"
	inv_box.set_dir(SOUTH)
	inv_box.icon = 'icons/mob/screen/screen1_alien.dmi'
	inv_box.icon_state = "equip"
	inv_box.screen_loc = UI_ALIEN_OCLOTHING
	inv_box.slot_id = SLOT_ID_WEAR_SUIT
	adding.Add(inv_box)

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "r_hand"
	inv_box.set_dir(WEST)
	inv_box.icon = 'icons/mob/screen/screen1_alien.dmi'
	inv_box.icon_state = "hand_inactive"
	if(isnotnull(owner) && !owner.hand)	//This being 0 or null means the right hand is in use
		using.icon_state = "hand_active"
	inv_box.screen_loc = UI_RHAND
	r_hand_hud_object = inv_box
	inv_box.slot_id = SLOT_ID_R_HAND
	adding.Add(inv_box)

	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "l_hand"
	inv_box.set_dir(EAST)
	inv_box.icon = 'icons/mob/screen/screen1_alien.dmi'
	inv_box.icon_state = "hand_inactive"
	if(isnotnull(owner) && owner.hand)	//This being 1 means the left hand is in use
		inv_box.icon_state = "hand_active"
	inv_box.screen_loc = UI_LHAND
	inv_box.slot_id = SLOT_ID_L_HAND
	l_hand_hud_object = inv_box
	adding.Add(inv_box)

	using = new /atom/movable/screen/inventory()
	using.name = "hand"
	using.set_dir(SOUTH)
	using.icon = 'icons/mob/screen/screen1_alien.dmi'
	using.icon_state = "hand1"
	using.screen_loc = UI_SWAPHAND1
	adding.Add(using)

	using = new /atom/movable/screen/inventory()
	using.name = "hand"
	using.set_dir(SOUTH)
	using.icon = 'icons/mob/screen/screen1_alien.dmi'
	using.icon_state = "hand2"
	using.screen_loc = UI_SWAPHAND2
	adding.Add(using)

	//pocket 1
	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "storage1"
	inv_box.icon = 'icons/mob/screen/screen1_alien.dmi'
	inv_box.icon_state = "pocket"
	inv_box.screen_loc = UI_STORAGE1
	inv_box.slot_id = SLOT_ID_L_POCKET
	adding.Add(inv_box)

	//pocket 2
	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "storage2"
	inv_box.icon = 'icons/mob/screen/screen1_alien.dmi'
	inv_box.icon_state = "pocket"
	inv_box.screen_loc = UI_STORAGE2
	inv_box.slot_id = SLOT_ID_R_POCKET
	adding.Add(inv_box)

	//head
	inv_box = new /atom/movable/screen/inventory()
	inv_box.name = "head"
	inv_box.icon = 'icons/mob/screen/screen1_alien.dmi'
	inv_box.icon_state = "hair"
	inv_box.screen_loc = UI_ALIEN_HEAD
	inv_box.slot_id = SLOT_ID_HEAD
	adding.Add(inv_box)
//end of equippable shit

/*
	adding.Add(new /atom/movable/screen/action/resist('icons/mob/screen/screen1_alien.dmi', UI_RESIST))
*/

	owner.throw_icon = new /atom/movable/screen/action/throw_icon('icons/mob/screen/screen1_alien.dmi', UI_DROP_THROW)
	owner.oxygen = setup_screen_object("oxygen", 'icons/mob/screen/screen1_alien.dmi', "oxy0", UI_ALIEN_OXYGEN)
	owner.toxin = setup_screen_object("toxin", 'icons/mob/screen/screen1_alien.dmi', "tox0", UI_ALIEN_TOXIN)
	owner.fire = setup_screen_object("fire", 'icons/mob/screen/screen1_alien.dmi', "fire0", UI_ALIEN_FIRE)
	owner.healths = setup_screen_object("health", 'icons/mob/screen/screen1_alien.dmi', "health0", UI_ALIEN_HEALTH)
	owner.pullin = new /atom/movable/screen/action/pull('icons/mob/screen/screen1_alien.dmi', UI_PULL_RESIST)

	owner.blind = new /atom/movable/screen()
	owner.blind.icon = 'icons/mob/screen/screen1_full.dmi'
	owner.blind.icon_state = "blackimageoverlay"
	owner.blind.name = " "
	owner.blind.screen_loc = "WEST,SOUTH"
	owner.blind.invisibility = INVISIBILITY_MAXIMUM // Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo

	owner.flash = new /atom/movable/screen()
	owner.flash.icon = 'icons/mob/screen/screen1_alien.dmi'
	owner.flash.icon_state = "blank"
	owner.flash.name = "flash"
	owner.flash.screen_loc = "WEST,SOUTH to EAST,NORTH"
	owner.flash.plane = FULLSCREEN_PLANE

	owner.zone_sel = new /atom/movable/screen/zone_sel()
	owner.zone_sel.icon = 'icons/mob/screen/screen1_alien.dmi'
	owner.zone_sel.update_icon()

	owner.client.screen.Cut()
	owner.client.screen.Add(list(
		owner.throw_icon,
		owner.zone_sel,
		owner.oxygen,
		owner.toxin,
		owner.fire,
		owner.healths,
		owner.pullin,
		owner.blind,
		owner.flash
	)) //, owner.hands, owner.rest, owner.sleep, owner.mach )
	owner.client.screen.Add(adding + other)