/obj/machinery/giga_drill
	name = "alien drill"
	desc = "A giant, alien drill mounted on long treads."
	icon = 'icons/obj/mining.dmi'
	icon_state = "gigadrill"
	density = TRUE
	layer = 3.1		//to go over ores

	var/active = 0
	var/drill_time = 10
	var/turf/drilling_turf

/obj/machinery/giga_drill/attack_hand(mob/user)
	if(active)
		active = 0
		icon_state = "gigadrill"
		to_chat(user, SPAN_INFO("You press a button and [src] slowly spins down."))
	else
		active = 1
		icon_state = "gigadrill_mov"
		to_chat(user, SPAN_INFO("You press a button and [src] shudders to life."))

/obj/machinery/giga_drill/Bump(atom/A)
	if(active && !drilling_turf)
		if(istype(A, /turf/closed/rock))
			var/turf/closed/rock/M = A
			drilling_turf = GET_TURF(src)
			visible_message(SPAN_DANGER("[src] begins to drill into [M]!"))
			anchored = TRUE
			spawn(drill_time)
				if(GET_TURF(src) == drilling_turf && active)
					M.get_drilled()
					forceMove(M)
				drilling_turf = null
				anchored = FALSE