//This is a list of words which are ignored by the parser when comparing message contents for names. MUST BE IN LOWER CASE!
GLOBAL_GLOBL_LIST_INIT(adminhelp_ignored_words, list("unknown", "the", "a", "an", "of", "monkey", "alien", "as"))

/client/verb/adminhelp(msg as text)
	set category = PANEL_ADMIN
	set name = "Adminhelp"

	if(say_disabled)
		FEEDBACK_SPEECH_ADMIN_DISABLED(usr) // This is here to try to identify lag problems.
		return

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, "<font color='red'>Error: Admin-PM: You cannot send adminhelps (Muted).</font>")
		return
	if(src.handle_spam_prevention(msg, MUTE_ADMINHELP))
		return

	/**src.verbs -= /client/verb/adminhelp

	spawn(1200)
		src.verbs += /client/verb/adminhelp	// 2 minute cool-down for adminhelps
		src.verbs += /client/verb/adminhelp	// 2 minute cool-down for adminhelps//Go to hell
	**/

	//clean the input msg
	if(!msg)
		return
	msg = sanitize(copytext(msg, 1, MAX_MESSAGE_LEN))
	if(!msg)
		return
	var/original_msg = msg

	//explode the input msg into a list
	var/list/msglist = splittext(msg, " ")

	//generate keywords lookup
	var/list/surnames = list()
	var/list/forenames = list()
	var/list/ckeys = list()
	for(var/mob/M in GLOBL.mob_list)
		var/list/indexing = list(M.real_name, M.name)
		if(M.mind)
			indexing += M.mind.name

		for(var/string in indexing)
			var/list/L = splittext(string, " ")
			var/surname_found = 0
			//surnames
			for(var/i = length(L), i >= 1, i--)
				var/word = ckey(L[i])
				if(word)
					surnames[word] = M
					surname_found = i
					break
			//forenames
			for(var/i = 1, i < surname_found, i++)
				var/word = ckey(L[i])
				if(word)
					forenames[word] = M
			//ckeys
			ckeys[M.ckey] = M

	var/ai_found = 0
	msg = ""
	var/list/mobs_found = list()
	for(var/original_word in msglist)
		var/word = ckey(original_word)
		if(word)
			if(!(word in GLOBL.adminhelp_ignored_words))
				if(word == "ai")
					ai_found = 1
				else
					var/mob/found = ckeys[word]
					if(!found)
						found = surnames[word]
						if(!found)
							found = forenames[word]
					if(found)
						if(!(found in mobs_found))
							mobs_found += found
							if(!ai_found && isAI(found))
								ai_found = 1
							msg += "<b><font color='black'>[original_word] (<A href='byond://?_src_=holder;adminmoreinfo=\ref[found]'>?</A>)</font></b> "
							continue
			msg += "[original_word] "

	if(!mob)
		return						//this doesn't happen

	var/ref_mob = "\ref[mob]"
	msg = "\blue <b><font color=red>HELP: </font>[key_name(src, 1)] (<A href='byond://?_src_=holder;adminmoreinfo=[ref_mob]'>?</A>) (<A href='byond://?_src_=holder;adminplayeropts=[ref_mob]'>PP</A>) (<A href='byond://?_src_=vars;Vars=[ref_mob]'>VV</A>) (<A href='byond://?_src_=holder;subtlemessage=[ref_mob]'>SM</A>) (<A href='byond://?_src_=holder;adminplayerobservejump=[ref_mob]'>JMP</A>) (<A href='byond://?_src_=holder;check_antagonist=1'>CA</A>) [ai_found ? " (<A href='byond://?_src_=holder;adminchecklaws=[ref_mob]'>CL</A>)" : ""]:</b> [msg]"

	//send this msg to all admins
	var/admin_number_afk = 0
	for_no_type_check(var/client/X, GLOBL.admins)
		if((R_ADMIN|R_MOD) & X.holder.rights)
			if(X.is_afk())
				admin_number_afk++
			if(X.prefs.toggles & SOUND_ADMINHELP)
				X << 'sound/effects/adminhelp.ogg'
			to_chat(X, msg)

	//show it to the person adminhelping too
	to_chat(src, "<font color='blue'>PM to-<b>Admins</b>: [original_msg]</font>")

	var/admin_number_present = length(GLOBL.admins) - admin_number_afk
	log_admin("HELP: [key_name(src)]: [original_msg] - heard by [admin_number_present] non-AFK admins.")
	if(admin_number_present <= 0)
		if(!admin_number_afk)
			send2adminirc("ADMINHELP from [key_name(src)]: [html_decode(original_msg)] - !!No admins online!!")
		else
			send2adminirc("ADMINHELP from [key_name(src)]: [html_decode(original_msg)] - !!All admins AFK ([admin_number_afk])!!")
	else
		send2adminirc("ADMINHELP from [key_name(src)]: [html_decode(original_msg)]")
	feedback_add_details("admin_verb", "AH") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return