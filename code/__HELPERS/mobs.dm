/proc/random_hair_style(gender, species = SPECIES_HUMAN)
	var/h_style = "Bald"

	var/list/valid_hairstyles = list()
	for(var/hairstyle in GLOBL.hair_styles_list)
		var/datum/sprite_accessory/S = GLOBL.hair_styles_list[hairstyle]
		if(gender == MALE && S.gender == FEMALE)
			continue
		if(gender == FEMALE && S.gender == MALE)
			continue
		if(!(species in S.species_allowed))
			continue
		valid_hairstyles[hairstyle] = GLOBL.hair_styles_list[hairstyle]

	if(length(valid_hairstyles))
		h_style = pick(valid_hairstyles)

	return h_style

/proc/random_facial_hair_style(gender, species = SPECIES_HUMAN)
	var/f_style = "Shaved"

	var/list/valid_facialhairstyles = list()
	for(var/facialhairstyle in GLOBL.facial_hair_styles_list)
		var/datum/sprite_accessory/S = GLOBL.facial_hair_styles_list[facialhairstyle]
		if(gender == MALE && S.gender == FEMALE)
			continue
		if(gender == FEMALE && S.gender == MALE)
			continue
		if(!(species in S.species_allowed))
			continue

		valid_facialhairstyles[facialhairstyle] = GLOBL.facial_hair_styles_list[facialhairstyle]

	if(length(valid_facialhairstyles))
		f_style = pick(valid_facialhairstyles)

		return f_style

/proc/random_name(gender, species = SPECIES_HUMAN)
	if(gender == FEMALE)
		return capitalize(pick(GLOBL.first_names_female)) + " " + capitalize(pick(GLOBL.last_names))
	else
		return capitalize(pick(GLOBL.first_names_male)) + " " + capitalize(pick(GLOBL.last_names))

/proc/random_skin_tone()
	switch(pick(60;"caucasian", 15;"afroamerican", 10;"african", 10;"latino", 5;"albino"))
		if("caucasian")
			. = -10
		if("afroamerican")
			. = -115
		if("african")
			. = -165
		if("latino")
			. = -55
		if("albino")
			. = 34
		else
			. = rand(-185, 34)
	return min(max(. + rand(-25, 25), -185), 34)

/proc/skintone2racedescription(tone)
	switch(tone)
		if(30 to INFINITY)
			return "albino"
		if(20 to 30)
			return "pale"
		if(5 to 15)
			return "light skinned"
		if(-10 to 5)
			return "white"
		if(-25 to -10)
			return "tan"
		if(-45 to -25)
			return "darker skinned"
		if(-65 to -45)
			return "brown"
		if(-INFINITY to -65)
			return "black"
		else
			return "unknown"

/proc/age2agedescription(age)
	switch(age)
		if(0 to 1)
			return "infant"
		if(1 to 3)
			return "toddler"
		if(3 to 13)
			return "child"
		if(13 to 19)
			return "teenager"
		if(19 to 30)
			return "young adult"
		if(30 to 45)
			return "adult"
		if(45 to 60)
			return "middle-aged"
		if(60 to 70)
			return "aging"
		if(70 to INFINITY)
			return "elderly"
		else
			return "unknown"

/proc/RoundHealth(health)
	switch(health)
		if(100 to INFINITY)
			return "health100"
		if(70 to 100)
			return "health80"
		if(50 to 70)
			return "health60"
		if(30 to 50)
			return "health40"
		if(18 to 30)
			return "health25"
		if(5 to 18)
			return "health10"
		if(1 to 5)
			return "health1"
		if(-99 to 0)
			return "health0"
		else
			return "health-100"

/proc/do_mob(mob/user, mob/target, time = 30, uninterruptible = 0, progress = 1)
	if(isnull(user) || isnull(target))
		return 0
	var/user_loc = user.loc
	var/target_loc = target.loc

	var/holding = user.get_active_hand()
	var/datum/progressbar/progbar
	if(progress)
		progbar = new /datum/progressbar(user, time, target)

	var/endtime = world.time + time
	var/starttime = world.time
	. = 1
	while(world.time < endtime)
		sleep(1)
		if(progress)
			progbar.update(world.time - starttime)
		if(isnull(user) || isnull(target))
			. = 0
			break
		if(uninterruptible)
			continue

		if(user.incapacitated() || user.loc != user_loc)
			. = 0
			break

		if(target.loc != target_loc || user.get_active_hand() != holding)
			. = 0
			break
	if(isnotnull(progbar))
		qdel(progbar)

