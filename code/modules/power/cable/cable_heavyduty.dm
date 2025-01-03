/obj/item/stack/cable_coil/heavyduty
	name = "heavy cable coil"
	icon = 'icons/obj/power.dmi'
	icon_state = "wire"

/obj/structure/cable/heavyduty
	icon = 'icons/obj/power_cond_heavy.dmi'
	name = "large power cable"
	desc = "This cable is tough. It cannot be cut with simple hand tools."
	layer = 2.39 //Just below pipes, which are at 2.4

/obj/structure/cable/heavyduty/attack_tool(obj/item/tool, mob/user)
	if(iswirecutter(tool))
		to_chat(user, SPAN_WARNING("The cables are too tough to be cut with \the [tool]."))
		return TRUE

	if(iscable(tool))
		to_chat(user, SPAN_WARNING("You will need heavier cables to connect to these."))
		return TRUE

	return ..()

/obj/structure/cable/heavyduty/attackby(obj/item/W, mob/user)
	var/turf/T = GET_TURF(src)
	if(T?.intact)
		return

	return ..()

/obj/structure/cable/heavyduty/cableColor(colorC)
	return