/var/datum/controller/transfer_controller/transfer_controller

/datum/controller/transfer_controller
	var/timerbuffer = 0 //buffer for time check
	var/currenttick = 0

/datum/controller/transfer_controller/New()
	..()
	timerbuffer = global.config.vote_autotransfer_initial
	global.processing_objects += src

/datum/controller/transfer_controller/Destroy()
	global.processing_objects -= src
	return ..()

/datum/controller/transfer_controller/proc/process()
	currenttick = currenttick + 1
	if(world.time >= timerbuffer - 600)
		global.vote.autotransfer()
		timerbuffer = timerbuffer + global.config.vote_autotransfer_interval