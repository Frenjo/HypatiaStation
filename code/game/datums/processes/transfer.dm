/*
 * Transfer Process
 */
PROCESS_DEF(transfer)
	name = "Transfer"
	schedule_interval = 2 SECONDS

/datum/process/transfer/do_work()
	global.CTtransfer.process()