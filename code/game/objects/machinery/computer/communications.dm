//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
GLOBAL_GLOBL_LIST_NEW(obj/machinery/computer/communications/communications_consoles)

#define STATE_DEFAULT 1
#define STATE_CALLSHUTTLE 2
#define STATE_CANCELSHUTTLE 3
#define STATE_MESSAGELIST 4
#define STATE_VIEWMESSAGE 5
#define STATE_DELMESSAGE 6
#define STATE_STATUSDISPLAY 7
#define STATE_ALERT_LEVEL 8
#define STATE_CONFIRM_LEVEL 9
#define STATE_CREWTRANSFER 10

#define AUTH_NONE 0
#define AUTH_PARTIAL 1
#define AUTH_FULL 2

// The communications computer
/obj/machinery/computer/communications
	name = "communications console"
	desc = "This can be used for various important functions. Still under developement."
	icon_state = "comm"
	req_access = list(ACCESS_BRIDGE)
	circuit = /obj/item/circuitboard/communications

	light_color = "#0099ff"

	var/prints_intercept = TRUE
	var/authenticated = AUTH_NONE
	var/list/messagetitle = list()
	var/list/messagetext = list()
	var/currmsg = 0
	var/aicurrmsg = 0
	var/state = STATE_DEFAULT
	var/aistate = STATE_DEFAULT
	var/message_cooldown = FALSE
	var/centcom_message_cooldown = FALSE

	var/tmp/decl/security_level/temp_alert_level = null // The typepath of the security level we're trying to set the station to, if applicable.

	var/status_display_freq = 1435
	var/stat_msg1
	var/stat_msg2

/obj/machinery/computer/communications/New()
	. = ..()
	GLOBL.communications_consoles.Add(src)

/obj/machinery/computer/communications/Destroy()
	GLOBL.communications_consoles.Remove(src)
	return ..()

/obj/machinery/computer/communications/process()
	if(..())
		if(state != STATE_STATUSDISPLAY)
			src.updateDialog()

