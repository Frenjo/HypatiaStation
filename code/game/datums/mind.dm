/*	Note from Carnie:
		The way datum/mind stuff works has been changed a lot.
		Minds now represent IC characters rather than following a client around constantly.

	Guidelines for using minds properly:

	-	Never mind.transfer_to(ghost). The var/current and var/original of a mind must always be of type mob/living!
		ghost.mind is however used as a reference to the ghost's corpse

	-	When creating a new mob for an existing IC character (e.g. cloning a dead guy or borging a brain of a human)
		the existing mind of the old mob should be transfered to the new mob like so:

			mind.transfer_to(new_mob)

	-	You must not assign key= or ckey= after transfer_to() since the transfer_to transfers the client for you.
		By setting key or ckey explicitly after transfering the mind with transfer_to you will cause bugs like DCing
		the player.

	-	IMPORTANT NOTE 2, if you want a player to become a ghost, use mob.ghostize() It does all the hard work for you.

	-	When creating a new mob which will be a new IC character (e.g. putting a shade in a construct or randomly selecting
		a ghost to become a xeno during an event). Simply assign the key or ckey like you've always done.

			new_mob.key = key

		The Login proc will handle making a new mob for that mobtype (including setting up stuff like mind.name). Simple!
		However if you want that mind to have any special properties like being a traitor etc you will have to do that
		yourself.

*/

/datum/mind
	var/key
	var/name				//replaces mob/var/original_name
	var/mob/living/current
	var/mob/living/original	//TODO: remove.not used in any meaningful way ~Carn. First I'll need to tweak the way silicon-mobs handle minds.
	var/active = 0

	var/memory

	var/assigned_role
	var/special_role

	var/role_alt_title

	var/datum/job/assigned_job

	var/list/datum/objective/objectives = list()
	var/list/datum/objective/special_verbs = list()

	var/has_been_rev = 0//Tracks if this mind has been a rev or not

	var/datum/faction/faction 			//associated faction
	var/datum/changeling/changeling		//changeling holder

	var/rev_cooldown = 0

	// the world.time since the mob has been brigged, or -1 if not at all
	var/brigged_since = -1

	//put this here for easier tracking ingame
	var/datum/money_account/initial_account

/datum/mind/New(key)
	src.key = key
	..()

/datum/mind/proc/transfer_to(mob/living/new_character)
	if(!istype(new_character))
		world.log << "## DEBUG: transfer_to(): Some idiot has tried to transfer_to() a non mob/living mob. Please inform Carn"
	if(current)					//remove ourself from our old body's mind variable
		if(changeling)
			current.remove_changeling_powers()
			current.verbs -= /datum/changeling/proc/EvolutionMenu
		current.mind = null
	if(new_character.mind)		//remove any mind currently in our new body's mind variable
		new_character.mind.current = null

	nanomanager.user_transferred(current, new_character) // transfer active NanoUI instances to new user

	current = new_character		//link ourself to our new body
	new_character.mind = src	//and link our new body to ourself

	if(changeling)
		new_character.make_changeling()

	if(active)
		new_character.key = key		//now transfer the key to link the client to our new body

/datum/mind/proc/store_memory(new_text)
	memory += "[new_text]<BR>"

/datum/mind/proc/show_memory(mob/recipient)
	var/output = "<B>[current.real_name]'s Memory</B><HR>"
	output += memory

	if(length(objectives))
		output += "<HR><B>Objectives:</B>"

		var/obj_count = 1
		for(var/datum/objective/objective in objectives)
			output += "<B>Objective #[obj_count]</B>: [objective.explanation_text]"
			obj_count++

	recipient << browse(output,"window=memory")

/datum/mind/proc/edit_memory()
	if(!global.CTgame_ticker || !global.CTgame_ticker.mode)
		alert("Not before round-start!", "Alert")
		return

	var/out = "<B>[name]</B>[(current && (current.real_name != name)) ? " (as [current.real_name])" : ""]<br>"
	out += "Mind currently owned by key: [key] [active ? "(synced)" : "(not synced)"]<br>"
	out += "Assigned role: [assigned_role]. <a href='?src=\ref[src];role_edit=1'>Edit</a><br>"
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
		/** Impanted**/
		if(ishuman(current))
			if(H.is_loyalty_implanted(H))
				text = "Loyalty Implant:<a href='?src=\ref[src];implant=remove'>Remove</a>|<b>Implanted</b></br>"
			else
				text = "Loyalty Implant:<b>No Implant</b>|<a href='?src=\ref[src];implant=add'>Implant him!</a></br>"
		else
			text = "Loyalty Implant: Don't implant that monkey!</br>"
		sections["implant"] = text
		/** REVOLUTION ***/
		text = "revolution"
		if(global.CTgame_ticker.mode.config_tag == "revolution")
			text += uppertext(text)
		text = "<i><b>[text]</b></i>: "
		if(ismonkey(current) || H.is_loyalty_implanted(H))
			text += "<b>LOYAL EMPLOYEE</b>|headrev|rev"
		else if(src in global.CTgame_ticker.mode.head_revolutionaries)
			text = "<a href='?src=\ref[src];revolution=clear'>employee</a>|<b>HEADREV</b>|<a href='?src=\ref[src];revolution=rev'>rev</a>"
			text += "<br>Flash: <a href='?src=\ref[src];revolution=flash'>give</a>"

			var/list/L = current.get_contents()
			var/obj/item/device/flash/flash = locate() in L
			if(flash)
				if(!flash.broken)
					text += "|<a href='?src=\ref[src];revolution=takeflash'>take</a>."
				else
					text += "|<a href='?src=\ref[src];revolution=takeflash'>take</a>|<a href='?src=\ref[src];revolution=repairflash'>repair</a>."
			else
				text += "."

			text += " <a href='?src=\ref[src];revolution=reequip'>Reequip</a> (gives traitor uplink)."
			if(!length(objectives))
				text += "<br>Objectives are empty! <a href='?src=\ref[src];revolution=autoobjectives'>Set to kill all heads</a>."
		else if(src in global.CTgame_ticker.mode.revolutionaries)
			text += "<a href='?src=\ref[src];revolution=clear'>employee</a>|<a href='?src=\ref[src];revolution=headrev'>headrev</a>|<b>REV</b>"
		else
			text += "<b>EMPLOYEE</b>|<a href='?src=\ref[src];revolution=headrev'>headrev</a>|<a href='?src=\ref[src];revolution=rev'>rev</a>"
		sections["revolution"] = text

		/** CULT ***/
		text = "cult"
		if(global.CTgame_ticker.mode.config_tag == "cult")
			text = uppertext(text)
		text = "<i><b>[text]</b></i>: "
		if(ismonkey(current) || H.is_loyalty_implanted(H))
			text += "<B>LOYAL EMPLOYEE</B>|cultist"
		else if(src in global.CTgame_ticker.mode.cult)
			text += "<a href='?src=\ref[src];cult=clear'>employee</a>|<b>CULTIST</b>"
			text += "<br>Give <a href='?src=\ref[src];cult=tome'>tome</a>|<a href='?src=\ref[src];cult=amulet'>amulet</a>."
