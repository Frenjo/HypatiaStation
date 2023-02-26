/*
 * Voting Process
 */
PROCESS_DEF(vote)
	name = "Vote"
	schedule_interval = 1 SECOND

/datum/process/vote/setup()
	if(isnull(global.CTvote))
		global.CTvote = new /datum/controller/vote()

/datum/process/vote/doWork()
	global.CTvote.process()