/obj/machinery/computer/communications/Topic(href, href_list)
	if(..())
		return
	if(src.z > 1)
		to_chat(usr, "\red <b>Unable to establish a connection</b>: \black You're too far away from the station!")
		return
	usr.set_machine(src)

	if(!href_list["operation"])
		return
	switch(href_list["operation"])
		// main interface
		if("main")
			src.state = STATE_DEFAULT
		if("login")
			var/mob/M = usr
			var/obj/item/card/id/I = M.get_active_hand()
			if(istype(I, /obj/item/pda))
				var/obj/item/pda/pda = I
				I = pda.id
			if(I && istype(I))
				if(src.check_access(I))
					authenticated = AUTH_PARTIAL
				if(ACCESS_CAPTAIN in I.access)
					authenticated = AUTH_FULL
		if("logout")
			authenticated = AUTH_NONE

		if("swipeidseclevel")
			var/mob/M = usr
			var/obj/item/card/id/I = M.get_active_hand()
			if(istype(I, /obj/item/pda))
				var/obj/item/pda/pda = I
				I = pda.id
			if(I && istype(I))
				if((ACCESS_CAPTAIN in I.access) || (ACCESS_BRIDGE in I.access)) //Let heads change the alert level.
					var/decl/security_level/old_level = GLOBL.security_level
					if(temp_alert_level == /decl/security_level/red || temp_alert_level == /decl/security_level/delta)
						temp_alert_level = /decl/security_level/blue // Cannot engage red or delta with this.
					set_security_level(temp_alert_level)
					if(GLOBL.security_level != old_level.type)
						// Only notify the admins if an actual change happened.
						log_game("[key_name(usr)] has changed the security level to [GLOBL.security_level.name].")
						message_admins("[key_name_admin(usr)] has changed the security level to [GLOBL.security_level.name].")
						feedback_inc("alert_comms_[GLOBL.security_level.name]", 1)
					temp_alert_level = null
				else
					to_chat(usr, "You are not authorized to do this.")
					temp_alert_level = null
				state = STATE_DEFAULT
			else
				to_chat(usr, "You need to swipe your ID.")

		if("announce")
			if(src.authenticated == AUTH_FULL)
				if(message_cooldown)
					return
				var/input = stripped_input(usr, "Please choose a message to announce to the station crew.", "What?")
				if(!input || !(usr in view(1, src)))
					return
				captain_announce(input)//This should really tell who is, IE HoP, CE, HoS, RD, Captain
				log_say("[key_name(usr)] has made a captain announcement: [input]")
				message_admins("[key_name_admin(usr)] has made a captain announcement.", 1)
				message_cooldown = TRUE
				spawn(1 MINUTE)//One minute cooldown
					message_cooldown = FALSE

		if("callshuttle")
			src.state = STATE_DEFAULT
			if(src.authenticated)
				src.state = STATE_CALLSHUTTLE
		if("callshuttle2")
			if(src.authenticated)
				call_shuttle_proc(usr)
			src.state = STATE_DEFAULT
		if("crewtransfer")
			src.state = STATE_DEFAULT
			if(src.authenticated)
				src.state = STATE_CREWTRANSFER
		if("crewtransfer2")
			if(src.authenticated)
				init_shift_change(usr)
		if("cancelshuttle")
			src.state = STATE_DEFAULT
			if(src.authenticated)
				src.state = STATE_CANCELSHUTTLE
		if("cancelshuttle2")
			if(src.authenticated)
				cancel_call_proc(usr)
			src.state = STATE_DEFAULT
		if("messagelist")
			src.currmsg = 0
			src.state = STATE_MESSAGELIST
		if("viewmessage")
			src.state = STATE_VIEWMESSAGE
			if(!src.currmsg)
				if(href_list["message-num"])
					src.currmsg = text2num(href_list["message-num"])
				else
					src.state = STATE_MESSAGELIST
		if("delmessage")
			src.state = src.currmsg ? STATE_DELMESSAGE : STATE_MESSAGELIST
		if("delmessage2")
			if(src.authenticated)
				if(src.currmsg)
					var/title = src.messagetitle[src.currmsg]
					var/text = src.messagetext[src.currmsg]
					src.messagetitle.Remove(title)
					src.messagetext.Remove(text)
					if(src.currmsg == src.aicurrmsg)
						src.aicurrmsg = 0
					src.currmsg = 0
				src.state = STATE_MESSAGELIST
			else
				src.state = STATE_VIEWMESSAGE
		if("status")
			src.state = STATE_STATUSDISPLAY

		// Status display stuff
		if("setstat")
			switch(href_list["statdisp"])
				if("message")
					post_status("message", stat_msg1, stat_msg2)
				if("alert")
					post_status("alert", href_list["alert"])
				else
					post_status(href_list["statdisp"])

		if("setmsg1")
			stat_msg1 = input("Line 1", "Enter Message Text", stat_msg1) as text|null
			src.updateDialog()
		if("setmsg2")
			stat_msg2 = input("Line 2", "Enter Message Text", stat_msg2) as text|null
			src.updateDialog()

		// OMG CENTCOM LETTERHEAD
		if("MessageCentCom")
			if(src.authenticated == AUTH_FULL)
				if(centcom_message_cooldown)
					to_chat(usr, SPAN_WARNING("Arrays recycling. Please stand by."))
					return
				var/input = stripped_input(usr, "Please choose a message to transmit to CentCom via quantum entanglement. Please be aware that this process is very expensive, and abuse will lead to... termination. Transmission does not guarantee a response. There is a 30 second delay before you may send another message, be clear, full and concise.", "To abort, send an empty message.", "")
				if(!input || !(usr in view(1, src)))
					return
				centcom_announce(input, usr)
				to_chat(usr, SPAN_INFO("Message transmitted."))
				log_say("[key_name(usr)] has made an IA CentCom announcement: [input]")
				centcom_message_cooldown = TRUE
				spawn(10 MINUTES) //10 minute cooldown
					centcom_message_cooldown = FALSE

		// OMG SYNDICATE ...LETTERHEAD
		if("MessageSyndicate")
			if(src.authenticated == AUTH_FULL && src.emagged)
				if(centcom_message_cooldown)
					to_chat(usr, SPAN_WARNING("Arrays recycling. Please stand by."))
					return
				var/input = stripped_input(usr, "Please choose a message to transmit to \[ABNORMAL ROUTING CORDINATES\] via quantum entanglement. Please be aware that this process is very expensive, and abuse will lead to... termination. Transmission does not guarantee a response. There is a 30 second delay before you may send another message, be clear, full and concise.", "To abort, send an empty message.", "")
				if(!input || !(usr in view(1, src)))
					return
				Syndicate_announce(input, usr)
				to_chat(usr, SPAN_INFO("Message transmitted."))
				log_say("[key_name(usr)] has made a Syndicate announcement: [input]")
				centcom_message_cooldown = TRUE
				spawn(10 MINUTES)//10 minute cooldown
					centcom_message_cooldown = FALSE

		if("RestoreBackup")
			to_chat(usr, "Backup routing data restored!")
			src.emagged = TRUE
			src.updateDialog()

		// AI interface
		if("ai-main")
			src.aicurrmsg = 0
			src.aistate = STATE_DEFAULT
		if("ai-callshuttle")
			src.aistate = STATE_CALLSHUTTLE
		if("ai-callshuttle2")
			call_shuttle_proc(usr)
			src.aistate = STATE_DEFAULT
		if("ai-crewtransfer")
			src.aistate = STATE_CREWTRANSFER
		if("ai-crewtransfer2")
			init_shift_change(usr)
		if("ai-messagelist")
			src.aicurrmsg = 0
			src.aistate = STATE_MESSAGELIST
		if("ai-viewmessage")
			src.aistate = STATE_VIEWMESSAGE
			if(!src.aicurrmsg)
				if(href_list["message-num"])
					src.aicurrmsg = text2num(href_list["message-num"])
				else
					src.aistate = STATE_MESSAGELIST
		if("ai-delmessage")
			src.aistate = src.aicurrmsg ? STATE_DELMESSAGE : STATE_MESSAGELIST
		if("ai-delmessage2")
			if(src.aicurrmsg)
				var/title = src.messagetitle[src.aicurrmsg]
				var/text = src.messagetext[src.aicurrmsg]
				src.messagetitle.Remove(title)
				src.messagetext.Remove(text)
				if(src.currmsg == src.aicurrmsg)
					src.currmsg = 0
				src.aicurrmsg = 0
			src.aistate = STATE_MESSAGELIST
		if("ai-status")
			src.aistate = STATE_STATUSDISPLAY

		if("securitylevel")
			temp_alert_level = text2path(href_list["newalertlevel"])
			state = STATE_CONFIRM_LEVEL

		if("changeseclevel")
			state = STATE_ALERT_LEVEL

	src.updateUsrDialog()

