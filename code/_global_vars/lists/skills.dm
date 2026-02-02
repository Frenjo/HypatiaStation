GLOBAL_GLOBL_ALIST_NEW(all_skills)

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