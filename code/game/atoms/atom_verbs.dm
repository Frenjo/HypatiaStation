// This is a proc not a verb but there are worse inconsistencies in this codebase.
/atom/proc/examine(mob/user, distance = -1)
	var/list/examine_header = get_examine_header(user, distance)
	var/list/examine_text = get_examine_text(user, distance)
	to_chat(user, jointext(examine_header + examine_text, "\n"))
	return distance == -1 || (get_dist(src, user) <= distance)

/atom/proc/get_examine_header(mob/user, distance = -1)
	RETURN_TYPE(/list)
	SHOULD_CALL_PARENT(FALSE)

	. = list()
	// This reformats names to get a/an properly working on item descriptions when they are bloody.
	var/f_name = "\a [src]."
	if(blood_DNA && !istype(src, /obj/effect/decal))
		if(gender == PLURAL)
			f_name = "some "
		else
			f_name = "a "
		f_name += "[SPAN_DANGER("blood-stained")] [name]!"

	. += "This is \icon[src] [f_name]"

	if(desc)
		. += desc

/atom/proc/get_examine_text(mob/user, distance = -1)
	RETURN_TYPE(/list)
	SHOULD_CALL_PARENT(TRUE)

	. = list()

/atom/movable/verb/pull()
	set category = null
	set name = "Pull"
	set src in oview(1)

	if(Adjacent(usr))
		usr.start_pulling(src)