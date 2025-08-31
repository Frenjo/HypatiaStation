/atom/movable/verb/pull()
	set category = null
	set name = "Pull"
	set src in oview(1)

	if(Adjacent(usr))
		usr.start_pulling(src)