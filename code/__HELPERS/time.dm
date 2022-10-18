#define TimeOfGame (get_game_time())
#define TimeOfTick (world.tick_usage * 0.01 * world.tick_lag)

GLOBAL_GLOBL_LIST_INIT(months, list(
	"January", "February", "March", "April",
	"May", "June", "July", "August",
	"September", "October", "November", "December"
))

/proc/get_game_time()
	var/global/time_offset = 0
	var/global/last_time = 0
	var/global/last_usage = 0

	var/wtime = world.time
	var/wusage = world.tick_usage * 0.01

	if(last_time < wtime && last_usage > 1)
		time_offset += last_usage - 1

	last_time = wtime
	last_usage = wusage

	return wtime + (time_offset + wusage) * world.tick_lag

//Returns the world time in english
/proc/worldtime2text(time = world.time)
	return "[round(time / 36000) + 12]:[(time / 600 % 60) < 10 ? add_zero(time / 600 % 60, 1) : time / 600 % 60]"

/proc/time_stamp()
	return time2text(world.timeofday, "hh:mm:ss")

/* Preserving this so future generations can see how fucking retarded some people are
proc/time_stamp()
	var/hh = text2num(time2text(world.timeofday, "hh")) // Set the hour
	var/mm = text2num(time2text(world.timeofday, "mm")) // Set the minute
	var/ss = text2num(time2text(world.timeofday, "ss")) // Set the second
	var/ph
	var/pm
	var/ps
	if(hh < 10) ph = "0"
	if(mm < 10) pm = "0"
	if(ss < 10) ps = "0"
	return"[ph][hh]:[pm][mm]:[ps][ss]"
*/

/* Returns 1 if it is the selected month and day */
/proc/isDay(month, day)
	if(isnum(month) && isnum(day))
		var/MM = text2num(time2text(world.timeofday, "MM")) // get the current month
		var/DD = text2num(time2text(world.timeofday, "DD")) // get the current day
		if(month == MM && day == DD)
			return 1

		// Uncomment this out when debugging!
		//else
			//return 1

// Increases delay as the server gets more overloaded,
// as sleeps aren't cheap and sleeping only to wake up and sleep again is wasteful.
#define DELTA_CALC max(((max(world.tick_usage, world.cpu) / 100)), 1)

/proc/stoplag(initial_delay)
	// If we're initializing, our tick limit might be over 100 (testing config), but stoplag() penalizes procs that go over.
	// Unfortunately, this penalty slows down init a *lot*. So, we disable it during boot and lobby, when relatively few things should be calling this.
	if(!global.master_controller || !global.master_controller.initialised || global.ticker.current_state != GAME_STATE_PLAYING)
		sleep(world.tick_lag)
		return 1

	if(!initial_delay)
		initial_delay = world.tick_lag

	. = 0
	var/i = DS2TICKS(initial_delay)
	do
		. += CEILING(i * DELTA_CALC, 1)
		sleep(i * world.tick_lag * DELTA_CALC)
		i *= 2
	while(world.tick_usage > STOPLAG_TICK_PERCENTAGE)

#undef DELTA_CALC