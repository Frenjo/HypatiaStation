// Melee Armour Booster
/obj/item/mecha_part/equipment/melee_armour_booster // What is that noise? A BAWWW from TK mutants.
	name = "armour booster module (close combat weaponry)"
	desc = "Boosts exosuit armour against armed melee attacks. Requires energy to operate. (Can be attached to: Any Exosuit except H.O.N.K)"
	icon_state = "mecha_abooster_ccw"
	origin_tech = list(/datum/tech/materials = 3)
	equip_cooldown = 10
	energy_drain = 50
	range = 0
	construction_cost = list(MATERIAL_METAL = 20000, /decl/material/silver = 5000)

	var/deflect_coeff = 1.15
	var/damage_coeff = 0.8

/obj/item/mecha_part/equipment/melee_armour_booster/attach(obj/mecha/M)
	. = ..()
	chassis.proc_res["dynattackby"] = src

/obj/item/mecha_part/equipment/melee_armour_booster/detach()
	chassis.proc_res["dynattackby"] = null
	. = ..()

/obj/item/mecha_part/equipment/melee_armour_booster/get_equip_info()
	if(!chassis)
		return
	return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[name]"

/obj/item/mecha_part/equipment/melee_armour_booster/proc/dynattackby(obj/item/W, mob/user)
	if(!action_checks(user))
		return chassis.dynattackby(W,user)
	chassis.log_message("Attacked by [W]. Attacker - [user]")
	if(prob(chassis.deflect_chance * deflect_coeff))
		user << "\red The [W] bounces off [chassis] armor."
		chassis.log_append_to_last("Armor saved.")
	else
		chassis.occupant_message("<font color='red'><b>[user] hits [chassis] with [W].</b></font>")
		user.visible_message("<font color='red'><b>[user] hits [chassis] with [W].</b></font>", "<font color='red'><b>You hit [src] with [W].</b></font>")
		chassis.take_damage(round(W.force * damage_coeff), W.damtype)
		chassis.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL, MECHA_INT_TANK_BREACH, MECHA_INT_CONTROL_LOST))
	set_ready_state(0)
	chassis.use_power(energy_drain)
	do_after_cooldown()
	return

// Ranged Armour Booster
/obj/item/mecha_part/equipment/ranged_armour_booster
	name = "armour booster module (ranged weaponry)"
	desc = "Boosts exosuit armour against ranged attacks. Completely blocks taser shots. Requires energy to operate. (Can be attached to: Any Exosuit except H.O.N.K)"
	icon_state = "mecha_abooster_proj"
	origin_tech = list(/datum/tech/materials = 4)
	equip_cooldown = 10
	energy_drain = 50
	range = 0
	construction_cost = list(MATERIAL_METAL = 20000, /decl/material/gold = 5000)

	var/deflect_coeff = 1.15
	var/damage_coeff = 0.8

/obj/item/mecha_part/equipment/ranged_armour_booster/attach(obj/mecha/M)
	. = ..()
	chassis.proc_res["dynbulletdamage"] = src
	chassis.proc_res["dynhitby"] = src

/obj/item/mecha_part/equipment/ranged_armour_booster/detach()
	chassis.proc_res["dynbulletdamage"] = null
	chassis.proc_res["dynhitby"] = null
	. = ..()

/obj/item/mecha_part/equipment/ranged_armour_booster/get_equip_info()
	if(!chassis)
		return
	return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[name]"

/obj/item/mecha_part/equipment/ranged_armour_booster/proc/dynbulletdamage(obj/item/projectile/Proj)
	if(!action_checks(src))
		return chassis.dynbulletdamage(Proj)
	if(prob(chassis.deflect_chance * deflect_coeff))
		chassis.occupant_message("\blue The armor deflects incoming projectile.")
		chassis.visible_message("The [chassis.name] armor deflects the projectile")
		chassis.log_append_to_last("Armor saved.")
	else
		chassis.take_damage(round(Proj.damage * damage_coeff), Proj.flag)
		chassis.check_for_internal_damage(list(MECHA_INT_FIRE, MECHA_INT_TEMP_CONTROL, MECHA_INT_TANK_BREACH, MECHA_INT_CONTROL_LOST))
		Proj.on_hit(chassis)
	set_ready_state(0)
	chassis.use_power(energy_drain)
	do_after_cooldown()

/obj/item/mecha_part/equipment/ranged_armour_booster/proc/dynhitby(atom/movable/A)
	if(!action_checks(A))
		return chassis.dynhitby(A)
	if(prob(chassis.deflect_chance * deflect_coeff) || isliving(A) || istype(A, /obj/item/mecha_part/tracking))
		chassis.occupant_message("\blue The [A] bounces off the armor.")
		chassis.visible_message("The [A] bounces off the [chassis] armor")
		chassis.log_append_to_last("Armor saved.")
		if(isliving(A))
			var/mob/living/M = A
			M.take_organ_damage(10)
	else if(isobj(A))
		var/obj/O = A
		if(O.throwforce)
			chassis.take_damage(round(O.throwforce * damage_coeff))
			chassis.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL, MECHA_INT_TANK_BREACH, MECHA_INT_CONTROL_LOST))
	set_ready_state(0)
	chassis.use_power(energy_drain)
	do_after_cooldown()