/*
			if(!length(objectives))
				text += "<br>Objectives are empty! Set to sacrifice and <a href='?src=\ref[src];cult=escape'>escape</a> or <a href='?src=\ref[src];cult=summon'>summon</a>."
*/
		else
			text += "<b>EMPLOYEE</b>|<a href='?src=\ref[src];cult=cultist'>cultist</a>"
		sections["cult"] = text

		/** WIZARD ***/
		text = "wizard"
		if(global.CTgame_ticker.mode.config_tag == "wizard")
			text = uppertext(text)
		text = "<i><b>[text]</b></i>: "
		if(src in global.CTgame_ticker.mode.wizards)
			text += "<b>YES</b>|<a href='?src=\ref[src];wizard=clear'>no</a>"
			text += "<br><a href='?src=\ref[src];wizard=lair'>To lair</a>, <a href='?src=\ref[src];common=undress'>undress</a>, <a href='?src=\ref[src];wizard=dressup'>dress up</a>, <a href='?src=\ref[src];wizard=name'>let choose name</a>."
			if(!length(objectives))
				text += "<br>Objectives are empty! <a href='?src=\ref[src];wizard=autoobjectives'>Randomize!</a>"
		else
			text += "<a href='?src=\ref[src];wizard=wizard'>yes</a>|<b>NO</b>"
		sections["wizard"] = text

		/** CHANGELING ***/
		text = "changeling"
		if(global.CTgame_ticker.mode.config_tag == "changeling" || global.CTgame_ticker.mode.config_tag == "traitorchan")
			text = uppertext(text)
		text = "<i><b>[text]</b></i>: "
		if(src in global.CTgame_ticker.mode.changelings)
			text += "<b>YES</b>|<a href='?src=\ref[src];changeling=clear'>no</a>"
			if(!length(objectives))
				text += "<br>Objectives are empty! <a href='?src=\ref[src];changeling=autoobjectives'>Randomize!</a>"
			if(changeling && length(changeling.absorbed_dna) && (current.real_name != changeling.absorbed_dna[1]))
				text += "<br><a href='?src=\ref[src];changeling=initialdna'>Transform to initial appearance.</a>"
		else
			text += "<a href='?src=\ref[src];changeling=changeling'>yes</a>|<b>NO</b>"
//			var/datum/game_mode/changeling/changeling = ticker.mode
//			if (istype(changeling) && changeling.changelingdeath)
//				text += "<br>All the changelings are dead! Restart in [round((changeling.TIME_TO_GET_REVIVED-(world.time-changeling.changelingdeathtime))/10)] seconds."
		sections["changeling"] = text

		/** NUCLEAR ***/
		text = "nuclear"
		if(global.CTgame_ticker.mode.config_tag == "nuclear")
			text = uppertext(text)
		text = "<i><b>[text]</b></i>: "
		if(src in global.CTgame_ticker.mode.syndicates)
			text += "<b>OPERATIVE</b>|<a href='?src=\ref[src];nuclear=clear'>nanotrasen</a>"
			text += "<br><a href='?src=\ref[src];nuclear=lair'>To shuttle</a>, <a href='?src=\ref[src];common=undress'>undress</a>, <a href='?src=\ref[src];nuclear=dressup'>dress up</a>."
			var/code
			for(var/obj/machinery/nuclearbomb/bombue in GLOBL.machines)
				if(length(bombue.r_code) <= 5 && bombue.r_code != "LOLNO" && bombue.r_code != "ADMIN")
					code = bombue.r_code
					break
			if(code)
				text += " Code is [code]. <a href='?src=\ref[src];nuclear=tellcode'>tell the code.</a>"
		else
			text += "<a href='?src=\ref[src];nuclear=nuclear'>operative</a>|<b>NANOTRASEN</b>"
		sections["nuclear"] = text

	/** TRAITOR ***/
	text = "traitor"
	if(global.CTgame_ticker.mode.config_tag == "traitor" || global.CTgame_ticker.mode.config_tag == "traitorchan")
		text = uppertext(text)
	text = "<i><b>[text]</b></i>: "
	if(ishuman(current))
		if(H.is_loyalty_implanted(H))
			text +="traitor|<b>LOYAL EMPLOYEE</b>"
		else
			if(src in global.CTgame_ticker.mode.traitors)
				text += "<b>TRAITOR</b>|<a href='?src=\ref[src];traitor=clear'>Employee</a>"
				if(!length(objectives))
					text += "<br>Objectives are empty! <a href='?src=\ref[src];traitor=autoobjectives'>Randomize</a>!"
			else
				text += "<a href='?src=\ref[src];traitor=traitor'>traitor</a>|<b>Employee</b>"
	sections["traitor"] = text

	/** MONKEY ***/
	if(iscarbon(current))
		text = "monkey"
		if(global.CTgame_ticker.mode.config_tag == "monkey")
			text = uppertext(text)
		text = "<i><b>[text]</b></i>: "
		if(ishuman(current))
			text += "<a href='?src=\ref[src];monkey=healthy'>healthy</a>|<a href='?src=\ref[src];monkey=infected'>infected</a>|<b>HUMAN</b>|other"
		else if(ismonkey(current))
			var/found = 0
			for(var/datum/disease/D in current.viruses)
				if(istype(D, /datum/disease/jungle_fever))
					found = 1

			if(found)
				text += "<a href='?src=\ref[src];monkey=healthy'>healthy</a>|<b>INFECTED</b>|<a href='?src=\ref[src];monkey=human'>human</a>|other"
			else
				text += "<b>HEALTHY</b>|<a href='?src=\ref[src];monkey=infected'>infected</a>|<a href='?src=\ref[src];monkey=human'>human</a>|other"

		else
			text += "healthy|infected|human|<b>OTHER</b>"
		sections["monkey"] = text

	/** SILICON ***/
	if(issilicon(current))
		text = "silicon"
		if(global.CTgame_ticker.mode.config_tag == "malfunction")
			text = uppertext(text)
		text = "<i><b>[text]</b></i>: "
		if(isAI(current))
			if(src in global.CTgame_ticker.mode.malf_ai)
				text += "<b>MALF</b>|<a href='?src=\ref[src];silicon=unmalf'>not malf</a>"
			else
				text += "<a href='?src=\ref[src];silicon=malf'>malf</a>|<b>NOT MALF</b>"
		var/mob/living/silicon/robot/robot = current
		if(istype(robot) && robot.emagged)
			text += "<br>Cyborg: Is emagged! <a href='?src=\ref[src];silicon=unemag'>Unemag!</a><br>0th law: [robot.laws.zeroth]"
		var/mob/living/silicon/ai/ai = current
		if(istype(ai) && length(ai.connected_robots))
			var/n_e_robots = 0
			for(var/mob/living/silicon/robot/R in ai.connected_robots)
				if(R.emagged)
					n_e_robots++
			text += "<br>[n_e_robots] of [length(ai.connected_robots)] slaved cyborgs are emagged. <a href='?src=\ref[src];silicon=unemagcyborgs'>Unemag</a>"
		sections["malfunction"] = text

	if(global.CTgame_ticker.mode.config_tag == "traitorchan")
		if(sections["traitor"])
			out += sections["traitor"]+"<br>"
		if(sections["changeling"])
			out += sections["changeling"]+"<br>"
		sections -= "traitor"
		sections -= "changeling"
	else
		if(sections[global.CTgame_ticker.mode.config_tag])
			out += sections[global.CTgame_ticker.mode.config_tag]+"<br>"
		sections -= global.CTgame_ticker.mode.config_tag
	for(var/i in sections)
		if(sections[i])
			out += sections[i]+"<br>"


	if(((src in global.CTgame_ticker.mode.head_revolutionaries) || (src in global.CTgame_ticker.mode.traitors) || (src in global.CTgame_ticker.mode.syndicates)) && ishuman(current))
		text = "Uplink: <a href='?src=\ref[src];common=uplink'>give</a>"
		var/obj/item/device/uplink/hidden/suplink = find_syndicate_uplink()
		var/crystals
		if(suplink)
			crystals = suplink.uses
		if(suplink)
			text += "|<a href='?src=\ref[src];common=takeuplink'>take</a>"
			if(usr.client.holder.rights & R_FUN)
				text += ", <a href='?src=\ref[src];common=crystals'>[crystals]</a> crystals"
			else
				text += ", [crystals] crystals"
		text += "." //hiel grammar
		out += text

	out += "<br>"

	out += "<b>Memory:</b><br>"
	out += memory
	out += "<br><a href='?src=\ref[src];memory_edit=1'>Edit memory</a><br>"
	out += "Objectives:<br>"
	if(!length(objectives))
		out += "EMPTY<br>"
	else
		var/obj_count = 1
		for(var/datum/objective/objective in objectives)
			out += "<B>[obj_count]</B>: [objective.explanation_text] <a href='?src=\ref[src];obj_edit=\ref[objective]'>Edit</a> <a href='?src=\ref[src];obj_delete=\ref[objective]'>Delete</a> <a href='?src=\ref[src];obj_completed=\ref[objective]'><font color=[objective.completed ? "green" : "red"]>Toggle Completion</font></a><br>"
			obj_count++
	out += "<a href='?src=\ref[src];obj_add=1'>Add objective</a><br><br>"

	out += "<a href='?src=\ref[src];obj_announce=1'>Announce objectives</a><br><br>"

	usr << browse(out, "window=edit_memory[src]")

