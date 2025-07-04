/obj/item/gun/energy/gun
	name = "energy gun"
	desc = "A basic energy-based gun with two settings: Stun and kill."
	icon_state = "energystun100"
	item_state = null	//so the human update icon uses the icon_state instead.

	origin_tech = alist(/decl/tech/magnets = 2, /decl/tech/combat = 3)

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
			fire_sound = 'sound/weapons/gun/laser.ogg'
		if(GUN_SETTING_KILL)
			gun_setting = GUN_SETTING_STUN
			charge_cost = 100
			fire_sound = 'sound/weapons/gun/taser.ogg'
	modifystate = "energy[gun_setting]"
	balloon_alert(user, "set to [gun_setting]")
	update_icon()

/obj/item/gun/energy/gun/nuclear
	name = "advanced energy gun"
	desc = "An energy gun with an experimental miniaturized reactor."
	icon_state = "nucgun"

	matter_amounts = /datum/design/weapon/nuclear_gun::materials
	origin_tech = /datum/design/weapon/nuclear_gun::req_tech

	self_charging = TRUE
	recharge_time = 0.4 SECONDS

	var/lightfail = FALSE

/obj/item/gun/energy/gun/nuclear/emp_act(severity)
	. = ..()
	reliability -= round(15 / severity)

/obj/item/gun/energy/gun/nuclear/update_icon()
	cut_overlays()
	update_charge()
	update_reactor()
	update_mode()

/obj/item/gun/energy/gun/nuclear/failcheck()
	lightfail = FALSE
	if(prob(reliability))
		return FALSE //No failure

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
		STOP_PROCESSING(PCobj, src)
		update_icon()
	return TRUE

/obj/item/gun/energy/gun/nuclear/proc/update_charge()
	if(crit_fail)
		add_overlay("nucgun-whee")
		return
	var/ratio = power_supply.charge / power_supply.maxcharge
	ratio = round(ratio, 0.25) * 100
	add_overlay("nucgun-[ratio]")

/obj/item/gun/energy/gun/nuclear/proc/update_reactor()
	if(crit_fail)
		add_overlay("nucgun-crit")
		return
	if(lightfail)
		add_overlay("nucgun-medium")
	else if((power_supply.charge / power_supply.maxcharge) <= 0.5)
		add_overlay("nucgun-light")
	else
		add_overlay("nucgun-clean")

/obj/item/gun/energy/gun/nuclear/proc/update_mode()
	add_overlay("nucgun-[gun_setting]")