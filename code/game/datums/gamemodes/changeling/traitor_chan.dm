/datum/game_mode/traitor/changeling
	name = "traitor+changeling"
	config_tag = "traitorchan"
	traitors_possible = 3 //hard limit on traitors if scaling is turned off
	required_players = 3
	required_players_secret = 10
	required_enemies = 2
	recommended_enemies = 3

/datum/game_mode/traitor/changeling/get_announce_content()
	. = list()
	. += "<B>The current game mode is - Traitor+Changeling!</B>"
	. += "<B>There is an alien creature on the station along with some Syndicate operatives out for their own gain! Do not let the changeling and the traitors succeed!</B>"

/datum/game_mode/traitor/changeling/pre_setup()
	var/list/datum/mind/possible_changelings = get_players_for_role(/decl/special_role/changeling)

	if(length(possible_changelings))
		var/datum/mind/changeling = pick(possible_changelings)
		//possible_changelings-=changeling
		changelings += changeling
		modePlayer += changelings
		return ..()
	else
		return 0

/datum/game_mode/traitor/changeling/post_setup()
	for_no_type_check(var/datum/mind/changeling, changelings)
		grant_changeling_powers(changeling.current)
		changeling.special_roles.Add(SPECIAL_ROLE_CHANGELING)
		if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
			forge_changeling_objectives(changeling)
		greet_changeling(changeling)
	..()
	return