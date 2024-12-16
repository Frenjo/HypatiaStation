/*
 * Captain
 */
/datum/job/captain
	title = "Captain"
	flag = JOB_CAPTAIN

	department = /decl/department/engsec
	head_position = TRUE

	total_positions = 1
	spawn_positions = 1

	supervisors = "NanoTrasen Officials and Space Law"
	selection_color = "#ccccff"

	req_admin_notify = TRUE
	minimal_player_age = 14

	outfit = /decl/hierarchy/outfit/job/command/captain

/datum/job/captain/equip(mob/living/carbon/human/H)
	. = ..()

	var/obj/item/implant/loyalty/L = new/obj/item/implant/loyalty(H)
	L.imp_in = H
	L.implanted = TRUE
	var/datum/organ/external/affected = H.organs_by_name["head"]
	affected.implants.Add(L)
	L.part = affected

	return 1

/datum/job/captain/get_access()
	return get_all_station_access()

/*
 * Head of Personnel
 */
/datum/job/hop
	title = "Head of Personnel"
	flag = JOB_HOP

	department = /decl/department/civilian
	head_position = TRUE

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Captain"
	selection_color = "#ddddff"

	req_admin_notify = TRUE
	minimal_player_age = 10

	access = list(
		ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT,
		ACCESS_FORENSICS_LOCKERS, ACCESS_MEDICAL, ACCESS_ENGINE, ACCESS_CHANGE_IDS,
		ACCESS_AI_UPLOAD, ACCESS_EVA, ACCESS_BRIDGE, ACCESS_ALL_PERSONAL_LOCKERS,
		ACCESS_MAINT_TUNNELS, ACCESS_BAR, ACCESS_JANITOR, ACCESS_CONSTRUCTION,
		ACCESS_MORGUE, ACCESS_CREMATORIUM, ACCESS_KITCHEN, ACCESS_CARGO,
		ACCESS_HYDROPONICS, ACCESS_LAWYER, ACCESS_THEATRE, ACCESS_CHAPEL_OFFICE,
		ACCESS_LIBRARY, ACCESS_RESEARCH, ACCESS_HEADS_VAULT, ACCESS_CLOWN,
		ACCESS_MIME, ACCESS_HOP, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH,
		ACCESS_GATEWAY
	)

	outfit = /decl/hierarchy/outfit/job/command/hop
	alt_titles = list("Human Resources Director")

/*
 * Internal Affairs Agent
 */
/datum/job/internal_affairs
	title = "Internal Affairs Agent"
	flag = JOB_INTERNALAFFAIRS

	department = /decl/department/civilian

	total_positions = 2
	spawn_positions = 2

	supervisors = "NanoTrasen Officials and Corporate Regulations"
	selection_color = "#ddddff"

	// Has basic access to every department, plus the usual command accesses.
	// Also has access to the law office and courtroom.
	access = list(
		ACCESS_SECURITY, ACCESS_MEDICAL, ACCESS_ENGINE, ACCESS_MAINT_TUNNELS,
		ACCESS_EXTERNAL_AIRLOCKS, ACCESS_AI_UPLOAD, ACCESS_TELEPORTER, ACCESS_EVA,
		ACCESS_BRIDGE, ACCESS_CARGO, ACCESS_LAWYER, ACCESS_COURT,
		ACCESS_RESEARCH, ACCESS_MINING, ACCESS_HEADS_VAULT, ACCESS_RC_ANNOUNCE,
		ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY, ACCESS_SEC_DOORS
	)

	outfit = /decl/hierarchy/outfit/job/command/internal_affairs

/datum/job/internal_affairs/equip(mob/living/carbon/human/H)
	. = ..()

	var/obj/item/implant/loyalty/L = new/obj/item/implant/loyalty(H)
	L.imp_in = H
	L.implanted = TRUE
	var/datum/organ/external/affected = H.organs_by_name["head"]
	affected.implants.Add(L)
	L.part = affected

	return 1