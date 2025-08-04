/*
 * Output Macros
 */
#define SHOW_BROWSER(TARGET, CONTENT, OPTIONS) TARGET << browse(CONTENT, OPTIONS)
#define CLOSE_BROWSER(TARGET, NAME) TARGET << browse(null, NAME)
#define SEND_RSC(TARGET, CONTENT, NAME) TARGET << browse_rsc(CONTENT, NAME)
#define OPEN_LINK(TARGET, URL) TARGET << link(URL)
#define OPEN_FILE(TARGET, FILE) TARGET << run(FILE)

/proc/generate_asset_name(file)
	return "asset.[md5(fcopy_rsc(file))]"

/proc/icon2html(thing, target, icon_state, dir, frame = 1, moving = FALSE, realsize = FALSE, class = null)
	if(!thing)
		return

	var/icon/I = thing
	if(!target)
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
		if(istype(thing, /mob/living/carbon/human)) // Shitty workaround for a BYOND issue.
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
	return "<img class='icon icon-[icon_state] [class]' src=\"[url_encode(name)]\">"

/proc/to_chat(atom/target, message)
	target << message

/proc/to_world(message)
	for_no_type_check(var/client/C, GLOBL.clients)
		to_chat(C, message)