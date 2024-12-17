// Due to how large this one is it gets its own file.
/*
 * Chaplain
 */
/datum/job/chaplain
	title = "Chaplain"
	flag = JOB_CHAPLAIN

	department = /decl/department/civilian

	total_positions = 1
	spawn_positions = 1

	supervisors = "the Head of Personnel"
	selection_color = "#dddddd"

	access = list(ACCESS_MORGUE, ACCESS_CHAPEL_OFFICE, ACCESS_CREMATORIUM, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_MORGUE, ACCESS_CHAPEL_OFFICE, ACCESS_CREMATORIUM)

	outfit = /decl/hierarchy/outfit/job/service/chaplain
	alt_titles = list("Counselor")

/datum/job/chaplain/equip(mob/living/carbon/human/H, alt_title, ask_questions = TRUE)
	. = ..()
	if(!ask_questions)
		return

	var/obj/item/storage/bible/B = locate(/obj/item/storage/bible) in H
	if(isnull(B))
		return

	spawn(0)
		var/religion_name = "Christianity"
		var/new_religion = copytext(sanitize(input(H, "You are the crew services officer. Would you like to change your religion? Default is Christianity, in SPACE.", "Name change", religion_name)), 1, MAX_NAME_LEN)

		if(!new_religion)
			new_religion = religion_name

		switch(lowertext(new_religion))
			if("christianity")
				B.name = pick("The Holy Bible", "The Dead Sea Scrolls")
			if("satanism")
				B.name = "The Unholy Bible"
			if("cthulu")
				B.name = "The Necronomicon"
			if("islam")
				B.name = "Quran"
			if("scientology")
				B.name = pick("The Biography of L. Ron Hubbard", "Dianetics")
			if("chaos")
				B.name = "The Book of Lorgar"
			if("imperium")
				B.name = "Uplifting Primer"
			if("toolboxia")
				B.name = "Toolbox Manifesto"
			if("homosexuality")
				B.name = "Guys Gone Wild"
			//if("lol", "wtf", "gay", "penis", "ass", "poo", "badmin", "shitmin", "deadmin", "cock", "cocks")
			//	B.name = pick("Woodys Got Wood: The Aftermath", "War of the Cocks", "Sweet Bro and Hella Jef: Expanded Edition")
			//	H.setBrainLoss(100) // starts off retarded as fuck
			if("science")
				B.name = pick( \
					"Principle of Relativity", "Quantum Enigma: Physics Encounters Consciousness", \
					"Programming the Universe", "Quantum Physics and Theology", "String Theory for Dummies", \
					"How To: Build Your Own Warp Drive", "The Mysteries of Bluespace", "Playing God: Collector's Edition" \
				)
			else
				B.name = "The Holy Book of [new_religion]"
		feedback_set_details("religion_name","[new_religion]")

	spawn(1)
		var/deity_name = "Space Jesus"
		var/new_deity = copytext(sanitize(input(H, "Would you like to change your deity? Default is Space Jesus.", "Name change", deity_name)), 1, MAX_NAME_LEN)

		if(length(new_deity) == 0 || new_deity == "Space Jesus")
			new_deity = deity_name
		B.deity_name = new_deity

		var/accepted = FALSE
		var/outoftime = FALSE
		spawn(200) // 20 seconds to choose
			outoftime = TRUE
		var/new_book_style = "Bible"

		while(!accepted)
			if(isnull(B))
				break // prevents possible runtime errors
			new_book_style = input(H, "Which bible style would you like?") in list("Bible", "Koran", "Scrapbook", "Creeper", "White Bible", "Holy Light", "Athiest", "Tome", "The King in Yellow", "Ithaqua", "Scientology", "the bible melts", "Necronomicon")
			switch(new_book_style)
				if("Koran")
					B.icon_state = "koran"
					B.item_state = "koran"
					for(var/area/station/crew/chapel/main/A in GLOBL.area_list)
						for_no_type_check(var/turf/T, A.turf_list)
							if(T.icon_state == "carpetsymbol")
								T.set_dir(4)
				if("Scrapbook")
					B.icon_state = "scrapbook"
					B.item_state = "scrapbook"
				if("Creeper")
					B.icon_state = "creeper"
					B.item_state = "syringe_kit"
				if("White Bible")
					B.icon_state = "white"
					B.item_state = "syringe_kit"
				if("Holy Light")
					B.icon_state = "holylight"
					B.item_state = "syringe_kit"
				if("Athiest")
					B.icon_state = "athiest"
					B.item_state = "syringe_kit"
					for(var/area/station/crew/chapel/main/A in GLOBL.area_list)
						for_no_type_check(var/turf/T, A.turf_list)
							if(T.icon_state == "carpetsymbol")
								T.set_dir(10)
				if("Tome")
					B.icon_state = "tome"
					B.item_state = "syringe_kit"
				if("The King in Yellow")
					B.icon_state = "kingyellow"
					B.item_state = "kingyellow"
				if("Ithaqua")
					B.icon_state = "ithaqua"
					B.item_state = "ithaqua"
				if("Scientology")
					B.icon_state = "scientology"
					B.item_state = "scientology"
					for(var/area/station/crew/chapel/main/A in GLOBL.area_list)
						for_no_type_check(var/turf/T, A.turf_list)
							if(T.icon_state == "carpetsymbol")
								T.set_dir(8)
				if("the bible melts")
					B.icon_state = "melted"
					B.item_state = "melted"
				if("Necronomicon")
					B.icon_state = "necronomicon"
					B.item_state = "necronomicon"
				else
					// if christian bible, revert to default
					B.icon_state = "bible"
					B.item_state = "bible"
					for(var/area/station/crew/chapel/main/A in GLOBL.area_list)
						for_no_type_check(var/turf/T, A.turf_list)
							if(T.icon_state == "carpetsymbol")
								T.set_dir(2)

			H.update_inv_l_hand() // so that it updates the bible's item_state in his hand

			switch(input(H, "Look at your bible - is this what you want?") in list("Yes", "No"))
				if("Yes")
					accepted = TRUE
				if("No")
					if(outoftime)
						to_chat(H, "Welp, out of time, buddy. You're stuck. Next time choose faster.")
						accepted = TRUE

		if(isnotnull(GLOBL.religion))
			GLOBL.religion.deity_name = B.deity_name
			GLOBL.religion.bible_name = B.name
			GLOBL.religion.bible_icon_state = B.icon_state
			GLOBL.religion.bible_item_state = B.item_state
		feedback_set_details("religion_deity", "[new_deity]")
		feedback_set_details("religion_book", "[new_book_style]")

	return 1

// This one's very special snowflake.
/datum/job/chaplain/equip_preview(mob/living/carbon/human/H, alt_title)
	var/species = H.get_species()
	if(species == SPECIES_SOGHUN || species == SPECIES_TAJARAN)
		H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H), SLOT_ID_SHOES)
	else if(species == SPECIES_PLASMALIN)
		H.equip_to_slot_or_del(new /obj/item/clothing/under/plasmalin(H), SLOT_ID_WEAR_UNIFORM)
		H.equip_to_slot_or_del(new /obj/item/clothing/gloves/plasmalin(H), SLOT_ID_GLOVES)
		H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/plasmalin(H), SLOT_ID_HEAD)
	else if(species == SPECIES_VOX)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath/vox(src), SLOT_ID_WEAR_MASK)
	return equip(H, alt_title, FALSE)