// See code/game/datums/controllers/global_variables.dm.

/*
 * Internal
 *
 * Do not use these directly, use the others below for clarity.
 */
#define GLOBAL_RAW(X) /var/global##X
#define GLOBAL_CONTROLLED(X) /datum/controller/global_variables/var##X
#define GLOBAL_MANAGED(X, INIT_VALUE)\
/datum/controller/global_variables/proc/InitGlobal##X()\
{\
	##X = ##INIT_VALUE;\
}

/*
 * BYOND
 */
#define GLOBAL_BYOND(N) GLOBAL_RAW(/##N)
#define GLOBAL_BYOND_NEW(N) GLOBAL_BYOND_INIT(N, new()) // This is one of the only places I will accept use of untyped new().
#define GLOBAL_BYOND_INIT(N, V) GLOBAL_BYOND(N) = V

/*
 * BYOND Lists
 */
#define GLOBAL_BYOND_LIST(N) GLOBAL_RAW(/list/##N)
#define GLOBAL_BYOND_LIST_NEW(N) GLOBAL_BYOND_LIST_INIT(N, list())
#define GLOBAL_BYOND_LIST_INIT(N, V) GLOBAL_BYOND_LIST(N) = V
// Associative
#define GLOBAL_BYOND_ALIST(N) GLOBAL_RAW(/alist/##N)
#define GLOBAL_BYOND_ALIST_NEW(N) GLOBAL_BYOND_ALIST_INIT(N, alist())
#define GLOBAL_BYOND_ALIST_INIT(N, V) GLOBAL_BYOND_ALIST(N) = V

/*
 * GLOBL
 */
#define GLOBAL_GLOBL_INIT(N, V) GLOBAL_CONTROLLED(/##N); GLOBAL_MANAGED(N, V)
#define GLOBAL_GLOBL_NEW(N) GLOBAL_GLOBL_INIT(N, new()) // This is one of the only places I will accept use of untyped new().
#define GLOBAL_GLOBL_TYPED(N, T, V) GLOBAL_CONTROLLED(##T/##N); GLOBAL_MANAGED(N, V)
#define GLOBAL_GLOBL_TYPED_NEW(N, T) GLOBAL_CONTROLLED(##T/##N); GLOBAL_MANAGED(N, new T())

/*
 * GLOBL Lists
 */
#define GLOBAL_GLOBL_LIST_INIT(N, V) GLOBAL_CONTROLLED(/list/##N); GLOBAL_MANAGED(N, V)
#define GLOBAL_GLOBL_LIST_NEW(N) GLOBAL_GLOBL_LIST_INIT(N, list())
#define GLOBAL_GLOBL_LIST_TYPED(N, T, V) GLOBAL_CONTROLLED(/list##T/##N); GLOBAL_MANAGED(N, V)
#define GLOBAL_GLOBL_LIST_TYPED_NEW(N, T) GLOBAL_GLOBL_LIST_TYPED(N, T, list())
// Associative
#define GLOBAL_GLOBL_ALIST_INIT(N, V) GLOBAL_CONTROLLED(/alist/##N); GLOBAL_MANAGED(N, V)
#define GLOBAL_GLOBL_ALIST_NEW(N) GLOBAL_GLOBL_ALIST_INIT(N, alist())

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