/obj/machinery/computer/communications/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(stat & (BROKEN | NOPOWER))
		FEEDBACK_MACHINE_UNRESPONSIVE(user)
		return FALSE

	if(emagged)
		FEEDBACK_ALREADY_EMAGGED(user)
		return FALSE
	to_chat(user, SPAN_WARNING("You scramble the communication routing circuits!"))
	emagged = TRUE
	return TRUE

/obj/machinery/computer/communications/attack_ai(mob/user)
	return src.attack_hand(user)

/obj/machinery/computer/communications/attack_paw(mob/user)
	return src.attack_hand(user)

/obj/machinery/computer/communications/attack_hand(mob/user)
	if(..())
		return
	if(src.z > 6)
		to_chat(user, "\red <b>Unable to establish a connection</b>: \black You're too far away from the station!")
		return

	user.set_machine(src)
	var/dat = "<head><title>Communications Console</title></head><body>"
	if(global.PCemergency.online() && !global.PCemergency.location())
		var/timeleft = global.PCemergency.estimate_arrival_time()
		dat += "<B>Emergency shuttle</B>\n<BR>\nETA: [timeleft / 60 % 60]:[add_zero(num2text(timeleft % 60), 2)]<BR>"

	if(issilicon(user))
		var/dat2 = src.interact_ai(user) // give the AI a different interact proc to limit its access
		if(dat2)
			dat += dat2
			user << browse(dat, "window=communications;size=400x500")
			onclose(user, "communications")
		return

	switch(src.state)
		if(STATE_DEFAULT)
			if(src.authenticated)
				dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=logout'>Log Out</A> \]"
				if(src.authenticated == AUTH_FULL)
					dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=announce'>Make An Announcement</A> \]"
					if(!src.emagged)
						dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=MessageCentCom'>Send an emergency message to CentCom</A> \]"
					else
						dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=MessageSyndicate'>Send an emergency message to \[UNKNOWN\]</A> \]"
						dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=RestoreBackup'>Restore Backup Routing Data</A> \]"

				dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=changeseclevel'>Change alert level</A> \]"
				if(!global.PCemergency.location())
					if(global.PCemergency.online())
						dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=cancelshuttle'>Cancel Shuttle Call</A> \]"
					else
						dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=callshuttle'>Call Emergency Shuttle</A> \]"
						dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=crewtransfer'>Initiate Crew Transfer</A> \]"
				dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=status'>Set Status Display</A> \]"
			else
				dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=login'>Log In</A> \]"
			dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=messagelist'>Message List</A> \]"
		if(STATE_CALLSHUTTLE)
			dat += "Are you sure you want to call the shuttle? \[ <A href='byond://?src=\ref[src];operation=callshuttle2'>OK</A> | <A href='byond://?src=\ref[src];operation=main'>Cancel</A> \]"
		if(STATE_CANCELSHUTTLE)
			dat += "Are you sure you want to cancel the shuttle? \[ <A href='byond://?src=\ref[src];operation=cancelshuttle2'>OK</A> | <A href='byond://?src=\ref[src];operation=main'>Cancel</A> \]"
		if(STATE_CREWTRANSFER)
			dat += "Are you sure you want to call the shuttle? \[ <A href='byond://?src=\ref[src];operation=crewtransfer2'>OK</A> | <A href='byond://?src=\ref[src];operation=main'>Cancel</A> \]"
		if(STATE_MESSAGELIST)
			dat += "Messages:"
			for(var/i = 1; i <= length(messagetitle); i++)
				dat += "<BR><A href='byond://?src=\ref[src];operation=viewmessage;message-num=[i]'>[src.messagetitle[i]]</A>"
		if(STATE_VIEWMESSAGE)
			if(src.currmsg)
				dat += "<B>[src.messagetitle[src.currmsg]]</B><BR><BR>[src.messagetext[src.currmsg]]"
				if(src.authenticated)
					dat += "<BR><BR>\[ <A href='byond://?src=\ref[src];operation=delmessage'>Delete \]"
			else
				src.state = STATE_MESSAGELIST
				src.attack_hand(user)
				return
		if(STATE_DELMESSAGE)
			if(src.currmsg)
				dat += "Are you sure you want to delete this message? \[ <A href='byond://?src=\ref[src];operation=delmessage2'>OK</A> | <A href='byond://?src=\ref[src];operation=viewmessage'>Cancel</A> \]"
			else
				src.state = STATE_MESSAGELIST
				src.attack_hand(user)
				return
		if(STATE_STATUSDISPLAY)
			dat += "Set Status Displays<BR>"
			dat += "\[ <A href='byond://?src=\ref[src];operation=setstat;statdisp=blank'>Clear</A> \]<BR>"
			dat += "\[ <A href='byond://?src=\ref[src];operation=setstat;statdisp=shuttle'>Shuttle ETA</A> \]<BR>"
			dat += "\[ <A href='byond://?src=\ref[src];operation=setstat;statdisp=message'>Message</A> \]"
			dat += "<ul><li> Line 1: <A href='byond://?src=\ref[src];operation=setmsg1'>[stat_msg1 ? stat_msg1 : "(none)"]</A>"
			dat += "<li> Line 2: <A href='byond://?src=\ref[src];operation=setmsg2'>[stat_msg2 ? stat_msg2 : "(none)"]</A></ul><br>"
			dat += "\[ Alert: <A href='byond://?src=\ref[src];operation=setstat;statdisp=alert;alert=default'>None</A> |"
			dat += " <A href='byond://?src=\ref[src];operation=setstat;statdisp=alert;alert=yellowalert'>Yellow Alert</A> |" // Add option to manually set yellow alert status. -Frenjo
			dat += " <A href='byond://?src=\ref[src];operation=setstat;statdisp=alert;alert=bluealert'>Blue Alert</A> |" // Add option to manually set blue alert status. -Frenjo
			dat += " <A href='byond://?src=\ref[src];operation=setstat;statdisp=alert;alert=redalert'>Red Alert</A> |"
			dat += " <A href='byond://?src=\ref[src];operation=setstat;statdisp=alert;alert=evacalert'>Evacuation Alert</A> |" // Add option to manually set evacuation alert status. -Frenjo
			dat += " <A href='byond://?src=\ref[src];operation=setstat;statdisp=alert;alert=lockdown'>Lockdown</A> |"
			dat += " <A href='byond://?src=\ref[src];operation=setstat;statdisp=alert;alert=biohazard'>Biohazard</A> |"
		if(STATE_ALERT_LEVEL)
			dat += "Current alert level: [GLOBL.security_level.name]<BR>"
			if(IS_SEC_LEVEL(/decl/security_level/delta))
				dat += "<font color='red'><b>The self-destruct mechanism is active. Find a way to deactivate the mechanism to lower the alert level or evacuate.</b></font>"
			else
				dat += "<A href='byond://?src=\ref[src];operation=securitylevel;newalertlevel=[/decl/security_level/blue]'>Blue</A><BR>"
				dat += "<A href='byond://?src=\ref[src];operation=securitylevel;newalertlevel=[/decl/security_level/yellow]'>Yellow</A><BR>"
				dat += "<A href='byond://?src=\ref[src];operation=securitylevel;newalertlevel=[/decl/security_level/green]'>Green</A>"
		if(STATE_CONFIRM_LEVEL)
			dat += "Current alert level: [GLOBL.security_level.name]<BR>"
			dat += "Confirm the change to: [GLOBL.security_level.name]<BR>"
			dat += "<A href='byond://?src=\ref[src];operation=swipeidseclevel'>Swipe ID</A> to confirm change.<BR>"

	dat += "<BR>\[ [(src.state != STATE_DEFAULT) ? "<A href='byond://?src=\ref[src];operation=main'>Main Menu</A> | " : ""]<A href='byond://?src=\ref[user];mach_close=communications'>Close</A> \]"
	user << browse(dat, "window=communications;size=400x500")
	onclose(user, "communications")

