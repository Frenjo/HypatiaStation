/*
 * Jetpack
 *
 * This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32
 */
/obj/item/tank/jetpack
	name = "jetpack (empty)"
	desc = "A tank of compressed gas for use as propulsion in zero-gravity areas. Use with caution."
	icon_state = "jetpack"
	item_state = "jetpack"
	w_class = 4
	distribute_pressure = ONE_ATMOSPHERE * O2STANDARD
	icon_action_button = "action_jetpack"

	alert_gas_amount = 10

	var/datum/effect/system/ion_trail_follow/ion_trail
	var/on = FALSE
	var/stabilization_on = 0
	var/volume_rate = 500				//Needed for borg jetpack transfer

/obj/item/tank/jetpack/New()
	. = ..()
	ion_trail = new /datum/effect/system/ion_trail_follow()
	ion_trail.set_up(src)

/obj/item/tank/jetpack/ui_action_click()
	toggle()

/obj/item/tank/jetpack/verb/toggle_rockets()
	set category = PANEL_OBJECT
	set name = "Toggle Jetpack Stabilization"

	stabilization_on = !stabilization_on
	to_chat(usr, "You toggle the stabilization [stabilization_on ? "on" : "off"].")

/obj/item/tank/jetpack/verb/toggle()
	set category = PANEL_OBJECT
	set name = "Toggle Jetpack"

	on = !on
	if(on)
		icon_state = "[icon_state]-on"
//		item_state = "[item_state]-on"
		ion_trail.start()
	else
		icon_state = initial(icon_state)
//		item_state = initial(item_state)
		ion_trail.stop()

/obj/item/tank/jetpack/proc/allow_thrust(num, mob/living/user as mob)
	if(!on)
		return 0
	if(num < 0.005 || air_contents.total_moles < num)
		ion_trail.stop()
		return 0

	var/datum/gas_mixture/G = air_contents.remove(num)

	if(G.total_moles >= 0.005)
		return 1

	qdel(G)