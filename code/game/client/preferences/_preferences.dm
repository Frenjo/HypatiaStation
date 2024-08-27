//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/datum/preferences
	//doohickeys for savefiles
	var/path
	var/default_slot = 1				//Holder so it doesn't default to slot 1, rather the last one used
	var/savefile_version = 0

	//non-preference stuff
	var/warns = 0
	var/muted = 0
	var/last_ip
	var/last_id

	//game-preferences
	var/lastchangelog = ""				//Saved changlog filesize to detect if there was a change
	var/ooccolor = "#b82e00"
	var/be_special = 0					//Special role selection
	var/UI_style = "Midnight"
	var/toggles = TOGGLES_DEFAULT
	var/UI_style_color = "#ffffff"
	var/UI_style_alpha = 255

	//character preferences
	var/real_name						//our character's name
	var/be_random_name = FALSE			//whether we are a random name every round
	var/gender = MALE					//gender of character (well duh)
	var/age = 30						//age of character
	var/spawnpoint = "Arrivals Shuttle" //where this character will spawn (0-2).
	var/b_type = "A+"					//blood type (not-chooseable)
	var/underwear = 1					//underwear type
	var/backbag = 2						//backpack type
	var/h_style = "Bald"				//Hair type
	var/r_hair = 0						//Hair color
	var/g_hair = 0						//Hair color
	var/b_hair = 0						//Hair color
	var/f_style = "Shaved"				//Face hair type
	var/r_facial = 0					//Face hair color
	var/g_facial = 0					//Face hair color
	var/b_facial = 0					//Face hair color
	var/s_tone = 0						//Skin tone
	var/r_skin = 0						//Skin color
	var/g_skin = 0						//Skin color
	var/b_skin = 0						//Skin color
	var/r_eyes = 0						//Eye color
	var/g_eyes = 0						//Eye color
	var/b_eyes = 0						//Eye color
	var/species = SPECIES_HUMAN
	var/secondary_language = "None"		//Secondary language

	//Mob preview
	var/icon/preview_icon = null
	var/icon/preview_icon_front = null
	var/icon/preview_icon_side = null

	// Jobs, now slightly more modular.
	// Needs to be finished and is still hardcoded in a few places.
	var/list/job_by_department_high = list()
	var/list/job_by_department_med = list()
	var/list/job_by_department_low = list()

	//Keeps track of preference for not getting any wanted jobs
	var/alternate_option = BE_ASSISTANT

	var/used_skillpoints = 0
	var/skill_specialization = null
	var/list/skills = list() // skills can range from 0 to 3

	// maps each organ to either null(intact), "cyborg" or "amputated"
	// will probably not be able to do this for head and torso ;)
	var/list/organ_data = list()

	var/list/player_alt_titles = list()		// the default name of a job like "Medical Doctor"

	var/flavor_text = ""
	var/med_record = ""
	var/sec_record = ""
	var/gen_record = ""
	var/disabilities = 0

	var/nanotrasen_relation = "Neutral"

	var/uplinklocation = "PDA"

	// OOC Metadata:
	var/metadata = ""
	var/slot_name = ""

/datum/preferences/New(client/C)
	if(istype(C))
		if(!IsGuestKey(C.key))
			load_path(C.ckey)
			if(load_preferences())
				if(load_character())
					return
	gender = pick(MALE, FEMALE)
	real_name = random_name(gender)
	randomize_appearance_for()
	age = rand(25, 35)
	b_type = pick(4;"O-", 36;"O+", 3;"A-", 28;"A+", 1;"B-", 20;"B+", 1;"AB-", 5;"AB+")

