//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/tank/jetpack
	name = "Jetpack (Empty)"
	desc = "A tank of compressed gas for use as propulsion in zero-gravity areas. Use with caution."
	icon_state = "jetpack"
	w_class = 4.0
	item_state = "jetpack"
	distribute_pressure = ONE_ATMOSPHERE * O2STANDARD
	icon_action_button = "action_jetpack"

	var/datum/effect/system/ion_trail_follow/ion_trail
	var/on = 0.0
	var/stabilization_on = 0
	var/volume_rate = 500				//Needed for borg jetpack transfer

/obj/item/tank/jetpack/New()
	..()
	src.ion_trail = new /datum/effect/system/ion_trail_follow()
	src.ion_trail.set_up(src)
	return

/obj/item/tank/jetpack/examine()
	set src in usr
	..()
	if(air_contents.gas[/decl/xgm_gas/oxygen] < 10)
		to_chat(usr, SPAN_DANGER("The meter on the [src.name] indicates you are almost out of air!"))
		playsound(usr, 'sound/effects/alert.ogg', 50, 1)

/obj/item/tank/jetpack/verb/toggle_rockets()
	set name = "Toggle Jetpack Stabilization"
	set category = "Object"
	src.stabilization_on = !( src.stabilization_on )
	usr << "You toggle the stabilization [stabilization_on? "on":"off"]."
	return

/obj/item/tank/jetpack/verb/toggle()
	set name = "Toggle Jetpack"
	set category = "Object"
	on = !on
	if(on)
		icon_state = "[icon_state]-on"
//		item_state = "[item_state]-on"
		ion_trail.start()
	else
		icon_state = initial(icon_state)
//		item_state = initial(item_state)
		ion_trail.stop()
	return

/obj/item/tank/jetpack/proc/allow_thrust(num, mob/living/user as mob)
	if(!(src.on))
		return 0
	if((num < 0.005 || src.air_contents.total_moles < num))
		src.ion_trail.stop()
		return 0

	var/datum/gas_mixture/G = src.air_contents.remove(num)

	if(G.total_moles >= 0.005)
		return 1

	qdel(G)
	return

/obj/item/tank/jetpack/ui_action_click()
	toggle()


/obj/item/tank/jetpack/void
	name = "Void Jetpack (Oxygen)"
	desc = "It works well in a void."
	icon_state = "jetpack-void"
	item_state =  "jetpack-void"

/obj/item/tank/jetpack/void/New()
	. = ..()
	air_contents.adjust_gas(/decl/xgm_gas/oxygen, (6 * ONE_ATMOSPHERE) * volume / (R_IDEAL_GAS_EQUATION * T20C))


/obj/item/tank/jetpack/oxygen
	name = "Jetpack (Oxygen)"
	desc = "A tank of compressed oxygen for use as propulsion in zero-gravity areas. Use with caution."
	icon_state = "jetpack"
	item_state = "jetpack"

/obj/item/tank/jetpack/oxygen/New()
	. = ..()
	air_contents.adjust_gas(/decl/xgm_gas/oxygen, (6 * ONE_ATMOSPHERE) * volume / (R_IDEAL_GAS_EQUATION * T20C))


/obj/item/tank/jetpack/carbondioxide
	name = "Jetpack (Carbon Dioxide)"
	desc = "A tank of compressed carbon dioxide for use as propulsion in zero-gravity areas. Painted black to indicate that it should not be used as a source for internals."
	distribute_pressure = 0
	icon_state = "jetpack-black"
	item_state =  "jetpack-black"

/obj/item/tank/jetpack/carbondioxide/New()
	. = ..()
	ion_trail = new /datum/effect/system/ion_trail_follow()
	ion_trail.set_up(src)
	//src.air_contents.carbon_dioxide = (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C)
	air_contents.adjust_gas(/decl/xgm_gas/carbon_dioxide, (6 * ONE_ATMOSPHERE) * volume / (R_IDEAL_GAS_EQUATION * T20C))

/obj/item/tank/jetpack/carbondioxide/examine()
	set src in usr
	..()
	if(air_contents.gas[/decl/xgm_gas/carbon_dioxide] < 10)
		to_chat(usr, SPAN_DANGER("The meter on the [name] indicates you are almost out of air!"))
		playsound(usr, 'sound/effects/alert.ogg', 50, 1)
	return