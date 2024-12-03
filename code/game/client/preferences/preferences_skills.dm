/*
 * Skill Preferences
 * (Skill-related preference procs.)
 */
/datum/preferences/proc/ZeroSkills(forced = 0)
	for(var/field in GLOBL.all_skills)
		for(var/path in GLOBL.all_skills[field])
			var/decl/hierarchy/skill/S = GET_DECL_INSTANCE(path)
			if(!skills.Find(S.type) || forced)
				skills[S.type] = SKILL_NONE

/datum/preferences/proc/CalculateSkillPoints()
	used_skillpoints = 0
	for(var/field in GLOBL.all_skills)
		for(var/path in GLOBL.all_skills[field])
			var/decl/hierarchy/skill/S = GET_DECL_INSTANCE(path)
			var/multiplier = 1
			switch(skills[S.type])
				if(SKILL_NONE)
					used_skillpoints += 0 * multiplier
				if(SKILL_BASIC)
					used_skillpoints += 1 * multiplier
				if(SKILL_ADEPT)
					// secondary skills cost less
					if(S.secondary)
						used_skillpoints += 1 * multiplier
					else
						used_skillpoints += 3 * multiplier
				if(SKILL_EXPERT)
					// secondary skills cost less
					if(S.secondary)
						used_skillpoints += 3 * multiplier
					else
						used_skillpoints += 6 * multiplier