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

/datum/construction/proc/action(obj/item/used_item, mob/living/user)
	return

/datum/construction/proc/check_step(obj/item/used_item, mob/living/user) //check last step only
	var/valid_step = is_right_key(used_item)
	if(valid_step && custom_action(valid_step, used_item, user))
		next_step()
		return TRUE
	return FALSE

/datum/construction/proc/is_right_key(obj/item/used_item) // returns current step num if used_item is of the right type.
	var/list/step = steps[length(steps)]
	if(istype(used_item, step["key"]))
		return length(steps)
	return 0

/datum/construction/proc/custom_action(step, obj/item/used_item, mob/living/user)
	return TRUE

/datum/construction/proc/check_all_steps(obj/item/used_item, mob/living/user) //check all steps, remove matching one.
	for(var/i = 1; i <= length(steps); i++)
		var/list/step = steps[i]
		if(istype(used_item, step["key"]))
			if(custom_action(i, used_item, user))
				steps[i] = null //stupid byond list from list removal...
				listclearnulls(steps)
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

/datum/construction/reversible/is_right_key(obj/item/used_item) // returns index step
	var/list/step = steps[index]
	if(istype(used_item, step["key"]))
		return FORWARD //to the first step -> forward
	else if(isnotnull(step["back_key"]) && istype(used_item, step["back_key"]))
		return BACKWARD //to the last step -> backwards
	return 0

/datum/construction/reversible/check_step(obj/item/used_item, mob/living/user)
	var/diff = is_right_key(used_item)
	if(diff && custom_action(index, diff, used_item, user))
		update_index(diff)
		return TRUE
	return FALSE

/datum/construction/reversible/custom_action(index, diff, used_item, user)
	return TRUE