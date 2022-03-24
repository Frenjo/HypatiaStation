/proc/captain_announce(text)
	to_world("<h1 class='alert'>Priority Announcement</h1>")
	to_world(SPAN_ALERT("[html_encode(text)]"))
	to_world("<br>")