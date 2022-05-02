//Food
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
	if(!H)
		return 0

	switch(H.backbag)
		if(2)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), slot_back)
		if(3)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(H), slot_back)
		if(4)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)
	
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_service(H), slot_l_ear)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/bartender(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/device/pda/bar(H), slot_belt)

	if(H.backbag == 1)
		var/obj/item/weapon/storage/box/survival/Barpack = new /obj/item/weapon/storage/box/survival(H)
		H.equip_to_slot_or_del(Barpack, slot_r_hand)
		new /obj/item/ammo_casing/shotgun/beanbag(Barpack)
		new /obj/item/ammo_casing/shotgun/beanbag(Barpack)
		new /obj/item/ammo_casing/shotgun/beanbag(Barpack)
		new /obj/item/ammo_casing/shotgun/beanbag(Barpack)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/ammo_casing/shotgun/beanbag(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/ammo_casing/shotgun/beanbag(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/ammo_casing/shotgun/beanbag(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/ammo_casing/shotgun/beanbag(H), slot_in_backpack)

	return 1


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
	if(!H)
		return 0

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_service(H), slot_l_ear)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/chef(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/chef(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/chefhat(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/device/pda/chef(H), slot_belt)

	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)

	return 1


/datum/job/hydro
	title = "Botanist"
	flag = JOB_BOTANIST
	department_flag = DEPARTMENT_CIVILIAN
	faction = "Station"
	total_positions = 3
	spawn_positions = 2
	supervisors = "the Head of Personnel"
	selection_color = "#dddddd"
	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE) // Removed tox and chem access because STOP PISSING OFF THE CHEMIST GUYS // //Removed medical access because WHAT THE FUCK YOU AREN'T A DOCTOR YOU GROW WHEAT //Given Morgue access because they have a viable means of cloning.
	minimal_access = list(ACCESS_HYDROPONICS, ACCESS_MORGUE) // Removed tox and chem access because STOP PISSING OFF THE CHEMIST GUYS // //Removed medical access because WHAT THE FUCK YOU AREN'T A DOCTOR YOU GROW WHEAT //Given Morgue access because they have a viable means of cloning.
	alt_titles = list("Hydroponicist", "Gardener")

/datum/job/hydro/equip(mob/living/carbon/human/H)
	if(!H)
		return 0

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_service(H), slot_l_ear)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/hydroponics(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/botanic_leather(H), slot_gloves)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/apron(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/device/analyzer/plant_analyzer(H), slot_s_store)
	H.equip_to_slot_or_del(new /obj/item/device/pda/botanist(H), slot_belt)

	if(H.backbag == 3)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_hyd(H), slot_back)
	else if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
	return 1


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
	if(!H)
		return 0

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_service(H), slot_l_ear)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/clown(H), slot_back)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/clown(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/clown_shoes(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/device/pda/clown(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/clown_hat(H), slot_wear_mask)
	H.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/food/snacks/grown/banana(H), slot_in_backpack)
	H.equip_to_slot_or_del(new /obj/item/weapon/bikehorn(H), slot_in_backpack)
	H.equip_to_slot_or_del(new /obj/item/weapon/stamp/clown(H), slot_in_backpack)
	H.equip_to_slot_or_del(new /obj/item/toy/crayon/rainbow(H), slot_in_backpack)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/fancy/crayons(H), slot_in_backpack)
	H.equip_to_slot_or_del(new /obj/item/toy/waterflower(H), slot_in_backpack)
	H.mutations.Add(CLUMSY)

	return 1


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
	if(!H)
		return 0

	if(H.backbag == 2)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), slot_back)
	if(H.backbag == 3)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(H), slot_back)

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_service(H), slot_l_ear)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/mime(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/device/pda/mime(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/white(H), slot_gloves)
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/mime(H), slot_wear_mask)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/beret(H), slot_head)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/suspenders(H), slot_wear_suit)

	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
		H.equip_to_slot_or_del(new /obj/item/toy/crayon/mime(H), slot_l_store)
		H.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/food/drinks/bottle/bottleofnothing(H), slot_l_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/toy/crayon/mime(H), slot_in_backpack)
		H.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/food/drinks/bottle/bottleofnothing(H), slot_in_backpack)

	H.verbs += /client/proc/mimespeak
	H.verbs += /client/proc/mimewall
	H.mind.special_verbs += /client/proc/mimespeak
	H.mind.special_verbs += /client/proc/mimewall
	H.miming = 1

	return 1


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
	if(!H)
		return 0

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_service(H), slot_l_ear)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/janitor(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/device/pda/janitor(H), slot_belt)

	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)

	return 1


//More or less assistants
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
	if(!H)
		return 0

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_service(H), slot_l_ear)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/red(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/device/pda/librarian(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/weapon/barcodescanner(H), slot_l_hand)

	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)

	return 1


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
	if(!H)
		return 0

	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_sec(H), slot_l_ear)
	switch(H.backbag)
		if(2)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack(H), slot_back)
		if(3)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel_norm(H), slot_back)
		if(4)
			H.equip_to_slot_or_del(new /obj/item/weapon/storage/backpack/satchel(H), slot_back)

	H.equip_to_slot_or_del(new /obj/item/clothing/under/rank/internalaffairs(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/internalaffairs(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/brown(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big(H), slot_glasses)
	H.equip_to_slot_or_del(new /obj/item/device/pda/lawyer(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/weapon/storage/briefcase(H), slot_l_hand)

	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)

	var/obj/item/weapon/implant/loyalty/L = new/obj/item/weapon/implant/loyalty(H)
	L.imp_in = H
	L.implanted = 1
	var/datum/organ/external/affected = H.organs_by_name["head"]
	affected.implants += L
	L.part = affected

	return 1