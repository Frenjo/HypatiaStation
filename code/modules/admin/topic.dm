/datum/admins/Topic(href, href_list)
	..()

	if(usr.client != src.owner || !check_rights(0))
		log_admin("[key_name(usr)] tried to use the admin panel without authorisation.")
		message_admins("[usr.key] has attempted to override the admin panel!")
		return

	if(href_list["makeAntag"])
		switch(href_list["makeAntag"])
			if("1")
				log_admin("[key_name(usr)] has spawned a traitor.")
				if(!make_traitors())
					usr << "\red Unfortunately there weren't enough candidates available."
			if("2")
				log_admin("[key_name(usr)] has spawned a changeling.")
				if(!make_changelings())
					usr << "\red Unfortunately there weren't enough candidates available."
			if("3")
				log_admin("[key_name(usr)] has spawned revolutionaries.")
				if(!make_revolutionaries())
					usr << "\red Unfortunately there weren't enough candidates available."
			if("4")
				log_admin("[key_name(usr)] has spawned a cultists.")
				if(!make_cult())
					usr << "\red Unfortunately there weren't enough candidates available."
			if("5")
				log_admin("[key_name(usr)] has spawned a malf AI.")
				if(!make_ai_malfunction())
					usr << "\red Unfortunately there weren't enough candidates available."
			if("6")
				log_admin("[key_name(usr)] has spawned a wizard.")
				if(!make_wizard())
					usr << "\red Unfortunately there weren't enough candidates available."
			if("7")
				log_admin("[key_name(usr)] has spawned a nuke team.")
				if(!make_nuclear_operatives())
					usr << "\red Unfortunately there weren't enough candidates available."
			if("8")
				log_admin("[key_name(usr)] has spawned a ninja.")
				make_space_ninja()
			if("9")
				log_admin("[key_name(usr)] has spawned aliens.")
				make_aliens()
			if("10")
				log_admin("[key_name(usr)] has spawned a death squad.")
			if("11")
				log_admin("[key_name(usr)] has spawned vox raiders.")
				if(!make_vox_raiders())
					usr << "\red Unfortunately there weren't enough candidates available."
	else if(href_list["dbsearchckey"] || href_list["dbsearchadmin"])
		var/adminckey = href_list["dbsearchadmin"]
		var/playerckey = href_list["dbsearchckey"]

		DB_ban_panel(playerckey, adminckey)
		return

	else if(href_list["dbbanedit"])
		var/banedit = href_list["dbbanedit"]
		var/banid = text2num(href_list["dbbanid"])
		if(!banedit || !banid)
			return

		DB_ban_edit(banid, banedit)
		return

	else if(href_list["dbbanaddtype"])

		var/bantype = text2num(href_list["dbbanaddtype"])
		var/banckey = href_list["dbbanaddckey"]
		var/banduration = text2num(href_list["dbbaddduration"])
		var/banjob = href_list["dbbanaddjob"]
		var/banreason = href_list["dbbanreason"]

		banckey = ckey(banckey)

		switch(bantype)
			if(BANTYPE_PERMA)
				if(!banckey || !banreason)
					usr << "Not enough parameters (Requires ckey and reason)"
					return
				banduration = null
				banjob = null
			if(BANTYPE_TEMP)
				if(!banckey || !banreason || !banduration)
					usr << "Not enough parameters (Requires ckey, reason and duration)"
					return
				banjob = null
			if(BANTYPE_JOB_PERMA)
				if(!banckey || !banreason || !banjob)
					usr << "Not enough parameters (Requires ckey, reason and job)"
					return
				banduration = null
			if(BANTYPE_JOB_TEMP)
				if(!banckey || !banreason || !banjob || !banduration)
					usr << "Not enough parameters (Requires ckey, reason and job)"
					return

		var/mob/playermob

		for_no_type_check(var/mob/M, GLOBL.player_list)
			if(M.ckey == banckey)
				playermob = M
				break

		banreason = "(MANUAL BAN) "+banreason

		DB_ban_record(bantype, playermob, banduration, banreason, banjob, null, banckey)

	else if(href_list["editrights"])
		if(!check_rights(R_PERMISSIONS))
			message_admins("[key_name_admin(usr)] attempted to edit the admin permissions without sufficient rights.")
			log_admin("[key_name(usr)] attempted to edit the admin permissions without sufficient rights.")
			return

		var/adm_ckey

		var/task = href_list["editrights"]
		if(task == "add")
			var/new_ckey = ckey(input(usr,"New admin's ckey","Admin ckey", null) as text|null)
			if(!new_ckey)	return
			if(new_ckey in GLOBL.admin_datums)
				usr << "<font color='red'>Error: Topic 'editrights': [new_ckey] is already an admin</font>"
				return
			adm_ckey = new_ckey
			task = "rank"
		else if(task != "show")
			adm_ckey = ckey(href_list["ckey"])
			if(!adm_ckey)
				usr << "<font color='red'>Error: Topic 'editrights': No valid ckey</font>"
				return

		var/datum/admins/D = GLOBL.admin_datums[adm_ckey]

		if(task == "remove")
			if(alert("Are you sure you want to remove [adm_ckey]?","Message","Yes","Cancel") == "Yes")
				if(!D)	return
				GLOBL.admin_datums -= adm_ckey
				D.disassociate()

				message_admins("[key_name_admin(usr)] removed [adm_ckey] from the admins list")
				log_admin("[key_name(usr)] removed [adm_ckey] from the admins list")
				log_admin_rank_modification(adm_ckey, "Removed")

		else if(task == "rank")
			var/new_rank
			if(length(GLOBL.admin_ranks))
				new_rank = input("Please select a rank", "New rank", null, null) as null|anything in (GLOBL.admin_ranks|"*New Rank*")
			else
				new_rank = input("Please select a rank", "New rank", null, null) as null|anything in list("Game Master","Game Admin", "Trial Admin", "Admin Observer","*New Rank*")

			var/rights = 0
			if(D)
				rights = D.rights
			switch(new_rank)
				if(null,"") return
				if("*New Rank*")
					new_rank = input("Please input a new rank", "New custom rank", null, null) as null|text
					if(CONFIG_GET(/decl/configuration_entry/admin_legacy_system))
						new_rank = ckeyEx(new_rank)
					if(!new_rank)
						usr << "<font color='red'>Error: Topic 'editrights': Invalid rank</font>"
						return
					if(CONFIG_GET(/decl/configuration_entry/admin_legacy_system))
						if(length(GLOBL.admin_ranks))
							if(new_rank in GLOBL.admin_ranks)
								rights = GLOBL.admin_ranks[new_rank]		//we typed a rank which already exists, use its rights
							else
								GLOBL.admin_ranks[new_rank] = 0			//add the new rank to admin_ranks
				else
					if(CONFIG_GET(/decl/configuration_entry/admin_legacy_system))
						new_rank = ckeyEx(new_rank)
						rights = GLOBL.admin_ranks[new_rank]				//we input an existing rank, use its rights

			if(D)
				D.disassociate()								//remove adminverbs and unlink from client
				D.rank = new_rank								//update the rank
				D.rights = rights								//update the rights based on admin_ranks (default: 0)
			else
				D = new /datum/admins(new_rank, rights, adm_ckey)

			var/client/C = GLOBL.directory[adm_ckey]				//find the client with the specified ckey (if they are logged in)
			D.associate(C)											//link up with the client and add verbs

			message_admins("[key_name_admin(usr)] edited the admin rank of [adm_ckey] to [new_rank]")
			log_admin("[key_name(usr)] edited the admin rank of [adm_ckey] to [new_rank]")
			log_admin_rank_modification(adm_ckey, new_rank)

		else if(task == "permissions")
			if(!D)	return
			var/list/permissionlist = list()
			for(var/i=1, i<=R_MAXPERMISSION, i<<=1)		//that <<= is shorthand for i = i << 1. Which is a left bitshift
				permissionlist[rights2text(i)] = i
			var/new_permission = input("Select a permission to turn on/off", "Permission toggle", null, null) as null|anything in permissionlist
			if(!new_permission)	return
			D.rights ^= permissionlist[new_permission]

			message_admins("[key_name_admin(usr)] toggled the [new_permission] permission of [adm_ckey]")
			log_admin("[key_name(usr)] toggled the [new_permission] permission of [adm_ckey]")
			log_admin_permission_modification(adm_ckey, permissionlist[new_permission])

		edit_admin_permissions()

	else if(href_list["call_shuttle"])
		if(!check_rights(R_ADMIN))	return

		if(global.PCticker.mode.name == "blob")
			alert("You can't call the shuttle during blob!")
			return

		switch(href_list["call_shuttle"])
			if("1")
				if(!global.PCticker || !global.PCemergency.location())
					return
				global.PCemergency.call_evac()
				captain_announce("The emergency shuttle has been called. It will arrive in [round(global.PCemergency.estimate_arrival_time() / 60)] minutes.")
				log_admin("[key_name(usr)] called the Emergency Shuttle")
				message_admins("\blue [key_name_admin(usr)] called the Emergency Shuttle to the station", 1)

			if("2")
				if(!global.PCticker || !global.PCemergency.location())
					return
				if(global.PCemergency.can_call())
					global.PCemergency.call_evac()
					captain_announce("The emergency shuttle has been called. It will arrive in [round(global.PCemergency.estimate_arrival_time() / 60)] minutes.")
					log_admin("[key_name(usr)] called the Emergency Shuttle")
					message_admins("\blue [key_name_admin(usr)] called the Emergency Shuttle to the station", 1)
				else
					global.PCemergency.recall()
					log_admin("[key_name(usr)] sent the Emergency Shuttle back")
					message_admins("\blue [key_name_admin(usr)] sent the Emergency Shuttle back", 1)

		href_list["secretsadmin"] = "check_antagonist"

	else if(href_list["edit_shuttle_time"])
		if(!check_rights(R_SERVER))	return

		//emergency_shuttle.settimeleft( input("Enter new shuttle duration (seconds):","Edit Shuttle Timeleft", emergency_shuttle.timeleft() ) as num )
		/*emergency_shuttle.settimeleft( input("Enter new shuttle duration (seconds):","Edit Shuttle Timeleft", emergency_shuttle.estimate_arrival_time() ) as num ) // Updated to reflect 'shuttles' port. -Frenjo
		log_admin("[key_name(usr)] edited the Emergency Shuttle's timeleft to [emergency_shuttle.timeleft()]")
		captain_announce("The emergency shuttle has been called. It will arrive in [round(emergency_shuttle.timeleft()/60)] minutes.")
		message_admins("\blue [key_name_admin(usr)] edited the Emergency Shuttle's timeleft to [emergency_shuttle.timeleft()]", 1)
		href_list["secretsadmin"] = "check_antagonist"*/

	else if(href_list["delay_round_end"])
		if(!check_rights(R_SERVER))	return

		global.PCticker.delay_end = !global.PCticker.delay_end
		log_admin("[key_name(usr)] [global.PCticker.delay_end ? "delayed the round end" : "has made the round end normally"].")
		message_admins("\blue [key_name(usr)] [global.PCticker.delay_end ? "delayed the round end" : "has made the round end normally"].", 1)
		href_list["secretsadmin"] = "check_antagonist"

	else if(href_list["simplemake"])
		if(!check_rights(R_SPAWN))	return

		var/mob/M = locate(href_list["mob"])
		if(!ismob(M))
			usr << "This can only be used on instances of type /mob"
			return

		var/delmob = 0
		switch(alert("Delete old mob?","Message","Yes","No","Cancel"))
			if("Cancel")	return
			if("Yes")		delmob = 1

		log_admin("[key_name(usr)] has used rudimentary transformation on [key_name(M)]. Transforming to [href_list["simplemake"]]; deletemob=[delmob]")
		message_admins("\blue [key_name_admin(usr)] has used rudimentary transformation on [key_name_admin(M)]. Transforming to [href_list["simplemake"]]; deletemob=[delmob]", 1)

		switch(href_list["simplemake"])
			if("observer")			M.change_mob_type( /mob/dead/ghost , null, null, delmob )
			if("larva")				M.change_mob_type( /mob/living/carbon/alien/larva , null, null, delmob )
			if("human")				M.change_mob_type( /mob/living/carbon/human , null, null, delmob )
			if("slime")			M.change_mob_type( /mob/living/carbon/slime , null, null, delmob )
			if("adultslime")		M.change_mob_type( /mob/living/carbon/slime/adult , null, null, delmob )
			if("monkey")			M.change_mob_type( /mob/living/carbon/monkey , null, null, delmob )
			if("robot")				M.change_mob_type( /mob/living/silicon/robot , null, null, delmob )
			if("cat")				M.change_mob_type( /mob/living/simple/cat , null, null, delmob )
			if("runtime")		M.change_mob_type( /mob/living/simple/cat/Runtime , null, null, delmob )
			if("corgi")				M.change_mob_type( /mob/living/simple/corgi , null, null, delmob )
			if("ian")				M.change_mob_type( /mob/living/simple/corgi/Ian , null, null, delmob )
			if("crab")				M.change_mob_type( /mob/living/simple/crab , null, null, delmob )
			if("coffee")			M.change_mob_type( /mob/living/simple/crab/Coffee , null, null, delmob )
			if("parrot")			M.change_mob_type( /mob/living/simple/parrot , null, null, delmob )
			if("polyparrot")		M.change_mob_type( /mob/living/simple/parrot/Poly , null, null, delmob )
			if("constructarmoured")	M.change_mob_type( /mob/living/simple/construct/armoured , null, null, delmob )
			if("constructbuilder")	M.change_mob_type( /mob/living/simple/construct/builder , null, null, delmob )
			if("constructwraith")	M.change_mob_type( /mob/living/simple/construct/wraith , null, null, delmob )
			if("shade")				M.change_mob_type( /mob/living/simple/shade , null, null, delmob )


	/////////////////////////////////////new ban stuff
	else if(href_list["unbanf"])
		if(!check_rights(R_BAN))	return

		var/banfolder = href_list["unbanf"]
		Banlist.cd = "/base/[banfolder]"
		var/key = Banlist["key"]
		if(alert(usr, "Are you sure you want to unban [key]?", "Confirmation", "Yes", "No") == "Yes")
			if(RemoveBan(banfolder))
				unbanpanel()
			else
				alert(usr, "This ban has already been lifted / does not exist.", "Error", "Ok")
				unbanpanel()

	else if(href_list["warn"])
		usr.client.warn(href_list["warn"])

	else if(href_list["unbane"])
		if(!check_rights(R_BAN))	return

		UpdateTime()
		var/reason

		var/banfolder = href_list["unbane"]
		Banlist.cd = "/base/[banfolder]"
		var/reason2 = Banlist["reason"]
		var/temp = Banlist["temp"]

		var/minutes = Banlist["minutes"]

		var/banned_key = Banlist["key"]
		Banlist.cd = "/base"

		var/duration

		switch(alert("Temporary Ban?", , "Yes", "No"))
			if("Yes")
				temp = 1
				var/mins = 0
				if(minutes > CMinutes)
					mins = minutes - CMinutes
				mins = input(usr, "How long (in minutes)? (Default: 1440)", "Ban time", mins ? mins : 1440) as num|null
				if(!mins)	return
				mins = min(525599,mins)
				minutes = CMinutes + mins
				duration = GetExp(minutes)
				reason = input(usr, "Reason?", "reason", reason2) as text|null
				if(!reason)	return
			if("No")
				temp = 0
				duration = "Perma"
				reason = input(usr, "Reason?", "reason", reason2) as text|null
				if(!reason)	return

		log_admin("[key_name(usr)] edited [banned_key]'s ban. Reason: [reason] Duration: [duration]")
		ban_unban_log_save("[key_name(usr)] edited [banned_key]'s ban. Reason: [reason] Duration: [duration]")
		message_admins("\blue [key_name_admin(usr)] edited [banned_key]'s ban. Reason: [reason] Duration: [duration]", 1)
		Banlist.cd = "/base/[banfolder]"
		Banlist["reason"] << reason
		Banlist["temp"] << temp
		Banlist["minutes"] << minutes
		Banlist["bannedby"] << usr.ckey
		Banlist.cd = "/base"
		feedback_inc("ban_edit",1)
		unbanpanel()

	/////////////////////////////////////new ban stuff

	else if(href_list["jobban2"])
