/mob/verb/pray(msg as text)
	set category = null
	set name = "pray"

	if(say_disabled)
		FEEDBACK_SPEECH_ADMIN_DISABLED(usr) // This is here to try to identify lag problems.
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)	return

	if(usr.client)
		if(usr.client.prefs.muted & MUTE_PRAY)
			usr << "\red You cannot pray (muted)."
			return
		if(src.client.handle_spam_prevention(msg,MUTE_PRAY))
			return

	var/image/cross = image('icons/obj/storage/bible.dmi',"bible")
	msg = "\blue \icon[cross] <b><font color=purple>PRAY: </font>[key_name(src, 1)] (<A href='byond://?_src_=holder;adminmoreinfo=\ref[src]'>?</A>) (<A href='byond://?_src_=holder;adminplayeropts=\ref[src]'>PP</A>) (<A href='byond://?_src_=vars;Vars=\ref[src]'>VV</A>) (<A href='byond://?_src_=holder;subtlemessage=\ref[src]'>SM</A>) (<A href='byond://?_src_=holder;adminplayerobservejump=\ref[src]'>JMP</A>) (<A href='byond://?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<A href='byond://?_src_=holder;adminspawncookie=\ref[src]'>SC</a>):</b> [msg]"

	for_no_type_check(var/client/C, GLOBL.admins)
		if(C.prefs.toggles & CHAT_PRAYER)
			C << msg
	usr << "Your prayers have been received by the gods."

	feedback_add_details("admin_verb","PR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	//log_admin("HELP: [key_name(src)]: [msg]")

/proc/centcom_announce(var/text , var/mob/Sender , var/iamessage)
	var/msg = copytext(sanitize(text), 1, MAX_MESSAGE_LEN)
	msg = "\blue <b><font color=orange>CENTCOM[iamessage ? " IA" : ""]:</font>[key_name(Sender, 1)] (<A href='byond://?_src_=holder;adminplayeropts=\ref[Sender]'>PP</A>) (<A href='byond://?_src_=vars;Vars=\ref[Sender]'>VV</A>) (<A href='byond://?_src_=holder;subtlemessage=\ref[Sender]'>SM</A>) (<A href='byond://?_src_=holder;adminplayerobservejump=\ref[Sender]'>JMP</A>) (<A href='byond://?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<A href='byond://?_src_=holder;BlueSpaceArtillery=\ref[Sender]'>BSA</A>) (<A href='byond://?_src_=holder;CentComReply=\ref[Sender]'>RPLY</A>):</b> [msg]"
	GLOBL.admins << msg

/proc/Syndicate_announce(var/text , var/mob/Sender)
	var/msg = copytext(sanitize(text), 1, MAX_MESSAGE_LEN)
	msg = "\blue <b><font color=crimson>SYNDICATE:</font>[key_name(Sender, 1)] (<A href='byond://?_src_=holder;adminplayeropts=\ref[Sender]'>PP</A>) (<A href='byond://?_src_=vars;Vars=\ref[Sender]'>VV</A>) (<A href='byond://?_src_=holder;subtlemessage=\ref[Sender]'>SM</A>) (<A href='byond://?_src_=holder;adminplayerobservejump=\ref[Sender]'>JMP</A>) (<A href='byond://?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<A href='byond://?_src_=holder;BlueSpaceArtillery=\ref[Sender]'>BSA</A>) (<A href='byond://?_src_=holder;SyndicateReply=\ref[Sender]'>RPLY</A>):</b> [msg]"
	GLOBL.admins << msg
