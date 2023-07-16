// Alien larva are quite simple.
/mob/living/carbon/alien/Life()
	set background = BACKGROUND_ENABLED

	. = ..()
	if(stat != DEAD) //still breathing
		// GROW!
		update_progression()

		// Chemicals in the body
		handle_chemicals_in_body()

	blinded = null

	//Status updates, death etc.
	handle_regular_status_updates()
	update_canmove()
	update_icons()

	if(isnotnull(client))
		handle_regular_hud_updates()

/mob/living/carbon/alien/handle_mutations_and_radiation()
	// Currently both Dionaea and larvae like to eat radiation, so I'm defining the
	// rad absorbtion here. This will need to be changed if other baby aliens are added.
	if(!radiation)
		return

	var/rads = radiation / 25
	radiation -= rads
	nutrition += rads
	heal_overall_damage(rads, rads)
	adjustOxyLoss(-rads)
	adjustToxLoss(-rads)
	return

/mob/living/carbon/alien/handle_environment(datum/gas_mixture/enviroment)
	//TODO: Work out if larvae breathe/suffer from pressure/suffer from heat.
	if(isnull(enviroment))
		return

/mob/living/carbon/alien/proc/handle_chemicals_in_body()
	return // Nothing yet. Maybe check it out at a later date.

/mob/living/carbon/alien/proc/handle_regular_status_updates()
	// TODO: sleep, blind, stunned, paralyzed?
	return

/mob/living/carbon/alien/proc/handle_regular_hud_updates()
	return //TODO: Not sure what to do with this yet.