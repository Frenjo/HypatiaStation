/*
 * Power-related /area procs
 */
// Returns TRUE if the area has power to the provided channel.
/area/proc/powered(channel)
	if(!requires_power)
		return TRUE
	if(always_unpowered)
		return FALSE

	switch(channel)
		if(EQUIP)
			return power_channels[EQUIP]
		if(LIGHT)
			return power_channels[LIGHT]
		if(ENVIRON)
			return power_channels[ENVIRON]

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
		if(EQUIP)
			used += power_used[EQUIP]
		if(LIGHT)
			used += power_used[LIGHT]
		if(ENVIRON)
			used += power_used[ENVIRON]
		if(TOTAL)
			used += power_used[EQUIP] + power_used[LIGHT] + power_used[ENVIRON]
	return used

// Sets usage on all channels to zero.
/area/proc/clear_usage()
	for(var/channel in power_used)
		power_used[channel] = 0

// Adds the provided usage amount to the provided channel.
/area/proc/use_power(amount, channel)
	switch(channel)
		if(EQUIP)
			power_used[EQUIP] += amount
		if(LIGHT)
			power_used[LIGHT] += amount
		if(ENVIRON)
			power_used[ENVIRON] += amount