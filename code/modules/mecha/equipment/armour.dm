// Melee Armour Booster
/obj/item/mecha_part/equipment/melee_armour_booster // What is that noise? A BAWWW from TK mutants.
	name = "armour booster module (close combat weaponry)"
	desc = "Boosts exosuit armour against armed melee attacks. Requires energy to operate. (Can be attached to: Any Exosuit except H.O.N.K and Reticence)"
	icon_state = "melee_armour_booster"
	origin_tech = list(/datum/tech/materials = 5, /datum/tech/combat = 4)

	equip_cooldown = 1 SECOND
	energy_drain = 50
	range = 0
	selectable = FALSE

	var/deflect_coeff = 1.15
	var/damage_coeff = 0.8

/obj/item/mecha_part/equipment/melee_armour_booster/proc/attack_react(mob/user)
	if(!action_checks(src))
		return FALSE
	set_ready_state(0)
	chassis.use_power(energy_drain)
	do_after_cooldown()
	return TRUE

/obj/item/mecha_part/equipment/melee_defence_shocker
	name = "armour module (melee defence shocker)"
	desc = "Electrically charges exosuit armour to discourage melee attackers. Requires energy to operate. (Can be attached to: Any Exosuit except H.O.N.K and Reticence)"
	icon_state = "melee_defence_shocker"
	origin_tech = list(/datum/tech/materials = 5, /datum/tech/combat = 4, /datum/tech/engineering = 2, /datum/tech/plasma = 2)

	equip_cooldown = 1 SECOND
	energy_drain = 100
	range = 0
	selectable = FALSE

	allow_duplicates = FALSE

	var/active = FALSE
	var/shock_damage = 15

/obj/item/mecha_part/equipment/melee_defence_shocker/proc/attack_react(mob/living/user)
	if(!active || !action_checks(src))
		return FALSE
	user.electrocute_act(shock_damage, src)
	set_ready_state(0)
	chassis.use_power(energy_drain)
	do_after_cooldown()
	return TRUE

/obj/item/mecha_part/equipment/melee_defence_shocker/get_equip_info()
	. = "[..()] - <a href='byond://?src=\ref[src];toggle_shocker=1'>[active ? "Dea" : "A"]ctivate</a>"

/obj/item/mecha_part/equipment/melee_defence_shocker/Topic(href, list/href_list)
	. = ..()
	if(href_list["toggle_shocker"])
		active = !active
		send_byjax(chassis.occupant, "exosuit.browser", "\ref[src]", get_equip_info())

// Ranged Armour Booster
/obj/item/mecha_part/equipment/ranged_armour_booster
	name = "armour booster module (ranged weaponry)"
	desc = "Boosts exosuit armour against ranged attacks. Completely blocks taser shots. Requires energy to operate. (Can be attached to: Any Exosuit except H.O.N.K and Reticence)"
	icon_state = "ranged_armour_booster"
	origin_tech = list(/datum/tech/materials = 5, /datum/tech/combat = 5, /datum/tech/engineering = 3)

	equip_cooldown = 1 SECOND
	energy_drain = 50
	range = 0
	selectable = FALSE

	var/deflect_coeff = 1.15
	var/damage_coeff = 0.8

/obj/item/mecha_part/equipment/ranged_armour_booster/proc/projectile_react()
	if(!action_checks(src))
		return FALSE
	set_ready_state(0)
	chassis.use_power(energy_drain)
	do_after_cooldown()
	return TRUE