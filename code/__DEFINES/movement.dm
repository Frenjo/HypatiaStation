// Move intent datum helpers.
#define IS_WALKING(X) istype(X?.move_intent, /decl/move_intent/walk)
#define IS_RUNNING(X) istype(X?.move_intent, /decl/move_intent/run)

// Throwing movement helpers.
// I was going to convert these to TRUE/FALSE because I don't think WEAK and STRONG have any...
// practical differences. But I decided to keep them separate for posterity.
#define THROW_NONE		0
#define THROW_WEAK		1
#define THROW_STRONG	2