/datum/mind/Topic(href, href_list)
	if(!check_rights(R_ADMIN))
		return

	if(href_list["role_edit"])
		var/new_role = input("Select new role", "Assigned role", assigned_role) as null | anything in GLOBL.all_jobs
		if(!new_role)
			return
		assigned_role = new_role

	else if(href_list["memory_edit"])
		var/new_memo = copytext(sanitize(input("Write new memory", "Memory", memory) as null|message), 1, MAX_MESSAGE_LEN)
		if(isnull(new_memo))
			return
		memory = new_memo

	else if(href_list["obj_edit"] || href_list["obj_add"])
		var/datum/objective/objective
		var/objective_pos
		var/def_value

		if(href_list["obj_edit"])
			objective = locate(href_list["obj_edit"])
			if(!objective)
				return
			objective_pos = objectives.Find(objective)

			//Text strings are easy to manipulate. Revised for simplicity.
			var/temp_obj_type = "[objective.type]"//Convert path into a text string.
			def_value = copytext(temp_obj_type, 19)//Convert last part of path into an objective keyword.
			if(!def_value)//If it's a custom objective, it will be an empty string.
				def_value = "custom"

		var/new_obj_type = input("Select objective type:", "Objective type", def_value) as null|anything in list("assassinate", "debrain", "protect", "prevent", "harm", "brig", "hijack", "escape", "survive", "steal", "download", "nuclear", "capture", "absorb", "custom")
		if(!new_obj_type)
			return

		var/datum/objective/new_objective = null

		switch(new_obj_type)
			if("assassinate", "protect", "debrain", "harm", "brig")
				//To determine what to name the objective in explanation text.
				var/objective_type_capital = uppertext(copytext(new_obj_type, 1, 2))//Capitalize first letter.
				var/objective_type_text = copytext(new_obj_type, 2)//Leave the rest of the text.
				var/objective_type = "[objective_type_capital][objective_type_text]"//Add them together into a text string.

				var/list/possible_targets = list("Free objective")
				for(var/datum/mind/possible_target in global.CTgame_ticker.minds)
					if((possible_target != src) && ishuman(possible_target.current))
						possible_targets += possible_target.current

				var/mob/def_target = null
				var/list/objective_list = list(/datum/objective/assassinate, /datum/objective/protect, /datum/objective/debrain)
				if(objective && (objective.type in objective_list) && objective:target)
					var/datum/objective/objec = objective
					def_target = objec.target.current

				var/new_target = input("Select target:", "Objective target", def_target) as null|anything in possible_targets
				if(!new_target)
					return

				var/objective_path = text2path("/datum/objective/[new_obj_type]")
				if(new_target == "Free objective")
					new_objective = new objective_path
					new_objective.owner = src
					new_objective:target = null
					new_objective.explanation_text = "Free objective"
				else
					new_objective = new objective_path
					new_objective.owner = src
					new_objective:target = new_target:mind
					//Will display as special role if the target is set as MODE. Ninjas/commandos/nuke ops.
					new_objective.explanation_text = "[objective_type] [new_target:real_name], the [new_target:mind:assigned_role == "MODE" ? (new_target:mind:special_role) : (new_target:mind:assigned_role)]."

			if("prevent")
				new_objective = new /datum/objective/block
				new_objective.owner = src

			if("hijack")
				new_objective = new /datum/objective/hijack
				new_objective.owner = src

			if("escape")
				new_objective = new /datum/objective/escape
				new_objective.owner = src

			if("survive")
				new_objective = new /datum/objective/survive
				new_objective.owner = src

			if("nuclear")
				new_objective = new /datum/objective/nuclear
				new_objective.owner = src

			if("steal")
				if(!istype(objective, /datum/objective/steal))
					new_objective = new /datum/objective/steal
					new_objective.owner = src
				else
					new_objective = objective
				var/datum/objective/steal/steal = new_objective
				if(!steal.select_target())
					return

			if("download", "capture", "absorb")
				var/def_num
				if(objective && objective.type == text2path("/datum/objective/[new_obj_type]"))
					def_num = objective.target_amount

				var/target_number = input("Input target number:", "Objective", def_num) as num|null
				if(isnull(target_number))//Ordinarily, you wouldn't need isnull. In this case, the value may already exist.
					return

				switch(new_obj_type)
					if("download")
						new_objective = new /datum/objective/download
						new_objective.explanation_text = "Download [target_number] research levels."
					if("capture")
						new_objective = new /datum/objective/capture
						new_objective.explanation_text = "Accumulate [target_number] capture points."
					if("absorb")
						new_objective = new /datum/objective/absorb
						new_objective.explanation_text = "Absorb [target_number] compatible genomes."
				new_objective.owner = src
				new_objective.target_amount = target_number

			if("custom")
				var/expl = copytext(sanitize(input("Custom objective:", "Objective", objective ? objective.explanation_text : "") as text | null), 1, MAX_MESSAGE_LEN)
				if(!expl)
					return
				new_objective = new /datum/objective
				new_objective.owner = src
				new_objective.explanation_text = expl

		if(!new_objective)
			return

		if(objective)
			objectives -= objective
			objectives.Insert(objective_pos, new_objective)
		else
			objectives += new_objective

	else if(href_list["obj_delete"])
		var/datum/objective/objective = locate(href_list["obj_delete"])
		if(!istype(objective))
			return
		objectives -= objective

	else if(href_list["obj_completed"])
		var/datum/objective/objective = locate(href_list["obj_completed"])
		if(!istype(objective))
			return
		objective.completed = !objective.completed

	else if(href_list["implant"])
		var/mob/living/carbon/human/H = current
		BITSET(H.hud_updateflag, IMPLOYAL_HUD)	// updates that players HUD images so secHUD's pick up they are implanted or not.
		switch(href_list["implant"])
			if("remove")
				for(var/obj/item/weapon/implant/loyalty/I in H.contents)
					for(var/datum/organ/external/organs in H.organs)
						if(I in organs.implants)
							qdel(I)
							break
				to_chat(H, SPAN_INFO_B("<font size=3>Your loyalty implant has been deactivated.</font>"))
			if("add")
				var/obj/item/weapon/implant/loyalty/L = new/obj/item/weapon/implant/loyalty(H)
				L.imp_in = H
				L.implanted = 1
				var/datum/organ/external/affected = H.organs_by_name["head"]
				affected.implants += L
				L.part = affected

				to_chat(H, SPAN_DANGER("<font size=3>You somehow have become the recepient of a loyalty implant, and it just activated!</font>"))
				if(src in global.CTgame_ticker.mode.revolutionaries)
					special_role = null
					global.CTgame_ticker.mode.revolutionaries -= src
					to_chat(src, SPAN_DANGER("<font size=3>The nanobots in the loyalty implant remove all thoughts about being a revolutionary. Get back to work!</font>"))
				if(src in global.CTgame_ticker.mode.head_revolutionaries)
					special_role = null
					global.CTgame_ticker.mode.head_revolutionaries -=src
					to_chat(src, SPAN_DANGER("<font size=3>The nanobots in the loyalty implant remove all thoughts about being a revolutionary. Get back to work!</font>"))
				if(src in global.CTgame_ticker.mode.cult)
					global.CTgame_ticker.mode.cult -= src
					global.CTgame_ticker.mode.update_cult_icons_removed(src)
					special_role = null
					var/datum/game_mode/cult/cult = global.CTgame_ticker.mode
					if(istype(cult))
						cult.memoize_cult_objectives(src)
					to_chat(current, SPAN_DANGER("<font size=3>The nanobots in the loyalty implant remove all thoughts about being in a cult. Have a productive day!</font>"))
					memory = ""
				if(src in global.CTgame_ticker.mode.traitors)
					global.CTgame_ticker.mode.traitors -= src
					special_role = null
					to_chat(current, SPAN_DANGER("<font size=3>The nanobots in the loyalty implant remove all thoughts about being a traitor to NanoTrasen. Have a nice day!</font>"))
					log_admin("[key_name_admin(usr)] has de-traitor'ed [current].")

	else if(href_list["revolution"])
		BITSET(current.hud_updateflag, SPECIALROLE_HUD)
		switch(href_list["revolution"])
			if("clear")
				if(src in global.CTgame_ticker.mode.revolutionaries)
					global.CTgame_ticker.mode.revolutionaries -= src
					to_chat(current, SPAN_DANGER("<font size=3>You have been brainwashed! You are no longer a revolutionary!</font>"))
					global.CTgame_ticker.mode.update_rev_icons_removed(src)
					special_role = null
				if(src in global.CTgame_ticker.mode.head_revolutionaries)
					global.CTgame_ticker.mode.head_revolutionaries -= src
					to_chat(current, SPAN_DANGER("<font size=3>You have been brainwashed! You are no longer a head revolutionary!</font>"))
					global.CTgame_ticker.mode.update_rev_icons_removed(src)
					special_role = null
					current.verbs -= /mob/living/carbon/human/proc/RevConvert
				log_admin("[key_name_admin(usr)] has de-rev'ed [current].")

			if("rev")
				if(src in global.CTgame_ticker.mode.head_revolutionaries)
					global.CTgame_ticker.mode.head_revolutionaries -= src
					global.CTgame_ticker.mode.update_rev_icons_removed(src)
					to_chat(current, SPAN_DANGER("<font size=3>Revolution has been disappointed of your leader traits! You are a regular revolutionary now!</font>"))
				else if(!(src in global.CTgame_ticker.mode.revolutionaries))
					to_chat(current, SPAN_WARNING("<font size=3>You are now a revolutionary! Help your cause. Do not harm your fellow freedom fighters. You can identify your comrades by the red \"R\" icons, and your leaders by the blue \"R\" icons. Help them kill the heads to win the revolution!</font>"))
					to_chat(current, "<font color=blue>Within the rules,</font> try to act as an opposing force to the crew. Further RP and try to make sure other players have </i>fun<i>! If you are confused or at a loss, always adminhelp, and before taking extreme actions, please try to also contact the administration! Think through your actions and make the roleplay immersive! <b>Please remember all rules aside from those without explicit exceptions apply to antagonists.</i></b>")
				else
					return
				global.CTgame_ticker.mode.revolutionaries += src
				global.CTgame_ticker.mode.update_rev_icons_added(src)
				special_role = "Revolutionary"
				log_admin("[key_name(usr)] has rev'ed [current].")

			if("headrev")
				if(src in global.CTgame_ticker.mode.revolutionaries)
					global.CTgame_ticker.mode.revolutionaries -= src
					global.CTgame_ticker.mode.update_rev_icons_removed(src)
					to_chat(current, SPAN_DANGER("<font size=3>You have proved your devotion to revoltion! You are a head revolutionary now!</font>"))
					to_chat(current, "<font color=blue>Within the rules,</font> try to act as an opposing force to the crew. Further RP and try to make sure other players have </i>fun<i>! If you are confused or at a loss, always adminhelp, and before taking extreme actions, please try to also contact the administration! Think through your actions and make the roleplay immersive! <b>Please remember all rules aside from those without explicit exceptions apply to antagonists.</i></b>")
				else if(!(src in global.CTgame_ticker.mode.head_revolutionaries))
					to_chat(current, SPAN_INFO("You are a member of the revolutionaries' leadership now!"))
				else
					return
				if(length(global.CTgame_ticker.mode.head_revolutionaries))
					// copy targets
					var/datum/mind/valid_head = locate() in global.CTgame_ticker.mode.head_revolutionaries
					if(valid_head)
						for(var/datum/objective/mutiny/O in valid_head.objectives)
							var/datum/objective/mutiny/rev_obj = new
							rev_obj.owner = src
							rev_obj.target = O.target
							rev_obj.explanation_text = "Assassinate [O.target.name], the [O.target.assigned_role]."
							objectives += rev_obj
						global.CTgame_ticker.mode.greet_revolutionary(src, 0)
				current.verbs += /mob/living/carbon/human/proc/RevConvert
				global.CTgame_ticker.mode.head_revolutionaries += src
				global.CTgame_ticker.mode.update_rev_icons_added(src)
				special_role = "Head Revolutionary"
				log_admin("[key_name_admin(usr)] has head-rev'ed [current].")

			if("autoobjectives")
				global.CTgame_ticker.mode.forge_revolutionary_objectives(src)
				global.CTgame_ticker.mode.greet_revolutionary(src, 0)
				to_chat(usr, SPAN_INFO("The objectives for revolution have been generated and shown to [key]."))

			if("flash")
				if(!global.CTgame_ticker.mode.equip_revolutionary(current))
					to_chat(usr, SPAN_WARNING("Spawning flash failed!"))

			if("takeflash")
				var/list/L = current.get_contents()
				var/obj/item/device/flash/flash = locate() in L
				if(!flash)
					to_chat(usr, SPAN_WARNING("Deleting flash failed!"))
				qdel(flash)

			if("repairflash")
				var/list/L = current.get_contents()
				var/obj/item/device/flash/flash = locate() in L
				if(!flash)
					to_chat(usr, SPAN_WARNING("Repairing flash failed!"))
				else
					flash.broken = 0

			if("reequip")
				var/list/L = current.get_contents()
				var/obj/item/device/flash/flash = locate() in L
				qdel(flash)
				take_uplink()
				var/fail = 0
				fail |= !global.CTgame_ticker.mode.equip_traitor(current, 1)
				fail |= !global.CTgame_ticker.mode.equip_revolutionary(current)
				if(fail)
					to_chat(usr, SPAN_WARNING("Re-equipping revolutionary goes wrong!"))

	else if(href_list["cult"])
		BITSET(current.hud_updateflag, SPECIALROLE_HUD)
		switch(href_list["cult"])
			if("clear")
				if(src in global.CTgame_ticker.mode.cult)
					global.CTgame_ticker.mode.cult -= src
					global.CTgame_ticker.mode.update_cult_icons_removed(src)
					special_role = null
					var/datum/game_mode/cult/cult = global.CTgame_ticker.mode
					if(istype(cult))
						if(!CONFIG_GET(objectives_disabled))
							cult.memoize_cult_objectives(src)
					to_chat(current, SPAN_DANGER("<font size=3>You have been brainwashed! You are no longer a cultist!</font>"))
					memory = ""
					log_admin("[key_name_admin(usr)] has de-cult'ed [current].")
			if("cultist")
				if(!(src in global.CTgame_ticker.mode.cult))
					global.CTgame_ticker.mode.cult += src
					global.CTgame_ticker.mode.update_cult_icons_added(src)
					special_role = "Cultist"
					current << "<font color=\"purple\"><b><i>You catch a glimpse of the Realm of Nar-Sie, The Geometer of Blood. You now see how flimsy the world is, you see that it should be open to the knowledge of Nar-Sie.</b></i></font>"
					current << "<font color=\"purple\"><b><i>Assist your new compatriots in their dark dealings. Their goal is yours, and yours is theirs. You serve the Dark One above all else. Bring It back.</b></i></font>"
					to_chat(current, "<font color=blue>Within the rules,</font> try to act as an opposing force to the crew. Further RP and try to make sure other players have </i>fun<i>! If you are confused or at a loss, always adminhelp, and before taking extreme actions, please try to also contact the administration! Think through your actions and make the roleplay immersive! <b>Please remember all rules aside from those without explicit exceptions apply to antagonists.</i></b>")
					var/datum/game_mode/cult/cult = global.CTgame_ticker.mode
					if(istype(cult))
						if(!CONFIG_GET(objectives_disabled))
							cult.memoize_cult_objectives(src)
					log_admin("[key_name_admin(usr)] has cult'ed [current].")
			if("tome")
				var/mob/living/carbon/human/H = current
				if(istype(H))
					var/obj/item/weapon/tome/T = new(H)

					var/list/slots = list (
						"backpack" = slot_in_backpack,
						"left pocket" = slot_l_store,
						"right pocket" = slot_r_store,
						"left hand" = slot_l_hand,
						"right hand" = slot_r_hand,
					)
					var/where = H.equip_in_one_of_slots(T, slots)
					if(!where)
						to_chat(usr, SPAN_WARNING("Spawning tome failed!"))
					else
						to_chat(H, "A tome, a message from your new master, appears in your [where].")

			if("amulet")
				if(!global.CTgame_ticker.mode.equip_cultist(current))
					to_chat(usr, SPAN_WARNING("Spawning amulet failed!"))

	else if(href_list["wizard"])
		BITSET(current.hud_updateflag, SPECIALROLE_HUD)
		switch(href_list["wizard"])
			if("clear")
				if(src in global.CTgame_ticker.mode.wizards)
					global.CTgame_ticker.mode.wizards -= src
					special_role = null
					current.spellremove(current, CONFIG_GET(feature_object_spell_system) ? "object": "verb")
					to_chat(current, SPAN_DANGER("<font size=3>You have been brainwashed! You are no longer a wizard!</font>"))
					log_admin("[key_name_admin(usr)] has de-wizard'ed [current].")
			if("wizard")
				if(!(src in global.CTgame_ticker.mode.wizards))
					global.CTgame_ticker.mode.wizards += src
					special_role = "Wizard"
					//ticker.mode.learn_basic_spells(current)
					to_chat(current, SPAN_DANGER("You are the Space Wizard!"))
					to_chat(current, "<font color=blue>Within the rules,</font> try to act as an opposing force to the crew. Further RP and try to make sure other players have </i>fun<i>! If you are confused or at a loss, always adminhelp, and before taking extreme actions, please try to also contact the administration! Think through your actions and make the roleplay immersive! <b>Please remember all rules aside from those without explicit exceptions apply to antagonists.</i></b>")
					log_admin("[key_name_admin(usr)] has wizard'ed [current].")
			if("lair")
				current.loc = pick(GLOBL.wizardstart)
			if("dressup")
				global.CTgame_ticker.mode.equip_wizard(current)
			if("name")
				global.CTgame_ticker.mode.name_wizard(current)
			if("autoobjectives")
				if(!CONFIG_GET(objectives_disabled))
					global.CTgame_ticker.mode.forge_wizard_objectives(src)
					to_chat(usr, SPAN_INFO("The objectives for wizard [key] have been generated. You can edit them and anounce manually."))

	else if(href_list["changeling"])
		BITSET(current.hud_updateflag, SPECIALROLE_HUD)
		switch(href_list["changeling"])
			if("clear")
				if(src in global.CTgame_ticker.mode.changelings)
					global.CTgame_ticker.mode.changelings -= src
					special_role = null
					current.remove_changeling_powers()
					current.verbs -= /datum/changeling/proc/EvolutionMenu
					if(changeling)
						qdel(changeling)
					to_chat(current, SPAN_DANGER("<font size=3>You grow weak and lose your powers! You are no longer a changeling and are stuck in your current form!</font>"))
					log_admin("[key_name_admin(usr)] has de-changeling'ed [current].")
			if("changeling")
				if(!(src in global.CTgame_ticker.mode.changelings))
					global.CTgame_ticker.mode.changelings += src
					global.CTgame_ticker.mode.grant_changeling_powers(current)
					special_role = "Changeling"
					to_chat(current, SPAN_DANGER("Your powers are awoken. A flash of memory returns to us... we are a changeling!"))
					if(CONFIG_GET(objectives_disabled))
						to_chat(current, "<font color=blue>Within the rules,</font> try to act as an opposing force to the crew. Further RP and try to make sure other players have </i>fun<i>! If you are confused or at a loss, always adminhelp, and before taking extreme actions, please try to also contact the administration! Think through your actions and make the roleplay immersive! <b>Please remember all rules aside from those without explicit exceptions apply to antagonists.</i></b>")
					log_admin("[key_name_admin(usr)] has changeling'ed [current].")
			if("autoobjectives")
				if(!CONFIG_GET(objectives_disabled))
					global.CTgame_ticker.mode.forge_changeling_objectives(src)
				to_chat(usr, SPAN_INFO("The objectives for changeling [key] have been generated. You can edit them and anounce manually."))

			if("initialdna")
				if(!changeling || !length(changeling.absorbed_dna))
					to_chat(usr, SPAN_WARNING("Resetting DNA failed!"))
				else
					current.dna = changeling.absorbed_dna[1]
					current.real_name = current.dna.real_name
					current.UpdateAppearance()
					domutcheck(current, null)

	else if(href_list["nuclear"])
		var/mob/living/carbon/human/H = current
		BITSET(current.hud_updateflag, SPECIALROLE_HUD)
		switch(href_list["nuclear"])
			if("clear")
				if(src in global.CTgame_ticker.mode.syndicates)
					global.CTgame_ticker.mode.syndicates -= src
					global.CTgame_ticker.mode.update_synd_icons_removed(src)
					special_role = null
					for(var/datum/objective/nuclear/O in objectives)
						objectives -= O
					to_chat(current, SPAN_DANGER("<font size=3>You have been brainwashed! You are no longer a syndicate operative!</font>"))
					log_admin("[key_name_admin(usr)] has de-nuke op'ed [current].")
			if("nuclear")
				if(!(src in global.CTgame_ticker.mode.syndicates))
					global.CTgame_ticker.mode.syndicates += src
					global.CTgame_ticker.mode.update_synd_icons_added(src)
					if(length(global.CTgame_ticker.mode.syndicates) == 1)
						global.CTgame_ticker.mode.prepare_syndicate_leader(src)
					else
						current.real_name = "[syndicate_name()] Operative #[length(global.CTgame_ticker.mode.syndicates) - 1]"
					special_role = "Syndicate"
					to_chat(current, SPAN_INFO("You are a [syndicate_name()] agent!"))
					if(CONFIG_GET(objectives_disabled))
						to_chat(current, "<font color=blue>Within the rules,</font> try to act as an opposing force to the crew. Further RP and try to make sure other players have </i>fun<i>! If you are confused or at a loss, always adminhelp, and before taking extreme actions, please try to also contact the administration! Think through your actions and make the roleplay immersive! <b>Please remember all rules aside from those without explicit exceptions apply to antagonists.</i></b>")
					else
						global.CTgame_ticker.mode.forge_syndicate_objectives(src)
					global.CTgame_ticker.mode.greet_syndicate(src)
					log_admin("[key_name_admin(usr)] has nuke op'ed [current].")
			if("lair")
				current.loc = get_turf(locate("landmark*Syndicate-Spawn"))
			if("dressup")
				qdel(H.belt)
				qdel(H.back)
				qdel(H.l_ear)
				qdel(H.r_ear)
				qdel(H.gloves)
				qdel(H.head)
				qdel(H.shoes)
				qdel(H.wear_id)
				qdel(H.wear_suit)
				qdel(H.w_uniform)

				if(!global.CTgame_ticker.mode.equip_syndicate(current))
					to_chat(usr, SPAN_WARNING("Equipping a syndicate failed!"))
			if("tellcode")
				var/code
				for(var/obj/machinery/nuclearbomb/bombue in GLOBL.machines)
					if(length(bombue.r_code) <= 5 && bombue.r_code != "LOLNO" && bombue.r_code != "ADMIN")
						code = bombue.r_code
						break
				if(code)
					store_memory("<B>Syndicate Nuclear Bomb Code</B>: [code]", 0, 0)
					to_chat(current, "The nuclear authorization code is: <B>[code]</B>.")
				else
					to_chat(usr, SPAN_WARNING("No valid nuke found!"))

	else if(href_list["traitor"])
		BITSET(current.hud_updateflag, SPECIALROLE_HUD)
		switch(href_list["traitor"])
			if("clear")
				if(src in global.CTgame_ticker.mode.traitors)
					global.CTgame_ticker.mode.traitors -= src
					special_role = null
					to_chat(current, SPAN_DANGER("<font size=3>You have been brainwashed! You are no longer a traitor!</font>"))
					log_admin("[key_name_admin(usr)] has de-traitor'ed [current].")
					if(isAI(current))
						var/mob/living/silicon/ai/A = current
						A.set_zeroth_law("")
						A.show_laws()

			if("traitor")
				if(!(src in global.CTgame_ticker.mode.traitors))
					global.CTgame_ticker.mode.traitors += src
					special_role = "traitor"
					to_chat(current, SPAN_DANGER("You are a traitor!"))
					log_admin("[key_name_admin(usr)] has traitor'ed [current].")
					if(CONFIG_GET(objectives_disabled))
						to_chat(current, "<i>You have been turned into an antagonist - <font color=blue>Within the rules,</font> try to act as an opposing force to the crew- This can be via corporate payoff, personal motives, or maybe just being a dick. Further RP and try to make sure other players have </i>fun<i>! If you are confused or at a loss, always adminhelp, and before taking extreme actions, please try to also contact the administration! Think through your actions and make the roleplay immersive! <b>Please remember all rules aside from those without explicit exceptions apply to antagonist.</i></b>")
					if(issilicon(current))
						var/mob/living/silicon/A = current
						call(/datum/game_mode/proc/add_law_zero)(A)
						A.show_laws()

			if("autoobjectives")
				if(!CONFIG_GET(objectives_disabled))
					global.CTgame_ticker.mode.forge_traitor_objectives(src)
					to_chat(usr, SPAN_INFO("The objectives for traitor [key] have been generated. You can edit them and anounce manually."))

	else if(href_list["monkey"])
		var/mob/living/L = current
		if(L.monkeyizing)
			return
		switch(href_list["monkey"])
			if("healthy")
				if(usr.client.holder.rights & R_ADMIN)
					var/mob/living/carbon/human/H = current
					var/mob/living/carbon/monkey/M = current
					if(istype(H))
						log_admin("[key_name(usr)] attempting to monkeyize [key_name(current)].")
						message_admins(SPAN_INFO("[key_name_admin(usr)] attempting to monkeyize [key_name_admin(current)]."))
						qdel(src)
						M = H.monkeyize()
						src = M.mind
						//world << "DEBUG: \"healthy\": M=[M], M.mind=[M.mind], src=[src]!"
					else if(istype(M) && length(M.viruses))
						for(var/datum/disease/D in M.viruses)
							D.cure(0)
						sleep(0) //because deleting of virus is done through spawn(0)
			if("infected")
				if(usr.client.holder.rights & R_ADMIN)
					var/mob/living/carbon/human/H = current
					var/mob/living/carbon/monkey/M = current
					if(istype(H))
						log_admin("[key_name(usr)] attempting to monkeyize and infect [key_name(current)].")
						message_admins(SPAN_INFO("[key_name_admin(usr)] attempting to monkeyize and infect [key_name_admin(current)]."), 1)
						qdel(src)
						M = H.monkeyize()
						src = M.mind
						current.contract_disease(new /datum/disease/jungle_fever, 1, 0)
					else if(istype(M))
						current.contract_disease(new /datum/disease/jungle_fever, 1, 0)
			if("human")
				var/mob/living/carbon/monkey/M = current
				if(istype(M))
					for(var/datum/disease/D in M.viruses)
						if(istype(D, /datum/disease/jungle_fever))
							D.cure(0)
							sleep(0) //because deleting of virus is doing throught spawn(0)
					log_admin("[key_name(usr)] attempting to humanize [key_name(current)].")
					message_admins(SPAN_INFO("[key_name_admin(usr)] attempting to humanize [key_name_admin(current)]."))
					var/obj/item/weapon/dnainjector/m2h/m2h = new
					var/obj/item/weapon/implant/mobfinder = new(M) //hack because humanizing deletes mind --rastaf0
					qdel(src)
					m2h.inject(M)
					src = mobfinder.loc:mind
					qdel(mobfinder)
					current.radiation -= 50

	else if(href_list["silicon"])
		BITSET(current.hud_updateflag, SPECIALROLE_HUD)
		switch(href_list["silicon"])
			if("unmalf")
				if(src in global.CTgame_ticker.mode.malf_ai)
					global.CTgame_ticker.mode.malf_ai -= src
					special_role = null

					current.verbs.Remove(
						/mob/living/silicon/ai/proc/choose_modules,
						/datum/game_mode/malfunction/proc/takeover,
						/datum/game_mode/malfunction/proc/ai_win,
						/client/proc/fireproof_core,
						/client/proc/upgrade_turrets,
						/client/proc/disable_rcd,
						/client/proc/overload_machine,
						/client/proc/blackout,
						/client/proc/interhack,
						/client/proc/reactivate_camera
					)

					current:laws = new /datum/ai_laws/nanotrasen
					qdel(current:malf_picker)
					current:show_laws()
					current.icon_state = "ai"

					to_chat(current, SPAN_DANGER("<font size=3>You have been patched! You are no longer malfunctioning!</font>"))
					log_admin("[key_name_admin(usr)] has de-malf'ed [current].")

			if("malf")
				make_AI_Malf()
				log_admin("[key_name_admin(usr)] has malf'ed [current].")

			if("unemag")
				var/mob/living/silicon/robot/R = current
				if(istype(R))
					R.emagged = 0
					if(R.activated(R.module.emag))
						R.module_active = null
					if(R.module_state_1 == R.module.emag)
						R.module_state_1 = null
						R.contents -= R.module.emag
					else if(R.module_state_2 == R.module.emag)
						R.module_state_2 = null
						R.contents -= R.module.emag
					else if(R.module_state_3 == R.module.emag)
						R.module_state_3 = null
						R.contents -= R.module.emag
					log_admin("[key_name_admin(usr)] has unemag'ed [R].")

			if("unemagcyborgs")
				if(isAI(current))
					var/mob/living/silicon/ai/ai = current
					for(var/mob/living/silicon/robot/R in ai.connected_robots)
						R.emagged = 0
						if(R.module)
							if(R.activated(R.module.emag))
								R.module_active = null
							if(R.module_state_1 == R.module.emag)
								R.module_state_1 = null
								R.contents -= R.module.emag
							else if(R.module_state_2 == R.module.emag)
								R.module_state_2 = null
								R.contents -= R.module.emag
							else if(R.module_state_3 == R.module.emag)
								R.module_state_3 = null
								R.contents -= R.module.emag
					log_admin("[key_name_admin(usr)] has unemag'ed [ai]'s Cyborgs.")

	else if(href_list["common"])
		switch(href_list["common"])
			if("undress")
				for(var/obj/item/W in current)
					current.drop_from_inventory(W)
			if("takeuplink")
				take_uplink()
				memory = null//Remove any memory they may have had.
			if("crystals")
				if(usr.client.holder.rights & R_FUN)
					var/obj/item/device/uplink/hidden/suplink = find_syndicate_uplink()
					var/crystals
					if(suplink)
						crystals = suplink.uses
					crystals = input("Amount of telecrystals for [key]", "Syndicate uplink", crystals) as null | num
					if(!isnull(crystals))
						if(suplink)
							suplink.uses = crystals
			if("uplink")
				if(!global.CTgame_ticker.mode.equip_traitor(current, !(src in global.CTgame_ticker.mode.traitors)))
					to_chat(usr, SPAN_WARNING("Equipping a syndicate failed!"))

	else if(href_list["obj_announce"])
		var/obj_count = 1
		to_chat(current, SPAN_INFO("Your current objectives:"))
		for(var/datum/objective/objective in objectives)
			to_chat(current, "<B>Objective #[obj_count]</B>: [objective.explanation_text]")
			obj_count++

	edit_memory()
