GLOBAL_GLOBL_LIST_NEW(events)

/datum/process/event
	name = "Event"
	schedule_interval = 2 SECONDS

/datum/process/event/doWork()
	var/i = 1
	while(i <= GLOBL.events.len)
		var/datum/event/Event = GLOBL.events[i]
		if(Event)
			Event.process()
			i++
			continue
		GLOBL.events.Cut(i, i + 1)
	checkEvent()