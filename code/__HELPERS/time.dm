GLOBAL_GLOBL_LIST_INIT(months, list(
	"January", "February", "March", "April",
	"May", "June", "July", "August",
	"September", "October", "November", "December"
))

// Increases delay as the server gets more overloaded,
// as sleeps aren't cheap and sleeping only to wake up and sleep again is wasteful.
#define DELTA_CALC max(((max(world.tick_usage, world.cpu) / 100)), 1)

/proc/stoplag(initial_delay)
	// If we're initializing, our tick limit might be over 100 (testing config), but stoplag() penalizes procs that go over.
	// Unfortunately, this penalty slows down init a *lot*. So, we disable it during boot and lobby, when relatively few things should be calling this.
	if(!global.CTmaster?.initialised || global.PCticker?.current_state != GAME_STATE_PLAYING)
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