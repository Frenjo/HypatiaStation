// Creates a new turf.
/turf/proc/ChangeTurf(turf/type_path)
	RETURN_TYPE(/turf)

	if(isnull(type_path))
		return

///// Z-Level Stuff ///// This makes sure that turfs are not changed to space when one side is part of a zone
	if(type_path == /turf/space)
		var/turf/controller = locate(1, 1, z)
		for(var/obj/effect/landmark/zcontroller/c in controller)
			if(c.down)
				var/turf/below = locate(x, y, c.down_target)
				if((global.PCair.has_valid_zone(below) || global.PCair.has_valid_zone(src)) && !isspace(below)) // dont make open space into space, its pointless and makes people drop out of the station
					var/turf/W = ChangeTurf(/turf/simulated/floor/open)
					var/list/temp = list()
					temp.Add(W)
					c.add(temp, 3, 1) // report the new open space to the zcontroller
					return W
///// Z-Level Stuff

	var/obj/fire/old_fire = fire

	var/old_opacity = opacity
	var/old_dynamic_lighting = dynamic_lighting
	var/old_affecting_lights = affecting_lights
	var/old_lighting_overlay = lighting_overlay
	var/old_corners = corners

	connections?.erase_all()

	if(issimulated(src))
		//Yeah, we're just going to rebuild the whole thing.
		//Despite this being called a bunch during explosions,
		//the zone will only really do heavy lifting once.
		var/turf/simulated/S = src
		if(isnotnull(S.zone))
			S.zone.rebuild()

	qdel(src) // Executes the Destroy() chain.
	var/turf/new_turf = new type_path(src)

	if(ispath(type_path, /turf/simulated/floor))
		if(old_fire)
			fire = old_fire
		new_turf.RemoveLattice()
	else
		old_fire?.RemoveFire()

	global.PCair?.mark_for_update(src)

	for(var/turf/space/S in range(new_turf, 1))
		S.update_starlight()

	new_turf.levelupdate()
	. = new_turf

	recalc_atom_opacity()

	if(GLOBL.lighting_overlays_initialised)
		lighting_overlay = old_lighting_overlay
		affecting_lights = old_affecting_lights
		corners = old_corners
		if(old_opacity != opacity || dynamic_lighting != old_dynamic_lighting)
			reconsider_lights()
		if(dynamic_lighting != old_dynamic_lighting)
			if(dynamic_lighting)
				lighting_build_overlay()
			else
				lighting_clear_overlay()

/turf/proc/transport_properties_from(turf/other)
	if(!istype(other, src.type))
		return 0

	set_dir(other.dir)
	icon_state = other.icon_state
	icon = other.icon
	overlays = other.overlays.Copy()
	underlays = other.underlays.Copy()
	return 1

//I would name this copy_from() but we remove the other turf from their air zone for some reason
/turf/simulated/transport_properties_from(turf/simulated/other)
	if(!..())
		return 0

	if(other.zone)
		if(isnull(air))
			make_air()
		air.copy_from(other.zone.air)
		other.zone.remove(other)
	return 1

//No idea why resetting the base appearence from New() isn't enough, but without this it doesn't work
/turf/closed/wall/shuttle/corner/exterior/transport_properties_from(turf/simulated/other)
	. = ..()
	reset_base_appearance()

/turf/proc/ReplaceWithLattice()
	ChangeTurf(get_base_turf_by_area(get_area(loc)))
	new /obj/structure/lattice(locate(x, y, z))

// Removes all signs of lattice on the pos of the turf -Donkieyo
/turf/proc/RemoveLattice()
	var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
	if(isnotnull(L))
		qdel(L)