#define UPDATE_BUFFER (2.5 SECONDS)

// CAMERA CHUNK
//
// A 16x16 grid of the map with a list of turfs that can be seen, are visible and are dimmed.
// Allows the AI Eye to stream these chunks and know what it can and cannot see.
/datum/camera_chunk
	var/list/turf/obscured_turfs = list()
	var/list/turf/visible_turfs = list()
	var/list/image/obscured = list()
	var/list/obj/machinery/camera/cameras = list()
	var/list/turf/turfs = list()
	var/list/mob/dead/ai_eye/seen_by = list()

	var/visible = 0
	var/changed = FALSE
	var/updating = FALSE

	var/x = 0
	var/y = 0
	var/z = 0

// Create a new camera chunk, since the chunks are made as they are needed.
/datum/camera_chunk/New(loc, x, y, z)
	// 0xf = 15
	x &= ~0xf
	y &= ~0xf

	src.x = x
	src.y = y
	src.z = z

	for(var/obj/machinery/camera/c in range(16, locate(x + 8, y + 8, z)))
		if(c.can_use())
			cameras.Add(c)

	for(var/turf/t in range(10, locate(x + 8, y + 8, z)))
		if(t.x >= x && t.y >= y && t.x < x + 16 && t.y < y + 16)
			turfs[t] = t

	for_no_type_check(var/obj/machinery/camera/c, cameras)
		if(isnull(c))
			continue

		if(!c.can_use())
			continue

		for(var/turf/t in c.can_see())
			visible_turfs[t] = t

	// Removes turf that isn't in turfs.
	visible_turfs &= turfs

	obscured_turfs = turfs - visible_turfs

	for_no_type_check(var/turf/t, obscured_turfs)
		if(isnull(t.obscured))
			t.obscured = image('icons/effects/cameravis.dmi', t, "black", 15)
			t.obscured.plane = OBSCURITY_PLANE
		obscured.Add(t.obscured)

// Add an AI eye to the chunk, then update if changed.
/datum/camera_chunk/proc/add(mob/dead/ai_eye/ai)
	if(isnull(ai.ai))
		return

	ai.visible_camera_chunks.Add(src)
	if(isnotnull(ai.ai.client))
		ai.ai.client.images.Add(obscured)
	visible++
	seen_by.Add(ai)
	if(changed && !updating)
		update()

// Remove an AI eye from the chunk, then update if changed.
/datum/camera_chunk/proc/remove(mob/dead/ai_eye/ai)
	if(isnull(ai.ai))
		return

	ai.visible_camera_chunks.Remove(src)
	if(isnotnull(ai.ai.client))
		ai.ai.client.images.Remove(obscured)
	seen_by.Remove(ai)
	if(visible > 0)
		visible--

// Called when a chunk has changed. I.E: A wall was deleted.
/datum/camera_chunk/proc/visibilityChanged(turf/loc)
	if(isnull(visible_turfs[loc]))
		return
	hasChanged()

// Updates the chunk, makes sure that it doesn't update too much. If the chunk isn't being watched it will
// instead be flagged to update the next time an AI Eye moves near it.
/datum/camera_chunk/proc/hasChanged(update_now = 0)
	if(visible || update_now)
		if(!updating)
			updating = TRUE
			spawn(UPDATE_BUFFER) // Batch large changes, such as many doors opening or closing at once
				update()
				updating = FALSE
	else
		changed = TRUE

// The actual updating. It gathers the visible turfs from cameras and puts them into the appropiate lists.
/datum/camera_chunk/proc/update()
	set background = BACKGROUND_ENABLED

	var/list/turf/new_visible_turfs = list()

	for_no_type_check(var/obj/machinery/camera/c, cameras)
		if(isnull(c))
			continue

		if(!c.can_use())
			continue

		var/turf/point = locate(src.x + 8, src.y + 8, src.z)
		if(get_dist(point, c) > 24)
			continue

		for(var/turf/t in c.can_see())
			new_visible_turfs[t] = t

	// Removes turf that isn't in turfs.
	new_visible_turfs &= turfs

	var/list/turf/vis_added = new_visible_turfs - visible_turfs
	var/list/turf/vis_removed = visible_turfs - new_visible_turfs

	visible_turfs = new_visible_turfs
	obscured_turfs = turfs - new_visible_turfs

	for_no_type_check(var/turf/t, vis_added)
		if(isnotnull(t.obscured))
			obscured.Remove(t.obscured)
			for_no_type_check(var/mob/dead/ai_eye/m, seen_by)
				if(isnull(m?.ai))
					continue
				if(isnotnull(m.ai.client))
					m.ai.client.images.Remove(t.obscured)

	for_no_type_check(var/turf/t, vis_removed)
		if(isnotnull(obscured_turfs[t]))
			if(isnull(t.obscured))
				t.obscured = image('icons/effects/cameravis.dmi', t, "black", 15)
				t.obscured.plane = OBSCURITY_PLANE

			obscured.Add(t.obscured)
			for_no_type_check(var/mob/dead/ai_eye/m, seen_by)
				if(isnull(m?.ai))
					seen_by.Remove(m)
					continue
				if(isnotnull(m.ai.client))
					m.ai.client.images.Add(t.obscured)

#undef UPDATE_BUFFER