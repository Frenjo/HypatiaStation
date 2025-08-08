/*
 * Core Macros
 *
 * These are supposed to look as if they're a part of the language itself.
 * IE, they're all lowercase and look like you'd expect a built-in proc to look.
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

// Allows easily obtaining all subtypes of a type exclusively.
#define SUBTYPESOF(prototype) (typesof(prototype) - prototype) // TODO: Make this lowercase.