/obj/machinery/computer/communications/proc/interact_ai(mob/living/silicon/ai/user)
	var/dat = ""
	switch(src.aistate)
		if(STATE_DEFAULT)
			if(global.PCemergency.location() && !global.PCemergency.online())
				dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=ai-callshuttle'>Call Emergency Shuttle</A> \]"
				dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=ai-crewtransfer'>Initiate Crew Transfer</A> \]"
			dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=ai-messagelist'>Message List</A> \]"
			dat += "<BR>\[ <A href='byond://?src=\ref[src];operation=ai-status'>Set Status Display</A> \]"
		if(STATE_CALLSHUTTLE)
			dat += "Are you sure you want to call the shuttle? \[ <A href='byond://?src=\ref[src];operation=ai-callshuttle2'>OK</A> | <A href='byond://?src=\ref[src];operation=ai-main'>Cancel</A> \]"
		if(STATE_CREWTRANSFER)
			dat += "Are you sure you want to call the shuttle? \[ <A href='byond://?src=\ref[src];operation=ai-crewtransfer2'>OK</A> | <A href='byond://?src=\ref[src];operation=main'>Cancel</A> \]"
		if(STATE_MESSAGELIST)
			dat += "Messages:"
			for(var/i = 1; i <= length(messagetitle); i++)
				dat += "<BR><A href='byond://?src=\ref[src];operation=ai-viewmessage;message-num=[i]'>[src.messagetitle[i]]</A>"
		if(STATE_VIEWMESSAGE)
			if(src.aicurrmsg)
				dat += "<B>[src.messagetitle[src.aicurrmsg]]</B><BR><BR>[src.messagetext[src.aicurrmsg]]"
				dat += "<BR><BR>\[ <A href='byond://?src=\ref[src];operation=ai-delmessage'>Delete</A> \]"
			else
				src.aistate = STATE_MESSAGELIST
				src.attack_hand(user)
				return null
		if(STATE_DELMESSAGE)
			if(src.aicurrmsg)
				dat += "Are you sure you want to delete this message? \[ <A href='byond://?src=\ref[src];operation=ai-delmessage2'>OK</A> | <A href='byond://?src=\ref[src];operation=ai-viewmessage'>Cancel</A> \]"
			else
				src.aistate = STATE_MESSAGELIST
				src.attack_hand(user)
				return

		if(STATE_STATUSDISPLAY)
			dat += "Set Status Displays<BR>"
			dat += "\[ <A href='byond://?src=\ref[src];operation=setstat;statdisp=blank'>Clear</A> \]<BR>"
			dat += "\[ <A href='byond://?src=\ref[src];operation=setstat;statdisp=shuttle'>Shuttle ETA</A> \]<BR>"
			dat += "\[ <A href='byond://?src=\ref[src];operation=setstat;statdisp=message'>Message</A> \]"
			dat += "<ul><li> Line 1: <A href='byond://?src=\ref[src];operation=setmsg1'>[stat_msg1 ? stat_msg1 : "(none)"]</A>"
			dat += "<li> Line 2: <A href='byond://?src=\ref[src];operation=setmsg2'>[stat_msg2 ? stat_msg2 : "(none)"]</A></ul><br>"
			dat += "\[ Alert: <A href='byond://?src=\ref[src];operation=setstat;statdisp=alert;alert=default'>None</A> |"
			dat += " <A href='byond://?src=\ref[src];operation=setstat;statdisp=alert;alert=yellowalert'>Yellow Alert</A> |" // Add option to manually set yellow alert status. -Frenjo
			dat += " <A href='byond://?src=\ref[src];operation=setstat;statdisp=alert;alert=bluealert'>Blue Alert</A> |" // Add option to manually set blue alert status. -Frenjo
			dat += " <A href='byond://?src=\ref[src];operation=setstat;statdisp=alert;alert=redalert'>Red Alert</A> |"
			dat += " <A href='byond://?src=\ref[src];operation=setstat;statdisp=alert;alert=evacalert'>Evacuation Alert</A> |" // Add option to manually set evacuation alert status. -Frenjo
			dat += " <A href='byond://?src=\ref[src];operation=setstat;statdisp=alert;alert=lockdown'>Lockdown</A> |"
			dat += " <A href='byond://?src=\ref[src];operation=setstat;statdisp=alert;alert=biohazard'>Biohazard</A> |"

	dat += "<BR>\[ [src.aistate != STATE_DEFAULT ? "<A href='byond://?src=\ref[src];operation=ai-main'>Main Menu</A> | " : ""]<A href='byond://?src=\ref[user];mach_close=communications'>Close</A> \]"
	return dat