//		if(!check_rights(R_BAN))	return
		var/mob/M = locate(href_list["jobban2"])
		if(!ismob(M))
			usr << "This can only be used on instances of type /mob"
			return

		if(!M.ckey)	//sanity
			usr << "This mob has no ckey"
			return
		if(!global.CTjobs)
			usr << "Job Master has not been setup!"
			return

		var/dat = ""
		var/header = "<head><title>Job-Ban Panel: [M.name]</title></head>"
		var/body
		var/jobs = ""

	/***********************************WARNING!************************************
				      The jobban stuff looks mangled and disgusting
						      But it looks beautiful in-game
						                -Nodrak
	************************************WARNING!***********************************/
		var/counter = 0
//Regular jobs
	//Command (Blue)
		jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
		jobs += "<tr align='center' bgcolor='ccccff'><th colspan='[length(GLOBL.command_positions)]'><a href='byond://?src=\ref[src];jobban3=commanddept;jobban4=\ref[M]'>Command Positions</a></th></tr><tr align='center'>"
		for(var/jobPos in GLOBL.command_positions)
			if(!jobPos)	continue
			var/datum/job/job = global.CTjobs.get_job(jobPos)
			if(!job) continue

			if(jobban_isbanned(M, job.title))
				jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
				counter++
			else
				jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
				counter++

			if(counter >= 6) //So things dont get squiiiiished!
				jobs += "</tr><tr>"
				counter = 0
		jobs += "</tr></table>"

	//Security (Red)
		counter = 0
		jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
		jobs += "<tr bgcolor='ffddf0'><th colspan='[length(GLOBL.security_positions)]'><a href='byond://?src=\ref[src];jobban3=securitydept;jobban4=\ref[M]'>Security Positions</a></th></tr><tr align='center'>"
		for(var/jobPos in GLOBL.security_positions)
			if(!jobPos)	continue
			var/datum/job/job = global.CTjobs.get_job(jobPos)
			if(!job) continue

			if(jobban_isbanned(M, job.title))
				jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
				counter++
			else
				jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
				counter++

			if(counter >= 5) //So things dont get squiiiiished!
				jobs += "</tr><tr align='center'>"
				counter = 0
		jobs += "</tr></table>"

	//Engineering (Yellow)
		counter = 0
		jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
		jobs += "<tr bgcolor='fff5cc'><th colspan='[length(GLOBL.engineering_positions)]'><a href='byond://?src=\ref[src];jobban3=engineeringdept;jobban4=\ref[M]'>Engineering Positions</a></th></tr><tr align='center'>"
		for(var/jobPos in GLOBL.engineering_positions)
			if(!jobPos)	continue
			var/datum/job/job = global.CTjobs.get_job(jobPos)
			if(!job) continue

			if(jobban_isbanned(M, job.title))
				jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
				counter++
			else
				jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
				counter++

			if(counter >= 5) //So things dont get squiiiiished!
				jobs += "</tr><tr align='center'>"
				counter = 0
		jobs += "</tr></table>"

	//Medical (White)
		counter = 0
		jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
		jobs += "<tr bgcolor='ffeef0'><th colspan='[length(GLOBL.medical_positions)]'><a href='byond://?src=\ref[src];jobban3=medicaldept;jobban4=\ref[M]'>Medical Positions</a></th></tr><tr align='center'>"
		for(var/jobPos in GLOBL.medical_positions)
			if(!jobPos)	continue
			var/datum/job/job = global.CTjobs.get_job(jobPos)
			if(!job) continue

			if(jobban_isbanned(M, job.title))
				jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
				counter++
			else
				jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
				counter++

			if(counter >= 5) //So things dont get squiiiiished!
				jobs += "</tr><tr align='center'>"
				counter = 0
		jobs += "</tr></table>"

	//Science (Purple)
		counter = 0
		jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
		jobs += "<tr bgcolor='e79fff'><th colspan='[length(GLOBL.science_positions)]'><a href='byond://?src=\ref[src];jobban3=sciencedept;jobban4=\ref[M]'>Science Positions</a></th></tr><tr align='center'>"
		for(var/jobPos in GLOBL.science_positions)
			if(!jobPos)	continue
			var/datum/job/job = global.CTjobs.get_job(jobPos)
			if(!job) continue

			if(jobban_isbanned(M, job.title))
				jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
				counter++
			else
				jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
				counter++

			if(counter >= 5) //So things dont get squiiiiished!
				jobs += "</tr><tr align='center'>"
				counter = 0
		jobs += "</tr></table>"

	//Cargo (Brown)
		counter = 0
		jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
		jobs += "<tr bgcolor='8c7846'><th colspan='[length(GLOBL.civilian_positions)]'><a href='byond://?src=\ref[src];jobban3=cargodept;jobban4=\ref[M]'>Cargo Positions</a></th></tr><tr align='center'>"
		for(var/jobPos in GLOBL.cargo_positions)
			if(!jobPos)	continue
			var/datum/job/job = global.CTjobs.get_job(jobPos)
			if(!job) continue

			if(jobban_isbanned(M, job.title))
				jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
				counter++
			else
				jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
				counter++

			if(counter >= 5) //So things dont get squiiiiished!
				jobs += "</tr><tr align='center'>"
				counter = 0

	//Civilian (Grey)
		counter = 0
		jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
		jobs += "<tr bgcolor='dddddd'><th colspan='[length(GLOBL.civilian_positions)]'><a href='byond://?src=\ref[src];jobban3=civiliandept;jobban4=\ref[M]'>Civilian Positions</a></th></tr><tr align='center'>"
		for(var/jobPos in GLOBL.civilian_positions)
			if(!jobPos)	continue
			var/datum/job/job = global.CTjobs.get_job(jobPos)
			if(!job) continue

			if(jobban_isbanned(M, job.title))
				jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
				counter++
			else
				jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
				counter++

			if(counter >= 5) //So things dont get squiiiiished!
				jobs += "</tr><tr align='center'>"
				counter = 0

		if(jobban_isbanned(M, "Internal Affairs Agent"))
			jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=Internal Affairs Agent;jobban4=\ref[M]'><font color=red>Internal Affairs Agent</font></a></td>"
		else
			jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=Internal Affairs Agent;jobban4=\ref[M]'>Internal Affairs Agent</a></td>"

		jobs += "</tr></table>"

	//Non-Human (Green)
		counter = 0
		jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
		jobs += "<tr bgcolor='ccffcc'><th colspan='[length(GLOBL.nonhuman_positions)+1]'><a href='byond://?src=\ref[src];jobban3=nonhumandept;jobban4=\ref[M]'>Non-human Positions</a></th></tr><tr align='center'>"
		for(var/jobPos in GLOBL.nonhuman_positions)
			if(!jobPos)	continue
			var/datum/job/job = global.CTjobs.get_job(jobPos)
			if(!job) continue

			if(jobban_isbanned(M, job.title))
				jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
				counter++
			else
				jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
				counter++

			if(counter >= 5) //So things dont get squiiiiished!
				jobs += "</tr><tr align='center'>"
				counter = 0

		//pAI isn't technically a job, but it goes in here.

		if(jobban_isbanned(M, "pAI"))
			jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=pAI;jobban4=\ref[M]'><font color=red>pAI</font></a></td>"
		else
			jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=pAI;jobban4=\ref[M]'>pAI</a></td>"
		if(jobban_isbanned(M, "AntagHUD"))
			jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=AntagHUD;jobban4=\ref[M]'><font color=red>AntagHUD</font></a></td>"
		else
			jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=AntagHUD;jobban4=\ref[M]'>AntagHUD</a></td>"
		jobs += "</tr></table>"

	//Antagonist (Orange)
		var/isbanned_dept = jobban_isbanned(M, "Syndicate")
		jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
		jobs += "<tr bgcolor='ffeeaa'><th colspan='10'><a href='byond://?src=\ref[src];jobban3=Syndicate;jobban4=\ref[M]'>Antagonist Positions</a></th></tr><tr align='center'>"

		//Traitor
		if(jobban_isbanned(M, "traitor") || isbanned_dept)
			jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=traitor;jobban4=\ref[M]'><font color=red>[replacetext("Traitor", " ", "&nbsp")]</font></a></td>"
		else
			jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=traitor;jobban4=\ref[M]'>[replacetext("Traitor", " ", "&nbsp")]</a></td>"

		//Changeling
		if(jobban_isbanned(M, "changeling") || isbanned_dept)
			jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=changeling;jobban4=\ref[M]'><font color=red>[replacetext("Changeling", " ", "&nbsp")]</font></a></td>"
		else
			jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=changeling;jobban4=\ref[M]'>[replacetext("Changeling", " ", "&nbsp")]</a></td>"

		//Nuke Operative
		if(jobban_isbanned(M, "operative") || isbanned_dept)
			jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=operative;jobban4=\ref[M]'><font color=red>[replacetext("Nuke Operative", " ", "&nbsp")]</font></a></td>"
		else
			jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=operative;jobban4=\ref[M]'>[replacetext("Nuke Operative", " ", "&nbsp")]</a></td>"

		//Revolutionary
		if(jobban_isbanned(M, "revolutionary") || isbanned_dept)
			jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=revolutionary;jobban4=\ref[M]'><font color=red>[replacetext("Revolutionary", " ", "&nbsp")]</font></a></td>"
		else
			jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=revolutionary;jobban4=\ref[M]'>[replacetext("Revolutionary", " ", "&nbsp")]</a></td>"

		jobs += "</tr><tr align='center'>" //Breaking it up so it fits nicer on the screen every 5 entries

		//Cultist
		if(jobban_isbanned(M, "cultist") || isbanned_dept)
			jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=cultist;jobban4=\ref[M]'><font color=red>[replacetext("Cultist", " ", "&nbsp")]</font></a></td>"
		else
			jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=cultist;jobban4=\ref[M]'>[replacetext("Cultist", " ", "&nbsp")]</a></td>"

		//Wizard
		if(jobban_isbanned(M, "wizard") || isbanned_dept)
			jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=wizard;jobban4=\ref[M]'><font color=red>[replacetext("Wizard", " ", "&nbsp")]</font></a></td>"
		else
			jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=wizard;jobban4=\ref[M]'>[replacetext("Wizard", " ", "&nbsp")]</a></td>"

		//ERT
		if(jobban_isbanned(M, "Emergency Response Team") || isbanned_dept)
			jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=Emergency Response Team;jobban4=\ref[M]'><font color=red>Emergency Response Team</font></a></td>"
		else
			jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=Emergency Response Team;jobban4=\ref[M]'>Emergency Response Team</a></td>"


