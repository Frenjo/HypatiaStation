/*
 * Flag Helper Macros
 *
 * Handy for getting, setting and checking bitflags on various types.
 * These do sacrifice compactness for readability, but they...
 * ... clearly allow someone to see at first glance exactly what's happening.
 */
// Atom
#define SET_ATOM_FLAGS(ATOM, FLAGS) ATOM.atom_flags |= FLAGS
#define UNSET_ATOM_FLAGS(ATOM, FLAGS) ATOM.atom_flags &= ~FLAGS
#define HAS_ATOM_FLAGS(ATOM, FLAGS) (ATOM.atom_flags & FLAGS)
// Pass
#define SET_PASS_FLAGS(ATOM, FLAGS) ATOM.pass_flags |= FLAGS
#define UNSET_PASS_FLAGS(ATOM, FLAGS) ATOM.pass_flags &= ~FLAGS
#define HAS_PASS_FLAGS(ATOM, FLAGS) (ATOM.pass_flags & FLAGS)

// Area
#define SET_AREA_FLAGS(AREA, FLAGS) AREA.area_flags |= FLAGS
#define UNSET_AREA_FLAGS(AREA, FLAGS) AREA.area_flags &= ~FLAGS
#define HAS_AREA_FLAGS(AREA, FLAGS) (AREA.area_flags & FLAGS)

// Turf
#define SET_TURF_FLAGS(TURF, FLAGS) TURF.turf_flags |= FLAGS
#define UNSET_TURF_FLAGS(TURF, FLAGS) TURF.turf_flags &= ~FLAGS
#define HAS_TURF_FLAGS(TURF, FLAGS) (TURF.turf_flags & FLAGS)

// Object
#define HAS_OBJ_FLAGS(OBJECT, FLAGS) (OBJECT.obj_flags & FLAGS)

// Item
#define SET_ITEM_FLAGS(ITEM, FLAGS) ITEM.item_flags |= FLAGS
#define UNSET_ITEM_FLAGS(ITEM, FLAGS) ITEM.item_flags &= ~FLAGS
#define HAS_ITEM_FLAGS(ITEM, FLAGS) (ITEM.item_flags & FLAGS)
// Inventory Hiding
#define SET_INV_FLAGS(ITEM, FLAGS) ITEM.inv_flags |= FLAGS
#define UNSET_INV_FLAGS(ITEM, FLAGS) ITEM.inv_flags &= ~FLAGS
#define HAS_INV_FLAGS(ITEM, FLAGS) (ITEM.inv_flags & FLAGS)

// Species
#define SET_SPECIES_FLAGS(SPECIES, FLAGS) SPECIES.species_flags |= FLAGS
#define UNSET_SPECIES_FLAGS(SPECIES, FLAGS) SPECIES.species_flags &= ~FLAGS
#define HAS_SPECIES_FLAGS(SPECIES, FLAGS) (SPECIES.species_flags & FLAGS)

// Language
#define HAS_LANGUAGE_FLAGS(LANGUAGE, FLAGS) (LANGUAGE.flags & FLAGS)