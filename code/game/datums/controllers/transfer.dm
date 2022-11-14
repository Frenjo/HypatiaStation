/*
 * Transfer Controller
 */
/hook/roundstart/proc/create_transfer_controller()
	global.CTtransfer = new /datum/controller/transfer()
	return 1

CONTROLLER_DEF(transfer)
	name = "Transfer"

	var/timerbuffer = 0 //buffer for time check
	var/currenttick = 0

/datum/controller/transfer/New()
	..()
	timerbuffer = CONFIG_GET(vote_autotransfer_initial)

/datum/controller/transfer/process()
	currenttick++
	if(world.time >= timerbuffer - 600)
		global.CTvote.autotransfer()
		timerbuffer = timerbuffer + CONFIG_GET(vote_autotransfer_interval)