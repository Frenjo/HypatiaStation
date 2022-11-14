#define BORG_CAMERA_BUFFER 30

//UPDATE TRIGGERS, when the chunk (and the surrounding chunks) should update.
// Cameras are in code/game/objects/machinery/camera/visibility.dm.
// Doors are in code/game/objects/machinery/doors/visibility.dm.

// TURFS
/turf
	var/image/obscured

/turf/proc/visibilityChanged()
	if(global.CTgame_ticker)
		global.CTcameranet.updateVisibility(src)

/turf/simulated/New()
	..()
	visibilityChanged()

/turf/simulated/Destroy()
	visibilityChanged()
	return ..()

// STRUCTURES
/obj/structure/New()
	..()
	if(global.CTgame_ticker)
		global.CTcameranet.updateVisibility(src)

/obj/structure/Destroy()
	if(global.CTgame_ticker)
		global.CTcameranet.updateVisibility(src)
	return ..()

// EFFECTS
/obj/effect/New()
	..()
	if(global.CTgame_ticker)
		global.CTcameranet.updateVisibility(src)

/obj/effect/Destroy()
	if(global.CTgame_ticker)
		global.CTcameranet.updateVisibility(src)
	return ..()

// ROBOT MOVEMENT
// Update the portable camera everytime the Robot moves.
// This might be laggy, comment it out if there are problems.
/mob/living/silicon/robot/var/updating = 0

/mob/living/silicon/robot/Move()
	var/oldLoc = src.loc
	. = ..()
	if(.)
		if(src.camera && src.camera.network.len)
			if(!updating)
				updating = 1
				spawn(BORG_CAMERA_BUFFER)
					if(oldLoc != src.loc)
						global.CTcameranet.updatePortableCamera(src.camera)
					updating = 0

#undef BORG_CAMERA_BUFFER