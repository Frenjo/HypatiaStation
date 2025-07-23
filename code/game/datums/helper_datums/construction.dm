/datum/construction
	var/list/steps
	var/atom/holder
	var/result
	var/list/steps_desc

/datum/construction/New(atom, update_holder = TRUE)
	. = ..()
	holder = atom
	if(!holder) //don't want this without a holder
		qdel(src)
	if(update_holder)
		set_desc(length(steps))

/datum/construction/proc/next_step()
	steps.len--
	if(!length(steps))
		spawn_result()
	else
		set_desc(length(steps))

/datum/construction/proc/action(obj/item/used_item, mob/living/user)
	return check_step(used_item, user)

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
	return FALSE

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
	if(isnotnull(step["desc"]))
		holder.desc = step["desc"]

/*
 * Reversible Construction
 *
 * This is a heavily modified version of tgstation's /datum/construction, but here it's applied only to the /reversible subtype.
 */
#define FORWARD 1
#define BACKWARD -1

#define CONSTRUCTION_ACTION_DELETE "delete"

/datum/construction/reversible
	var/index = 1

	var/radial_messages = FALSE // If TRUE, balloon alerts for step completion will be displayed radially instead of just to the user.

/datum/construction/reversible/New(atom)
	. = ..(atom, FALSE)
	update_holder(index)

/datum/construction/reversible/check_step(obj/item/used_item, mob/living/user)
	var/diff = is_right_key(used_item)
	if(diff && custom_action(diff, used_item, user))
		update_index(diff)
		return TRUE
	return FALSE

/datum/construction/reversible/is_right_key(obj/item/used_item) // returns index step
	var/list/step = steps[index]
	if(istype(used_item, step["key"]))
		return FORWARD //to the first step -> forward
	else if(isnotnull(step["back_key"]) && istype(used_item, step["back_key"]))
		return BACKWARD //to the last step -> backwards
	return FALSE

/datum/construction/reversible/custom_action(diff, obj/item/used_item, mob/living/user)
	var/target_index = index + diff
	var/list/current_step = steps[index]
	var/list/target_step

	if(target_index > 0 && target_index <= length(steps))
		target_step = steps[target_index]

	. = TRUE

	if(iswelder(used_item))
		var/obj/item/weldingtool/W = used_item
		if(!W.remove_fuel(0, user))
			return FALSE
		playsound(holder, 'sound/items/Welder2.ogg', 50, 1)
	else if(iswrench(used_item))
		playsound(holder, 'sound/items/Ratchet.ogg', 50, 1)

	else if(isscrewdriver(used_item))
		playsound(holder, 'sound/items/Screwdriver.ogg', 50, 1)

	else if(iswirecutter(used_item))
		playsound(holder, 'sound/items/Wirecutter.ogg', 50, 1)

	else if(iscable(used_item))
		var/obj/item/stack/cable_coil/C = used_item
		if(C.amount < current_step["amount"])
			to_chat(user, SPAN_WARNING("There's not enough cable to finish the task."))
			return FALSE
		C.use(current_step["amount"])
		playsound(holder, 'sound/items/Deconstruct.ogg', 50, 1)
	else if(istype(used_item, /obj/item/stack))
		var/obj/item/stack/S = used_item
		if(S.amount < current_step["amount"])
			to_chat(user, SPAN_WARNING("There's not enough material in this stack."))
			return FALSE
		S.use(current_step["amount"])

	if(diff == FORWARD && current_step["action"] == CONSTRUCTION_ACTION_DELETE)
		qdel(used_item)

	if(. && diff == BACKWARD && isnotnull(target_step) && !target_step["no_refund"])
		var/target_step_key = target_step["key"]
		if(target_step["action"] == CONSTRUCTION_ACTION_DELETE)
			new target_step_key(GET_TURF(holder))
		else if(ispath(target_step_key, target_step["amount"]))
			new target_step_key(GET_TURF(holder), target_step["amount"])

	if(.)
		var/list/step = steps[index]
		var/message = null
		if(diff == FORWARD && isnotnull(step["message"]))
			message = step["message"]
		else if(diff == BACKWARD && isnotnull(step["back_message"]))
			message = step["back_message"]
		if(isnotnull(message))
			if(radial_messages)
				holder.balloon_alert_visible(message)
			else
				holder.balloon_alert(user, message)

/datum/construction/reversible/proc/update_holder()
	var/list/step = steps[index]
	if(isnotnull(step["desc"]))
		holder.desc = step["desc"]
	if(isnotnull(step["icon_state"]))
		holder.icon_state = step["icon_state"]

/datum/construction/reversible/proc/on_step()
	if(index >= length(steps))
		spawn_result()
	else
		update_holder()

/datum/construction/reversible/proc/update_index(diff)
	index += diff
	on_step()