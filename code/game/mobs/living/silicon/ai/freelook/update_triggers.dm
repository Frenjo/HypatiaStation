//UPDATE TRIGGERS, when the chunk (and the surrounding chunks) should update.
// Cameras are in code/game/objects/machinery/camera/visibility.dm.
// Doors are in code/game/objects/machinery/doors/visibility.dm.

// TURFS
/turf
	var/image/obscured

/turf/proc/visibilityChanged()
	global.CTcameranet?.update_visibility(src)

/turf/open/New()
	. = ..()
	visibilityChanged()

/turf/open/Destroy()
	visibilityChanged()
	return ..()

// STRUCTURES
/obj/structure/New()
	. = ..()
	global.CTcameranet?.update_visibility(src)

/obj/structure/Destroy()
	global.CTcameranet?.update_visibility(src)
	return ..()

// EFFECTS
/obj/effect/New()
	. = ..()
	global.CTcameranet?.update_visibility(src)

/obj/effect/Destroy()
	global.CTcameranet?.update_visibility(src)
	return ..()

// ROBOT MOVEMENT
// Update the portable camera everytime the Robot moves.
// This might be laggy, comment it out if there are problems.
#define BORG_CAMERA_BUFFER (3 SECONDS)
/mob/living/silicon/robot
	var/camera_updating = FALSE

/mob/living/silicon/robot/Move()
	var/oldLoc = loc
	. = ..()
	if(.)
		if(isnotnull(camera) && length(camera.network))
			if(!camera_updating)
				camera_updating = TRUE
				spawn(BORG_CAMERA_BUFFER)
					if(oldLoc != loc)
						global.CTcameranet.update_portable_camera(src.camera)
					camera_updating = FALSE
#undef BORG_CAMERA_BUFFER