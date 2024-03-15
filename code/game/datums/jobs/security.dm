/*
 * Head of Security
 */
/datum/job/hos
	title = "Head of Security"
	flag = JOB_HOS
	department_flag = DEPARTMENT_ENGSEC

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Captain"
	selection_color = "#ffdddd"

	req_admin_notify = TRUE
	minimal_player_age = 14

	access = list(
		ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_ARMOURY, ACCESS_COURT,
		ACCESS_FORENSICS_LOCKERS, ACCESS_MORGUE, ACCESS_MAINT_TUNNELS, ACCESS_ALL_PERSONAL_LOCKERS,
		ACCESS_RESEARCH, ACCESS_ENGINE, ACCESS_MINING, ACCESS_MEDICAL, ACCESS_CONSTRUCTION, ACCESS_MAILSORTING,
		ACCESS_BRIDGE, ACCESS_HOS, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY
	)
	minimal_access = list(
		ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_ARMOURY, ACCESS_COURT,
		ACCESS_FORENSICS_LOCKERS, ACCESS_MORGUE, ACCESS_MAINT_TUNNELS, ACCESS_ALL_PERSONAL_LOCKERS,
		ACCESS_RESEARCH, ACCESS_ENGINE, ACCESS_MINING, ACCESS_MEDICAL, ACCESS_CONSTRUCTION, ACCESS_MAILSORTING,
		ACCESS_BRIDGE, ACCESS_HOS, ACCESS_RC_ANNOUNCE, ACCESS_KEYCARD_AUTH, ACCESS_GATEWAY
	)

	outfit = /decl/hierarchy/outfit/job/security/hos
	alt_titles = list("Security Commander")

/datum/job/hos/equip(mob/living/carbon/human/H)
	. = ..()

	var/obj/item/implant/loyalty/L = new/obj/item/implant/loyalty(H)
	L.imp_in = H
	L.implanted = TRUE
	var/datum/organ/external/affected = H.organs_by_name["head"]
	affected.implants.Add(L)
	L.part = affected

	return 1

/*
 * Warden
 */
/datum/job/warden
	title = "Warden"
	flag = JOB_WARDEN
	department_flag = DEPARTMENT_ENGSEC

	total_positions = 2
	spawn_positions = 2

	supervisors = "the Head of Security"
	selection_color = "#ffeeee"

	minimal_player_age = 5

	access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_ARMOURY, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_MORGUE)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_ARMOURY, ACCESS_COURT, ACCESS_MAINT_TUNNELS)

	outfit = /decl/hierarchy/outfit/job/security/warden

/*
 * Detective
 */
/datum/job/detective
	title = "Detective"
	flag = JOB_DETECTIVE
	department_flag = DEPARTMENT_ENGSEC

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Head of Security"
	selection_color = "#ffeeee"

	minimal_player_age = 3

	access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_FORENSICS_LOCKERS, ACCESS_MORGUE, ACCESS_MAINT_TUNNELS, ACCESS_COURT)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_FORENSICS_LOCKERS, ACCESS_MORGUE, ACCESS_MAINT_TUNNELS, ACCESS_COURT)

	outfit = /decl/hierarchy/outfit/job/security/detective
	alt_titles = list("Forensic Technician" = /decl/hierarchy/outfit/job/security/detective/forensics)

/*
 * Security Officer
 */
/datum/job/officer
	title = "Security Officer"
	flag = JOB_OFFICER
	department_flag = DEPARTMENT_ENGSEC

	total_positions = 5
	spawn_positions = 5

	supervisors = "the Head of Security"
	selection_color = "#ffeeee"

	minimal_player_age = 3

	access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_MORGUE)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MAINT_TUNNELS)

	outfit = /decl/hierarchy/outfit/job/security/officer

/*
 * Security Paramedic
 */
/datum/job/secpara
	title = "Security Paramedic"
	flag = JOB_SECPARA
	department_flag = DEPARTMENT_ENGSEC

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Warden and the Head of Security"
	selection_color = "#ffeeee"

	minimal_player_age = 7

	access = list(ACCESS_MEDICAL, ACCESS_CHEMISTRY, ACCESS_SURGERY, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_MORGUE)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_SEC_DOORS, ACCESS_BRIG, ACCESS_COURT, ACCESS_MAINT_TUNNELS)

	outfit = /decl/hierarchy/outfit/job/security/paramedic