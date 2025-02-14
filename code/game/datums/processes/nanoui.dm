/*
 * NanoUI Process
 *
 * This also includes the functionality of the "NanoManager", the window/UI manager for NanoUIs.
 */
PROCESS_DEF(nanoui)
	name = "NanoUI"
	schedule_interval = 2 SECONDS

	// A list of current open /datum/nanoui UIs, grouped by src_object and ui_key.
	var/list/open_uis = list()
	// A list of current open /datum/nanoui UIs, not grouped, for use in processing.
	var/list/datum/nanoui/processing_uis = list()

/datum/process/nanoui/do_work()
	for_no_type_check(var/datum/nanoui/ui, processing_uis)
		if(!GC_DESTROYED(ui))
			try
				ui.process()
			catch(var/exception/e)
				catch_exception(e, ui)
		else
			catch_bad_type(ui)
			processing_uis.Remove(ui)

/datum/process/nanoui/stat_entry()
	return list("[length(processing_uis)] UIs")

/*
 * Gets an open /datum/nanoui for the current user, src_object and ui_key and tries to update it with data.
 *
 * @param user /mob The mob who opened/owns the UI.
 * @param src_object /obj|/mob The obj or mob which the UI belongs to.
 * @param ui_key string A string key used for the UI.
 * @param ui /datum/nanoui An existing instance of the UI (can be null).
 * @param data list The data to be passed to the UI, if it exists.
 *
 * @return /datum/nanoui Returns the found UI, for null if none exists.
 */
/datum/process/nanoui/proc/try_update_ui(mob/user, src_object, ui_key, datum/nanoui/ui, list/data)
	RETURN_TYPE(/datum/nanoui)

	if(isnull(ui)) // no UI has been passed, so we'll search for one
		ui = get_open_ui(user, src_object, ui_key)
	if(isnotnull(ui))
		// The UI is already open so push the data to it
		ui.push_data(data)
		return ui
	return null

/*
 * Gets an open /datum/nanoui for the current user, src_object and ui_key.
 *
 * @param user /mob The mob who opened/owns the UI.
 * @param src_object /obj|/mob The obj or mob which the UI belongs to.
 * @param ui_key string A string key used for the UI.
 *
 * @return /datum/nanoui Returns the found UI, or null if none exists.
 */
/datum/process/nanoui/proc/get_open_ui(mob/user, src_object, ui_key)
	RETURN_TYPE(/datum/nanoui)

	if(isnull(open_uis[src_object]) || !islist(open_uis[src_object]))
		return null
	else if(isnull(open_uis[src_object][ui_key]) || !islist(open_uis[src_object][ui_key]))
		return null

	for_no_type_check(var/datum/nanoui/ui, open_uis[src_object][ui_key])
		if(ui.user == user)
			return ui

	return null

/*
 * Updates all /datum/nanoui UIs attached to src_object.
 *
 * @param src_object /obj|/mob The obj or mob which the UIs are attached to.
 *
 * @return int The number of UIs updated.
 */
/datum/process/nanoui/proc/update_uis(src_object)
	if(isnull(open_uis[src_object]) || !islist(open_uis[src_object]))
		return 0

	var/update_count = 0
	for(var/ui_key in open_uis[src_object])
		for_no_type_check(var/datum/nanoui/ui, open_uis[src_object][ui_key])
			if(isnull(ui))
				continue
			if(isnotnull(ui.src_object) && isnotnull(ui.user))
				ui.process(1)
				update_count++
	return update_count

/*
 * Updates /datum/nanoui UIs belonging to user.
 *
 * @param user /mob The mob who owns the UIs.
 * @param src_object /obj|/mob If src_object is provided, only update UIs which are attached to src_object (optional).
 * @param ui_key string If ui_key is provided, only update UIs with a matching ui_key (optional).
 *
 * @return int The number of UIs updated.
 */
/datum/process/nanoui/proc/update_user_uis(mob/user, src_object = null, ui_key = null)
	if(isnull(user.open_uis) || !islist(user.open_uis) || !length(open_uis))
		return 0 // has no open UIs

	var/update_count = 0
	for_no_type_check(var/datum/nanoui/ui, user.open_uis)
		if((isnull(src_object) || (isnotnull(src_object) && ui.src_object == src_object)) && (isnull(ui_key) || (isnotnull(ui_key) && ui.ui_key == ui_key)))
			ui.process(TRUE)
			update_count++

	return update_count

