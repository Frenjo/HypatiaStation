/datum/game_mode/extended
	name = "extended"
	config_tag = "extended"
	required_players = 0

	uplink_welcome = "Syndicate Uplink Console:"
	uplink_uses = 10

/datum/game_mode/extended/get_announce_content()
	. = list()
	. += "<B>The current game mode is - Extended Role-Playing!</B>"
	. += "<B>Just have fun and role-play!</B>"