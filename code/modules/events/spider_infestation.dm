GLOBAL_GLOBL_INIT(sent_spiders_to_station, FALSE)

/datum/event/spider_infestation
	announceWhen = 400
	oneShot = TRUE

	var/spawncount = 1

/datum/event/spider_infestation/setup()
	announceWhen = rand(announceWhen, announceWhen + 50)
	spawncount = rand(8, 12)	//spiderlings only have a 50% chance to grow big and strong
	GLOBL.sent_spiders_to_station = TRUE

/datum/event/spider_infestation/announce()
	command_alert("Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert")
	world << sound('sound/AI/aliens.ogg')

/datum/event/spider_infestation/start()
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in GLOBL.machines)
		if(!temp_vent.welded && temp_vent.network && isstationlevel(temp_vent.loc.z))
			if(length(temp_vent.network.normal_members) > 50)
				vents.Add(temp_vent)

	while(spawncount >= 1 && length(vents))
		var/obj/vent = pick(vents)
		new /obj/effect/spider/spiderling(vent.loc)
		vents -= vent
		spawncount--