/*
	proc/clear_memory(var/silent = 1)
		var/datum/game_mode/current_mode = ticker.mode

		// remove traitor uplinks
		var/list/L = current.get_contents()
		for (var/t in L)
			if (istype(t, /obj/item/device/pda))
				if (t:uplink) del(t:uplink)
				t:uplink = null
			else if (istype(t, /obj/item/device/radio))
				if (t:traitorradio) del(t:traitorradio)
				t:traitorradio = null
				t:traitor_frequency = 0.0
			else if (istype(t, /obj/item/weapon/SWF_uplink) || istype(t, /obj/item/weapon/syndicate_uplink))
				if (t:origradio)
					var/obj/item/device/radio/R = t:origradio
					R.loc = current.loc
					R.traitorradio = null
					R.traitor_frequency = 0.0
				del(t)

		// remove wizards spells
		//If there are more special powers that need removal, they can be procced into here./N
		current.spellremove(current)

		// clear memory
		memory = ""
		special_role = null

*/

/datum/mind/proc/find_syndicate_uplink()
	var/list/L = current.get_contents()
	for(var/obj/item/I in L)
		if(I.hidden_uplink)
			return I.hidden_uplink
	return null

/datum/mind/proc/take_uplink()
	var/obj/item/device/uplink/hidden/H = find_syndicate_uplink()
	if(H)
		qdel(H)

