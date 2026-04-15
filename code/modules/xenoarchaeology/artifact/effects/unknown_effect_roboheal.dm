/datum/artifact_effect/roboheal
	effecttype = "roboheal"

/datum/artifact_effect/roboheal/New()
	..()
	effect_type = pick(3, 4)

/datum/artifact_effect/roboheal/DoEffectTouch(mob/user)
	if(user)
		if(isrobot(user))
			var/mob/living/silicon/robot/R = user
			to_chat(R, SPAN_INFO("Your systems report damaged components mending by themselves!"))
			R.adjustBruteLoss(rand(-10, -30))
			R.adjustFireLoss(rand(-10, -30))
			return 1

/datum/artifact_effect/roboheal/DoEffectAura()
	if(holder)
		for(var/mob/living/silicon/robot/M in range(src.effectrange, holder))
			if(prob(10))
				to_chat(M, SPAN_INFO("SYSTEM ALERT: Beneficial energy field detected!"))
			M.adjustBruteLoss(-1)
			M.adjustFireLoss(-1)
			M.updatehealth()
		return 1

/datum/artifact_effect/roboheal/DoEffectPulse()
	if(holder)
		for(var/mob/living/silicon/robot/M in range(src.effectrange, holder))
			to_chat(M, SPAN_INFO("SYSTEM ALERT: Structural damage has been repaired by energy pulse!"))
			M.adjustBruteLoss(-10)
			M.adjustFireLoss(-10)
			M.updatehealth()
		return 1