/*
/proc/enable_prison_shuttle(var/mob/user)
	for(var/obj/machinery/computer/prison_shuttle/PS in GLOBL.machines)
		PS.allowedtocall = !(PS.allowedtocall)
*/

/proc/call_shuttle_proc(mob/user)
	if(!global.PCticker || !global.PCemergency.location())
		return

	if(GLOBL.sent_strike_team)
		to_chat(user, "CentCom will not allow the shuttle to be called. Consider all contracts terminated.")
		return

	if(world.time < 6000) // Ten minute grace period to let the game get going without lolmetagaming. -- TLE
		to_chat(user, "The emergency shuttle is refueling. Please wait another [round((6000 - world.time) / 600)] minutes before trying again.")
		return

	if(global.PCemergency.going_to_centcom())
		to_chat(user, "The emergency shuttle may not be called while returning to CentCom.")
		return

	if(global.PCemergency.online())
		to_chat(user, "The emergency shuttle is already on its way.")
		return

	if(global.PCticker.mode.name == "blob")
		to_chat(user, "Under directive 7-10, [station_name()] is quarantined until further notice.")
		return

	global.PCemergency.call_evac()
	log_game("[key_name(user)] has called the shuttle.")
	message_admins("[key_name_admin(user)] has called the shuttle.", 1)

	return