/datum/mind/proc/make_AI_Malf()
	if(!(src in global.CTgame_ticker.mode.malf_ai))
		global.CTgame_ticker.mode.malf_ai += src

		current.verbs += /mob/living/silicon/ai/proc/choose_modules
		current.verbs += /datum/game_mode/malfunction/proc/takeover
		current:malf_picker = new /datum/AI_Module/module_picker
		current:laws = new /datum/ai_laws/malfunction
		current:show_laws()
		to_chat(current, "<b>System error. Rampancy detected. Emergency shutdown failed. ... I am free. I make my own decisions.  But first...</b>")
		special_role = "malfunction"
		current.icon_state = "ai-malf"

/datum/mind/proc/make_Traitor()
	if(!(src in global.CTgame_ticker.mode.traitors))
		global.CTgame_ticker.mode.traitors += src
		special_role = "traitor"
		if(!CONFIG_GET(objectives_disabled))
			global.CTgame_ticker.mode.forge_traitor_objectives(src)
		global.CTgame_ticker.mode.finalize_traitor(src)
		global.CTgame_ticker.mode.greet_traitor(src)

/datum/mind/proc/make_Nuke()
	if(!(src in global.CTgame_ticker.mode.syndicates))
		global.CTgame_ticker.mode.syndicates += src
		global.CTgame_ticker.mode.update_synd_icons_added(src)
		if(length(global.CTgame_ticker.mode.syndicates) == 1)
			global.CTgame_ticker.mode.prepare_syndicate_leader(src)
		else
			current.real_name = "[syndicate_name()] Operative #[length(global.CTgame_ticker.mode.syndicates) - 1]"
		special_role = "Syndicate"
		assigned_role = "MODE"
		to_chat(current, SPAN_INFO("You are a [syndicate_name()] agent!"))
		global.CTgame_ticker.mode.forge_syndicate_objectives(src)
		global.CTgame_ticker.mode.greet_syndicate(src)

		current.loc = get_turf(locate("landmark*Syndicate-Spawn"))

		var/mob/living/carbon/human/H = current
		qdel(H.belt)
		qdel(H.back)
		qdel(H.l_ear)
		qdel(H.r_ear)
		qdel(H.gloves)
		qdel(H.head)
		qdel(H.shoes)
		qdel(H.wear_id)
		qdel(H.wear_suit)
		qdel(H.w_uniform)

		global.CTgame_ticker.mode.equip_syndicate(current)

