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