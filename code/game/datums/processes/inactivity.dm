#define INACTIVITY_KICK	(10 MINUTES)
/datum/process/inactivity
	name = "Inactivity"
	schedule_interval = INACTIVITY_KICK

/datum/process/inactivity/doWork()
	if(CONFIG_GET(kick_inactive))
		for(var/client/C in GLOBL.clients)
			if(C.is_afk(INACTIVITY_KICK))
				if(!istype(C.mob, /mob/dead))
					log_access("AFK: [key_name(C)]")
					to_chat(C, SPAN_WARNING("You have been inactive for more than 10 minutes and have been disconnected."))
					qdel(C)

			SCHECK
#undef INACTIVITY_KICK