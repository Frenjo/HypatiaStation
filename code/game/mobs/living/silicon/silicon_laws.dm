/mob/living/silicon/proc/state_laws()
	var/number = 1
	say("Current Active Laws:")
	sleep(1 SECOND)

	if(isnotnull(laws.zeroth))
		if(lawcheck[1] == "Yes") // This line and the similar lines below make sure you don't state a law unless you want to. --NeoFite
			say("0. [laws.zeroth]")
			sleep(1 SECOND)

	for(var/index in 1 to length(laws.ion))
		var/law = laws.ion[index]
		var/num = ionnum()
		if(length(law) > 0)
			if(ioncheck[index] == "Yes")
				say("[num]. [law]")
				sleep(1 SECOND)

	for(var/index in 1 to length(laws.inherent))
		var/law = laws.inherent[index]
		if(length(law) > 0)
			if(lawcheck[index + 1] == "Yes")
				say("[number]. [law]")
				sleep(1 SECOND)
			number++

	for(var/index in 1 to length(laws.supplied))
		var/law = laws.supplied[index]

		if(length(law) > 0)
			if(length(lawcheck) >= number + 1)
				if(lawcheck[number + 1] == "Yes")
					say("[number]. [law]")
					sleep(1 SECOND)
				number++