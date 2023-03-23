/*
 * Power-related /area procs.
 */
// Returns true if the area has power to the provided channel.
/area/proc/powered(channel)
	if(!requires_power)
		return TRUE
	if(always_unpowered)
		return FALSE

	switch(channel)
		if(EQUIP)
			return power_equip
		if(LIGHT)
			return power_light
		if(ENVIRON)
			return power_environ

	return FALSE

// Called when power status changes.
/area/proc/power_change()
	for(var/obj/machinery/M in src)	// for each machine in the area
		M.power_change()			// reverify power status (to update icons etc.)
	if(fire_alarm || evac_alarm || party_alarm || destruct_alarm)
		updateicon()

// Returns the current usage on the provided channel.
/area/proc/usage(channel)
	var/used = 0
	switch(channel)
		if(LIGHT)
			used += used_light
		if(EQUIP)
			used += used_equip
		if(ENVIRON)
			used += used_environ
		if(TOTAL)
			used += used_light + used_equip + used_environ
	return used

// Sets usage on all channels to zero.
/area/proc/clear_usage()
	used_equip = 0
	used_light = 0
	used_environ = 0

// Adds the provided usage amount to the provided channel.
/area/proc/use_power(amount, channel)
	switch(channel)
		if(EQUIP)
			used_equip += amount
		if(LIGHT)
			used_light += amount
		if(ENVIRON)
			used_environ += amount