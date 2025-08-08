// Used to determine if an object has been destroyed by qdel.
#define GC_DESTROYED(X) isnotnull(X?.gc_destroyed)

// This exists to simplify the many repeated lines of this that are littered throughout the codebase.
#define QDEL_NULL(X) \
	qdel(X); \
	X = null;