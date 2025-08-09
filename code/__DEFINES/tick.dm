// The percentage of tick usage at which CHECK_TICK begins calling /proc/stoplag().
#define STOPLAG_TICK_PERCENTAGE 70

// Returns true if tick_usage is above the limit.
#define TICK_CHECK (world.tick_usage > STOPLAG_TICK_PERCENTAGE)
// Runs /proc/stoplag() if tick_usage is above the limit.
#define CHECK_TICK (TICK_CHECK ? stoplag() : 0)

// The default value for all uses of set background. Set background can cause gradual lag and is recommended you only turn this on if necessary.
// TRUE will enable set background. FALSE will disable set background.
#define BACKGROUND_ENABLED FALSE