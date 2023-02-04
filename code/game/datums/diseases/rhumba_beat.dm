/datum/disease/rhumba_beat
	name = "The Rhumba Beat"
	max_stages = 5
	spread = "On contact"
	spread_type = CONTACT_GENERAL
	cure = "Chick Chicky Boom!"
	cure_id = list("plasma")
	agent = "Unknown"
	affected_species = list(SPECIES_HUMAN)
	permeability_mod = 1

/datum/disease/rhumba_beat/stage_act()
	..()
	// Moving this here instead of checking on every single stage should work, right?
	// As a sidenote, what the fuck is this for, anyway? -Frenjo
	if(affected_mob.ckey == "rosham")
		src.cure()

	switch(stage)
		if(1)
			// Nothing happens here.
		if(2)
			if(prob(45))
				affected_mob.adjustToxLoss(5)
				affected_mob.updatehealth()
			if(prob(1))
				to_chat(affected_mob, SPAN_WARNING("You feel strange..."))
		if(3)
			if(prob(5))
				to_chat(affected_mob, SPAN_WARNING("You feel the urge to dance..."))
			else if(prob(5))
				affected_mob.emote("gasp")
			else if(prob(10))
				to_chat(affected_mob, SPAN_WARNING("You feel the need to chick chicky boom..."))
		if(4)
			if(prob(10))
				affected_mob.emote("gasp")
				to_chat(affected_mob, SPAN_WARNING("You feel a burning beat inside..."))
			if(prob(20))
				affected_mob.adjustToxLoss(5)
				affected_mob.updatehealth()
		if(5)
			to_chat(affected_mob, SPAN_WARNING("Your body is unable to contain the Rhumba Beat..."))
			if(prob(50))
				affected_mob.gib()
		else
			return