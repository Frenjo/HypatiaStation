/*
 * Core Macros
 */
// This just exists to make !isnull(X) clearer in what it does.
#define isnotnull(X) !isnull(X)

/*
 * for_no_type_check()
 *
 * This makes use of a BYOND quirk for massive performance increases with typed lists.
 * Documented here: https://hackmd.io/@goonstation/code#typecheckless-for-loops
 *
 * NOTE:
 * When iterating over contents using for_no_type_check(), LIST should always just be X and never X.contents! This may change in future.
 * For iterating over the contents of any /atom subtype that's not /area, THING should always be /atom/movable.
 * At the moment, I don't advise using this for iterating over the contents of an /area. This may also change in future.
 */
#define for_no_type_check(THING, LIST) for(##THING as anything in LIST)

// Used to determine if an object has been destroyed by qdel.
#define GC_DESTROYED(X) isnotnull(X?.gc_destroyed)

// List-related macro that has to be here because it's used in __HELPERS.
#define SUBTYPESOF(prototype) (typesof(prototype) - prototype)

// Bitflags.
#define BITFLAG(X) (1 << X)

// Used to retrieve /decl instances from the declarations controller.
#define GET_DECL_INSTANCE(PATH) global.CTdecls.get_decl_instance(PATH)
#define GET_DECL_SUBTYPE_INSTANCES(PATH) global.CTdecls.get_decl_subtype_instances(PATH)

// Returns whether or not the current gamemode is of type X.
// Basically exists so there isn't the need to type out long lines.
#define IS_GAME_MODE(X) istype(global.PCticker?.mode, X)

// These are used for the new configuration system.
#define CONFIG_GET(PATH) global.CTconfiguration.get_value(PATH)
#define CONFIG_SET(PATH, VALUE) global.CTconfiguration.set_value(PATH, VALUE)