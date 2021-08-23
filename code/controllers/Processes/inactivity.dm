#define INACTIVITY_KICK	6000	//10 minutes in ticks (approx.)
/datum/controller/process/inactivity/setup()
	name = "inactivity"
	schedule_interval = INACTIVITY_KICK

/datum/controller/process/inactivity/doWork()
	if(config.kick_inactive)
		for(var/client/C in clients)
			if(C.is_afk(INACTIVITY_KICK))
				if(!istype(C.mob, /mob/dead))
					log_access("AFK: [key_name(C)]")
					to_chat(C, SPAN_WARNING("You have been inactive for more than 10 minutes and have been disconnected."))
					qdel(C)

			SCHECK

#undef INACTIVITY_KICK