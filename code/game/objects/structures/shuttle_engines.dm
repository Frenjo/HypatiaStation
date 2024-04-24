/obj/structure/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'

/obj/structure/shuttle/window
	name = "shuttle window"
	icon = 'icons/obj/structures/podwindows.dmi'
	icon_state = "1"
	density = TRUE
	opacity = FALSE
	anchored = TRUE

/obj/structure/shuttle/window/CanPass(atom/movable/mover, turf/target, height, air_group)
	if(!height || air_group)
		return FALSE
	else
		return ..()

/obj/structure/shuttle/engine
	name = "engine"
	density = TRUE
	anchored = TRUE

/obj/structure/shuttle/engine/heater
	name = "heater"
	icon_state = "heater"

/obj/structure/shuttle/engine/platform
	name = "platform"
	icon_state = "platform"

/obj/structure/shuttle/engine/propulsion
	name = "propulsion"
	icon_state = "propulsion"
	opacity = TRUE

/obj/structure/shuttle/engine/propulsion/left
	icon_state = "propulsion_l"

/obj/structure/shuttle/engine/propulsion/right
	icon_state = "propulsion_r"

/obj/structure/shuttle/engine/propulsion/burst
	name = "burst"
	icon_state = "burst_s"

/obj/structure/shuttle/engine/propulsion/burst/left
	icon_state = "burst_l"

/obj/structure/shuttle/engine/propulsion/burst/right
	icon_state = "burst_r"

/obj/structure/shuttle/engine/router
	name = "router"
	icon_state = "router"