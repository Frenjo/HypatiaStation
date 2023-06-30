/*
 * Events Process
 */
GLOBAL_GLOBL_LIST_NEW(events)

PROCESS_DEF(event)
	name = "Event"
	schedule_interval = 2 SECONDS

/datum/process/event/doWork()
	var/i = 1
	while(i <= length(GLOBL.events))
		var/datum/event/event = GLOBL.events[i]
		if(isnotnull(event))
			event.process()
			i++
			continue
		GLOBL.events.Cut(i, i + 1)
	checkEvent()