/proc/do_after(mob/user, delay, atom/target = null, needhand = 1, progress = 1)
	if(isnull(user))
		return 0
	var/atom/target_loc = null
	if(isnotnull(target))
		target_loc = target.loc

	var/atom/original_loc = user.loc

	var/holding = user.get_active_hand()

	var/holdingnull = TRUE // User's hand started out empty, check for an empty hand.
	if(isnotnull(holding))
		holdingnull = FALSE // User's hand started holding something, check to see if it's still holding that.

	var/datum/progressbar/progbar
	if(progress)
		progbar = new /datum/progressbar(user, delay, target)

	var/endtime = world.time + delay
	var/starttime = world.time
	. = 1
	while(world.time < endtime)
		sleep(1)
		if(progress)
			progbar.update(world.time - starttime)

		if(isnull(user) || user.incapacitated() || user.loc != original_loc)
			. = 0
			break

		if(isnotnull(target_loc) && (isnull(target) || target_loc != target.loc))
			. = 0
			break

		if(needhand)
			//This might seem like an odd check, but you can still need a hand even when it's empty
			//i.e the hand is used to pull some item/tool out of the construction
			if(!holdingnull)
				if(!holding)
					. = 0
					break
			if(user.get_active_hand() != holding)
				. = 0
				break

	if(isnotnull(progbar))
		qdel(progbar)

/proc/FindNameFromID(mob/living/carbon/human/H)
	ASSERT(istype(H))
	var/obj/item/card/id/C = H.get_active_hand()
	if(istype(C) || istype(C, /obj/item/pda))
		var/obj/item/card/id/ID = C

		if(istype(C, /obj/item/pda))
			var/obj/item/pda/pda = C
			ID = pda.id
		if(!istype(ID))
			ID = null

		if(isnotnull(ID))
			return ID.registered_name

	C = H.id_store

	if(istype(C) || istype(C, /obj/item/pda))
		var/obj/item/card/id/ID = C

		if(istype(C, /obj/item/pda))
			var/obj/item/pda/pda = C
			ID = pda.id
		if(!istype(ID))
			ID = null

		if(isnotnull(ID))
			return ID.registered_name

/proc/get_mannequin(ckey)
	. = GLOBL.mannequins_by_ckey[ckey]
	if(isnull(.))
		. = new /mob/living/carbon/human/dummy/mannequin()
		GLOBL.mannequins_by_ckey[ckey] = .

//This will update a mob's name, real_name, mind.name, data_core records, pda and id
//Calling this proc without an oldname will only update the mob and skip updating the pda, id and records ~Carn
/mob/proc/fully_replace_character_name(oldname, newname)
	if(!newname)
		return 0
	real_name = newname
	name = newname
	mind?.name = newname
	dna?.real_name = real_name

	if(oldname)
		//update the datacore records! This is goig to be a bit costly.
		for_no_type_check(var/list/L, list(GLOBL.data_core.general, GLOBL.data_core.medical, GLOBL.data_core.security, GLOBL.data_core.locked))
			for_no_type_check(var/datum/data/record/R, L)
				if(R.fields["name"] == oldname)
					R.fields["name"] = newname
					break

		//update our pda and id if we have them on our person
		var/list/searching = GetAllContents(searchDepth = 3)
		var/search_id = TRUE
		var/search_pda = TRUE

		for(var/A in searching)
			if(search_id && istype(A, /obj/item/card/id))
				var/obj/item/card/id/ID = A
				if(ID.registered_name == oldname)
					ID.registered_name = newname
					ID.name = "[newname]'s ID Card ([ID.assignment])"
					if(!search_pda)
						break
					search_id = FALSE

			else if(search_pda && istype(A, /obj/item/pda))
				var/obj/item/pda/PDA = A
				if(PDA.owner == oldname)
					PDA.owner = newname
					PDA.name = "PDA - [newname] ([PDA.ownjob])" // Edited this to space out the dash. -Frenjo
					if(!search_id)
						break
					search_pda = FALSE
	return 1

