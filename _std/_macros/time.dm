// Converts deciseconds to ticks.
#define DS2TICKS(DS) ((DS) / world.tick_lag)

// Used so the code isn't littered with random sleep(-1) everywhere.
#define WAIT_FOR_BACKLOG sleep(-1)

#define TIMEOFGAME (get_game_time())
#define TIMEOFTICK (world.tick_usage * 0.01 * world.tick_lag)