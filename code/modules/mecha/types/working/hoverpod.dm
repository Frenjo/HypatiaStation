// Ported this from NSS Eternal's code, the hoverpod is literally my old favourite. -Frenjo
/obj/mecha/working/hoverpod
	name = "\improper HoverPod"
	desc = "Stubby and round, this space-capable craft is an ancient favorite."
	icon_state = "hoverpod"
	infra_luminosity = 6

	step_sound = 'sound/machines/hiss.ogg'
	turn_sound = null

	health = 150
	move_delay = 0.4 SECONDS
	max_temperature = 20000
	internal_damage_threshold = 80

	mecha_type = MECHA_TYPE_HOVERPOD

	wreckage = /obj/structure/mecha_wreckage/hoverpod

	var/initial_pixel_y

	var/datum/effect/system/ion_trail_follow/ion_trail
	var/stabilisation = TRUE

/obj/mecha/working/hoverpod/initialise()
	. = ..()
	initial_pixel_y = pixel_y
	ion_trail = new /datum/effect/system/ion_trail_follow()
	ion_trail.set_up(src)
	ion_trail.start()

/obj/mecha/working/hoverpod/Destroy()
	QDEL_NULL(ion_trail)
	return ..()

/obj/mecha/working/hoverpod/get_stats_part()
	. = ..()
	. += "<b>Thruster Stabilisation: [stabilisation ? "enabled" : "disabled"]</b>"

/obj/mecha/working/hoverpod/get_commands()
	. = {"<div class='wr'>
		<div class='header'>Special</div>
		<div class='links'>
		<a href='byond://?src=\ref[src];stabilisation=1'><span id="stabilisation_command">[stabilisation ? "Dis" : "En"]able Thruster Stabilisation</span></a>
		<br>
		</div>
		</div>
	"}
	. += ..()

//Modified phazon code
/obj/mecha/working/hoverpod/Topic(href, href_list)
	. = ..()
	if(href_list["stabilisation"])
		stabilisation = !stabilisation
		balloon_alert(occupant, "[stabilisation ? "en" : "dis"]abled stabilisation")
		send_byjax(occupant, "exosuit.browser", "stabilisation_command", "[stabilisation ? "Dis" : "En"]able Thruster Stabilisation")
		return

//No space drifting
/obj/mecha/working/hoverpod/check_for_support()
	//does the hoverpod have enough charge left to stabilise itself?
	if(!has_charge(step_energy_drain))
		ion_trail.stop()
	else
		if(!ion_trail.on)
			ion_trail.start()
		if(stabilisation)
			return TRUE

	return ..()

/obj/mecha/working/hoverpod/moved_inside(mob/living/carbon/human/pilot)
	. = ..()
	if(.)
		start_floating_animation()

/obj/mecha/working/hoverpod/mmi_moved_inside(obj/item/mmi/mmi_as_oc, mob/user)
	. = ..()
	if(.)
		start_floating_animation()

/obj/mecha/working/hoverpod/go_out()
	. = ..()
	if(.)
		stop_floating_animation()

/obj/mecha/working/hoverpod/proc/start_floating_animation()
	animate(src, pixel_y = 2, time = 2 SECONDS, loop = -1, flags = ANIMATION_RELATIVE)
	animate(pixel_y = -2, time = 2 SECONDS, flags = ANIMATION_RELATIVE)

/obj/mecha/working/hoverpod/proc/stop_floating_animation()
	animate(src, pixel_y = initial_pixel_y, time = 2 SECONDS)

//Hoverpod variants
/obj/mecha/working/hoverpod/combat
	name = "\improper Combat HoverPod"
	desc = "An ancient, run-down combat spacecraft." // Ideally would have a seperate icon.

	health = 200
	internal_damage_threshold = 35

	max_equip = 2

	mecha_type = MECHA_TYPE_COMBAT_HOVERPOD
	starts_with = list(/obj/item/mecha_equipment/weapon/energy/laser, /obj/item/mecha_equipment/weapon/ballistic/launcher/missile_rack)

	cargo_capacity = 2

/obj/mecha/working/hoverpod/shuttle
	name = "\improper Shuttle HoverPod"
	desc = "Who knew a tiny ball could fit three people?"

	starts_with = list(/obj/item/mecha_equipment/passenger, /obj/item/mecha_equipment/passenger)