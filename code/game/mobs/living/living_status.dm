/*
adds a dizziness amount to a mob
use this rather than directly changing var/dizziness
since this ensures that the dizzy_process proc is started
currently only humans get dizzy

value of dizziness ranges from 0 to 1000
below 100 is not dizzy
*/
/mob/living/proc/make_dizzy(amount)
	if(!ishuman(src)) // for the moment, only humans get dizzy
		return

	dizziness = min(1000, dizziness + amount)	// store what will be new value
													// clamped to max 1000
	if(dizziness > 100 && !is_dizzy)
		dizzy_process()

/*
dizzy process - wiggles the client's pixel offset over time
spawned from make_dizzy(), will terminate automatically when dizziness gets <100
note dizziness decrements automatically in the mob's Life() proc.
*/
/mob/living/proc/dizzy_process()
	set waitfor = FALSE
	is_dizzy = TRUE
	while(dizziness > 100)
		if(isnotnull(client))
			var/amplitude = dizziness * (sin(dizziness * 0.044 * world.time) + 1) / 70
			client.pixel_x = amplitude * sin(0.008 * dizziness * world.time)
			client.pixel_y = amplitude * cos(0.008 * dizziness * world.time)

		sleep(1)
	//endwhile - reset the pixel offsets to zero
	is_dizzy = FALSE
	if(isnotnull(client))
		client.pixel_x = 0
		client.pixel_y = 0

// jitteriness - copy+paste of dizziness
/mob/living/proc/make_jittery(amount)
	if(!ishuman(src)) // for the moment, only humans get dizzy
		return

	jitteriness = min(1000, jitteriness + amount)	// store what will be new value
													// clamped to max 1000
	if(jitteriness > 100 && !is_jittery)
		jittery_process()

// Typo from the oriignal coder here, below lies the jitteriness process. So make of his code what you will, the previous comment here was just a copypaste of the above.
/mob/living/proc/jittery_process()
	set waitfor = FALSE
	var/old_x = pixel_x
	var/old_y = pixel_y
	is_jittery = TRUE
	while(jitteriness > 100)
//		var/amplitude = jitteriness*(sin(jitteriness * 0.044 * world.time) + 1) / 70
//		pixel_x = amplitude * sin(0.008 * jitteriness * world.time)
//		pixel_y = amplitude * cos(0.008 * jitteriness * world.time)

		var/amplitude = min(4, jitteriness / 100)
		pixel_x = rand(-amplitude, amplitude)
		pixel_y = rand(-amplitude / 3, amplitude / 3)

		sleep(1)
	//endwhile - reset the pixel offsets to zero
	is_jittery = FALSE
	pixel_x = old_x
	pixel_y = old_y