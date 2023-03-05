/proc/communications_blackout(silent = 1)
	if(!silent)
		command_alert("Ionospheric anomalies detected. Temporary telecommunication failure imminent. Please contact you-BZZT")
	else // AIs will always know if there's a comm blackout, rogue AIs could then lie about comm blackouts in the future while they shutdown comms
		for(var/mob/living/silicon/ai/A in GLOBL.player_list)
			A << "<br>"
			A << "<span class='warning'><b>Ionospheric anomalies detected. Temporary telecommunication failure imminent. Please contact you-BZZT<b></span>"
			A << "<br>"
	for(var/obj/machinery/telecoms/T in telecoms_list)
		T.emp_act(1)