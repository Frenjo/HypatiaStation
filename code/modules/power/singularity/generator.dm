/////SINGULARITY SPAWNER
/obj/machinery/the_singularitygen
	name = "Gravitational Singularity Generator"
	desc = "An Odd Device which produces a Gravitational Singularity when set up."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "TheSingGen"
	anchored = FALSE
	density = TRUE

	power_state = USE_POWER_OFF

	var/energy = 0

/obj/machinery/the_singularitygen/process()
	var/turf/T = get_turf(src)
	if(src.energy >= 200)
		new /obj/singularity/(T, 50)
		if(src)
			qdel(src)

/obj/machinery/the_singularitygen/attack_tool(obj/item/tool, mob/user)
	if(iswrench(tool))
		anchored = !anchored
		if(anchored)
			user.visible_message(
				SPAN_NOTICE("[user] secures [src] to the floor."),
				SPAN_NOTICE("You secure \the [src] to the floor."),
				SPAN_INFO("You hear a ratchet.")
			)
		else
			user.visible_message(
				SPAN_NOTICE("[user] unsecures [src] from the floor."),
				SPAN_NOTICE("You unsecure \the [src] from the floor."),
				SPAN_INFO("You hear a ratchet.")
			)
		playsound(src, 'sound/items/Ratchet.ogg', 75, 1)
		return TRUE

	return ..()