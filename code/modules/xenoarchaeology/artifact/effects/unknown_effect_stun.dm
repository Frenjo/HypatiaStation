/datum/artifact_effect/stun
	effecttype = "stun"

/datum/artifact_effect/stun/New()
	..()
	effect_type = pick(2, 5)

/datum/artifact_effect/stun/DoEffectTouch(mob/toucher)
	if(toucher && iscarbon(toucher))
		var/mob/living/carbon/C = toucher
		var/weakness = GetAnomalySusceptibility(C)
		if(prob(weakness * 100))
			to_chat(C, SPAN_WARNING("A powerful force overwhelms your consciousness."))
			C.weakened += 45 * weakness
			C.stuttering += 45 * weakness
			C.stunned += rand(1,10) * weakness

/datum/artifact_effect/stun/DoEffectAura()
	if(holder)
		for(var/mob/living/carbon/C in range(src.effectrange, holder))
			var/weakness = GetAnomalySusceptibility(C)
			if(prob(10 * weakness))
				to_chat(C, SPAN_WARNING("Your body goes numb for a moment."))
				C.weakened += 2
				C.stuttering += 2
				if(prob(10))
					C.stunned += 1
			else if(prob(10))
				to_chat(C, SPAN_WARNING("You feel numb."))

/datum/artifact_effect/stun/DoEffectPulse()
	if(holder)
		for(var/mob/living/carbon/C in range(src.effectrange, holder))
			var/weakness = GetAnomalySusceptibility(C)
			if(prob(100 * weakness))
				to_chat(C, SPAN_WARNING("A wave of energy overwhelms your senses!"))
				C.weakened += 4 * weakness
				C.stuttering += 4 * weakness
				if(prob(10))
					C.stunned += 1 * weakness