/proc/init_shift_change(mob/user, force = 0)
	if(!global.PCticker || !global.PCemergency.location())
		return

	if(global.PCemergency.going_to_centcom())
		to_chat(user, "The shuttle may not be called while returning to CentCom.")
		return

	if(global.PCemergency.online())
		to_chat(user, "The shuttle is already on its way.")
		return

	// if force is 0, some things may stop the shuttle call
	if(!force)
		if(global.PCemergency.deny_shuttle)
			to_chat(user, "CentCom does not currently have a shuttle available in your sector. Please try again later.")
			return

		if(GLOBL.sent_strike_team)
			to_chat(user, "CentCom will not allow the shuttle to be called. Consider all contracts terminated.")
			return

		if(world.time < 135000) // cant call the transfer until 15:45
			to_chat(user, "It is not crew transfer time. [round((135000 - world.time) / 600)] minutes before trying again.") //may need to change "/600"
			return

		if(IS_GAME_MODE(/datum/game_mode/revolution) || IS_GAME_MODE(/datum/game_mode/malfunction) || global.PCticker.mode.name == "sandbox")
			// New version pretends to call the shuttle but cause the shuttle to return after a random duration.
			global.PCemergency.auto_recall = TRUE

		if(global.PCticker.mode.name == "blob" || global.PCticker.mode.name == "epidemic")
			to_chat(user, "Under directive 7-10, [station_name()] is quarantined until further notice.")
			return

	global.PCemergency.call_transfer()
	log_game("[key_name(user)] has called the shuttle.")
	message_admins("[key_name_admin(user)] has called the shuttle.", 1)
	captain_announce("A crew transfer has been initiated. The shuttle has been called. It will arrive in [round(global.PCemergency.estimate_arrival_time() / 60)] minutes.")
	world << sound('sound/AI/crewtransfer2.ogg')

	return

