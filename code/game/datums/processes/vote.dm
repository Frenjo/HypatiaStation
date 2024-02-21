/*
 * Voting Process
 */
PROCESS_DEF(vote)
	name = "Vote"
	schedule_interval = 1 SECOND

	var/static/list/round_voters = list() // Keeps track of the individuals voting for a given round, for use in forcedrafting.

	var/initiator = null
	var/started_time = null
	var/time_remaining = 0
	var/mode = null
	var/question = null
	var/list/choices = list()
	var/list/voted = list()
	var/list/voting = list()
	var/list/current_votes = list()
	var/auto_muted = 0

/datum/process/vote/do_work()
	if(isnotnull(mode))
		// No more change mode votes after the game has started.
		// 3 is GAME_STATE_PLAYING, but that #define is undefined for some reason
		if(mode == "gamemode" && global.CTticker.current_state >= 2)
			to_world("<b>Voting aborted due to game start.</b>")
			src.reset()
			return

		// Calculate how much time is remaining by comparing current time, to time of vote start,
		// plus vote duration
		time_remaining = round((started_time + CONFIG_GET(vote_period) - world.time) / 10)
		if(time_remaining < 0)
			result()
			for(var/client/C in voting)
				if(C)
					C << browse(null, "window=vote;can_close=0")
			reset()
		else
			for(var/client/C in voting)
				if(C)
					C << browse(interface(C), "window=vote;can_close=0")
			voting.Cut()

/datum/process/vote/proc/autotransfer()
	initiate_vote("crew_transfer", "the server")
	log_debug("The server has called a crew transfer vote")

/*
/datum/process/vote/proc/autogamemode() //This is here for whoever can figure out how to make this work
	initiate_vote("gamemode","the server")
	log_debug("The server has called a gamemode vote")
*/

/datum/process/vote/proc/reset()
	initiator = null
	time_remaining = 0
	mode = null
	question = null
	choices.Cut()
	voted.Cut()
	voting.Cut()
	current_votes.Cut()

/*
	if(auto_muted && !ooc_allowed)
		auto_muted = 0
		ooc_allowed = !( ooc_allowed )
		to_world("<b>The OOC channel has been automatically enabled due to vote end.</b>")
		log_admin("OOC was toggled automatically due to vote end.")
		message_admins("OOC has been toggled on automatically.")
*/

/datum/process/vote/proc/get_result()
	//get the highest number of votes
	var/greatest_votes = 0
	var/total_votes = 0
	for(var/option in choices)
		var/votes = choices[option]
		total_votes += votes
		if(votes > greatest_votes)
			greatest_votes = votes
	//default-vote for everyone who didn't vote
	if(!CONFIG_GET(vote_no_default) && length(choices))
		var/non_voters = (length(GLOBL.clients) - total_votes)
		if(non_voters > 0)
			if(mode == "restart")
				choices["Continue Playing"] += non_voters
				if(choices["Continue Playing"] >= greatest_votes)
					greatest_votes = choices["Continue Playing"]
			else if(mode == "gamemode")
				if(global.CTticker.master_mode in choices)
					choices[global.CTticker.master_mode] += non_voters
					if(choices[global.CTticker.master_mode] >= greatest_votes)
						greatest_votes = choices[global.CTticker.master_mode]
			else if(mode == "crew_transfer")
				var/factor = 0.5
				switch(world.time / (10 * 60)) // minutes
					if(0 to 60)
						factor = 0.5
					if(61 to 120)
						factor = 0.8
					if(121 to 240)
						factor = 1
					if(241 to 300)
						factor = 1.2
					else
						factor = 1.4
				choices["Initiate Crew Transfer"] = round(choices["Initiate Crew Transfer"] * factor)
				to_world("<font color='purple'>Crew Transfer Factor: [factor]</font>")
				greatest_votes = max(choices["Initiate Crew Transfer"], choices["Continue The Round"])

	//get all options with that many votes and return them in a list
	. = list()
	if(greatest_votes)
		for(var/option in choices)
			if(choices[option] == greatest_votes)
				. += option
	return .

/datum/process/vote/proc/announce_result()
	var/list/winners = get_result()
	var/text
	if(length(winners))
		if(length(winners) > 1)
			if(mode != "gamemode" || !global.CTticker.hide_mode) // Here we are making sure we don't announce potential game modes
				text = "<b>Vote Tied Between:</b>\n"
				for(var/option in winners)
					text += "\t[option]\n"
		. = pick(winners)

		for(var/key in current_votes)
			if(choices[current_votes[key]] == .)
				round_voters += key // Keep track of who voted for the winning round.
		if((mode == "gamemode" && . == "extended") || !global.CTticker.hide_mode) // Announce Extended gamemode, but not other gamemodes
			text += "<b>Vote Result: [.]</b>"
		else
			if(mode != "gamemode")
				text += "<b>Vote Result: [.]</b>"
			else
				text += "<b>The vote has ended.</b>" // What will be shown if it is a gamemode vote that isn't extended

	else
		text += "<b>Vote Result: Inconclusive - No Votes!</b>"
	log_vote(text)
	to_world("<font color='purple'>[text]</font>")
	return .