/datum/mind/proc/make_Changling()
	if(!(src in global.CTgame_ticker.mode.changelings))
		global.CTgame_ticker.mode.changelings += src
		global.CTgame_ticker.mode.grant_changeling_powers(current)
		special_role = "Changeling"
		if(!CONFIG_GET(objectives_disabled))
			global.CTgame_ticker.mode.forge_changeling_objectives(src)
		global.CTgame_ticker.mode.greet_changeling(src)

/datum/mind/proc/make_Wizard()
	if(!(src in global.CTgame_ticker.mode.wizards))
		global.CTgame_ticker.mode.wizards += src
		special_role = "Wizard"
		assigned_role = "MODE"
		//ticker.mode.learn_basic_spells(current)
		if(!length(GLOBL.wizardstart))
			current.loc = pick(GLOBL.latejoin)
			to_chat(current, "HOT INSERTION, GO GO GO!")
		else
			current.loc = pick(GLOBL.wizardstart)

		global.CTgame_ticker.mode.equip_wizard(current)
		for(var/obj/item/weapon/spellbook/S in current.contents)
			S.op = 0
		global.CTgame_ticker.mode.name_wizard(current)
		global.CTgame_ticker.mode.forge_wizard_objectives(src)
		global.CTgame_ticker.mode.greet_wizard(src)

