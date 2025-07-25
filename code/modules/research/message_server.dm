GLOBAL_GLOBL_LIST_NEW(obj/machinery/message_server/message_servers)

/datum/data_pda_msg
	var/recipient = "Unspecified" //name of the person
	var/sender = "Unspecified" //name of the sender
	var/message = "Blank" //transferred message

/datum/data_pda_msg/New(param_rec = "", param_sender = "", param_message = "")
	if(param_rec)
		recipient = param_rec
	if(param_sender)
		sender = param_sender
	if(param_message)
		message = param_message


/datum/data_rc_msg
	var/rec_dpt = "Unspecified" //name of the person
	var/send_dpt = "Unspecified" //name of the sender
	var/message = "Blank" //transferred message
	var/stamp = "Unstamped"
	var/id_auth = "Unauthenticated"
	var/priority = "Normal"

/datum/data_rc_msg/New(param_rec = "", param_sender = "", param_message = "", param_stamp = "", param_id_auth = "", param_priority)
	if(param_rec)
		rec_dpt = param_rec
	if(param_sender)
		send_dpt = param_sender
	if(param_message)
		message = param_message
	if(param_stamp)
		stamp = param_stamp
	if(param_id_auth)
		id_auth = param_id_auth
	if(param_priority)
		switch(param_priority)
			if(1)
				priority = "Normal"
			if(2)
				priority = "High"
			if(3)
				priority = "Extreme"
			else
				priority = "Undetermined"


/obj/machinery/message_server
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "server"
	name = "Messaging Server"
	density = TRUE
	anchored = TRUE

	power_usage = alist(
		USE_POWER_IDLE = 10,
		USE_POWER_ACTIVE = 100
	)

	var/list/datum/data_pda_msg/pda_msgs = list()
	var/list/datum/data_rc_msg/rc_msgs = list()
	var/active = 1
	var/decryptkey = "password"

/obj/machinery/message_server/initialise()
	. = ..()
	GLOBL.message_servers.Add(src)
	decryptkey = GenerateKey()
	send_pda_message("System Administrator", "system", "This is an automated message. The messaging system is functioning correctly.")

/obj/machinery/message_server/Destroy()
	GLOBL.message_servers.Remove(src)
	return ..()

/obj/machinery/message_server/proc/GenerateKey()
	//Feel free to move to Helpers.
	var/newKey
	newKey += pick("the", "if", "of", "as", "in", "a", "you", "from", "to", "an", "too", "little", "snow", "dead", "drunk", "rosebud", "duck", "al", "le")
	newKey += pick("diamond", "beer", "mushroom", "assistant", "clown", "captain", "twinkie", "security", "nuke", "small", "big", "escape", "yellow", "gloves", "monkey", "engine", "nuclear", "ai")
	newKey += pick("1", "2", "3", "4", "5", "6", "7", "8", "9", "0")
	return newKey

/obj/machinery/message_server/process()
	//if(decryptkey == "password")
	//	decryptkey = generateKey()
	if(active && (stat & (BROKEN | NOPOWER)))
		active = 0
		return
	update_icon()
	return

/obj/machinery/message_server/proc/send_pda_message(recipient = "", sender = "", message = "")
	pda_msgs += new/datum/data_pda_msg(recipient,sender,message)

/obj/machinery/message_server/proc/send_rc_message(recipient = "", sender = "", message = "", stamp = "", id_auth = "", priority = 1)
	rc_msgs += new/datum/data_rc_msg(recipient,sender,message,stamp,id_auth)

/obj/machinery/message_server/attack_hand(mob/user)
//	user << "\blue There seem to be some parts missing from this server. They should arrive on the station in a few days, give or take a few CentCom delays."
	to_chat(user, "You toggle PDA message passing from [active ? "On" : "Off"] to [active ? "Off" : "On"].")
	active = !active
	update_icon()
	return

