/obj/mecha/working/thales
	name = "\improper Thales" // Thay-leez.
	desc = "An exosuit of unknown design constructed from advanced \"alien\" technology. It emits an extremely strong electromagnetic field."
	icon_state = "thales"
	infra_luminosity = 4.5

	force = 22.5 // It can't actually hit stuff, this is just for future reference.

	custom_cursor = TRUE

	health = 300
	move_delay = 0.35 SECONDS
	step_energy_drain = /obj/mecha/combat::step_energy_drain * 4
	deflect_chance = 30
	damage_resistance = list("brute" = 40, "fire" = 40, "bullet" = 40, "laser" = 40, "energy" = 40, "bomb" = 40)
	internal_damage_threshold = 30

	step_sound = 'sound/mecha/movement/eidolon/sbdwalk0.ogg'

	max_equip = 6 // It gets 6 equipment slots, but 4 come pre-fitted and 2 of those aren't removable. So it effectively has 4 total.

	mecha_type = MECHA_TYPE_THALES
	excluded_equipment = list(
		/obj/item/mecha_equipment/generator,
		/obj/item/mecha_equipment/generator/nuclear,
		/obj/item/mecha_equipment/tesla_energy_relay
	) // Something about the electromagnetic nature of the mech means generators and relays won't work.

	wreckage = /obj/structure/mecha_wreckage/thales

	cargo_capacity = 0 // This gets set to 999 on the equipped version by the bluespace cargo module.

	var/step_loop = 0

/obj/mecha/working/thales/play_step_sound() // Uses the same looping movement sound as the Eidolon.
	step_loop = (step_loop++) % 3
	playsound(src, "sound/mecha/movement/eidolon/sbdwalk[step_loop].ogg", step_sound_volume, TRUE)

/obj/mecha/working/thales/add_cell(obj/item/cell/C = null)
	if(isnotnull(C))
		C.forceMove(src)
		cell = C
		return
	cell = new /obj/item/cell/bluespace(src)

/obj/mecha/working/thales/equipped
	starts_with = list(
		/obj/item/mecha_equipment/weapon/energy/laser/axis_projector, /obj/item/mecha_equipment/tool/hydraulic_clamp/magnetic,
		/obj/item/mecha_equipment/emp_insulation/alien, /obj/item/mecha_equipment/bluespace_cargo_module
	)