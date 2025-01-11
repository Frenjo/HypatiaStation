// Updates the screentip to reflect what we're hovering over.
/atom/MouseEntered(location, control, params)
	. = ..()
	var/client/client = usr?.client
	var/datum/hud/active_hud = client?.mob?.hud_used
	if(isnotnull(active_hud))
		if(!client.prefs.screentip_pref || HAS_ATOM_FLAGS(src, ATOM_FLAG_NO_SCREENTIP))
			active_hud.screentip_text.maptext = ""
		else
			active_hud.screentip_text.maptext = "<span style='text-align: center; font-size: 12px; color: [client?.prefs?.screentip_colour]'>[name]</span>"