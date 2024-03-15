/*
 * Chief Engineer
 */
/datum/job/chief_engineer
	title = "Chief Engineer"
	flag = JOB_CHIEF
	department_flag = DEPARTMENT_ENGSEC

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Captain"
	selection_color = "#ffeeaa"

	req_admin_notify = TRUE
	minimal_player_age = 7

	access = list(
		ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS,
		ACCESS_TELEPORTER, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_ATMOSPHERICS, ACCESS_EMERGENCY_STORAGE, ACCESS_EVA,
		ACCESS_BRIDGE, ACCESS_CONSTRUCTION, ACCESS_SEC_DOORS,
		ACCESS_CE, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_TCOMSAT, ACCESS_AI_UPLOAD
	)
	minimal_access = list(
		ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS,
		ACCESS_TELEPORTER, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_ATMOSPHERICS, ACCESS_EMERGENCY_STORAGE, ACCESS_EVA,
		ACCESS_BRIDGE, ACCESS_CONSTRUCTION, ACCESS_SEC_DOORS,
		ACCESS_CE, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_TCOMSAT, ACCESS_AI_UPLOAD
	)

	outfit = /decl/hierarchy/outfit/job/engineering/chief

	special_survival_kit = /obj/item/storage/box/survival/engineer

/*
 * Station Engineer
 */
/datum/job/engineer
	title = "Station Engineer"
	flag = JOB_ENGINEER
	department_flag = DEPARTMENT_ENGSEC

	total_positions = 5
	spawn_positions = 5

	supervisors = "the Chief Engineer"
	selection_color = "#fff5cc"

	access = list(
		ACCESS_EVA, ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE,
		ACCESS_MAINT_TUNNELS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CONSTRUCTION, ACCESS_ATMOSPHERICS
	)
	minimal_access = list(
		ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE, ACCESS_MAINT_TUNNELS,
		ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CONSTRUCTION
	)

	outfit = /decl/hierarchy/outfit/job/engineering/engineer
	alt_titles = list("Maintenance Technician", "Engine Technician", "Electrician")

	special_survival_kit = /obj/item/storage/box/survival/engineer

/*
 * Atmospheric Technician
 */
/datum/job/atmos
	title = "Atmospheric Technician"
	flag = JOB_ATMOSTECH
	department_flag = DEPARTMENT_ENGSEC

	total_positions = 3
	spawn_positions = 2

	supervisors = "the Chief Engineer"
	selection_color = "#fff5cc"

	access = list(
		ACCESS_EVA, ACCESS_ENGINE, ACCESS_ENGINE_EQUIP, ACCESS_TECH_STORAGE,
		ACCESS_MAINT_TUNNELS, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_CONSTRUCTION,
		ACCESS_ATMOSPHERICS, ACCESS_EXTERNAL_AIRLOCKS
	)
	minimal_access = list(
		ACCESS_ATMOSPHERICS, ACCESS_MAINT_TUNNELS, ACCESS_EMERGENCY_STORAGE, ACCESS_CONSTRUCTION,
		ACCESS_EXTERNAL_AIRLOCKS
	)

	outfit = /decl/hierarchy/outfit/job/engineering/atmospherics

	special_survival_kit = /obj/item/storage/box/survival/engineer