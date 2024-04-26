//toggles
/client/verb/toggle_ghost_ears()
	set category = PANEL_PREFERENCES
	set name = "Show/Hide GhostEars"
	set desc = "Toggle Between seeing all mob speech, and only speech of nearby mobs."

	prefs.toggles ^= CHAT_GHOSTEARS
	to_chat(src, "As a ghost, you will now [(prefs.toggles & CHAT_GHOSTEARS) ? "see all speech in the world" : "only see speech from nearby mobs"].")
	prefs.save_preferences()
	feedback_add_details("admin_verb", "TGE") // If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ghost_sight()
	set category = PANEL_PREFERENCES
	set name = "Show/Hide GhostSight"
	set desc = "Toggle Between seeing all mob emotes, and only emotes of nearby mobs."

	prefs.toggles ^= CHAT_GHOSTSIGHT
	to_chat(src, "As a ghost, you will now [(prefs.toggles & CHAT_GHOSTSIGHT) ? "see all emotes in the world" : "only see emotes from nearby mobs"].")
	prefs.save_preferences()
	feedback_add_details("admin_verb", "TGS") // If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_ghost_radio()
	set category = PANEL_PREFERENCES
	set name = "Enable/Disable GhostRadio"
	set desc = "Toggle between hearing all radio chatter, or only from nearby speakers."

	prefs.toggles ^= CHAT_GHOSTRADIO
	to_chat(src, "As a ghost, you will now [(prefs.toggles & CHAT_GHOSTRADIO) ? "hear all radio chat in the world" : "only hear from nearby speakers"].")
	prefs.save_preferences()
	feedback_add_details("admin_verb", "TGR")

/client/proc/toggle_hear_radio()
	set category = PANEL_PREFERENCES
	set name = "Show/Hide RadioChatter"
	set desc = "Toggle seeing radiochatter from radios and speakers."

	if(isnull(holder))
		return

	prefs.toggles ^= CHAT_RADIO
	prefs.save_preferences()
	to_chat(usr, "You will [(prefs.toggles & CHAT_RADIO) ? "now" : "no longer"] see radio chatter from radios or speakers.")
	feedback_add_details("admin_verb", "THR") // If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggleadminhelpsound()
	set category = PANEL_PREFERENCES
	set name = "Hear/Silence Adminhelps"
	set desc = "Toggle hearing a notification when admin PMs are recieved."

	if(isnull(holder))
		return

	prefs.toggles ^= SOUND_ADMINHELP
	prefs.save_preferences()
	to_chat(usr, "You will [(prefs.toggles & SOUND_ADMINHELP) ? "now" : "no longer"] hear a sound when adminhelps arrive.")
	feedback_add_details("admin_verb", "AHS") // If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/deadchat() // Deadchat toggle is usable by anyone.
	set category = PANEL_PREFERENCES
	set name = "Show/Hide Deadchat"
	set desc = "Toggles seeing deadchat."

	prefs.toggles ^= CHAT_DEAD
	prefs.save_preferences()

	if(isnotnull(holder))
		to_chat(src, "You will [(prefs.toggles & CHAT_DEAD) ? "now" : "no longer"] see deadchat.")
	else
		to_chat(src, "As a ghost, you will [(prefs.toggles & CHAT_DEAD) ? "now" : "no longer"] see deadchat.")

	feedback_add_details("admin_verb", "TDV") // If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggleprayers()
	set category = PANEL_PREFERENCES
	set name = "Show/Hide Prayers"
	set desc = "Toggles seeing prayers."

	prefs.toggles ^= CHAT_PRAYER
	prefs.save_preferences()

	to_chat(src, "You will [(prefs.toggles & CHAT_PRAYER) ? "now" : "no longer"] see prayerchat.")
	feedback_add_details("admin_verb", "TP") // If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggletitlemusic()
	set category = PANEL_PREFERENCES
	set name = "Hear/Silence LobbyMusic"
	set desc = "Toggles hearing the GameLobby music."

	prefs.toggles ^= SOUND_LOBBY
	prefs.save_preferences()

	if(prefs.toggles & SOUND_LOBBY)
		to_chat(src, "You will now hear music in the game lobby.")
		if(isnewplayer(mob))
			playtitlemusic()
	else
		to_chat(src, "You will no longer hear music in the game lobby.")
		if(isnewplayer(mob))
			src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // Stop the jamsz.
	feedback_add_details("admin_verb", "TLobby") // If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/togglemidis()
	set category = PANEL_PREFERENCES
	set name = "Hear/Silence Midis"
	set desc = "Toggles hearing sounds uploaded by admins."

	prefs.toggles ^= SOUND_MIDI
	prefs.save_preferences()

	if(prefs.toggles & SOUND_MIDI)
		to_chat(src, "You will now hear any sounds uploaded by admins.")
		var/sound/break_sound = sound(null, repeat = 0, wait = 0, channel = 777)
		break_sound.priority = 250
		src << break_sound // Breaks the client's sound output on channel 777.
	else
		to_chat(src, "You will no longer hear sounds uploaded by admins; any currently playing midis have been disabled.")
	feedback_add_details("admin_verb", "TMidi") // If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/listen_ooc()
	set category = PANEL_PREFERENCES
	set name = "Show/Hide OOC"
	set desc = "Toggles seeing OutOfCharacter chat."

	prefs.toggles ^= CHAT_OOC
	prefs.save_preferences()

	to_chat(src, "You will [(prefs.toggles & CHAT_OOC) ? "now" : "no longer"] see messages on the OOC channel.")
	feedback_add_details("admin_verb", "TOOC") // If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/listen_looc()
	set category = PANEL_PREFERENCES
	set name = "Show/Hide LOOC"
	set desc = "Toggles seeing Local OutOfCharacter chat."

	prefs.toggles ^= CHAT_LOOC
	prefs.save_preferences()

	to_chat(src, "You will [(prefs.toggles & CHAT_LOOC) ? "now" : "no longer"] see messages on the LOOC channel.")
	feedback_add_details("admin_verb", "TLOOC") // If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_soundscape() //All new ambience should be added here so it works with this verb until someone better at things comes up with a fix that isn't awful
	set category = PANEL_PREFERENCES
	set name = "Hear/Silence Ambience"
	set desc = "Toggles hearing ambient sound effects."

	prefs.toggles ^= SOUND_AMBIENCE
	prefs.save_preferences()

	if(prefs.toggles & SOUND_AMBIENCE)
		to_chat(src, "You will now hear ambient sounds.")
	else
		to_chat(src, "You will no longer hear ambient sounds.")
		src << sound(null, repeat = 0, wait = 0, volume = 0, channel = 1)
		src << sound(null, repeat = 0, wait = 0, volume = 0, channel = 2)
	feedback_add_details("admin_verb", "TAmbi") // If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

