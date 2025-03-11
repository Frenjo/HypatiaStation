// See code/game/datums/controllers/global_variables.dm.

/*
 * Internal
 *
 * Do not use these directly, use the others below for clarity.
 */
#define GLOBAL_RAW(X) /var/global##X
#define GLOBAL_CONTROLLED(X) /datum/controller/global_variables/var/static##X

/*
 * BYOND
 */
#define GLOBAL_BYOND(N) GLOBAL_RAW(/##N)
#define GLOBAL_BYOND_INIT(N, V) GLOBAL_BYOND(N) = V
#define GLOBAL_BYOND_NEW(N) GLOBAL_BYOND_INIT(N, new()) // This is one of the only places I will accept use of untyped new().

/*
 * BYOND Lists
 */
#define GLOBAL_BYOND_LIST(N) GLOBAL_RAW(/list/##N)
#define GLOBAL_BYOND_LIST_INIT(N, V) GLOBAL_BYOND_LIST(N) = V
#define GLOBAL_BYOND_LIST_NEW(N) GLOBAL_BYOND_LIST_INIT(N, list())
// Associative
// These need to be updated to use alist/alist() when it becomes more supported.
#define GLOBAL_BYOND_ALIST(N) GLOBAL_RAW(/list/##N)
#define GLOBAL_BYOND_ALIST_INIT(N, V) GLOBAL_BYOND_ALIST(N) = V
#define GLOBAL_BYOND_ALIST_NEW(N) GLOBAL_BYOND_ALIST_INIT(N, list())

/*
 * GLOBL
 */
#define GLOBAL_GLOBL(N) GLOBAL_CONTROLLED(/##N)
#define GLOBAL_GLOBL_INIT(N, V) GLOBAL_GLOBL(N) = V
#define GLOBAL_GLOBL_NEW(N) GLOBAL_GLOBL_INIT(N, new()) // This is one of the only places I will accept use of untyped new().

/*
 * GLOBL Lists
 */
#define GLOBAL_GLOBL_LIST(N) GLOBAL_CONTROLLED(/list/##N)
#define GLOBAL_GLOBL_LIST_INIT(N, V) GLOBAL_GLOBL_LIST(N) = V
#define GLOBAL_GLOBL_LIST_NEW(N) GLOBAL_GLOBL_LIST_INIT(N, list())
// Associative
// These need to be updated to use alist/alist() when it becomes more supported.
#define GLOBAL_GLOBL_ALIST(N) GLOBAL_CONTROLLED(/list/##N)
#define GLOBAL_GLOBL_ALIST_INIT(N, V) GLOBAL_GLOBL_ALIST(N) = V
#define GLOBAL_GLOBL_ALIST_NEW(N) GLOBAL_GLOBL_ALIST_INIT(N, list())

/*
 * Controllers & Processes
 */
#define CONTROLLER_DEF(X) GLOBAL_BYOND(datum/controller/##X/CT##X); \
/datum/controller/##X/New() \
{ \
	. = ..(); \
	if(global.CT##X != src) \
		global.CT##X = src; \
} \
/datum/controller/##X

#define PROCESS_DEF(X) GLOBAL_BYOND(datum/process/##X/PC##X); \
/datum/process/##X/New() \
{ \
	. = ..(); \
	if(global.PC##X != src) \
		global.PC##X = src; \
} \
/datum/process/##X