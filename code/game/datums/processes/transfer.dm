/*
 * Transfer Process
 */
/datum/process/transfer
	name = "Transfer"
	schedule_interval = 2 SECONDS

/datum/process/transfer/doWork()
	global.transfer_controller.process()