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

	var/overload = FALSE
	var/overload_coeff = 2

/obj/mecha/combat/gygax/verb/overload()
	set category = "Exosuit Interface"
	set name = "Toggle Leg Actuator Overload"
	set popup_menu = FALSE
	set src = usr.loc

	if(usr != occupant)
		return

	if(overload)
		overload = FALSE
		step_in = initial(step_in)
		step_energy_drain = initial(step_energy_drain)
		occupant_message(SPAN_INFO("You disable the leg actuator overload."))
	else
		overload = TRUE
		step_in = min(1, round(step_in / 2))
		step_energy_drain = step_energy_drain * overload_coeff
		occupant_message(SPAN_WARNING("You enable the leg actuator overload."))
	log_message("Toggled leg actuator overload.")

/obj/mecha/combat/gygax/dyndomove(direction)
	if(!..())
		return
	if(overload)
		health--
		if(health < initial(health) - initial(health) / 3)
			overload = FALSE
			step_in = initial(step_in)
			step_energy_drain = initial(step_energy_drain)
			occupant_message(SPAN_WARNING("Leg actuator damage threshold exceded. Disabling overload."))

/obj/mecha/combat/gygax/get_stats_part()
	. = ..()
	. += "<b>Leg actuator overload: [overload ? "on" : "off"]</b>"

/obj/mecha/combat/gygax/get_commands()
	. = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='byond://?src=\ref[src];toggle_leg_overload=1'>Toggle leg actuator overload</a>
						</div>
						</div>
						"}
	. += ..()

/obj/mecha/combat/gygax/Topic(href, href_list)
	. = ..()
	if(href_list["toggle_leg_overload"])
		overload()

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