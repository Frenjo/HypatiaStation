//cael - two events here

//meteor storms are much heavier
/datum/round_event/meteor_wave
	start_when = 6
	end_when = 33

/datum/round_event/meteor_wave/setup()
	end_when = rand(10, 25) * 3

/datum/round_event/meteor_wave/announce()
	priority_announce("Meteors have been detected on collision course with the station.", "Meteor Alert", 'sound/AI/meteors.ogg')

/datum/round_event/meteor_wave/tick()
	if(IsMultiple(active_for, 3))
		spawn_meteors(rand(2, 5))

/datum/round_event/meteor_wave/end()
	priority_announce("The station has cleared the meteor storm.", "Meteor Alert")

//
/datum/round_event/meteor_shower
	start_when = 5
	end_when = 7

	var/next_meteor = 6
	var/waves = 1

/datum/round_event/meteor_shower/setup()
	waves = rand(1, 4)

/datum/round_event/meteor_shower/announce()
	priority_announce("The station is now in a meteor shower.", "Meteor Alert")

//meteor showers are lighter and more common,
/datum/round_event/meteor_shower/tick()
	if(active_for >= next_meteor)
		spawn_meteors(rand(1, 4))
		next_meteor += rand(20, 100)
		waves--
		if(waves <= 0)
			end_when = active_for + 1
		else
			end_when = next_meteor + 1

/datum/round_event/meteor_shower/end()
	priority_announce("The station has cleared the meteor shower", "Meteor Alert")