/datum/process/vote
	name = "Vote"
	schedule_interval = 1 SECOND

/datum/process/vote/setup()
	if(!global.vote)
		global.vote = new /datum/controller/vote()

/datum/process/vote/doWork()
	global.vote.process()