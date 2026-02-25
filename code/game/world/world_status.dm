// Hub status updates.
/world/proc/update_status()
	var/list/status_list = list()

	var/server_name = CONFIG_GET(/decl/configuration_entry/server_name)
	if(isnotnull(server_name))
		status_list.Add("<b>[server_name]</b> &#8212; ")

	status_list.Add("<b>[station_name()]</b>")
	status_list.Add(" (")
	status_list.Add("<a href='[CONFIG_GET(/decl/configuration_entry/hub_url)]'>[GLOBL.game_version]</a>")
	status_list.Add(")")

	var/list/features = list()

	if(isnotnull(global.PCticker?.master_mode))
		features.Add(global.PCticker.master_mode)
	else
		features.Add("<b>STARTING</b>")

	if(!GLOBL.enter_allowed)
		features.Add("closed")

	features.Add(CONFIG_GET(/decl/configuration_entry/respawn) ? "respawn" : "no respawn")

	if(CONFIG_GET(/decl/configuration_entry/allow_vote_mode))
		features.Add("vote")

	if(CONFIG_GET(/decl/configuration_entry/allow_ai))
		features.Add("AI allowed")

	var/n = 0
	for_no_type_check(var/mob/M, GLOBL.player_list)
		if(isnotnull(M.client))
			n++

	if(n > 1)
		features.Add("~[n] players")
	else if(n > 0)
		features.Add("~[n] player")

	/*
	is there a reason for this? the byond site shows 'hosted by X' when there is a proper host already.
	if(host)
		features.Add("hosted by <b>[host]</b>")
	*/

	var/hostedby = CONFIG_GET(/decl/configuration_entry/hostedby)
	if(isnull(host) && isnotnull(hostedby))
		features.Add("hosted by <b>[hostedby]</b>")

	if(isnotnull(features))
		status_list.Add(": [jointext(features, ", ")]")

	/* does this help? I do not know */
	var/s = jointext(status_list, "")
	if(status != s)
		status = s