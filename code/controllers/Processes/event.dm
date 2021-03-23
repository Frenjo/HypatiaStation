/datum/controller/process/event/setup()
	name = "event"
	schedule_interval = 20 // every 2 seconds

/datum/controller/process/event/doWork()
	var/i = 1
	while(i <= events.len)
		var/datum/event/Event = events[i]
		if(Event)
			Event.process()
			i++
			continue
		events.Cut(i, i + 1)
	checkEvent()