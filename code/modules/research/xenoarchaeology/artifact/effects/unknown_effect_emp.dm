/datum/artifact_effect/emp
	effecttype = "emp"
	effect_type = 3

/datum/artifact_effect/emp/New()
	..()
	effect = EFFECT_PULSE

/datum/artifact_effect/emp/DoEffectPulse()
	if(holder)
		empulse(GET_TURF(holder), effectrange / 2, effectrange)
		return 1