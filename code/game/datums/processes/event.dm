/*
 * Events Process
 */
PROCESS_DEF(event)
	name = "Event"
	schedule_interval = 2 SECONDS

	var/static/list/all_events = SUBTYPESOF(/datum/round_event)

	var/static/list/datum/round_event/processing_list = list()

	var/static/event_time_lower = 20 MINUTES
	var/static/event_time_upper = 40 MINUTES
	var/static/scheduled_event = null

/datum/process/event/do_work()
	var/i = 1
	while(i <= length(processing_list))
		var/datum/round_event/event = processing_list[i]
		if(isnotnull(event))
			event.process()
			i++
			continue
		processing_list.Cut(i, i + 1)
	check_event()

/datum/process/event/proc/check_event()
	if(!scheduled_event)
		//more players = more time between events, less players = less time between events
		var/playercount_modifier = 1
		switch(length(GLOBL.player_list))
			if(0 to 10)
				playercount_modifier = 1.2
			if(11 to 15)
				playercount_modifier = 1.1
			if(16 to 25)
				playercount_modifier = 1
			if(26 to 35)
				playercount_modifier = 0.9
			if(36 to 100000)
				playercount_modifier = 0.8
		var/next_event_delay = rand(event_time_lower, event_time_upper) * playercount_modifier
		scheduled_event = world.timeofday + next_event_delay
		log_debug("Next event in [next_event_delay/600] minutes.")

	else if(world.timeofday > scheduled_event)
		spawn_dynamic_event()

		scheduled_event = null
		.()

/client/proc/forceEvent(type in global.PCevent.all_events)
	set category = PANEL_DEBUG
	set name = "Trigger Event (Debug Only)"

	if(!holder)
		return

	if(ispath(type))
		new type
		message_admins("[key_name_admin(usr)] has triggered an event. ([type])", 1)