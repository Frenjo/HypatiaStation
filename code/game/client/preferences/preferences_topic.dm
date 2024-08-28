/datum/preferences/proc/process_link(mob/user, list/href_list)
	if(isnull(user) || !isnewplayer(user))
		return

	switch(href_list["preference"])
		if("job")
			return process_occupation_choices_panel(user, href_list)
		if("records")
			return process_character_records_panel(user, href_list)
		if("skills")
			return process_set_skills_panel(user, href_list)
		if("specialroles")
			return process_special_roles_panel(user, href_list)
		if("uipreferences")
			return process_ui_preferences_panel(user, href_list)

	switch(href_list["task"])
		if("random")
			switch(href_list["preference"])
				if("name")
					real_name = random_name(gender)
				if("age")
					age = rand(AGE_MIN, AGE_MAX)
				if("hair")
					r_hair = rand(0, 255)
					g_hair = rand(0, 255)
					b_hair = rand(0, 255)
				if("h_style")
					h_style = random_hair_style(gender, species)
				if("facial")
					r_facial = rand(0, 255)
					g_facial = rand(0, 255)
					b_facial = rand(0, 255)
				if("f_style")
					f_style = random_facial_hair_style(gender, species)
				if("underwear")
					underwear = rand(1, length(GLOBL.underwear_m))
					character_setup_panel(user)
				if("eyes")
					r_eyes = rand(0, 255)
					g_eyes = rand(0, 255)
					b_eyes = rand(0, 255)
				if("s_tone")
					s_tone = random_skin_tone()
				if("s_color")
					r_skin = rand(0, 255)
					g_skin = rand(0, 255)
					b_skin = rand(0, 255)
				if("bag")
					backbag = rand(1, 4)
				/*if("skin_style")
					h_style = random_skin_style(gender)*/
				if("all")
					randomize_appearance_for()	//no params needed
		if("input")
			switch(href_list["preference"])
				if("name")
					var/new_name = reject_bad_name(input(user, "Choose your character's name:", "Character Preference") as text | null)
					if(new_name)
						real_name = new_name
					else
						to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and .</font>")

				if("age")
					var/new_age = input(user, "Choose your character's age:\n([AGE_MIN] - [AGE_MAX])", "Character Preference") as num | null
					if(new_age)
						age = max(min(round(text2num(new_age)), AGE_MAX), AGE_MIN)
				if("species")
					var/list/new_species = list(SPECIES_HUMAN)
					var/prev_species = species
					var/whitelisted = 0

					if(CONFIG_GET(usealienwhitelist)) //If we're using the whitelist, make sure to check it!
						for(var/S in GLOBL.whitelisted_species)
							if(is_alien_whitelisted(user, S))
								new_species += S
								whitelisted = 1
						if(!whitelisted)
							alert(user, "You cannot change your species as you need to be whitelisted. If you wish to be whitelisted contact an admin in-game, on the forums, or on IRC.")
					else //Not using the whitelist? Aliens for everyone!
						new_species = GLOBL.whitelisted_species

					species = input("Please select a species", "Character Generation", null) in new_species

					if(prev_species != species)
						//grab one of the valid hair styles for the newly chosen species
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
						else
							//this shouldn't happen
							h_style = GLOBL.hair_styles_list["Bald"]

						//grab one of the valid facial hair styles for the newly chosen species
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
						else
							//this shouldn't happen
							f_style = GLOBL.facial_hair_styles_list["Shaved"]

						//reset hair colour and skin colour
						r_hair = 0//hex2num(copytext(new_hair, 2, 4))
						g_hair = 0//hex2num(copytext(new_hair, 4, 6))
						b_hair = 0//hex2num(copytext(new_hair, 6, 8))

						s_tone = 0

				if("language")
					var/languages_available
					var/list/new_languages = list("None")
					var/datum/species/S = GLOBL.all_species[species]

					if(CONFIG_GET(usealienwhitelist))
						for(var/L in GLOBL.all_languages)
							var/datum/language/lang = GLOBL.all_languages[L]
							if(!HAS_LANGUAGE_FLAGS(lang, LANGUAGE_FLAG_RESTRICTED) && (is_alien_whitelisted(user, L) \
							|| !HAS_LANGUAGE_FLAGS(lang, LANGUAGE_FLAG_WHITELISTED) || (S && (L in S.secondary_langs))))
								new_languages += lang
								languages_available = 1

						if(!(languages_available))
							alert(user, "There are not currently any available secondary languages.")
					else
						for(var/L in GLOBL.all_languages)
							var/datum/language/lang = GLOBL.all_languages[L]
							if(!HAS_LANGUAGE_FLAGS(lang, LANGUAGE_FLAG_RESTRICTED))
								new_languages += lang.name

					secondary_language = input("Please select a secondary language", "Character Generation", null) in new_languages

				if("metadata")
					var/new_metadata = input(user, "Enter any information you'd like others to see, such as Roleplay-preferences:", "Game Preference", metadata) as message | null
					if(new_metadata)
						metadata = sanitize(copytext(new_metadata, 1, MAX_MESSAGE_LEN))

				if("b_type")
					var/new_b_type = input(user, "Choose your character's blood-type:", "Character Preference") as null | anything in list("A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-")
					if(new_b_type)
						b_type = new_b_type

				if("hair")
					var/datum/species/species_instance = GLOBL.all_species[species]
					if(!HAS_SPECIES_FLAGS(species_instance, SPECIES_FLAG_HAS_HAIR_COLOUR))
						return
					var/new_hair = input(user, "Choose your character's hair colour:", "Character Preference") as color | null
					if(new_hair)
						r_hair = hex2num(copytext(new_hair, 2, 4))
						g_hair = hex2num(copytext(new_hair, 4, 6))
						b_hair = hex2num(copytext(new_hair, 6, 8))

				if("h_style")
					var/list/valid_hairstyles = list()
					for(var/hairstyle in GLOBL.hair_styles_list)
						var/datum/sprite_accessory/S = GLOBL.hair_styles_list[hairstyle]
						if(!(species in S.species_allowed))
							continue

						valid_hairstyles[hairstyle] = GLOBL.hair_styles_list[hairstyle]

					var/new_h_style = input(user, "Choose your character's hair style:", "Character Preference") as null | anything in valid_hairstyles
					if(new_h_style)
						h_style = new_h_style

				if("facial")
					var/new_facial = input(user, "Choose your character's facial-hair colour:", "Character Preference") as color | null
					if(new_facial)
						r_facial = hex2num(copytext(new_facial, 2, 4))
						g_facial = hex2num(copytext(new_facial, 4, 6))
						b_facial = hex2num(copytext(new_facial, 6, 8))

				if("f_style")
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

					var/new_f_style = input(user, "Choose your character's facial-hair style:", "Character Preference") as null | anything in valid_facialhairstyles
					if(new_f_style)
						f_style = new_f_style

				if("underwear")
					var/list/underwear_options
					if(gender == MALE)
						underwear_options = GLOBL.underwear_m
					else
						underwear_options = GLOBL.underwear_f

					var/new_underwear = input(user, "Choose your character's underwear:", "Character Preference") as null | anything in underwear_options
					if(new_underwear)
						underwear = underwear_options.Find(new_underwear)
					character_setup_panel(user)

				if("eyes")
					var/new_eyes = input(user, "Choose your character's eye colour:", "Character Preference") as color | null
					if(new_eyes)
						r_eyes = hex2num(copytext(new_eyes, 2, 4))
						g_eyes = hex2num(copytext(new_eyes, 4, 6))
						b_eyes = hex2num(copytext(new_eyes, 6, 8))

				if("s_tone")
					var/datum/species/species_instance = GLOBL.all_species[species]
					if(!HAS_SPECIES_FLAGS(species_instance, SPECIES_FLAG_HAS_SKIN_TONE))
						return
					var/new_s_tone = input(user, "Choose your character's skin-tone:\n(Light 1 - 220 Dark)", "Character Preference") as num | null
					if(new_s_tone)
						s_tone = 35 - max(min( round(new_s_tone), 220),1)

				if("skin")
					var/datum/species/species_instance = GLOBL.all_species[species]
					if(!HAS_SPECIES_FLAGS(species_instance, SPECIES_FLAG_HAS_SKIN_COLOUR))
						return
					var/new_skin = input(user, "Choose your character's skin colour: ", "Character Preference") as color | null
					if(new_skin)
						r_skin = hex2num(copytext(new_skin, 2, 4))
						g_skin = hex2num(copytext(new_skin, 4, 6))
						b_skin = hex2num(copytext(new_skin, 6, 8))

				if("ooccolor")
					var/new_ooccolor = input(user, "Choose your OOC colour:", "Game Preference") as color | null
					if(new_ooccolor)
						ooccolor = new_ooccolor

				if("bag")
					var/new_backbag = input(user, "Choose your character's style of bag:", "Character Preference") as null | anything in GLOBL.backbaglist
					if(new_backbag)
						backbag = GLOBL.backbaglist.Find(new_backbag)

				if("nt_relation")
					var/new_relation = input(user, "Choose your relation to NT. Note that this represents what others can find out about your character by researching your background, not what your character actually thinks.", "Character Preference") as null | anything in list("Loyal", "Supportive", "Neutral", "Skeptical", "Opposed")
					if(new_relation)
						nanotrasen_relation = new_relation

				if("flavor_text")
					var/msg = input(usr, "Set the flavor text in your 'examine' verb. This can also be used for OOC notes and preferences!", "Flavor Text", html_decode(flavor_text)) as message

					if(msg != null)
						msg = copytext(msg, 1, MAX_MESSAGE_LEN)
						msg = html_encode(msg)

						flavor_text = msg

				if("disabilities")
					if(text2num(href_list["disabilities"]) >= -1)
						if(text2num(href_list["disabilities"]) >= 0)
							disabilities ^= (1 << text2num(href_list["disabilities"])) //MAGIC
						SetDisabilities(user)
						return
					else
						user << browse(null, "window=disabil")

				if("limbs")
					var/limb_name = input(user, "Which limb do you want to change?") as null | anything in list("Left Leg", "Right Leg", "Left Arm", "Right Arm", "Left Foot", "Right Foot", "Left Hand", "Right Hand")
					if(!limb_name)
						return

					var/limb = null
					var/second_limb = null // if you try to change the arm, the hand should also change
					var/third_limb = null  // if you try to unchange the hand, the arm should also change
					switch(limb_name)
						if("Left Leg")
							limb = "l_leg"
							second_limb = "l_foot"
						if("Right Leg")
							limb = "r_leg"
							second_limb = "r_foot"
						if("Left Arm")
							limb = "l_arm"
							second_limb = "l_hand"
						if("Right Arm")
							limb = "r_arm"
							second_limb = "r_hand"
						if("Left Foot")
							limb = "l_foot"
							third_limb = "l_leg"
						if("Right Foot")
							limb = "r_foot"
							third_limb = "r_leg"
						if("Left Hand")
							limb = "l_hand"
							third_limb = "l_arm"
						if("Right Hand")
							limb = "r_hand"
							third_limb = "r_arm"

					var/new_state = input(user, "What state do you wish the limb to be in?") as null | anything in list("Normal", "Amputated", "Prothesis")
					if(!new_state)
						return

					switch(new_state)
						if("Normal")
							organ_data[limb] = null
							if(third_limb)
								organ_data[third_limb] = null
						if("Amputated")
							organ_data[limb] = "amputated"
							if(second_limb)
								organ_data[second_limb] = "amputated"
						if("Prothesis")
							organ_data[limb] = "cyborg"
							if(second_limb)
								organ_data[second_limb] = "cyborg"

				if("organs")
					var/organ_name = input(user, "Which internal function do you want to change?") as null | anything in list("Heart", "Eyes")
					if(!organ_name)
						return

					var/organ = null
					switch(organ_name)
						if("Heart")
							organ = "heart"
						if("Eyes")
							organ = "eyes"

					var/new_state = input(user, "What state do you wish the organ to be in?") as null | anything in list("Normal", "Assisted", "Mechanical")
					if(!new_state)
						return

					switch(new_state)
						if("Normal")
							organ_data[organ] = null
						if("Assisted")
							organ_data[organ] = "assisted"
						if("Mechanical")
							organ_data[organ] = "mechanical"

				if("skin_style")
					var/skin_style_name = input(user, "Select a new skin style.") as null | anything in list("default1", "default2", "default3")
					if(!skin_style_name)
						return

				if("spawnpoint")
					var/list/spawnkeys = list()
					for(var/S in GLOBL.spawntypes)
						spawnkeys += S
					var/choice = input(user, "Where would you like to spawn when latejoining?") as null | anything in spawnkeys
					if(!choice || !GLOBL.spawntypes[choice])
						spawnpoint = "Arrivals Shuttle"
						return
					spawnpoint = choice

		else
			switch(href_list["preference"])
				if("gender")
					if(gender == MALE)
						gender = FEMALE
					else
						gender = MALE

				if("disabilities")					//please note: current code only allows nearsightedness as a disability
					disabilities = !disabilities	//if you want to add actual disabilities, code that selects them should be here

				if("hear_adminhelps")
					toggles ^= SOUND_ADMINHELP

				if("be_special")
					var/num = text2num(href_list["num"])
					be_special ^= (1<<num)

				if("name")
					be_random_name = !be_random_name

				if("save")
					save_preferences()
					save_character()

				if("reload")
					load_preferences()
					load_character()

				if("open_load_dialog")
					if(!IsGuestKey(user.key))
						open_load_dialog(user)

				if("close_load_dialog")
					close_load_dialog(user)

				if("changeslot")
					load_character(text2num(href_list["num"]))
					close_load_dialog(user)

	character_setup_panel(user)
	return 1