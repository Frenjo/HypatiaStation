/obj/mecha/medical/serenity
	name = "Serenity"
	desc = "A lightweight exosuit constructed from a modified Gygax chassis combined with proprietary Vey-Med (&copy; All rights reserved) medical technology."
	icon_state = "serenity"
	infra_luminosity = 11
	initial_icon = "serenity"

	health = 210
	step_in = 2.5
	step_energy_drain = 8
	max_temperature = 20000
	deflect_chance = 15
	damage_absorption = list("brute" = 0.775, "fire" = 1.1, "bullet" = 0.85, "laser" = 0.85, "energy" = 0.925, "bomb" = 1)
	internal_damage_threshold = 35

	wreckage = /obj/effect/decal/mecha_wreckage/gygax/serenity

/obj/mecha/medical/serenity/New()
	. = ..()
	excluded_equipment.Remove(/obj/item/mecha_part/equipment/weapon)