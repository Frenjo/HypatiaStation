GLOBAL_GLOBL(datum/datacore/data_core)

/hook/startup/proc/create_datacore()
	. = TRUE
	GLOBL.data_core = new /datum/datacore()

/datum/datacore
	var/list/datum/data/record/general = list()
	var/list/datum/data/record/medical = list()
	var/list/datum/data/record/security = list()
	// This list tracks characters spawned in the world and cannot be modified in-game. Currently referenced by respawn_character().
	var/list/datum/data/record/locked = list()
	// This was originally a global variable, but why not just put it on the datacore since that in itself is global anyway?!
	var/list/pda_manifest = list()

/datum/datacore/proc/get_manifest(monochrome, OOC)
	var/list/heads = list()
	var/list/sec = list()
	var/list/eng = list()
	var/list/med = list()
	var/list/sci = list()
	var/list/civ = list()
	var/list/bot = list()
	var/list/misc = list()
	var/list/isactive = list()
	var/html = {"
	<head><style>
		.manifest {border-collapse:collapse;}
		.manifest td, th {border:1px solid [monochrome ? "black" : "#DEF; background-color:white; color:black"]; padding:.25em}
		.manifest th {height: 2em; [monochrome ? "border-top-width: 3px" : "background-color: #48C; color:white"]}
		.manifest tr.head th { [monochrome ? "border-top-width: 1px" : "background-color: #488;"] }
		.manifest td:first-child {text-align:right}
		.manifest tr.alt td {[monochrome?"border-top-width: 2px" : "background-color: #DEF"]}
	</style></head>
	<table class="manifest" width='350px'>
	<tr class='head'><th>Name</th><th>Rank</th><th>Activity</th></tr>
	"}
	var/even = FALSE

	// sort mobs
	for_no_type_check(var/datum/data/record/t, general)
		var/name = t.fields["name"]
		var/rank = t.fields["rank"]
		var/real_rank = t.fields["real_rank"]
		if(OOC)
			var/active = FALSE
			for_no_type_check(var/mob/M, GLOBL.player_list)
				if(M.real_name == name && M.client?.inactivity <= 10 * 60 * 10)
					active = TRUE
					break
			isactive[name] = active ? "Active" : "Inactive"
		else
			isactive[name] = t.fields["p_stat"]
			//to_world("[name]: [rank]")
			//cael - to prevent multiple appearances of a player/job combination, add a continue after each line
		var/department = FALSE
		if(real_rank in GLOBL.command_positions)
			heads[name] = rank
			department = TRUE
		if(real_rank in GLOBL.security_positions)
			sec[name] = rank
			department = TRUE
		if(real_rank in GLOBL.engineering_positions)
			eng[name] = rank
			department = TRUE
		if(real_rank in GLOBL.medical_positions)
			med[name] = rank
			department = TRUE
		if(real_rank in GLOBL.science_positions)
			sci[name] = rank
			department = TRUE
		if(real_rank in GLOBL.civilian_positions)
			civ[name] = rank
			department = TRUE
		if(real_rank in GLOBL.nonhuman_positions)
			bot[name] = rank
			department = TRUE
		if(!department && !(name in heads))
			misc[name] = rank

	var/name
	if(length(heads))
		html += "<tr><th colspan=3>Heads</th></tr>"
		for(name in heads)
			html += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[heads[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(length(sec))
		html += "<tr><th colspan=3>Security</th></tr>"
		for(name in sec)
			html += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[sec[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(length(eng))
		html += "<tr><th colspan=3>Engineering</th></tr>"
		for(name in eng)
			html += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[eng[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(length(med))
		html += "<tr><th colspan=3>Medical</th></tr>"
		for(name in med)
			html += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[med[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(length(sci))
		html += "<tr><th colspan=3>Science</th></tr>"
		for(name in sci)
			html += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[sci[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	if(length(civ))
		html += "<tr><th colspan=3>Civilian</th></tr>"
		for(name in civ)
			html += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[civ[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	// in case somebody is insane and added them to the manifest, why not
	if(length(bot))
		html += "<tr><th colspan=3>Silicon</th></tr>"
		for(name in bot)
			html += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[bot[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even
	// misc guys
	if(length(misc))
		html += "<tr><th colspan=3>Miscellaneous</th></tr>"
		for(name in misc)
			html += "<tr[even ? " class='alt'" : ""]><td>[name]</td><td>[misc[name]]</td><td>[isactive[name]]</td></tr>"
			even = !even

	html += "</table>"
	html = replacetext(html, "\n", "") // so it can be placed on paper correctly
	html = replacetext(html, "\t", "")
	return html

/*
We can't just insert in HTML into the NanoUI so we need the raw data to play with.
Instead of creating this list over and over when someone leaves their PDA open to the page
we'll only update it when it changes. The pda_manifest global list is zeroed out upon any change
using /datum/datacore/proc/manifest_inject(), or manifest_insert()
*/
/datum/datacore/proc/get_manifest_json()
	if(length(pda_manifest))
		return pda_manifest

	var/list/heads = list()
	var/list/sec = list()
	var/list/eng = list()
	var/list/med = list()
	var/list/sci = list()
	var/list/civ = list()
	var/list/bot = list()
	var/list/misc = list()

	for_no_type_check(var/datum/data/record/t, general)
		var/name = sanitize(t.fields["name"])
		var/rank = sanitize(t.fields["rank"])
		var/real_rank = t.fields["real_rank"]
		var/isactive = t.fields["p_stat"]
		var/department = 0
		var/depthead = 0			// Department Heads will be placed at the top of their lists.
		if(real_rank in GLOBL.command_positions)
			heads[++heads.len] = list("name" = name, "rank" = rank, "active" = isactive)
			department = 1
			depthead = 1
			if(rank == "Captain" && length(heads) != 1)
				heads.Swap(1, length(heads))

		if(real_rank in GLOBL.security_positions)
			sec[++sec.len] = list("name" = name, "rank" = rank, "active" = isactive)
			department = 1
			if(depthead && length(sec) != 1)
				sec.Swap(1, length(sec))

		if(real_rank in GLOBL.engineering_positions)
			eng[++eng.len] = list("name" = name, "rank" = rank, "active" = isactive)
			department = 1
			if(depthead && length(eng) != 1)
				eng.Swap(1, length(eng))

		if(real_rank in GLOBL.medical_positions)
			med[++med.len] = list("name" = name, "rank" = rank, "active" = isactive)
			department = 1
			if(depthead && length(med) != 1)
				med.Swap(1, length(med))

		if(real_rank in GLOBL.science_positions)
			sci[++sci.len] = list("name" = name, "rank" = rank, "active" = isactive)
			department = 1
			if(depthead && length(sci) != 1)
				sci.Swap(1, length(sci))

		if(real_rank in GLOBL.civilian_positions)
			civ[++civ.len] = list("name" = name, "rank" = rank, "active" = isactive)
			department = 1
			if(depthead && length(civ) != 1)
				civ.Swap(1, length(civ))

		if(real_rank in GLOBL.nonhuman_positions)
			bot[++bot.len] = list("name" = name, "rank" = rank, "active" = isactive)
			department = 1

		if(!department && !(name in heads))
			misc[++misc.len] = list("name" = name, "rank" = rank, "active" = isactive)

	pda_manifest = list(
		"heads" = heads,
		"sec" = sec,
		"eng" = eng,
		"med" = med,
		"sci" = sci,
		"civ" = civ,
		"bot" = bot,
		"misc" = misc
	)
	return pda_manifest

/datum/datacore/proc/manifest()
	for(var/mob/living/carbon/human/H in GLOBL.player_list)
		manifest_inject(H)

/datum/datacore/proc/manifest_modify(name, assignment)
	if(length(pda_manifest))
		pda_manifest.Cut()

	var/datum/data/record/foundrecord
	var/real_title = assignment
	for_no_type_check(var/datum/data/record/t, general)
		if(isnotnull(t))
			if(t.fields["name"] == name)
				foundrecord = t
				break

	for_no_type_check(var/datum/job/J, get_job_datums())
		var/list/alttitles = get_alternate_titles(J.title)
		if(isnull(J))
			continue
		if(assignment in alttitles)
			real_title = J.title
			break

	if(isnotnull(foundrecord))
		foundrecord.fields["rank"] = assignment
		foundrecord.fields["real_rank"] = real_title

/datum/datacore/proc/manifest_inject(mob/living/carbon/human/H)
	if(length(pda_manifest))
		pda_manifest.Cut()

	if(isnotnull(H.mind) && (H.mind.assigned_role != "MODE"))
		var/assignment
		if(isnotnull(H.mind.role_alt_title))
			assignment = H.mind.role_alt_title
		else if(H.mind.assigned_role)
			assignment = H.mind.assigned_role
		else if(H.job)
			assignment = H.job
		else
			assignment = "Unassigned"

		var/id = add_zero(num2hex(rand(1, 1.6777215E7)), 6)	//this was the best they could come up with? A large random number? *sigh*

		//General Record
		var/datum/data/record/G = new /datum/data/record()
		G.fields["id"]			= id
		G.fields["name"]		= H.real_name
		G.fields["real_rank"]	= H.mind.assigned_role
		G.fields["rank"]		= assignment
		G.fields["age"]			= H.age
		G.fields["fingerprint"]	= md5(H.dna.uni_identity)
		G.fields["p_stat"]		= "Active"
		G.fields["m_stat"]		= "Stable"
		G.fields["sex"]			= H.gender
		G.fields["species"]		= H.get_species()
		G.fields["photo"]		= get_id_photo(H)
		if(H.gen_record && !jobban_isbanned(H, "Records"))
			G.fields["notes"] = H.gen_record
		else
			G.fields["notes"] = "No notes found."
		general.Add(G)

		//Medical Record
		var/datum/data/record/M = new /datum/data/record()
		M.fields["id"]			= id
		M.fields["name"]		= H.real_name
		M.fields["b_type"]		= H.b_type
		M.fields["b_dna"]		= H.dna.unique_enzymes
		M.fields["mi_dis"]		= "None"
		M.fields["mi_dis_d"]	= "No minor disabilities have been declared."
		M.fields["ma_dis"]		= "None"
		M.fields["ma_dis_d"]	= "No major disabilities have been diagnosed."
		M.fields["alg"]			= "None"
		M.fields["alg_d"]		= "No allergies have been detected in this patient."
		M.fields["cdi"]			= "None"
		M.fields["cdi_d"]		= "No diseases have been diagnosed at the moment."
		if(H.med_record && !jobban_isbanned(H, "Records"))
			M.fields["notes"] = H.med_record
		else
			M.fields["notes"] = "No notes found."
		medical.Add(M)

		//Security Record
		var/datum/data/record/S = new /datum/data/record()
		S.fields["id"]			= id
		S.fields["name"]		= H.real_name
		S.fields["criminal"]	= "None"
		S.fields["mi_crim"]		= "None"
		S.fields["mi_crim_d"]	= "No minor crime convictions."
		S.fields["ma_crim"]		= "None"
		S.fields["ma_crim_d"]	= "No major crime convictions."
		S.fields["notes"]		= "No notes."
		if(H.sec_record && !jobban_isbanned(H, "Records"))
			S.fields["notes"] = H.sec_record
		else
			S.fields["notes"] = "No notes."
		security.Add(S)

		//Locked Record
		var/datum/data/record/L = new /datum/data/record()
		L.fields["id"]			= md5("[H.real_name][H.mind.assigned_role]")
		L.fields["name"]		= H.real_name
		L.fields["rank"] 		= H.mind.assigned_role
		L.fields["age"]			= H.age
		L.fields["sex"]			= H.gender
		L.fields["b_type"]		= H.b_type
		L.fields["b_dna"]		= H.dna.unique_enzymes
		L.fields["enzymes"]		= H.dna.SE // Used in respawning
		L.fields["identity"]	= H.dna.UI // "
		L.fields["image"]		= getFlatIcon(H)	//This is god-awful
		locked.Add(L)

/proc/get_id_photo(mob/living/carbon/human/H)
	var/icon/preview_icon = null

	var/g = "m"
	if(H.gender == FEMALE)
		g = "f"

	var/icon/icobase = H.species.icobase

	preview_icon = new /icon(icobase, "torso_[g]")
	var/icon/temp
	temp = new /icon(icobase, "groin_[g]")
	preview_icon.Blend(temp, ICON_OVERLAY)
	temp = new /icon(icobase, "head_[g]")
	preview_icon.Blend(temp, ICON_OVERLAY)

	for(var/datum/organ/external/E in H.organs)
		if(E.status & ORGAN_CUT_AWAY || E.status & ORGAN_DESTROYED)
			continue
		temp = new /icon(icobase, "[E.name]")
		if(E.status & ORGAN_ROBOT)
			temp.MapColors(rgb(77, 77, 77), rgb(150, 150, 150), rgb(28, 28, 28), rgb(0, 0, 0))
		preview_icon.Blend(temp, ICON_OVERLAY)

	// Tail
	if(isnotnull(H.species.tail) && HAS_SPECIES_FLAGS(H.species, SPECIES_FLAG_HAS_TAIL))
		temp = new/icon("icon" = 'icons/effects/species.dmi', "icon_state" = "[H.species.tail]_s")
		preview_icon.Blend(temp, ICON_OVERLAY)

	// Skin tone
	if(HAS_SPECIES_FLAGS(H.species, SPECIES_FLAG_HAS_SKIN_TONE))
		if(H.s_tone >= 0)
			preview_icon.Blend(rgb(H.s_tone, H.s_tone, H.s_tone), ICON_ADD)
		else
			preview_icon.Blend(rgb(-H.s_tone,  -H.s_tone,  -H.s_tone), ICON_SUBTRACT)

	// Skin color
	if(HAS_SPECIES_FLAGS(H.species, SPECIES_FLAG_HAS_SKIN_TONE))
		if(isnull(H.species) || HAS_SPECIES_FLAGS(H.species, SPECIES_FLAG_HAS_SKIN_COLOUR))
			preview_icon.Blend(rgb(H.r_skin, H.g_skin, H.b_skin), ICON_ADD)

	var/icon/eyes_s = new/icon("icon" = 'icons/mob/on_mob/human_face.dmi', "icon_state" = H.species ? H.species.eyes : "eyes_s")

	eyes_s.Blend(rgb(H.r_eyes, H.g_eyes, H.b_eyes), ICON_ADD)

	var/datum/sprite_accessory/hair_style = GLOBL.hair_styles_list[H.h_style]
	if(isnotnull(hair_style))
		var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
		hair_s.Blend(rgb(H.r_hair, H.g_hair, H.b_hair), ICON_ADD)
		eyes_s.Blend(hair_s, ICON_OVERLAY)

	var/datum/sprite_accessory/facial_hair_style = GLOBL.facial_hair_styles_list[H.f_style]
	if(isnotnull(facial_hair_style))
		var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
		facial_s.Blend(rgb(H.r_facial, H.g_facial, H.b_facial), ICON_ADD)
		eyes_s.Blend(facial_s, ICON_OVERLAY)

	var/icon/clothes_s = null
	switch(H.mind.assigned_role)
		if("Head of Personnel")
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "hop_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "brown"), ICON_UNDERLAY)
		if("Bartender")
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "ba_suit_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "black"), ICON_UNDERLAY)
		if("Botanist")
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "hydroponics_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "black"), ICON_UNDERLAY)
		if("Chef")
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "chef_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "black"), ICON_UNDERLAY)
		if("Janitor")
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "janitor_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "black"), ICON_UNDERLAY)
		if("Librarian")
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "red_suit_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "black"), ICON_UNDERLAY)
		if("Quartermaster")
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "qm_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "brown"), ICON_UNDERLAY)
		if("Cargo Technician")
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "cargotech_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "black"), ICON_UNDERLAY)
		if("Mining Foreman")
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "overalls_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "black"), ICON_UNDERLAY)
		if("Shaft Miner")
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "miner_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "black"), ICON_UNDERLAY)
		if("Lawyer")
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "internalaffairs_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "brown"), ICON_UNDERLAY)
		if("Chaplain")
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "chapblack_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "black"), ICON_UNDERLAY)
		if("Research Director")
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "director_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "brown"), ICON_UNDERLAY)
			clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "labcoat_open"), ICON_OVERLAY)
		if("Scientist")
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "toxinswhite_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "white"), ICON_UNDERLAY)
			clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "labcoat_tox_open"), ICON_OVERLAY)
		if("Chemist")
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "chemistrywhite_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "white"), ICON_UNDERLAY)
			clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "labcoat_chem_open"), ICON_OVERLAY)
		if("Chief Medical Officer")
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "cmo_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "brown"), ICON_UNDERLAY)
			clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "labcoat_cmo_open"), ICON_OVERLAY)
		if("Medical Doctor")
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "medical_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "white"), ICON_UNDERLAY)
			clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "labcoat_open"), ICON_OVERLAY)
		if("Geneticist")
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "geneticswhite_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "white"), ICON_UNDERLAY)
			clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "labcoat_gen_open"), ICON_OVERLAY)
		if("Virologist")
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "virologywhite_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "white"), ICON_UNDERLAY)
			clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "labcoat_vir_open"), ICON_OVERLAY)
		if("Captain")
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "captain_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "brown"), ICON_UNDERLAY)
		if("Head of Security")
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "hosred_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "jackboots"), ICON_UNDERLAY)
		if("Warden")
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "warden_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "jackboots"), ICON_UNDERLAY)
		if("Detective")
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "detective_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "brown"), ICON_UNDERLAY)
			clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "detective"), ICON_OVERLAY)
		if("Security Officer")
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "secred_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "jackboots"), ICON_UNDERLAY)
		if("Security Paramedic")
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "secred2_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "jackboots"), ICON_UNDERLAY)
			clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "labcoat_open"), ICON_OVERLAY)
		if("Chief Engineer")
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "chief_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "brown"), ICON_UNDERLAY)
			clothes_s.Blend(new /icon('icons/mob/on_mob/belt.dmi', "utility"), ICON_OVERLAY)
		if("Station Engineer")
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "engine_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "orange"), ICON_UNDERLAY)
			clothes_s.Blend(new /icon('icons/mob/on_mob/belt.dmi', "utility"), ICON_OVERLAY)
		if("Atmospheric Technician")
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "atmos_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "black"), ICON_UNDERLAY)
			clothes_s.Blend(new /icon('icons/mob/on_mob/belt.dmi', "utility"), ICON_OVERLAY)
		if("Roboticist")
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "robotics_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "black"), ICON_UNDERLAY)
			clothes_s.Blend(new /icon('icons/mob/on_mob/suit.dmi', "labcoat_open"), ICON_OVERLAY)
		else
			clothes_s = new /icon('icons/mob/on_mob/uniform.dmi', "grey_s")
			clothes_s.Blend(new /icon('icons/mob/on_mob/feet.dmi', "black"), ICON_UNDERLAY)
	preview_icon.Blend(eyes_s, ICON_OVERLAY)
	if(isnotnull(clothes_s))
		preview_icon.Blend(clothes_s, ICON_OVERLAY)
	qdel(eyes_s)
	qdel(clothes_s)

	return preview_icon