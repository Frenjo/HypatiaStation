/datum/game_mode/extended
	name = "extended"
	config_tag = "extended"
	required_players = 0

	uplink_welcome = "Syndicate Uplink Console:"
	uplink_uses = 10

	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800

/datum/game_mode/extended/announce()
	to_world("<B>The current game mode is - Extended Role-Playing!</B>")
	to_world("<B>Just have fun and role-play!</B>")

/datum/game_mode/extended/post_setup()
	spawn(rand(waittime_l, waittime_h)) // To reduce extended meta.
		send_intercept()
	. = ..()