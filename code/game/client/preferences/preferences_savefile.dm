#define SAVEFILE_VERSION_MIN	8
#define SAVEFILE_VERSION_MAX	11

//handles converting savefiles to new formats
//MAKE SURE YOU KEEP THIS UP TO DATE!
//If the sanity checks are capable of handling any issues. Only increase SAVEFILE_VERSION_MAX,
//this will mean that savefile_version will still be over SAVEFILE_VERSION_MIN, meaning
//this savefile update doesn't run everytime we load from the savefile.
//This is mainly for format changes, such as the bitflags in toggles changing order or something.
//if a file can't be updated, return 0 to delete it and start again
//if a file was updated, return 1
/datum/preferences/proc/savefile_update()
	if(savefile_version < 8) // Lazily delete everything + additional files so they can be saved in the new format.
		for(var/ckey in GLOBL.preferences_datums)
			var/datum/preferences/D = GLOBL.preferences_datums[ckey]
			if(D == src)
				var/delpath = "data/player_saves/[copytext(ckey, 1, 2)]/[ckey]/"
				if(delpath && fexists(delpath))
					fdel(delpath)
				break
		return FALSE

	if(savefile_version == SAVEFILE_VERSION_MAX) // Update successful.
		save_preferences()
		save_character()
		return TRUE
	return FALSE

/datum/preferences/proc/load_path(ckey, filename = "preferences.sav")
	if(isnull(ckey))
		return
	path = "data/player_saves/[copytext(ckey, 1, 2)]/[ckey]/[filename]"
	savefile_version = SAVEFILE_VERSION_MAX

/datum/preferences/proc/load_preferences()
	if(!path)
		return FALSE
	if(!fexists(path))
		return FALSE
	var/savefile/S = new /savefile(path)
	if(isnull(S))
		return FALSE

	S.cd = "/"

	FROM_SAVEFILE(S, "version", savefile_version)
	// Conversion.
	if(!savefile_version || !isnum(savefile_version) || savefile_version < SAVEFILE_VERSION_MIN || savefile_version > SAVEFILE_VERSION_MAX)
		if(!savefile_update()) // Handles updates.
			savefile_version = SAVEFILE_VERSION_MAX
			save_preferences()
			save_character()
			return FALSE

	// General preferences.
	FROM_SAVEFILE(S, "ooccolor", ooccolor)
	FROM_SAVEFILE(S, "lastchangelog", lastchangelog)
	FROM_SAVEFILE(S, "UI_style", UI_style)
	FROM_SAVEFILE(S, "be_special", be_special)
	FROM_SAVEFILE(S, "default_slot", default_slot)
	FROM_SAVEFILE(S, "toggles", toggles)
	FROM_SAVEFILE(S, "UI_style_color", UI_style_color)
	FROM_SAVEFILE(S, "UI_style_alpha", UI_style_alpha)
	FROM_SAVEFILE(S, "screentip_pref", screentip_pref)
	FROM_SAVEFILE(S, "screentip_colour", screentip_colour)

	// Sanitize.
	ooccolor	= sanitize_hexcolor(ooccolor, initial(ooccolor))
	lastchangelog	= sanitize_text(lastchangelog, initial(lastchangelog))
	UI_style	= sanitize_inlist(UI_style, list("White", "Midnight", "Orange", "old"), initial(UI_style))
	be_special	= sanitize_integer(be_special, 0, 65535, initial(be_special))
	default_slot	= sanitize_integer(default_slot, 1, MAX_SAVE_SLOTS, initial(default_slot))
	toggles		= sanitize_integer(toggles, 0, 65535, initial(toggles))
	UI_style_color	= sanitize_hexcolor(UI_style_color, initial(UI_style_color))
	UI_style_alpha	= sanitize_integer(UI_style_alpha, 0, 255, initial(UI_style_alpha))
	screentip_colour = sanitize_hexcolor(screentip_colour, initial(screentip_colour))

	return TRUE

