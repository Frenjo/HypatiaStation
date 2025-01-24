/*
 * Power-related /area procs
 */
// Returns TRUE if the area has power to the provided channel.
/area/proc/powered(channel)
	if(!requires_power)
		return TRUE
	if(always_unpowered)
		return FALSE

	if(isnotnull(power_channels[channel]))
		return power_channels[channel]

	return FALSE

// Called when power status changes.
/area/proc/power_change()
	for_no_type_check(var/obj/machinery/M, machines_list) // For each machine in the area.
		M.power_change()			// reverify power status (to update icons etc.)
	if(fire_alarm || evac_alarm || party_alarm || destruct_alarm)
		updateicon()

// Returns the current usage on the provided channel.
/area/proc/usage(channel)
	if(channel == TOTAL)
		return (power_used[EQUIP] + power_used[LIGHT] + power_used[ENVIRON])

	return power_used[channel]

// Sets usage on all channels to zero.
/area/proc/clear_usage()
	for(var/channel in power_used)
		power_used[channel] = 0

// Adds the provided usage amount to the provided channel.
/area/proc/use_power(amount, channel)
	if(isnotnull(power_used[channel]))
		power_used[channel] += amount