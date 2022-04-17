/datum/controller/process/vote/setup()
	name = "vote"
	schedule_interval = 1 SECOND

/datum/controller/process/vote/doWork()
	global.vote.process()