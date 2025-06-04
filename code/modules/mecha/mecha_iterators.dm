//////////////////////////////////////////
////////  Mecha global iterators  ////////
//////////////////////////////////////////
// Handles inertial movement in space.
/datum/global_iterator/mecha_inertial_movement
	delay = 0.7 SECONDS

/datum/global_iterator/mecha_inertial_movement/process(obj/mecha/mecha, direction)
	if(direction)
		if(!step(mecha, direction) || mecha.check_for_support())
			stop()
	else
		stop()