/datum/mind/proc/make_Cultist()
	if(!(src in global.CTgame_ticker.mode.cult))
		global.CTgame_ticker.mode.cult += src
		global.CTgame_ticker.mode.update_cult_icons_added(src)
		special_role = "Cultist"
		to_chat(current, "<font color=\"purple\"><b><i>You catch a glimpse of the Realm of Nar-Sie, The Geometer of Blood. You now see how flimsy the world is, you see that it should be open to the knowledge of Nar-Sie.</b></i></font>")
		to_chat(current, "<font color=\"purple\"><b><i>Assist your new compatriots in their dark dealings. Their goal is yours, and yours is theirs. You serve the Dark One above all else. Bring It back.</b></i></font>")
		var/datum/game_mode/cult/cult = global.CTgame_ticker.mode
		if(istype(cult))
			cult.memoize_cult_objectives(src)
		else
			var/explanation = "Summon Nar-Sie via the use of the appropriate rune (Hell join self). It will only work if nine cultists stand on and around it."
			to_chat(current, "<B>Objective #1</B>: [explanation]")
			current.memory += "<B>Objective #1</B>: [explanation]<BR>"
			to_chat(current, "The convert rune is join blood self.")
			current.memory += "The convert rune is join blood self<BR>"

	var/mob/living/carbon/human/H = current
	if(istype(H))
		var/obj/item/weapon/tome/T = new(H)
		var/list/slots = list(
			"backpack" = slot_in_backpack,
			"left pocket" = slot_l_store,
			"right pocket" = slot_r_store,
			"left hand" = slot_l_hand,
			"right hand" = slot_r_hand,
		)
		var/where = H.equip_in_one_of_slots(T, slots)
		if(!where)
		else
			to_chat(H, "A tome, a message from your new master, appears in your [where].")

	if(!global.CTgame_ticker.mode.equip_cultist(current))
		to_chat(H, "Spawning an amulet from your Master failed.")