/obj/machinery/message_server/update_icon()
	if((stat & (BROKEN | NOPOWER)))
		icon_state = "server-nopower"
	else if (!active)
		icon_state = "server-off"
	else
		icon_state = "server-on"
	return


/datum/feedback_variable
	var/variable
	var/value
	var/details

/datum/feedback_variable/New(param_variable, param_value = 0)
	variable = param_variable
	value = param_value

/datum/feedback_variable/proc/inc(num = 1)
	if(isnum(value))
		value += num
	else
		value = text2num(value)
		if(isnum(value))
			value += num
		else
			value = num

/datum/feedback_variable/proc/dec(num = 1)
	if(isnum(value))
		value -= num
	else
		value = text2num(value)
		if(isnum(value))
			value -= num
		else
			value = -num

/datum/feedback_variable/proc/set_value(num)
	if(isnum(num))
		value = num

/datum/feedback_variable/proc/get_value()
	return value

/datum/feedback_variable/proc/get_variable()
	return variable

/datum/feedback_variable/proc/set_details(text)
	if(istext(text))
		details = text

/datum/feedback_variable/proc/add_details(text)
	if(istext(text))
		if(!details)
			details = text
		else
			details += " [text]"

/datum/feedback_variable/proc/get_details()
	return details

/datum/feedback_variable/proc/get_parsed()
	return list(variable, value, details)


/var/obj/machinery/blackbox_recorder/blackbox

/obj/machinery/blackbox_recorder
	icon = 'icons/obj/machines/telecoms.dmi'
	icon_state = "blackbox"
	name = "Blackbox Recorder"
	density = TRUE
	anchored = TRUE

	power_usage = alist(
		USE_POWER_IDLE = 10,
		USE_POWER_ACTIVE = 100
	)

	var/list/messages = list()		//Stores messages of non-standard frequencies
	var/list/messages_admin = list()

	var/list/msg_common = list()
	var/list/msg_science = list()
	var/list/msg_command = list()
	var/list/msg_medical = list()
	var/list/msg_engineering = list()
	var/list/msg_security = list()
	var/list/msg_deathsquad = list()
	var/list/msg_syndicate = list()
	var/list/msg_mining = list()
	var/list/msg_cargo = list()

	var/list/datum/feedback_variable/feedback = new()

//Only one can exsist in the world!
/obj/machinery/blackbox_recorder/initialise()
	. = ..()
	if(blackbox)
		if(istype(blackbox, /obj/machinery/blackbox_recorder))
			qdel(src)
	blackbox = src

/obj/machinery/blackbox_recorder/Destroy()
	var/turf/T = locate(1, 1, 2)
	if(isnotnull(T))
		blackbox = null
		var/obj/machinery/blackbox_recorder/box = new/obj/machinery/blackbox_recorder(T)
		box.msg_common = msg_common
		box.msg_science = msg_science
		box.msg_command = msg_command
		box.msg_medical = msg_medical
		box.msg_engineering = msg_engineering
		box.msg_security = msg_security
		box.msg_deathsquad = msg_deathsquad
		box.msg_syndicate = msg_syndicate
		box.msg_mining = msg_mining
		box.msg_cargo = msg_cargo
		box.feedback = feedback
		box.messages = messages
		box.messages_admin = messages_admin
		if(blackbox != box)
			blackbox = box
	return ..()

/obj/machinery/blackbox_recorder/proc/find_feedback_datum(variable)
	for(var/datum/feedback_variable/FV in feedback)
		if(FV.get_variable() == variable)
			return FV
	var/datum/feedback_variable/FV = new(variable)
	feedback += FV
	return FV

/obj/machinery/blackbox_recorder/proc/get_round_feedback()
	return feedback

