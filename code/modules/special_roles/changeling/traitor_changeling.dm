/datum/game_mode/traitor/changeling
	name = "traitor+changeling"
	config_tag = "traitorchan"
	traitors_possible = 3 //hard limit on traitors if scaling is turned off
	required_players = 3
	required_players_secret = 10
	required_enemies = 2
	recommended_enemies = 3

	var/list/selected_changelings = list()

/datum/game_mode/traitor/changeling/get_announce_content()
	. = list()
	. += "<B>The current game mode is - Traitor+Changeling!</B>"
	. += "<B>There is an alien creature on the station along with some Syndicate operatives out for their own gain! Do not let the changeling and the traitors succeed!</B>"

/datum/game_mode/traitor/changeling/pre_setup()
	. = ..()
	var/list/datum/mind/possible_changelings = get_players_for_role(/decl/special_role/changeling)
	if(!length(possible_changelings))
		return 0

	var/datum/mind/changeling = pick(possible_changelings)
	selected_changelings.Add(changeling)

/datum/game_mode/traitor/changeling/post_setup()
	. = ..()
	var/decl/special_role/changeling/changeling_role = GET_DECL_INSTANCE(__IMPLIED_TYPE__)
	for_no_type_check(var/datum/mind/changeling, selected_changelings)
		changeling_role.setup(changeling.current)