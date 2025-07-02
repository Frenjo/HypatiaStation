/datum/mind
	var/memory

/datum/mind/proc/store_memory(new_text)
	memory += "[new_text]<BR>"

/datum/mind/proc/show_memory(mob/recipient)
	var/output = "<B>[current.real_name]'s Memory</B><HR>"
	output += memory

	if(length(objectives))
		output += "<HR><B>Objectives:</B>"

		var/obj_count = 1
		for_no_type_check(var/datum/objective/objective, objectives)
			output += "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
			obj_count++

	recipient << browse(output,"window=memory")

/datum/mind/proc/edit_memory()
	if(isnull(global.PCticker?.mode))
		alert("Not before round-start!", "Alert")
		return

	var/out = "<B>[name]</B>[(current && (current.real_name != name)) ? " (as [current.real_name])" : ""]<br>"
	out += "Mind currently owned by key: [key] [active ? "(synced)" : "(not synced)"]<br>"
	out += "Assigned role: [assigned_role]. <a href='byond://?src=\ref[src];role_edit=1'>Edit</a><br>"
	out += "Factions and special roles:<br>"

	var/list/sections = list(
		"implant",
		"revolution",
		"cult",
		"wizard",
		"changeling",
		"nuclear",
		"traitor", // "traitorchan",
		"monkey",
		"malfunction",
	)
	var/text = ""
	var/mob/living/carbon/human/H = current
	if(ishuman(current) || ismonkey(current))
		/*** Implanted ***/
		if(ishuman(current))
			if(H.is_mindshield_implanted())
				text = "Mindshield Implant: <a href='byond://?src=\ref[src];implant=shieldremove'>Remove</a> | <b>Implanted</b></br>"
			else
				text = "Mindshield Implant: <b>No Implant</b> | <a href='byond://?src=\ref[src];implant=shieldadd'>Implant him!</a></br>"
			if(H.is_loyalty_implanted())
				text = "Loyalty Implant: <a href='byond://?src=\ref[src];implant=loyaltyremove'>Remove</a> | <b>Implanted</b></br>"
			else
				text = "Loyalty Implant: <b>No Implant</b> | <a href='byond://?src=\ref[src];implant=loyaltyadd'>Implant him!</a></br>"
		else
			text = "Loyalty Implant: Don't implant that monkey!</br>"
		sections["implant"] = text
		/*** REVOLUTION ***/
		text = "revolution"
		if(IS_GAME_MODE(/datum/game_mode/revolution))
			text += uppertext(text)
		text = "<i><b>[text]</b></i>: "
		if(ismonkey(current) || H.is_loyalty_implanted())
			text += "<b>LOYAL EMPLOYEE</b>|headrev|rev"
		else if(src in global.PCticker.mode.head_revolutionaries)
			text = "<a href='byond://?src=\ref[src];revolution=clear'>employee</a>|<b>HEADREV</b>|<a href='byond://?src=\ref[src];revolution=rev'>rev</a>"
			text += "<br>Flash: <a href='byond://?src=\ref[src];revolution=flash'>give</a>"

			var/list/L = current.get_contents()
			var/obj/item/flash/flash = locate() in L
			if(isnotnull(flash))
				if(!flash.broken)
					text += "|<a href='byond://?src=\ref[src];revolution=takeflash'>take</a>."
				else
					text += "|<a href='byond://?src=\ref[src];revolution=takeflash'>take</a>|<a href='byond://?src=\ref[src];revolution=repairflash'>repair</a>."
			else
				text += "."

			text += " <a href='byond://?src=\ref[src];revolution=reequip'>Reequip</a> (gives traitor uplink)."
			if(!length(objectives))
				text += "<br>Objectives are empty! <a href='byond://?src=\ref[src];revolution=autoobjectives'>Set to kill all heads</a>."
		else if(src in global.PCticker.mode.revolutionaries)
			text += "<a href='byond://?src=\ref[src];revolution=clear'>employee</a>|<a href='byond://?src=\ref[src];revolution=headrev'>headrev</a>|<b>REV</b>"
		else
			text += "<b>EMPLOYEE</b>|<a href='byond://?src=\ref[src];revolution=headrev'>headrev</a>|<a href='byond://?src=\ref[src];revolution=rev'>rev</a>"
		sections["revolution"] = text

		/*** CULT ***/
		text = "cult"
		if(IS_GAME_MODE(/datum/game_mode/cult))
			text = uppertext(text)
		text = "<i><b>[text]</b></i>: "
		if(ismonkey(current) || H.is_loyalty_implanted())
			text += "<B>LOYAL EMPLOYEE</B>|cultist"
		else if(src in global.PCticker.mode.cult)
			text += "<a href='byond://?src=\ref[src];cult=clear'>employee</a>|<b>CULTIST</b>"
			text += "<br>Give <a href='byond://?src=\ref[src];cult=tome'>tome</a>|<a href='byond://?src=\ref[src];cult=amulet'>amulet</a>."
