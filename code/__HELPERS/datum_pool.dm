/*
/tg/station13 /atom/movable Pool:
---------------------------------
By RemieRichards
Creation/Deletion is laggy, so let's reduce reuse and recycle!
*/
#define ATOM_POOL_COUNT 100
// "define DEBUG_ATOM_POOL 1
GLOBAL_BYOND_LIST_NEW(GlobalPool)

//You'll be using this proc 90% of the time.
//It grabs a type from the pool if it can
//And if it can't, it creates one
//The pool is flexible and will expand to fit
//The new created atom when it eventually
//Goes into the pool

//Second argument can be a new location, if the type is /atom/movable
//Or a list of arguments
//Either way it gets passed to new

/proc/PoolOrNew(get_type, second_arg)
	if(!get_type)
		return

	var/datum/D
	D = GetFromPool(get_type, second_arg)

	if(!D)
		if(ispath(get_type))
			if(islist(second_arg))
				return new get_type(arglist(second_arg))
			else
				return new get_type(second_arg)
	return D

/proc/GetFromPool(get_type, second_arg)
	if(!get_type)
		return 0

	if(isnull(global.GlobalPool[get_type]))
		return 0

	if(length(global.GlobalPool[get_type]) == 0)
		return 0

	var/datum/D = pick_n_take(global.GlobalPool[get_type])
	if(D)
		D.ResetVars()
		D.Prepare(second_arg)
		return D
	return 0

/proc/PlaceInPool(datum/D)
	if(!istype(D))
		return

	if(length(global.GlobalPool[D.type]) > ATOM_POOL_COUNT)
		#ifdef DEBUG_ATOM_POOL
		to_world("DEBUG_DATUM_POOL: PlaceInPool([D.type]) exceeds [ATOM_POOL_COUNT]. Discarding.")
		#endif
		qdel(D)
		return

	if(D in global.GlobalPool[D.type])
		return

	if(!global.GlobalPool[D.type])
		global.GlobalPool[D.type] = list()

	global.GlobalPool[D.type] += D

	D.Destroy()
	D.ResetVars()

/proc/IsPooled(datum/D)
	if(isnull(global.GlobalPool[D.type]) || length(global.GlobalPool[D.type]) == 0)
		return 0
	return 1

/datum/proc/Prepare(args)
	if(islist(args))
		New(arglist(args))
	else
		New(args)

/atom/movable/Prepare(args)
	if(islist(args))
		loc = args[1]
		loc = args
	..()

/datum/proc/ResetVars(list/exclude = list())
	var/list/excluded = list("animate_movement", "loc", "locs", "parent_type", "vars", "verbs", "type") + exclude

	for(var/V in vars)
		if(V in excluded)
			continue

		vars[V] = initial(vars[V])

/atom/movable/ResetVars()
	..()
	vars["loc"] = null

#undef ATOM_POOL_COUNT