GLOBAL_GLOBL_ALIST_NEW(all_skills)
GLOBAL_GLOBL_ALIST_INIT(skill_presets, alist(
	"Engineer" = GLOBL.skills_engineer,
	"Roboticist" = GLOBL.skills_roboticist,
	"Security Officer" = GLOBL.skills_security_officer,
	"Chemist" = GLOBL.skills_chemist
))

// Skill Presets
GLOBAL_GLOBL_ALIST_INIT(skills_engineer, alist(
	"field" = "Engineering",
	"EVA" = SKILL_BASIC,
	"construction" = SKILL_ADEPT,
	"electrical" = SKILL_BASIC,
	"engines" = SKILL_ADEPT
))
GLOBAL_GLOBL_ALIST_INIT(skills_roboticist, alist(
	"field" = "Science",
	"devices" = SKILL_ADEPT,
	"electrical" = SKILL_BASIC,
	"computer" = SKILL_ADEPT,
	"anatomy" = SKILL_BASIC
))
GLOBAL_GLOBL_ALIST_INIT(skills_security_officer, alist(
	"field" = "Security",
	"combat" = SKILL_BASIC,
	"weapons" = SKILL_ADEPT,
	"law" = SKILL_ADEPT,
	"forensics" = SKILL_BASIC
))
GLOBAL_GLOBL_ALIST_INIT(skills_chemist, alist(
	"field" = "Science",
	"chemistry" = SKILL_ADEPT,
	"science" = SKILL_ADEPT,
	"medical" = SKILL_BASIC,
	"devices" = SKILL_BASIC
))