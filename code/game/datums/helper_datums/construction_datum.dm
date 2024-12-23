#define FORWARD -1
#define BACKWARD 1

/datum/construction
	var/list/steps
	var/atom/holder
	var/result
	var/list/steps_desc

/datum/construction/New(atom)
	. = ..()
	holder = atom
	if(!holder) //don't want this without a holder
		qdel(src)
	set_desc(length(steps))

/datum/construction/proc/next_step()
	steps.len--
	if(!length(steps))
		spawn_result()
	else
		set_desc(length(steps))

/datum/construction/proc/action(atom/used_atom, mob/user)
	return

/datum/construction/proc/check_step(atom/used_atom, mob/user) //check last step only
	var/valid_step = is_right_key(used_atom)
	if(valid_step)
		if(custom_action(valid_step, used_atom, user))
			next_step()
			return TRUE
	return FALSE

/datum/construction/proc/is_right_key(atom/used_atom) // returns current step num if used_atom is of the right type.
	var/list/L = steps[length(steps)]
	if(istype(used_atom, L["key"]))
		return length(steps)
	return 0

/datum/construction/proc/custom_action(step, used_atom, user)
	return TRUE

/datum/construction/proc/check_all_steps(atom/used_atom, mob/user) //check all steps, remove matching one.
	for(var/i = 1; i <= length(steps); i++)
		var/list/L = steps[i];
		if(istype(used_atom, L["key"]))
			if(custom_action(i, used_atom, user))
				steps[i] = null;	//stupid byond list from list removal...
				listclearnulls(steps);
				if(!length(steps))
					spawn_result()
				return TRUE
	return FALSE

/datum/construction/proc/spawn_result()
	if(isnotnull(result))
		new result(GET_TURF(holder))
		qdel(holder)

/datum/construction/proc/set_desc(index)
	var/list/step = steps[index]
	holder.desc = step["desc"]


/datum/construction/reversible
	var/index

/datum/construction/reversible/New(atom)
	. = ..()
	index = length(steps)

/datum/construction/reversible/proc/update_index(diff)
	index += diff
	if(index == 0)
		spawn_result()
	else
		set_desc(index)

/datum/construction/reversible/is_right_key(atom/used_atom) // returns index step
	var/list/L = steps[index]
	if(istype(used_atom, L["key"]))
		return FORWARD //to the first step -> forward
	else if(isnotnull(L["back_key"]) && istype(used_atom, L["back_key"]))
		return BACKWARD //to the last step -> backwards
	return 0

/datum/construction/reversible/check_step(atom/used_atom, mob/user)
	var/diff = is_right_key(used_atom)
	if(diff)
		if(custom_action(index, diff, used_atom, user))
			update_index(diff)
			return TRUE
	return FALSE

/datum/construction/reversible/custom_action(index, diff, used_atom, user)
	return TRUE