/*
			if(!length(objectives))
				text += "<br>Objectives are empty! Set to sacrifice and <a href='byond://?src=\ref[src];cult=escape'>escape</a> or <a href='byond://?src=\ref[src];cult=summon'>summon</a>."
*/
		else
			text += "<b>EMPLOYEE</b>|<a href='byond://?src=\ref[src];cult=cultist'>cultist</a>"
		sections["cult"] = text

		/*** WIZARD ***/
		text = "wizard"
		if(IS_GAME_MODE(/datum/game_mode/wizard))
			text = uppertext(text)
		text = "<i><b>[text]</b></i>: "
		if(src in global.PCticker.mode.wizards)
			text += "<b>YES</b>|<a href='byond://?src=\ref[src];wizard=clear'>no</a>"
			text += "<br><a href='byond://?src=\ref[src];wizard=lair'>To lair</a>, <a href='byond://?src=\ref[src];common=undress'>undress</a>, <a href='byond://?src=\ref[src];wizard=dressup'>dress up</a>, <a href='byond://?src=\ref[src];wizard=name'>let choose name</a>."
			if(!length(objectives))
				text += "<br>Objectives are empty! <a href='byond://?src=\ref[src];wizard=autoobjectives'>Randomize!</a>"
		else
			text += "<a href='byond://?src=\ref[src];wizard=wizard'>yes</a>|<b>NO</b>"
		sections["wizard"] = text

		/*** CHANGELING ***/
		text = "changeling"
		if(IS_GAME_MODE(/datum/game_mode/changeling) || IS_GAME_MODE(/datum/game_mode/traitor/changeling))
			text = uppertext(text)
		text = "<i><b>[text]</b></i>: "
		if(src in global.PCticker.mode.changelings)
			text += "<b>YES</b>|<a href='byond://?src=\ref[src];changeling=clear'>no</a>"
			if(!length(objectives))
				text += "<br>Objectives are empty! <a href='byond://?src=\ref[src];changeling=autoobjectives'>Randomize!</a>"
			if(changeling && length(changeling.absorbed_dna) && (current.real_name != changeling.absorbed_dna[1]))
				text += "<br><a href='byond://?src=\ref[src];changeling=initialdna'>Transform to initial appearance.</a>"
		else
			text += "<a href='byond://?src=\ref[src];changeling=changeling'>yes</a>|<b>NO</b>"
