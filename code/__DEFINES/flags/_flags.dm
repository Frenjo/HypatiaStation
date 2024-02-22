/*
 * Flag Helper Macros
 *
 * Handy for getting, setting and checking bitflags on various types.
 */
// Area
#define SET_AREA_FLAGS(AREA, FLAGS) AREA.area_flags |= FLAGS
#define UNSET_AREA_FLAGS(AREA, FLAGS) AREA.area_flags &= ~FLAGS
#define HAS_AREA_FLAGS(AREA, FLAGS) (AREA.area_flags & FLAGS)

// Turf
#define SET_TURF_FLAGS(TURF, FLAGS) TURF.turf_flags |= FLAGS
#define UNSET_TURF_FLAGS(TURF, FLAGS) TURF.turf_flags &= ~FLAGS
#define HAS_TURF_FLAGS(TURF, FLAGS) (TURF.turf_flags & FLAGS)

// Species
#define SET_SPECIES_FLAGS(SPECIES, FLAGS) SPECIES.species_flags |= FLAGS
#define UNSET_SPECIES_FLAGS(SPECIES, FLAGS) SPECIES.species_flags &= ~FLAGS
#define HAS_SPECIES_FLAGS(SPECIES, FLAGS) (SPECIES.species_flags & FLAGS)