//Generalised helper proc for letting mobs rename themselves. Used to be clname() and ainame()
//Last modified by Carn
/mob/proc/rename_self(role, allow_numbers = 0)
	set waitfor = FALSE

	var/oldname = real_name

	var/time_passed = world.time
	var/newname

	for(var/i = 1, i <= 3, i++)	//we get 3 attempts to pick a suitable name.
		newname = input(src, "You are a [role]. Would you like to change your name to something else?", "Name change", oldname) as text
		if((world.time - time_passed) > 300)
			return	//took too long
		newname = reject_bad_name(newname, allow_numbers)	//returns null if the name doesn't meet some basic requirements. Tidies up a few other things like bad-characters.

		for(var/mob/living/M in GLOBL.player_list)
			if(M == src)
				continue
			if(!newname || M.real_name == newname)
				newname = null
				break
		if(newname)
			break	//That's a suitable name!
		to_chat(src, "Sorry, that [role]-name wasn't appropriate, please try another. It's possibly too long/short, has bad characters or is already taken.")

	if(!newname)	//we'll stick with the oldname then
		return

	if(cmptext("ai", role))
		if(isAI(src))
			var/mob/living/silicon/ai/A = src
			oldname = null//don't bother with the records update crap
			//to_world("<b>[newname] is the AI!</b>")
			//world << sound('sound/AI/newAI.ogg')
			// Set eyeobj name
			A.eyeobj?.name = "[newname] (AI Eye)"

			// Set ai pda name
			if(isnotnull(A.aiPDA))
				A.aiPDA.owner = newname
				A.aiPDA.name = newname + " (" + A.aiPDA.ownjob + ")"

	fully_replace_character_name(oldname, newname)

/proc/get_sorted_mobs()
	var/list/old_list = getmobs()
	var/list/ai_list = list()
	var/list/dead_list = list()
	var/list/keyclient_list = list()
	var/list/key_list = list()
	var/list/logged_list = list()
	for(var/named in old_list)
		var/mob/M = old_list[named]
		if(issilicon(M))
			ai_list |= M
		else if(isghost(M) || M.stat == DEAD)
			dead_list |= M
		else if(isnotnull(M.key) && isnotnull(M.client))
			keyclient_list |= M
		else if(isnotnull(M.key))
			key_list |= M
		else
			logged_list |= M
		old_list.Remove(named)
	. = list()
	. += ai_list
	. += keyclient_list
	. += key_list
	. += logged_list
	. += dead_list

//Returns a list of all mobs with their name
/proc/getmobs()
	. = list()
	var/list/mobs = sortmobs()
	var/list/names = list()
	var/list/namecounts = list()
	for(var/mob/M in mobs)
		var/name = M.name
		if(name in names)
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1
		if(isnotnull(M.real_name) && M.real_name != M.name)
			name += " \[[M.real_name]\]"
		if(M.stat == DEAD)
			if(isghost(M))
				name += " \[ghost\]"
			else
				name += " \[dead\]"
		.[name] = M

//Orders mobs by type then by name
/proc/sortmobs()
	. = list()
	var/list/sorted_mob_list = sortAtom(GLOBL.mob_list)
	for(var/mob/living/silicon/ai/M in sorted_mob_list)
		. += M
	for(var/mob/living/silicon/pai/M in sorted_mob_list)
		. += M
	for(var/mob/living/silicon/robot/M in sorted_mob_list)
		. += M
	for(var/mob/living/carbon/human/M in sorted_mob_list)
		. += M
	for(var/mob/living/brain/M in sorted_mob_list)
		. += M
	for(var/mob/living/carbon/alien/M in sorted_mob_list)
		. += M
	for(var/mob/dead/ghost/M in sorted_mob_list)
		. += M
	for(var/mob/dead/new_player/M in sorted_mob_list)
		. += M
	for(var/mob/living/carbon/monkey/M in sorted_mob_list)
		. += M
	for(var/mob/living/carbon/slime/M in sorted_mob_list)
		. += M
	for(var/mob/living/simple/M in sorted_mob_list)
		. += M
//	for(var/mob/living/silicon/hivebot/M in sorted_mob_list)
//		. += M
//	for(var/mob/living/silicon/hive_mainframe/M in sorted_mob_list)
//		. += M

/proc/get_mob_with_client_list()
	. = list()
	for(var/mob/M in GLOBL.mob_list)
		if(isnotnull(M.client))
			. += M