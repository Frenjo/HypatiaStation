/datum/process/vote/setup()
	name = "vote"
	schedule_interval = 1 SECOND

	if(!global.vote)
		global.vote = new /datum/controller/vote()

/datum/process/vote/doWork()
	global.vote.process()