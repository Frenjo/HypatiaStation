//Challenge Areas

/area/away_mission/challenge/start
	name = "Where Am I?"
	icon_state = "away"

/area/away_mission/challenge/main
	name = "\improper Danger Room"
	icon_state = "away1"
	requires_power = FALSE

/area/away_mission/challenge/end
	name = "Administration"
	icon_state = "away2"
	requires_power = FALSE


/obj/machinery/power/emitter/energycannon
	name = "Energy Cannon"
	desc = "A heavy duty industrial laser"
	icon = 'icons/obj/singularity.dmi'
	icon_state = "emitter"
	anchored = TRUE
	density = TRUE

	use_power = 0
	idle_power_usage = 0
	active_power_usage = 0

	active = 1
	locked = 1
	state = 2