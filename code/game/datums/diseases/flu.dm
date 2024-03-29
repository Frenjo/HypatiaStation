/datum/disease/flu
	name = "The Flu"
	max_stages = 3
	spread = "Airborne"
	cure = "Spaceacillin"
	cure_id = "spaceacillin"
	cure_chance = 10
	agent = "H13N1 flu virion"
	affected_species = list(SPECIES_HUMAN, "Monkey")
	permeability_mod = 0.75
	desc = "If left untreated the subject will feel quite unwell."
	severity = "Medium"

/datum/disease/flu/stage_act()
	..()
	switch(stage)
		if(2)
/*
			if(affected_mob.sleeping && prob(20))  //removed until sleeping is fixed --Blaank
				FEEDBACK_YOU_FEEL_BETTER(affected_mob)
				stage--
				return
*/
			if(affected_mob.lying && prob(20))  //added until sleeping is fixed --Blaank
				FEEDBACK_YOU_FEEL_BETTER(affected_mob)
				stage--
				return
			if(prob(1))
				affected_mob.emote("sneeze")
			if(prob(1))
				affected_mob.emote("cough")
			if(prob(1))
				to_chat(affected_mob, SPAN_WARNING("Your muscles ache."))
				if(prob(20))
					affected_mob.take_organ_damage(1)
			if(prob(1))
				to_chat(affected_mob, SPAN_WARNING("Your stomach hurts."))
				if(prob(20))
					affected_mob.adjustToxLoss(1)
					affected_mob.updatehealth()

		if(3)
/*
			if(affected_mob.sleeping && prob(15))  //removed until sleeping is fixed
				FEEDBACK_YOU_FEEL_BETTER(affected_mob)
				stage--
				return
*/
			if(affected_mob.lying && prob(15))  //added until sleeping is fixed
				FEEDBACK_YOU_FEEL_BETTER(affected_mob)
				stage--
				return
			if(prob(1))
				affected_mob.emote("sneeze")
			if(prob(1))
				affected_mob.emote("cough")
			if(prob(1))
				to_chat(affected_mob, SPAN_WARNING("Your muscles ache."))
				if(prob(20))
					affected_mob.take_organ_damage(1)
			if(prob(1))
				to_chat(affected_mob, SPAN_WARNING("Your stomach hurts."))
				if(prob(20))
					affected_mob.adjustToxLoss(1)
					affected_mob.updatehealth()
	return
