/client/proc/cmd_admin_say(msg as text)
	set category = PANEL_SPECIAL_VERBS
	set name = "Asay" //Gave this shit a shorter name so you only have to time out "asay" rather than "admin say" to use it --NeoFite
	set hidden = 1

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return

	log_admin("[key_name(src)] : [msg]")

	msg = "<span class='admin'><EM>[key_name(usr, 1)]</EM> (<a href='byond://?_src_=holder;adminplayerobservejump=\ref[mob]'>JMP</A>): <span class='message'>[msg]</span></span>"
	for_no_type_check(var/client/C, GLOBL.admins)
		if(check_rights(R_ADMIN | R_MOD))
			var/chat_tag = create_chat_tag_icon("admin", C)
			to_chat(C, "[chat_tag] [msg]")

	feedback_add_details("admin_verb", "M") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_mod_say(msg as text)
	set category = PANEL_SPECIAL_VERBS
	set name = "Msay"
	set hidden = 1

	if(!check_rights(R_ADMIN | R_MOD))
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	log_admin("MOD: [key_name(src)] : [msg]")

	if(!msg)
		return
	var/color = "mod"
	if(check_rights(R_ADMIN, 0))
		color = "adminmod"
	for_no_type_check(var/client/C, GLOBL.admins)
		if((R_ADMIN | R_MOD) & C.holder.rights)
			var/chat_tag = create_chat_tag_icon("mod", C)
			to_chat(C, "[chat_tag] <span class='[color]'><EM>[key_name(src,1)]</EM> (<A href='byond://?src=\ref[C.holder];adminplayerobservejump=\ref[mob]'>JMP</A>): <span class='message'>[msg]</span></span>")