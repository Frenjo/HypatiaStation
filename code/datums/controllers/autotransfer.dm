/var/global/datum/controller/transfer/transfer_controller // Set in /datum/controller/master/setup()

/datum/controller/transfer
	name = "Transfer"

	var/timerbuffer = 0 //buffer for time check
	var/currenttick = 0

/datum/controller/transfer/New()
	..()
	timerbuffer = global.config.vote_autotransfer_initial
	global.processing_objects += src

/datum/controller/transfer/Destroy()
	global.processing_objects -= src
	return ..()

/datum/controller/transfer/process()
	currenttick = currenttick + 1
	if(world.time >= timerbuffer - 600)
		global.vote.autotransfer()
		timerbuffer = timerbuffer + global.config.vote_autotransfer_interval