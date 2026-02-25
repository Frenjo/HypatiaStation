// The two procs below are ported from Bay12.
/proc/generate_asset_name(file)
	return "asset.[md5(fcopy_rsc(file))]"

/proc/icon2html(thing, target, icon_state, dir, frame = 1, moving = FALSE, realsize = FALSE, class = null)
	if(isnull(thing))
		return

	var/icon/I = thing
	if(isnull(target))
		return
	if(target == world)
		target = GLOBL.clients

	var/list/targets
	if(!islist(target))
		targets = list(target)
	else
		targets = target
		if(!targets.len)
			return
	if(!isicon(I))
		if(isfile(thing)) //special snowflake
			var/name = "[generate_asset_name(thing)].png"
			for(var/thing2 in targets)
				SEND_RSC(thing2, thing, name)
			return "<img class='icon icon-misc [class]' src=\"[url_encode(name)]\">"
		var/atom/A = thing
		if(isnull(dir))
			dir = A.dir
		if(isnull(icon_state))
			icon_state = A.icon_state
		I = A.icon
		if(ishuman(thing)) // Shitty workaround for a BYOND issue.
			var/icon/temp = I
			I = icon()
			I.Insert(temp, dir = SOUTH)
			dir = SOUTH
	else
		if(isnull(dir))
			dir = SOUTH
		if(isnull(icon_state))
			icon_state = ""

	I = icon(I, icon_state, dir, frame, moving)

	var/name = "[generate_asset_name(I)].png"
	for(var/thing2 in targets)
		SEND_RSC(thing2, I, name)

	if(realsize)
		return "<img class='icon icon-[icon_state] [class]' style='width:[I.Width()]px;height:[I.Height()]px;min-height:[I.Height()]px' src=\"[url_encode(name)]\">"
	return "<img class='icon icon-[icon_state] [class]' style='width:16px;height:16px' src=\"[url_encode(name)]\">"