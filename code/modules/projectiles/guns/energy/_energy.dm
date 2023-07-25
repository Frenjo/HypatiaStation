/obj/item/gun/energy
	name = "energy gun"
	desc = "A basic energy-based gun."
	icon_state = "energy"

	fire_sound = 'sound/weapons/Taser.ogg'

	var/modifystate = null

	var/obj/item/cell/power_supply	// The installed power cell.
	var/cell_type = /obj/item/cell	// What type of power cell this uses.
	var/charge_cost = 100			// How much energy is needed to fire.

	var/has_firemodes = TRUE
	var/gun_mode = GUN_MODE_PULSE
	var/gun_setting = GUN_SETTING_STUN
	var/list/pulse_projectile_types = list()
	var/list/beam_projectile_types = list()
	var/projectile_type

/obj/item/gun/energy/emp_act(severity)
	. = ..()
	power_supply.use(round(power_supply.maxcharge / severity))
	update_icon()

/obj/item/gun/energy/New()
	. = ..()
	if(isnotnull(cell_type))
		power_supply = new cell_type(src)
	else
		power_supply = new /obj/item/cell(src)
	power_supply.give(power_supply.maxcharge)

/obj/item/gun/energy/load_into_chamber()
	if(isnotnull(in_chamber))
		return 1
	if(isnull(power_supply))
		return 0

	projectile_from_setting()
	if(isnull(projectile_type))
		return 0 // Something went very wrong.

	if(!power_supply.use(gun_mode == GUN_MODE_PULSE ? charge_cost / 2 : charge_cost))
		return 0

	in_chamber = new projectile_type(src)
	return 1

/obj/item/gun/energy/update_icon()
	var/ratio = power_supply.charge / power_supply.maxcharge
	ratio = round(ratio, 0.25) * 100
	if(isnotnull(modifystate))
		icon_state = "[modifystate][ratio]"
	else
		icon_state = "[initial(icon_state)][ratio]"

/obj/item/gun/energy/AltClick(mob/user)
	if(!has_firemodes)
		to_chat(user, SPAN_WARNING("\The [src] does not have adjustable fire modes."))
		return

	switch(gun_mode)
		if(GUN_MODE_PULSE)
			gun_mode = GUN_MODE_BEAM
		if(GUN_MODE_BEAM)
			gun_mode = GUN_MODE_PULSE
	to_chat(user, SPAN_WARNING("\The [src]'s firing mode is now set to [gun_mode == GUN_MODE_PULSE ? "pulse" : "beam"]."))

/obj/item/gun/energy/proc/projectile_from_setting()
	// This still looks really ugly but it's a second implementation and I can fix it again later. -Frenjo
	switch(gun_mode)
		if(GUN_MODE_PULSE)
			projectile_type = pulse_projectile_types[gun_setting]

		if(GUN_MODE_BEAM)
			projectile_type = beam_projectile_types[gun_setting]