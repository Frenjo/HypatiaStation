//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
/mob/proc/update_Login_details()
	//Multikey checks and logging
	lastKnownIP	= client.address
	computer_id	= client.computer_id
	log_access("Login: [key_name(src)] from [lastKnownIP ? lastKnownIP : "localhost"]-[computer_id] || BYOND v[client.byond_version]")
	if(CONFIG_GET(log_access))
		for_no_type_check(var/mob/M, GLOBL.player_list)
			if(M == src)
				continue
			if(isnotnull(M.key) && M.key != key)
				var/matches
				if(M.lastKnownIP == client.address)
					matches += "IP ([client.address])"
				if(M.computer_id == client.computer_id)
					if(matches)
						matches += " and "
					matches += "ID ([client.computer_id])"
					spawn()
						alert("You have logged in already with another key this round, please log out of this one NOW or risk being banned!")
				if(matches)
					if(isnotnull(M.client))
						message_admins("<font color='red'><B>Notice: </B><font color='blue'><A href='byond:://?src=\ref[usr];priv_msg=\ref[src]'>[key_name_admin(src)]</A> has the same [matches] as <A href='byond:://?src=\ref[usr];priv_msg=\ref[M]'>[key_name_admin(M)]</A>.</font>", 1)
						log_access("Notice: [key_name(src)] has the same [matches] as [key_name(M)].")
					else
						message_admins("<font color='red'><B>Notice: </B><font color='blue'><A href='byond:://?src=\ref[usr];priv_msg=\ref[src]'>[key_name_admin(src)]</A> has the same [matches] as [key_name_admin(M)] (no longer logged in). </font>", 1)
						log_access("Notice: [key_name(src)] has the same [matches] as [key_name(M)] (no longer logged in).")

/mob/Login()
	GLOBL.player_list |= src
	update_Login_details()
	world.update_status()

	client.images = null	//remove the images such as AIs being unable to see runes
	client.screen = null	//remove hud items just in case
	if(hud_used)
		qdel(hud_used)		//remove the hud objects
	if(isnotnull(hud_type))
		hud_used = new hud_type(src)

	client.apply_parallax()

	next_move = 1
	sight |= SEE_SELF
	. = ..()

	if(isnotnull(loc) && !isturf(loc))
		client.eye = loc
		client.perspective = EYE_PERSPECTIVE
	else
		client.eye = src
		client.perspective = MOB_PERSPECTIVE

	// Send NanoUI resources to this client
	global.PCnanoui.send_resources(src)