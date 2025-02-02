/obj/item/gun/energy/gun
	name = "energy gun"
	desc = "A basic energy-based gun with two settings: Stun and kill."
	icon_state = "energystun100"
	item_state = null	//so the human update icon uses the icon_state instead.

	origin_tech = list(/datum/tech/magnets = 2, /datum/tech/combat = 3)

	modifystate = "energystun"

	charge_cost = 100 // How much energy is needed to fire.

	projectile_type = /obj/item/projectile/energy/electrode
	pulse_projectile_types = list(
		GUN_SETTING_STUN = /obj/item/projectile/energy/electrode,
		GUN_SETTING_KILL = /obj/item/projectile/energy/pulse/laser
	)
	beam_projectile_types = list(
		GUN_SETTING_STUN = /obj/item/projectile/energy/electrode,
		GUN_SETTING_KILL = /obj/item/projectile/energy/beam/laser
	)

/obj/item/gun/energy/gun/attack_self(mob/living/user)
	switch(gun_setting)
		if(GUN_SETTING_STUN)
			gun_setting = GUN_SETTING_KILL
			charge_cost = 100
			fire_sound = 'sound/weapons/Laser.ogg'
			to_chat(user, SPAN_WARNING("\The [src] is now set to kill."))
			modifystate = "energykill"
		if(GUN_SETTING_KILL)
			gun_setting = GUN_SETTING_STUN
			charge_cost = 100
			fire_sound = 'sound/weapons/Taser.ogg'
			to_chat(user, SPAN_WARNING("\The [src] is now set to stun."))
			modifystate = "energystun"
	update_icon()

/obj/item/gun/energy/gun/nuclear
	name = "advanced energy gun"
	desc = "An energy gun with an experimental miniaturized reactor."
	icon_state = "nucgun"

	origin_tech = list(/datum/tech/materials = 5, /datum/tech/combat = 3, /datum/tech/power_storage = 3)

	var/lightfail = 0
	var/charge_tick = 0

/obj/item/gun/energy/gun/nuclear/New()
	. = ..()
	GLOBL.processing_objects.Add(src)

/obj/item/gun/energy/gun/nuclear/process()
	charge_tick++
	if(charge_tick < 4)
		return 0
	charge_tick = 0
	if(isnull(power_supply))
		return 0
	if((power_supply.charge / power_supply.maxcharge) != 1)
		if(!failcheck())
			return 0
		power_supply.give(100)
		update_icon()
	return 1

/obj/item/gun/energy/gun/nuclear/emp_act(severity)
	. = ..()
	reliability -= round(15 / severity)

/obj/item/gun/energy/gun/nuclear/update_icon()
	overlays.Cut()
	update_charge()
	update_reactor()
	update_mode()

/obj/item/gun/energy/gun/nuclear/proc/failcheck()
	lightfail = FALSE
	if(prob(reliability))
		return 1 //No failure

	if(prob(reliability))
		for(var/mob/living/M in range(0, src)) //Only a minor failure, enjoy your radiation if you're in the same tile or carrying it
			if(src in M.contents)
				to_chat(M, SPAN_WARNING("Your gun feels pleasantly warm for a moment."))
			else
				to_chat(M, SPAN_WARNING("You feel a warm sensation."))
			M.apply_effect(rand(3, 120), IRRADIATE)
		lightfail = TRUE
	else
		for(var/mob/living/M in range(rand(1, 4), src)) //Big failure, TIME FOR RADIATION BITCHES
			if(src in M.contents)
				to_chat(M, SPAN_WARNING("Your gun's reactor overloads!"))
			to_chat(M, SPAN_WARNING("You feel a wave of heat wash over you."))
			M.apply_effect(300, IRRADIATE)
		crit_fail = TRUE //break the gun so it stops recharging
		GLOBL.processing_objects.Remove(src)
		update_icon()
	return 0

/obj/item/gun/energy/gun/nuclear/proc/update_charge()
	if(crit_fail)
		overlays.Add("nucgun-whee")
		return
	var/ratio = power_supply.charge / power_supply.maxcharge
	ratio = round(ratio, 0.25) * 100
	overlays.Add("nucgun-[ratio]")

/obj/item/gun/energy/gun/nuclear/proc/update_reactor()
	if(crit_fail)
		overlays.Add("nucgun-crit")
		return
	if(lightfail)
		overlays.Add("nucgun-medium")
	else if((power_supply.charge / power_supply.maxcharge) <= 0.5)
		overlays.Add("nucgun-light")
	else
		overlays.Add("nucgun-clean")

/obj/item/gun/energy/gun/nuclear/proc/update_mode()
	if(gun_setting == GUN_SETTING_STUN)
		overlays.Add("nucgun-stun")
	else if(gun_setting == GUN_SETTING_KILL)
		overlays.Add("nucgun-kill")