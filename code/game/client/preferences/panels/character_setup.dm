/datum/preferences/proc/character_setup_panel(mob/user)
	if(isnull(user?.client))
		return

	update_preview_icon()
	user << browse_rsc(preview_icon_front, "previewicon.png")
	user << browse_rsc(preview_icon_side, "previewicon2.png")

	var/dat = "<div align='center'>"
	if(path)
		dat += "Slot <b>[slot_name]</b> - "
		dat += "<a href=\"byond://?src=\ref[user];preference=open_load_dialog\">Load slot</a> - "
		dat += "<a href=\"byond://?src=\ref[user];preference=save\">Save slot</a> - "
		dat += "<a href=\"byond://?src=\ref[user];preference=reload\">Reload slot</a>"
	else
		dat += "Please create an account to save your preferences."
	dat += "<hr>"

	dat += "<a href='byond://?_src_=prefs;preference=job;task=menu'><b>Occupation Choices</b></a> - "
	if(jobban_isbanned(user, "Records"))
		dat += "<font color='red'><b><s><a>Character Records</a></s></b></font> - "
	else
		dat += "<b><a href=\"byond://?src=\ref[user];preference=records;record=1\">Character Records</a></b> - "
	dat += "\t<a href=\"byond://?src=\ref[user];preference=skills\"><b>Set Skills</b> (<i>[GetSkillClass(used_skillpoints)] [used_skillpoints > 0 ? " [used_skillpoints]" : "0"])</i></a>"
	dat += "<hr>"
	dat += "</div>"

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
	dat += "<b>UI Style:</b> <a href='byond://?_src_=prefs;preference=ui'><b>[UI_style]</b></a>"
	dat += "<br>"
	dat += "<b>Custom UI</b> (recommended for White UI):"
	dat += "<br>"
	dat += "- Color: <a href='byond://?_src_=prefs;preference=UIcolor'><b>[UI_style_color]</b></a> <font face='fixedsys' size='3' color='[UI_style_color]'><table style='display:inline;' bgcolor='[UI_style_color]'><tr><td>__</td></tr></font></table>"
	dat += "<br>"
	dat += "- Alpha (transparency): <a href='byond://?_src_=prefs;preference=UIalpha'><b>[UI_style_alpha]</b></a>"
	dat += "<br>"
	dat += "<b>Play admin midis:</b> <a href='byond://?_src_=prefs;preference=hear_midis'><b>[(toggles & SOUND_MIDI) ? "Yes" : "No"]</b></a>"
	dat += "<br>"
	dat += "<b>Play lobby music:</b> <a href='byond://?_src_=prefs;preference=lobby_music'><b>[(toggles & SOUND_LOBBY) ? "Yes" : "No"]</b></a>"
	dat += "<br>"
	dat += "<b>Ghost ears:</b> <a href='byond://?_src_=prefs;preference=ghost_ears'><b>[(toggles & CHAT_GHOSTEARS) ? "All Speech" : "Nearest Creatures"]</b></a>"
	dat += "<br>"
	dat += "<b>Ghost sight:</b> <a href='byond://?_src_=prefs;preference=ghost_sight'><b>[(toggles & CHAT_GHOSTSIGHT) ? "All Emotes" : "Nearest Creatures"]</b></a>"
	dat += "<br>"
	dat += "<b>Ghost radio:</b> <a href='byond://?_src_=prefs;preference=ghost_radio'><b>[(toggles & CHAT_GHOSTRADIO) ? "All Chatter" : "Nearest Speakers"]</b></a>"
	dat += "<br>"

	if(CONFIG_GET(allow_Metadata))
		dat += "<b>OOC Notes:</b> <a href='byond://?_src_=prefs;preference=metadata;task=input'> Edit </a><br>"

	dat += "<br><table><tr><td><b>Body</b> "
	dat += "(<a href='byond://?_src_=prefs;preference=all;task=random'>&reg;</A>)"
	dat += "<br>"
	dat += "Species: <a href='byond://?src=\ref[user];preference=species;task=input'>[species]</a><br>"
	dat += "Secondary Language:<br><a href='byond://?src=\ref[user];preference=language;task=input'>[secondary_language]</a><br>"
	dat += "Blood Type: <a href='byond://?src=\ref[user];preference=b_type;task=input'>[b_type]</a><br>"
	dat += "Skin Tone: <a href='byond://?_src_=prefs;preference=s_tone;task=input'>[-s_tone + 35]/220<br></a>"
	//dat += "Skin pattern: <a href='byond://?src=\ref[user];preference=skin_style;task=input'>Adjust</a><br>"
	dat += "Needs Glasses: <a href='byond://?_src_=prefs;preference=disabilities'><b>[disabilities == 0 ? "No" : "Yes"]</b></a><br>"
	dat += "Limbs: <a href='byond://?src=\ref[user];preference=limbs;task=input'>Adjust</a><br>"
	dat += "Internal Organs: <a href='byond://?src=\ref[user];preference=organs;task=input'>Adjust</a><br>"

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
		dat += "\[...\]<br><br>"
	else
		dat += "<br><br>"

	if(gender == MALE)
		dat += "Underwear: <a href='byond://?_src_=prefs;preference=underwear;task=input'><b>[GLOBL.underwear_m[underwear]]</b></a><br>"
	else
		dat += "Underwear: <a href='byond://?_src_=prefs;preference=underwear;task=input'><b>[GLOBL.underwear_f[underwear]]</b></a><br>"

	dat += "Backpack Type:<br><a href='byond://?_src_=prefs;preference=bag;task=input'><b>[GLOBL.backbaglist[backbag]]</b></a><br>"

	dat += "NanoTrasen Relation:<br><a href='byond://?_src_=prefs;preference=nt_relation;task=input'><b>[nanotrasen_relation]</b></a><br>"

	dat += "</td>"
	dat += "<td><div class='block'>"
	dat += "<b>Preview</b>"
	dat += "<hr>"
	dat += "<img src=previewicon.png height=64 width=64><img src=previewicon2.png height=64 width=64>"
	dat += "</div></td>"
	dat += "</tr></table>"

	dat += "</td><td width='300px' height='300px'>"

	//dat += "<b><a href=\"byond://?src=\ref[user];preference=antagoptions;active=0\">Set Antag Options</b></a><br>"

	dat += "<a href='byond://?src=\ref[user];preference=flavor_text;task=input'><b>Set Flavor Text</b></a><br>"
	if(length(flavor_text) <= 40)
		if(!length(flavor_text))
			dat += "\[...\]"
		else
			dat += "[flavor_text]"
	else
		dat += "[copytext(flavor_text, 1, 37)]...<br>"
	dat += "<br>"

	dat += "<br><b>Hair</b><br>"
	dat += "Style: <a href='byond://?_src_=prefs;preference=h_style;task=input'>[h_style]</a><br>"
	dat += "<a href='byond://?_src_=prefs;preference=hair;task=input'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(r_hair, 2)][num2hex(g_hair, 2)][num2hex(b_hair, 2)]'><table style='display:inline;' bgcolor='#[num2hex(r_hair, 2)][num2hex(g_hair, 2)][num2hex(b_hair)]'><tr><td>__</td></tr></table></font><br>"

	dat += "<br><b>Facial</b><br>"
	dat += "Style: <a href='byond://?_src_=prefs;preference=f_style;task=input'>[f_style]</a><br>"
	dat += "<a href='byond://?_src_=prefs;preference=facial;task=input'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(r_facial, 2)][num2hex(g_facial, 2)][num2hex(b_facial, 2)]'><table  style='display:inline;' bgcolor='#[num2hex(r_facial, 2)][num2hex(g_facial, 2)][num2hex(b_facial)]'><tr><td>__</td></tr></table></font><br>"

	dat += "<br><b>Eyes</b><br>"
	dat += "<a href='byond://?_src_=prefs;preference=eyes;task=input'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(r_eyes, 2)][num2hex(g_eyes, 2)][num2hex(b_eyes, 2)]'><table  style='display:inline;' bgcolor='#[num2hex(r_eyes, 2)][num2hex(g_eyes, 2)][num2hex(b_eyes)]'><tr><td>__</td></tr></table></font><br>"

	dat += "<br><b>Body Color</b><br>"
	dat += "<a href='byond://?_src_=prefs;preference=skin;task=input'>Change Color</a> <font face='fixedsys' size='3' color='#[num2hex(r_skin, 2)][num2hex(g_skin, 2)][num2hex(b_skin, 2)]'><table style='display:inline;' bgcolor='#[num2hex(r_skin, 2)][num2hex(g_skin, 2)][num2hex(b_skin)]'><tr><td>__</td></tr></table></font>"

	dat += "<br><br>"
	if(jobban_isbanned(user, "Syndicate"))
		dat += "<b>You are banned from antagonist roles.</b>"
		be_special = 0
	else
		var/n = 0
		for(var/i in GLOBL.special_roles)
			if(GLOBL.special_roles[i]) //if mode is available on the server
				if(jobban_isbanned(user, i))
					dat += "<b>Be [i]:</b> <font color=red><b> \[BANNED]</b></font><br>"
				else if(i == "pai candidate")
					if(jobban_isbanned(user, "pAI"))
						dat += "<b>Be [i]:</b> <font color=red><b> \[BANNED]</b></font><br>"
				else
					dat += "<b>Be [i]:</b> <a href='byond://?_src_=prefs;preference=be_special;num=[n]'><b>[be_special & (1 << n) ? "Yes" : "No"]</b></a><br>"
			n++
	dat += "</td></tr></table>"

	dat += "<hr>"
	dat += "<div align='center'>"
	if(!IsGuestKey(user.key))
		dat += "<a href='byond://?_src_=prefs;preference=load'>Undo</a> - "
		dat += "<a href='byond://?_src_=prefs;preference=save'>Save Setup</a> - "
	dat += "<a href='byond://?_src_=prefs;preference=reset_all'>Reset Setup</a>"
	dat += "</div>"

	var/datum/browser/panel = new /datum/browser(user, "preferences", "", 700, 780)
	panel.set_content(dat)
	panel.open()