/*		//Malfunctioning AI	//Removed Malf-bans because they're a pain to impliment
		if(jobban_isbanned(M, "malf AI") || isbanned_dept)
			jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=malf AI;jobban4=\ref[M]'><font color=red>[replacetextx("Malf AI", " ", "&nbsp")]</font></a></td>"
		else
			jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=malf AI;jobban4=\ref[M]'>[replacetextx("Malf AI", " ", "&nbsp")]</a></td>"

		//Alien
		if(jobban_isbanned(M, "alien candidate") || isbanned_dept)
			jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=alien candidate;jobban4=\ref[M]'><font color=red>[replacetextx("Alien", " ", "&nbsp")]</font></a></td>"
		else
			jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=alien candidate;jobban4=\ref[M]'>[replacetextx("Alien", " ", "&nbsp")]</a></td>"

		//Infested Monkey
		if(jobban_isbanned(M, "infested monkey") || isbanned_dept)
			jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=infested monkey;jobban4=\ref[M]'><font color=red>[replacetextx("Infested Monkey", " ", "&nbsp")]</font></a></td>"
		else
			jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=infested monkey;jobban4=\ref[M]'>[replacetextx("Infested Monkey", " ", "&nbsp")]</a></td>"
*/

		jobs += "</tr></table>"

		//Other races  (BLUE, because I have no idea what other color to make this)
		jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
		jobs += "<tr bgcolor='ccccff'><th colspan='1'>Other Races</th></tr><tr align='center'>"

		if(jobban_isbanned(M, "Dionaea"))
			jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=Dionaea;jobban4=\ref[M]'><font color=red>Dionaea</font></a></td>"
		else
			jobs += "<td width='20%'><a href='byond://?src=\ref[src];jobban3=Dionaea;jobban4=\ref[M]'>Dionaea</a></td>"

		jobs += "</tr></table>"


		body = "<body>[jobs]</body>"
		dat = "<tt>[header][body]</tt>"
		usr << browse(dat, "window=jobban2;size=800x490")
		return

	//JOBBAN'S INNARDS
	else if(href_list["jobban3"])
		if(!check_rights(R_MOD, 0) && !check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["jobban4"])
		if(!ismob(M))
			usr << "This can only be used on instances of type /mob"
			return

		if(M != usr)																//we can jobban ourselves
			if(M.client && M.client.holder && (M.client.holder.rights & R_BAN))		//they can ban too. So we can't ban them
				alert("You cannot perform this action. You must be of a higher administrative rank!")
				return

		if(!global.CTjobs)
			usr << "Job Master has not been setup!"
			return

		//get jobs for department if specified, otherwise just returnt he one job in a list.
		var/list/joblist = list()
		switch(href_list["jobban3"])
			if("commanddept")
				for(var/jobPos in GLOBL.command_positions)
					if(!jobPos)	continue
					var/datum/job/temp = global.CTjobs.get_job(jobPos)
					if(!temp) continue
					joblist += temp.title
			if("securitydept")
				for(var/jobPos in GLOBL.security_positions)
					if(!jobPos)	continue
					var/datum/job/temp = global.CTjobs.get_job(jobPos)
					if(!temp) continue
					joblist += temp.title
			if("engineeringdept")
				for(var/jobPos in GLOBL.engineering_positions)
					if(!jobPos)	continue
					var/datum/job/temp = global.CTjobs.get_job(jobPos)
					if(!temp) continue
					joblist += temp.title
			if("medicaldept")
				for(var/jobPos in GLOBL.medical_positions)
					if(!jobPos)	continue
					var/datum/job/temp = global.CTjobs.get_job(jobPos)
					if(!temp) continue
					joblist += temp.title
			if("sciencedept")
				for(var/jobPos in GLOBL.science_positions)
					if(!jobPos)	continue
					var/datum/job/temp = global.CTjobs.get_job(jobPos)
					if(!temp) continue
					joblist += temp.title
			if("cargodept")
				for(var/jobPos in GLOBL.cargo_positions)
					if(!jobPos) continue
					var/datum/job/temp = global.CTjobs.get_job(jobPos)
					if(!temp) continue
					joblist += temp.title
			if("civiliandept")
				for(var/jobPos in GLOBL.civilian_positions)
					if(!jobPos)	continue
					var/datum/job/temp = global.CTjobs.get_job(jobPos)
					if(!temp) continue
					joblist += temp.title
			if("nonhumandept")
				joblist += "pAI"
				for(var/jobPos in GLOBL.nonhuman_positions)
					if(!jobPos)	continue
					var/datum/job/temp = global.CTjobs.get_job(jobPos)
					if(!temp) continue
					joblist += temp.title
			else
				joblist += href_list["jobban3"]

		//Create a list of unbanned jobs within joblist
		var/list/notbannedlist = list()
		for(var/job in joblist)
			if(!jobban_isbanned(M, job))
				notbannedlist += job

		//Banning comes first
		if(length(notbannedlist)) //at least 1 unbanned job exists in joblist so we have stuff to ban.
			switch(alert("Temporary Ban?",,"Yes","No", "Cancel"))
				if("Yes")
					if(!check_rights(R_MOD,0) && !check_rights(R_BAN))  return
					if(CONFIG_GET(/decl/configuration_entry/ban_legacy_system))
						usr << "\red Your server is using the legacy banning system, which does not support temporary job bans. Consider upgrading. Aborting ban."
						return
					var/mins = input(usr,"How long (in minutes)?","Ban time",1440) as num|null
					if(!mins)
						return
					var/reason = input(usr,"Reason?","Please State Reason","") as text|null
					if(!reason)
						return

					var/msg
					for(var/job in notbannedlist)
						ban_unban_log_save("[key_name(usr)] temp-jobbanned [key_name(M)] from [job] for [mins] minutes. reason: [reason]")
						log_admin("[key_name(usr)] temp-jobbanned [key_name(M)] from [job] for [mins] minutes")
						feedback_inc("ban_job_tmp",1)
						DB_ban_record(BANTYPE_JOB_TEMP, M, mins, reason, job)
						feedback_add_details("ban_job_tmp","- [job]")
						jobban_fullban(M, job, "[reason]; By [usr.ckey] on [time2text(world.realtime)]") //Legacy banning does not support temporary jobbans.
						if(!msg)
							msg = job
						else
							msg += ", [job]"
					notes_add(M.ckey, "Banned  from [msg] - [reason]")
					message_admins("\blue [key_name_admin(usr)] banned [key_name_admin(M)] from [msg] for [mins] minutes", 1)
					M << "\red<BIG><B>You have been jobbanned by [usr.client.ckey] from: [msg].</B></BIG>"
					M << "\red <B>The reason is: [reason]</B>"
					M << "\red This jobban will be lifted in [mins] minutes."
					href_list["jobban2"] = 1 // lets it fall through and refresh
					return 1
				if("No")
					if(!check_rights(R_BAN))  return
					var/reason = input(usr,"Reason?","Please State Reason","") as text|null
					if(reason)
						var/msg
						for(var/job in notbannedlist)
							ban_unban_log_save("[key_name(usr)] perma-jobbanned [key_name(M)] from [job]. reason: [reason]")
							log_admin("[key_name(usr)] perma-banned [key_name(M)] from [job]")
							feedback_inc("ban_job",1)
							DB_ban_record(BANTYPE_JOB_PERMA, M, -1, reason, job)
							feedback_add_details("ban_job","- [job]")
							jobban_fullban(M, job, "[reason]; By [usr.ckey] on [time2text(world.realtime)]")
							if(!msg)	msg = job
							else		msg += ", [job]"
						notes_add(M.ckey, "Banned  from [msg] - [reason]")
						message_admins("\blue [key_name_admin(usr)] banned [key_name_admin(M)] from [msg]", 1)
						M << "\red<BIG><B>You have been jobbanned by [usr.client.ckey] from: [msg].</B></BIG>"
						M << "\red <B>The reason is: [reason]</B>"
						M << "\red Jobban can be lifted only upon request."
						href_list["jobban2"] = 1 // lets it fall through and refresh
						return 1
				if("Cancel")
					return

		//Unbanning joblist
		//all jobs in joblist are banned already OR we didn't give a reason (implying they shouldn't be banned)
		if(length(joblist)) //at least 1 banned job exists in joblist so we have stuff to unban.
			if(!CONFIG_GET(/decl/configuration_entry/ban_legacy_system))
				usr << "Unfortunately, database based unbanning cannot be done through this panel"
				DB_ban_panel(M.ckey)
				return
			var/msg
			for(var/job in joblist)
				var/reason = jobban_isbanned(M, job)
				if(!reason) continue //skip if it isn't jobbanned anyway
				switch(alert("Job: '[job]' Reason: '[reason]' Un-jobban?","Please Confirm","Yes","No"))
					if("Yes")
						ban_unban_log_save("[key_name(usr)] unjobbanned [key_name(M)] from [job]")
						log_admin("[key_name(usr)] unbanned [key_name(M)] from [job]")
						DB_ban_unban(M.ckey, BANTYPE_JOB_PERMA, job)
						feedback_inc("ban_job_unban",1)
						feedback_add_details("ban_job_unban","- [job]")
						jobban_unban(M, job)
						if(!msg)	msg = job
						else		msg += ", [job]"
					else
						continue
			if(msg)
				message_admins("\blue [key_name_admin(usr)] unbanned [key_name_admin(M)] from [msg]", 1)
				M << "\red<BIG><B>You have been un-jobbanned by [usr.client.ckey] from [msg].</B></BIG>"
				href_list["jobban2"] = 1 // lets it fall through and refresh
			return 1
		return 0 //we didn't do anything!

	else if(href_list["boot2"])
		var/mob/M = locate(href_list["boot2"])
		if (ismob(M))
			if(!check_if_greater_rights_than(M.client))
				return
			var/reason = input("Please enter reason")
			if(!reason)
				M << "\red You have been kicked from the server"
			else
				M << "\red You have been kicked from the server: [reason]"
			log_admin("[key_name(usr)] booted [key_name(M)].")
			message_admins("\blue [key_name_admin(usr)] booted [key_name_admin(M)].", 1)
			//M.client = null
			qdel(M.client)
