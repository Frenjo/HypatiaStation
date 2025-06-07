/datum/round_event/rogue_drone
	start_when = 10
	end_when = 1000

	var/list/mob/living/simple/hostile/retaliate/malf_drone/drones_list = list()

/datum/round_event/rogue_drone/start()
	//spawn them at the same place as carp
	var/list/possible_spawns = list()
	for_no_type_check(var/obj/effect/landmark/C, GLOBL.landmark_list)
		if(C.name == "carpspawn")
			possible_spawns.Add(C)

	//25% chance for this to be a false alarm
	var/num
	if(prob(25))
		num = 0
	else
		num = rand(2, 6)
	for(var/i = 0, i < num, i++)
		var/mob/living/simple/hostile/retaliate/malf_drone/D = new /mob/living/simple/hostile/retaliate/malf_drone(GET_TURF(pick(possible_spawns)))
		drones_list.Add(D)
		if(prob(25))
			D.disabled = rand(15, 60)

/datum/round_event/rogue_drone/announce()
	var/msg
	if(prob(33))
		msg = "A combat drone wing operating out of the NMV Icarus has failed to return from a sweep of this sector, if any are sighted approach with caution."
	else if(prob(50))
		msg = "Contact has been lost with a combat drone wing operating out of the NMV Icarus. If any are sighted in the area, approach with caution."
	else
		msg = "Unidentified hackers have targetted a combat drone wing deployed from the NMV Icarus. If any are sighted in the area, approach with caution."
	priority_announce(msg, "Rogue Drone Alert")

/datum/round_event/rogue_drone/tick()
	return

/datum/round_event/rogue_drone/end()
	var/num_recovered = 0
	for_no_type_check(var/mob/living/simple/hostile/retaliate/malf_drone/D, drones_list)
		make_sparks(3, FALSE, D.loc)
		D.z = GLOBL.current_map.admin_levels[1]
		D.has_loot = 0

		qdel(D)
		num_recovered++

	if(num_recovered > length(drones_list) * 0.75)
		priority_announce("Icarus drone control reports the malfunctioning wing has been recovered safely.", "Rogue Drone Alert")
	else
		priority_announce(
			"Icarus drone control registers disappointment at the loss of the drones, but the survivors have been recovered.",
			"Rogue Drone Alert"
		)