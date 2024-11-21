//cael - two events here

//meteor storms are much heavier
/datum/round_event/meteor_wave
	startWhen = 6
	endWhen = 33

/datum/round_event/meteor_wave/setup()
	endWhen = rand(10, 25) * 3

/datum/round_event/meteor_wave/announce()
	command_alert("Meteors have been detected on collision course with the station.", "Meteor Alert")
	world << sound('sound/AI/meteors.ogg')

/datum/round_event/meteor_wave/tick()
	if(IsMultiple(activeFor, 3))
		spawn_meteors(rand(2, 5))

/datum/round_event/meteor_wave/end()
	command_alert("The station has cleared the meteor storm.", "Meteor Alert")

//
/datum/round_event/meteor_shower
	startWhen = 5
	endWhen = 7

	var/next_meteor = 6
	var/waves = 1

/datum/round_event/meteor_shower/setup()
	waves = rand(1, 4)

/datum/round_event/meteor_shower/announce()
	command_alert("The station is now in a meteor shower.", "Meteor Alert")

//meteor showers are lighter and more common,
/datum/round_event/meteor_shower/tick()
	if(activeFor >= next_meteor)
		spawn_meteors(rand(1, 4))
		next_meteor += rand(20, 100)
		waves--
		if(waves <= 0)
			endWhen = activeFor + 1
		else
			endWhen = next_meteor + 1

/datum/round_event/meteor_shower/end()
	command_alert("The station has cleared the meteor shower", "Meteor Alert")