/*
 * Game Ticker Process
 */
GLOBAL_BYOND_TYPED(ticker_process, /datum/process/ticker) // Set in /datum/process/ticker/setup().

/datum/process/ticker
	name = "Ticker"
	schedule_interval = 2 SECONDS

	var/lastTickerTimeDuration
	var/lastTickerTime

/datum/process/ticker/setup()
	lastTickerTime = world.timeofday

	if(!global.ticker)
		global.ticker = new /datum/controller/game_ticker()

	global.ticker_process = src

	spawn(0)
		if(global.ticker)
			global.ticker.pregame()

/datum/process/ticker/doWork()
	var/currentTime = world.timeofday

	if(currentTime < lastTickerTime) // check for midnight rollover
		lastTickerTimeDuration = (currentTime - (lastTickerTime - TICKS_IN_DAY)) / TICKS_IN_SECOND
	else
		lastTickerTimeDuration = (currentTime - lastTickerTime) / TICKS_IN_SECOND

	lastTickerTime = currentTime

	global.ticker.process()

/datum/process/ticker/proc/getLastTickerTimeDuration()
	return lastTickerTimeDuration