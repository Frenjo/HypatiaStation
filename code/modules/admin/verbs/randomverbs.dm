/client/proc/cmd_admin_drop_everything(mob/M as mob in GLOBL.mob_list)
	set category = null
	set name = "Drop Everything"
	if(!holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return

	var/confirm = alert(src, "Make [M] drop everything?", "Message", "Yes", "No")
	if(confirm != "Yes")
		return

	for(var/obj/item/W in M)
		M.drop_from_inventory(W)

	log_admin("[key_name(usr)] made [key_name(M)] drop everything!")
	message_admins("[key_name_admin(usr)] made [key_name_admin(M)] drop everything!", 1)
	feedback_add_details("admin_verb","DEVR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_prison(mob/M as mob in GLOBL.mob_list)
	set category = PANEL_ADMIN
	set name = "Prison"

	if(!holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return
	if (ismob(M))
		if(isAI(M))
			alert("The AI can't be sent to prison you jerk!", null, null, null, null, null)
			return
		//strip their stuff before they teleport into a cell :downs:
		for(var/obj/item/W in M)
			M.drop_from_inventory(W)
		//teleport person to cell
		M.Paralyse(5)
		sleep(5)	//so they black out before warping
		M.forceMove(pick(GLOBL.prisonwarp))
		if(ishuman(M))
			var/mob/living/carbon/human/prisoner = M
			prisoner.equip_to_slot_or_del(new /obj/item/clothing/under/color/orange(prisoner), SLOT_ID_WEAR_UNIFORM)
			prisoner.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(prisoner), SLOT_ID_SHOES)
		spawn(50)
			M << "\red You have been sent to the prison station!"
		log_admin("[key_name(usr)] sent [key_name(M)] to the prison station.")
		message_admins("\blue [key_name_admin(usr)] sent [key_name_admin(M)] to the prison station.", 1)
		feedback_add_details("admin_verb","PRISON") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_subtle_message(mob/M as mob in GLOBL.mob_list)
	set category = PANEL_SPECIAL_VERBS
	set name = "Subtle Message"

	if(!ismob(M))	return
	if (!holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return

	var/msg = input("Message:", text("Subtle PM to [M.key]")) as text

	if (!msg)
		return
	if(usr)
		if (usr.client)
			if(usr.client.holder)
				M << "\bold You hear a voice in your head... \italic [msg]"

	log_admin("SubtlePM: [key_name(usr)] -> [key_name(M)] : [msg]")
	message_admins("\blue \bold SubtleMessage: [key_name_admin(usr)] -> [key_name_admin(M)] : [msg]", 1)
	feedback_add_details("admin_verb","SMS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_world_narrate() // Allows administrators to fluff events a little easier -- TLE
	set category = PANEL_SPECIAL_VERBS
	set name = "Global Narrate"

	if (!holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return

	var/msg = input("Message:", text("Enter the text you wish to appear to everyone:")) as text

	if (!msg)
		return
	to_world("[msg]")
	log_admin("GlobalNarrate: [key_name(usr)] : [msg]")
	message_admins("\blue \bold GlobalNarrate: [key_name_admin(usr)] : [msg]<BR>", 1)
	feedback_add_details("admin_verb","GLN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_direct_narrate(var/mob/M)	// Targetted narrate -- TLE
	set category = PANEL_SPECIAL_VERBS
	set name = "Direct Narrate"

	if(!holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return

	if(!M)
		M = input("Direct narrate to who?", "Active Players") as null|anything in get_mob_with_client_list()

	if(!M)
		return

	var/msg = input("Message:", text("Enter the text you wish to appear to your target:")) as text

	if( !msg )
		return

	M << msg
	log_admin("DirectNarrate: [key_name(usr)] to ([M.name]/[M.key]): [msg]")
	message_admins("\blue \bold DirectNarrate: [key_name(usr)] to ([M.name]/[M.key]): [msg]<BR>", 1)
	feedback_add_details("admin_verb","DIRN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_godmode(mob/M as mob in GLOBL.mob_list)
	set category = PANEL_SPECIAL_VERBS
	set name = "Godmode"

	if(!holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return
	M.status_flags ^= GODMODE
	usr << "\blue Toggled [(M.status_flags & GODMODE) ? "ON" : "OFF"]"

	log_admin("[key_name(usr)] has toggled [key_name(M)]'s nodamage to [(M.status_flags & GODMODE) ? "On" : "Off"]")
	message_admins("[key_name_admin(usr)] has toggled [key_name_admin(M)]'s nodamage to [(M.status_flags & GODMODE) ? "On" : "Off"]", 1)
	feedback_add_details("admin_verb","GOD") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/proc/cmd_admin_mute(mob/M as mob, mute_type, automute = 0)
	if(automute)
		if(!CONFIG_GET(/decl/configuration_entry/automute_on))
			return
	else
		if(!usr || !usr.client)
			return
		if(!usr.client.holder)
			usr << "<font color='red'>Error: cmd_admin_mute: You don't have permission to do this.</font>"
			return
		if(!M.client)
			usr << "<font color='red'>Error: cmd_admin_mute: This mob doesn't have a client tied to it.</font>"
		if(M.client.holder)
			usr << "<font color='red'>Error: cmd_admin_mute: You cannot mute an admin/mod.</font>"
	if(!M.client)		return
	if(M.client.holder)	return

	var/muteunmute
	var/mute_string

	switch(mute_type)
		if(MUTE_IC)			mute_string = "IC (say and emote)"
		if(MUTE_OOC)		mute_string = "OOC"
		if(MUTE_PRAY)		mute_string = "pray"
		if(MUTE_ADMINHELP)	mute_string = "adminhelp, admin PM and ASAY"
		if(MUTE_DEADCHAT)	mute_string = "deadchat and DSAY"
		if(MUTE_ALL)		mute_string = "everything"
		else				return

	if(automute)
		muteunmute = "auto-muted"
		M.client.prefs.muted |= mute_type
		log_admin("SPAM AUTOMUTE: [muteunmute] [key_name(M)] from [mute_string]")
		message_admins("SPAM AUTOMUTE: [muteunmute] [key_name_admin(M)] from [mute_string].", 1)
		M << "You have been [muteunmute] from [mute_string] by the SPAM AUTOMUTE system. Contact an admin."
		feedback_add_details("admin_verb","AUTOMUTE") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		return

	if(M.client.prefs.muted & mute_type)
		muteunmute = "unmuted"
		M.client.prefs.muted &= ~mute_type
	else
		muteunmute = "muted"
		M.client.prefs.muted |= mute_type

	log_admin("[key_name(usr)] has [muteunmute] [key_name(M)] from [mute_string]")
	message_admins("[key_name_admin(usr)] has [muteunmute] [key_name_admin(M)] from [mute_string].", 1)
	M << "You have been [muteunmute] from [mute_string]."
	feedback_add_details("admin_verb","MUTE") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/cmd_admin_add_random_ai_law()
	set category = PANEL_FUN
	set name = "Add Random AI Law"

	if(!holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return
	var/confirm = alert(src, "You sure?", "Confirm", "Yes", "No")
	if(confirm != "Yes") return
	log_admin("[key_name(src)] has added a random AI law.")
	message_admins("[key_name_admin(src)] has added a random AI law.", 1)

	var/show_log = alert(src, "Show ion message?", "Message", "Yes", "No")
	if(show_log == "Yes")
		priority_announce(
			"Ion storm detected near the station. Please check all AI-controlled equipment for errors.", "Anomaly Alert", 'sound/AI/ionstorm.ogg'
		)

	new /datum/round_event/storm/ion(0, TRUE)
	feedback_add_details("admin_verb","ION") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_banhammer()
	set category = PANEL_FUN
	set name = "Banhammer!"
	set desc = "Play the banhammer sound.  Banhammmerrr...."

	if(!holder)
		src << "Excuse me, I don't see your banhammer license..."
		return
	world << sound("sound/voice/banhammer.ogg")

/*
Allow admins to set players to be able to respawn/bypass 30 min wait, without the admin having to edit variables directly
Ccomp's first proc.
*/

/client/proc/get_ghosts(var/notify = 0, var/what = 2)
	// what = 1, return ghosts ass list.
	// what = 2, return mob list

	var/list/mobs = list()
	var/list/ghosts = list()
	var/list/sortmob = sortAtom(GLOBL.mob_list)	// get the mob list.
	var/any = FALSE
	for(var/mob/dead/ghost/M in sortmob)
		mobs.Add(M)					//filter it where it's only ghosts
		any = TRUE					//if no ghosts show up, any will just be 0
	if(!any)
		if(notify)
			src << "There doesn't appear to be any ghosts for you to select."
		return

	for(var/mob/M in mobs)
		var/name = M.name
		ghosts[name] = M			//get the name of the mob for the popup list
	if(what == 1)
		return ghosts
	else
		return mobs


/client/proc/allow_character_respawn()
	set category = PANEL_SPECIAL_VERBS
	set name = "Allow player to respawn"
	set desc = "Let's the player bypass the 30 minute wait to respawn or allow them to re-enter their corpse."

	if(!holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
	var/list/ghosts= get_ghosts(1,1)

	var/target = input("Please, select a ghost!", "COME BACK TO LIFE!", null, null) as null|anything in ghosts
	if(!target)
		src << "Hrm, appears you didn't select a ghost"		// Sanity check, if no ghosts in the list we don't want to edit a null variable and cause a runtime error.
		return

	var/mob/dead/ghost/G = ghosts[target]
	if(G.has_enabled_antagHUD && CONFIG_GET(/decl/configuration_entry/antag_hud_restricted))
		var/response = alert(src, "Are you sure you wish to allow this individual to play?","Ghost has used AntagHUD","Yes","No")
		if(response == "No") return
	G.timeofdeath=-19999						/* time of death is checked in /mob/verb/abandon_mob() which is the Respawn verb.
									   timeofdeath is used for bodies on autopsy but since we're messing with a ghost I'm pretty sure
									   there won't be an autopsy.
									*/
	G.has_enabled_antagHUD = 2
	G.can_reenter_corpse = 1

	to_chat(G, SPAN_INFO_B("You may now respawn. You should roleplay as if you learned nothing about the round during your time with the dead."))
	log_admin("[key_name(usr)] allowed [key_name(G)] to bypass the 30 minute respawn limit")
	message_admins("Admin [key_name_admin(usr)] allowed [key_name_admin(G)] to bypass the 30 minute respawn limit", 1)


/client/proc/toggle_antagHUD_use()
	set category = PANEL_SERVER
	set name = "Toggle antagHUD usage"
	set desc = "Toggles antagHUD usage for observers"

	if(!holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
	var/action=""
	if(CONFIG_GET(/decl/configuration_entry/antag_hud_allowed))
		for(var/mob/dead/ghost/g in get_ghosts())
			if(!g.client.holder)						//Remove the verb from non-admin ghosts
				g.verbs -= /mob/dead/ghost/verb/toggle_antagHUD
			if(g.antagHUD)
				g.antagHUD = 0						// Disable it on those that have it enabled
				g.has_enabled_antagHUD = 2				// We'll allow them to respawn
				g << "\red <B>The Administrator has disabled AntagHUD </B>"
		CONFIG_SET(/decl/configuration_entry/antag_hud_allowed, FALSE)
		src << "\red <B>AntagHUD usage has been disabled</B>"
		action = "disabled"
	else
		for(var/mob/dead/ghost/g in get_ghosts())
			if(!g.client.holder)						// Add the verb back for all non-admin ghosts
				g.verbs += /mob/dead/ghost/verb/toggle_antagHUD
			g << "\blue <B>The Administrator has enabled AntagHUD </B>"	// Notify all observers they can now use AntagHUD
		CONFIG_SET(/decl/configuration_entry/antag_hud_allowed, TRUE)
		action = "enabled"
		src << "\blue <B>AntagHUD usage has been enabled</B>"


	log_admin("[key_name(usr)] has [action] antagHUD usage for observers")
	message_admins("Admin [key_name_admin(usr)] has [action] antagHUD usage for observers", 1)



/client/proc/toggle_antagHUD_restrictions()
	set category = PANEL_SERVER
	set name = "Toggle antagHUD Restrictions"
	set desc = "Restricts players that have used antagHUD from being able to join this round."

	if(!holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
	var/action=""
	if(CONFIG_GET(/decl/configuration_entry/antag_hud_restricted))
		for(var/mob/dead/ghost/g in get_ghosts())
			g << "\blue <B>The administrator has lifted restrictions on joining the round if you use AntagHUD</B>"
		action = "lifted restrictions"
		CONFIG_SET(/decl/configuration_entry/antag_hud_restricted, FALSE)
		src << "\blue <B>AntagHUD restrictions have been lifted</B>"
	else
		for(var/mob/dead/ghost/g in get_ghosts())
			g << "\red <B>The administrator has placed restrictions on joining the round if you use AntagHUD</B>"
			g << "\red <B>Your AntagHUD has been disabled, you may choose to re-enabled it but will be under restrictions </B>"
			g.antagHUD = 0
			g.has_enabled_antagHUD = 0
		action = "placed restrictions"
		CONFIG_SET(/decl/configuration_entry/antag_hud_restricted, TRUE)
		src << "\red <B>AntagHUD restrictions have been enabled</B>"

	log_admin("[key_name(usr)] has [action] on joining the round if they use AntagHUD")
	message_admins("Admin [key_name_admin(usr)] has [action] on joining the round if they use AntagHUD", 1)




/*
If a guy was gibbed and you want to revive him, this is a good way to do so.
Works kind of like entering the game with a new character. Character receives a new mind if they didn't have one.
Traitors and the like can also be revived with the previous role mostly intact.
/N */
/client/proc/respawn_character()
	set category = PANEL_SPECIAL_VERBS
	set name = "Respawn Character"
	set desc = "Respawn a person that has been gibbed/dusted/killed. They must be a ghost for this to work and preferably should not have a body to go back into."

	if(!holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return
	var/input = ckey(input(src, "Please specify which key will be respawned.", "Key", ""))
	if(!input)
		return

	var/mob/dead/ghost/G_found
	for(var/mob/dead/ghost/G in GLOBL.player_list)
		if(G.ckey == input)
			G_found = G
			break

	if(!G_found)//If a ghost was not found.
		usr << "<font color='red'>There is no active key like that in the game or the person is not currently a ghost.</font>"
		return

	if(G_found.mind && !G_found.mind.active)	//mind isn't currently in use by someone/something
		//check if they were a monkey
		if(findtext(G_found.real_name,"monkey"))
			if(alert("This character appears to have been a monkey. Would you like to respawn them as such?",,"Yes","No")=="Yes")
				var/mob/living/carbon/monkey/new_monkey = new(pick(GLOBL.latejoin))
				G_found.mind.transfer_to(new_monkey)	//be careful when doing stuff like this! I've already checked the mind isn't in use
				new_monkey.key = G_found.key
				new_monkey << "You have been fully respawned. Enjoy the game."
				message_admins("\blue [key_name_admin(usr)] has respawned [new_monkey.key] as a filthy xeno.", 1)
				return	//all done. The ghost is auto-deleted


	//Ok, it's not a monkey. So, spawn a human.
	var/mob/living/carbon/human/new_character = new(pick(GLOBL.latejoin))//The mob being spawned.

	var/datum/data/record/record_found			//Referenced to later to either randomize or not randomize the character.
	if(G_found.mind && !G_found.mind.active)	//mind isn't currently in use by someone/something
		/*Try and locate a record for the person being respawned through data_core.
		This isn't an exact science but it does the trick more often than not.*/
		var/id = md5("[G_found.real_name][G_found.mind.assigned_role]")
		for_no_type_check(var/datum/data/record/t, GLOBL.data_core.locked)
			if(t.fields["id"]==id)
				record_found = t//We shall now reference the record.
				break

	if(record_found)//If they have a record we can determine a few things.
		new_character.real_name = record_found.fields["name"]
		new_character.gender = record_found.fields["sex"]
		new_character.age = record_found.fields["age"]
		new_character.b_type = record_found.fields["b_type"]
	else
		new_character.gender = pick(MALE,FEMALE)
		var/datum/preferences/A = new()
		A.randomize_appearance_for(new_character)
		new_character.real_name = G_found.real_name

	if(!new_character.real_name)
		if(new_character.gender == MALE)
			new_character.real_name = capitalize(pick(GLOBL.first_names_male)) + " " + capitalize(pick(GLOBL.last_names))
		else
			new_character.real_name = capitalize(pick(GLOBL.first_names_female)) + " " + capitalize(pick(GLOBL.last_names))
	new_character.name = new_character.real_name

	if(G_found.mind && !G_found.mind.active)
		G_found.mind.transfer_to(new_character)	//be careful when doing stuff like this! I've already checked the mind isn't in use
		new_character.mind.special_verbs = list()
	else
		new_character.mind_initialize()
	if(!new_character.mind.assigned_role)	new_character.mind.assigned_role = "Assistant"//If they somehow got a null assigned role.

	//DNA
	if(record_found)//Pull up their name from database records if they did have a mind.
		new_character.dna = new()//Let's first give them a new DNA.
		new_character.dna.unique_enzymes = record_found.fields["b_dna"]//Enzymes are based on real name but we'll use the record for conformity.

		// I HATE BYOND.  HATE.  HATE. - N3X
		var/list/newSE= record_found.fields["enzymes"]
		var/list/newUI = record_found.fields["identity"]
		new_character.dna.SE = newSE.Copy() //This is the default of enzymes so I think it's safe to go with.
		new_character.dna.UpdateSE()
		new_character.UpdateAppearance(newUI.Copy())//Now we configure their appearance based on their unique identity, same as with a DNA machine or somesuch.
	else//If they have no records, we just do a random DNA for them, based on their random appearance/savefile.
		new_character.dna.ready_dna(new_character)

	new_character.key = G_found.key

	/*
	The code below functions with the assumption that the mob is already a traitor if they have a special role.
	So all it does is re-equip the mob with powers and/or items. Or not, if they have no special role.
	If they don't have a mind, they obviously don't have a special role.
	*/

	//Two variables to properly announce later on.
	var/admin = key_name_admin(src)
	var/player_key = G_found.key

	//Now for special roles and equipment.
	switch(new_character.mind.special_role)
		if("traitor")
			global.CTjobs.equip_rank(new_character, new_character.mind.assigned_role, TRUE)
			global.PCticker.mode.equip_traitor(new_character)
		if("Wizard")
			new_character.forceMove(pick(GLOBL.wizardstart))
			//ticker.mode.learn_basic_spells(new_character)
			global.PCticker.mode.equip_wizard(new_character)
		if("Syndicate")
			var/obj/effect/landmark/synd_spawn = locate("landmark*Syndicate-Spawn")
			if(synd_spawn)
				new_character.forceMove(GET_TURF(synd_spawn))
			new_character.equip_outfit(/decl/hierarchy/outfit/syndicate/nuclear)
		if("Ninja")
			new_character.equip_space_ninja()
			new_character.internal = new_character.suit_store
			new_character.internals.icon_state = "internal1"
			if(!length(GLOBL.ninjastart))
				new_character << "<B>\red A proper starting location for you could not be found, please report this bug!</B>"
				new_character << "<B>\red Attempting to place at a carpspawn.</B>"
				for_no_type_check(var/obj/effect/landmark/L, GLOBL.landmark_list)
					if(L.name == "carpspawn")
						GLOBL.ninjastart.Add(L)
				if(!length(GLOBL.ninjastart) && length(GLOBL.latejoin))
					new_character << "<B>\red Still no spawneable locations could be found. Defaulting to latejoin.</B>"
					new_character.forceMove(pick(GLOBL.latejoin))
				else if(!length(GLOBL.ninjastart))
					new_character << "<B>\red Still no spawneable locations could be found. Aborting.</B>"

		if("Death Commando")//Leaves them at late-join spawn.
			new_character.equip_outfit(/decl/hierarchy/outfit/death_commando/standard)
			new_character.internal = new_character.suit_store
			new_character.internals.icon_state = "internal1"
		else//They may also be a cyborg or AI.
			switch(new_character.mind.assigned_role)
				if("Cyborg")//More rigging to make em' work and check if they're traitor.
					new_character = new_character.Robotize()
					if(new_character.mind.special_role == "traitor")
						call(/datum/game_mode/proc/add_law_zero)(new_character)
				if("AI")
					new_character = new_character.AIize()
					if(new_character.mind.special_role == "traitor")
						call(/datum/game_mode/proc/add_law_zero)(new_character)
				//Add aliens.
				else
					global.CTjobs.equip_rank(new_character, new_character.mind.assigned_role, TRUE)//Or we simply equip them.

	//Announces the character on all the systems, based on the record.
	if(!issilicon(new_character))//If they are not a cyborg/AI.
		if(!record_found&&new_character.mind.assigned_role != "MODE")//If there are no records for them. If they have a record, this info is already in there. MODE people are not announced anyway.
			//Power to the user!
			if(alert(new_character, "Warning: No data core entry detected. Would you like to announce the arrival of this character by adding them to various databases, such as medical records?", , "No", "Yes") == "Yes")
				GLOBL.data_core.manifest_inject(new_character)

			if(alert(new_character, "Would you like an active AI to announce this character?", , "No", "Yes") == "Yes")
				call(/mob/dead/new_player/proc/announce_arrival)(new_character, new_character.mind.assigned_role)

	message_admins("\blue [admin] has respawned [player_key] as [new_character.real_name].", 1)

	new_character << "You have been fully respawned. Enjoy the game."

	feedback_add_details("admin_verb", "RSPCH") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return new_character

/client/proc/cmd_admin_add_freeform_ai_law()
	set category = PANEL_FUN
	set name = "Add Custom AI law"

	if(!holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return
	var/input = input(usr, "Please enter anything you want the AI to do. Anything. Serious.", "What?", "") as text|null
	if(!input)
		return
	for(var/mob/living/silicon/ai/M in GLOBL.mob_list)
		if(M.stat == DEAD)
			usr << "Upload failed. No signal is being detected from the AI."
		else if(M.see_in_dark == 0)
			usr << "Upload failed. Only a faint signal is being detected from the AI, and it is not responding to our requests. It may be low on power."
		else
			M.add_ion_law(input)
			for(var/mob/living/silicon/ai/O in GLOBL.mob_list)
				O << "\red " + input + "\red...LAWS UPDATED"

	log_admin("Admin [key_name(usr)] has added a new AI law - [input]")
	message_admins("Admin [key_name_admin(usr)] has added a new AI law - [input]", 1)

	var/show_log = alert(src, "Show ion message?", "Message", "Yes", "No")
	if(show_log == "Yes")
		priority_announce(
			"Ion storm detected near the station. Please check all AI-controlled equipment for errors.", "Anomaly Alert", 'sound/AI/ionstorm.ogg'
		)
	feedback_add_details("admin_verb","IONC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_rejuvenate(mob/living/M as mob in GLOBL.mob_list)
	set category = PANEL_SPECIAL_VERBS
	set name = "Rejuvenate"

	if(!holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return
	if(!mob)
		return
	if(!istype(M))
		alert("Cannot revive a ghost")
		return
	if(CONFIG_GET(/decl/configuration_entry/allow_admin_rev))
		M.revive()

		log_admin("[key_name(usr)] healed / revived [key_name(M)]")
		message_admins("\red Admin [key_name_admin(usr)] healed / revived [key_name_admin(M)]!", 1)
	else
		alert("Admin revive disabled")
	feedback_add_details("admin_verb","REJU") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_create_centcom_report()
	set category = PANEL_SPECIAL_VERBS
	set name = "Create Command Report"

	if(!holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return
	var/input = input(usr, "Please enter anything you want. Anything. Serious.", "What?", "") as message|null
	var/customname = input(usr, "Pick a title for the report.", "Title") as text|null
	if(!input)
		return
	if(!customname)
		customname = "NanoTrasen Update"
	FOR_MACHINES_TYPED(comms, /obj/machinery/computer/communications)
		if(!(comms.stat & (BROKEN|NOPOWER)))
			var/obj/item/paper/P = new /obj/item/paper(comms.loc)
			P.name = "'[command_name()] Update.'"
			P.info = input
			P.update_icon()
			comms.messagetitle.Add("[command_name()] Update")
			comms.messagetext.Add(P.info)

	switch(alert("Should this be announced to the general population?",,"Yes","No"))
		if("Yes")
			priority_announce(input, customname)
		if("No")
			to_world("\red New NanoTrasen Update available at all communication consoles.")

	world << sound('sound/AI/commandreport.ogg')
	log_admin("[key_name(src)] has created a command report: [input]")
	message_admins("[key_name_admin(src)] has created a command report", 1)
	feedback_add_details("admin_verb","CCR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_delete(atom/O as obj|mob|turf in world)
	set category = PANEL_ADMIN
	set name = "Delete"

	if (!holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return

	if (alert(src, "Are you sure you want to delete:\n[O]\nat ([O.x], [O.y], [O.z])?", "Confirmation", "Yes", "No") == "Yes")
		log_admin("[key_name(usr)] deleted [O] at ([O.x],[O.y],[O.z])")
		message_admins("[key_name_admin(usr)] deleted [O] at ([O.x],[O.y],[O.z])", 1)
		feedback_add_details("admin_verb","DEL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		qdel(O)

/client/proc/cmd_admin_list_open_jobs()
	set category = PANEL_ADMIN
	set name = "List free slots"

	if (!holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return
	if(global.CTjobs)
		for_no_type_check(var/datum/job/job, global.CTjobs.occupations)
			src << "[job.title]: [job.total_positions]"
	feedback_add_details("admin_verb","LFS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_explosion(atom/O as obj|mob|turf in world)
	set category = PANEL_SPECIAL_VERBS
	set name = "Explosion"

	if(!check_rights(R_DEBUG|R_FUN))	return

	var/devastation = input("Range of total devastation. -1 to none", text("Input"))  as num|null
	if(devastation == null) return
	var/heavy = input("Range of heavy impact. -1 to none", text("Input"))  as num|null
	if(heavy == null) return
	var/light = input("Range of light impact. -1 to none", text("Input"))  as num|null
	if(light == null) return
	var/flash = input("Range of flash. -1 to none", text("Input"))  as num|null
	if(flash == null) return

	if ((devastation != -1) || (heavy != -1) || (light != -1) || (flash != -1))
		if ((devastation > 20) || (heavy > 20) || (light > 20))
			if (alert(src, "Are you sure you want to do this? It will laaag.", "Confirmation", "Yes", "No") == "No")
				return

		explosion(O, devastation, heavy, light, flash)
		log_admin("[key_name(usr)] created an explosion ([devastation],[heavy],[light],[flash]) at ([O.x],[O.y],[O.z])")
		message_admins("[key_name_admin(usr)] created an explosion ([devastation],[heavy],[light],[flash]) at ([O.x],[O.y],[O.z])", 1)
		feedback_add_details("admin_verb","EXPL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		return
	else
		return

/client/proc/cmd_admin_emp(atom/O as obj|mob|turf in world)
	set category = PANEL_SPECIAL_VERBS
	set name = "EM Pulse"

	if(!check_rights(R_DEBUG|R_FUN))	return

	var/heavy = input("Range of heavy pulse.", text("Input"))  as num|null
	if(heavy == null) return
	var/light = input("Range of light pulse.", text("Input"))  as num|null
	if(light == null) return

	if (heavy || light)

		empulse(O, heavy, light)
		log_admin("[key_name(usr)] created an EM Pulse ([heavy],[light]) at ([O.x],[O.y],[O.z])")
		message_admins("[key_name_admin(usr)] created an EM PUlse ([heavy],[light]) at ([O.x],[O.y],[O.z])", 1)
		feedback_add_details("admin_verb","EMP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

		return
	else
		return

/client/proc/cmd_admin_gib(mob/victim as mob in GLOBL.mob_list)
	set category = PANEL_SPECIAL_VERBS
	set name = "Gib"

	if(!check_rights(R_ADMIN | R_FUN))
		return

	var/confirm = alert(src, "You sure?", "Confirm", "Yes", "No")
	if(confirm != "Yes")
		return
	// Due to the delay here its easy for something to have happened to the mob
	if(isnull(victim))
		return

	log_admin("[key_name(usr)] has gibbed [key_name(victim)]")
	message_admins("[key_name_admin(usr)] has gibbed [key_name_admin(victim)]", 1)

	if(isghost(victim))
		gibs(victim.loc, victim.viruses)
		return

	if(isliving(victim))
		var/mob/living/living_victim = victim
		living_victim.gib()

	feedback_add_details("admin_verb","GIB") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/cmd_admin_gib_self()
	set category = PANEL_FUN
	set name = "Gibself"

	var/confirm = alert(src, "You sure?", "Confirm", "Yes", "No")
	if(confirm == "Yes")
		log_admin("[key_name(usr)] used gibself.")
		message_admins("\blue [key_name_admin(usr)] used gibself.", 1)

		if(isliving(mob))
			var/mob/living/self = mob
			self.gib()

		feedback_add_details("admin_verb","GIBS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
/*
/client/proc/cmd_manual_ban()
	set category = PANEL_SPECIAL_VERBS
	set name = "Manual Ban"

	if(!authenticated || !holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return
	var/mob/M = null
	switch(alert("How would you like to ban someone today?", "Manual Ban", "Key List", "Enter Manually", "Cancel"))
		if("Key List")
			var/list/keys = list()
			for_no_type_check(var/mob/M, GLOBL.mob_list)
				keys += M.client
			var/selection = input("Please, select a player!", "Admin Jumping", null, null) as null|anything in keys
			if(!selection)
				return
			M = selection:mob
			if ((M.client && M.client.holder && (M.client.holder.level >= holder.level)))
				alert("You cannot perform this action. You must be of a higher administrative rank!")
				return

	switch(alert("Temporary Ban?",,"Yes","No"))
	if("Yes")
		var/mins = input(usr,"How long (in minutes)?","Ban time",1440) as num
		if(!mins)
			return
		if(mins >= 525600) mins = 525599
		var/reason = input(usr,"Reason?","reason","Griefer") as text
		if(!reason)
			return
		if(M)
			AddBan(M.ckey, M.computer_id, reason, usr.ckey, 1, mins)
			M << "\red<BIG><B>You have been banned by [usr.client.ckey].\nReason: [reason].</B></BIG>"
			M << "\red This is a temporary ban, it will be removed in [mins] minutes."
			M << "\red To try to resolve this matter head to http://ss13.donglabs.com/forum/"
			log_admin("[usr.client.ckey] has banned [M.ckey].\nReason: [reason]\nThis will be removed in [mins] minutes.")
			message_admins("\blue[usr.client.ckey] has banned [M.ckey].\nReason: [reason]\nThis will be removed in [mins] minutes.")
			world.Export("http://216.38.134.132/adminlog.php?type=ban&key=[usr.client.key]&key2=[M.key]&msg=[html_decode(reason)]&time=[mins]&server=[replacetextx(CONFIG_GET(/decl/configuration_entry/server_name), "#", "")]")
			del(M.client)
			del(M)
		else

	if("No")
		var/reason = input(usr,"Reason?","reason","Griefer") as text
		if(!reason)
			return
		AddBan(M.ckey, M.computer_id, reason, usr.ckey, 0, 0)
		M << "\red<BIG><B>You have been banned by [usr.client.ckey].\nReason: [reason].</B></BIG>"
		M << "\red This is a permanent ban."
		M << "\red To try to resolve this matter head to http://ss13.donglabs.com/forum/"
		log_admin("[usr.client.ckey] has banned [M.ckey].\nReason: [reason]\nThis is a permanent ban.")
		message_admins("\blue[usr.client.ckey] has banned [M.ckey].\nReason: [reason]\nThis is a permanent ban.")
		world.Export("http://216.38.134.132/adminlog.php?type=ban&key=[usr.client.key]&key2=[M.key]&msg=[html_decode(reason)]&time=perma&server=[replacetextx(CONFIG_GET(/decl/configuration_entry/server_name), "#", "")]")
		del(M.client)
		del(M)
*/

/client/proc/update_world()
	// If I see anyone granting powers to specific keys like the code that was here,
	// I will both remove their SVN access and permanently ban them from my servers.
	return

/client/proc/cmd_admin_check_contents(mob/living/M as mob in GLOBL.mob_list)
	set category = PANEL_SPECIAL_VERBS
	set name = "Check Contents"

	var/list/L = M.get_contents()
	for(var/t in L)
		usr << "[t]"
	feedback_add_details("admin_verb","CC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/* This proc is DEFERRED. Does not do anything.
/client/proc/cmd_admin_remove_plasma()
	set category = PANEL_DEBUG
	set name = "Stabilize Atmos."

	if(!holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return
	feedback_add_details("admin_verb","STATM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
// DEFERRED
	spawn(0)
		for(var/turf/T in view())
			T.poison = 0
			T.oldpoison = 0
			T.tmppoison = 0
			T.oxygen = 755985
			T.oldoxy = 755985
			T.tmpoxy = 755985
			T.co2 = 14.8176
			T.oldco2 = 14.8176
			T.tmpco2 = 14.8176
			T.n2 = 2.844e+006
			T.on2 = 2.844e+006
			T.tn2 = 2.844e+006
			T.tsl_gas = 0
			T.osl_gas = 0
			T.sl_gas = 0
			T.temp = 293.15
			T.otemp = 293.15
			T.ttemp = 293.15
*/

/client/proc/toggle_view_range()
	set category = PANEL_SPECIAL_VERBS
	set name = "Change View Range"
	set desc = "switches between 1x and custom views"

	if(view == world.view)
		view = input("Select view range:", "FUCK YE", 7) in list(1,2,3,4,5,6,7,8,9,10,11,12,13,14,128)
	else
		view = world.view

	log_admin("[key_name(usr)] changed their view range to [view].")
	//message_admins("\blue [key_name_admin(usr)] changed their view range to [view].", 1)	//why? removed by order of XSI

	feedback_add_details("admin_verb","CVRA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/admin_call_shuttle()
	set category = PANEL_ADMIN
	set name = "Call Shuttle"

	if(!global.PCticker || !global.PCemergency.location())
		return

	if(!check_rights(R_ADMIN))	return

	var/confirm = alert(src, "You sure?", "Confirm", "Yes", "No")
	if(confirm != "Yes") return

	if(IS_GAME_MODE(/datum/game_mode/revolution) || IS_GAME_MODE(/datum/game_mode/malfunction) || global.PCticker.mode.name == "confliction")
		var/choice = input("The shuttle will just return if you call it. Call anyway?") in list("Confirm", "Cancel")
		if(choice == "Confirm")
			global.PCemergency.auto_recall = TRUE
		else
			return

	global.PCemergency.call_evac()
	feedback_add_details("admin_verb","CSHUT") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(usr)] admin-called the emergency shuttle.")
	message_admins("\blue [key_name_admin(usr)] admin-called the emergency shuttle.", 1)
	return

/client/proc/admin_cancel_shuttle()
	set category = PANEL_ADMIN
	set name = "Cancel Shuttle"

	if(!check_rights(R_ADMIN))	return

	if(alert(src, "You sure?", "Confirm", "Yes", "No") != "Yes") return

	if(!global.PCticker || !global.PCemergency.can_recall())
		return

	global.PCemergency.recall()
	feedback_add_details("admin_verb","CCSHUT") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(usr)] admin-recalled the emergency shuttle.")
	message_admins("\blue [key_name_admin(usr)] admin-recalled the emergency shuttle.", 1)

	return

/client/proc/admin_deny_shuttle()
	set category = PANEL_ADMIN
	set name = "Toggle Deny Shuttle"

	if(!global.PCticker)
		return

	if(!check_rights(R_ADMIN))	return

	global.PCemergency.deny_shuttle = !global.PCemergency.deny_shuttle

	log_admin("[key_name(src)] has [global.PCemergency.deny_shuttle ? "denied" : "allowed"] the shuttle to be called.")
	message_admins("[key_name_admin(usr)] has [global.PCemergency.deny_shuttle ? "denied" : "allowed"] the shuttle to be called.")

/client/proc/cmd_admin_attack_log(mob/M as mob in GLOBL.mob_list)
	set category = PANEL_SPECIAL_VERBS
	set name = "Attack Log"

	usr << text("\red <b>Attack Log for []</b>", mob)
	for(var/t in M.attack_log)
		usr << t
	feedback_add_details("admin_verb","ATTL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/everyone_random()
	set category = PANEL_FUN
	set name = "Make Everyone Random"
	set desc = "Make everyone have a random appearance. You can only use this before rounds!"

	if(!check_rights(R_FUN))	return

	if(global.PCticker?.mode)
		usr << "Nope you can't do this, the game's already started. This only works before rounds!"
		return

	if(global.PCticker.random_players)
		global.PCticker.random_players = FALSE
		message_admins("Admin [key_name_admin(usr)] has disabled \"Everyone is Special\" mode.", 1)
		usr << "Disabled."
		return


	var/notifyplayers = alert(src, "Do you want to notify the players?", "Options", "Yes", "No", "Cancel")
	if(notifyplayers == "Cancel")
		return

	log_admin("Admin [key_name(src)] has forced the players to have random appearances.")
	message_admins("Admin [key_name_admin(usr)] has forced the players to have random appearances.", 1)

	if(notifyplayers == "Yes")
		to_world("\blue <b>Admin [usr.key] has forced the players to have completely random identities!")

	usr << "<i>Remember: you can always disable the randomness by using the verb again, assuming the round hasn't started yet</i>."

	global.PCticker.random_players = TRUE
	feedback_add_details("admin_verb","MER") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/toggle_random_events()
	set category = PANEL_SERVER
	set name = "Toggle random events on/off"
	set desc = "Toggles random events such as meteors, black holes, blob (but not space dust) on/off"

	if(!check_rights(R_SERVER))	return

	if(!CONFIG_GET(/decl/configuration_entry/allow_random_events))
		CONFIG_SET(/decl/configuration_entry/allow_random_events, TRUE)
		usr << "Random events enabled"
		message_admins("Admin [key_name_admin(usr)] has enabled random events.", 1)
	else
		CONFIG_SET(/decl/configuration_entry/allow_random_events, FALSE)
		usr << "Random events disabled"
		message_admins("Admin [key_name_admin(usr)] has disabled random events.", 1)
	feedback_add_details("admin_verb","TRE") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
