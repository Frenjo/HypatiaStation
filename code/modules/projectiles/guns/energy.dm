/obj/item/weapon/gun/energy
	icon_state = "energy"
	name = "energy gun"
	desc = "A basic energy-based gun."
	fire_sound = 'sound/weapons/Taser.ogg'

	var/obj/item/weapon/cell/power_supply //What type of power cell this uses
	var/charge_cost = 100 //How much energy is needed to fire.
	var/cell_type = /obj/item/weapon/cell
	var/gun_mode = GUN_MODE_PULSE
	var/gun_setting = GUN_SETTING_STUN
	var/projectile_type
	var/modifystate

/obj/item/weapon/gun/energy/emp_act(severity)
	power_supply.use(round(power_supply.maxcharge / severity))
	update_icon()
	..()

/obj/item/weapon/gun/energy/New()
	..()
	if(cell_type)
		power_supply = new cell_type(src)
	else
		power_supply = new(src)
	power_supply.give(power_supply.maxcharge)
	return

/obj/item/weapon/gun/energy/load_into_chamber()
	if(in_chamber)
		return 1
	if(!power_supply)
		return 0
	if(!power_supply.use(gun_mode == GUN_MODE_PULSE ? charge_cost : charge_cost * 2))
		return 0

	projectile_from_settings()
	if(!projectile_type)
		return 0

	in_chamber = new projectile_type(src)
	return 1

/obj/item/weapon/gun/energy/update_icon()
	var/ratio = power_supply.charge / power_supply.maxcharge
	ratio = round(ratio, 0.25) * 100
	if(modifystate)
		icon_state = "[modifystate][ratio]"
	else
		icon_state = "[initial(icon_state)][ratio]"

/obj/item/weapon/gun/energy/AltClick(mob/user)
	if(gun_setting == GUN_SETTING_SPECIAL)
		to_chat(user, SPAN_WARNING("\The [src] does not have adjustable fire modes."))
		return
	switch(gun_mode)
		if(GUN_MODE_PULSE)
			if(gun_setting == GUN_SETTING_STUN)
				to_chat(user, SPAN_WARNING("\The [src] is set to stun, there is no beam setting."))
				return
			else
				gun_mode = GUN_MODE_BEAM
		if(GUN_MODE_BEAM)
			gun_mode = GUN_MODE_PULSE
	to_chat(user, SPAN_WARNING("\The [src]'s firing mode is now set to [gun_mode == GUN_MODE_PULSE ? "pulse" : "beam"]."))
	return

/obj/item/weapon/gun/energy/proc/projectile_from_settings()
	// This looks really ugly but it's a first implementation and I can fix it later. -Frenjo
	if(gun_setting == GUN_SETTING_SPECIAL)
		return // This is ignored so the type can be set in the gun itself for special things.

	switch(gun_mode)
		if(GUN_MODE_PULSE)
			switch(gun_setting)
				if(GUN_SETTING_STUN)
					projectile_type = /obj/item/projectile/energy/electrode
				if(GUN_SETTING_DISABLE)
					projectile_type = /obj/item/projectile/energy/pulse/disabler
				if(GUN_SETTING_KILL)
					projectile_type = /obj/item/projectile/energy/pulse/laser
				if(GUN_SETTING_DESTROY)
					projectile_type = /obj/item/projectile/energy/pulse/pulse

		if(GUN_MODE_BEAM)
			switch(gun_setting)
				if(GUN_SETTING_STUN)
					return // Stun guns don't get a beam setting, maybe they will in future.
				if(GUN_SETTING_DISABLE)
					projectile_type = /obj/item/projectile/energy/beam/disabler
				if(GUN_SETTING_KILL)
					projectile_type = /obj/item/projectile/energy/beam/laser
				if(GUN_SETTING_DESTROY)
					projectile_type = /obj/item/projectile/energy/beam/pulse
	return