/client/proc/set_zoom_mode(new_mode)
	if(new_mode == chosen_scaling_mode)
		return FALSE
	if(!(new_mode in scaling_modes))
		return FALSE

	chosen_scaling_mode = new_mode
	winset(src, "mapwindow.map", "zoom-mode=[new_mode]")
	return TRUE