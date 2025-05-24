/*
 * Bartender
 */
/datum/job/bartender
	title = "Bartender"
	flag = JOB_BARTENDER

	department = /decl/department/civilian

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Head of Personnel"
	selection_color = "#dddddd"

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE)
	minimal_access = list(ACCESS_BAR)

	outfit = /decl/hierarchy/outfit/job/service/bartender
	alt_titles = list("Barista", "Mixologist")

/*
 * Chef
 */
/datum/job/chef
	title = "Chef"
	flag = JOB_CHEF

	department = /decl/department/civilian

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Head of Personnel"
	selection_color = "#dddddd"

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE)
	minimal_access = list(ACCESS_KITCHEN)

	outfit = /decl/hierarchy/outfit/job/service/chef
	alt_titles = list("Cook")

/*
 * Botanist
 */
/datum/job/hydro
	title = "Botanist"
	flag = JOB_BOTANIST

	department = /decl/department/civilian

	total_positions = 3
	spawn_positions = 2

	supervisors = "the Head of Personnel"
	selection_color = "#dddddd"

	// Removed tox and chem access because STOP PISSING OFF THE CHEMIST GUYS // //Removed medical access because WHAT THE FUCK YOU AREN'T A DOCTOR YOU GROW WHEAT //Given Morgue access because they have a viable means of cloning.
	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE)
	minimal_access = list(ACCESS_HYDROPONICS, ACCESS_MORGUE)

	outfit = /decl/hierarchy/outfit/job/service/botanist
	alt_titles = list("Hydroponicist", "Gardener")

/*
 * Janitor
 */
/datum/job/janitor
	title = "Janitor"
	flag = JOB_JANITOR

	department = /decl/department/civilian

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Head of Personnel"
	selection_color = "#dddddd"

	access = list(ACCESS_JANITOR, ACCESS_MAINT_TUNNELS)

	outfit = /decl/hierarchy/outfit/job/service/janitor
	alt_titles = list("Custodial Specialist", "Sanitation Technician", "Cleaner")

/*
 * Librarian
 */
// More or less assistants.
/datum/job/librarian
	title = "Librarian"
	flag = JOB_LIBRARIAN

	department = /decl/department/civilian

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Head of Personnel"
	selection_color = "#dddddd"

	access = list(ACCESS_LIBRARY, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_LIBRARY)

	outfit = /decl/hierarchy/outfit/job/service/librarian
	alt_titles = list("Journalist", "Reporter")

/*
 * Lawyer
 */
/datum/job/lawyer
	title = "Lawyer"
	flag = JOB_LAWYER

	department = /decl/department/civilian

	total_positions = 2
	spawn_positions = 2

	supervisors = "the Head of Personnel and Space Law"
	selection_color = "#dddddd"

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS)
	minimal_access = list(ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS)

	outfit = /decl/hierarchy/outfit/job/service/lawyer
	alt_titles = list("Solicitor")

/*
 * Clown
 */
//Griff //BS12 EDIT
// Re-enabled clown and mime. -Frenjo
/datum/job/clown
	title = "Clown"
	flag = JOB_CLOWN

	department = /decl/department/civilian

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Head of Personnel"
	selection_color = "#dddddd"

	access = list(ACCESS_CLOWN, ACCESS_THEATRE, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_CLOWN, ACCESS_THEATRE)

	outfit = /decl/hierarchy/outfit/job/service/clown

/datum/job/clown/equip(mob/living/carbon/human/H)
	. = ..()
	H.mutations.Add(MUTATION_CLUMSY)
	var/obj/item/implant/sad_trombone/womp = new /obj/item/implant/sad_trombone(H)
	womp.imp_in = H
	womp.implanted = TRUE
	var/datum/organ/external/affected = H.organs_by_name["head"]
	affected.implants.Add(womp)
	womp.part = affected

/*
 * Mime
 */
/datum/job/mime
	title = "Mime"
	flag = JOB_MIME

	department = /decl/department/civilian

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Head of Personnel"
	selection_color = "#dddddd"

	access = list(ACCESS_MIME, ACCESS_THEATRE, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_MIME, ACCESS_THEATRE)

	outfit = /decl/hierarchy/outfit/job/service/mime

/datum/job/mime/equip(mob/living/carbon/human/H)
	. = ..()
	H.verbs.Add(/client/proc/mimespeak)
	H.verbs.Add(/client/proc/mimewall)
	H.mind.special_verbs.Add(/client/proc/mimespeak)
	H.mind.special_verbs.Add(/client/proc/mimewall)
	H.miming = TRUE

/*
 * Mimewalls
 */
/client/proc/mimewall()
	set category = "Mime"
	set name = "Invisible wall"
	set desc = "Create an invisible wall on your location."

	if(usr.stat)
		to_chat(usr, "Not when you're incapacitated.")
		return
	if(!ishuman(usr))
		return

	var/mob/living/carbon/human/H = usr

	if(!H.miming)
		to_chat(usr, "You still haven't atoned for your speaking transgression. Wait.")
		return
	H.verbs.Remove(/client/proc/mimewall)
	spawn(300)
		H.verbs.Add(/client/proc/mimewall)
	H.visible_message(
		SPAN_INFO("[H] looks as if a wall is in front of them."),
		SPAN_INFO("You form a wall in front of yourself.")
	)
	new /obj/effect/forcefield/mime(locate(usr.x, usr.y, usr.z))

/obj/effect/forcefield/mime
	icon_state = "empty"
	name = "invisible wall"
	desc = "You have a bad feeling about this."

	var/timeleft = 300
	var/last_process = 0

/obj/effect/forcefield/mime/New()
	. = ..()
	last_process = world.time
	GLOBL.processing_objects.Add(src)

/obj/effect/forcefield/mime/process()
	timeleft -= (world.time - last_process)
	if(timeleft <= 0)
		GLOBL.processing_objects.Remove(src)
		qdel(src)

/*
 * Mime Speech
 */
/client/proc/mimespeak()
	set category = "Mime"
	set name = "Speech"
	set desc = "Toggle your speech."

	if(!ishuman(usr))
		return

	var/mob/living/carbon/human/H = usr

	if(H.miming)
		H.miming = FALSE
	else
		to_chat(usr, "You'll have to wait if you want to atone for your sins.")
		spawn(3000)
			H.miming = TRUE