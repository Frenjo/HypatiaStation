/obj/item/weapon/gun/energy/gun
	name = "energy gun"
	desc = "A basic energy-based gun with two settings: Stun and kill."
	icon_state = "energystun100"
	item_state = null	//so the human update icon uses the icon_state instead.
	fire_sound = 'sound/weapons/Taser.ogg'

	charge_cost = 100 //How much energy is needed to fire.
	projectile_type = /obj/item/projectile/energy/electrode
	pulse_projectile_types = list(
		GUN_SETTING_STUN = /obj/item/projectile/energy/electrode,
		GUN_SETTING_KILL = /obj/item/projectile/energy/pulse/laser
	)
	beam_projectile_types = list(
		GUN_SETTING_STUN = /obj/item/projectile/energy/electrode,
		GUN_SETTING_KILL = /obj/item/projectile/energy/beam/laser
	)
	origin_tech = list(RESEARCH_TECH_COMBAT = 3, RESEARCH_TECH_MAGNETS = 2)
	modifystate = "energystun"

/obj/item/weapon/gun/energy/gun/attack_self(mob/living/user as mob)
	switch(gun_setting)
		if(GUN_SETTING_STUN)
			gun_setting = GUN_SETTING_KILL
			charge_cost = 100
			fire_sound = 'sound/weapons/Laser.ogg'
			to_chat(user, SPAN_WARNING("\The [src.name] is now set to kill."))
			modifystate = "energykill"
		if(GUN_SETTING_KILL)
			gun_setting = GUN_SETTING_STUN
			charge_cost = 100
			fire_sound = 'sound/weapons/Taser.ogg'
			to_chat(user, SPAN_WARNING("\The [src.name] is now set to stun."))
			modifystate = "energystun"
	update_icon()

/obj/item/weapon/gun/energy/gun/nuclear
	name = "Advanced Energy Gun"
	desc = "An energy gun with an experimental miniaturized reactor."
	icon_state = "nucgun"
	origin_tech = list(RESEARCH_TECH_COMBAT = 3, RESEARCH_TECH_MATERIALS = 5, RESEARCH_TECH_POWERSTORAGE = 3)

	var/lightfail = 0
	var/charge_tick = 0

/obj/item/weapon/gun/energy/gun/nuclear/New()
	. = ..()
	GLOBL.processing_objects.Add(src)

/obj/item/weapon/gun/energy/gun/nuclear/Destroy()
	GLOBL.processing_objects.Remove(src)
	return ..()

/obj/item/weapon/gun/energy/gun/nuclear/process()
	charge_tick++
	if(charge_tick < 4)
		return 0
	charge_tick = 0
	if(!power_supply)
		return 0
	if((power_supply.charge / power_supply.maxcharge) != 1)
		if(!failcheck())
			return 0
		power_supply.give(100)
		update_icon()
	return 1

/obj/item/weapon/gun/energy/gun/nuclear/proc/failcheck()
	lightfail = 0
	if(prob(src.reliability))
		return 1 //No failure

	if(prob(src.reliability))
		for(var/mob/living/M in range(0, src)) //Only a minor failure, enjoy your radiation if you're in the same tile or carrying it
			if(src in M.contents)
				to_chat(M, SPAN_WARNING("Your gun feels pleasantly warm for a moment."))
			else
				to_chat(M, SPAN_WARNING("You feel a warm sensation."))
			M.apply_effect(rand(3, 120), IRRADIATE)
		lightfail = 1
	else
		for(var/mob/living/M in range(rand(1, 4), src)) //Big failure, TIME FOR RADIATION BITCHES
			if(src in M.contents)
				to_chat(M, SPAN_WARNING("Your gun's reactor overloads!"))
			to_chat(M, SPAN_WARNING("You feel a wave of heat wash over you."))
			M.apply_effect(300, IRRADIATE)
		crit_fail = 1 //break the gun so it stops recharging
		GLOBL.processing_objects.Remove(src)
		update_icon()
	return 0

/obj/item/weapon/gun/energy/gun/nuclear/proc/update_charge()
	if(crit_fail)
		overlays += "nucgun-whee"
		return
	var/ratio = power_supply.charge / power_supply.maxcharge
	ratio = round(ratio, 0.25) * 100
	overlays += "nucgun-[ratio]"

/obj/item/weapon/gun/energy/gun/nuclear/proc/update_reactor()
	if(crit_fail)
		overlays += "nucgun-crit"
		return
	if(lightfail)
		overlays += "nucgun-medium"
	else if((power_supply.charge / power_supply.maxcharge) <= 0.5)
		overlays += "nucgun-light"
	else
		overlays += "nucgun-clean"

/obj/item/weapon/gun/energy/gun/nuclear/proc/update_mode()
	if(gun_setting == GUN_SETTING_STUN)
		overlays += "nucgun-stun"
	else if(gun_setting == GUN_SETTING_KILL)
		overlays += "nucgun-kill"

/obj/item/weapon/gun/energy/gun/nuclear/emp_act(severity)
	..()
	reliability -= round(15 / severity)

/obj/item/weapon/gun/energy/gun/nuclear/update_icon()
	overlays.Cut()
	update_charge()
	update_reactor()
	update_mode()