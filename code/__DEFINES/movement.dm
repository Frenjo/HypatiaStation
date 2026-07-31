// Move intent datum helpers.
#define IS_WALKING(X) istype(X?.move_intent, /decl/move_intent/walk)
#define IS_RUNNING(X) istype(X?.move_intent, /decl/move_intent/run)

// Throwing movement helpers.
// I was going to convert these to TRUE/FALSE because I don't think WEAK and STRONG have any...
// practical differences. But I decided to keep them separate for posterity.
#define THROW_NONE		0
#define THROW_WEAK		1
#define THROW_STRONG	2

// Broken down, here's what this does:
//	Divides the world icon_size by delay divided by ticklag to get the number of pixels something should be moving each tick.
//	The division result is given a min value of 1 to prevent obscenely slow glide sizes from being set
//	Then that's multiplied by the global glide size multiplier. 1.25 by default feels pretty close to spot on. This is just to try to get byond to behave.
//	The whole result is then clamped to within the range above.
//	Not very readable but it works
#define DELAY_TO_GLIDE_SIZE(delay) (clamp(((32 / max((delay) / world.tick_lag, 1)) * 1), 1, 32))