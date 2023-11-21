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
	set name = "Pull"
	set category = "Object"
	set src in oview(1)

	if(Adjacent(usr))
		usr.start_pulling(src)

/atom/verb/point()
	set name = "Point To"
	set category = "Object"
	set src in oview()
	var/atom/this = src//detach proc from src
	//qdel(src) // Trying to fix pointing deleting whatever you point at. -Frenjo

	if(isnull(usr) || !isturf(usr.loc))
		return
	if(usr.stat || usr.restrained())
		return
	if(usr.status_flags & FAKEDEATH)
		return

	var/tile = get_turf(this)
	if(isnull(tile))
		return

	var/P = new /obj/effect/decal/point(tile)
	spawn(20)
		if(isnotnull(P))
			qdel(P)

	usr.visible_message("<b>[usr]</b> points to [this].") // Added a full stop here. -Frenjo