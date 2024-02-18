// CAMERA
// An addition to deactivate which removes/adds the camera from the chunk list based on if it works or not.
/obj/machinery/camera/deactivate(user as mob, choice = 1)
	..(user, choice)
	if(can_use())
		global.CTcameranet.addCamera(src)
	else
		set_light(0)
		global.CTcameranet.removeCamera(src)

/obj/machinery/camera/initialise()
	. = ..()
	global.CTcameranet.cameras += src //Camera must be added to global list of all cameras no matter what...
	var/list/open_networks = difflist(network, GLOBL.restricted_camera_networks) //...but if all of camera's networks are restricted, it only works for specific camera consoles.
	if(length(open_networks)) //If there is at least one open network, chunk is available for AI usage.
		global.CTcameranet.addCamera(src)

/obj/machinery/camera/Destroy()
	global.CTcameranet.cameras -= src
	var/list/open_networks = difflist(network, GLOBL.restricted_camera_networks)
	if(length(open_networks))
		global.CTcameranet.removeCamera(src)
	return ..()