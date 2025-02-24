/proc/sql_poll_players()
	if(!CONFIG_GET(/decl/configuration_entry/sql_logging))
		return
	var/playercount = 0
	for_no_type_check(var/mob/M, GLOBL.player_list)
		if(isnotnull(M.client))
			playercount++
	establish_db_connection()
	if(!GLOBL.dbcon.IsConnected())
		log_game("SQL ERROR during player polling. Failed to connect.")
	else
		var/sqltime = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")
		var/DBQuery/query = GLOBL.dbcon_old.NewQuery("INSERT INTO population (playercount, time) VALUES ([playercount], '[sqltime]')")
		if(!query.Execute())
			var/err = query.ErrorMsg()
			log_game("SQL ERROR during player polling. Error : \[[err]\]\n")

/proc/sql_poll_admins()
	if(!CONFIG_GET(/decl/configuration_entry/sql_logging))
		return
	var/admincount = length(GLOBL.admins)
	establish_db_connection()
	if(!GLOBL.dbcon.IsConnected())
		log_game("SQL ERROR during admin polling. Failed to connect.")
	else
		var/sqltime = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")
		var/DBQuery/query = GLOBL.dbcon_old.NewQuery("INSERT INTO population (admincount, time) VALUES ([admincount], '[sqltime]')")
		if(!query.Execute())
			var/err = query.ErrorMsg()
			log_game("SQL ERROR during admin polling. Error : \[[err]\]\n")

/proc/sql_report_round_start()
	// TODO
	if(!CONFIG_GET(/decl/configuration_entry/sql_logging))
		return
/proc/sql_report_round_end()
	// TODO
	if(!CONFIG_GET(/decl/configuration_entry/sql_logging))
		return

/proc/sql_report_death(mob/living/carbon/human/H)
	if(!CONFIG_GET(/decl/configuration_entry/sql_logging))
		return
	if(isnull(H))
		return
	if(isnull(H.key) || isnull(H.mind))
		return

	var/area/placeofdeath = GET_AREA(H)
	var/podname = placeofdeath.name

	var/sqlname = sanitizeSQL(H.real_name)
	var/sqlkey = sanitizeSQL(H.key)
	var/sqlpod = sanitizeSQL(podname)
	var/sqlspecial = sanitizeSQL(H.mind.special_role)
	var/sqljob = sanitizeSQL(H.mind.assigned_role)
	var/laname
	var/lakey
	if(H.lastattacker)
		laname = sanitizeSQL(H.lastattacker:real_name)
		lakey = sanitizeSQL(H.lastattacker:key)
	var/sqltime = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")
	var/coord = "[H.x], [H.y], [H.z]"
	//to_world("INSERT INTO death (name, byondkey, job, special, pod, tod, laname, lakey, gender, bruteloss, fireloss, brainloss, oxyloss) VALUES ('[sqlname]', '[sqlkey]', '[sqljob]', '[sqlspecial]', '[sqlpod]', '[sqltime]', '[laname]', '[lakey]', '[H.gender]', [H.bruteloss], [H.getFireLoss()], [H.brainloss], [H.getOxyLoss()])")
	establish_db_connection()
	if(!GLOBL.dbcon.IsConnected())
		log_game("SQL ERROR during death reporting. Failed to connect.")
	else
		var/DBQuery/query = GLOBL.dbcon.NewQuery("INSERT INTO death (name, byondkey, job, special, pod, tod, laname, lakey, gender, bruteloss, fireloss, brainloss, oxyloss, coord) VALUES ('[sqlname]', '[sqlkey]', '[sqljob]', '[sqlspecial]', '[sqlpod]', '[sqltime]', '[laname]', '[lakey]', '[H.gender]', [H.getBruteLoss()], [H.getFireLoss()], [H.brainloss], [H.getOxyLoss()], '[coord]')")
		if(!query.Execute())
			var/err = query.ErrorMsg()
			log_game("SQL ERROR during death reporting. Error : \[[err]\]\n")

