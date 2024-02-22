/*
 * Flag Helper Macros
 *
 * Handy for getting, setting and checking bitflags on various types.
 */
// Turf.
#define SET_TURF_FLAGS(TURF, FLAGS) TURF.turf_flags |= FLAGS
#define UNSET_TURF_FLAGS(TURF, FLAGS) TURF.turf_flags &= ~FLAGS
#define HAS_TURF_FLAGS(TURF, FLAGS) (TURF.turf_flags & FLAGS)