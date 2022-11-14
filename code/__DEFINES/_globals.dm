// See code/datums/controllers/global_variables.dm.

/*
 * Internal
 */
#define GLOBAL_RAW(X) /var/global##X
#define GLOBAL_CONTROLLED(X) /datum/controller/global_variables/var/static##X

/*
 * BYOND
 */
#define GLOBAL_BYOND(N) GLOBAL_RAW(/##N)
#define GLOBAL_BYOND_TYPED(N, T) GLOBAL_RAW(##T/##N)
#define GLOBAL_BYOND_INIT(N, V) GLOBAL_BYOND(N) = V
#define GLOBAL_BYOND_TYPED_INIT(N, T, V) GLOBAL_BYOND_TYPED(N, T) = V
#define GLOBAL_BYOND_NEW(N, T) GLOBAL_BYOND_TYPED_INIT(N, T, new T())

/*
 * BYOND Lists
 */
#define GLOBAL_BYOND_LIST(N) GLOBAL_RAW(/list/##N)
#define GLOBAL_BYOND_LIST_INIT(N, V) GLOBAL_BYOND_LIST(N) = V
#define GLOBAL_BYOND_LIST_NEW(N) GLOBAL_BYOND_LIST_INIT(N, list())

/*
 * GLOBL
 */
#define GLOBAL_GLOBL(N) GLOBAL_CONTROLLED(/##N)
#define GLOBAL_GLOBL_TYPED(N, T) GLOBAL_CONTROLLED(##T/##N)
#define GLOBAL_GLOBL_INIT(N, V) GLOBAL_GLOBL(N) = V
#define GLOBAL_GLOBL_TYPED_INIT(N, T, V) GLOBAL_GLOBL_TYPED(N, T) = V
#define GLOBAL_GLOBL_NEW(N, T) GLOBAL_GLOBL_TYPED_INIT(N, T, new T())

/*
 * GLOBL Lists
 */
#define GLOBAL_GLOBL_LIST(N) GLOBAL_CONTROLLED(/list/##N)
#define GLOBAL_GLOBL_LIST_INIT(N, V) GLOBAL_GLOBL_LIST(N) = V
#define GLOBAL_GLOBL_LIST_NEW(N) GLOBAL_GLOBL_LIST_INIT(N, list())

/*
 * Controllers & Processes
 */
#define CONTROLLER_DEF(X) GLOBAL_BYOND_TYPED(CT##X, /datum/controller/##X); \
/datum/controller/##X/New() \
{ \
	. = ..(); \
	if(global.CT##X != src) \
		global.CT##X = src; \
} \
/datum/controller/##X

#define PROCESS_DEF(X) GLOBAL_BYOND_TYPED(PC##X, /datum/process/##X); \
/datum/process/##X/New() \
{ \
	. = ..(); \
	if(global.PC##X != src) \
		global.PC##X = src; \
} \
/datum/process/##X