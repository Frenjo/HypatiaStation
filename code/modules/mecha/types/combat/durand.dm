/obj/mecha/combat/durand
	name = "\improper Durand"
	desc = "An aging combat exosuit utilised by the NanoTrasen corporation. Originally developed to combat hostile alien lifeforms."
	icon_state = "durand"
	infra_luminosity = 8

	entry_direction = NORTH

	force = 40

	health = 400
	move_delay = 0.4 SECONDS
	max_temperature = 30000
	deflect_chance = 20
	damage_resistance = list("brute" = 50, "fire" = 0, "bullet" = 35, "laser" = 15, "energy" = 10, "bomb" = 20)

	mecha_type = MECHA_TYPE_DURAND

	wreckage = /obj/structure/mecha_wreckage/durand

	defence_mode_capable = TRUE

/obj/mecha/combat/durand/get_stats_part()
	. = ..()
	. += "<b>Defence Mode: [defence_mode ? "enabled" : "disabled"]</b>"

/obj/mecha/combat/durand/get_commands()
	. = {"<div class='wr'>
		<div class='header'>Special</div>
		<div class='links'>
		<a href='byond://?src=\ref[src];defence_mode=1'><span id="defence_mode_command">[defence_mode ? "Dis" : "En"]able Defence Mode</span></a>
		</div>
		</div>
	"}
	. += ..()

// Archambeau
/obj/mecha/combat/durand/archambeau
	name = "\improper Archambeau"
	desc = "A modern variant of the aging Durand-type exosuit. This version features enhanced lightweight armour plating akin to that originally developed for the Phazon-type exosuit."
	icon_state = "archambeau"
	infra_luminosity = 6

	force = 25

	move_delay = 0.3 SECONDS
	step_energy_drain = 15
	max_temperature = 25000
	deflect_chance = 20
	damage_resistance = list("brute" = 40, "fire" = 20, "bullet" = 32.5, "laser" = 22.5, "energy" = 20, "bomb" = 25)
	internal_damage_threshold = 35

	wreckage = /obj/structure/mecha_wreckage/durand/archambeau