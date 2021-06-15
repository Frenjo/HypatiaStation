/proc/captain_announce(text)
	to_chat(world, "<h1 class='alert'>Priority Announcement</h1>")
	to_chat(world, SPAN_ALERT("[html_encode(text)]"))
	to_chat(world, "<br>")

