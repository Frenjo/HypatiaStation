//Will return the contents of an atom recursivly to a depth of 'searchDepth'
/atom/proc/GetAllContents(searchDepth = 5)
	. = list()

	for_no_type_check(var/atom/movable/part, src)
		. += part
		if(length(part.contents) && searchDepth)
			. += part.GetAllContents(searchDepth - 1)

// This is mostly ported from /tg/ code with slight modifications to make it work with our older infrastructure.
#define BALLOON_TEXT_WIDTH 200
#define BALLOON_TEXT_SPAWN_TIME (0.2 SECONDS)
#define BALLOON_TEXT_FADE_TIME (0.1 SECONDS)
#define BALLOON_TEXT_FULLY_VISIBLE_TIME (0.7 SECONDS)
#define BALLOON_TEXT_TOTAL_LIFETIME (BALLOON_TEXT_SPAWN_TIME + BALLOON_TEXT_FULLY_VISIBLE_TIME + BALLOON_TEXT_FADE_TIME)

// Creates text that will float from the atom upwards to all viewers in range.
// This uses the same code as /atom/proc/visible_message
/atom/proc/balloon_alert_visible(text)
	for(var/mob/M in viewers(src))
		balloon_alert(M, text)

// Creates text that will float from the atom upwards to the viewer.
/atom/proc/balloon_alert(mob/viewer, text)
	var/client/viewer_client = viewer.client
	if(isnull(viewer_client))
		return

	var/bound_width = world.icon_size
	if(ismovable(src))
		var/atom/movable/movable_source = src
		bound_width = movable_source.bound_width

	var/image/balloon_alert = image(loc = loc, layer = MOB_LAYER + 0.1)
	balloon_alert.plane = BALLOON_TEXT_PLANE
	balloon_alert.alpha = 0
	balloon_alert.maptext = "<span style='text-align: center; -dm-text-outline: 1px #0005'>[text]</span>"
	balloon_alert.maptext_x = (BALLOON_TEXT_WIDTH - bound_width) * -0.5
	balloon_alert.maptext_height = WXH_TO_HEIGHT(viewer_client.MeasureText(text, null, BALLOON_TEXT_WIDTH))
	balloon_alert.maptext_width = BALLOON_TEXT_WIDTH

	viewer_client.images.Add(balloon_alert)

	animate(
		balloon_alert,
		pixel_y = world.icon_size * 1.2,
		time = BALLOON_TEXT_TOTAL_LIFETIME,
		easing = SINE_EASING | EASE_OUT,
	)

	animate(
		alpha = 255,
		time = BALLOON_TEXT_SPAWN_TIME,
		easing = CUBIC_EASING | EASE_OUT,
		flags = ANIMATION_PARALLEL,
	)

	animate(
		alpha = 0,
		time = BALLOON_TEXT_FULLY_VISIBLE_TIME,
		easing = CUBIC_EASING | EASE_IN,
	)

	// We don't have a timer system so this will have to do.
	spawn(BALLOON_TEXT_TOTAL_LIFETIME)
		viewer_client.images.Remove(balloon_alert)

#undef BALLOON_TEXT_FADE_TIME
#undef BALLOON_TEXT_FULLY_VISIBLE_TIME
#undef BALLOON_TEXT_SPAWN_TIME
#undef BALLOON_TEXT_TOTAL_LIFETIME
#undef BALLOON_TEXT_WIDTH