/datum/process/vote/proc/result()
	. = announce_result()
	var/restart = 0
	if(.)
		switch(mode)
			if("restart")
				if(. == "Restart Round")
					restart = 1
			if("gamemode")
				if(global.CTticker.master_mode != .)
					world.save_mode(.)
					if(isnotnull(global.CTticker?.mode))
						restart = 1
					else
						global.CTticker.master_mode = .
			if("crew_transfer")
				if(. == "Initiate Crew Transfer")
					init_shift_change(null, 1)

	if(mode == "gamemode") //fire this even if the vote fails.
		if(!global.CTticker.roundstart_progressing)
			global.CTticker.roundstart_progressing = TRUE
			to_world("<font color='red'><b>The round will start soon.</b></font>")

	if(restart)
		to_world("World restarting due to vote...")
		feedback_set_details("end_error", "restart vote")
		blackbox?.save_all_data_to_sql()
		sleep(50)
		log_game("Rebooting due to restart vote")
		world.Reboot()

	return .

/datum/process/vote/proc/submit_vote(ckey, vote)
	if(isnotnull(mode))
		if(CONFIG_GET(vote_no_dead) && usr.stat == DEAD && isnull(usr.client.holder))
			return 0
		if(isnotnull(current_votes[ckey]))
			choices[choices[current_votes[ckey]]]--
		if(vote && 1 <= vote && vote <= length(choices))
			voted.Add(usr.ckey)
			choices[choices[vote]]++	//check this
			current_votes[ckey] = vote
			return vote
	return 0

/datum/process/vote/proc/initiate_vote(vote_type, initiator_key)
	if(isnull(mode))
		if(started_time != null && !check_rights(R_ADMIN))
			var/next_allowed_time = (started_time + CONFIG_GET(vote_delay))
			if(next_allowed_time > world.time)
				return 0

		reset()
		switch(vote_type)
			if("restart")
				choices.Add("Restart Round", "Continue Playing")
			if("gamemode")
				if(global.CTticker.current_state >= GAME_STATE_SETTING_UP)
					return 0
				choices.Add(CONFIG_GET_OLD(votable_modes))
			if("crew_transfer")
				if(check_rights(R_ADMIN | R_MOD, 0))
					question = "End the shift?"
					choices.Add("Initiate Crew Transfer", "Continue The Round")
				else
					if(!GLOBL.security_level.can_call_transfer)
						to_chat(initiator_key, "The current alert status is too high to call for a crew transfer!")
						return 0
					if(global.CTticker.current_state <= GAME_STATE_SETTING_UP)
						to_chat(initiator_key, "The crew transfer button has been disabled!")
						return 0
					question = "End the shift?"
					choices.Add("Initiate Crew Transfer", "Continue The Round")
			if("custom")
				question = html_encode(input(usr, "What is the vote for?") as text | null)
				if(isnull(question))
					return 0
				for(var/i = 1, i <= 10, i++)
					var/option = capitalize(html_encode(input(usr, "Please enter an option or hit cancel to finish") as text | null))
					if(!option || mode || !usr.client)
						break
					choices.Add(option)
			else
				return 0
		mode = vote_type
		initiator = initiator_key
		started_time = world.time
		var/text = "[capitalize(mode)] vote started by [initiator]."
		if(mode == "custom")
			text += "\n[question]"

		log_vote(text)
		to_world("<font color='purple'><b>[text]</b>\nType vote to place your votes.\nYou have [CONFIG_GET(vote_period) / 10] seconds to vote.</font>")
		switch(vote_type)
			if("crew_transfer")
				world << sound('sound/ambience/alarm4.ogg')
			if("gamemode")
				world << sound('sound/ambience/alarm4.ogg')
			if("custom")
				world << sound('sound/ambience/alarm4.ogg')
		if(mode == "gamemode" && global.CTticker.roundstart_progressing)
			global.CTticker.roundstart_progressing = FALSE
			to_world(SPAN_DANGER("Round start has been delayed."))
	/*
		if(mode == "crew_transfer" && ooc_allowed)
			auto_muted = 1
			ooc_allowed = !( ooc_allowed )
			to_world("<b>The OOC channel has been automatically disabled due to a crew transfer vote.</b>")
			log_admin("OOC was toggled automatically due to crew_transfer vote.")
			message_admins("OOC has been toggled off automatically.")
		if(mode == "gamemode" && ooc_allowed)
			auto_muted = 1
			ooc_allowed = !( ooc_allowed )
			to_world("<b>The OOC channel has been automatically disabled due to the gamemode vote.</b>")
			log_admin("OOC was toggled automatically due to gamemode vote.")
			message_admins("OOC has been toggled off automatically.")
		if(mode == "custom" && ooc_allowed)
			auto_muted = 1
			ooc_allowed = !( ooc_allowed )
			to_world("<b>The OOC channel has been automatically disabled due to a custom vote.</b>")
			log_admin("OOC was toggled automatically due to custom vote.")
			message_admins("OOC has been toggled off automatically.")
	*/

		time_remaining = round(CONFIG_GET(vote_period) / 10)
		return 1
	return 0

