GLOBAL_GLOBL_INIT(sent_spiders_to_station, FALSE)

/datum/round_event/spider_infestation
	announce_when = 400
	one_shot = TRUE

	var/spawncount = 1

/datum/round_event/spider_infestation/setup()
	announce_when = rand(announce_when, announce_when + 50)
	spawncount = rand(8, 12)	//spiderlings only have a 50% chance to grow big and strong
	GLOBL.sent_spiders_to_station = TRUE

/datum/round_event/spider_infestation/announce()
	priority_announce(
		"Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.",
		"Lifesign Alert", 'sound/AI/aliens.ogg'
	)

/datum/round_event/spider_infestation/start()
	var/list/vents = list()
	FOR_MACHINES_SUBTYPED(temp_vent, /obj/machinery/atmospherics/unary/vent_pump)
		if(!temp_vent.welded && temp_vent.network && isstationlevel(temp_vent.loc.z))
			if(length(temp_vent.network.normal_members) > 50)
				vents.Add(temp_vent)

	while(spawncount >= 1 && length(vents))
		var/obj/vent = pick(vents)
		new /obj/effect/spider/spiderling(vent.loc)
		vents -= vent
		spawncount--