/datum/preferences/proc/save_preferences()
	if(!path)
		return FALSE
	var/savefile/S = new /savefile(path)
	if(isnull(S))
		return FALSE

	S.cd = "/"

	TO_SAVEFILE(S, "version", savefile_version)

	// General preferences.
	TO_SAVEFILE(S, "ooccolor", ooccolor)
	TO_SAVEFILE(S, "lastchangelog", lastchangelog)
	TO_SAVEFILE(S, "UI_style", UI_style)
	TO_SAVEFILE(S, "be_special", be_special)
	TO_SAVEFILE(S, "default_slot", default_slot)
	TO_SAVEFILE(S, "toggles", toggles)
	TO_SAVEFILE(S, "UI_style_color", UI_style_color)
	TO_SAVEFILE(S, "UI_style_alpha", UI_style_alpha)
	TO_SAVEFILE(S, "screentip_pref", screentip_pref)
	TO_SAVEFILE(S, "screentip_colour", screentip_colour)

	return TRUE

/datum/preferences/proc/load_character(slot)
	if(!path)
		return FALSE
	if(!fexists(path))
		return FALSE
	var/savefile/S = new /savefile(path)
	if(isnull(S))
		return FALSE

	S.cd = "/"
	if(!slot)
		slot = default_slot
	slot = sanitize_integer(slot, 1, MAX_SAVE_SLOTS, initial(default_slot))
	if(slot != default_slot)
		default_slot = slot
		TO_SAVEFILE(S, "default_slot", slot)
	S.cd = "/character[slot]"

	// Character.
	FROM_SAVEFILE(S, "OOC_Notes", metadata)
	FROM_SAVEFILE(S, "real_name", real_name)
	FROM_SAVEFILE(S, "name_is_always_random", be_random_name)
	FROM_SAVEFILE(S, "gender", gender)
	FROM_SAVEFILE(S, "age", age)
	FROM_SAVEFILE(S, "species", species)
	FROM_SAVEFILE(S, "language", secondary_language)
	FROM_SAVEFILE(S, "spawnpoint", spawnpoint)

	// Colours to be consolidated into hex strings (requires some work with dna code).
	FROM_SAVEFILE(S, "hair_red", r_hair)
	FROM_SAVEFILE(S, "hair_green", g_hair)
	FROM_SAVEFILE(S, "hair_blue", b_hair)
	FROM_SAVEFILE(S, "facial_red", r_facial)
	FROM_SAVEFILE(S, "facial_green", g_facial)
	FROM_SAVEFILE(S, "facial_blue", b_facial)
	FROM_SAVEFILE(S, "skin_tone", s_tone)
	FROM_SAVEFILE(S, "skin_red", r_skin)
	FROM_SAVEFILE(S, "skin_green", g_skin)
	FROM_SAVEFILE(S, "skin_blue", b_skin)
	FROM_SAVEFILE(S, "hair_style_name", h_style)
	FROM_SAVEFILE(S, "facial_style_name", f_style)
	FROM_SAVEFILE(S, "eyes_red", r_eyes)
	FROM_SAVEFILE(S, "eyes_green", g_eyes)
	FROM_SAVEFILE(S, "eyes_blue", b_eyes)
	FROM_SAVEFILE(S, "underwear", underwear)
	FROM_SAVEFILE(S, "backbag", backbag)
	FROM_SAVEFILE(S, "b_type", b_type)

	// Jobs.
	FROM_SAVEFILE(S, "alternate_option", alternate_option)
	for_no_type_check(var/decl/department/dep, GET_DECL_SUBTYPE_INSTANCES(/decl/department))
		var/dep_name = lowertext(dep.name)
		FROM_SAVEFILE(S, "job_[dep_name]_high", job_by_department_high[dep.type])
		FROM_SAVEFILE(S, "job_[dep_name]_med", job_by_department_med[dep.type])
		FROM_SAVEFILE(S, "job_[dep_name]_low", job_by_department_low[dep.type])

	// Miscellaneous.
	FROM_SAVEFILE(S, "flavor_text", flavor_text)
	FROM_SAVEFILE(S, "med_record", med_record)
	FROM_SAVEFILE(S, "sec_record", sec_record)
	FROM_SAVEFILE(S, "gen_record", gen_record)
	FROM_SAVEFILE(S, "player_alt_titles", player_alt_titles)
	FROM_SAVEFILE(S, "be_special", be_special)
	FROM_SAVEFILE(S, "disabilities", disabilities)
	FROM_SAVEFILE(S, "used_skillpoints", used_skillpoints)
	FROM_SAVEFILE(S, "skills", skills)
	FROM_SAVEFILE(S, "skill_specialization", skill_specialization)
	FROM_SAVEFILE(S, "organ_data", organ_data)

	FROM_SAVEFILE(S, "nanotrasen_relation", nanotrasen_relation)
	//FROM_SAVEFILE(S, "skin_style", skin_style)

	FROM_SAVEFILE(S, "uplinklocation", uplinklocation)

	// Sanitize.
	metadata		= sanitize_text(metadata, initial(metadata))
	real_name		= reject_bad_name(real_name)
	if(isnull(species))
		species = SPECIES_HUMAN
	if(isnull(secondary_language))
		secondary_language = "None"
	if(isnull(spawnpoint))
		spawnpoint = "Arrivals Shuttle"
	if(isnull(nanotrasen_relation))
		nanotrasen_relation = initial(nanotrasen_relation)
	if(!real_name)
		real_name = random_name(gender)
	be_random_name	= sanitize_integer(be_random_name, FALSE, TRUE, initial(be_random_name))
	gender			= sanitize_gender(gender)
	age				= sanitize_integer(age, AGE_MIN, AGE_MAX, initial(age))
	r_hair			= sanitize_integer(r_hair, 0, 255, initial(r_hair))
	g_hair			= sanitize_integer(g_hair, 0, 255, initial(g_hair))
	b_hair			= sanitize_integer(b_hair, 0, 255, initial(b_hair))
	r_facial		= sanitize_integer(r_facial, 0, 255, initial(r_facial))
	g_facial		= sanitize_integer(g_facial, 0, 255, initial(g_facial))
	b_facial		= sanitize_integer(b_facial, 0, 255, initial(b_facial))
	s_tone			= sanitize_integer(s_tone, -185, 34, initial(s_tone))
	r_skin			= sanitize_integer(r_skin, 0, 255, initial(r_skin))
	g_skin			= sanitize_integer(g_skin, 0, 255, initial(g_skin))
	b_skin			= sanitize_integer(b_skin, 0, 255, initial(b_skin))
	h_style			= sanitize_inlist(h_style, GLOBL.hair_styles_list, initial(h_style))
	f_style			= sanitize_inlist(f_style, GLOBL.facial_hair_styles_list, initial(f_style))
	r_eyes			= sanitize_integer(r_eyes, 0, 255, initial(r_eyes))
	g_eyes			= sanitize_integer(g_eyes, 0, 255, initial(g_eyes))
	b_eyes			= sanitize_integer(b_eyes, 0, 255, initial(b_eyes))
	underwear		= sanitize_integer(underwear, 1, length(GLOBL.underwear_m), initial(underwear))
	backbag			= sanitize_integer(backbag, 1, length(GLOBL.backbaglist), initial(backbag))
	b_type			= sanitize_text(b_type, initial(b_type))
	preview_icon = null

	alternate_option = sanitize_integer(alternate_option, 0, 2, initial(alternate_option))
	for(var/path in subtypesof(/decl/department))
		job_by_department_high[path] = sanitize_integer(job_by_department_high[path], 0, 65535, initial(job_by_department_high[path]))
		job_by_department_med[path] = sanitize_integer(job_by_department_med[path], 0, 65535, initial(job_by_department_med[path]))
		job_by_department_low[path] = sanitize_integer(job_by_department_low[path], 0, 65535, initial(job_by_department_low[path]))

	LAZYINITLIST(skills)
	if(!used_skillpoints)
		used_skillpoints = 0
	if(!disabilities)
		disabilities = 0
	LAZYINITLIST(player_alt_titles)
	LAZYINITLIST(organ_data)
	//if(!skin_style) skin_style = "Default"

	return TRUE

