/*
 * Transfer Process
 */
PROCESS_DEF(transfer)
	name = "Transfer"
	schedule_interval = 2 SECONDS

	var/timerbuffer = 0 // Buffer for time check.
	var/currenttick = 0

/datum/process/transfer/setup()
	timerbuffer = CONFIG_GET(/decl/configuration_entry/vote_autotransfer_initial)

/datum/process/transfer/do_work()
	currenttick++
	if(world.time >= timerbuffer - (1 MINUTE))
		global.PCvote.autotransfer()
		timerbuffer = timerbuffer + CONFIG_GET(/decl/configuration_entry/vote_autotransfer_interval)