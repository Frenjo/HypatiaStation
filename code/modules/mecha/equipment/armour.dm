// Melee Armour Booster
/obj/item/mecha_equipment/melee_armour_booster // What is that noise? A BAWWW from TK mutants.
	name = "armour booster module (close combat weaponry)"
	desc = "Boosts exosuit armour against armed melee attacks. Requires energy to operate. (Can be attached to: Any Exosuit except H.O.N.K and Reticence)"
	icon_state = "melee_armour_booster"
	matter_amounts = /datum/design/mechfab/equipment/melee_armour_booster::materials
	origin_tech = /datum/design/mechfab/equipment/melee_armour_booster::req_tech

	equip_cooldown = 1 SECOND
	energy_drain = 50
	selectable = FALSE

	var/deflect_coeff = 1.15
	var/damage_coeff = 0.8

/obj/item/mecha_equipment/melee_armour_booster/proc/attack_react(mob/user)
	if(!action_checks(src))
		return FALSE
	start_cooldown()
	return TRUE

/obj/item/mecha_equipment/melee_defence_shocker
	name = "armour module (melee defence shocker)"
	desc = "Electrically charges exosuit armour to discourage melee attackers. Requires energy to operate. (Can be attached to: Any Exosuit except H.O.N.K and Reticence)"
	icon_state = "melee_defence_shocker"
	matter_amounts = /datum/design/mechfab/equipment/melee_defence_shocker::materials
	origin_tech = /datum/design/mechfab/equipment/melee_defence_shocker::req_tech

	equip_cooldown = 1 SECOND
	energy_drain = 100
	selectable = FALSE

	allow_duplicates = FALSE

	var/active = FALSE
	var/shock_damage = 15

/obj/item/mecha_equipment/melee_defence_shocker/proc/attack_react(mob/living/user)
	if(!active || !action_checks(src))
		return FALSE
	user.electrocute_act(shock_damage, src)
	start_cooldown()
	return TRUE

/obj/item/mecha_equipment/melee_defence_shocker/get_equip_info()
	. = "[..()] - <a href='byond://?src=\ref[src];toggle_shocker=1'>[active ? "Dea" : "A"]ctivate</a>"

/obj/item/mecha_equipment/melee_defence_shocker/Topic(href, list/href_list)
	. = ..()
	if(href_list["toggle_shocker"])
		active = !active
		send_byjax(chassis.occupant, "exosuit.browser", "\ref[src]", get_equip_info())

// Ranged Armour Booster
/obj/item/mecha_equipment/ranged_armour_booster
	name = "armour booster module (ranged weaponry)"
	desc = "Boosts exosuit armour against ranged attacks. Completely blocks taser shots. Requires energy to operate. (Can be attached to: Any Exosuit except H.O.N.K and Reticence)"
	icon_state = "ranged_armour_booster"
	matter_amounts = /datum/design/mechfab/equipment/ranged_armour_booster::materials
	origin_tech = /datum/design/mechfab/equipment/ranged_armour_booster::req_tech

	equip_cooldown = 1 SECOND
	energy_drain = 50
	selectable = FALSE

	var/deflect_coeff = 1.15
	var/damage_coeff = 0.8

/obj/item/mecha_equipment/ranged_armour_booster/proc/projectile_react()
	if(!action_checks(src))
		return FALSE
	start_cooldown()
	return TRUE

// EMP Armour Booster
/obj/item/mecha_equipment/emp_insulation
	name = "armour module (ablative EMP insulation)"
	desc = "Boosts exosuit systems against energy and EMP-based interference. Requires energy to operate. (Can be attached to: Any Exosuit except H.O.N.K and Reticence)"
	icon_state = "emp_insulation"
	matter_amounts = /datum/design/mechfab/equipment/emp_insulation::materials
	origin_tech = /datum/design/mechfab/equipment/emp_insulation::req_tech

	equip_cooldown = 1 SECOND
	energy_drain = 50
	selectable = FALSE

	var/severity_modifier = 0.85

/obj/item/mecha_equipment/emp_insulation/proc/emp_react()
	if(!action_checks(src))
		return FALSE
	start_cooldown()
	return TRUE