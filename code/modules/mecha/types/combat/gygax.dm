/obj/mecha/combat/gygax
	name = "\improper Gygax"
	desc = "A lightweight, security exosuit. Popular among private and corporate security."
	icon_state = "gygax"
	infra_luminosity = 6

	entry_direction = NORTH

	move_delay = 0.3 SECONDS
	deflect_chance = 15
	damage_resistance = list("brute" = 25, "fire" = 10, "bullet" = 20, "laser" = 30, "energy" = 15, "bomb" = 0)
	internal_damage_threshold = 35

	mecha_type = MECHA_TYPE_GYGAX

	wreckage = /obj/structure/mecha_wreckage/gygax

	var/overload = FALSE
	var/overload_coeff = 2

/obj/mecha/combat/gygax/Topic(href, list/href_list)
	. = ..()
	if(href_list["toggle_leg_overload"])
		toggle_actuator_overload()

/obj/mecha/combat/gygax/do_move(direction)
	. = ..()
	if(!.)
		return FALSE
	if(!overload)
		return FALSE

	health--
	var/initial_health = initial(health)
	if(health < initial_health - (initial_health / 3))
		overload = FALSE
		move_delay = initial(move_delay)
		step_energy_drain = initial(step_energy_drain)
		occupant_message(SPAN_WARNING("Leg actuator damage threshold exceded. Disabling overload."))

/obj/mecha/combat/gygax/get_stats_part()
	. = ..()
	. += "<b>Leg Actuator Overload: [overload ? "enabled" : "disabled"]</b>"

/obj/mecha/combat/gygax/get_commands()
	. = {"<div class='wr'>
		<div class='header'>Special</div>
		<div class='links'>
		<a href='byond://?src=\ref[src];toggle_leg_overload=1'><span id="leg_overload_command">[overload ? "Dis" : "En"]able Leg Actuator Overload</span></a>
		</div>
		</div>
	"}
	. += ..()

/obj/mecha/combat/gygax/verb/toggle_actuator_overload()
	set category = "Exosuit Interface"
	set name = "Toggle Leg Actuator Overload"
	set popup_menu = FALSE
	set src = usr.loc

	if(usr != occupant)
		return

	overload = !overload
	if(overload)
		move_delay = min(1, round(move_delay / 2))
		step_energy_drain = step_energy_drain * overload_coeff
	else
		move_delay = initial(move_delay)
		step_energy_drain = initial(step_energy_drain)
	balloon_alert(occupant, "[overload ? "en" : "dis"]abled leg overload")
	send_byjax(occupant, "exosuit.browser", "leg_overload_command", "[overload ? "Dis" : "En"]able Leg Actuator Overload")
	log_message("Toggled leg actuator overload.")

// Dark Gygax
/obj/mecha/combat/gygax/dark
	name = "\improper Dark Gygax"
	desc = "A lightweight exosuit used by NanoTrasen Death Squads. A significantly upgraded Gygax security mech."
	icon_state = "dark_gygax"

	health = 400
	step_energy_drain = 5
	max_temperature = 45000
	deflect_chance = 25
	damage_resistance = list("brute" = 40, "fire" = 20, "bullet" = 40, "laser" = 50, "energy" = 35, "bomb" = 20)

	max_equip = 5

	wreckage = /obj/structure/mecha_wreckage/gygax/dark

	overload_coeff = 1

/obj/mecha/combat/gygax/dark/add_cell(obj/item/cell/C = null)
	if(isnotnull(C))
		C.forceMove(src)
		cell = C
		return
	cell = new /obj/item/cell/hyper(src)

// Equipped variant
/obj/mecha/combat/gygax/dark/equipped
	starts_with = list(
		/obj/item/mecha_equipment/weapon/ballistic/scattershot, /obj/item/mecha_equipment/weapon/ballistic/launcher/flashbang/cluster,
		/obj/item/mecha_equipment/teleporter, /obj/item/mecha_equipment/tesla_energy_relay, /obj/item/mecha_equipment/emp_insulation/hardened
	)

// Serenity
/obj/mecha/combat/gygax/serenity
	name = "\improper Serenity"
	desc = "A lightweight exosuit constructed from a modified Gygax chassis combined with proprietary Vey-Med(&copy; all rights reserved) medical technology."
	icon_state = "serenity"
	infra_luminosity = 11

	force = 15

	health = 210
	move_delay = 0.25 SECONDS
	step_energy_drain = 8
	max_temperature = 20000
	damage_resistance = list("brute" = 22.5, "fire" = 0, "bullet" = 15, "laser" = 15, "energy" = 7.5, "bomb" = 0)

	step_sound_volume = 25
	turn_sound = 'sound/mecha/movement/mechmove01.ogg'

	mecha_type = MECHA_TYPE_SERENITY

	wreckage = /obj/structure/mecha_wreckage/gygax/serenity