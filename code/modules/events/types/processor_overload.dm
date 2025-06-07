/datum/round_event/processor_overload
	announceWhen = 1

	var/static/list/possible_alerts = list(
		"Exospheric bubble inbound. Processor overload is likely. Please contact you*%xp25)`6cq-BZZT",
		"Exospheric bubble inbound. Processor overload is likel*1eta;c5;'1v¬-BZZZT",
		"Exospheric bubble inbound. Processor ov#MCi46:5.;@63-BZZZZT",
		"Exospheric bubble inbo'Fz\\k55_@-BZZZZZT",
		"Exospheri:%£ QCbyj^j</.3-BZZZZZZT",
		"!!hy%;f3l7e,<$^-BZZZZZZZT"
	)

/datum/round_event/processor_overload/announce()
	var/alert = pick(possible_alerts)

	for_no_type_check(var/mob/living/silicon/ai/A, GLOBL.ai_list) // AIs are always aware of processor overloads.
		to_chat(A, "<br>")
		to_chat(A, SPAN_DANGER(alert))
		to_chat(A, "<br>")

	if(prob(80)) // Most of the time we want an announcement, but there's a little gap for shenanigans.
		priority_announce(alert)

/datum/round_event/processor_overload/start()
	for(var/obj/machinery/telecoms/processor/machine in GLOBL.telecoms_list)
		if(!prob(10))
			machine.emp_act(2)