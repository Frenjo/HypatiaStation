/datum/hud/proc/alien_hud()
	src.adding = list()
	src.other = list()

	var/obj/screen/using
	var/obj/screen/inventory/inv_box

	using = new /obj/screen()
	using.name = "act_intent"
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/mob/screen/screen1_alien.dmi'
	using.icon_state = (mymob.a_intent == "hurt" ? "harm" : mymob.a_intent)
	using.screen_loc = UI_ACTI
	using.layer = 20
	src.adding += using
	action_intent = using

//intent small hud objects
	var/icon/ico

	ico = new('icons/mob/screen/screen1_alien.dmi', "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255, 255, 255, 1), 1, ico.Height() / 2, ico.Width() / 2, ico.Height())
	using = new /obj/screen(src)
	using.name = "help"
	using.icon = ico
	using.screen_loc = UI_ACTI
	using.layer = 21
	src.adding += using
	help_intent = using

	ico = new('icons/mob/screen/screen1_alien.dmi', "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255, 255, 255, 1),ico.Width() / 2, ico.Height() / 2, ico.Width(), ico.Height())
	using = new /obj/screen(src)
	using.name = "disarm"
	using.icon = ico
	using.screen_loc = UI_ACTI
	using.layer = 21
	src.adding += using
	disarm_intent = using

	ico = new('icons/mob/screen/screen1_alien.dmi', "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255, 255, 255, 1), ico.Width() / 2, 1, ico.Width(), ico.Height() / 2)
	using = new /obj/screen(src)
	using.name = "grab"
	using.icon = ico
	using.screen_loc = UI_ACTI
	using.layer = 21
	src.adding += using
	grab_intent = using

	ico = new('icons/mob/screen/screen1_alien.dmi', "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255, 255, 255, 1), 1, 1, ico.Width() / 2, ico.Height() / 2)
	using = new /obj/screen(src)
	using.name = "harm"
	using.icon = ico
	using.screen_loc = UI_ACTI
	using.layer = 21
	src.adding += using
	hurt_intent = using

//end intent small hud objects

	using = new /obj/screen()
	using.name = "mov_intent"
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/mob/screen/screen1_alien.dmi'
	using.icon_state = mymob.move_intent.hud_icon_state
	using.screen_loc = UI_MOVI
	using.layer = 20
	src.adding += using
	move_intent = using

	using = new /obj/screen()
	using.name = "drop"
	using.icon = 'icons/mob/screen/screen1_alien.dmi'
	using.icon_state = "act_drop"
	using.screen_loc = UI_DROP_THROW
	using.layer = 19
	src.adding += using

//equippable shit
	//suit
	inv_box = new /obj/screen/inventory()
	inv_box.name = "o_clothing"
	inv_box.set_dir(SOUTH)
	inv_box.icon = 'icons/mob/screen/screen1_alien.dmi'
	inv_box.icon_state = "equip"
	inv_box.screen_loc = UI_ALIEN_OCLOTHING
	inv_box.slot_id = SLOT_ID_WEAR_SUIT
	inv_box.layer = 19
	src.adding += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "r_hand"
	inv_box.set_dir(WEST)
	inv_box.icon = 'icons/mob/screen/screen1_alien.dmi'
	inv_box.icon_state = "hand_inactive"
	if(mymob && !mymob.hand)	//This being 0 or null means the right hand is in use
		using.icon_state = "hand_active"
	inv_box.screen_loc = UI_RHAND
	inv_box.layer = 19
	src.r_hand_hud_object = inv_box
	inv_box.slot_id = SLOT_ID_R_HAND
	src.adding += inv_box

	inv_box = new /obj/screen/inventory()
	inv_box.name = "l_hand"
	inv_box.set_dir(EAST)
	inv_box.icon = 'icons/mob/screen/screen1_alien.dmi'
	inv_box.icon_state = "hand_inactive"
	if(mymob && mymob.hand)	//This being 1 means the left hand is in use
		inv_box.icon_state = "hand_active"
	inv_box.screen_loc = UI_LHAND
	inv_box.layer = 19
	inv_box.slot_id = SLOT_ID_L_HAND
	src.l_hand_hud_object = inv_box
	src.adding += inv_box

	using = new /obj/screen/inventory()
	using.name = "hand"
	using.set_dir(SOUTH)
	using.icon = 'icons/mob/screen/screen1_alien.dmi'
	using.icon_state = "hand1"
	using.screen_loc = UI_SWAPHAND1
	using.layer = 19
	src.adding += using

	using = new /obj/screen/inventory()
	using.name = "hand"
	using.set_dir(SOUTH)
	using.icon = 'icons/mob/screen/screen1_alien.dmi'
	using.icon_state = "hand2"
	using.screen_loc = UI_SWAPHAND2
	using.layer = 19
	src.adding += using

	//pocket 1
	inv_box = new /obj/screen/inventory()
	inv_box.name = "storage1"
	inv_box.icon = 'icons/mob/screen/screen1_alien.dmi'
	inv_box.icon_state = "pocket"
	inv_box.screen_loc = UI_STORAGE1
	inv_box.slot_id = SLOT_ID_L_STORE
	inv_box.layer = 19
	src.adding += inv_box

	//pocket 2
	inv_box = new /obj/screen/inventory()
	inv_box.name = "storage2"
	inv_box.icon = 'icons/mob/screen/screen1_alien.dmi'
	inv_box.icon_state = "pocket"
	inv_box.screen_loc = UI_STORAGE2
	inv_box.slot_id = SLOT_ID_R_STORE
	inv_box.layer = 19
	src.adding += inv_box

	//head
	inv_box = new /obj/screen/inventory()
	inv_box.name = "head"
	inv_box.icon = 'icons/mob/screen/screen1_alien.dmi'
	inv_box.icon_state = "hair"
	inv_box.screen_loc = UI_ALIEN_HEAD
	inv_box.slot_id = SLOT_ID_HEAD
	inv_box.layer = 19
	src.adding += inv_box
//end of equippable shit

/*
	using = new /obj/screen()
	using.name = "resist"
	using.icon = 'icons/mob/screen/screen1_alien.dmi'
	using.icon_state = "act_resist"
	using.screen_loc = ui_resist
	using.layer = 19
	src.adding += using
*/

	mymob.throw_icon = new /obj/screen()
	mymob.throw_icon.icon = 'icons/mob/screen/screen1_alien.dmi'
	mymob.throw_icon.icon_state = "act_throw_off"
	mymob.throw_icon.name = "throw"
	mymob.throw_icon.screen_loc = UI_DROP_THROW

	mymob.oxygen = new /obj/screen()
	mymob.oxygen.icon = 'icons/mob/screen/screen1_alien.dmi'
	mymob.oxygen.icon_state = "oxy0"
	mymob.oxygen.name = "oxygen"
	mymob.oxygen.screen_loc = UI_ALIEN_OXYGEN

	mymob.toxin = new /obj/screen()
	mymob.toxin.icon = 'icons/mob/screen/screen1_alien.dmi'
	mymob.toxin.icon_state = "tox0"
	mymob.toxin.name = "toxin"
	mymob.toxin.screen_loc = UI_ALIEN_TOXIN

	mymob.fire = new /obj/screen()
	mymob.fire.icon = 'icons/mob/screen/screen1_alien.dmi'
	mymob.fire.icon_state = "fire0"
	mymob.fire.name = "fire"
	mymob.fire.screen_loc = UI_ALIEN_FIRE

	mymob.healths = new /obj/screen()
	mymob.healths.icon = 'icons/mob/screen/screen1_alien.dmi'
	mymob.healths.icon_state = "health0"
	mymob.healths.name = "health"
	mymob.healths.screen_loc = UI_ALIEN_HEALTH

	mymob.pullin = new /obj/screen()
	mymob.pullin.icon = 'icons/mob/screen/screen1_alien.dmi'
	mymob.pullin.icon_state = "pull0"
	mymob.pullin.name = "pull"
	mymob.pullin.screen_loc = UI_PULL_RESIST

	mymob.blind = new /obj/screen()
	mymob.blind.icon = 'icons/mob/screen/screen1_full.dmi'
	mymob.blind.icon_state = "blackimageoverlay"
	mymob.blind.name = " "
	mymob.blind.screen_loc = "1,1"
	mymob.blind.invisibility = INVISIBILITY_MAXIMUM // Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo

	mymob.flash = new /obj/screen()
	mymob.flash.icon = 'icons/mob/screen/screen1_alien.dmi'
	mymob.flash.icon_state = "blank"
	mymob.flash.name = "flash"
	mymob.flash.screen_loc = "1,1 to 15,15"
	mymob.flash.layer = 17

	mymob.zone_sel = new /obj/screen/zone_sel()
	mymob.zone_sel.icon = 'icons/mob/screen/screen1_alien.dmi'
	mymob.zone_sel.overlays.Cut()
	mymob.zone_sel.overlays += image('icons/mob/screen/zone_sel.dmi', "[mymob.zone_sel.selecting]")

	mymob.client.screen.Cut()
	mymob.client.screen += list(
		mymob.throw_icon,
		mymob.zone_sel,
		mymob.oxygen,
		mymob.toxin,
		mymob.fire,
		mymob.healths,
		mymob.pullin,
		mymob.blind,
		mymob.flash
	) //, mymob.hands, mymob.rest, mymob.sleep, mymob.mach )
	mymob.client.screen += src.adding + src.other