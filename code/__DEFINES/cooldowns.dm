/*
 * Cooldown system based on storing world.time on a variable, plus the cooldown time.
 * Better performance over timer cooldowns, lower control. Same functionality.
*/

// Declares a variable to be used for cooldowns.
#define COOLDOWN_DECLARE(INDEX) var/##INDEX = 0

// Starts a cooldown.
#define COOLDOWN_START(SOURCE, INDEX, TIME) (SOURCE.INDEX = world.time + (TIME))

// Returns TRUE if the cooldown has run its course, FALSE otherwise.
#define COOLDOWN_FINISHED(SOURCE, INDEX) (SOURCE.INDEX <= world.time)

// Adds time to an existing cooldown if it's already started, otherwise starts it with the new duration.
#define COOLDOWN_INCREMENT(SOURCE, INDEX, INCREMENT) \
	if(COOLDOWN_FINISHED(SOURCE, INDEX)) { \
		COOLDOWN_START(SOURCE, INDEX, INCREMENT); \
		return; \
	} \
	SOURCE.INDEX += (INCREMENT); \