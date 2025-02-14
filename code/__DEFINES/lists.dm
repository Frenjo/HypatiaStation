// Ensures L is initialised after this point.
#define LAZYINITLIST(L) if (isnull(L)) L = list()

// Removes I from list L, and sets I to null if it is now empty.
#define LAZYREMOVE(L, I) if(isnotnull(L)) { L -= I; if(!length(L)) { L = null; } }

// Adds I to L, initalizing L if necessary.
#define LAZYADD(L, I) if(isnull(L)) { L = list(); } L += I;

// Adds I to L, initialising L if necessary, if I is not already in L.
#define LAZYDISTINCTADD(L, I) if(isnull(L)) { L = list(); } L |= I;

// Sets L[A] to I, initalizing L if necessary.
#define LAZYSET(L, A, I) if(isnull(L)) { L = list(); } L[A] = I;