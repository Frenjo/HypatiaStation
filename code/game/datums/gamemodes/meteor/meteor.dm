/datum/game_mode/meteor
	name = "meteor"
	config_tag = "meteor"

	required_players = 0
	votable = FALSE

	var/const/meteordelay = 2000
	var/nometeors = 1
	var/wavesecret = FALSE

	uplink_welcome = "EVIL METEOR Uplink Console:"
	uplink_uses = 10

/datum/game_mode/meteor/get_announce_content()
	. = list()
	. += "<B>The current game mode is - Meteor!</B>"
	. += "<B>The space station has been stuck in a major meteor shower. You must escape from the station or at least live.</B>"

/datum/game_mode/meteor/post_setup()
	. = ..()
	GLOBL.defer_powernet_rebuild = 2	//Might help with the lag
	spawn(meteordelay)
		nometeors = 0

/datum/game_mode/meteor/process()
	if(nometeors)
		return
	/*if(prob(80))
		spawn()
			dust_swarm("norm")
	else
		spawn()
			dust_swarm("strong")*/
	spawn()
		spawn_meteors(6)

/datum/game_mode/meteor/declare_completion()
	var/text
	var/survivors = 0
	for(var/mob/living/player in GLOBL.player_list)
		if(player.stat != DEAD)
			var/turf/location = GET_TURF(player)
			if(isnull(location))
				continue
			switch(location.loc.type)
				if(/area/shuttle/escape/centcom)
					text += "<br><b><font size=2>[player.real_name] escaped on the emergency shuttle</font></b>"
				if(/area/shuttle/escape_pod/one/centcom, /area/shuttle/escape_pod/two/centcom, /area/shuttle/escape_pod/three/centcom, /area/shuttle/escape_pod/four/centcom, /area/shuttle/escape_pod/five/centcom)
					text += "<br><font size=2>[player.real_name] escaped in a life pod.</font>"
				else
					text += "<br><font size=1>[player.real_name] survived but is stranded without any hope of rescue.</font>"
			survivors++

	if(survivors)
		to_world(SPAN_INFO("<B>The following survived the meteor storm</B>:[text]"))
	else
		to_world(SPAN_INFO_B("Nobody survived the meteor storm!"))

	feedback_set_details("round_end_result", "end - evacuation")
	feedback_set("round_end_result", survivors)

	..()
	return 1
