/*
 * AI Takeover (System Override)
 */
/datum/game_mode/malfunction/proc/takeover()
	set category = PANEL_MALFUNCTION
	set name = "System Override"
	set desc = "Start the victory timer."

	if(!IS_GAME_MODE(/datum/game_mode/malfunction))
		to_chat(usr, "You cannot begin a takeover in this round type!.")
		return
	var/datum/game_mode/malfunction/malf = global.PCticker.mode
	if(malf.malf_mode_declared)
		to_chat(usr, "You've already begun your takeover.")
		return
	if(malf.apcs < 3)
		to_chat(usr, "You don't have enough hacked APCs to take over the station yet. You need to hack at least 3, however hacking more will make the takeover faster. You have hacked [malf.apcs] APCs so far.")
		return

	if(alert(usr, "Are you sure you wish to initiate the takeover? The station hostile runtime detection software is bound to alert everyone. You have hacked [malf.apcs] APCs.", "Takeover:", "Yes", "No") != "Yes")
		return

	command_alert("Hostile runtimes detected in all station systems, please deactivate your AI to prevent possible damage to its morality core.", "Anomaly Alert")
	set_security_level(/decl/security_level/delta)

	malf.malf_mode_declared = TRUE
	for(var/datum/mind/ai_mind in malf.malf_ai)
		ai_mind.current.verbs.Remove(/datum/game_mode/malfunction/proc/takeover)
	for_no_type_check(var/mob/M, GLOBL.player_list)
		if(!isnewplayer(M))
			M << sound('sound/AI/aimalf.ogg')

/*
 * AI Win (Explode)
 */
/datum/game_mode/malfunction/proc/ai_win()
	set category = PANEL_MALFUNCTION
	set name = "Explode"
	set desc = "Destroy the station."

	if(!IS_GAME_MODE(/datum/game_mode/malfunction))
		to_chat(usr, "You cannot blow up the station in this round type!.")
		return

	var/datum/game_mode/malfunction/malf = global.PCticker.mode
	if(!malf.to_nuke_or_not_to_nuke)
		return
	malf.to_nuke_or_not_to_nuke = FALSE
	for(var/datum/mind/ai_mind in malf.malf_ai)
		ai_mind.current.verbs.Remove(/datum/game_mode/malfunction/proc/ai_win)
	malf.explosion_in_progress = TRUE
	for_no_type_check(var/mob/M, GLOBL.player_list)
		M << 'sound/machines/Alarm.ogg'
	to_world("Self-destructing in 10...")
	for(var/i = 9 to 1 step -1)
		sleep(10)
		to_world(i + "...")
	sleep(10)
	GLOBL.enter_allowed = FALSE
	global.PCticker.station_explosion_cinematic(0, null)
	malf.station_was_nuked = TRUE
	malf.explosion_in_progress = FALSE