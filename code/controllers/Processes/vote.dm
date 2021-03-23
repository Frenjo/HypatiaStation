/datum/controller/process/vote/setup()
	name = "vote"
	schedule_interval = 10 // every 1 second

/datum/controller/process/vote/doWork()
	vote.process()