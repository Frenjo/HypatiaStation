// These involve BYOND's built in filters that do visual effects, and not stuff that distinguishes between things.

// All of this ported from TG.
// And then ported to Nebula from Polaris.
// Which was then ported (in a heavily modified form) to Hypatia from Nebula.
/atom/movable
	var/list/filter_data = list() // For handling persistent filters

/atom/movable/proc/add_filter(filter_name, list/params, force_update = FALSE)
	// Check if we already have a filter and hence don't need to rebuild filters.
	if((filter_name in filter_data) && !force_update)
		var/existing_params = filter_data[name]
		if(length(params) == length(existing_params))
			var/found_difference = FALSE
			for(var/param in (existing_params | params))
				if(params[param] != existing_params[param])
					found_difference = TRUE
					break
			if(!found_difference)
				return FALSE

	var/list/p = params.Copy()
	filter_data[filter_name] = p
	filters.Add(filter(arglist(p)))
	return TRUE

/atom/movable/proc/get_filter(filter_name)
	var/filter_index = filter_data?.Find(filter_name)
	if(filter_index > 0 && filter_index <= length(filters))
		return filters[filter_index]

// Polaris Extensions
/atom/movable/proc/remove_filter(filter_name)
	var/thing = get_filter(filter_name)
	if(isnotnull(thing))
		filter_data.Remove(filter_name)
		filters.Remove(thing)
		return TRUE
	return FALSE

// Anything below here is ported from TG.
/proc/apply_wibbly_filters(atom/movable/in_atom, length = 7)
	for(var/i in 1 to length)
		// This is a very baffling and strange way of doing this but I am just preserving old functionality
		var/pos_x
		var/pos_y
		var/rsq
		do
			pos_x = 60 * rand() - 30
			pos_y = 60 * rand() - 30
			rsq = pos_x * pos_x + pos_y * pos_y
		while(rsq < 100 || rsq > 900) // Yeah let's just loop infinitely due to bad luck what's the worst that could happen?
		var/random_roll = rand()
		in_atom.add_filter("wibbly-[i]", list(type = "wave", x = pos_y, y = pos_y, size = rand() * 2.5 + 0.5, offset = random_roll))
		animate(in_atom.get_filter("wibbly-[i]"), offset = random_roll, time = 0, loop = -1, flags = ANIMATION_PARALLEL)
		animate(offset = random_roll - 1, time = rand() * 20 + 10)

/proc/remove_wibbly_filters(atom/movable/in_atom, length = 7)
	for(var/i in 1 to length)
		animate(in_atom.get_filter("wibbly-[i]"))
		in_atom.remove_filter("wibbly-[i]")