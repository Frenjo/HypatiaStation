/obj/mecha/combat/gygax
	name = "Gygax"
	desc = "A lightweight, security exosuit. Popular among private and corporate security."
	icon_state = "gygax"
	infra_luminosity = 6
	initial_icon = "gygax"

	step_in = 3
	deflect_chance = 15
	damage_absorption = list("brute" = 0.75, "fire" = 1, "bullet" = 0.8, "laser" = 0.7, "energy" = 0.85, "bomb" = 1)
	internal_damage_threshold = 35

	wreckage = /obj/effect/decal/mecha_wreckage/gygax

	overload_capable = TRUE

// Dark Gygax
/obj/mecha/combat/gygax/dark
	name = "Dark Gygax"
	desc = "A lightweight exosuit used by NanoTrasen Death Squads. A significantly upgraded Gygax security mech."
	icon_state = "darkgygax"
	initial_icon = "darkgygax"

	health = 400
	step_energy_drain = 5
	max_temperature = 45000
	deflect_chance = 25
	damage_absorption = list("brute" = 0.6, "fire" = 0.8, "bullet" = 0.6, "laser" = 0.5, "energy" = 0.65, "bomb" = 0.8)

	max_equip = 4

	wreckage = /obj/effect/decal/mecha_wreckage/gygax/dark

	overload_coeff = 1

/obj/mecha/combat/gygax/dark/New()
	. = ..()
	var/obj/item/mecha_part/equipment/ME = new /obj/item/mecha_part/equipment/weapon/ballistic/scattershot(src)
	ME.attach(src)
	ME = new /obj/item/mecha_part/equipment/weapon/ballistic/missile_rack/flashbang/clusterbang(src)
	ME.attach(src)
	ME = new /obj/item/mecha_part/equipment/teleporter(src)
	ME.attach(src)
	ME = new /obj/item/mecha_part/equipment/tesla_energy_relay(src)
	ME.attach(src)

/obj/mecha/combat/gygax/dark/add_cell(obj/item/cell/C = null)
	if(isnotnull(C))
		C.forceMove(src)
		cell = C
		return
	cell = new /obj/item/cell/hyper(src)

// Serenity
/obj/mecha/combat/gygax/serenity
	name = "Serenity"
	desc = "A lightweight exosuit constructed from a modified Gygax chassis combined with proprietary Vey-Med(&copy; All rights reserved) medical technology."
	icon_state = "serenity"
	infra_luminosity = 11
	initial_icon = "serenity"

	force = 15

	health = 210
	step_in = 2.5
	step_energy_drain = 8
	max_temperature = 20000
	damage_absorption = list("brute" = 0.775, "fire" = 1.1, "bullet" = 0.85, "laser" = 0.85, "energy" = 0.925, "bomb" = 1)

	step_sound_volume = 25
	turn_sound = 'sound/mecha/mechmove01.ogg'

	wreckage = /obj/effect/decal/mecha_wreckage/gygax/serenity

/obj/mecha/combat/gygax/serenity/New()
	. = ..()
	excluded_equipment.Remove(/obj/item/mecha_part/equipment/medical)