/proc/cancel_call_proc(mob/user)
	if(!global.PCticker || !global.PCemergency.can_recall())
		return
	if(global.PCticker.mode.name == "blob" || global.PCticker.mode.name == "meteor")
		return

	if(!global.PCemergency.going_to_centcom() && global.PCemergency.online()) //check that shuttle isn't already heading to centcom
		global.PCemergency.recall()
		log_game("[key_name(user)] has recalled the shuttle.")
		message_admins("[key_name_admin(user)] has recalled the shuttle.", 1)
	return

/obj/machinery/computer/communications/proc/post_status(command, data1, data2)
	var/datum/radio_frequency/frequency = global.CTradio.return_frequency(status_display_freq)
	if(isnull(frequency))
		return

	var/datum/signal/status_signal = new /datum/signal()
	status_signal.source = src
	status_signal.transmission_method = TRANSMISSION_RADIO
	status_signal.data["command"] = command

	switch(command)
		if("message")
			status_signal.data["msg1"] = data1
			status_signal.data["msg2"] = data2
			log_admin("STATUS: [src.last_fingerprints] set status screen message with [src]: [data1] [data2]")
			//message_admins("STATUS: [user] set status screen with [PDA]. Message: [data1] [data2]")
		if("alert")
			status_signal.data["picture_state"] = data1
		if("ai_emotion")
			status_signal.data["emotion"] = data1

	frequency.post_signal(src, status_signal)

/obj/machinery/computer/communications/Destroy()
	for_no_type_check(var/obj/machinery/computer/communications/commconsole, GLOBL.communications_consoles)
		if(isturf(commconsole.loc) && commconsole != src)
			return ..()

	for(var/obj/item/circuitboard/communications/commboard in GLOBL.movable_atom_list)
		if(isturf(commboard.loc) || istype(commboard.loc, /obj/item/storage))
			return ..()

	for(var/mob/living/silicon/ai/shuttlecaller in GLOBL.player_list)
		if(!shuttlecaller.stat && shuttlecaller.client && isturf(shuttlecaller.loc))
			return ..()

	if(IS_GAME_MODE(/datum/game_mode/revolution) || IS_GAME_MODE(/datum/game_mode/malfunction) || GLOBL.sent_strike_team)
		return ..()

	global.PCemergency.call_evac()
	log_game("All the AIs, comm consoles and boards are destroyed. Shuttle called.")
	message_admins("All the AIs, comm consoles and boards are destroyed. Shuttle called.", 1)

	return ..()

#undef AUTH_NONE
#undef AUTH_PARTIAL
#undef AUTH_FULL

#undef STATE_DEFAULT
#undef STATE_CALLSHUTTLE
#undef STATE_CANCELSHUTTLE
#undef STATE_MESSAGELIST
#undef STATE_VIEWMESSAGE
#undef STATE_DELMESSAGE
#undef STATE_STATUSDISPLAY
#undef STATE_ALERT_LEVEL
#undef STATE_CONFIRM_LEVEL
#undef STATE_CREWTRANSFER