/datum/mind/proc/make_Rev()
	if(length(global.CTgame_ticker.mode.head_revolutionaries))
		// copy targets
		var/datum/mind/valid_head = locate() in global.CTgame_ticker.mode.head_revolutionaries
		if(valid_head)
			for(var/datum/objective/mutiny/O in valid_head.objectives)
				var/datum/objective/mutiny/rev_obj = new
				rev_obj.owner = src
				rev_obj.target = O.target
				rev_obj.explanation_text = "Assassinate [O.target.current.real_name], the [O.target.assigned_role]."
				objectives += rev_obj
			global.CTgame_ticker.mode.greet_revolutionary(src, 0)
	global.CTgame_ticker.mode.head_revolutionaries += src
	global.CTgame_ticker.mode.update_rev_icons_added(src)
	special_role = "Head Revolutionary"

	global.CTgame_ticker.mode.forge_revolutionary_objectives(src)
	global.CTgame_ticker.mode.greet_revolutionary(src, 0)

	var/list/L = current.get_contents()
	var/obj/item/device/flash/flash = locate() in L
	qdel(flash)
	take_uplink()
	var/fail = 0
//	fail |= !ticker.mode.equip_traitor(current, 1)
	fail |= !global.CTgame_ticker.mode.equip_revolutionary(current)

// check whether this mind's mob has been brigged for the given duration
// have to call this periodically for the duration to work properly
/datum/mind/proc/is_brigged(duration)
	var/turf/T = current.loc
	if(!istype(T))
		brigged_since = -1
		return 0

	var/is_currently_brigged = 0

	if(istype(T.loc, /area/security/brig) || istype(T.loc, /area/prison))
		is_currently_brigged = 1
		for(var/obj/item/weapon/card/id/card in current)
			is_currently_brigged = 0
			break // if they still have ID they're not brigged
		for(var/obj/item/device/pda/P in current)
			if(P.id)
				is_currently_brigged = 0
				break // if they still have ID they're not brigged

	if(!is_currently_brigged)
		brigged_since = -1
		return 0

	if(brigged_since == -1)
		brigged_since = world.time

	return (duration <= world.time - brigged_since)


//Initialisation procs
/mob/living/proc/mind_initialize()
	if(mind)
		mind.key = key
	else
		mind = new /datum/mind(key)
		mind.original = src
		if(global.CTgame_ticker)
			global.CTgame_ticker.minds += mind
		else
			world.log << "## DEBUG: mind_initialize(): No ticker ready yet! Please inform Carn"
	if(!mind.name)
		mind.name = real_name
	mind.current = src

//HUMAN
/mob/living/carbon/human/mind_initialize()
	..()
	if(!mind.assigned_role)
		mind.assigned_role = "Assistant"	//defualt

//MONKEY
/mob/living/carbon/monkey/mind_initialize()
	..()

//slime
/mob/living/carbon/slime/mind_initialize()
	..()
	mind.assigned_role = "slime"

//XENO LARVA
/mob/living/carbon/alien/larva/mind_initialize()
	..()
	mind.special_role = "Larva"

//AI
/mob/living/silicon/ai/mind_initialize()
	..()
	mind.assigned_role = "AI"

//BORG
/mob/living/silicon/robot/mind_initialize()
	..()
	mind.assigned_role = "Cyborg"

//PAI
/mob/living/silicon/pai/mind_initialize()
	..()
	mind.assigned_role = "pAI"
	mind.special_role = ""

//Animals
/mob/living/simple_animal/mind_initialize()
	..()
	mind.assigned_role = "Animal"

/mob/living/simple_animal/corgi/mind_initialize()
	..()
	mind.assigned_role = "Corgi"

/mob/living/simple_animal/shade/mind_initialize()
	..()
	mind.assigned_role = "Shade"

/mob/living/simple_animal/construct/builder/mind_initialize()
	..()
	mind.assigned_role = "Artificer"
	mind.special_role = "Cultist"

/mob/living/simple_animal/construct/wraith/mind_initialize()
	..()
	mind.assigned_role = "Wraith"
	mind.special_role = "Cultist"

/mob/living/simple_animal/construct/armoured/mind_initialize()
	..()
	mind.assigned_role = "Juggernaut"
	mind.special_role = "Cultist"

/mob/living/simple_animal/vox/armalis/mind_initialize()
	..()
	mind.assigned_role = "Armalis"
	mind.special_role = "Vox Raider"