/datum/preferences/proc/save_character()
	if(!path)
		return FALSE
	var/savefile/S = new /savefile(path)
	if(isnull(S))
		return FALSE

	S.cd = "/character[default_slot]"

	// Character.
	TO_SAVEFILE(S, "OOC_Notes", metadata)
	TO_SAVEFILE(S, "real_name", real_name)
	TO_SAVEFILE(S, "name_is_always_random", be_random_name)
	TO_SAVEFILE(S, "gender", gender)
	TO_SAVEFILE(S, "age", age)
	TO_SAVEFILE(S, "species", species)
	TO_SAVEFILE(S, "language", secondary_language)
	TO_SAVEFILE(S, "hair_red", r_hair)
	TO_SAVEFILE(S, "hair_green", g_hair)
	TO_SAVEFILE(S, "hair_blue", b_hair)
	TO_SAVEFILE(S, "facial_red", r_facial)
	TO_SAVEFILE(S, "facial_green", g_facial)
	TO_SAVEFILE(S, "facial_blue", b_facial)
	TO_SAVEFILE(S, "skin_tone", s_tone)
	TO_SAVEFILE(S, "skin_red", r_skin)
	TO_SAVEFILE(S, "skin_green", g_skin)
	TO_SAVEFILE(S, "skin_blue", b_skin)
	TO_SAVEFILE(S, "hair_style_name", h_style)
	TO_SAVEFILE(S, "facial_style_name", f_style)
	TO_SAVEFILE(S, "eyes_red", r_eyes)
	TO_SAVEFILE(S, "eyes_green", g_eyes)
	TO_SAVEFILE(S, "eyes_blue", b_eyes)
	TO_SAVEFILE(S, "underwear", underwear)
	TO_SAVEFILE(S, "backbag", backbag)
	TO_SAVEFILE(S, "b_type", b_type)

	// Jobs.
	TO_SAVEFILE(S, "alternate_option", alternate_option)
	for_no_type_check(var/decl/department/dep, GET_DECL_SUBTYPE_INSTANCES(/decl/department))
		var/dep_name = lowertext(dep.name)
		TO_SAVEFILE(S, "job_[dep_name]_high", job_by_department_high[dep.type])
		TO_SAVEFILE(S, "job_[dep_name]_med", job_by_department_med[dep.type])
		TO_SAVEFILE(S, "job_[dep_name]_low", job_by_department_low[dep.type])

	// Miscellaneous.
	TO_SAVEFILE(S, "flavor_text", flavor_text)
	TO_SAVEFILE(S, "med_record", med_record)
	TO_SAVEFILE(S, "sec_record", sec_record)
	TO_SAVEFILE(S, "gen_record", gen_record)
	TO_SAVEFILE(S, "player_alt_titles", player_alt_titles)
	TO_SAVEFILE(S, "be_special", be_special)
	TO_SAVEFILE(S, "disabilities", disabilities)
	TO_SAVEFILE(S, "used_skillpoints", used_skillpoints)
	TO_SAVEFILE(S, "skills", skills)
	TO_SAVEFILE(S, "skill_specialization", skill_specialization)
	TO_SAVEFILE(S, "organ_data", organ_data)

	TO_SAVEFILE(S, "nanotrasen_relation", nanotrasen_relation)
	//TO_SAVEFILE(S, "skin_style", skin_style)

	TO_SAVEFILE(S, "uplinklocation", uplinklocation)

	return TRUE

#undef SAVEFILE_VERSION_MAX
#undef SAVEFILE_VERSION_MIN