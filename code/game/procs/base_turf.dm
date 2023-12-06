// Returns the lowest turf available on a given Z-level.
/proc/get_base_turf(z)
	if(isnull(GLOBL.current_map.base_turf_by_z["[z]"]))
		GLOBL.current_map.base_turf_by_z["[z]"] = world.turf
	return GLOBL.current_map.base_turf_by_z["[z]"]

// An area can override the z-level base turf, so our solar array areas etc. can be space-based.
/proc/get_base_turf_by_area(turf/T)
	var/area/A = T.loc
	if(isnotnull(A?.base_turf))
		return A.base_turf
	return get_base_turf(T.z)

/client/proc/set_base_turf()
	set category = PANEL_DEBUG
	set name = "Set Base Turf"
	set desc = "Set the base turf for a z-level."

	if(isnull(holder))
		return

	var/choice = input("Which Z-level do you wish to set the base turf for?") as num | null
	if(isnull(choice))
		return

	var/new_base_path = input("Please select a turf path or cancel to reset to [world.turf].") as null | anything in typesof(/turf)
	if(isnull(new_base_path))
		new_base_path = world.turf
	GLOBL.current_map.base_turf_by_z[choice] = new_base_path
	message_admins("[key_name_admin(usr)] has set the base turf for z-level [choice] to [get_base_turf(choice)].")
	log_admin("[key_name(usr)] has set the base turf for z-level [choice] to [get_base_turf(choice)].")