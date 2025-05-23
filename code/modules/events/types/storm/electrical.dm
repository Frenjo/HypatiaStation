/datum/round_event/storm/electrical
	startWhen = 1
	endWhen = 1

	var/lightsoutAmount = 1
	var/lightsoutRange = 25

	var/list/epicentres = list()
	var/list/possible_epicentres = list()

/datum/round_event/storm/electrical/setup()
	for_no_type_check(var/obj/effect/landmark/new_epicentre, GLOBL.landmark_list)
		if(new_epicentre.name == "lightsout" && !(new_epicentre in epicentres))
			possible_epicentres.Add(new_epicentre)

/datum/round_event/storm/electrical/announce()
	command_alert("An electrical storm has been detected in your area, please repair potential electronic overloads.", "Electrical Storm Alert")

/datum/round_event/storm/electrical/start()
	if(!length(epicentres))
		return

	for_no_type_check(var/obj/effect/landmark/epicentre, epicentres)
		for(var/obj/machinery/power/apc/apc in range(epicentre, lightsoutRange))
			apc.overload_lighting()