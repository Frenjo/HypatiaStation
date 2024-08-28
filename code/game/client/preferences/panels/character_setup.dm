/datum/preferences/proc/character_setup_panel(mob/user)
	if(isnull(user?.client))
		return

	update_preview_icon()
	user << browse_rsc(preview_icon_front, "previewicon.png")
	user << browse_rsc(preview_icon_side, "previewicon2.png")

	var/dat = character_setup_header(user)

	dat += "<table><tr><td width='340px' height='320px'>"

	dat += "<b>Name:</b> <a href='byond://?_src_=prefs;preference=name;task=input'><b>[real_name]</b></a>"
	dat += "<br>"
	dat += "(<a href='byond://?_src_=prefs;preference=name;task=random'>Random Name</A>) (<a href='byond://?_src_=prefs;preference=name'>Always Random Name: [be_random_name ? "Yes" : "No"]</a>)"
	dat += "<br>"
	dat += "<b>Gender:</b> <a href='byond://?_src_=prefs;preference=gender'><b>[gender == MALE ? "Male" : "Female"]</b></a>"
	dat += "<br>"
	dat += "<b>Age:</b> <a href='byond://?_src_=prefs;preference=age;task=input'>[age]</a>"
	dat += "<br>"
	dat += "<b>Spawn Point</b>: <a href='byond://?src=\ref[user];preference=spawnpoint;task=input'>[spawnpoint]</a>"
	dat += "<br>"

	if(CONFIG_GET(allow_Metadata))
		dat += "<b>OOC Notes:</b> <a href='byond://?_src_=prefs;preference=metadata;task=input'> Edit </a>"
		dat += "<br>"

	dat += "<br>"
	dat += "<table><tr><td>"
	dat += "<b>Body</b> (<a href='byond://?_src_=prefs;preference=all;task=random'>&reg;</A>)"
	dat += "<br>"
	dat += "Species: <a href='byond://?src=\ref[user];preference=species;task=input'>[species]</a>"
	dat += "<br>"
	dat += "Secondary Language:<br><a href='byond://?src=\ref[user];preference=language;task=input'>[secondary_language]</a>"
	dat += "<br>"
	dat += "Blood Type: <a href='byond://?src=\ref[user];preference=b_type;task=input'>[b_type]</a>"
	dat += "<br>"
	dat += "Skin Tone: <a href='byond://?_src_=prefs;preference=s_tone;task=input'>[-s_tone + 35]/220</a>"
	dat += "<br>"
	//dat += "Skin pattern: <a href='byond://?src=\ref[user];preference=skin_style;task=input'>Adjust</a>"
	//dat += "<br>"
	dat += "Needs Glasses: <a href='byond://?_src_=prefs;preference=disabilities'><b>[disabilities == 0 ? "No" : "Yes"]</b></a>"
	dat += "<br>"
	dat += "Limbs: <a href='byond://?src=\ref[user];preference=limbs;task=input'>Adjust</a>"
	dat += "<br>"
	dat += "Internal Organs: <a href='byond://?src=\ref[user];preference=organs;task=input'>Adjust</a>"
	dat += "<br>"

	//display limbs below
	var/ind = 0
	for(var/name in organ_data)
		//to_world("[ind] \ [length(organ_data)]")
		var/status = organ_data[name]
		var/organ_name = null
		switch(name)
			if("l_arm")
				organ_name = "left arm"
			if("r_arm")
				organ_name = "right arm"
			if("l_leg")
				organ_name = "left leg"
			if("r_leg")
				organ_name = "right leg"
			if("l_foot")
				organ_name = "left foot"
			if("r_foot")
				organ_name = "right foot"
			if("l_hand")
				organ_name = "left hand"
			if("r_hand")
				organ_name = "right hand"
			if("heart")
				organ_name = "heart"
			if("eyes")
				organ_name = "eyes"

		if(status == "cyborg")
			++ind
			if(ind > 1)
				dat += ", "
			dat += "\tMechanical [organ_name] prothesis"
		else if(status == "amputated")
			++ind
			if(ind > 1)
				dat += ", "
			dat += "\tAmputated [organ_name]"
		else if(status == "mechanical")
			++ind
			if(ind > 1)
				dat += ", "
			dat += "\tMechanical [organ_name]"
		else if(status == "assisted")
			++ind
			if(ind > 1)
				dat += ", "
			switch(organ_name)
				if("heart")
					dat += "\tPacemaker-assisted [organ_name]"
				if("voicebox") //on adding voiceboxes for speaking skrell/similar replacements
					dat += "\tSurgically altered [organ_name]"
				if("eyes")
					dat += "\tRetinal overlayed [organ_name]"
				else
					dat += "\tMechanically assisted [organ_name]"
	if(!ind)
		dat += "\[...\]"
		dat += "<br>"
		dat += "<br>"
	else
		dat += "<br>"
		dat += "<br>"

	if(gender == MALE)
		dat += "Underwear: <a href='byond://?_src_=prefs;preference=underwear;task=input'><b>[GLOBL.underwear_m[underwear]]</b></a>"
		dat += "<br>"
	else
		dat += "Underwear: <a href='byond://?_src_=prefs;preference=underwear;task=input'><b>[GLOBL.underwear_f[underwear]]</b></a>"
		dat += "<br>"

	dat += "Backpack Type:<br><a href='byond://?_src_=prefs;preference=bag;task=input'><b>[GLOBL.backbaglist[backbag]]</b></a>"
	dat += "<br>"
	dat += "NanoTrasen Relation:<br><a href='byond://?_src_=prefs;preference=nt_relation;task=input'><b>[nanotrasen_relation]</b></a>"
	dat += "<br>"

	dat += "</td>"
	dat += "<td><div class='block'>"
	dat += "<b>Preview</b>"
	dat += "<hr>"
	dat += "<img src=previewicon.png height=64 width=64><img src=previewicon2.png height=64 width=64>"
	dat += "</div></td>"
	dat += "</tr></table>"

	dat += "</td><td width='300px' height='300px'>"

	dat += "<a href='byond://?src=\ref[user];preference=flavor_text;task=input'><b>Set Flavor Text</b></a>"
	dat += "<br>"
	if(length(flavor_text) <= 40)
		if(!length(flavor_text))
			dat += "\[...\]"
		else
			dat += "[flavor_text]"
	else
		dat += "[copytext(flavor_text, 1, 37)]..."
		dat += "<br>"
	dat += "<br>"

	dat += "<br>"
	dat += "<b>Hair</b>"
	dat += "<br>"
	dat += "Style: <a href='byond://?_src_=prefs;preference=h_style;task=input'>[h_style]</a>"
	dat += "<br>"
	dat += "<a href='byond://?_src_=prefs;preference=hair;task=input'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(r_hair, 2)][num2hex(g_hair, 2)][num2hex(b_hair, 2)]'><table style='display:inline;' bgcolor='#[num2hex(r_hair, 2)][num2hex(g_hair, 2)][num2hex(b_hair)]'><tr><td>__</td></tr></table></font>"
	dat += "<br>"

	dat += "<br>"
	dat += "<b>Facial</b>"
	dat += "<br>"
	dat += "Style: <a href='byond://?_src_=prefs;preference=f_style;task=input'>[f_style]</a>"
	dat += "<br>"
	dat += "<a href='byond://?_src_=prefs;preference=facial;task=input'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(r_facial, 2)][num2hex(g_facial, 2)][num2hex(b_facial, 2)]'><table  style='display:inline;' bgcolor='#[num2hex(r_facial, 2)][num2hex(g_facial, 2)][num2hex(b_facial)]'><tr><td>__</td></tr></table></font>"
	dat += "<br>"

	dat += "<br>"
	dat += "<b>Eyes</b>"
	dat += "<br>"
	dat += "<a href='byond://?_src_=prefs;preference=eyes;task=input'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(r_eyes, 2)][num2hex(g_eyes, 2)][num2hex(b_eyes, 2)]'><table  style='display:inline;' bgcolor='#[num2hex(r_eyes, 2)][num2hex(g_eyes, 2)][num2hex(b_eyes)]'><tr><td>__</td></tr></table></font>"
	dat += "<br>"

	dat += "<br>"
	dat += "<b>Body Color</b>"
	dat += "<br>"
	dat += "<a href='byond://?_src_=prefs;preference=skin;task=input'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(r_skin, 2)][num2hex(g_skin, 2)][num2hex(b_skin, 2)]'><table style='display:inline;' bgcolor='#[num2hex(r_skin, 2)][num2hex(g_skin, 2)][num2hex(b_skin)]'><tr><td>__</td></tr></table></font>"
	dat += "</td></tr></table>"

	dat += character_setup_footer(user)

	var/datum/browser/panel = new /datum/browser(user, "preferences", "", 700, 600)
	panel.set_content(dat)
	panel.open()

