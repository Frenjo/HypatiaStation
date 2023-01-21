// GC/qdel.
#define qdel_null(x) if(x) { qdel(x); x = null }

// List-related macro that has to be here because it's used in __HELPERS.
#define SUBTYPESOF(prototype) (typesof(prototype) - prototype)

// Bitflags.
#define BITFLAG(X) (1 << X)