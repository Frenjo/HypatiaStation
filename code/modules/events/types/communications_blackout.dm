/datum/round_event/communications_blackout
	var/static/list/possible_alerts = list(
		"Ionospheric anomalies detected. Temporary telecommunication failure imminent. Please contact you*%fj00)`5vc-BZZT",
		"Ionospheric anomalies detected. Temporary telecommunication failu*3mga;b4;'1v�-BZZZT",
		"Ionospheric anomalies detected. Temporary telec#MCi46:5.;@63-BZZZZT",
		"Ionospheric anomalies dete'fZ\\kg5_0-BZZZZZT",
		"Ionospheri:%� MCayj^j<.3-BZZZZZZT",
		"#4nd%;f4y6,>�%-BZZZZZZZT"
	)

/datum/round_event/communications_blackout/announce()
	var/alert = pick(possible_alerts)

	for_no_type_check(var/mob/living/silicon/ai/A, GLOBL.ai_list)	//AIs are always aware of communication blackouts.
		to_chat(A, "<br>")
		to_chat(A, SPAN_DANGER(alert))
		to_chat(A, "<br>")

	if(prob(30))	//most of the time, we don't want an announcement, so as to allow AIs to fake blackouts.
		priority_announce(alert)

/datum/round_event/communications_blackout/start()
	for_no_type_check(var/obj/machinery/telecoms/T, GLOBL.telecoms_list)
		T.emp_act(1)