/obj/machinery/blackbox_recorder/proc/round_end_data_gathering()
	var/pda_msg_amt = 0
	var/rc_msg_amt = 0

	FOR_MACHINES_TYPED(server, /obj/machinery/message_server)
		if(length(server.pda_msgs) > pda_msg_amt)
			pda_msg_amt = length(server.pda_msgs)
		if(length(server.rc_msgs) > rc_msg_amt)
			rc_msg_amt = length(server.rc_msgs)

	feedback_set_details("radio_usage", "")

	feedback_add_details("radio_usage", "COM-[length(msg_common)]")
	feedback_add_details("radio_usage", "SCI-[length(msg_science)]")
	feedback_add_details("radio_usage", "HEA-[length(msg_command)]")
	feedback_add_details("radio_usage", "MED-[length(msg_medical)]")
	feedback_add_details("radio_usage", "ENG-[length(msg_engineering)]")
	feedback_add_details("radio_usage", "SEC-[length(msg_security)]")
	feedback_add_details("radio_usage", "DTH-[length(msg_deathsquad)]")
	feedback_add_details("radio_usage", "SYN-[length(msg_syndicate)]")
	feedback_add_details("radio_usage", "MIN-[length(msg_mining)]")
	feedback_add_details("radio_usage", "CAR-[length(msg_cargo)]")
	feedback_add_details("radio_usage", "OTH-[length(messages)]")
	feedback_add_details("radio_usage", "PDA-[pda_msg_amt]")
	feedback_add_details("radio_usage", "RC-[rc_msg_amt]")

	feedback_set_details("round_end", "[time2text(world.realtime)]") //This one MUST be the last one that gets set.

//This proc is only to be called at round end.
/obj/machinery/blackbox_recorder/proc/save_all_data_to_sql()
	if(!feedback)
		return

	round_end_data_gathering() //round_end time logging and some other data processing
	establish_db_connection()
	if(!GLOBL.dbcon.IsConnected())
		return
	var/round_id

	var/DBQuery/query = GLOBL.dbcon.NewQuery("SELECT MAX(round_id) AS round_id FROM erro_feedback")
	query.Execute()
	while(query.NextRow())
		round_id = query.item[1]

	if(!isnum(round_id))
		round_id = text2num(round_id)
	round_id++

	for(var/datum/feedback_variable/FV in feedback)
		var/sql = "INSERT INTO erro_feedback VALUES (null, Now(), [round_id], \"[FV.get_variable()]\", [FV.get_value()], \"[FV.get_details()]\")"
		var/DBQuery/query_insert = GLOBL.dbcon.NewQuery(sql)
		query_insert.Execute()


// Sanitize inputs to avoid SQL injection attacks
/proc/sql_sanitize_text(text)
	text = replacetext(text, "'", "''")
	text = replacetext(text, ";", "")
	text = replacetext(text, "&", "")
	return text

/proc/feedback_set(variable, value)
	if(!blackbox)
		return

	variable = sql_sanitize_text(variable)

	var/datum/feedback_variable/FV = blackbox.find_feedback_datum(variable)
	if(!FV)
		return

	FV.set_value(value)

/proc/feedback_inc(variable, value)
	if(!blackbox)
		return

	variable = sql_sanitize_text(variable)

	var/datum/feedback_variable/FV = blackbox.find_feedback_datum(variable)
	if(!FV)
		return

	FV.inc(value)

/proc/feedback_dec(variable, value)
	if(!blackbox)
		return

	variable = sql_sanitize_text(variable)

	var/datum/feedback_variable/FV = blackbox.find_feedback_datum(variable)
	if(!FV)
		return

	FV.dec(value)

/proc/feedback_set_details(variable, details)
	if(!blackbox)
		return

	variable = sql_sanitize_text(variable)
	details = sql_sanitize_text(details)

	var/datum/feedback_variable/FV = blackbox.find_feedback_datum(variable)
	if(!FV)
		return

	FV.set_details(details)

/proc/feedback_add_details(variable, details)
	if(!blackbox)
		return

	variable = sql_sanitize_text(variable)
	details = sql_sanitize_text(details)

	var/datum/feedback_variable/FV = blackbox.find_feedback_datum(variable)
	if(!FV)
		return

	FV.add_details(details)