/datum/preferences/proc/SetDisabilities(mob/user)
	var/dat = "<body>"
	dat += "<tt><center>"
	dat += "<b>Choose disabilities</b><br>"

	dat += "Need Glasses? <a href=\"byond://?src=\ref[user];preferences=1;disabilities=0\">[disabilities & (1<<0) ? "Yes" : "No"]</a><br>"
	dat += "Seizures? <a href=\"byond://?src=\ref[user];preferences=1;disabilities=1\">[disabilities & (1<<1) ? "Yes" : "No"]</a><br>"
	dat += "Coughing? <a href=\"byond://?src=\ref[user];preferences=1;disabilities=2\">[disabilities & (1<<2) ? "Yes" : "No"]</a><br>"
	dat += "Tourettes/Twitching? <a href=\"byond://?src=\ref[user];preferences=1;disabilities=3\">[disabilities & (1<<3) ? "Yes" : "No"]</a><br>"
	dat += "Nervousness? <a href=\"byond://?src=\ref[user];preferences=1;disabilities=4\">[disabilities & (1<<4) ? "Yes" : "No"]</a><br>"
	dat += "Deafness? <a href=\"byond://?src=\ref[user];preferences=1;disabilities=5\">[disabilities & (1<<5) ? "Yes" : "No"]</a><br>"

	dat += "<br>"
	dat += "<a href=\"byond://?src=\ref[user];preferences=1;disabilities=-2\">\[Done\]</a>"
	dat += "</center></tt>"

	user << browse(null, "window=preferences")
	user << browse(dat, "window=disabil;size=350x300")

/datum/preferences/proc/set_records(mob/user)
	var/html = "<div align='center'><b>Set Character Records</b>"
	html += "<hr>"

	html += "<a href=\"byond://?src=\ref[user];preference=records;task=med_record\">Medical Records</a><br>"
	if(length(med_record) <= 40)
		html += "[med_record]"
	else
		html += "[copytext(med_record, 1, 37)]..."

	html += "<br><br><a href=\"byond://?src=\ref[user];preference=records;task=gen_record\">Employment Records</a><br>"
	if(length(gen_record) <= 40)
		html += "[gen_record]"
	else
		html += "[copytext(gen_record, 1, 37)]..."

	html += "<br><br><a href=\"byond://?src=\ref[user];preference=records;task=sec_record\">Security Records</a><br>"
	if(length(sec_record) <= 40)
		html += "[sec_record]<br>"
	else
		html += "[copytext(sec_record, 1, 37)]...<br>"

	html += "<br>"
	html += "<hr>"
	html += "<a href=\"byond://?src=\ref[user];preference=records;records=-1\">\[Done\]</a>"
	html += "</div>"

	user << browse(null, "window=preferences")
	var/datum/browser/panel = new /datum/browser(user, "records", "", 350, 300)
	panel.set_content(html)
	panel.open()

/datum/preferences/proc/SetAntagoptions(mob/user)
	if(uplinklocation == "")
		uplinklocation = "PDA"

	var/dat = "<body>"
	dat += "<tt><center>"
	dat += "<b>Antagonist Options</b> <hr />"
	dat += "<br>"
	dat +="Uplink Type : <b><a href='byond://?src=\ref[user];preference=antagoptions;antagtask=uplinktype;active=1'>[uplinklocation]</a></b>"
	dat +="<br>"
	dat +="<hr />"
	dat +="<a href='byond://?src=\ref[user];preference=antagoptions;antagtask=done;active=1'>\[Done\]</a>"

	dat += "</center></tt>"

	user << browse(null, "window=preferences")
	user << browse(dat, "window=antagoptions")

