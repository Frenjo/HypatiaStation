/mob/living/Life()
	set invisibility = 0
	set background = BACKGROUND_ENABLED
	. = ..()

	if(!loc)
		return	// Fixing a null error that occurs when the mob isn't found in the world -- TLE
	if(monkeyizing)
		return
	
	var/datum/gas_mixture/environment = loc.return_air()

	// Handle temperature/pressure differences between body and environment.
	if(environment) // More error checking -- TLE
		handle_environment(environment) // Optimised a good bit.

/mob/living/proc/handle_environment(datum/gas_mixture/environment)
	return