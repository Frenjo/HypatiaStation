/client/verb/fit_viewport()
	set category = PANEL_OOC
	set name = "Fit Viewport"
	set desc = "Adjusts the width of the map window to remove letterboxing."

	// Fetches the aspect ratio.
	var/view_size = world.view
	var/aspect_ratio = view_size / view_size

	// Calculates the desired pixel width using window size and aspect ratio.
	var/sizes = params2list(winget(src, "mainwindow.mainvsplit;mapwindow", "size"))
	var/map_size = splittext(sizes["mapwindow.size"], "x")
	var/height = text2num(map_size[2])
	var/desired_width = round(height * aspect_ratio)
	if(text2num(map_size[1]) == desired_width)
		return

	var/split_size = splittext(sizes["mainwindow.mainvsplit.size"], "x")
	var/split_width = text2num(split_size[1])

	// Calculates and applies a best estimate.
	// +4 pixels are for the width of the splitter's handle
	var/pct = 100 * (desired_width + 4) / split_width
	winset(src, "mainwindow.mainvsplit", "splitter=[pct]")

	// Applies an ever-lowering offset until we finish or fail.
	var/delta
	for(var/safety in 1 to 10)
		var/after_size = winget(src, "mapwindow", "size")
		map_size = splittext(after_size, "x")
		var/got_width = text2num(map_size[1])

		if(got_width == desired_width)
			return
		else if(isnull(delta))
			// Calculates a probable delta value based on the difference.
			delta = 100 * (desired_width - got_width) / split_width
		else if((delta > 0 && got_width > desired_width) || (delta < 0 && got_width < desired_width))
			// If we overshot, halve the delta and reverse direction.
			delta = -delta / 2

		pct += delta
		winset(src, "mainwindow.mainvsplit", "splitter=[pct]")