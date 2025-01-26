/datum/progressbar
	var/goal = 1
	var/image/bar
	var/shown = 0
	var/mob/user
	var/client/client

/datum/progressbar/New(mob/user, goal_number, atom/target)
	. = ..()
	if(isnull(target))
		target = user
	if(!istype(target))
		EXCEPTION("Invalid target given")
	if(goal_number)
		goal = goal_number
	bar = image('icons/effects/progessbar.dmi', target, "prog_bar_0")
	bar.plane = HUD_PLANE
	bar.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	bar.pixel_y = 32
	src.user = user
	if(isnotnull(user))
		client = user.client

/datum/progressbar/Destroy()
	if(isnotnull(client))
		client.images.Remove(bar)
	QDEL_NULL(bar)
	return ..()

/datum/progressbar/proc/update(progress)
	if(isnull(user) || isnull(user.client))
		shown = FALSE
		return
	if(user.client != client)
		if(isnotnull(client))
			client.images.Remove(bar)
		if(isnotnull(user.client))
			user.client.images.Add(bar)

	progress = clamp(progress, 0, goal)
	bar.icon_state = "prog_bar_[round(((progress / goal) * 100), 5)]"
	if(!shown)
		user.client.images.Add(bar)
		shown = TRUE