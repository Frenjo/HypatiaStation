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

	alt_titles = list("Barista", "Mixologist")

/datum/job/bartender/equip(mob/living/carbon/human/H)
	if(isnull(H))
		return 0

	switch(H.backbag)
		if(2)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), SLOT_ID_BACK)
		if(3)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/norm(H), SLOT_ID_BACK)
		if(4)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel(H), SLOT_ID_BACK)
	
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_service(H), SLOT_ID_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), SLOT_ID_SHOES)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/bartender(H), SLOT_ID_W_UNIFORM)
	H.equip_to_slot_or_del(new /obj/item/device/pda/bar(H), SLOT_ID_BELT)

	if(H.backbag == 1)
		var/obj/item/weapon/storage/box/survival/Barpack = new /obj/item/weapon/storage/box/survival(H)
		H.equip_to_slot_or_del(Barpack, SLOT_ID_R_HAND)
		new /obj/item/ammo_casing/shotgun/beanbag(Barpack)
		new /obj/item/ammo_casing/shotgun/beanbag(Barpack)
		new /obj/item/ammo_casing/shotgun/beanbag(Barpack)
		new /obj/item/ammo_casing/shotgun/beanbag(Barpack)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), SLOT_ID_IN_BACKPACK)
		H.equip_to_slot_or_del(new /obj/item/ammo_casing/shotgun/beanbag(H), SLOT_ID_IN_BACKPACK)
		H.equip_to_slot_or_del(new /obj/item/ammo_casing/shotgun/beanbag(H), SLOT_ID_IN_BACKPACK)
		H.equip_to_slot_or_del(new /obj/item/ammo_casing/shotgun/beanbag(H), SLOT_ID_IN_BACKPACK)
		H.equip_to_slot_or_del(new /obj/item/ammo_casing/shotgun/beanbag(H), SLOT_ID_IN_BACKPACK)

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

	alt_titles = list("Cook")

/datum/job/chef/equip(mob/living/carbon/human/H)
	if(isnull(H))
		return 0

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_service(H), SLOT_ID_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chef(H), SLOT_ID_W_UNIFORM)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/chef(H), SLOT_ID_WEAR_SUIT)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), SLOT_ID_SHOES)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/chefhat(H), SLOT_ID_HEAD)
	H.equip_to_slot_or_del(new /obj/item/device/pda/chef(H), SLOT_ID_BELT)

	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), SLOT_ID_R_HAND)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), SLOT_ID_IN_BACKPACK)

	return 1

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

	alt_titles = list("Hydroponicist", "Gardener")

/datum/job/hydro/equip(mob/living/carbon/human/H)
	if(isnull(H))
		return 0

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_service(H), SLOT_ID_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/hydroponics(H), SLOT_ID_W_UNIFORM)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), SLOT_ID_SHOES)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/botanic_leather(H), SLOT_ID_GLOVES)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/apron(H), SLOT_ID_WEAR_SUIT)
	H.equip_to_slot_or_del(new /obj/item/device/analyzer/plant_analyzer(H), SLOT_ID_S_STORE)
	H.equip_to_slot_or_del(new /obj/item/device/pda/botanist(H), SLOT_ID_BELT)

	if(H.backbag == 3)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/hyd(H), SLOT_ID_BACK)
	else if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), SLOT_ID_R_HAND)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), SLOT_ID_IN_BACKPACK)
	return 1

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

/datum/job/clown/equip(mob/living/carbon/human/H)
	if(isnull(H))
		return 0

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_service(H), SLOT_ID_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/clown(H), SLOT_ID_BACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), SLOT_ID_IN_BACKPACK)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/clown(H), SLOT_ID_W_UNIFORM)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/clown_shoes(H), SLOT_ID_SHOES)
	H.equip_to_slot_or_del(new /obj/item/device/pda/clown(H), SLOT_ID_BELT)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/clown_hat(H), SLOT_ID_WEAR_MASK)
	H.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/food/snacks/grown/banana(H), SLOT_ID_IN_BACKPACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/bikehorn(H), SLOT_ID_IN_BACKPACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/stamp/clown(H), SLOT_ID_IN_BACKPACK)
	H.equip_to_slot_or_del(new /obj/item/toy/crayon/rainbow(H), SLOT_ID_IN_BACKPACK)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/fancy/crayons(H), SLOT_ID_IN_BACKPACK)
	H.equip_to_slot_or_del(new /obj/item/toy/waterflower(H), SLOT_ID_IN_BACKPACK)
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