/datum/preferences/proc/process_link(mob/user, list/href_list)
	if(isnull(user))
		return
	if(!isnewplayer(user))
		return

	if(href_list["preference"] == "job")
		switch(href_list["task"])
			if("close")
				user << browse(null, "window=mob_occupation")
				character_setup_panel(user)
			if("reset")
				ResetJobs()
				SetChoices(user)
			if("random")
				if(alternate_option == GET_RANDOM_JOB || alternate_option == BE_ASSISTANT)
					alternate_option += 1
				else if(alternate_option == RETURN_TO_LOBBY)
					alternate_option = 0
				else
					return 0
				SetChoices(user)
			if("alt_title")
				var/datum/job/job = locate(href_list["job"])
				if(job)
					var/choices = list(job.title) + job.alt_titles
					var/choice = input("Pick a title for [job.title].", "Character Generation", GetPlayerAltTitle(job)) as anything in choices | null
					if(choice)
						SetPlayerAltTitle(job, choice)
						SetChoices(user)
			if("input")
				SetJob(user, href_list["text"])
			else
				SetChoices(user)
		return 1
	else if(href_list["preference"] == "skills")
		if(href_list["cancel"])
			user << browse(null, "window=show_skills")
			character_setup_panel(user)
		else if(href_list["skillinfo"])
			var/datum/skill/S = locate(href_list["skillinfo"])
			var/HTML = "<b>[S.name]</b><br>[S.desc]"
			user << browse(HTML, "window=\ref[user]skillinfo")
		else if(href_list["setskill"])
			var/datum/skill/S = locate(href_list["setskill"])
			var/value = text2num(href_list["newvalue"])
			skills[S.id] = value
			CalculateSkillPoints()
			set_skills_panel(user)
		else if(href_list["preconfigured"])
			var/selected = input(user, "Select a skillset", "Skillset") as null | anything in GLOBL.skill_presets
			if(!selected)
				return

			ZeroSkills(1)
			for(var/V in GLOBL.skill_presets[selected])
				if(V == "field")
					skill_specialization = GLOBL.skill_presets[selected]["field"]
					continue
				skills[V] = GLOBL.skill_presets[selected][V]
			CalculateSkillPoints()

			set_skills_panel(user)
		else if(href_list["setspecialization"])
			skill_specialization = href_list["setspecialization"]
			CalculateSkillPoints()
			set_skills_panel(user)
		else
			set_skills_panel(user)
		return 1

	else if(href_list["preference"] == "records")
		if(text2num(href_list["record"]) >= 1)
			set_records(user)
			return
		else
			user << browse(null, "window=records")
		if(href_list["task"] == "med_record")
			var/medmsg = input(usr,"Set your medical notes here.", "Medical Records", html_decode(med_record)) as message

			if(medmsg != null)
				medmsg = copytext(medmsg, 1, MAX_PAPER_MESSAGE_LEN)
				medmsg = html_encode(medmsg)

				med_record = medmsg
				set_records(user)

		if(href_list["task"] == "sec_record")
			var/secmsg = input(usr, "Set your security notes here.", "Security Records", html_decode(sec_record)) as message

			if(secmsg != null)
				secmsg = copytext(secmsg, 1, MAX_PAPER_MESSAGE_LEN)
				secmsg = html_encode(secmsg)

				sec_record = secmsg
				set_records(user)
		if(href_list["task"] == "gen_record")
			var/genmsg = input(usr, "Set your employment notes here.", "Employment Records", html_decode(gen_record)) as message

			if(genmsg != null)
				genmsg = copytext(genmsg, 1, MAX_PAPER_MESSAGE_LEN)
				genmsg = html_encode(genmsg)

				gen_record = genmsg
				set_records(user)

	else if(href_list["preference"] == "antagoptions")
		if(text2num(href_list["active"]) == 0)
			SetAntagoptions(user)
			return
		if(href_list["antagtask"] == "uplinktype")
			if(uplinklocation == "PDA")
				uplinklocation = "Headset"
			else if(uplinklocation == "Headset")
				uplinklocation = "None"
			else
				uplinklocation = "PDA"
			SetAntagoptions(user)
		if(href_list["antagtask"] == "done")
			user << browse(null, "window=antagoptions")
			character_setup_panel(user)
		return 1

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

				if("ui")
					switch(UI_style)
						if("Midnight")
							UI_style = "Orange"
						if("Orange")
							UI_style = "old"
						if("old")
							UI_style = "White"
						else
							UI_style = "Midnight"

				if("UIcolor")
					var/UI_style_color_new = input(user, "Choose your UI color, dark colors are not recommended!") as color | null
					if(!UI_style_color_new)
						return
					UI_style_color = UI_style_color_new

				if("UIalpha")
					var/UI_style_alpha_new = input(user, "Select a new alpha(transparency) parameter for UI, between 50 and 255.") as num
					if(!UI_style_alpha_new || !(UI_style_alpha_new <= 255 && UI_style_alpha_new >= 50))
						return
					UI_style_alpha = UI_style_alpha_new

				if("be_special")
					var/num = text2num(href_list["num"])
					be_special ^= (1<<num)

				if("name")
					be_random_name = !be_random_name

				if("hear_midis")
					toggles ^= SOUND_MIDI

				if("lobby_music")
					toggles ^= SOUND_LOBBY
					if(toggles & SOUND_LOBBY)
						global.PCticker.lobby_music.play(user)
					else
						global.PCticker.lobby_music.stop(user)

				if("ghost_ears")
					toggles ^= CHAT_GHOSTEARS

				if("ghost_sight")
					toggles ^= CHAT_GHOSTSIGHT

				if("ghost_radio")
					toggles ^= CHAT_GHOSTRADIO

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

