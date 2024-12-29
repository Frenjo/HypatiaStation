// Ported this from NSS Eternal's code, the hoverpod is literally my old favourite. -Frenjo
/obj/mecha/working/hoverpod
	name = "\improper HoverPod"
	desc = "Stubby and round, this space-capable craft is an ancient favorite."
	icon_state = "engineering_pod"
	infra_luminosity = 6
	initial_icon = "engineering_pod"

	step_sound = 'sound/machines/hiss.ogg'
	turn_sound = null

	health = 150
	step_in = 4
	max_temperature = 20000
	internal_damage_threshold = 80

	wreckage = /obj/structure/mecha_wreckage/hoverpod

	var/datum/effect/system/ion_trail_follow/ion_trail
	var/stabilization_enabled = TRUE

/obj/mecha/working/hoverpod/New()
	. = ..()
	ion_trail = new /datum/effect/system/ion_trail_follow()
	ion_trail.set_up(src)
	ion_trail.start()

//Modified phazon code
/obj/mecha/working/hoverpod/Topic(href, href_list)
	. = ..()
	if(href_list["toggle_stabilization"])
		stabilization_enabled = !stabilization_enabled
		send_byjax(occupant, "exosuit.browser", "stabilization_command", "[stabilization_enabled ? "Dis" : "En"]able thruster stabilization")
		occupant_message(SPAN_INFO("Thruster stabilization [stabilization_enabled ? "enabled" : "disabled"]."))
		return

/obj/mecha/working/hoverpod/get_commands()
	. = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='byond://?src=\ref[src];toggle_stabilization=1'><span id="stabilization_command">[stabilization_enabled ? "Dis" : "En"]able thruster stabilization</span></a><br>
						</div>
						</div>
						"}
	. += ..()

//No space drifting
/obj/mecha/working/hoverpod/check_for_support()
	//does the hoverpod have enough charge left to stabilize itself?
	if(!has_charge(step_energy_drain))
		ion_trail.stop()
	else
		if(!ion_trail.on)
			ion_trail.start()
		if(stabilization_enabled)
			return 1

	return ..()

//Hoverpod variants
/obj/mecha/working/hoverpod/combat
	name = "\improper Combat HoverPod"
	desc = "An ancient, run-down combat spacecraft." // Ideally would have a seperate icon.

	health = 200

	max_equip = 2

	internal_damage_threshold = 35
	cargo_capacity = 2

/obj/mecha/working/hoverpod/combat/New()
	. = ..()
	var/obj/item/mecha_part/equipment/ME = new /obj/item/mecha_part/equipment/weapon/energy/laser(src)
	ME.attach(src)
	ME = new /obj/item/mecha_part/equipment/weapon/ballistic/missile_rack/explosive(src)
	ME.attach(src)

/obj/mecha/working/hoverpod/shuttle
	name = "\improper Shuttle HoverPod"
	desc = "Who knew a tiny ball could fit three people?"

/obj/mecha/working/hoverpod/shuttle/New()
	. = ..()
	var/obj/item/mecha_part/equipment/ME = new /obj/item/mecha_part/equipment/passenger(src)
	ME.attach(src)
	ME = new /obj/item/mecha_part/equipment/passenger(src)
	ME.attach(src)