// This is a proc not a verb but there are worse inconsistencies in this codebase.
/atom/proc/examine(mob/user, distance = -1)
	var/list/examine_header = get_examine_header(user, distance)
	var/list/examine_text = get_examine_text(user, distance)
	var/examine_output = jointext(examine_header + examine_text, "<br>")
	to_chat(user, "<div class='examine'>[examine_output]</div>")
	return distance == -1 || (get_dist(src, user) <= distance)

/atom/proc/get_examine_header(mob/user, distance = -1)
	RETURN_TYPE(/list)
	SHOULD_CALL_PARENT(FALSE)

	. = list()
	// This reformats names to get a/an properly working on item descriptions when they are bloody.
	var/f_name = "<em>\a [src]</em>."
	if(blood_DNA && !istype(src, /obj/effect/decal))
		if(gender == PLURAL)
			f_name = "<em>some</em> "
		else
			f_name = "<em>a</em> "
		f_name += "[SPAN_DANGER("blood-stained")] <em>[name]</em>!"

	. += "This is [icon2html(src, user)] [f_name]"

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