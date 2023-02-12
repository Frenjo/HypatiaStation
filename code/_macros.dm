// Used to determine if an object has been destroyed by qdel.
#define GC_DESTROYED(X) !isnull(X.gc_destroyed)

// List-related macro that has to be here because it's used in __HELPERS.
#define SUBTYPESOF(prototype) (typesof(prototype) - prototype)

// Bitflags.
#define BITFLAG(X) (1 << X)