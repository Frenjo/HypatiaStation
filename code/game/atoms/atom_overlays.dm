/atom/proc/add_overlay(new_overlay)
	if(isnull(overlays))
		return
	overlays.Add(new_overlay)

/atom/proc/cut_overlays()
	overlays.Cut()