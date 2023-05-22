// Used to determine if an object has been destroyed by qdel.
#define GC_DESTROYED(X) !isnull(X?.gc_destroyed)

// List-related macro that has to be here because it's used in __HELPERS.
#define SUBTYPESOF(prototype) (typesof(prototype) - prototype)

// Bitflags.
#define BITFLAG(X) (1 << X)

// Used to retrieve /decl instances from the declarations controller.
#define GET_DECL_INSTANCE(X) global.CTdecls.get_decl_instance(X)

// Returns whether or not the current gamemode is of type X.
// Basically exists so there isn't the need to type out long lines.
#define IS_GAME_MODE(X) istype(global.CTgame_ticker?.mode, X)