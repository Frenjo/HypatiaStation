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
	if(!ckey)
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

	S["version"] >> savefile_version
	// Conversion.
	if(!savefile_version || !isnum(savefile_version) || savefile_version < SAVEFILE_VERSION_MIN || savefile_version > SAVEFILE_VERSION_MAX)
		if(!savefile_update()) // Handles updates.
			savefile_version = SAVEFILE_VERSION_MAX
			save_preferences()
			save_character()
			return FALSE

	// General preferences.
	S["ooccolor"]		>> ooccolor
	S["lastchangelog"]	>> lastchangelog
	S["UI_style"]		>> UI_style
	S["be_special"]		>> be_special
	S["default_slot"]	>> default_slot
	S["toggles"]		>> toggles
	S["UI_style_color"]	>> UI_style_color
	S["UI_style_alpha"]	>> UI_style_alpha

	// Sanitize.
	ooccolor		= sanitize_hexcolor(ooccolor, initial(ooccolor))
	lastchangelog	= sanitize_text(lastchangelog, initial(lastchangelog))
	UI_style		= sanitize_inlist(UI_style, list("White", "Midnight", "Orange", "old"), initial(UI_style))
	be_special		= sanitize_integer(be_special, 0, 65535, initial(be_special))
	default_slot	= sanitize_integer(default_slot, 1, MAX_SAVE_SLOTS, initial(default_slot))
	toggles			= sanitize_integer(toggles, 0, 65535, initial(toggles))
	UI_style_color	= sanitize_hexcolor(UI_style_color, initial(UI_style_color))
	UI_style_alpha	= sanitize_integer(UI_style_alpha, 0, 255, initial(UI_style_alpha))

	return TRUE

