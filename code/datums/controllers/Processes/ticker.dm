/var/global/datum/controller/process/ticker/ticker_process

/datum/controller/process/ticker
	var/lastTickerTimeDuration
	var/lastTickerTime

/datum/controller/process/ticker/setup()
	name = "ticker"
	schedule_interval = 2 SECONDS

	lastTickerTime = world.timeofday

	if(!global.ticker)
		global.ticker = new /datum/controller/game_ticker()

	global.ticker_process = src

	spawn(0)
		if(global.ticker)
			global.ticker.pregame()

/datum/controller/process/ticker/doWork()
	var/currentTime = world.timeofday

	if(currentTime < lastTickerTime) // check for midnight rollover
		lastTickerTimeDuration = (currentTime - (lastTickerTime - TICKS_IN_DAY)) / TICKS_IN_SECOND
	else
		lastTickerTimeDuration = (currentTime - lastTickerTime) / TICKS_IN_SECOND

	lastTickerTime = currentTime

	global.ticker.process()

/datum/controller/process/ticker/proc/getLastTickerTimeDuration()
	return lastTickerTimeDuration