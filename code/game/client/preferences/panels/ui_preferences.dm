/datum/preferences/proc/ui_preferences_panel(mob/user)
	var/html = "<div align='center'>"
	html += "<b>UI Preferences</b>"
	html += "<hr>"

	html += "<b>UI Style:</b> <a href='byond://?_src_=prefs;preference=uipreferences;task=ui'><b>[UI_style]</b></a>"
	html += "<br>"
	html += "<b>Custom UI</b>"
	html += "<br>"
	html += "(Recommended for White UI)"
	html += "<br>"
	html += "Color: <a href='byond://?_src_=prefs;preference=uipreferences;task=UIcolor'><b>[UI_style_color]</b></a> <font face='fixedsys' size='3' color='[UI_style_color]'><table style='display:inline;' bgcolor='[UI_style_color]'><tr><td>__</td></tr></font></table>"
	html += "<br>"
	html += "Alpha (transparency): <a href='byond://?_src_=prefs;preference=uipreferences;task=UIalpha'><b>[UI_style_alpha]</b></a>"
	html += "<br>"
	html += "<b>Screentips:</b> <a href='byond://?_src_=prefs;preference=uipreferences;task=screentip_pref'>[screentip_pref ? "Enabled" : "Disabled"]</a>"
	html += "<br>"
	html += "<b>Screentip Colour:</b> <span style='border:1px solid #161616; background-color: [screentip_colour];'>&nbsp;&nbsp;&nbsp;</span> <a href='byond://?_src_=prefs;preference=uipreferences;task=screentip_colour'>Change</a>"
	html += "<hr>"

	html += "<b>Play admin midis:</b> <a href='byond://?_src_=prefs;preference=uipreferences;task=hear_midis'><b>[(toggles & SOUND_MIDI) ? "Yes" : "No"]</b></a>"
	html += "<br>"
	html += "<b>Play lobby music:</b> <a href='byond://?_src_=prefs;preference=uipreferences;task=lobby_music'><b>[(toggles & SOUND_LOBBY) ? "Yes" : "No"]</b></a>"
	html += "<br>"
	html += "<b>Ghost ears:</b> <a href='byond://?_src_=prefs;preference=uipreferences;task=ghost_ears'><b>[(toggles & CHAT_GHOSTEARS) ? "All Speech" : "Nearest Creatures"]</b></a>"
	html += "<br>"
	html += "<b>Ghost sight:</b> <a href='byond://?_src_=prefs;preference=uipreferences;task=ghost_sight'><b>[(toggles & CHAT_GHOSTSIGHT) ? "All Emotes" : "Nearest Creatures"]</b></a>"
	html += "<br>"
	html += "<b>Ghost radio:</b> <a href='byond://?_src_=prefs;preference=uipreferences;task=ghost_radio'><b>[(toggles & CHAT_GHOSTRADIO) ? "All Chatter" : "Nearest Speakers"]</b></a>"

	html += "<hr>"
	html += "<a href='byond://?src=\ref[user];preference=uipreferences;task=close'>\[Done\]</a>"
	html += "</div>"

	var/datum/browser/panel = new /datum/browser(user, "uipreferences", "", 300, 360)
	panel.set_content(html)
	panel.open()

/datum/preferences/proc/process_ui_preferences_panel(mob/user, list/href_list)
	switch(href_list["task"])
		if("open")
			ui_preferences_panel(user)
		if("close")
			user << browse(null, "window=uipreferences")
			character_setup_panel(user)

		if("ui")
			switch(UI_style)
				if("Midnight")
					UI_style = "Orange"
				if("Orange")
					UI_style = "old"
				if("old")
					UI_style = "White"
				else
					UI_style = "Midnight"

		if("UIcolor")
			var/UI_style_color_new = input(user, "Choose your UI color, dark colors are not recommended!") as color | null
			if(!UI_style_color_new)
				return
			UI_style_color = UI_style_color_new

		if("UIalpha")
			var/UI_style_alpha_new = input(user, "Select a new alpha(transparency) parameter for UI, between 50 and 255.") as num
			if(!UI_style_alpha_new || !(UI_style_alpha_new <= 255 && UI_style_alpha_new >= 50))
				return
			UI_style_alpha = UI_style_alpha_new

		if("screentip_pref")
			screentip_pref = !screentip_pref
			ui_preferences_panel(user)
		if("screentip_colour")
			var/picked_screentip_colour = input(user, "Choose your screentip colour.", "General Preference", screentip_colour) as color | null
			if(isnotnull(picked_screentip_colour))
				screentip_colour = picked_screentip_colour
				ui_preferences_panel(user)

		if("hear_midis")
			toggles ^= SOUND_MIDI

		if("lobby_music")
			toggles ^= SOUND_LOBBY
			if(toggles & SOUND_LOBBY)
				global.PCticker.lobby_music.play(user)
			else
				global.PCticker.lobby_music.stop(user)

		if("ghost_ears")
			toggles ^= CHAT_GHOSTEARS

		if("ghost_sight")
			toggles ^= CHAT_GHOSTSIGHT

		if("ghost_radio")
			toggles ^= CHAT_GHOSTRADIO

	return 1