/datum/process/vote/proc/interface(client/C)
	if(isnull(C))
		return
	var/admin = FALSE
	var/trialmin = FALSE
	if(isnotnull(C.holder))
		admin = TRUE
		if(C.holder.rights & R_ADMIN)
			trialmin = TRUE
	voting |= C

	. = "<html><head><title>Voting Panel</title></head><body>"
	if(isnotnull(mode))
		if(isnotnull(question))
			. += "<h2>Vote: '[question]'</h2>"
		else
			. += "<h2>Vote: [capitalize(mode)]</h2>"
		. += "Time Left: [time_remaining] s<hr><ul>"
		for(var/i = 1, i <= length(choices), i++)
			var/votes = choices[choices[i]]
			if(!votes)
				votes = 0
			if(current_votes[C.ckey] == i)
				. += "<li><b><a href='?src=\ref[src];vote=[i]'>[choices[i]] ([votes] votes)</a></b></li>"
			else
				. += "<li><a href='?src=\ref[src];vote=[i]'>[choices[i]] ([votes] votes)</a></li>"

		. += "</ul><hr>"
		if(admin)
			. += "(<a href='?src=\ref[src];vote=cancel'>Cancel Vote</a>) "
	else
		. += "<h2>Start a vote:</h2><hr><ul><li>"
		//restart
		if(trialmin || CONFIG_GET(allow_vote_restart))
			. += "<a href='?src=\ref[src];vote=restart'>Restart</a>"
		else
			. += "<font color='grey'>Restart (Disallowed)</font>"
		. += "</li><li>"
		if(trialmin || CONFIG_GET(allow_vote_restart))
			. += "<a href='?src=\ref[src];vote=crew_transfer'>Crew Transfer</a>"
		else
			. += "<font color='grey'>Crew Transfer (Disallowed)</font>"
		if(trialmin)
			. += "\t(<a href='?src=\ref[src];vote=toggle_restart'>[CONFIG_GET(allow_vote_restart) ? "Allowed" : "Disallowed"]</a>)"
		. += "</li><li>"
		//gamemode
		if(trialmin || CONFIG_GET(allow_vote_mode))
			. += "<a href='?src=\ref[src];vote=gamemode'>GameMode</a>"
		else
			. += "<font color='grey'>GameMode (Disallowed)</font>"
		if(trialmin)
			. += "\t(<a href='?src=\ref[src];vote=toggle_gamemode'>[CONFIG_GET(allow_vote_mode) ? "Allowed" : "Disallowed"]</a>)"

		. += "</li>"
		//custom
		if(trialmin)
			. += "<li><a href='?src=\ref[src];vote=custom'>Custom</a></li>"
		. += "</ul><hr>"
	. += "<a href='?src=\ref[src];vote=close' style='position:absolute;right:50px'>Close</a></body></html>"
	return .

/datum/process/vote/Topic(href, list/href_list, hsrc)
	if(isnull(usr) || isnull(usr.client))
		return	//not necessary but meh...just in-case somebody does something stupid
	switch(href_list["vote"])
		if("close")
			voting.Remove(usr.client)
			usr << browse(null, "window=vote")
			return
		if("cancel")
			if(isnotnull(usr.client.holder))
				reset()
		if("toggle_restart")
			if(isnotnull(usr.client.holder))
				CONFIG_SET(allow_vote_restart, !CONFIG_GET(allow_vote_restart))
		if("toggle_gamemode")
			if(isnotnull(usr.client.holder))
				CONFIG_SET(allow_vote_mode, !CONFIG_GET(allow_vote_mode))
		if("restart")
			if(CONFIG_GET(allow_vote_restart) || isnotnull(usr.client.holder))
				initiate_vote("restart", usr.key)
		if("gamemode")
			if(CONFIG_GET(allow_vote_mode) || isnotnull(usr.client.holder))
				initiate_vote("gamemode", usr.key)
		if("crew_transfer")
			if(CONFIG_GET(allow_vote_restart) || isnotnull(usr.client.holder))
				initiate_vote("crew_transfer", usr.key)
		if("custom")
			if(isnotnull(usr.client.holder))
				initiate_vote("custom", usr.key)
		else
			submit_vote(usr.ckey, round(text2num(href_list["vote"])))
	usr.vote()

/mob/verb/vote()
	set category = PANEL_OOC
	set name = "Vote"

	if(isnotnull(global.PCvote))
		src << browse(global.PCvote.interface(client), "window=vote;can_close=0")