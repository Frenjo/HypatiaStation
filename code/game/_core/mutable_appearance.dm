// The mutable appearance version of image().
/proc/mutable_appearance(icon, icon_state = "", plane = FLOAT_PLANE, layer = FLOAT_LAYER)
	RETURN_TYPE(/mutable_appearance)

	var/mutable_appearance/appearance = new /mutable_appearance()
	appearance.icon = icon
	appearance.icon_state = icon_state
	appearance.plane = plane
	appearance.layer = layer
	return appearance