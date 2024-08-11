/*
 * Grass
 */
/turf/open/floor/grass
	name = "grass patch"
	icon = 'icons/turf/floors/grass.dmi'
	icon_state = "grass1"
	tile_path = /obj/item/stack/tile/grass

/turf/open/floor/grass/New()
	icon_state = "grass[pick("1","2","3","4")]"
	. = ..()

/turf/open/floor/grass/attack_tool(obj/item/tool, mob/user)
	if(istype(tool, /obj/item/shovel))
		new /obj/item/ore/glass(src)
		new /obj/item/ore/glass(src) //Make some sand if you shovel grass
		to_chat(user, SPAN_INFO("You shovel the grass."))
		make_plating()
		return TRUE
	return ..()

/turf/open/floor/grass/update_special()
	for(var/direction in GLOBL.cardinal)
		var/turf/T = get_step(src, direction)
		if(istype(T, /turf/open/floor))
			var/turf/open/floor/F = T
			F.update_icon() //so siding get updated properly

/turf/open/floor/grass/update_icon()
	. = ..()
	if(!.)
		return FALSE
	if(broken || burnt)
		return FALSE

	if(!(icon_state in list("grass1","grass2","grass3","grass4")))
		icon_state = "grass[pick(1, 2, 3, 4)]"

/turf/open/floor/grass/break_tile()
	. = ..()
	if(.)
		icon_state = "sand[pick(1, 2, 3)]"

/turf/open/floor/grass/burn_tile()
	. = ..()
	if(.)
		icon_state = "sand[pick(1, 2, 3)]"

/turf/open/floor/grass/return_siding_icon_state()
	. = ..()
	var/dir_sum = 0
	for(var/direction in GLOBL.cardinal)
		var/turf/T = get_step(src, direction)
		if(!istype(T, /turf/open/floor/grass))
			dir_sum += direction
	if(dir_sum)
		return "wood_siding[dir_sum]"
	else
		return 0