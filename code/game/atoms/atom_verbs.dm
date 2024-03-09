// This is a proc not a verb but there are worse inconsistencies in this codebase.
/atom/proc/examine(mob/user, distance = -1)
	// This reformats names to get a/an properly working on item descriptions when they are bloody.
	var/f_name = "\a [src]."
	if(blood_DNA && !istype(src, /obj/effect/decal))
		if(gender == PLURAL)
			f_name = "some "
		else
			f_name = "a "
		f_name += "[SPAN_DANGER("blood-stained")] [name]!"

	to_chat(user, "\icon[src] That's [f_name]")

	if(desc)
		to_chat(user, desc)

	return distance == -1 || (get_dist(src, user) <= distance)

/atom/movable/verb/pull()
	set category = PANEL_OBJECT
	set name = "Pull"
	set src in oview(1)

	if(Adjacent(usr))
		usr.start_pulling(src)