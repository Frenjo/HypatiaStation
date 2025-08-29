// Melee Armour Booster
/obj/item/mecha_equipment/melee_armour_booster // What is that noise? A BAWWW from TK mutants.
	name = "armour booster module (close combat weaponry)"
	desc = "An exosuit module that boosts armour against armed melee attacks. Requires energy to operate."
	icon_state = "melee_armour_booster"
	matter_amounts = /datum/design/mechfab/equipment/melee_armour_booster::materials
	origin_tech = /datum/design/mechfab/equipment/melee_armour_booster::req_tech

	equip_cooldown = 1 SECOND
	energy_drain = 50
	selectable = FALSE

	attaches_to_string = "<em><i>any</i></em> exosuit except the <em><i>H.O.N.K</i></em> and the <em><i>Reticence</i></em>"

	var/deflect_coeff = 1.15
	var/damage_coeff = 0.8

/obj/item/mecha_equipment/melee_armour_booster/proc/attack_react(mob/user)
	if(!action_checks(src))
		return FALSE
	start_cooldown()
	return TRUE

/obj/item/mecha_equipment/melee_defence_shocker
	name = "armour module (melee defence shocker)"
	desc = "An exosuit module that electrically charges the armour to discourage melee attackers. Requires energy to operate."
	icon_state = "melee_defence_shocker"
	matter_amounts = /datum/design/mechfab/equipment/melee_defence_shocker::materials
	origin_tech = /datum/design/mechfab/equipment/melee_defence_shocker::req_tech

	equip_cooldown = 1 SECOND
	energy_drain = 100
	selectable = FALSE

	allow_duplicates = FALSE

	attaches_to_string = "<em><i>any</i></em> exosuit except the <em><i>H.O.N.K</i></em> and the <em><i>Reticence</i></em>"

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

/obj/item/mecha_equipment/melee_defence_shocker/handle_topic(mob/user, datum/topic_input/topic)
	. = ..()
	if(!.)
		return FALSE

	if(topic.has("toggle_shocker"))
		active = !active
		send_byjax(chassis.occupant, "exosuit.browser", "\ref[src]", get_equip_info())

// Ranged Armour Booster
/obj/item/mecha_equipment/ranged_armour_booster
	name = "armour booster module (ranged weaponry)"
	desc = "An exosuit module that boosts armour against ranged attacks. Completely blocks taser shots. Requires energy to operate."
	icon_state = "ranged_armour_booster"
	matter_amounts = /datum/design/mechfab/equipment/ranged_armour_booster::materials
	origin_tech = /datum/design/mechfab/equipment/ranged_armour_booster::req_tech

	equip_cooldown = 1 SECOND
	energy_drain = 50
	selectable = FALSE

	attaches_to_string = "<em><i>any</i></em> exosuit except the <em><i>H.O.N.K</i></em> and the <em><i>Reticence</i></em>"

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
	desc = "An exosuit module that boosts internal systems against energy and EMP-based interference. Requires energy to operate."
	icon_state = "emp_insulation"
	matter_amounts = /datum/design/mechfab/equipment/emp_insulation::materials
	origin_tech = /datum/design/mechfab/equipment/emp_insulation::req_tech

	equip_cooldown = 1 SECOND
	energy_drain = 50
	selectable = FALSE

	attaches_to_string = "<em><i>any</i></em> exosuit except the <em><i>H.O.N.K</i></em> and the <em><i>Reticence</i></em>"

	var/severity_modifier = 0.85

/obj/item/mecha_equipment/emp_insulation/proc/emp_react()
	if(!action_checks(src))
		return FALSE
	start_cooldown()
	return TRUE

// Hardened version used on Syndicate and CentCom exosuits.
/obj/item/mecha_equipment/emp_insulation/hardened
	name = "armour module (hardened ablative EMP insulation)"
	desc = "An exosuit module that boosts internal systems against energy and EMP-based interference. Requires energy to operate. \
		This variant sports improved shielding at the cost of being permanently integrated into the exosuit's chassis."

	salvageable = FALSE

	allow_detach = FALSE // It's stuck on the suits it comes with.

	severity_modifier = 0.75

// "Alien" version for future use.
/obj/item/mecha_equipment/emp_insulation/alien
	name = "armour module (non-ablative magnetic/EMP shielding)"
	desc = "An exosuit module that boosts internal systems against energy, magnetic and EMP-based interference. \
		This variant appears to be constructed from \"alien\" technology, being significantly more advanced than even military models \
		at the cost of requiring particularly large amounts of energy to operate."
	icon_state = "emp_insulation_alien"

	energy_drain = parent_type::energy_drain * 4

	severity_modifier = 0.5