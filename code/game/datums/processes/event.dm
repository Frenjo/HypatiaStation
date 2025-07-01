/*
 * Events Process
 */
PROCESS_DEF(event)
	name = "Event"
	schedule_interval = 2 SECONDS

	var/static/list/datum/round_event/processing_list = list()

/datum/process/event/do_work()
	var/i = 1
	while(i <= length(processing_list))
		var/datum/round_event/event = processing_list[i]
		if(isnotnull(event))
			event.process()
			i++
			continue
		processing_list.Cut(i, i + 1)
	checkEvent()