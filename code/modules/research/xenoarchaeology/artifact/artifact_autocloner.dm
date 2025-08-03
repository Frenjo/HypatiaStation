/obj/machinery/auto_cloner
	name = "mysterious pod"
	desc = "It's full of a viscous liquid, but appears dark and silent."
	icon = 'icons/obj/cryogenics.dmi'
	icon_state = "cellold0"
	density = TRUE

	power_usage = alist(
		USE_POWER_IDLE = 1000,
		USE_POWER_ACTIVE = 2000
	)

	var/spawn_type
	var/current_ticks_spawning = 0
	var/ticks_required_to_spawn
	var/previous_power_state = 0

	var/list/nasties = list(
		/mob/living/simple/hostile/giant_spider/nurse,
		/mob/living/simple/hostile/alien,
		/mob/living/simple/hostile/bear,
		/mob/living/simple/hostile/creature,
		/mob/living/simple/hostile/panther,
		/mob/living/simple/hostile/snake
	)

	var/list/not_nasties = list(
		/mob/living/simple/cat,
		/mob/living/simple/corgi,
		/mob/living/simple/corgi/puppy,
		/mob/living/simple/chicken,
		/mob/living/simple/cow,
		/mob/living/simple/parrot,
		/mob/living/simple/slime,
		/mob/living/simple/crab,
		/mob/living/simple/mouse,
		/mob/living/simple/hostile/retaliate/goat,
		/mob/living/carbon/monkey
	)

/obj/machinery/auto_cloner/initialise()
	. = ..()

	ticks_required_to_spawn = rand(240, 1440)

	//33% chance to spawn nasties
	if(prob(33))
		spawn_type = pick(nasties)
	else
		spawn_type = pick(not_nasties)

//todo: how the hell is the asteroid permanently powered?
/obj/machinery/auto_cloner/process()
	if(powered(power_channel))
		if(!previous_power_state)
			previous_power_state = 1
			icon_state = "cellold1"
			visible_message(SPAN_INFO("[html_icon(src)] [src] suddenly comes to life!"))

		//slowly grow a mob
		current_ticks_spawning++
		if(prob(5))
			visible_message(SPAN_INFO("[html_icon(src)] [src] [pick("gloops", "glugs", "whirrs", "whooshes", "hisses", "purrs", "hums", "gushes")]."))

		//if we've finished growing...
		if(current_ticks_spawning >= ticks_required_to_spawn)
			current_ticks_spawning = 0
			update_power_state(USE_POWER_IDLE)
			visible_message(SPAN_INFO("[html_icon(src)] [src] pings!"))
			icon_state = "cellold1"
			desc = "It's full of a bubbling viscous liquid, and is lit by a mysterious glow."
			if(spawn_type)
				new spawn_type(src.loc)

		//if we're getting close to finished, kick into overdrive power usage
		if(current_ticks_spawning / ticks_required_to_spawn > 0.75)
			update_power_state(USE_POWER_ACTIVE)
			icon_state = "cellold2"
			desc = "It's full of a bubbling viscous liquid, and is lit by a mysterious glow. A dark shape appears to be forming inside..."
		else
			update_power_state(USE_POWER_IDLE)
			icon_state = "cellold1"
			desc = "It's full of a bubbling viscous liquid, and is lit by a mysterious glow."
	else
		if(previous_power_state)
			previous_power_state = 0
			icon_state = "cellold0"
			visible_message(SPAN_INFO("[html_icon(src)] [src] suddenly shuts down."))

		//cloned mob slowly breaks down
		if(current_ticks_spawning > 0)
			current_ticks_spawning--