/datum/preferences/proc/character_setup_header(mob/user)
	. = "<div align='center'>"
	if(path)
		. += "Slot <b>[slot_name]</b> - "
		. += "<a href=\"byond://?src=\ref[user];preference=open_load_dialog\">Load slot</a> - "
		. += "<a href=\"byond://?src=\ref[user];preference=save\">Save slot</a> - "
		. += "<a href=\"byond://?src=\ref[user];preference=reload\">Reload slot</a>"
	else
		. += "Please create an account to save your preferences."
	. += "<hr>"

	. += "<a href='byond://?_src_=prefs;preference=job;task=menu'><b>Occupation Choices</b></a> - "
	if(jobban_isbanned(user, "Records"))
		. += "<font color='red'><b><s><a>Character Records</a></s></b></font> - "
	else
		. += "<a href=\"byond://?src=\ref[user];preference=records;record=1\"><b>Character Records</b></a> - "
	. += "\t<a href=\"byond://?src=\ref[user];preference=skills\"><b>Skills</b> (<i>[GetSkillClass(used_skillpoints)] [used_skillpoints > 0 ? " [used_skillpoints]" : "0"])</i></a> - "
	. += "<a href=\"byond://?src=\ref[user];preference=specialroles;active=0\"><b>Special Roles</b></a> - "
	. += "<a href=\"byond://?src=\ref[user];preference=uipreferences;task=open\"><b>UI Preferences</b></a>"
	. += "<hr>"
	. += "</div>"

/datum/preferences/proc/character_setup_footer(mob/user)
	. += "<hr>"
	. += "<div align='center'>"
	if(!IsGuestKey(user.key))
		. += "<a href='byond://?_src_=prefs;preference=load'>Undo</a> - "
		. += "<a href='byond://?_src_=prefs;preference=save'>Save Setup</a> - "
	. += "<a href='byond://?_src_=prefs;preference=reset_all'>Reset Setup</a>"
	. += "</div>"