/obj/mecha/combat/reticence
	name = "\improper Reticence"
	desc = "A silent and fast miming exosuit. Popular among mimes and mime assassins."
	icon_state = "reticence"
	infra_luminosity = 5
	initial_icon = "reticence"

	step_sound = null
	turn_sound = null

	health = 140
	step_in = 2
	deflect_chance = 60
	damage_absorption = list("brute" = 1.2, "fire" = 1.5, "bullet" = 1, "laser" = 1, "energy" = 1, "bomb" = 1)
	internal_damage_threshold = 60

	operation_req_access = list(ACCESS_MIME)
	add_req_access = FALSE

	wreckage = /obj/effect/decal/mecha_wreckage/reticence

/obj/mecha/combat/reticence/New()
	. = ..()
	excluded_equipment.Add(/obj/item/mecha_part/equipment/melee_armour_booster, /obj/item/mecha_part/equipment/ranged_armour_booster)

/obj/mecha/combat/reticence/melee_action(target)
	if(!melee_can_hit)
		return

	if(ismob(target))
		step_away(target, src, 15)