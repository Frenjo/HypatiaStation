//Uncommenting ALLOW_HOLIDAYS in config.txt will enable Holidays

GLOBAL_GLOBL_INIT(eventchance, 10)	//% per 5 mins

//Just thinking ahead! Here's the foundations to a more robust Holiday event system.
//It's easy as hell to add stuff. Just set Holiday to something using the switch (or something else)
//then use if(Holiday == "MyHoliday") to make stuff happen on that specific day only
//Please, Don't spam stuff up with easter eggs, I'd rather somebody just delete this than people cause
//the game to lag even more in the name of one-day content.

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//ALSO, MOST IMPORTANTLY: Don't add stupid stuff! Discuss bonus content with Project-Heads first please!//
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//																							~Carn

/hook/startup/proc/update_holiday()
	get_holiday()
	return 1

//sets up the Holiday global variable. Shouldbe called on game configuration or something.
/proc/get_holiday()
	if(!CONFIG_GET(allow_holidays))
		return	// Holiday stuff was not enabled in the config!

	var/YY	=	text2num(time2text(world.timeofday, "YY"))	// get the current year
	var/MM	=	text2num(time2text(world.timeofday, "MM"))	// get the current month
	var/DD	=	text2num(time2text(world.timeofday, "DD"))	// get the current day

	//Main switch. If any of these are too dumb/inappropriate, or you have better ones, feel free to change whatever
	switch(MM)
		if(1)	//Jan
			switch(DD)
				if(1)
					CONFIG_SET(holiday_name, "New Year's Day")

		if(2)	//Feb
			switch(DD)
				if(2)
					CONFIG_SET(holiday_name, "Groundhog Day")
				if(14)
					CONFIG_SET(holiday_name, "Valentine's Day")
				if(17)
					CONFIG_SET(holiday_name, "Random Acts of Kindness Day")

		if(3)	//Mar
			switch(DD)
				if(14)
					CONFIG_SET(holiday_name, "Pi Day")
				if(17)
					CONFIG_SET(holiday_name, "St. Patrick's Day")
				if(27)
					if(YY == 16)
						CONFIG_SET(holiday_name, "Easter")
				if(31)
					if(YY == 13)
						CONFIG_SET(holiday_name, "Easter")

		if(4)	//Apr
			switch(DD)
				if(1)
					CONFIG_SET(holiday_name, "April Fool's Day")
					if(YY == 18 && prob(50))
						CONFIG_SET(holiday_name, "Easter")
				if(5)
					if(YY == 15)
						CONFIG_SET(holiday_name, "Easter")
				if(16)
					if(YY == 17)
						CONFIG_SET(holiday_name, "Easter")
				if(20)
					CONFIG_SET(holiday_name, "Four-Twenty")
					if(YY == 14 && prob(50))
						CONFIG_SET(holiday_name, "Easter")
				if(22)
					CONFIG_SET(holiday_name, "Earth Day")

		if(5)	//May
			switch(DD)
				if(1)
					CONFIG_SET(holiday_name, "Labour Day")
				if(4)
					CONFIG_SET(holiday_name, "FireFighter's Day")
				if(12)
					CONFIG_SET(holiday_name, "Owl and Pussycat Day")	//what a dumb day of observence...but we -do- have costumes already :3

		if(6)	//Jun

		if(7)	//Jul
			switch(DD)
				if(1)
					CONFIG_SET(holiday_name, "Doctor's Day")
				if(2)
					CONFIG_SET(holiday_name, "UFO Day")
				if(8)
					CONFIG_SET(holiday_name, "Writer's Day")
				if(30)
					CONFIG_SET(holiday_name, "Friendship Day")

		if(8)	//Aug
			switch(DD)
				if(5)
					CONFIG_SET(holiday_name, "Beer Day")

		if(9)	//Sep
			switch(DD)
				if(19)
					CONFIG_SET(holiday_name, "Talk-Like-a-Pirate Day")
				if(28)
					CONFIG_SET(holiday_name, "Stupid-Questions Day")

		if(10)	//Oct
			switch(DD)
				if(4)
					CONFIG_SET(holiday_name, "Animal's Day")
				if(7)
					CONFIG_SET(holiday_name, "Smiling Day")
				if(16)
					CONFIG_SET(holiday_name, "Boss' Day")
				if(31)
					CONFIG_SET(holiday_name, "Halloween")

		if(11)	//Nov
			switch(DD)
				if(1)
					CONFIG_SET(holiday_name, "Vegan Day")
				if(13)
					CONFIG_SET(holiday_name, "Kindness Day")
				if(19)
					CONFIG_SET(holiday_name, "Flowers Day")
				if(21)
					CONFIG_SET(holiday_name, "Saying-'Hello' Day")

		if(12)	//Dec
			switch(DD)
				if(10)
					CONFIG_SET(holiday_name, "Human-Rights Day")
				if(14)
					CONFIG_SET(holiday_name, "Monkey Day")
				if(21)
					if(YY == 12)
						CONFIG_SET(holiday_name, "End of the World")
				if(22)
					CONFIG_SET(holiday_name, "Orgasming Day")		//lol. These all actually exist
				if(24)
					CONFIG_SET(holiday_name, "Christmas Eve")
				if(25)
					CONFIG_SET(holiday_name, "Christmas")
				if(26)
					CONFIG_SET(holiday_name, "Boxing Day")
				if(31)
					CONFIG_SET(holiday_name, "New Year's Eve")

	if(!CONFIG_GET(holiday_name))
		//Friday the 13th
		if(DD == 13)
			if(time2text(world.timeofday, "DDD") == "Fri")
				CONFIG_SET(holiday_name, "Friday the 13th")

