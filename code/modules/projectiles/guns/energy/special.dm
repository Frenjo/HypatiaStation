/obj/item/gun/energy/decloner
	name = "biological demolecularisor"
	desc = "A gun that discharges high amounts of controlled radiation to slowly break a target into component elements."
	icon_state = "decloner"

	origin_tech = list(RESEARCH_TECH_COMBAT = 5, RESEARCH_TECH_MATERIALS = 4, RESEARCH_TECH_POWERSTORAGE = 3)

	fire_sound = 'sound/weapons/pulse3.ogg'

	gun_setting = GUN_SETTING_SPECIAL
	pulse_projectile_types = list(GUN_SETTING_SPECIAL = /obj/item/projectile/energy/declone)

/obj/item/gun/energy/floragun
	name = "floral somatoray"
	desc = "A tool that discharges controlled radiation which induces mutation in plant cells."
	icon_state = "floramut100"

	origin_tech = list(RESEARCH_TECH_MATERIALS = 2, RESEARCH_TECH_BIOTECH = 3, RESEARCH_TECH_POWERSTORAGE = 3)

	fire_sound = 'sound/effects/stealthoff.ogg'

	modifystate = "floramut"

	gun_setting = GUN_SETTING_KILL
	pulse_projectile_types = list(
		GUN_SETTING_KILL = /obj/item/projectile/energy/floramut,
		GUN_SETTING_SPECIAL = /obj/item/projectile/energy/florayield
	)

	var/charge_tick = 0

/obj/item/gun/energy/floragun/New()
	. = ..()
	GLOBL.processing_objects.Add(src)

/obj/item/gun/energy/floragun/Destroy()
	GLOBL.processing_objects.Remove(src)
	return ..()

/obj/item/gun/energy/floragun/process()
	charge_tick++
	if(charge_tick < 4)
		return 0
	charge_tick = 0
	if(isnull(power_supply))
		return 0
	power_supply.give(100)
	update_icon()
	return 1

/obj/item/gun/energy/floragun/attack_self(mob/living/user as mob)
	switch(gun_setting)
		if(GUN_SETTING_KILL)
			gun_setting = GUN_SETTING_SPECIAL
			charge_cost = 100
			to_chat(user, SPAN_WARNING("\The [name] is now set to increase yield."))
			modifystate = "florayield"
		if(GUN_SETTING_SPECIAL)
			gun_setting = GUN_SETTING_KILL
			charge_cost = 100
			to_chat(user, SPAN_WARNING("\The [name] is now set to induce mutations."))
			modifystate = "floramut"
	update_icon()

/obj/item/gun/energy/meteorgun
	name = "meteor gun"
	desc = "For the love of god, make sure you're aiming this the right way!"
	icon_state = "riotgun"
	item_state = "c20r"

	w_class = 4

	clumsy_check = FALSE // Admin spawn only, might as well let clowns use it.

	cell_type = /obj/item/cell/potato

	gun_setting = GUN_SETTING_SPECIAL
	pulse_projectile_types = list(GUN_SETTING_SPECIAL = /obj/item/projectile/meteor)

	var/charge_tick = 0
	var/recharge_time = 0.5 SECONDS // Time it takes for shots to recharge (in ticks)

/obj/item/gun/energy/meteorgun/New()
	. = ..()
	GLOBL.processing_objects.Add(src)

/obj/item/gun/energy/meteorgun/Destroy()
	GLOBL.processing_objects.Remove(src)
	return ..()

/obj/item/gun/energy/meteorgun/process()
	charge_tick++
	if(charge_tick < recharge_time)
		return 0
	charge_tick = 0
	if(isnull(power_supply))
		return 0
	power_supply.give(100)

/obj/item/gun/energy/meteorgun/update_icon()
	return

/obj/item/gun/energy/meteorgun/pen
	name = "meteor pen"
	desc = "The pen is mightier than the sword."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	item_state = "pen"

	w_class = 1

/obj/item/gun/energy/mindflayer
	name = "mind flayer"
	desc = "A prototype weapon recovered from the ruins of Research-Station Epsilon."
	icon_state = "xray"

	fire_sound = 'sound/weapons/Laser.ogg'

	gun_mode = GUN_MODE_BEAM
	gun_setting = GUN_SETTING_SPECIAL
	beam_projectile_types = list(GUN_SETTING_SPECIAL = /obj/item/projectile/energy/beam/mindflayer)

/obj/item/gun/energy/toxgun
	name = "plasma pistol"
	desc = "A specialized firearm designed to fire lethal bolts of toxins."
	icon_state = "toxgun"

	origin_tech = list(RESEARCH_TECH_COMBAT = 5, RESEARCH_TECH_PLASMATECH = 4)

	fire_sound = 'sound/effects/stealthoff.ogg'

	gun_setting = GUN_SETTING_SPECIAL
	pulse_projectile_types = list(GUN_SETTING_SPECIAL = /obj/item/projectile/energy/plasma)

/obj/item/gun/energy/sniperrifle
	name = "L.W.A.P. Sniper Rifle"
	desc = "A rifle constructed of lightweight materials, fitted with a SMART aiming-system scope."
	icon_state = "sniper"

	w_class = 4
	slot_flags = SLOT_BACK
	origin_tech = list(RESEARCH_TECH_COMBAT = 6, RESEARCH_TECH_MATERIALS = 5, RESEARCH_TECH_POWERSTORAGE = 4)

	fire_sound = 'sound/weapons/marauder.ogg'
	fire_delay = 3.5 SECONDS

	charge_cost = 250

	gun_setting = GUN_SETTING_SPECIAL
	pulse_projectile_types = list(GUN_SETTING_SPECIAL = /obj/item/projectile/energy/pulse/sniper)
	beam_projectile_types = list(GUN_SETTING_SPECIAL = /obj/item/projectile/energy/beam/sniper)

	var/zoom = FALSE

/obj/item/gun/energy/sniperrifle/dropped(mob/user)
	user.client.view = world.view

/*
This is called from
modules/mob/mob_movement.dm if you move you will be zoomed out
modules/mob/living/carbon/human/life.dm if you die, you will be zoomed out.
*/
/obj/item/gun/energy/sniperrifle/verb/zoom()
	set category = PANEL_OBJECT
	set name = "Use Sniper Scope"
	set popup_menu = 0

	if(usr.stat || !ishuman(usr))
		to_chat(usr, "You are unable to focus down the scope of the rifle.")
		return
	if(!zoom && (GLOBL.global_hud.darkMask[1] in usr.client.screen))
		to_chat(usr, "Your welding equipment gets in the way of you looking down the scope.")
		return
	if(!zoom && usr.get_active_hand() != src)
		to_chat(usr, "You are too distracted to look down the scope, perhaps if it was in your active hand this might work better.")
		return

	if(usr.client.view == world.view)
		if(!usr.hud_used.hud_shown)
			usr.button_pressed_F12(TRUE)	// If the user has already limited their HUD this avoids them having a HUD when they zoom in
		usr.button_pressed_F12(TRUE)
		usr.client.view = 12
		zoom = 1
	else
		usr.client.view = world.view
		if(!usr.hud_used.hud_shown)
			usr.button_pressed_F12(TRUE)
		zoom = 0
	to_chat(usr, "<font color='[zoom ? "blue" : "red"]'>Zoom mode [zoom ? "en" : "dis"]abled.</font>")