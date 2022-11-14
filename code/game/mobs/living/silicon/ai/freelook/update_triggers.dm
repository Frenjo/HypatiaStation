#define BORG_CAMERA_BUFFER 30

//UPDATE TRIGGERS, when the chunk (and the surrounding chunks) should update.
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

// DOORS
// Simply updates the visibility of the area when it opens/closes/destroyed.
/obj/machinery/door/update_nearby_tiles(need_rebuild)
	. = ..(need_rebuild)
	// Glass door glass = 1
	// don't check then?
	if(!glass && global.CTcameranet)
		global.CTcameranet.updateVisibility(src, 0)


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

// CAMERA
// An addition to deactivate which removes/adds the camera from the chunk list based on if it works or not.
/obj/machinery/camera/deactivate(user as mob, choice = 1)
	..(user, choice)
	if(src.can_use())
		global.CTcameranet.addCamera(src)
	else
		src.set_light(0)
		global.CTcameranet.removeCamera(src)

/obj/machinery/camera/initialize()
	..()
	global.CTcameranet.cameras += src //Camera must be added to global list of all cameras no matter what...
	var/list/open_networks = difflist(network, GLOBL.restricted_camera_networks) //...but if all of camera's networks are restricted, it only works for specific camera consoles.
	if(open_networks.len) //If there is at least one open network, chunk is available for AI usage.
		global.CTcameranet.addCamera(src)

/obj/machinery/camera/Destroy()
	global.CTcameranet.cameras -= src
	var/list/open_networks = difflist(network, GLOBL.restricted_camera_networks)
	if(open_networks.len)
		global.CTcameranet.removeCamera(src)
	return ..()

#undef BORG_CAMERA_BUFFER