//			var/datum/game_mode/changeling/changeling = ticker.mode
//			if (istype(changeling) && changeling.changelingdeath)
//				text += "<br>All the changelings are dead! Restart in [round((changeling.TIME_TO_GET_REVIVED-(world.time-changeling.changelingdeathtime))/10)] seconds."
		sections["changeling"] = text

		/*** NUCLEAR ***/
		text = "nuclear"
		if(IS_GAME_MODE(/datum/game_mode/nuclear))
			text = uppertext(text)
		text = "<i><b>[text]</b></i>: "
		if(src in global.PCticker.mode.syndicates)
			text += "<b>OPERATIVE</b>|<a href='byond://?src=\ref[src];nuclear=clear'>nanotrasen</a>"
			text += "<br><a href='byond://?src=\ref[src];nuclear=lair'>To shuttle</a>, <a href='byond://?src=\ref[src];common=undress'>undress</a>, <a href='byond://?src=\ref[src];nuclear=dressup'>dress up</a>."
			var/code
			for_no_type_check(var/obj/machinery/nuclearbomb/bombue, GET_MACHINES_TYPED(/obj/machinery/nuclearbomb))
				if(length(bombue.r_code) <= 5 && bombue.r_code != "LOLNO" && bombue.r_code != "ADMIN")
					code = bombue.r_code
					break
			if(code)
				text += " Code is [code]. <a href='byond://?src=\ref[src];nuclear=tellcode'>tell the code.</a>"
		else
			text += "<a href='byond://?src=\ref[src];nuclear=nuclear'>operative</a>|<b>NANOTRASEN</b>"
		sections["nuclear"] = text

	/*** TRAITOR ***/
	text = "traitor"
	if(IS_GAME_MODE(/datum/game_mode/traitor) || IS_GAME_MODE(/datum/game_mode/traitor/changeling))
		text = uppertext(text)
	text = "<i><b>[text]</b></i>: "
	if(ishuman(current))
		if(H.is_loyalty_implanted())
			text += "traitor|<b>LOYAL EMPLOYEE</b>"
		else
			if(src in global.PCticker.mode.traitors)
				text += "<b>TRAITOR</b>|<a href='byond://?src=\ref[src];traitor=clear'>Employee</a>"
				if(!length(objectives))
					text += "<br>Objectives are empty! <a href='byond://?src=\ref[src];traitor=autoobjectives'>Randomize</a>!"
			else
				text += "<a href='byond://?src=\ref[src];traitor=traitor'>traitor</a>|<b>Employee</b>"
	sections["traitor"] = text

	/*** MONKEY ***/
	if(iscarbon(current))
		text = "monkey"
		if(IS_GAME_MODE(/datum/game_mode/monkey))
			text = uppertext(text)
		text = "<i><b>[text]</b></i>: "
		if(ishuman(current))
			text += "<a href='byond://?src=\ref[src];monkey=healthy'>healthy</a>|<a href='byond://?src=\ref[src];monkey=infected'>infected</a>|<b>HUMAN</b>|other"
		else if(ismonkey(current))
			var/found = 0
			for_no_type_check(var/datum/disease/D, current.viruses)
				if(istype(D, /datum/disease/jungle_fever))
					found = 1

			if(found)
				text += "<a href='byond://?src=\ref[src];monkey=healthy'>healthy</a>|<b>INFECTED</b>|<a href='byond://?src=\ref[src];monkey=human'>human</a>|other"
			else
				text += "<b>HEALTHY</b>|<a href='byond://?src=\ref[src];monkey=infected'>infected</a>|<a href='byond://?src=\ref[src];monkey=human'>human</a>|other"

		else
			text += "healthy|infected|human|<b>OTHER</b>"
		sections["monkey"] = text

	/*** SILICON ***/
	if(issilicon(current))
		text = "silicon"
		if(IS_GAME_MODE(/datum/game_mode/malfunction))
			text = uppertext(text)
		text = "<i><b>[text]</b></i>: "
		if(isAI(current))
			if(src in global.PCticker.mode.malf_ai)
				text += "<b>MALF</b>|<a href='byond://?src=\ref[src];silicon=unmalf'>not malf</a>"
			else
				text += "<a href='byond://?src=\ref[src];silicon=malf'>malf</a>|<b>NOT MALF</b>"
		var/mob/living/silicon/robot/robot = current
		if(istype(robot) && robot.emagged)
			text += "<br>Cyborg: Is emagged! <a href='byond://?src=\ref[src];silicon=unemag'>Unemag!</a><br>0th law: [robot.laws.zeroth]"
		var/mob/living/silicon/ai/ai = current
		if(istype(ai) && length(ai.connected_robots))
			var/n_e_robots = 0
			for(var/mob/living/silicon/robot/R in ai.connected_robots)
				if(R.emagged)
					n_e_robots++
			text += "<br>[n_e_robots] of [length(ai.connected_robots)] slaved cyborgs are emagged. <a href='byond://?src=\ref[src];silicon=unemagcyborgs'>Unemag</a>"
		sections["malfunction"] = text

	if(IS_GAME_MODE(/datum/game_mode/traitor/changeling))
		if(isnotnull(sections["traitor"]))
			out += sections["traitor"]+"<br>"
		if(isnotnull(sections["changeling"]))
			out += sections["changeling"]+"<br>"
		sections.Remove("traitor")
		sections.Remove("changeling")
	else
		if(isnotnull(sections[global.PCticker.mode.config_tag]))
			out += sections[global.PCticker.mode.config_tag]+"<br>"
		sections.Remove(global.PCticker.mode.config_tag)
	for(var/i in sections)
		if(sections[i])
			out += sections[i]+"<br>"


	if(((src in global.PCticker.mode.head_revolutionaries) || (src in global.PCticker.mode.traitors) || (src in global.PCticker.mode.syndicates)) && ishuman(current))
		text = "Uplink: <a href='byond://?src=\ref[src];common=uplink'>give</a>"
		var/obj/item/uplink/hidden/suplink = find_syndicate_uplink()
		var/crystals
		if(suplink)
			crystals = suplink.uses
		if(suplink)
			text += "|<a href='byond://?src=\ref[src];common=takeuplink'>take</a>"
			if(usr.client.holder.rights & R_FUN)
				text += ", <a href='byond://?src=\ref[src];common=crystals'>[crystals]</a> crystals"
			else
				text += ", [crystals] crystals"
		text += "." //hiel grammar
		out += text

	out += "<br>"

	out += "<b>Memory:</b><br>"
	out += memory
	out += "<br><a href='byond://?src=\ref[src];memory_edit=1'>Edit memory</a><br>"
	out += "Objectives:<br>"
	if(!length(objectives))
		out += "EMPTY<br>"
	else
		var/obj_count = 1
		for_no_type_check(var/datum/objective/objective, objectives)
			out += "<B>[obj_count]</B>: [objective.explanation_text] <a href='byond://?src=\ref[src];obj_edit=\ref[objective]'>Edit</a> <a href='byond://?src=\ref[src];obj_delete=\ref[objective]'>Delete</a> <a href='byond://?src=\ref[src];obj_completed=\ref[objective]'><font color=[objective.completed ? "green" : "red"]>Toggle Completion</font></a><br>"
			obj_count++
	out += "<a href='byond://?src=\ref[src];obj_add=1'>Add objective</a><br><br>"

	out += "<a href='byond://?src=\ref[src];obj_announce=1'>Announce objectives</a><br><br>"

	usr << browse(out, "window=edit_memory[src]")