/datum/preferences/proc/copy_to(mob/living/carbon/human/character, safety = 0)
	if(be_random_name)
		real_name = random_name(gender)

	if(CONFIG_GET(humans_need_surnames))
		var/firstspace = findtext(real_name, " ")
		var/name_length = length(real_name)
		if(!firstspace) // We need a surname.
			real_name += " [pick(GLOBL.last_names)]"
		else if(firstspace == name_length)
			real_name += "[pick(GLOBL.last_names)]"

	character.real_name = real_name
	character.name = character.real_name
	if(character.dna)
		character.dna.real_name = character.real_name

	character.flavor_text = flavor_text
	character.med_record = med_record
	character.sec_record = sec_record
	character.gen_record = gen_record

	character.gender = gender
	character.age = age
	character.b_type = b_type

	character.r_eyes = r_eyes
	character.g_eyes = g_eyes
	character.b_eyes = b_eyes

	character.r_hair = r_hair
	character.g_hair = g_hair
	character.b_hair = b_hair

	character.r_facial = r_facial
	character.g_facial = g_facial
	character.b_facial = b_facial

	character.r_skin = r_skin
	character.g_skin = g_skin
	character.b_skin = b_skin

	character.s_tone = s_tone

	character.h_style = h_style
	character.f_style = f_style

	character.skills = skills

	// Destroy/cyborgize organs.
	for(var/name in organ_data)
		var/datum/organ/external/O = character.organs_by_name[name]
		var/datum/organ/internal/I = character.internal_organs_by_name[name]
		var/status = organ_data[name]

		if(isnull(I) || isnull(O))
			continue

		if(status == "amputated")
			O.amputated = 1
			O.status |= ORGAN_DESTROYED
			O.destspawn = 1
		if(status == "cyborg")
			O.status |= ORGAN_ROBOT
		if(status == "assisted")
			I.mechassist()
		else if(status == "mechanical")
			I.mechanize()
		else
			continue

	if(underwear > length(GLOBL.underwear_m) || underwear < 1)
		underwear = 0 // I'm sure this is 100% unnecessary, but I'm paranoid... sue me. //HAH NOW NO MORE MAGIC CLONING UNDIES
	character.underwear = underwear

	if(backbag > 4 || backbag < 1)
		backbag = 1 // Same as above.
	character.backbag = backbag

	//Debugging report to track down a bug, which randomly assigned the plural gender to people.
	if(character.gender in list(PLURAL, NEUTER))
		if(isliving(src)) //Ghosts get neuter by default
			message_admins("[character] ([character.ckey]) has spawned with their gender as plural or neuter. Please notify coders.")
			character.gender = MALE

/datum/preferences/proc/open_load_dialog(mob/user)
	var/dat = "<body>"
	dat += "<tt><center>"

	var/savefile/S = new /savefile(path)
	if(isnotnull(S))
		dat += "<b>Select a character slot to load</b><hr>"
		var/name
		for(var/i = 1, i <= MAX_SAVE_SLOTS, i++)
			S.cd = "/character[i]"
			S["real_name"] >> name
			if(!name)
				name = "Character[i]"
			if(i == default_slot)
				name = "<b>[name]</b>"
			dat += "<a href='byond://?_src_=prefs;preference=changeslot;num=[i];'>[name]</a><br>"

	dat += "<hr>"
	dat += "<a href='byond://?src=\ref[user];preference=close_load_dialog'>Close</a><br>"
	dat += "</center></tt>"
	user << browse(dat, "window=saves;size=300x390")

/datum/preferences/proc/close_load_dialog(mob/user)
	user << browse(null, "window=saves")