/proc/sql_report_cyborg_death(mob/living/silicon/robot/H)
	if(!CONFIG_GET(/decl/configuration_entry/sql_logging))
		return
	if(isnull(H))
		return
	if(isnull(H.key) || isnull(H.mind))
		return

	var/area/placeofdeath = GET_AREA(H)
	var/podname = placeofdeath.name

	var/sqlname = sanitizeSQL(H.real_name)
	var/sqlkey = sanitizeSQL(H.key)
	var/sqlpod = sanitizeSQL(podname)
	var/sqlspecial = sanitizeSQL(H.mind.special_role)
	var/sqljob = sanitizeSQL(H.mind.assigned_role)
	var/laname
	var/lakey
	if(H.lastattacker)
		laname = sanitizeSQL(H.lastattacker:real_name)
		lakey = sanitizeSQL(H.lastattacker:key)
	var/sqltime = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")
	var/coord = "[H.x], [H.y], [H.z]"
	//to_world("INSERT INTO death (name, byondkey, job, special, pod, tod, laname, lakey, gender, bruteloss, fireloss, brainloss, oxyloss) VALUES ('[sqlname]', '[sqlkey]', '[sqljob]', '[sqlspecial]', '[sqlpod]', '[sqltime]', '[laname]', '[lakey]', '[H.gender]', [H.bruteloss], [H.getFireLoss()], [H.brainloss], [H.getOxyLoss()])")
	establish_db_connection()
	if(!GLOBL.dbcon.IsConnected())
		log_game("SQL ERROR during death reporting. Failed to connect.")
	else
		var/DBQuery/query = GLOBL.dbcon.NewQuery("INSERT INTO death (name, byondkey, job, special, pod, tod, laname, lakey, gender, bruteloss, fireloss, brainloss, oxyloss, coord) VALUES ('[sqlname]', '[sqlkey]', '[sqljob]', '[sqlspecial]', '[sqlpod]', '[sqltime]', '[laname]', '[lakey]', '[H.gender]', [H.getBruteLoss()], [H.getFireLoss()], [H.brainloss], [H.getOxyLoss()], '[coord]')")
		if(!query.Execute())
			var/err = query.ErrorMsg()
			log_game("SQL ERROR during death reporting. Error : \[[err]\]\n")

/proc/statistic_cycle()
	if(!CONFIG_GET(/decl/configuration_entry/sql_logging))
		return
	while(1)
		sql_poll_players()
		sleep(1 MINUTE)
		sql_poll_admins()
		sleep(10 MINUTES) // Poll every ten minutes

//This proc is used for feedback. It is executed at round end.
/proc/sql_commit_feedback()
	if(isnull(blackbox))
		log_game("Round ended without a blackbox recorder. No feedback was sent to the database.")
		return

	//content is a list of lists. Each item in the list is a list with two fields, a variable name and a value. Items MUST only have these two values.
	var/list/datum/feedback_variable/content = blackbox.get_round_feedback()

	if(!content)
		log_game("Round ended without any feedback being generated. No feedback was sent to the database.")
		return

	establish_db_connection()
	if(!GLOBL.dbcon.IsConnected())
		log_game("SQL ERROR during feedback reporting. Failed to connect.")
	else

		var/DBQuery/max_query = GLOBL.dbcon.NewQuery("SELECT MAX(roundid) AS max_round_id FROM erro_feedback")
		max_query.Execute()

		var/newroundid

		while(max_query.NextRow())
			newroundid = max_query.item[1]

		if(!isnum(newroundid))
			newroundid = text2num(newroundid)

		if(isnum(newroundid))
			newroundid++
		else
			newroundid = 1

		for(var/datum/feedback_variable/item in content)
			var/variable = item.get_variable()
			var/value = item.get_value()

			var/DBQuery/query = GLOBL.dbcon.NewQuery("INSERT INTO erro_feedback (id, roundid, time, variable, value) VALUES (null, [newroundid], Now(), '[variable]', '[value]')")
			if(!query.Execute())
				var/err = query.ErrorMsg()
				log_game("SQL ERROR during death reporting. Error : \[[err]\]\n")