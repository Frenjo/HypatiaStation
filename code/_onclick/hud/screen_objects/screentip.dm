/atom/movable/screen/screentip
	icon = null
	icon_state = null
	mouse_opacity = FALSE
	screen_loc = "TOP,LEFT"
	maptext_height = 480

/atom/movable/screen/screentip/New()
	. = ..()
	// If world.view ever changes, this needs to change with it.
	maptext_width = 15 * world.icon_size