/var/global/list/events = list()

/datum/process/event/setup()
	name = "event"
	schedule_interval = 2 SECONDS

/datum/process/event/doWork()
	var/i = 1
	while(i <= global.events.len)
		var/datum/event/Event = global.events[i]
		if(Event)
			Event.process()
			i++
			continue
		global.events.Cut(i, i + 1)
	checkEvent()