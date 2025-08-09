/atom/proc/reset_plane_and_layer()
	plane = initial(plane)
	layer = initial(layer)

/atom/proc/copy_initial_plane_and_layer(atom/to_copy)
	plane = initial(to_copy.plane)
	layer = initial(to_copy.layer)