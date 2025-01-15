// Melee Armour Booster
/obj/item/mecha_part/equipment/melee_armour_booster // What is that noise? A BAWWW from TK mutants.
	name = "armour booster module (close combat weaponry)"
	desc = "Boosts exosuit armour against armed melee attacks. Requires energy to operate. (Can be attached to: Any Exosuit except H.O.N.K and Reticence)"
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
	. = "<span style=\"color:[equip_ready ? "#0f0" : "#f00"];\">*</span>&nbsp;[name]"

/obj/item/mecha_part/equipment/melee_armour_booster/proc/attack_react(mob/user)
	if(!action_checks(src))
		return FALSE
	set_ready_state(0)
	chassis.use_power(energy_drain)
	do_after_cooldown()
	return TRUE

// Ranged Armour Booster
/obj/item/mecha_part/equipment/ranged_armour_booster
	name = "armour booster module (ranged weaponry)"
	desc = "Boosts exosuit armour against ranged attacks. Completely blocks taser shots. Requires energy to operate. (Can be attached to: Any Exosuit except H.O.N.K and Reticence)"
	icon_state = "mecha_abooster_proj"
	origin_tech = list(/datum/tech/materials = 4)
	equip_cooldown = 10
	energy_drain = 50
	range = 0
	construction_cost = list(MATERIAL_METAL = 20000, /decl/material/gold = 5000)

	var/deflect_coeff = 1.15
	var/damage_coeff = 0.8

/obj/item/mecha_part/equipment/ranged_armour_booster/get_equip_info()
	. = "<span style=\"color:[equip_ready ? "#0f0" : "#f00"];\">*</span>&nbsp;[name]"

/obj/item/mecha_part/equipment/ranged_armour_booster/proc/projectile_react()
	if(!action_checks(src))
		return FALSE
	set_ready_state(0)
	chassis.use_power(energy_drain)
	do_after_cooldown()
	return TRUE