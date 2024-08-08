/mob/new_player
	var/client/my_client // Need to keep track of this ourselves, since by the time Logout() is called the client has already been nulled

/mob/new_player/Login()
	update_Login_details()	//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
	if(GLOBL.join_motd)
		to_chat(src, "<div class=\"motd\">[GLOBL.join_motd]</div>")

	if(!mind)
		mind = new /datum/mind(key)
		mind.active = TRUE
		mind.current = src

	loc = null
	client.screen += GLOBL.splashscreen
	my_client = client

	sight |= SEE_TURFS
	GLOBL.player_list |= src

	new_player_panel()
	spawn(10 SECONDS)
		if(client)
			global.PCnanoui.send_resources(client)
			handle_privacy_poll()
			client.playtitlemusic()