/datum/topic_input
	VAR_PRIVATE/_href
	VAR_PRIVATE/list/_href_list

/datum/topic_input/New(href, list/href_list)
	. = ..()
	_href = href
	_href_list = href_list.Copy()

/datum/topic_input/proc/has(i)
	return isnotnull(_href_list[i])

/datum/topic_input/proc/get(i)
	return listgetindex(_href_list, i)

/datum/topic_input/proc/get_and_locate(i)
	var/t = get(i)
	if(isnotnull(t))
		t = locate(t)
	return t || null

/datum/topic_input/proc/get_num(i)
	var/t = get(i)
	if(isnotnull(t))
		t = text2num(t)
	return isnum(t) ? t : null

/datum/topic_input/proc/get_obj(i)
	RETURN_TYPE(/obj)

	var/t = get_and_locate(i)
	return isobj(t) ? t : null

/datum/topic_input/proc/get_mob(i)
	RETURN_TYPE(/mob)

	var/t = get_and_locate(i)
	return ismob(t) ? t : null

/datum/topic_input/proc/get_turf(i)
	RETURN_TYPE(/turf)

	var/t = get_and_locate(i)
	return isturf(t) ? t : null

/datum/topic_input/proc/get_atom(i)
	RETURN_TYPE(/atom)

	return get_type(i, /atom)

/datum/topic_input/proc/get_area(i)
	RETURN_TYPE(/area)

	var/t = get_and_locate(i)
	return isarea(t) ? t : null

/datum/topic_input/proc/get_str(i) // Params should always be text, but...
	var/t = get(i)
	return istext(t) ? t : null

/datum/topic_input/proc/get_type(i, type)
	RETURN_TYPE(type)

	var/t = get_and_locate(i)
	return istype(t, type) ? t : null

/datum/topic_input/proc/get_path(i)
	var/t = get(i)
	if(isnotnull(t))
		t = text2path(t)
	return ispath(t) ? t : null

/datum/topic_input/proc/get_list(i)
	RETURN_TYPE(/list)

	var/t = get_and_locate(i)
	return islist(t) ? t : null