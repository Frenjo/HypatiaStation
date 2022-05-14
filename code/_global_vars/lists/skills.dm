/var/global/list/all_skills = list()
/var/global/list/skill_presets = list(
	"Engineer" = global.skills_engineer,
	"Roboticist" = global.skills_roboticist,
	"Security Officer" = global.skills_security_officer,
	"Chemist" = global.skills_chemist
)

// Skill preset lists.
/var/global/list/skills_engineer = list(
	"field" = "Engineering",
	"EVA" = SKILL_BASIC,
	"construction" = SKILL_ADEPT,
	"electrical" = SKILL_BASIC,
	"engines" = SKILL_ADEPT
)
/var/global/list/skills_roboticist = list(
	"field" = "Science",
	"devices" = SKILL_ADEPT,
	"electrical" = SKILL_BASIC,
	"computer" = SKILL_ADEPT,
	"anatomy" = SKILL_BASIC
)
/var/global/list/skills_security_officer = list(
	"field" = "Security",
	"combat" = SKILL_BASIC,
	"weapons" = SKILL_ADEPT,
	"law" = SKILL_ADEPT,
	"forensics" = SKILL_BASIC
)
/var/global/list/skills_chemist = list(
	"field" = "Science",
	"chemistry" = SKILL_ADEPT,
	"science" = SKILL_ADEPT,
	"medical" = SKILL_BASIC,
	"devices" = SKILL_BASIC
)