/*
 * Game Ticker Process
 */
PROCESS_DEF(ticker)
	name = "Ticker"
	schedule_interval = 2 SECONDS

	var/lastTickerTimeDuration
	var/lastTickerTime

/datum/process/ticker/setup()
	lastTickerTime = world.timeofday

	if(isnull(global.CTticker))
		global.CTticker = new /datum/controller/ticker()

	wait_for_pregame()

/datum/process/ticker/do_work()
	var/currentTime = world.timeofday

	if(currentTime < lastTickerTime) // check for midnight rollover
		lastTickerTimeDuration = (currentTime - (lastTickerTime - TICKS_IN_DAY)) / TICKS_IN_SECOND
	else
		lastTickerTimeDuration = (currentTime - lastTickerTime) / TICKS_IN_SECOND

	lastTickerTime = currentTime

	global.CTticker.process()

/datum/process/ticker/proc/wait_for_pregame()
	set waitfor = FALSE
	// This seems really, really wrong but I don't want to rearrange the entire initialisation order just yet.
	// It's going to be one of those "temporary fixes" they find is still in the code two decades later.
	while(!global.CTmaster.initialised)
		sleep(1)
	global.CTticker?.pregame()

/datum/process/ticker/proc/getLastTickerTimeDuration()
	return lastTickerTimeDuration