//be special
/client/verb/toggle_be_special(role in GLOBL.be_special_flags)
	set category = PANEL_PREFERENCES
	set name = "Toggle SpecialRole Candidacy"
	set desc = "Toggles which special roles you would like to be a candidate for, during events."

	var/role_flag = GLOBL.be_special_flags[role]
	if(!role_flag)
		return

	prefs.be_special ^= role_flag
	prefs.save_preferences()

	to_chat(src, "You will [(prefs.be_special & role_flag) ? "now" : "no longer"] be considered for [role] events (where possible).")
	feedback_add_details("admin_verb", "TBeSpecial") // If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/change_ui()
	set category = PANEL_PREFERENCES
	set name = "Change UI"
	set desc = "Configure your user interface."

	if(!ishuman(usr))
		to_chat(usr, "This is only for human mobs.")
		return
	var/mob/living/carbon/human/user = usr

	var/UI_style_new = input(user, "Select a style, we recommend White for customization.") in list("White", "Midnight", "Orange", "old")
	if(isnull(UI_style_new))
		return

	var/UI_style_alpha_new = input(user, "Select a new alpha(transparency) parameter for UI, between 50 and 255.") as num
	if(isnull(UI_style_alpha_new) || !(UI_style_alpha_new <= 255 && UI_style_alpha_new >= 50))
		return

	var/UI_style_color_new = input(user, "Choose your UI color, dark colors are not recommended!") as color|null
	if(isnull(UI_style_color_new))
		return

	//update UI
	var/list/icons = user.hud_used.adding + user.hud_used.other + user.hud_used.hotkeybuttons
	icons.Add(user.zone_sel)

	for(var/atom/movable/screen/I in icons)
		if(I.color && I.alpha)
			I.icon = ui_style2icon(UI_style_new)
			I.color = UI_style_color_new
			I.alpha = UI_style_alpha_new

	if(alert("Like it? Save changes?", ,"Yes", "No") == "Yes")
		prefs.UI_style = UI_style_new
		prefs.UI_style_alpha = UI_style_alpha_new
		prefs.UI_style_color = UI_style_color_new
		prefs.save_preferences()
		to_chat(user, "UI was saved.")