//Allows GA and GM to set the Holiday variable
/client/proc/set_holiday(T as text|null)
	set name = "Set Holiday"
	set category = "Fun"
	set desc = "Force-set the Holiday variable to make the game think it's a certain day."
	if(!check_rights(R_SERVER))
		return

	CONFIG_SET(holiday_name, T)
	//get a new station name
	global.current_map.station_name = null
	station_name()
	//update our hub status
	world.update_status()
	holiday_game_start()

	message_admins("\blue ADMIN: Event: [key_name(src)] force-set Holiday to \"[CONFIG_GET(holiday_name)]\"")
	log_admin("[key_name(src)] force-set Holiday to \"[CONFIG_GET(holiday_name)]\"")

//Run at the  start of a round
/proc/holiday_game_start()
	if(CONFIG_GET(holiday_name))
		to_world("<font color='blue'>and...</font>")
		to_world("<h4>Happy [CONFIG_GET(holiday_name)] Everybody!</h4>")
		switch(CONFIG_GET(holiday_name))	//special holidays
			if("Easter")
				//do easter stuff
			if("Christmas Eve", "Christmas")
				christmas_game_start()
	return

//Nested in the random events loop. Will be triggered every 2 minutes
/proc/holiday_random_event()
	switch(CONFIG_GET(holiday_name))	//special holidays

		if("", null)			//no Holiday today! Back to work!
			return

		if("Easter")		//I'll make this into some helper procs at some point
/*			var/list/turf/simulated/floor/Floorlist = list()
			for(var/turf/simulated/floor/T)
				if(T.contents)
					Floorlist += T
			var/turf/simulated/floor/F = Floorlist[rand(1,Floorlist.len)]
			Floorlist = null
			var/obj/structure/closet/C = locate(/obj/structure/closet) in F
			var/obj/item/weapon/reagent_containers/food/snacks/chocolateegg/wrapped/Egg
			if( C )			Egg = new(C)
			else			Egg = new(F)
*/
/*			var/list/obj/containers = list()
			for(var/obj/item/weapon/storage/S in world)
				if(S.z != 1)	continue
				containers += S

			message_admins("\blue DEBUG: Event: Egg spawned at [Egg.loc] ([Egg.x],[Egg.y],[Egg.z])")*/
		if("End of the World")
			if(prob(GLOBL.eventchance))
				game_over_event()

		if("Christmas", "Christmas Eve")
			if(prob(GLOBL.eventchance))
				christmas_event()