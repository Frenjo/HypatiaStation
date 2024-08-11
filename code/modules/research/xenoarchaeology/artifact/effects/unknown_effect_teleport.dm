/datum/artifact_effect/teleport
	effecttype = "teleport"
	effect_type = 6

/datum/artifact_effect/teleport/DoEffectTouch(mob/user)
	var/weakness = GetAnomalySusceptibility(user)
	if(prob(100 * weakness))
		var/list/randomturfs = list()
		for(var/turf/open/floor/T in orange(user, 50))
			randomturfs.Add(T)
		if(length(randomturfs))
			to_chat(user, SPAN_WARNING("You are suddenly zapped away elsewhere!"))
			if(user.buckled)
				user.buckled.unbuckle()

			make_sparks(3, FALSE, get_turf(user))
			user.loc = pick(randomturfs)
			make_sparks(3, FALSE, get_turf(user))

/datum/artifact_effect/teleport/DoEffectAura()
	if(holder)
		for(var/mob/living/M in range(src.effectrange, holder))
			var/weakness = GetAnomalySusceptibility(M)
			if(prob(100 * weakness))
				var/list/randomturfs = list()
				for(var/turf/open/floor/T in orange(M, 30))
					randomturfs.Add(T)
				if(length(randomturfs))
					to_chat(M, SPAN_WARNING("You are displaced by a strange force!"))
					if(M.buckled)
						M.buckled.unbuckle()

					make_sparks(3, FALSE, get_turf(M))
					M.loc = pick(randomturfs)
					make_sparks(3, FALSE, get_turf(M))

/datum/artifact_effect/teleport/DoEffectPulse()
	if(holder)
		for(var/mob/living/M in range(src.effectrange, holder))
			var/weakness = GetAnomalySusceptibility(M)
			if(prob(100 * weakness))
				var/list/randomturfs = list()
				for(var/turf/open/floor/T in orange(M, 15))
					randomturfs.Add(T)
				if(length(randomturfs))
					to_chat(M, SPAN_WARNING("You are displaced by a strange force!"))

					make_sparks(3, FALSE, get_turf(M))
					if(M.buckled)
						M.buckled.unbuckle()
					M.loc = pick(randomturfs)
					make_sparks(3, FALSE, get_turf(M))