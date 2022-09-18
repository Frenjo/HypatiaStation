#define INACTIVITY_KICK	(10 MINUTES)	//10 minutes in ticks (approx.)
/datum/process/inactivity/setup()
	name = "inactivity"
	schedule_interval = INACTIVITY_KICK

/datum/process/inactivity/doWork()
	if(config.kick_inactive)
		for(var/client/C in global.clients)
			if(C.is_afk(INACTIVITY_KICK))
				if(!istype(C.mob, /mob/dead))
					log_access("AFK: [key_name(C)]")
					to_chat(C, SPAN_WARNING("You have been inactive for more than 10 minutes and have been disconnected."))
					qdel(C)

			SCHECK
#undef INACTIVITY_KICK