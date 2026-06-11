// Initialisation procs.
/mob/living/proc/mind_initialize()
	if(isnotnull(mind))
		mind.key = key
	else
		mind = new /datum/mind(key)
		mind.original = src
		if(isnotnull(global.PCticker))
			global.PCticker.minds.Add(mind)
		else
			TO_WORLD_LOG("## DEBUG: mind_initialize(): No ticker ready yet! Please inform Carn")
	if(isnull(mind.name))
		mind.name = real_name
	mind.current = src

// Xeno Larva
/mob/living/carbon/alien/larva/mind_initialize()
	. = ..()
	mind.assign_special_role(SPECIAL_ROLE_LARVA)

/mob/living/simple/construct/builder/mind_initialize()
	. = ..()
	mind.assign_special_role(SPECIAL_ROLE_CULTIST)

/mob/living/simple/construct/wraith/mind_initialize()
	. = ..()
	mind.assign_special_role(SPECIAL_ROLE_CULTIST)

/mob/living/simple/construct/armoured/mind_initialize()
	. = ..()
	mind.assign_special_role(SPECIAL_ROLE_CULTIST)

/mob/living/simple/vox/armalis/mind_initialize()
	. = ..()
	mind.assign_special_role(SPECIAL_ROLE_VOX_RAIDER)