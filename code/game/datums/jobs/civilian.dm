/*
 * Bartender
 */
/datum/job/bartender
	title = "Bartender"
	flag = JOB_BARTENDER
	department_flag = DEPARTMENT_CIVILIAN
	faction = "Station"

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Head of Personnel"
	selection_color = "#dddddd"

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE)
	minimal_access = list(ACCESS_BAR)

	outfit = /decl/hierarchy/outfit/job/service/bartender
	alt_titles = list("Barista", "Mixologist")

/datum/job/bartender/equip(mob/living/carbon/human/H)
	. = ..()

	var/obj/item/weapon/storage/box/barpack = new /obj/item/weapon/storage/box(H)
	barpack.name = "bartender survival kit"
	new /obj/item/ammo_casing/shotgun/beanbag(barpack)
	new /obj/item/ammo_casing/shotgun/beanbag(barpack)
	new /obj/item/ammo_casing/shotgun/beanbag(barpack)
	new /obj/item/ammo_casing/shotgun/beanbag(barpack)
	if(H.backbag == 1)
		H.equip_to_slot_or_del(barpack, SLOT_ID_R_HAND)
	else
		H.equip_to_slot_or_del(barpack, SLOT_ID_IN_BACKPACK)

	return 1

/*
 * Chef
 */
/datum/job/chef
	title = "Chef"
	flag = JOB_CHEF
	department_flag = DEPARTMENT_CIVILIAN
	faction = "Station"

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
	department_flag = DEPARTMENT_CIVILIAN
	faction = "Station"

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
 * Clown
 */
//Griff //BS12 EDIT
// Re-enabled clown and mime. -Frenjo
/datum/job/clown
	title = "Clown"
	flag = JOB_CLOWN
	department_flag = DEPARTMENT_CIVILIAN
	faction = "Station"

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Head of Personnel"
	selection_color = "#dddddd"

	access = list(ACCESS_CLOWN, ACCESS_THEATRE, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_CLOWN, ACCESS_THEATRE)

	outfit = /decl/hierarchy/outfit/job/service/clown

/datum/job/clown/equip(mob/living/carbon/human/H)
	. = ..()

	H.mutations.Add(CLUMSY)

	return 1

/*
 * Mime
 */
/datum/job/mime
	title = "Mime"
	flag = JOB_MIME
	department_flag = DEPARTMENT_CIVILIAN
	faction = "Station"

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

	return 1

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
	for(var/mob/V in viewers(H))
		if(V != usr)
			V.show_message("[H] looks as if a wall is in front of them.", 3, "", 2)
	to_chat(usr, "You form a wall in front of yourself.")
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

/*
 * Janitor
 */
/datum/job/janitor
	title = "Janitor"
	flag = JOB_JANITOR
	department_flag = DEPARTMENT_CIVILIAN
	faction = "Station"

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Head of Personnel"
	selection_color = "#dddddd"

	access = list(ACCESS_JANITOR, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_JANITOR, ACCESS_MAINT_TUNNELS)

	outfit = /decl/hierarchy/outfit/job/service/janitor
	alt_titles = list("Custodial Specialist", "Sanitation Technician", "Cleaner")

/*
 * Librarian
 */
// More or less assistants.
/datum/job/librarian
	title = "Librarian"
	flag = JOB_LIBRARIAN
	department_flag = DEPARTMENT_CIVILIAN
	faction = "Station"

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Head of Personnel"
	selection_color = "#dddddd"

	access = list(ACCESS_LIBRARY, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_LIBRARY)

	outfit = /decl/hierarchy/outfit/job/service/librarian
	alt_titles = list("Journalist", "Reporter")

/*
 * Internal Affairs Agent
 */
//var/global/lawyer = 0//Checks for another lawyer //This changed clothes on 2nd lawyer, both IA get the same dreds.
/datum/job/lawyer
	title = "Internal Affairs Agent"
	flag = JOB_LAWYER
	department_flag = DEPARTMENT_CIVILIAN
	faction = "Station"

	total_positions = 2
	spawn_positions = 2

	supervisors = "the Captain"
	selection_color = "#dddddd"

	access = list(ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_LAWYER, ACCESS_COURT, ACCESS_SEC_DOORS)

	outfit = /decl/hierarchy/outfit/job/internal_affairs
	alt_titles = list("Lawyer")

/datum/job/lawyer/equip(mob/living/carbon/human/H)
	. = ..()

	var/obj/item/weapon/implant/loyalty/L = new/obj/item/weapon/implant/loyalty(H)
	L.imp_in = H
	L.implanted = TRUE
	var/datum/organ/external/affected = H.organs_by_name["head"]
	affected.implants.Add(L)
	L.part = affected

	return 1