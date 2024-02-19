// Turf-only flags.
#define TURF_NO_JAUNT		BITFLAG(0) // Disallows ethereal jaunting over the turf.
#define TURF_BLOCKS_AIR		BITFLAG(1) // Blocks airflow through the turf.

#define TRANSITIONEDGE	7 //Distance from edge to move to another z-level

// Helper macros for getting and setting turf bitflags.
// These could be made more generic in future but I just wanted to get the system in place.
#define SET_TURF_FLAGS(TURF, FLAGS) TURF.flags |= FLAGS
#define UNSET_TURF_FLAGS(TURF, FLAGS) TURF.flags &= ~FLAGS
#define HAS_TURF_FLAGS(TURF, FLAGS) (TURF.flags & FLAGS)