/datum/preferences/proc/save_preferences()
	if(!path)
		return FALSE
	var/savefile/S = new /savefile(path)
	if(isnull(S))
		return FALSE

	S.cd = "/"

	S["version"] << savefile_version

	// General preferences.
	S["ooccolor"]		<< ooccolor
	S["lastchangelog"]	<< lastchangelog
	S["UI_style"]		<< UI_style
	S["be_special"]		<< be_special
	S["default_slot"]	<< default_slot
	S["toggles"]		<< toggles
	S["UI_style_color"]	<< UI_style_color
	S["UI_style_alpha"]	<< UI_style_alpha

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
		S["default_slot"] << slot
	S.cd = "/character[slot]"

	// Character.
	S["OOC_Notes"]			>> metadata
	S["real_name"]			>> real_name
	S["name_is_always_random"] >> be_random_name
	S["gender"]				>> gender
	S["age"]				>> age
	S["species"]			>> species
	S["language"]			>> secondary_language
	S["spawnpoint"]			>> spawnpoint

	// Colours to be consolidated into hex strings (requires some work with dna code).
	S["hair_red"]			>> r_hair
	S["hair_green"]			>> g_hair
	S["hair_blue"]			>> b_hair
	S["facial_red"]			>> r_facial
	S["facial_green"]		>> g_facial
	S["facial_blue"]		>> b_facial
	S["skin_tone"]			>> s_tone
	S["skin_red"]			>> r_skin
	S["skin_green"]			>> g_skin
	S["skin_blue"]			>> b_skin
	S["hair_style_name"]	>> h_style
	S["facial_style_name"]	>> f_style
	S["eyes_red"]			>> r_eyes
	S["eyes_green"]			>> g_eyes
	S["eyes_blue"]			>> b_eyes
	S["underwear"]			>> underwear
	S["backbag"]			>> backbag
	S["b_type"]				>> b_type

	// Jobs.
	S["alternate_option"]	>> alternate_option
	S["job_civilian_high"]	>> job_civilian_high
	S["job_civilian_med"]	>> job_civilian_med
	S["job_civilian_low"]	>> job_civilian_low
	S["job_medsci_high"]	>> job_medsci_high
	S["job_medsci_med"]		>> job_medsci_med
	S["job_medsci_low"]		>> job_medsci_low
	S["job_engsec_high"]	>> job_engsec_high
	S["job_engsec_med"]		>> job_engsec_med
	S["job_engsec_low"]		>> job_engsec_low

	// Miscellaneous.
	S["flavor_text"]		>> flavor_text
	S["med_record"]			>> med_record
	S["sec_record"]			>> sec_record
	S["gen_record"]			>> gen_record
	S["be_special"]			>> be_special
	S["disabilities"]		>> disabilities
	S["player_alt_titles"]		>> player_alt_titles
	S["used_skillpoints"]	>> used_skillpoints
	S["skills"]				>> skills
	S["skill_specialization"] >> skill_specialization
	S["organ_data"]			>> organ_data

	S["nanotrasen_relation"] >> nanotrasen_relation
	//S["skin_style"]			>> skin_style

	S["uplinklocation"] >> uplinklocation

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

	alternate_option = sanitize_integer(alternate_option, 0, 2, initial(alternate_option))
	job_civilian_high = sanitize_integer(job_civilian_high, 0, 65535, initial(job_civilian_high))
	job_civilian_med = sanitize_integer(job_civilian_med, 0, 65535, initial(job_civilian_med))
	job_civilian_low = sanitize_integer(job_civilian_low, 0, 65535, initial(job_civilian_low))
	job_medsci_high = sanitize_integer(job_medsci_high, 0, 65535, initial(job_medsci_high))
	job_medsci_med = sanitize_integer(job_medsci_med, 0, 65535, initial(job_medsci_med))
	job_medsci_low = sanitize_integer(job_medsci_low, 0, 65535, initial(job_medsci_low))
	job_engsec_high = sanitize_integer(job_engsec_high, 0, 65535, initial(job_engsec_high))
	job_engsec_med = sanitize_integer(job_engsec_med, 0, 65535, initial(job_engsec_med))
	job_engsec_low = sanitize_integer(job_engsec_low, 0, 65535, initial(job_engsec_low))

	if(isnull(skills))
		skills = list()
	if(!used_skillpoints)
		used_skillpoints = 0
	if(!disabilities)
		disabilities = 0
	if(isnull(player_alt_titles))
		player_alt_titles = list()
	if(isnull(organ_data))
		organ_data = list()
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
	S["OOC_Notes"]			<< metadata
	S["real_name"]			<< real_name
	S["name_is_always_random"] << be_random_name
	S["gender"]				<< gender
	S["age"]				<< age
	S["species"]			<< species
	S["language"]			<< secondary_language
	S["hair_red"]			<< r_hair
	S["hair_green"]			<< g_hair
	S["hair_blue"]			<< b_hair
	S["facial_red"]			<< r_facial
	S["facial_green"]		<< g_facial
	S["facial_blue"]		<< b_facial
	S["skin_tone"]			<< s_tone
	S["skin_red"]			<< r_skin
	S["skin_green"]			<< g_skin
	S["skin_blue"]			<< b_skin
	S["hair_style_name"]	<< h_style
	S["facial_style_name"]	<< f_style
	S["eyes_red"]			<< r_eyes
	S["eyes_green"]			<< g_eyes
	S["eyes_blue"]			<< b_eyes
	S["underwear"]			<< underwear
	S["backbag"]			<< backbag
	S["b_type"]				<< b_type

	// Jobs.
	S["alternate_option"]	<< alternate_option
	S["job_civilian_high"]	<< job_civilian_high
	S["job_civilian_med"]	<< job_civilian_med
	S["job_civilian_low"]	<< job_civilian_low
	S["job_medsci_high"]	<< job_medsci_high
	S["job_medsci_med"]		<< job_medsci_med
	S["job_medsci_low"]		<< job_medsci_low
	S["job_engsec_high"]	<< job_engsec_high
	S["job_engsec_med"]		<< job_engsec_med
	S["job_engsec_low"]		<< job_engsec_low

	// Miscellaneous.
	S["flavor_text"]		<< flavor_text
	S["med_record"]			<< med_record
	S["sec_record"]			<< sec_record
	S["gen_record"]			<< gen_record
	S["player_alt_titles"]		<< player_alt_titles
	S["be_special"]			<< be_special
	S["disabilities"]		<< disabilities
	S["used_skillpoints"]	<< used_skillpoints
	S["skills"]				<< skills
	S["skill_specialization"] << skill_specialization
	S["organ_data"]			<< organ_data

	S["nanotrasen_relation"] << nanotrasen_relation
	//S["skin_style"]			<< skin_style

	S["uplinklocation"] << uplinklocation

	return TRUE

#undef SAVEFILE_VERSION_MAX
#undef SAVEFILE_VERSION_MIN