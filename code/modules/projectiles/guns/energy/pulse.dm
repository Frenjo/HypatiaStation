/obj/item/gun/energy/pulse_rifle
	name = "pulse rifle"
	desc = "A heavy-duty, pulse-based energy weapon, preferred by front-line combat personnel."
	icon_state = "pulse"
	item_state = null	//so the human update icon uses the icon_state instead.

	force = 10

	fire_sound = 'sound/weapons/gun/pulse.ogg'
	fire_delay = 2.5 SECONDS

	cell_type = /obj/item/cell/super
	charge_cost = 200

	gun_setting = GUN_SETTING_DESTROY
	pulse_projectile_types = list(
		GUN_SETTING_STUN = /obj/item/projectile/energy/electrode,
		GUN_SETTING_KILL = /obj/item/projectile/energy/pulse/laser,
		GUN_SETTING_DESTROY = /obj/item/projectile/energy/pulse/pulse
	)
	beam_projectile_types = list(
		GUN_SETTING_STUN = /obj/item/projectile/energy/electrode,
		GUN_SETTING_KILL = /obj/item/projectile/energy/beam/laser,
		GUN_SETTING_DESTROY = /obj/item/projectile/energy/beam/pulse
	)

/obj/item/gun/energy/pulse_rifle/attack_self(mob/living/user)
	switch(gun_setting)
		if(GUN_SETTING_DESTROY)
			gun_setting = GUN_SETTING_STUN
			charge_cost = 100
			fire_sound = 'sound/weapons/gun/taser.ogg'
			to_chat(user, SPAN_WARNING("\The [src] is now set to stun."))
		if(GUN_SETTING_STUN)
			gun_setting = GUN_SETTING_KILL
			charge_cost = 100
			fire_sound = 'sound/weapons/gun/laser.ogg'
			to_chat(user, SPAN_WARNING("\The [src] is now set to kill."))
		if(GUN_SETTING_KILL)
			gun_setting = GUN_SETTING_DESTROY
			charge_cost = 200
			fire_sound = 'sound/weapons/gun/pulse.ogg'
			to_chat(user, SPAN_WARNING("\The [src] is now set to DESTROY."))

/obj/item/gun/energy/pulse_rifle/isHandgun()
	return FALSE

/obj/item/gun/energy/pulse_rifle/cyborg/load_into_chamber()
	if(in_chamber)
		return 1
	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		if(isnotnull(R.cell))
			R.cell.use(charge_cost)
			projectile_from_setting()
			in_chamber = new projectile_type(src)
			return 1
	return 0

/obj/item/gun/energy/pulse_rifle/destroyer
	name = "pulse destroyer"
	desc = "A heavy-duty, pulse-based energy weapon."

	cell_type = /obj/item/cell/infinite

/obj/item/gun/energy/pulse_rifle/destroyer/attack_self(mob/living/user)
	to_chat(user, SPAN_WARNING("\The [src] has three settings, and they are all DESTROY."))

/obj/item/gun/energy/pulse_rifle/M1911
	name = "m1911-P"
	desc = "It's not the size of the gun, it's the size of the hole it puts through people."
	icon_state = "m1911-p"

	cell_type = /obj/item/cell/infinite

/obj/item/gun/energy/pulse_rifle/M1911/isHandgun()
	return TRUE