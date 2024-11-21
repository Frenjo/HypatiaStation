/datum/round_event/wallrot
	var/severity = 1

/datum/round_event/wallrot/setup()
	announceWhen = rand(0, 300)
	endWhen = announceWhen + 1
	severity = rand(5, 10)

/datum/round_event/wallrot/announce()
	command_alert("Harmful fungi detected on station. Station structures may be contaminated.", "Biohazard Alert")

/datum/round_event/wallrot/start()
	spawn()
		var/turf/center = null

		// 100 attempts
		for(var/i = 0, i < 100, i++)
			var/turf/candidate = locate(rand(1, world.maxx), rand(1, world.maxy), 1)
			if(istype(candidate, /turf/closed/wall))
				center = candidate

		if(center)
			// Make sure at least one piece of wall rots!
			center:rot()

			// Have a chance to rot lots of other walls.
			var/rotcount = 0
			for(var/turf/closed/wall/W in range(5, center))
				if(prob(50))
					W:rot()
					rotcount++

				// Only rot up to severity walls
				if(rotcount >= severity)
					break