/datum/job/mime/equip(mob/living/carbon/human/H)
	if(isnull(H))
		return 0

	if(H.backbag == 2)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), SLOT_ID_BACK)
	if(H.backbag == 3)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/norm(H), SLOT_ID_BACK)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_service(H), SLOT_ID_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/mime(H), SLOT_ID_W_UNIFORM)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), SLOT_ID_SHOES)
	H.equip_to_slot_or_del(new /obj/item/device/pda/mime(H), SLOT_ID_BELT)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/white(H), SLOT_ID_GLOVES)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/mime(H), SLOT_ID_WEAR_MASK)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret(H), SLOT_ID_HEAD)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/suspenders(H), SLOT_ID_WEAR_SUIT)

	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), SLOT_ID_R_HAND)
		H.equip_to_slot_or_del(new /obj/item/toy/crayon/mime(H), SLOT_ID_L_STORE)
		H.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/food/drinks/bottle/bottleofnothing(H), SLOT_ID_L_HAND)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), SLOT_ID_IN_BACKPACK)
		H.equip_to_slot_or_del(new /obj/item/toy/crayon/mime(H), SLOT_ID_IN_BACKPACK)
		H.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/food/drinks/bottle/bottleofnothing(H), SLOT_ID_IN_BACKPACK)

	H.verbs += /client/proc/mimespeak
	H.verbs += /client/proc/mimewall
	H.mind.special_verbs += /client/proc/mimespeak
	H.mind.special_verbs += /client/proc/mimewall
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
	return

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
	return

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

	alt_titles = list("Custodial Specialist", "Sanitation Technician", "Cleaner")

/datum/job/janitor/equip(mob/living/carbon/human/H)
	if(isnull(H))
		return 0

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_service(H), SLOT_ID_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/janitor(H), SLOT_ID_W_UNIFORM)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), SLOT_ID_SHOES)
	H.equip_to_slot_or_del(new /obj/item/device/pda/janitor(H), SLOT_ID_BELT)

	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), SLOT_ID_R_HAND)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), SLOT_ID_IN_BACKPACK)

	return 1

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

	alt_titles = list("Journalist", "Reporter")

/datum/job/librarian/equip(mob/living/carbon/human/H)
	if(isnull(H))
		return 0

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_service(H), SLOT_ID_L_EAR)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/red(H), SLOT_ID_W_UNIFORM)
	H.equip_to_slot_or_del(new /obj/item/device/pda/librarian(H), SLOT_ID_BELT)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), SLOT_ID_SHOES)
	H.equip_to_slot_or_del(new /obj/item/weapon/barcodescanner(H), SLOT_ID_L_HAND)

	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), SLOT_ID_R_HAND)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), SLOT_ID_IN_BACKPACK)

	return 1

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

	alt_titles = list("Lawyer")

/datum/job/lawyer/equip(mob/living/carbon/human/H)
	if(isnull(H))
		return 0

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sec(H), SLOT_ID_L_EAR)
	switch(H.backbag)
		if(2)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), SLOT_ID_BACK)
		if(3)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel/norm(H), SLOT_ID_BACK)
		if(4)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/satchel(H), SLOT_ID_BACK)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/internalaffairs(H), SLOT_ID_W_UNIFORM)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/internalaffairs(H), SLOT_ID_WEAR_SUIT)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), SLOT_ID_SHOES)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big(H), SLOT_ID_GLASSES)
	H.equip_to_slot_or_del(new /obj/item/device/pda/lawyer(H), SLOT_ID_BELT)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/briefcase(H), SLOT_ID_L_HAND)

	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), SLOT_ID_R_HAND)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), SLOT_ID_IN_BACKPACK)

	var/obj/item/weapon/implant/loyalty/L = new/obj/item/weapon/implant/loyalty(H)
	L.imp_in = H
	L.implanted = 1
	var/datum/organ/external/affected = H.organs_by_name["head"]
	affected.implants.Add(L)
	L.part = affected

	return 1