/*
	//Player Notes
	else if(href_list["notes"])
		var/ckey = href_list["ckey"]
		if(!ckey)
			var/mob/M = locate(href_list["mob"])
			if(ismob(M))
				ckey = M.ckey

		switch(href_list["notes"])
			if("show")
				notes_show(ckey)
			if("add")
				notes_add(ckey,href_list["text"])
				notes_show(ckey)
			if("remove")
				notes_remove(ckey,text2num(href_list["from"]),text2num(href_list["to"]))
				notes_show(ckey)
*/
	else if(href_list["removejobban"])
		if(!check_rights(R_BAN))	return

		var/t = href_list["removejobban"]
		if(t)
			if((alert("Do you want to unjobban [t]?","Unjobban confirmation", "Yes", "No") == "Yes") && t) //No more misclicks! Unless you do it twice.
				log_admin("[key_name(usr)] removed [t]")
				message_admins("\blue [key_name_admin(usr)] removed [t]", 1)
				jobban_remove(t)
				href_list["ban"] = 1 // lets it fall through and refresh
				var/t_split = splittext(t, " - ")
				var/key = t_split[1]
				var/job = t_split[2]
				DB_ban_unban(ckey(key), BANTYPE_JOB_PERMA, job)

	else if(href_list["newban"])
		if(!check_rights(R_MOD,0) && !check_rights(R_BAN))  return

		var/mob/M = locate(href_list["newban"])
		if(!ismob(M)) return

		if(M.client && M.client.holder)	return	//admins cannot be banned. Even if they could, the ban doesn't affect them anyway

		switch(alert("Temporary Ban?",,"Yes","No", "Cancel"))
			if("Yes")
				var/mins = input(usr,"How long (in minutes)?","Ban time",1440) as num|null
				if(!mins)
					return
				if(mins >= 525600) mins = 525599
				var/reason = input(usr,"Reason?","reason","Griefer") as text|null
				if(!reason)
					return
				AddBan(M.ckey, M.computer_id, reason, usr.ckey, 1, mins)
				ban_unban_log_save("[usr.client.ckey] has banned [M.ckey]. - Reason: [reason] - This will be removed in [mins] minutes.")
				M << "\red<BIG><B>You have been banned by [usr.client.ckey].\nReason: [reason].</B></BIG>"
				M << "\red This is a temporary ban, it will be removed in [mins] minutes."
				feedback_inc("ban_tmp",1)
				DB_ban_record(BANTYPE_TEMP, M, mins, reason)
				feedback_inc("ban_tmp_mins",mins)
				if(isnotnull(CONFIG_GET(/decl/configuration_entry/banappeals)))
					M << "\red To try to resolve this matter head to [CONFIG_GET(/decl/configuration_entry/banappeals)]"
				else
					M << "\red No ban appeals URL has been set."
				log_admin("[usr.client.ckey] has banned [M.ckey].\nReason: [reason]\nThis will be removed in [mins] minutes.")
				message_admins("\blue[usr.client.ckey] has banned [M.ckey].\nReason: [reason]\nThis will be removed in [mins] minutes.")

				qdel(M.client)
				//del(M)	// See no reason why to delete mob. Important stuff can be lost. And ban can be lifted before round ends.
			if("No")
				if(!check_rights(R_BAN))   return
				var/reason = input(usr,"Reason?","reason","Griefer") as text|null
				if(!reason)
					return
				switch(alert(usr,"IP ban?",,"Yes","No","Cancel"))
					if("Cancel")	return
					if("Yes")
						AddBan(M.ckey, M.computer_id, reason, usr.ckey, 0, 0, M.lastKnownIP)
					if("No")
						AddBan(M.ckey, M.computer_id, reason, usr.ckey, 0, 0)
				M << "\red<BIG><B>You have been banned by [usr.client.ckey].\nReason: [reason].</B></BIG>"
				M << "\red This is a permanent ban."
				if(isnotnull(CONFIG_GET(/decl/configuration_entry/banappeals)))
					M << "\red To try to resolve this matter head to [CONFIG_GET(/decl/configuration_entry/banappeals)]"
				else
					M << "\red No ban appeals URL has been set."
				ban_unban_log_save("[usr.client.ckey] has permabanned [M.ckey]. - Reason: [reason] - This is a permanent ban.")
				log_admin("[usr.client.ckey] has banned [M.ckey].\nReason: [reason]\nThis is a permanent ban.")
				message_admins("\blue[usr.client.ckey] has banned [M.ckey].\nReason: [reason]\nThis is a permanent ban.")
				feedback_inc("ban_perma",1)
				DB_ban_record(BANTYPE_PERMA, M, -1, reason)

				qdel(M.client)
				//del(M)
			if("Cancel")
				return

	else if(href_list["unjobbanf"])
		if(!check_rights(R_BAN))	return

		var/banfolder = href_list["unjobbanf"]
		Banlist.cd = "/base/[banfolder]"
		var/key = Banlist["key"]
		if(alert(usr, "Are you sure you want to unban [key]?", "Confirmation", "Yes", "No") == "Yes")
			if (RemoveBanjob(banfolder))
				unjobbanpanel()
			else
				alert(usr,"This ban has already been lifted / does not exist.","Error","Ok")
				unjobbanpanel()

	else if(href_list["mute"])
		if(!check_rights(R_MOD,0) && !check_rights(R_ADMIN))  return

		var/mob/M = locate(href_list["mute"])
		if(!ismob(M))	return
		if(!M.client)	return

		var/mute_type = href_list["mute_type"]
		if(istext(mute_type))	mute_type = text2num(mute_type)
		if(!isnum(mute_type))	return

		cmd_admin_mute(M, mute_type)

	else if(href_list["c_mode"])
		if(!check_rights(R_ADMIN))	return

		if(global.PCticker?.mode)
			return alert(usr, "The game has already started.", null, null, null, null)
		var/dat = {"<B>What mode do you wish to play?</B><HR>"}
		for(var/mode in global.CTconfiguration.modes)
			dat += {"<A href='byond://?src=\ref[src];c_mode2=[mode]'>[global.CTconfiguration.mode_names[mode]]</A><br>"}
		dat += {"<A href='byond://?src=\ref[src];c_mode2=secret'>Secret</A><br>"}
		dat += {"<A href='byond://?src=\ref[src];c_mode2=random'>Random</A><br>"}
		dat += {"Now: [global.PCticker.master_mode]"}
		usr << browse(dat, "window=c_mode")

	else if(href_list["f_secret"])
		if(!check_rights(R_ADMIN))	return

		if(global.PCticker?.mode)
			return alert(usr, "The game has already started.", null, null, null, null)
		if(global.PCticker.master_mode != "secret")
			return alert(usr, "The game mode has to be secret!", null, null, null, null)
		var/dat = {"<B>What game mode do you want to force secret to be? Use this if you want to change the game mode, but want the players to believe it's secret. This will only work if the current game mode is secret.</B><HR>"}
		for(var/mode in global.CTconfiguration.modes)
			dat += {"<A href='byond://?src=\ref[src];f_secret2=[mode]'>[global.CTconfiguration.mode_names[mode]]</A><br>"}
		dat += {"<A href='byond://?src=\ref[src];f_secret2=secret'>Random (default)</A><br>"}
		dat += {"Now: [global.PCticker.secret_force_mode]"}
		usr << browse(dat, "window=f_secret")

	else if(href_list["c_mode2"])
		if(!check_rights(R_ADMIN|R_SERVER))	return

		if(global.PCticker?.mode)
			return alert(usr, "The game has already started.", null, null, null, null)
		global.PCticker.master_mode = href_list["c_mode2"]
		log_admin("[key_name(usr)] set the mode as [global.PCticker.master_mode].")
		message_admins("\blue [key_name_admin(usr)] set the mode as [global.PCticker.master_mode].", 1)
		to_world("\blue <b>The mode is now: [global.PCticker.master_mode]</b>")
		Game() // updates the main game menu
		world.save_mode(global.PCticker.master_mode)
		.(href, list("c_mode"=1))

	else if(href_list["f_secret2"])
		if(!check_rights(R_ADMIN|R_SERVER))	return

		if(global.PCticker?.mode)
			return alert(usr, "The game has already started.", null, null, null, null)
		if(global.PCticker.master_mode != "secret")
			return alert(usr, "The game mode has to be secret!", null, null, null, null)
		global.PCticker.secret_force_mode = href_list["f_secret2"]
		log_admin("[key_name(usr)] set the forced secret mode as [global.PCticker.secret_force_mode].")
		message_admins("\blue [key_name_admin(usr)] set the forced secret mode as [global.PCticker.secret_force_mode].", 1)
		Game() // updates the main game menu
		.(href, list("f_secret"=1))

	else if(href_list["monkeyone"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["monkeyone"])
		if(!istype(H))
			usr << "This can only be used on instances of type /mob/living/carbon/human"
			return

		log_admin("[key_name(usr)] attempting to monkeyize [key_name(H)]")
		message_admins("\blue [key_name_admin(usr)] attempting to monkeyize [key_name_admin(H)]", 1)
		H.monkeyize()

	else if(href_list["corgione"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["corgione"])
		if(!istype(H))
			usr << "This can only be used on instances of type /mob/living/carbon/human"
			return

		log_admin("[key_name(usr)] attempting to corgize [key_name(H)]")
		message_admins("\blue [key_name_admin(usr)] attempting to corgize [key_name_admin(H)]", 1)
		H.corgize()

	else if(href_list["forcespeech"])
		if(!check_rights(R_FUN))	return

		var/mob/M = locate(href_list["forcespeech"])
		if(!ismob(M))
			usr << "this can only be used on instances of type /mob"

		var/speech = input("What will [key_name(M)] say?.", "Force speech", "")// Don't need to sanitize, since it does that in say(), we also trust our admins.
		if(!speech)	return
		M.say(speech)
		speech = sanitize(speech) // Nah, we don't trust them
		log_admin("[key_name(usr)] forced [key_name(M)] to say: [speech]")
		message_admins("\blue [key_name_admin(usr)] forced [key_name_admin(M)] to say: [speech]")

	else if(href_list["sendtoprison"])
		if(!check_rights(R_ADMIN))	return

		if(alert(usr, "Send to admin prison for the round?", "Message", "Yes", "No") != "Yes")
			return

		var/mob/M = locate(href_list["sendtoprison"])
		if(!ismob(M))
			usr << "This can only be used on instances of type /mob"
			return
		if(isAI(M))
			usr << "This cannot be used on instances of type /mob/living/silicon/ai"
			return

		var/turf/prison_cell = pick(GLOBL.prisonwarp)
		if(!prison_cell)	return

		var/obj/structure/closet/secure/brig/locker = new /obj/structure/closet/secure/brig(prison_cell)
		locker.opened = 0
		locker.locked = 1

		//strip their stuff and stick it in the crate
		for(var/obj/item/I in M)
			M.u_equip(I)
			if(I)
				I.loc = locker
				I.reset_plane_and_layer()
				I.dropped(M)
		M.update_icons()

		//so they black out before warping
		M.Paralyse(5)
		sleep(5)
		if(!M)	return

		M.loc = prison_cell
		if(ishuman(M))
			var/mob/living/carbon/human/prisoner = M
			prisoner.equip_to_slot_or_del(new /obj/item/clothing/under/color/orange(prisoner), SLOT_ID_WEAR_UNIFORM)
			prisoner.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(prisoner), SLOT_ID_SHOES)

		M << "\red You have been sent to the prison station!"
		log_admin("[key_name(usr)] sent [key_name(M)] to the prison station.")
		message_admins("\blue [key_name_admin(usr)] sent [key_name_admin(M)] to the prison station.", 1)

	else if(href_list["tdome1"])
		if(!check_rights(R_FUN))	return

		if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")
			return

		var/mob/M = locate(href_list["tdome1"])
		if(!ismob(M))
			usr << "This can only be used on instances of type /mob"
			return
		if(isAI(M))
			usr << "This cannot be used on instances of type /mob/living/silicon/ai"
			return

		for(var/obj/item/I in M)
			M.u_equip(I)
			if(I)
				I.loc = M.loc
				I.reset_plane_and_layer()
				I.dropped(M)

		M.Paralyse(5)
		sleep(5)
		M.loc = pick(GLOBL.tdome1)
		spawn(50)
			M << "\blue You have been sent to the Thunderdome."
		log_admin("[key_name(usr)] has sent [key_name(M)] to the thunderdome. (Team 1)")
		message_admins("[key_name_admin(usr)] has sent [key_name_admin(M)] to the thunderdome. (Team 1)", 1)

	else if(href_list["tdome2"])
		if(!check_rights(R_FUN))	return

		if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")
			return

		var/mob/M = locate(href_list["tdome2"])
		if(!ismob(M))
			usr << "This can only be used on instances of type /mob"
			return
		if(isAI(M))
			usr << "This cannot be used on instances of type /mob/living/silicon/ai"
			return

		for(var/obj/item/I in M)
			M.u_equip(I)
			if(I)
				I.loc = M.loc
				I.reset_plane_and_layer()
				I.dropped(M)

		M.Paralyse(5)
		sleep(5)
		M.loc = pick(GLOBL.tdome2)
		spawn(50)
			M << "\blue You have been sent to the Thunderdome."
		log_admin("[key_name(usr)] has sent [key_name(M)] to the thunderdome. (Team 2)")
		message_admins("[key_name_admin(usr)] has sent [key_name_admin(M)] to the thunderdome. (Team 2)", 1)

	else if(href_list["tdomeadmin"])
		if(!check_rights(R_FUN))	return

		if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")
			return

		var/mob/M = locate(href_list["tdomeadmin"])
		if(!ismob(M))
			usr << "This can only be used on instances of type /mob"
			return
		if(isAI(M))
			usr << "This cannot be used on instances of type /mob/living/silicon/ai"
			return

		M.Paralyse(5)
		sleep(5)
		M.loc = pick(GLOBL.tdomeadmin)
		spawn(50)
			M << "\blue You have been sent to the Thunderdome."
		log_admin("[key_name(usr)] has sent [key_name(M)] to the thunderdome. (Admin.)")
		message_admins("[key_name_admin(usr)] has sent [key_name_admin(M)] to the thunderdome. (Admin.)", 1)

	else if(href_list["tdomeobserve"])
		if(!check_rights(R_FUN))	return

		if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")
			return

		var/mob/M = locate(href_list["tdomeobserve"])
		if(!ismob(M))
			usr << "This can only be used on instances of type /mob"
			return
		if(isAI(M))
			usr << "This cannot be used on instances of type /mob/living/silicon/ai"
			return

		for(var/obj/item/I in M)
			M.u_equip(I)
			if(I)
				I.loc = M.loc
				I.reset_plane_and_layer()
				I.dropped(M)

		if(ishuman(M))
			var/mob/living/carbon/human/observer = M
			observer.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket(observer), SLOT_ID_WEAR_UNIFORM)
			observer.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(observer), SLOT_ID_SHOES)
		M.Paralyse(5)
		sleep(5)
		M.loc = pick(GLOBL.tdomeobserve)
		spawn(50)
			M << "\blue You have been sent to the Thunderdome."
		log_admin("[key_name(usr)] has sent [key_name(M)] to the thunderdome. (Observer.)")
		message_admins("[key_name_admin(usr)] has sent [key_name_admin(M)] to the thunderdome. (Observer.)", 1)

	else if(href_list["revive"])
		if(!check_rights(R_REJUVINATE))	return

		var/mob/living/L = locate(href_list["revive"])
		if(!istype(L))
			usr << "This can only be used on instances of type /mob/living"
			return

		if(CONFIG_GET(/decl/configuration_entry/allow_admin_rev))
			L.revive()
			message_admins("\red Admin [key_name_admin(usr)] healed / revived [key_name_admin(L)]!", 1)
			log_admin("[key_name(usr)] healed / Rrvived [key_name(L)]")
		else
			usr << "Admin Rejuvinates have been disabled"

	else if(href_list["makeai"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["makeai"])
		if(!istype(H))
			usr << "This can only be used on instances of type /mob/living/carbon/human"
			return

		message_admins("\red Admin [key_name_admin(usr)] AIized [key_name_admin(H)]!", 1)
		log_admin("[key_name(usr)] AIized [key_name(H)]")
		H.AIize()

	else if(href_list["makealien"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["makealien"])
		if(!istype(H))
			usr << "This can only be used on instances of type /mob/living/carbon/human"
			return

		usr.client.cmd_admin_alienize(H)

	else if(href_list["makeslime"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["makeslime"])
		if(!istype(H))
			usr << "This can only be used on instances of type /mob/living/carbon/human"
			return

		usr.client.cmd_admin_slimeize(H)

	else if(href_list["makerobot"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["makerobot"])
		if(!istype(H))
			usr << "This can only be used on instances of type /mob/living/carbon/human"
			return

		usr.client.cmd_admin_robotize(H)

	else if(href_list["makeanimal"])
		if(!check_rights(R_SPAWN))	return

		var/mob/M = locate(href_list["makeanimal"])
		if(isnewplayer(M))
			usr << "This cannot be used on instances of type /mob/dead/new_player"
			return

		usr.client.cmd_admin_animalize(M)

	else if(href_list["togmutate"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["togmutate"])
		if(!istype(H))
			usr << "This can only be used on instances of type /mob/living/carbon/human"
			return
		var/block=text2num(href_list["block"])
		//testing("togmutate([href_list["block"]] -> [block])")
		usr.client.cmd_admin_toggle_block(H,block)
		show_player_panel(H)
		//H.regenerate_icons()

/***************** BEFORE**************

	if (href_list["l_players"])
		var/dat = "<B>Name/Real Name/Key/IP:</B><HR>"
		for_no_type_check(var/mob/M, GLOBL.mob_list)
			var/foo = ""
			if (ismob(M) && M.client)
				if(!M.client.authenticated && !M.client.authenticating)
					foo += text("\[ <A href='byond://?src=\ref[];adminauth=\ref[]'>Authorize</A> | ", src, M)
				else
					foo += text("\[ <B>Authorized</B> | ")
				if(M.start)
					if(!ismonkey(M))
						foo += text("<A href='byond://?src=\ref[];monkeyone=\ref[]'>Monkeyize</A> | ", src, M)
					else
						foo += text("<B>Monkeyized</B> | ")
					if(isAI(M))
						foo += text("<B>Is an AI</B> | ")
					else
						foo += text("<A href='byond://?src=\ref[];makeai=\ref[]'>Make AI</A> | ", src, M)
					if(M.z != 2)
						foo += text("<A href='byond://?src=\ref[];sendtoprison=\ref[]'>Prison</A> | ", src, M)
						foo += text("<A href='byond://?src=\ref[];sendtomaze=\ref[]'>Maze</A> | ", src, M)
					else
						foo += text("<B>On Z = 2</B> | ")
				else
					foo += text("<B>Hasn't Entered Game</B> | ")
				foo += text("<A href='byond://?src=\ref[];revive=\ref[]'>Heal/Revive</A> | ", src, M)

				foo += text("<A href='byond://?src=\ref[];forcespeech=\ref[]'>Say</A> \]", src, M)
			dat += text("N: [] R: [] (K: []) (IP: []) []<BR>", M.name, M.real_name, (M.client ? M.client : "No client"), M.lastKnownIP, foo)

		usr << browse(dat, "window=players;size=900x480")

*****************AFTER******************/

// Now isn't that much better? IT IS NOW A PROC, i.e. kinda like a big panel like unstable

	else if(href_list["adminplayeropts"])
		var/mob/M = locate(href_list["adminplayeropts"])
		show_player_panel(M)

	else if(href_list["adminplayerobservejump"])
		if(!check_rights(R_MOD,0) && !check_rights(R_ADMIN))	return

		var/mob/M = locate(href_list["adminplayerobservejump"])

		var/client/C = usr.client
		if(!isghost(usr))	C.admin_ghost()
		sleep(2)
		C.jumptomob(M)

	else if(href_list["check_antagonist"])
		check_antagonists()

	else if(href_list["adminplayerobservecoodjump"])
		if(!check_rights(R_ADMIN))	return

		var/x = text2num(href_list["X"])
		var/y = text2num(href_list["Y"])
		var/z = text2num(href_list["Z"])

		var/client/C = usr.client
		if(!isghost(usr))	C.admin_ghost()
		sleep(2)
		C.jumptocoord(x,y,z)

	else if(href_list["adminchecklaws"])
		output_ai_laws()

	else if(href_list["adminmoreinfo"])
		var/mob/M = locate(href_list["adminmoreinfo"])
		if(!ismob(M))
			usr << "This can only be used on instances of type /mob"
			return

		var/location_description = ""
		var/special_role_description = ""
		var/health_description = ""
		var/gender_description = ""
		var/turf/T = GET_TURF(M)

		//Location
		if(isturf(T))
			if(isarea(T.loc))
				location_description = "([M.loc == T ? "at coordinates " : "in [M.loc] at coordinates "] [T.x], [T.y], [T.z] in area <b>[T.loc]</b>)"
			else
				location_description = "([M.loc == T ? "at coordinates " : "in [M.loc] at coordinates "] [T.x], [T.y], [T.z])"

		//Job + antagonist
		if(M.mind)
			special_role_description = "Role: <b>[M.mind.assigned_role]</b>; Antagonist: <font color='red'><b>[M.mind.special_role]</b></font>; Has been rev: [(M.mind.has_been_rev)?"Yes":"No"]"
		else
			special_role_description = "Role: <i>Mind datum missing</i> Antagonist: <i>Mind datum missing</i>; Has been rev: <i>Mind datum missing</i>;"

		//Health
		if(isliving(M))
			var/mob/living/L = M
			var/status
			switch (M.stat)
				if (0) status = "Alive"
				if (1) status = "<font color='orange'><b>Unconscious</b></font>"
				if (2) status = "<font color='red'><b>Dead</b></font>"
			health_description = "Status = [status]"
			health_description += "<BR>Oxy: [L.getOxyLoss()] - Tox: [L.getToxLoss()] - Fire: [L.getFireLoss()] - Brute: [L.getBruteLoss()] - Clone: [L.getCloneLoss()] - Brain: [L.getBrainLoss()]"
		else
			health_description = "This mob type has no health to speak of."

		//Gener
		switch(M.gender)
			if(MALE,FEMALE)	gender_description = "[M.gender]"
			else			gender_description = "<font color='red'><b>[M.gender]</b></font>"

		src.owner << "<b>Info about [M.name]:</b> "
		src.owner << "Mob type = [M.type]; Gender = [gender_description] Damage = [health_description]"
		src.owner << "Name = <b>[M.name]</b>; Real_name = [M.real_name]; Mind_name = [M.mind?"[M.mind.name]":""]; Key = <b>[M.key]</b>;"
		src.owner << "Location = [location_description];"
		src.owner << "[special_role_description]"
		src.owner << "(<a href='byond://?src=\ref[usr];priv_msg=\ref[M]'>PM</a>) (<A href='byond://?src=\ref[src];adminplayeropts=\ref[M]'>PP</A>) (<A href='byond://?_src_=vars;Vars=\ref[M]'>VV</A>) (<A href='byond://?src=\ref[src];subtlemessage=\ref[M]'>SM</A>) (<A href='byond://?src=\ref[src];adminplayerobservejump=\ref[M]'>JMP</A>) (<A href='byond://?src=\ref[src];secretsadmin=check_antagonist'>CA</A>)"

	else if(href_list["adminspawncookie"])
		if(!check_rights(R_ADMIN|R_FUN))
			return

		var/mob/living/carbon/human/H = locate(href_list["adminspawncookie"])
		if(!ishuman(H))
			usr << "This can only be used on instances of type /mob/living/carbon/human"
			return

		H.equip_to_slot_or_del(new /obj/item/reagent_holder/food/snacks/cookie(H), SLOT_ID_L_HAND)
		if(!(istype(H.l_hand, /obj/item/reagent_holder/food/snacks/cookie)))
			H.equip_to_slot_or_del(new /obj/item/reagent_holder/food/snacks/cookie(H), SLOT_ID_R_HAND)
			if(!(istype(H.r_hand, /obj/item/reagent_holder/food/snacks/cookie)))
				log_admin("[key_name(H)] has their hands full, so they did not receive their cookie, spawned by [key_name(src.owner)].")
				message_admins("[key_name(H)] has their hands full, so they did not receive their cookie, spawned by [key_name(src.owner)].")
				return
			else
				H.update_inv_r_hand()//To ensure the icon appears in the HUD
		else
			H.update_inv_l_hand()
		log_admin("[key_name(H)] got their cookie, spawned by [key_name(src.owner)]")
		message_admins("[key_name(H)] got their cookie, spawned by [key_name(src.owner)]")
		feedback_inc("admin_cookies_spawned",1)
		H << "\blue Your prayers have been answered!! You received the <b>best cookie</b>!"

	else if(href_list["BlueSpaceArtillery"])
		if(!check_rights(R_ADMIN|R_FUN))
			return

		var/mob/living/M = locate(href_list["BlueSpaceArtillery"])
		if(!isliving(M))
			usr << "This can only be used on instances of type /mob/living"
			return

		if(alert(src.owner, "Are you sure you wish to hit [key_name(M)] with Blue Space Artillery?",  "Confirm Firing?" , "Yes" , "No") != "Yes")
			return

		if(BSACooldown)
			src.owner << "Standby!  Reload cycle in progress!  Gunnary crews ready in five seconds!"
			return

		BSACooldown = 1
		spawn(50)
			BSACooldown = 0

		M << "You've been hit by bluespace artillery!"
		log_admin("[key_name(M)] has been hit by Bluespace Artillery fired by [src.owner]")
		message_admins("[key_name(M)] has been hit by Bluespace Artillery fired by [src.owner]")

		var/obj/effect/stop/S
		S = new /obj/effect/stop
		S.victim = M
		S.loc = M.loc
		spawn(20)
			qdel(S)

		var/turf/open/floor/T = GET_TURF(M)
		if(istype(T))
			if(prob(80))
				T.break_tile_to_plating()
			else
				T.break_tile()

		if(M.health == 1)
			M.gib()
		else
			M.adjustBruteLoss( min( 99 , (M.health - 1) )    )
			M.Stun(20)
			M.Weaken(20)
			M.stuttering = 20

	else if(href_list["CentComReply"])
		var/mob/living/carbon/human/H = locate(href_list["CentComReply"])
		if(!istype(H))
			usr << "This can only be used on instances of type /mob/living/carbon/human"
			return
		if(!istype(H.l_ear, /obj/item/radio/headset) && !istype(H.r_ear, /obj/item/radio/headset))
			usr << "The person you are trying to contact is not wearing a headset"
			return

		var/input = input(src.owner, "Please enter a message to reply to [key_name(H)] via their headset.","Outgoing message from CentCom", "")
		if(!input)	return

		src.owner << "You sent [input] to [H] via a secure channel."
		log_admin("[src.owner] replied to [key_name(H)]'s CentCom message with the message [input].")
		message_admins("[src.owner] replied to [key_name(H)]'s CentCom message with: \"[input]\"")
		H << "You hear something crackle in your headset for a moment before a voice speaks.  \"Please stand by for a message from Central Command.  Message as follows. <b>\"[input]\"</b>  Message ends.\""

	else if(href_list["SyndicateReply"])
		var/mob/living/carbon/human/H = locate(href_list["SyndicateReply"])
		if(!istype(H))
			usr << "This can only be used on instances of type /mob/living/carbon/human"
			return
		if(!istype(H.l_ear, /obj/item/radio/headset) && !istype(H.r_ear, /obj/item/radio/headset))
			usr << "The person you are trying to contact is not wearing a headset"
			return

		var/input = input(src.owner, "Please enter a message to reply to [key_name(H)] via their headset.","Outgoing message from The Syndicate", "")
		if(!input)	return

		src.owner << "You sent [input] to [H] via a secure channel."
		log_admin("[src.owner] replied to [key_name(H)]'s Syndicate message with the message [input].")
		H << "You hear something crackle in your headset for a moment before a voice speaks.  \"Please stand by for a message from your benefactor.  Message as follows, agent. <b>\"[input]\"</b>  Message ends.\""

	else if(href_list["CentComFaxView"])
		var/info = locate(href_list["CentComFaxView"])

		usr << browse("<HTML><HEAD><TITLE>CentCom Fax Message</TITLE></HEAD><BODY>[info]</BODY></HTML>", "window=CentCom Fax Message")

	else if(href_list["CentComFaxReply"])
		var/mob/living/carbon/human/H = locate(href_list["CentComFaxReply"])

		var/input = input(src.owner, "Please enter a message to reply to [key_name(H)] via secure connection. NOTE: BBCode does not work, but HTML tags do! Use <br> for line breaks.", "Outgoing message from CentCom", "") as message|null
		if(!input)	return

		var/customname = input(src.owner, "Pick a title for the report", "Title") as text|null

		for(var/obj/machinery/faxmachine/F in GLOBL.machines)
			if(! (F.stat & (BROKEN|NOPOWER) ) )

				// animate! it's alive!
				flick("faxreceive", F)

				// give the sprite some time to flick
				spawn(20)
					var/obj/item/paper/P = new /obj/item/paper( F.loc )
					P.name = "[command_name()]- [customname]"
					P.info = input
					P.update_icon()

					playsound(F.loc, "sound/items/polaroid1.ogg", 50, 1)

					// Stamps
					var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
					stampoverlay.icon_state = "paper_stamp-cent"
					if(!P.stamped)
						P.stamped = new
					P.stamped += /obj/item/stamp
					P.overlays += stampoverlay
					P.stamps += "<HR><i>This paper has been stamped by the Central Command Quantum Relay.</i>"

		src.owner << "Message reply to transmitted successfully."
		log_admin("[key_name(src.owner)] replied to a fax message from [key_name(H)]: [input]")
		message_admins("[key_name_admin(src.owner)] replied to a fax message from [key_name_admin(H)]", 1)


	else if(href_list["jumpto"])
		if(!check_rights(R_ADMIN))	return

		var/mob/M = locate(href_list["jumpto"])
		usr.client.jumptomob(M)

	else if(href_list["getmob"])
		if(!check_rights(R_ADMIN))	return

		if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")	return
		var/mob/M = locate(href_list["getmob"])
		usr.client.Getmob(M)

	else if(href_list["sendmob"])
		if(!check_rights(R_ADMIN))	return

		var/mob/M = locate(href_list["sendmob"])
		usr.client.sendmob(M)

	else if(href_list["narrateto"])
		if(!check_rights(R_ADMIN))	return

		var/mob/M = locate(href_list["narrateto"])
		usr.client.cmd_admin_direct_narrate(M)

	else if(href_list["subtlemessage"])
		if(!check_rights(R_MOD,0) && !check_rights(R_ADMIN))  return

		var/mob/M = locate(href_list["subtlemessage"])
		usr.client.cmd_admin_subtle_message(M)

	else if(href_list["traitor"])
		if(!check_rights(R_ADMIN|R_MOD))	return

		if(!global.PCticker || !global.PCticker.mode)
			alert("The game hasn't started yet!")
			return

		var/mob/M = locate(href_list["traitor"])
		if(!ismob(M))
			usr << "This can only be used on instances of type /mob."
			return
		show_traitor_panel(M)

	else if(href_list["create_object"])
		if(!check_rights(R_SPAWN))
			return
		return create_object(usr)

	else if(href_list["quick_create_object"])
		if(!check_rights(R_SPAWN))
			return
		return quick_create_object(usr)

	else if(href_list["create_turf"])
		if(!check_rights(R_SPAWN))
			return
		return create_turf(usr)

	else if(href_list["create_mob"])
		if(!check_rights(R_SPAWN))
			return
		return create_mob(usr)

	else if(href_list["object_list"])			//this is the laggiest thing ever
		if(!check_rights(R_SPAWN))	return

		if(!CONFIG_GET(/decl/configuration_entry/allow_admin_spawning))
			usr << "Spawning of items is not allowed."
			return

		var/atom/loc = usr.loc

		var/dirty_paths
		if (istext(href_list["object_list"]))
			dirty_paths = list(href_list["object_list"])
		else if (istype(href_list["object_list"], /list))
			dirty_paths = href_list["object_list"]

		var/paths = list()
		var/removed_paths = list()

		for(var/dirty_path in dirty_paths)
			var/path = text2path(dirty_path)
			if(!path)
				removed_paths += dirty_path
				continue
			else if(!ispath(path, /obj) && !ispath(path, /turf) && !ispath(path, /mob))
				removed_paths += dirty_path
				continue
			else if(ispath(path, /obj/item/gun/energy/pulse_rifle))
				if(!check_rights(R_FUN,0))
					removed_paths += dirty_path
					continue
			else if(ispath(path, /obj/item/melee/energy/blade))//Not an item one should be able to spawn./N
				if(!check_rights(R_FUN,0))
					removed_paths += dirty_path
					continue
			else if(ispath(path, /obj/effect/bhole))
				if(!check_rights(R_FUN,0))
					removed_paths += dirty_path
					continue
			paths += path

		if(!paths)
			alert("The path list you sent is empty")
			return
		if(length(paths) > 5)
			alert("Select fewer object types, (max 5)")
			return
		else if(length(removed_paths))
			alert("Removed:\n" + jointext(removed_paths, "\n"))

		var/list/offset = splittext(href_list["offset"],",")
		var/number = dd_range(1, 100, text2num(href_list["object_count"]))
		var/X = length(offset) ? text2num(offset[1]) : 0
		var/Y = length(offset) > 1 ? text2num(offset[2]) : 0
		var/Z = length(offset) > 2 ? text2num(offset[3]) : 0
		var/tmp_dir = href_list["object_dir"]
		var/obj_dir = tmp_dir ? text2num(tmp_dir) : 2
		if(!obj_dir || !(obj_dir in list(1,2,4,8,5,6,9,10)))
			obj_dir = 2
		var/obj_name = sanitize(href_list["object_name"])
		var/where = href_list["object_where"]
		if(!(where in list("onfloor", "inhand", "inmarked")))
			where = "onfloor"

		if(where == "inhand")
			usr << "Support for inhand not available yet. Will spawn on floor."
			where = "onfloor"

		if(where == "inhand")	//Can only give when human or monkey
			if(!(ishuman(usr) || ismonkey(usr)))
				usr << "Can only spawn in hand when you're a human or a monkey."
				where = "onfloor"
			else if(usr.get_active_hand())
				usr << "Your active hand is full. Spawning on floor."
				where = "onfloor"

		if(where == "inmarked")
			if(!marked_datum)
				usr << "You don't have any object marked. Abandoning spawn."
				return
			else
				if(!isatom(marked_datum))
					usr << "The object you have marked cannot be used as a target. Target must be of type /atom. Abandoning spawn."
					return

		var/atom/target //Where the object will be spawned
		switch ( where )
			if ( "onfloor" )
				switch (href_list["offset_type"])
					if ("absolute")
						target = locate(0 + X,0 + Y,0 + Z)
					if ("relative")
						target = locate(loc.x + X,loc.y + Y,loc.z + Z)
			if ( "inmarked" )
				target = marked_datum

		if(target)
			for(var/path in paths)
				for(var/i = 0; i < number; i++)
					if(path in typesof(/turf))
						var/turf/O = target
						var/turf/N = O.ChangeTurf(path)
						if(N)
							if(obj_name)
								N.name = obj_name
					else
						var/atom/O = new path(target)
						if(O)
							O.set_dir(obj_dir)
							if(obj_name)
								O.name = obj_name
								if(ismob(O))
									var/mob/M = O
									M.real_name = obj_name

		if(number == 1)
			log_admin("[key_name(usr)] created a [english_list(paths)]")
			for(var/path in paths)
				if(ispath(path, /mob))
					message_admins("[key_name_admin(usr)] created a [english_list(paths)]", 1)
					break
		else
			log_admin("[key_name(usr)] created [number]ea [english_list(paths)]")
			for(var/path in paths)
				if(ispath(path, /mob))
					message_admins("[key_name_admin(usr)] created [number]ea [english_list(paths)]", 1)
					break
		return

	else if(href_list["secretsfun"])
		if(!check_rights(R_FUN))	return

		var/ok = 0
		switch(href_list["secretsfun"])
			if("sec_clothes")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","SC")
				for(var/obj/item/clothing/under/O in GLOBL.movable_atom_list)
					qdel(O)
				ok = 1
			if("sec_all_clothes")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","SAC")
				for(var/obj/item/clothing/O in GLOBL.movable_atom_list)
					qdel(O)
				ok = 1
			if("sec_classic1")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","SC1")
				for(var/obj/item/clothing/suit/fire/O in GLOBL.movable_atom_list)
					qdel(O)
				for(var/obj/structure/grille/O in GLOBL.movable_atom_list)
					qdel(O)
/*					for(var/obj/machinery/vehicle/pod/O in world)
					for(var/mob/M in src)
						M.forceMove(loc)
						if (M.client)
							M.client.perspective = MOB_PERSPECTIVE
							M.client.eye = M
					del(O)
				ok = 1*/
			if("monkey")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","M")
				for(var/mob/living/carbon/human/H in GLOBL.mob_list)
					spawn(0)
						H.monkeyize()
				ok = 1
			if("corgi")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","M")
				for(var/mob/living/carbon/human/H in GLOBL.mob_list)
					spawn(0)
						H.corgize()
				ok = 1
			if("striketeam")
				if(usr.client.strike_team())
					feedback_inc("admin_secrets_fun_used",1)
					feedback_add_details("admin_secrets_fun_used","Strike")
			if("tripleAI")
				usr.client.triple_ai()
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","TriAI")
			if("gravity")
				if(isnull(global.PCticker) || isnull(global.PCticker.mode))
					to_chat(usr, "Please wait until the game starts! Not sure how it will work otherwise.")
					return
				global.PCticker.gravity_is_on = !global.PCticker.gravity_is_on
				for_no_type_check(var/area/A, GLOBL.area_list)
					A.set_gravity(global.PCticker.gravity_is_on)
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","Grav")
				if(global.PCticker.gravity_is_on)
					log_admin("[key_name(usr)] toggled gravity on.", 1)
					message_admins(SPAN_INFO("[key_name_admin(usr)] toggled gravity on."), 1)
					command_alert("Gravity generators are again functioning within normal parameters. Sorry for any inconvenience.")
				else
					log_admin("[key_name(usr)] toggled gravity off.", 1)
					message_admins(SPAN_INFO("[key_name_admin(usr)] toggled gravity off."), 1)
					command_alert("Feedback surge detected in mass-distributions systems. Artifical gravity has been disabled whilst the system reinitializes. Further failures may result in a gravitational collapse and formation of blackholes. Have a nice day.")
			if("wave")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","Meteor")
				log_admin("[key_name(usr)] spawned a meteor wave", 1)
				message_admins("\blue [key_name_admin(usr)] spawned a meteor wave.", 1)
				new /datum/round_event/meteor_wave()
			if("goblob")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","Blob")
				log_admin("[key_name(usr)] spawned a blob", 1)
				message_admins("\blue [key_name_admin(usr)] spawned a blob.", 1)
				new /datum/round_event/blob()

			if("aliens")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","Aliens")
				log_admin("[key_name(usr)] spawned an alien infestation", 1)
				message_admins("\blue [key_name_admin(usr)] attempted an alien infestation", 1)
				new /datum/round_event/alien_infestation()
			if("borers")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","Borers")
				log_admin("[key_name(usr)] spawned a cortical borer infestation.", 1)
				message_admins("\blue [key_name_admin(usr)] spawned a cortical borer infestation.", 1)
				new /datum/round_event/borer_infestation()

			if("power")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","P")
				log_admin("[key_name(usr)] made all areas powered", 1)
				message_admins("\blue [key_name_admin(usr)] made all areas powered", 1)
				power_restore()
			if("unpower")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","UP")
				log_admin("[key_name(usr)] made all areas unpowered", 1)
				message_admins("\blue [key_name_admin(usr)] made all areas unpowered", 1)
				power_failure()
			if("quickpower")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","QP")
				log_admin("[key_name(usr)] made all SMESs powered", 1)
				message_admins("\blue [key_name_admin(usr)] made all SMESs powered", 1)
				power_restore_quick()
			/*
			if("activateprison")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","AP")
				to_world("\blue <B>Transit signature detected.</B>")
				to_world("\blue <B>Incoming shuttle.</B>")
				/*
				var/A = locate(/area/shuttle_prison)
				for(var/atom/movable/AM as mob|obj in A)
					AM.z = 1
					AM.Move()
				*/
				message_admins("\blue [key_name_admin(usr)] sent the prison shuttle to the station.", 1)
			if("deactivateprison")
				/*
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","DP")
				var/A = locate(/area/shuttle_prison)
				for(var/atom/movable/AM as mob|obj in A)
					AM.z = 2
					AM.Move()
				*/
				message_admins("\blue [key_name_admin(usr)] sent the prison shuttle back.", 1)
			if("toggleprisonstatus")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","TPS")
				for(var/obj/machinery/computer/prison_shuttle/PS in GLOBL.machines)
					PS.allowedtocall = !(PS.allowedtocall)
					message_admins("\blue [key_name_admin(usr)] toggled status of prison shuttle to [PS.allowedtocall].", 1)
			if("prisonwarp")
				if(!ticker)
					alert("The game hasn't started yet!", null, null, null, null, null)
					return
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","PW")
				message_admins("\blue [key_name_admin(usr)] teleported all players to the prison station.", 1)
				for(var/mob/living/carbon/human/H in mob_list)
					var/turf/loc = find_loc(H)
					var/security = 0
					if(loc.z > 1 || prisonwarped.Find(H))
						//don't warp them if they aren't ready or are already there
						continue
					H.Paralyse(5)
					if(H.id_store)
						var/obj/item/card/id/id = H.get_idcard()
						for(var/A in id.access)
							if(A == access_security)
								security++
					if(!security)
						//strip their stuff before they teleport into a cell :downs:
						for(var/obj/item/W in H)
							if(isorgan(W))
								continue
								//don't strip organs
							H.u_equip(W)
							if (H.client)
								H.client.screen -= W
							if (W)
								W.loc = H.loc
								W.dropped(H)
								W.reset_plane_and_layer()
						//teleport person to cell
						H.loc = pick(prisonwarp)
						H.equip_to_slot_or_del(new /obj/item/clothing/under/color/orange(H), SLOT_ID_WEAR_UNIFORM)
						H.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(H), SLOT_ID_SHOES)
					else
						//teleport security person
						H.loc = pick(prisonsecuritywarp)
					prisonwarped += H
			*/
			if("traitor_all")
				if(!global.PCticker)
					alert("The game hasn't started yet!")
					return
				var/objective = copytext(sanitize(input("Enter an objective")), 1, MAX_MESSAGE_LEN)
				if(!objective)
					return
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","TA([objective])")
				for(var/mob/living/carbon/human/H in GLOBL.player_list)
					if(H.stat == DEAD || !H.client || !H.mind)
						continue
					if(is_special_character(H)) continue
					//traitorize(H, objective, 0)
					global.PCticker.mode.traitors += H.mind
					H.mind.special_role = "traitor"
					var/datum/objective/new_objective = new
					new_objective.owner = H
					new_objective.explanation_text = objective
					H.mind.objectives += new_objective
					global.PCticker.mode.greet_traitor(H.mind)
					//ticker.mode.forge_traitor_objectives(H.mind)
					global.PCticker.mode.finalize_traitor(H.mind)
				for(var/mob/living/silicon/A in GLOBL.player_list)
					global.PCticker.mode.traitors += A.mind
					A.mind.special_role = "traitor"
					var/datum/objective/new_objective = new
					new_objective.owner = A
					new_objective.explanation_text = objective
					A.mind.objectives += new_objective
					global.PCticker.mode.greet_traitor(A.mind)
					global.PCticker.mode.finalize_traitor(A.mind)
				message_admins("\blue [key_name_admin(usr)] used everyone is a traitor secret. Objective is [objective]", 1)
				log_admin("[key_name(usr)] used everyone is a traitor secret. Objective is [objective]")
			if("moveminingshuttle")
				var/datum/shuttle/ferry/mining_shuttle = global.PCshuttle.shuttles["Mining"]
				if(!mining_shuttle.can_launch())
					return
				message_admins(SPAN_INFO("[key_name_admin(usr)] moved mining shuttle"), 1)
				log_admin("[key_name(usr)] moved the mining shuttle")
				mining_shuttle.launch()
				feedback_inc("admin_secrets_fun_used", 1)
				feedback_add_details("admin_secrets_fun_used", "ShM")
			if("moveresearchshuttle")
				var/datum/shuttle/ferry/research_shuttle = global.PCshuttle.shuttles["Research"]
				if(!research_shuttle.can_launch())
					return
				message_admins(SPAN_INFO("[key_name_admin(usr)] moved research shuttle"), 1)
				log_admin("[key_name(usr)] moved the research shuttle")
				research_shuttle.launch()
				feedback_inc("admin_secrets_fun_used", 1)
				feedback_add_details("admin_secrets_fun_used", "ShR")
			if("moveadminshuttle")
				var/datum/shuttle/ferry/admin_shuttle = global.PCshuttle.shuttles["Administration"]
				if(!admin_shuttle.can_launch())
					return
				message_admins(SPAN_INFO("[key_name_admin(usr)] moved the centcom administration shuttle"), 1)
				log_admin("[key_name(usr)] moved the centcom administration shuttle")
				admin_shuttle.launch()
				feedback_inc("admin_secrets_fun_used", 1)
				feedback_add_details("admin_secrets_fun_used", "ShA")
			if("moveferry")
				var/datum/shuttle/ferry/centcom_ferry = global.PCshuttle.shuttles["CentCom"]
				if(!centcom_ferry.can_launch())
					return
				message_admins(SPAN_INFO("[key_name_admin(usr)] moved the centcom ferry"), 1)
				log_admin("[key_name(usr)] moved the centcom ferry")
				centcom_ferry.launch()
				feedback_inc("admin_secrets_fun_used", 1)
				feedback_add_details("admin_secrets_fun_used", "ShF")
			if("movealienship")
				var/datum/shuttle/ferry/alien_ship = global.PCshuttle.shuttles["Alien"]
				if(!alien_ship.can_launch())
					return
				message_admins(SPAN_INFO("[key_name_admin(usr)] moved the alien dinghy"), 1)
				log_admin("[key_name(usr)] moved the alien dinghy")
				alien_ship.launch()
				feedback_inc("admin_secrets_fun_used", 1)
				feedback_add_details("admin_secrets_fun_used", "ShX")
			if("togglebombcap")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","BC")
				switch(GLOBL.max_explosion_range)
					if(14)	GLOBL.max_explosion_range = 16
					if(16)	GLOBL.max_explosion_range = 20
					if(20)	GLOBL.max_explosion_range = 28
					if(28)	GLOBL.max_explosion_range = 56
					if(56)	GLOBL.max_explosion_range = 128
					if(128)	GLOBL.max_explosion_range = 14
				var/range_dev = GLOBL.max_explosion_range *0.25
				var/range_high = GLOBL.max_explosion_range *0.5
				var/range_low = GLOBL.max_explosion_range
				message_admins("\red <b> [key_name_admin(usr)] changed the bomb cap to [range_dev], [range_high], [range_low]</b>", 1)
				log_admin("[key_name_admin(usr)] changed the bomb cap to [GLOBL.max_explosion_range]")

			if("flicklights")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","FL")
				while(!usr.stat)
//knock yourself out to stop the ghosts
					for_no_type_check(var/mob/M, GLOBL.player_list)
						if(M.stat != DEAD && prob(25))
							var/area/AffectedArea = GET_AREA(M)
							if(AffectedArea.name != "Space" && AffectedArea.name != "Engine Walls" && AffectedArea.name != "Chemical Lab Test Chamber" && AffectedArea.name != "Escape Shuttle" && AffectedArea.name != "Arrival Area" && AffectedArea.name != "Arrival Shuttle" && AffectedArea.name != "start area" && AffectedArea.name != "Engine Combustion Chamber")
								AffectedArea.power_channels[LIGHT] = FALSE
								AffectedArea.power_change()
								spawn(rand(55,185))
									AffectedArea.power_channels[LIGHT] = TRUE
									AffectedArea.power_change()
								var/Message = rand(1,4)
								switch(Message)
									if(1)
										to_chat(M, SPAN_INFO("You shudder as if cold..."))
									if(2)
										to_chat(M, SPAN_INFO("You feel something gliding across your back..."))
									if(3)
										M.show_message(SPAN_INFO("Your eyes twitch, you feel like something you can't see is here..."), 1)
									if(4)
										M.show_message(SPAN_INFO("You notice something moving out of the corner of your eye, but nothing is there..."), 1)
								for(var/obj/W in orange(5,M))
									if(prob(25) && !W.anchored)
										step_rand(W)
					sleep(rand(100,1000))
				for_no_type_check(var/mob/M, GLOBL.player_list)
					if(M.stat != DEAD)
						to_chat(M, SPAN_INFO("The chilling wind suddenly stops..."))
/*				if("shockwave")
				ok = 1
				to_world("\red <B><big>ALERT: STATION STRESS CRITICAL</big></B>")
				sleep(60)
				to_world("\red <B><big>ALERT: STATION STRESS CRITICAL. TOLERABLE LEVELS EXCEEDED!</big></B>")
				sleep(80)
				to_world("\red <B><big>ALERT: STATION STRUCTURAL STRESS CRITICAL. SAFETY MECHANISMS FAILED!</big></B>")
				sleep(40)
				for_no_type_check(var/mob/M, GLOBL.mob_list)
					shake_camera(M, 400, 1)
				for(var/obj/structure/window/W in GLOBL.movable_atom_list)
					spawn(0)
						sleep(rand(10,400))
						W.ex_act(rand(2,1))
				for(var/obj/structure/grille/G in GLOBL.movable_atom_list)
					spawn(0)
						sleep(rand(20,400))
						G.ex_act(rand(2,1))
				for(var/obj/machinery/door/D in GLOBL.machines)
					spawn(0)
						sleep(rand(20,400))
						D.ex_act(rand(2,1))
				for(var/turf/station/floor/Floor in GLOBL.open_turf_list)
					spawn(0)
						sleep(rand(30,400))
						Floor.ex_act(rand(2,1))
				for(var/obj/structure/cable/Cable in GLOBL.cable_list)
					spawn(0)
						sleep(rand(30,400))
						Cable.ex_act(rand(2,1))
				for(var/obj/structure/closet/Closet in GLOBL.movable_atom_list)
					spawn(0)
						sleep(rand(30,400))
						Closet.ex_act(rand(2,1))
				for(var/obj/machinery/Machinery in GLOBL.machines)
					spawn(0)
						sleep(rand(30,400))
						Machinery.ex_act(rand(1,3))
				for(var/turf/station/wall/Wall in world)
					spawn(0)
						sleep(rand(30,400))
						Wall.ex_act(rand(2,1)) */
			if("wave")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","MW")
				new /datum/round_event/meteor_wave()

			if("gravanomalies")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","GA")
				command_alert("Gravitational anomalies detected on the station. There is no additional data.", "Anomaly Alert")
				world << sound('sound/AI/granomalies.ogg')
				var/turf/T = pick(GLOBL.blobstart)
				var/obj/effect/bhole/bh = new /obj/effect/bhole( T.loc, 30 )
				spawn(rand(100, 600))
					qdel(bh)

			if("timeanomalies")	//dear god this code was awful :P Still needs further optimisation
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","STA")
				//moved to its own dm so I could split it up and prevent the spawns copying variables over and over
				//can be found in code\game\game_modes\events\wormholes.dm
				wormhole_event()

			if("goblob")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","BL")
				mini_blob_event()
				message_admins("[key_name_admin(usr)] has spawned blob", 1)
			if("aliens")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","AL")
				if(CONFIG_GET(/decl/configuration_entry/aliens_allowed))
					new /datum/round_event/alien_infestation()
					message_admins("[key_name_admin(usr)] has spawned aliens", 1)
			if("spiders")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","SL")
				new /datum/round_event/spider_infestation()
				message_admins("[key_name_admin(usr)] has spawned spiders", 1)
			if("comms_blackout")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","CB")
				var/answer = alert(usr, "Would you like to alert the crew?", "Alert", "Yes", "No")
				if(answer == "Yes")
					communications_blackout(0)
				else
					communications_blackout(1)
				message_admins("[key_name_admin(usr)] triggered a communications blackout.", 1)
			if("spaceninja")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","SN")
				if(GLOBL.toggle_space_ninja)
					if(space_ninja_arrival())//If the ninja is actually spawned. They may not be depending on a few factors.
						message_admins("[key_name_admin(usr)] has sent in a space ninja", 1)
			if("carp")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","C")
				var/choice = input("You sure you want to spawn carp?") in list("Badmin", "Cancel")
				if(choice == "Badmin")
					message_admins("[key_name_admin(usr)] has spawned carp.", 1)
					new /datum/round_event/carp_migration()
			if("radiation")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","R")
				message_admins("[key_name_admin(usr)] has has irradiated the station", 1)
				new /datum/round_event/storm/radiation()
			if("immovable")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","IR")
				message_admins("[key_name_admin(usr)] has sent an immovable rod to the station", 1)
				immovablerod()
			if("prison_break")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","PB")
				message_admins("[key_name_admin(usr)] has allowed a prison break", 1)
				prison_break()
			if("lightsout")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","LO")
				message_admins("[key_name_admin(usr)] has broke a lot of lights", 1)
				lightsout(1,2)
			if("blackout")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","BO")
				message_admins("[key_name_admin(usr)] broke all lights", 1)
				lightsout(0,0)
			if("whiteout")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","WO")
				for(var/obj/machinery/light/L in GLOBL.movable_atom_list)
					L.fix()
				message_admins("[key_name_admin(usr)] fixed all lights", 1)
			if("friendai")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","FA")
				for(var/mob/dead/ai_eye/aE in GLOBL.mob_list)
					aE.icon_state = "ai_friend"
				var/obj/machinery/computer/communications/comms = pick(GLOBL.communications_consoles)
				comms?.post_status("friend_computer")
				message_admins("[key_name_admin(usr)] turned all AIs into best friends.", 1)
			if("floorlava")
				if(floorIsLava)
					usr << "The floor is lava already."
					return
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","LF")

				//Options
				var/length = input(usr, "How long will the lava last? (in seconds)", "Length", 180) as num
				length = min(abs(length), 1200)

				var/damage = input(usr, "How deadly will the lava be?", "Damage", 2) as num
				damage = min(abs(damage), 100)

				var/sure = alert(usr, "Are you sure you want to do this?", "Confirmation", "YES!", "Nah")
				if(sure == "Nah")
					return
				floorIsLava = 1

				message_admins("[key_name_admin(usr)] made the floor LAVA! It'll last [length] seconds and it will deal [damage] damage to everyone.", 1)

				for(var/turf/open/floor/F in GLOBL.open_turf_list)
					if(isstationlevel(F.z))
						F.name = "lava"
						F.desc = "The floor is LAVA!"
						F.overlays += "lava"
						F.lava = 1

				spawn(0)
					for(var/i = 0, i < length, i++) // 180 = 3 minutes
						if(damage)
							for(var/mob/living/carbon/L in GLOBL.living_mob_list)
								if(isfloorturf(L.loc)) // Are they on LAVA?!
									var/turf/open/floor/F = L.loc
									if(F.lava)
										var/safe = 0
										for(var/obj/structure/O in F.contents)
											if(O.level > F.level && !istype(O, /obj/structure/window)) // Something to stand on and it isn't under the floor!
												safe = 1
												break
										if(!safe)
											L.adjustFireLoss(damage)


						sleep(10)

					for(var/turf/open/floor/F in GLOBL.open_turf_list) // Reset everything.
						if(isstationlevel(F.z))
							F.name = initial(F.name)
							F.desc = initial(F.desc)
							F.overlays.Cut()
							F.lava = 0
							F.update_icon()
					floorIsLava = 0
				return
			if("virus")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","V")
				var/answer = alert("Do you want this to be a greater disease or a lesser one?",,"Greater","Lesser")
				if(answer=="Lesser")
					virus2_lesser_infection()
					message_admins("[key_name_admin(usr)] has triggered a lesser virus outbreak.", 1)
				else
					virus2_greater_infection()
					message_admins("[key_name_admin(usr)] has triggered a greater virus outbreak.", 1)
			if("retardify")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","RET")
				for(var/mob/living/carbon/human/H in GLOBL.player_list)
					H << "\red <B>You suddenly feel stupid.</B>"
					H.setBrainLoss(60)
				message_admins("[key_name_admin(usr)] made everybody retarded")
			if("fakeguns")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","FG")
				for(var/obj/item/W in GLOBL.movable_atom_list)
					if(istype(W, /obj/item/clothing) || istype(W, /obj/item/card/id) || istype(W, /obj/item/disk) || istype(W, /obj/item/tank))
						continue
					W.icon = 'icons/obj/weapons/gun.dmi'
					W.icon_state = "revolver"
					W.item_state = "gun"
				message_admins("[key_name_admin(usr)] made every item look like a gun")
			if("schoolgirl")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","SG")
				for(var/obj/item/clothing/under/W in GLOBL.movable_atom_list)
					W.icon_state = "schoolgirl"
					W.item_state = "w_suit"
					W.item_color = "schoolgirl"
				message_admins("[key_name_admin(usr)] activated Japanese Animes mode")
				world << sound('sound/AI/animes.ogg')
			if("eagles")//SCRAW
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","EgL")
				for_no_type_check(var/obj/machinery/door/airlock/W, GLOBL.airlocks_list)
					var/area/A = GET_AREA(W)
					if(isstationlevel(W.z) && !istype(A, /area/station/command) && !istype(A, /area/station/crew) && !istype(A, /area/external/prison))
						W.req_access = list()
				message_admins("[key_name_admin(usr)] activated Egalitarian Station mode")
				command_alert("CentCom airlock control override activated. Please take this time to get acquainted with your coworkers.")
				world << sound('sound/AI/commandreport.ogg')
			if("dorf")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","DF")
				for(var/mob/living/carbon/human/B in GLOBL.mob_list)
					B.f_style = "Dward Beard"
					B.update_hair()
				message_admins("[key_name_admin(usr)] activated dorf mode")
			if("ionstorm")
				feedback_inc("admin_secrets_fun_used", 1)
				feedback_add_details("admin_secrets_fun_used", "I")
				new /datum/round_event/storm/ion()
				message_admins("[key_name_admin(usr)] triggered an ion storm")
			if("ion_storm_large")
				feedback_inc("admin_secrets_fun_used", 1)
				feedback_add_details("admin_secrets_fun_used", "ISL")
				new /datum/round_event/storm/ion_large()
				message_admins("[key_name_admin(usr)] triggered a severe ion storm")
			if("spacevines")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","K")
				new /datum/round_event/spacevine()
				message_admins("[key_name_admin(usr)] has spawned spacevines", 1)
			if("onlyone")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","OO")
				usr.client.only_one()
				message_admins("[key_name_admin(usr)] has triggered a battle to the death (only one)")
			if("electricstorm")
				feedback_inc("admin_secrets_fun_used", 1)
				feedback_add_details("admin_secrets_fun_used", "EL")
				new /datum/round_event/storm/electrical()
				message_admins("[key_name_admin(usr)] triggered an electrical storm", 1)
			if("electrical_storm_large")
				feedback_inc("admin_secrets_fun_used", 1)
				feedback_add_details("admin_secrets_fun_used", "ESL")
				new /datum/round_event/storm/electrical_large()
				message_admins("[key_name_admin(usr)] triggered a severe electrical storm", 1)
		if(usr)
			log_admin("[key_name(usr)] used secret [href_list["secretsfun"]]")
			if (ok)
				to_world("<B>A secret has been activated by [usr.key]!</B>")

	else if(href_list["secretsadmin"])
		if(!check_rights(R_ADMIN))	return

		var/ok = 0
		switch(href_list["secretsadmin"])
			if("clear_bombs")
				//I do nothing
			if("change_sec")
				//var/level = alert(usr, "What would you like to change the security level to?", "Security Level", "Code Green", "Code Blue", "Code Red", "Code Delta", "Cancel"))
				var/level = input("Please select security level:", "Security Level") as null | anything in list("Green", "Yellow", "Blue", "Red", "Delta", "Cancel")
				//Stupid BYOND...  Alert can only take 6 args.
				switch(level)
					if("Green")
						set_security_level(/decl/security_level/green)
					if("Yellow")
						set_security_level(/decl/security_level/yellow)
					if("Blue")
						set_security_level(/decl/security_level/blue)
					if("Red")
						set_security_level(/decl/security_level/red)
					if("Delta")
						set_security_level(/decl/security_level/delta)
					if("Cancel")
						return
				if(level != "Cancel")
					log_admin("[usr.key] has changed the security level to [level].")
					message_admins("[usr.key] has changed the security level to [level].")
			if("list_bombers")
				var/dat = "<B>Bombing List<HR>"
				for(var/l in GLOBL.bombers)
					dat += text("[l]<BR>")
				usr << browse(dat, "window=bombers")
			if("list_signalers")
				var/dat = "<B>Showing last [length(GLOBL.lastsignalers)] signalers.</B><HR>"
				for(var/sig in GLOBL.lastsignalers)
					dat += "[sig]<BR>"
				usr << browse(dat, "window=lastsignalers;size=800x500")
			if("list_lawchanges")
				var/dat = "<B>Showing last [length(GLOBL.lawchanges)] law changes.</B><HR>"
				for(var/sig in GLOBL.lawchanges)
					dat += "[sig]<BR>"
				usr << browse(dat, "window=lawchanges;size=800x500")
			if("list_job_debug")
				var/dat = "<B>Job Debug info.</B><HR>"
				if(global.CTjobs)
					for(var/line in global.CTjobs.job_debug)
						dat += "[line]<BR>"
					dat+= "*******<BR><BR>"
					for_no_type_check(var/datum/job/job, global.CTjobs.occupations)
						if(!job)	continue
						dat += "job: [job.title], current_positions: [job.current_positions], total_positions: [job.total_positions] <BR>"
					usr << browse(dat, "window=jobdebug;size=600x500")
			if("showailaws")
				output_ai_laws()
			if("showgm")
				if(!global.PCticker)
					alert("The game hasn't started yet!")
				else if(global.PCticker.mode)
					alert("The game mode is [global.PCticker.mode.name]")
				else alert("For some reason there's a ticker, but not a game mode")
			if("manifest")
				var/dat = "<B>Showing Crew Manifest.</B><HR>"
				dat += "<table cellspacing=5><tr><th>Name</th><th>Position</th></tr>"
				for(var/mob/living/carbon/human/H in GLOBL.mob_list)
					if(H.ckey)
						dat += text("<tr><td>[]</td><td>[]</td></tr>", H.name, H.get_assignment())
				dat += "</table>"
				usr << browse(dat, "window=manifest;size=440x410")
			if("check_antagonist")
				check_antagonists()
			if("DNA")
				var/dat = "<B>Showing DNA from blood.</B><HR>"
				dat += "<table cellspacing=5><tr><th>Name</th><th>DNA</th><th>Blood Type</th></tr>"
				for(var/mob/living/carbon/human/H in GLOBL.mob_list)
					if(H.dna && H.ckey)
						dat += "<tr><td>[H]</td><td>[H.dna.unique_enzymes]</td><td>[H.b_type]</td></tr>"
				dat += "</table>"
				usr << browse(dat, "window=DNA;size=440x410")
			if("fingerprints")
				var/dat = "<B>Showing Fingerprints.</B><HR>"
				dat += "<table cellspacing=5><tr><th>Name</th><th>Fingerprints</th></tr>"
				for(var/mob/living/carbon/human/H in GLOBL.mob_list)
					if(H.ckey)
						if(H.dna && H.dna.uni_identity)
							dat += "<tr><td>[H]</td><td>[md5(H.dna.uni_identity)]</td></tr>"
						else if(H.dna && !H.dna.uni_identity)
							dat += "<tr><td>[H]</td><td>H.dna.uni_identity = null</td></tr>"
						else if(!H.dna)
							dat += "<tr><td>[H]</td><td>H.dna = null</td></tr>"
				dat += "</table>"
				usr << browse(dat, "window=fingerprints;size=440x410")
			else
		if (usr)
			log_admin("[key_name(usr)] used secret [href_list["secretsadmin"]]")
			if (ok)
				to_world("<B>A secret has been activated by [usr.key]!</B>")

	else if(href_list["secretscoder"])
		if(!check_rights(R_DEBUG))	return

		switch(href_list["secretscoder"])
			if("spawn_objects")
				var/dat = "<B>Admin Log<HR></B>"
				for(var/l in GLOBL.admin_log)
					dat += "<li>[l]</li>"
				if(!length(GLOBL.admin_log))
					dat += "No-one has done anything this round!"
				usr << browse(dat, "window=admin_log")
			if("maint_access_brig")
				for_no_type_check(var/obj/machinery/door/airlock/maintenance/M, GLOBL.maintenance_airlocks_list)
					if(ACCESS_MAINT_TUNNELS in M.req_access)
						M.req_access = list(ACCESS_BRIG)
				message_admins("[key_name_admin(usr)] made all maint doors brig access-only.")
			if("maint_access_engiebrig")
				for_no_type_check(var/obj/machinery/door/airlock/maintenance/M, GLOBL.maintenance_airlocks_list)
					if(ACCESS_MAINT_TUNNELS in M.req_access)
						M.req_access = list()
						M.req_one_access = list(ACCESS_BRIG, ACCESS_ENGINE)
				message_admins("[key_name_admin(usr)] made all maint doors engineering and brig access-only.")
			if("infinite_sec")
				var/datum/job/J = global.CTjobs.get_job("Security Officer")
				if(!J)
					return
				J.total_positions = -1
				J.spawn_positions = -1
				message_admins("[key_name_admin(usr)] has removed the cap on security officers.")

	else if(href_list["ac_view_wanted"])			//Admin newscaster Topic() stuff be here
		src.admincaster_screen = 18					//The ac_ prefix before the hrefs stands for AdminCaster.
		src.access_news_network()

	else if(href_list["ac_set_channel_name"])
		src.admincaster_feed_channel.channel_name = strip_html_simple(input(usr, "Provide a Feed Channel Name", "Network Channel Handler", ""))
		while (findtext(src.admincaster_feed_channel.channel_name," ") == 1)
			src.admincaster_feed_channel.channel_name = copytext(src.admincaster_feed_channel.channel_name,2,length(src.admincaster_feed_channel.channel_name)+1)
		src.access_news_network()

	else if(href_list["ac_set_channel_lock"])
		src.admincaster_feed_channel.locked = !src.admincaster_feed_channel.locked
		src.access_news_network()

	else if(href_list["ac_submit_new_channel"])
		var/check = 0
		for_no_type_check(var/datum/feed_channel/FC, global.CTeconomy.news_network.channels)
			if(FC.channel_name == src.admincaster_feed_channel.channel_name)
				check = 1
				break
		if(src.admincaster_feed_channel.channel_name == "" || src.admincaster_feed_channel.channel_name == "\[REDACTED\]" || check )
			src.admincaster_screen=7
		else
			var/choice = alert("Please confirm Feed channel creation","Network Channel Handler","Confirm","Cancel")
			if(choice=="Confirm")
				var/datum/feed_channel/newChannel = new /datum/feed_channel
				newChannel.channel_name = src.admincaster_feed_channel.channel_name
				newChannel.author = src.admincaster_signature
				newChannel.locked = src.admincaster_feed_channel.locked
				newChannel.is_admin_channel = TRUE
				feedback_inc("newscaster_channels",1)
				global.CTeconomy.news_network.channels.Add(newChannel)	// Adds the channel to the global network.
				log_admin("[key_name_admin(usr)] created command feed channel: [src.admincaster_feed_channel.channel_name]!")
				src.admincaster_screen=5
		src.access_news_network()

	else if(href_list["ac_set_channel_receiving"])
		var/list/available_channels = list()
		for_no_type_check(var/datum/feed_channel/F, global.CTeconomy.news_network.channels)
			available_channels += F.channel_name
		src.admincaster_feed_channel.channel_name = adminscrub(input(usr, "Choose receiving Feed Channel", "Network Channel Handler") in available_channels )
		src.access_news_network()

	else if(href_list["ac_set_new_message"])
		src.admincaster_feed_message.body = adminscrub(input(usr, "Write your Feed story", "Network Channel Handler", ""))
		while (findtext(src.admincaster_feed_message.body," ") == 1)
			src.admincaster_feed_message.body = copytext(src.admincaster_feed_message.body,2,length(src.admincaster_feed_message.body)+1)
		src.access_news_network()

	else if(href_list["ac_submit_new_message"])
		if(src.admincaster_feed_message.body =="" || src.admincaster_feed_message.body =="\[REDACTED\]" || src.admincaster_feed_channel.channel_name == "" )
			src.admincaster_screen = 6
		else
			var/datum/feed_message/newMsg = new /datum/feed_message
			newMsg.author = src.admincaster_signature
			newMsg.body = src.admincaster_feed_message.body
			newMsg.is_admin_message = TRUE
			feedback_inc("newscaster_stories",1)
			for_no_type_check(var/datum/feed_channel/FC, global.CTeconomy.news_network.channels)
				if(FC.channel_name == src.admincaster_feed_channel.channel_name)
					FC.messages += newMsg //Adding message to the network's appropriate feed_channel
					break
			src.admincaster_screen=4

		for_no_type_check(var/obj/machinery/newscaster/caster, GLOBL.all_newscasters)
			caster.newsAlert(src.admincaster_feed_channel.channel_name)

		log_admin("[key_name_admin(usr)] submitted a feed story to channel: [src.admincaster_feed_channel.channel_name]!")
		src.access_news_network()

	else if(href_list["ac_create_channel"])
		src.admincaster_screen=2
		src.access_news_network()

	else if(href_list["ac_create_feed_story"])
		src.admincaster_screen=3
		src.access_news_network()

	else if(href_list["ac_menu_censor_story"])
		src.admincaster_screen=10
		src.access_news_network()

	else if(href_list["ac_menu_censor_channel"])
		src.admincaster_screen=11
		src.access_news_network()

	else if(href_list["ac_menu_wanted"])
		var/already_wanted = 0
		if(global.CTeconomy.news_network.wanted_issue)
			already_wanted = 1

		if(already_wanted)
			src.admincaster_feed_message.author = global.CTeconomy.news_network.wanted_issue.author
			src.admincaster_feed_message.body = global.CTeconomy.news_network.wanted_issue.body
		src.admincaster_screen = 14
		src.access_news_network()

	else if(href_list["ac_set_wanted_name"])
		src.admincaster_feed_message.author = adminscrub(input(usr, "Provide the name of the Wanted person", "Network Security Handler", ""))
		while (findtext(src.admincaster_feed_message.author," ") == 1)
			src.admincaster_feed_message.author = copytext(admincaster_feed_message.author,2,length(admincaster_feed_message.author)+1)
		src.access_news_network()

	else if(href_list["ac_set_wanted_desc"])
		src.admincaster_feed_message.body = adminscrub(input(usr, "Provide the a description of the Wanted person and any other details you deem important", "Network Security Handler", ""))
		while (findtext(src.admincaster_feed_message.body," ") == 1)
			src.admincaster_feed_message.body = copytext(src.admincaster_feed_message.body,2,length(src.admincaster_feed_message.body)+1)
		src.access_news_network()

	else if(href_list["ac_submit_wanted"])
		var/input_param = text2num(href_list["ac_submit_wanted"])
		if(src.admincaster_feed_message.author == "" || src.admincaster_feed_message.body == "")
			src.admincaster_screen = 16
		else
			var/choice = alert("Please confirm Wanted Issue [(input_param==1) ? ("creation.") : ("edit.")]","Network Security Handler","Confirm","Cancel")
			if(choice=="Confirm")
				if(input_param==1)          //If input_param == 1 we're submitting a new wanted issue. At 2 we're just editing an existing one. See the else below
					var/datum/feed_message/WANTED = new /datum/feed_message
					WANTED.author = src.admincaster_feed_message.author               //Wanted name
					WANTED.body = src.admincaster_feed_message.body                   //Wanted desc
					WANTED.backup_author = src.admincaster_signature                  //Submitted by
					WANTED.is_admin_message = TRUE
					global.CTeconomy.news_network.wanted_issue = WANTED
					for_no_type_check(var/obj/machinery/newscaster/caster, GLOBL.all_newscasters)
						caster.newsAlert()
						caster.update_icon()
					src.admincaster_screen = 15
				else
					global.CTeconomy.news_network.wanted_issue.author = src.admincaster_feed_message.author
					global.CTeconomy.news_network.wanted_issue.body = src.admincaster_feed_message.body
					global.CTeconomy.news_network.wanted_issue.backup_author = src.admincaster_feed_message.backup_author
					src.admincaster_screen = 19
				log_admin("[key_name_admin(usr)] issued a Station-wide Wanted Notification for [src.admincaster_feed_message.author]!")
		src.access_news_network()

	else if(href_list["ac_cancel_wanted"])
		var/choice = alert("Please confirm Wanted Issue removal","Network Security Handler","Confirm","Cancel")
		if(choice=="Confirm")
			global.CTeconomy.news_network.wanted_issue = null
			for_no_type_check(var/obj/machinery/newscaster/caster, GLOBL.all_newscasters)
				caster.update_icon()
			src.admincaster_screen=17
		src.access_news_network()

	else if(href_list["ac_censor_channel_author"])
		var/datum/feed_channel/FC = locate(href_list["ac_censor_channel_author"])
		if(FC.author != "<B>\[REDACTED\]</B>")
			FC.backup_author = FC.author
			FC.author = "<B>\[REDACTED\]</B>"
		else
			FC.author = FC.backup_author
		src.access_news_network()

	else if(href_list["ac_censor_channel_story_author"])
		var/datum/feed_message/MSG = locate(href_list["ac_censor_channel_story_author"])
		if(MSG.author != "<B>\[REDACTED\]</B>")
			MSG.backup_author = MSG.author
			MSG.author = "<B>\[REDACTED\]</B>"
		else
			MSG.author = MSG.backup_author
		src.access_news_network()

	else if(href_list["ac_censor_channel_story_body"])
		var/datum/feed_message/MSG = locate(href_list["ac_censor_channel_story_body"])
		if(MSG.body != "<B>\[REDACTED\]</B>")
			MSG.backup_body = MSG.body
			MSG.body = "<B>\[REDACTED\]</B>"
		else
			MSG.body = MSG.backup_body
		src.access_news_network()

	else if(href_list["ac_pick_d_notice"])
		var/datum/feed_channel/FC = locate(href_list["ac_pick_d_notice"])
		src.admincaster_feed_channel = FC
		src.admincaster_screen=13
		src.access_news_network()

	else if(href_list["ac_toggle_d_notice"])
		var/datum/feed_channel/FC = locate(href_list["ac_toggle_d_notice"])
		FC.censored = !FC.censored
		src.access_news_network()

	else if(href_list["ac_view"])
		src.admincaster_screen=1
		src.access_news_network()

	else if(href_list["ac_setScreen"]) //Brings us to the main menu and resets all fields~
		src.admincaster_screen = text2num(href_list["ac_setScreen"])
		if (src.admincaster_screen == 0)
			if(src.admincaster_feed_channel)
				src.admincaster_feed_channel = new /datum/feed_channel
			if(src.admincaster_feed_message)
				src.admincaster_feed_message = new /datum/feed_message
		src.access_news_network()

	else if(href_list["ac_show_channel"])
		var/datum/feed_channel/FC = locate(href_list["ac_show_channel"])
		src.admincaster_feed_channel = FC
		src.admincaster_screen = 9
		src.access_news_network()

	else if(href_list["ac_pick_censor_channel"])
		var/datum/feed_channel/FC = locate(href_list["ac_pick_censor_channel"])
		src.admincaster_feed_channel = FC
		src.admincaster_screen = 12
		src.access_news_network()

	else if(href_list["ac_refresh"])
		src.access_news_network()

	else if(href_list["ac_set_signature"])
		src.admincaster_signature = adminscrub(input(usr, "Provide your desired signature", "Network Identity Handler", ""))
		src.access_news_network()

	else if(href_list["populate_inactive_customitems"])
		if(check_rights(R_ADMIN|R_SERVER))
			populate_inactive_customitems_list(src.owner)

	else if(href_list["vsc"])
		if(check_rights(R_ADMIN|R_SERVER))
			if(href_list["vsc"] == "airflow")
				global.vsc.ChangeSettingsDialog(usr, vsc.settings)
			if(href_list["vsc"] == "plasma")
				global.vsc.ChangeSettingsDialog(usr, vsc.plc.settings)
			if(href_list["vsc"] == "default")
				global.vsc.SetDefault(usr)

	// player info stuff

	if(href_list["add_player_info"])
		var/key = href_list["add_player_info"]
		var/add = input("Add Player Info") as null|text
		if(!add) return

		notes_add(key,add,usr)
		show_player_info(key)

	if(href_list["remove_player_info"])
		var/key = href_list["remove_player_info"]
		var/index = text2num(href_list["remove_index"])

		notes_del(key, index)
		show_player_info(key)

	if(href_list["notes"])
		var/ckey = href_list["ckey"]
		if(!ckey)
			var/mob/M = locate(href_list["mob"])
			if(ismob(M))
				ckey = M.ckey

		switch(href_list["notes"])
			if("show")
				show_player_info(ckey)
			if("list")
				PlayerNotesPage(text2num(href_list["index"]))
		return
