/obj/item/gun/energy
	name = "energy gun"
	desc = "A basic energy-based gun."
	icon_state = "energy"

	fire_sound = 'sound/weapons/gun/taser.ogg'

	var/modifystate = null

	var/obj/item/cell/power_supply	// The installed power cell.
	var/cell_type = /obj/item/cell	// What type of power cell this uses.
	var/charge_cost = 100			// How much energy is needed to fire.

	// This one is set TRUE/FALSE automatically based on whether both...
	// ... pulse_projectile_types and beam_projectile_types are lists or null.
	var/has_firemodes
	var/gun_mode = GUN_MODE_PULSE
	var/gun_setting = GUN_SETTING_STUN
	var/list/pulse_projectile_types = null
	var/list/beam_projectile_types = null
	var/projectile_type

	var/self_charging = FALSE // Set to TRUE if the gun is self-charging or used as a cyborg module.
	var/charge_tick = 0
	var/recharge_time = 1 SECOND // Time it takes for shots to recharge (in ticks)

/obj/item/gun/energy/New()
	. = ..()
	// If both lists have been assigned on a subtype, then it has firemodes, otherwise it doesn't and is locked at its default.
	has_firemodes = (isnotnull(pulse_projectile_types) && isnotnull(beam_projectile_types))

	if(isnotnull(cell_type))
		power_supply = new cell_type(src)
	else
		power_supply = new /obj/item/cell(src)

	GLOBL.processing_objects.Add(src)

/obj/item/gun/energy/Destroy()
	GLOBL.processing_objects.Remove(src)
	return ..()

/obj/item/gun/energy/process()
	if(!self_charging)
		return PROCESS_KILL

	charge_tick++
	if(charge_tick < recharge_time)
		return 0
	charge_tick = 0

	if(isnull(power_supply))
		return 0 // Sanity.
	if(power_supply.charge >= power_supply.maxcharge)
		return 0 // Checks if we actually need to recharge.
	if(failcheck())
		return 0 // Checks if the gun is going to fail.

	if(isrobot(loc)) // If it's a cyborg gun...
		var/mob/living/silicon/robot/R = loc
		if(isnotnull(R?.cell))
			R.cell.use(charge_cost) // Takes power from the borg to recharge the shot.

	power_supply.give(charge_cost)
	update_icon()

// Returns TRUE if the gun fails.
/obj/item/gun/energy/proc/failcheck()
	return FALSE

/obj/item/gun/energy/emp_act(severity)
	. = ..()
	power_supply.use(round(power_supply.maxcharge / severity))
	update_icon()

/obj/item/gun/energy/load_into_chamber()
	if(isnotnull(in_chamber))
		return TRUE
	if(isnull(power_supply))
		return FALSE

	projectile_from_setting()
	if(isnull(projectile_type))
		return FALSE // Something went very wrong.

	if(!power_supply.use(gun_mode == GUN_MODE_PULSE ? charge_cost / 2 : charge_cost))
		return FALSE

	in_chamber = new projectile_type(src)
	return TRUE

/obj/item/gun/energy/update_icon()
	var/ratio = power_supply.charge / power_supply.maxcharge
	ratio = round(ratio, 0.25) * 100
	if(isnotnull(modifystate))
		icon_state = "[modifystate][ratio]"
	else
		icon_state = "[initial(icon_state)][ratio]"

/obj/item/gun/energy/AltClick(mob/user)
	if(!has_firemodes)
		to_chat(user, SPAN_WARNING("\The [src] does not have adjustable firing modes."))
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