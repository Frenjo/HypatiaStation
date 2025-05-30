/datum/round_event/portalstorm

	Announce()
		priority_announce("Subspace disruption detected around the vessel.", "Anomaly Alert")
		LongTerm()

		var/list/turfs = list(	)
		var/turf/picked

		for(var/turf/T in world)
			if(T.z < 5 && isfloorturf(T))
				turfs += T

		for(var/turf/T in world)
			if(prob(10) && T.z < 5 && isfloorturf(T))
				spawn(50+rand(0,3000))
					picked = pick(turfs)
					var/obj/portal/P = new /obj/portal( T )
					P.target = picked
					P.creator = null
					P.icon = 'icons/obj/objects.dmi'
					P.failchance = 0
					P.icon_state = "anom"
					P.name = "wormhole"
					spawn(rand(100,150))
						del(P)