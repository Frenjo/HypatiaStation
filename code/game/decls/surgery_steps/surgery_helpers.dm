/proc/spread_germs_to_organ(datum/organ/external/E, mob/living/carbon/human/user)
	if(!istype(user) || !istype(E))
		return

	var/germ_level = user.germ_level
	if(user.gloves)
		germ_level = user.gloves.germ_level

	E.germ_level = max(germ_level, E.germ_level) //as funny as scrubbing microbes out with clean gloves is - no.

/proc/do_surgery(mob/living/M, mob/living/user, obj/item/tool)
	if(!iscarbon(M))
		return 0
	if(user.a_intent == "harm")	//check for Hippocratic Oath
		return 0
	for_no_type_check(var/decl/surgery_step/S, GLOBL.surgery_steps)
		//check if tool is right or close enough and if this step is possible
		if(S.tool_quality(tool) && S.can_use(user, M, user.zone_sel.selecting, tool) && S.is_valid_mutantrace(M))
			S.begin_step(user, M, user.zone_sel.selecting, tool)		//start on it
			//We had proper tools! (or RNG smiled.) and User did not move or change hands.
			if(prob(S.tool_quality(tool)) &&  do_mob(user, M, rand(S.min_duration, S.max_duration)))
				S.end_step(user, M, user.zone_sel.selecting, tool)		//finish successfully
			else														//or
				S.fail_step(user, M, user.zone_sel.selecting, tool)		//malpractice~
			return	1	  												//don't want to do weapony things after surgery
	return 0

/proc/sort_surgeries()
	var/gap = length(GLOBL.surgery_steps)
	var/swapped = 1
	while(gap > 1 || swapped)
		swapped = 0
		if(gap > 1)
			gap = round(gap / 1.247330950103979)
		if(gap < 1)
			gap = 1
		for(var/i = 1; gap + i <= length(GLOBL.surgery_steps); i++)
			var/decl/surgery_step/l = GLOBL.surgery_steps[i]		//Fucking hate
			var/decl/surgery_step/r = GLOBL.surgery_steps[gap + i]	//how lists work here
			if(l.priority < r.priority)
				GLOBL.surgery_steps.Swap(i, gap + i)
				swapped = 1

/datum/surgery_status
	var/eyes	=	0
	var/face	=	0
	var/appendix =	0
	var/ribcage =	0