/**
 * Closes /datum/nanoui UIs belonging to user.
 *
 * @param user /mob The mob who owns the UIs.
 * @param src_object /obj|/mob If src_object is provided, only close UIs which are attached to src_object (optional).
 * @param ui_key string If ui_key is provided, only close UIs with a matching ui_key (optional).
 *
 * @return int The number of UIs closed.
 */
/datum/process/nanoui/proc/close_user_uis(mob/user, src_object = null, ui_key = null)
	if(isnull(user.open_uis) || !islist(user.open_uis) || !length(open_uis))
		return 0 // has no open uis

	var/close_count = 0
	for_no_type_check(var/datum/nanoui/ui, user.open_uis)
		if((isnull(src_object) || (isnotnull(src_object) && ui.src_object == src_object)) && (isnull(ui_key) || (isnotnull(ui_key) && ui.ui_key == ui_key)))
			ui.close()
			close_count++

	return close_count

/**
 * Adds a /datum/nanoui UI to the list of open UIs.
 * This is called by the /datum/nanoui/proc/open().
 *
 * @param ui /datum/nanoui The UI to add.
 *
 * @return nothing.
 */
/datum/process/nanoui/proc/ui_opened(datum/nanoui/ui)
	var/src_object = ui.src_object
	if(isnull(open_uis[src_object]) || !islist(open_uis[src_object]))
		open_uis[src_object] = list(ui.ui_key = list())
	else if(isnull(open_uis[src_object][ui.ui_key]) || !islist(open_uis[src_object][ui.ui_key]))
		open_uis[src_object][ui.ui_key] = list()

	ui.user.open_uis.Add(ui)
	var/list/uis = open_uis[src_object][ui.ui_key]
	uis.Add(ui)
	processing_uis.Add(ui)

/*
 * Removes a /datum/nanoui from the list of open UIs.
 * This is called by /datum/nanoui/proc/close().
 *
 * @param ui /datum/nanoui The UI to remove.
 *
 * @return boolean FALSE if no UI was removed, TRUE if removed successfully
 */
/datum/process/nanoui/proc/ui_closed(datum/nanoui/ui)
	var/src_object = ui.src_object
	if(isnull(open_uis[src_object]) || !islist(open_uis[src_object]))
		return FALSE // wasn't open
	else if(isnull(open_uis[src_object][ui.ui_key]) || !islist(open_uis[src_object][ui.ui_key]))
		return FALSE // wasn't open

	processing_uis.Remove(ui)
	ui.user.open_uis.Remove(ui)
	var/list/uis = open_uis[src_object][ui.ui_key]
	return uis.Remove(ui)

/*
 * Closes/clears all UIs attached to the user's /mob.
 * This is called on user logout.
 *
 * @param user /mob The user's mob.
 *
 * @return nothing.
 */
/datum/process/nanoui/proc/user_logout(mob/user)
	return close_user_uis(user)

/*
 * Transfers all open UIs to the new mob.
 * This is called when a player transfers from one mob to another.
 *
 * @param oldMob /mob The user's old mob.
 * @param newMob /mob The user's new mob.
 *
 * @return nothing.
 */
/datum/process/nanoui/proc/user_transferred(mob/oldMob, mob/newMob)
	if(isnull(oldMob.open_uis) || !islist(oldMob.open_uis) || !length(open_uis))
		return 0 // has no open uis

	if(isnull(newMob.open_uis) || !islist(newMob.open_uis))
		newMob.open_uis = list()

	for_no_type_check(var/datum/nanoui/ui, oldMob.open_uis)
		ui.user = newMob
		newMob.open_uis.Add(ui)

	oldMob.open_uis.Cut()

	return 1 // success

/*
 * Sends all nano assets to the client.
 * This is called on user login.
 *
 * @param client /client The user's client.
 *
 * @return nothing.
 */
/datum/process/nanoui/proc/send_resources(client)
	var/list/nano_asset_dirs = list(
		"nano/css/",
		"nano/images/",
		"nano/js/",
		"nano/templates/"
	)

	var/list/files = null
	for(var/path in nano_asset_dirs)
		files = flist(path)
		for(var/file in files)
			if(copytext(file, length(file)) != "/") // files which end in "/" are actually directories, which we want to ignore
				client << browse_rsc(file(path + file))	// send the file to the client