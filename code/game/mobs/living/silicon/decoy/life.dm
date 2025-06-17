/mob/living/silicon/decoy/Life()
	if(stat == DEAD)
		return
	else
		if(health <= CONFIG_GET(/decl/configuration_entry/health_threshold_dead) && src.stat != DEAD)
			death()
			return

/mob/living/silicon/decoy/updatehealth()
	if(status_flags & GODMODE)
		health = maxHealth
		stat = CONSCIOUS
	else
		health = maxHealth - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()