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
			world.log << "## DEBUG: mind_initialize(): No ticker ready yet! Please inform Carn"
	if(isnull(mind.name))
		mind.name = real_name
	mind.current = src

// Human
/mob/living/carbon/human/mind_initialize()
	. = ..()
	if(isnull(mind.assigned_role))
		mind.assigned_role = "Assistant"	// Default.

// Monkey
/mob/living/carbon/monkey/mind_initialize()
	. = ..()

// Slime
/mob/living/carbon/slime/mind_initialize()
	. = ..()
	mind.assigned_role = "slime"

// Xeno Larva
/mob/living/carbon/alien/larva/mind_initialize()
	. = ..()
	mind.special_role = "Larva"

// AI
/mob/living/silicon/ai/mind_initialize()
	. = ..()
	mind.assigned_role = "AI"

// Cyborg
/mob/living/silicon/robot/mind_initialize()
	. = ..()
	mind.assigned_role = "Cyborg"

// pAI
/mob/living/silicon/pai/mind_initialize()
	. = ..()
	mind.assigned_role = "pAI"
	mind.special_role = ""

// Animals
/mob/living/simple/mind_initialize()
	. = ..()
	mind.assigned_role = "Animal"

/mob/living/simple/corgi/mind_initialize()
	. = ..()
	mind.assigned_role = "Corgi"

/mob/living/simple/shade/mind_initialize()
	. = ..()
	mind.assigned_role = "Shade"

/mob/living/simple/construct/builder/mind_initialize()
	. = ..()
	mind.assigned_role = "Artificer"
	mind.special_role = "Cultist"

/mob/living/simple/construct/wraith/mind_initialize()
	. = ..()
	mind.assigned_role = "Wraith"
	mind.special_role = "Cultist"

/mob/living/simple/construct/armoured/mind_initialize()
	. = ..()
	mind.assigned_role = "Juggernaut"
	mind.special_role = "Cultist"

/mob/living/simple/vox/armalis/mind_initialize()
	. = ..()
	mind.assigned_role = "Armalis"
	mind.special_role = "Vox Raider"