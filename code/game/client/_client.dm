/client
	/*
	 * This line sets /client's parent type to be /datum.
	 *
	 * By default in BYOND if you define a proc on /datum, that proc will exist on nearly every single type
	 * from /icon to /image to /atom to /mob to /obj to /turf to /area, it won't however, appear on /client.
	 *
	 * Instead by default they act like their own independent type, so while you can do isdatum(icon)
	 * and have it return true, you can't do isdatum(client), it will always return false.
	 *
	 * This makes writing object-oriented code hard when you have to consider this extra special case.
	 *
	 * This line prevents that, and has never appeared to cause any ill effects, while saving us an extra
	 * pain to think about.
	 *
	 * This line is widely considered black fucking magic, and the fact it works is a puzzle to everyone
	 * involved, including the current engine developer, Lummox.
	 *
	 * If you are a future developer and the engine source is now available and you can explain why this
	 * is the way it is, please do update this comment.
	*/
	parent_type = /datum

	// This is FALSE so we can set it to a URL once the player logs in and have them download the resources from a different server.
	preload_rsc = FALSE

	/*
	 * Admin Things
	 */
	// Holder for admin info, null if the client isn't an admin.
	var/datum/admins/holder = null
	var/buildmode = 0

	// Contains the last message sent by this client - used to protect against copy-paste spamming.
	var/last_message = ""
	// Contains the number of times a message identical to last_message was sent.
	var/last_message_count = 0

	/*
	 * Other
	 */
	// Player preferences datum for the client.
	var/datum/preferences/prefs = null
	var/move_delay = 1
	var/moving = FALSE
	var/adminobs = FALSE
	// When the client last died as a mouse.
	var/time_died_as_mouse = null

	/*
	 * Sound Stuff
	 */
	var/ambience_playing = FALSE
	var/played = 0

	/*
	 * Security
	 */
	var/next_allowed_topic_time = 10
	// comment out the line below when debugging locally to enable the options & messages menu
	//control_freak = 1

	/*
	 * Viewport
	 */
	VAR_PRIVATE/static/list/scaling_modes = list(SCALING_MODE_NORMAL, SCALING_MODE_DISTORT, SCALING_MODE_BLUR)
	var/chosen_scaling_mode = SCALING_MODE_DISTORT

	/*
	 * Things That Require The Database
	 */
	// These have default values so admins know why they aren't working.
	// Used to determine how old the account is, in days.
	var/player_age = "Requires database"
	// Used to determine what other accounts previously logged in from this ip.
	var/related_accounts_ip = "Requires database"
	// Used to determine what other accounts previously logged in from this computer id.
	var/related_accounts_cid = "Requires database"

// Checks if a client is afk.
// Default is 3000 frames, or 5 minutes.
/client/proc/is_afk(duration = 5 MINUTES)
	if(inactivity > duration)
		return inactivity
	return 0