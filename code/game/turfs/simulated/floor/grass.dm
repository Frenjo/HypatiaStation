/*
 * Grass
 */
/turf/simulated/floor/grass
	name = "grass patch"
	icon_state = "grass1"
	tile_path = /obj/item/stack/tile/grass

/turf/simulated/floor/grass/New()
	icon_state = "grass[pick("1","2","3","4")]"
	. = ..()

/turf/simulated/floor/grass/attack_tool(obj/item/tool, mob/user)
	if(istype(tool, /obj/item/shovel))
		new /obj/item/ore/glass(src)
		new /obj/item/ore/glass(src) //Make some sand if you shovel grass
		to_chat(user, SPAN_INFO("You shovel the grass."))
		make_plating()
		return TRUE
	return ..()

/turf/simulated/floor/grass/update_special()
	for(var/direction in GLOBL.cardinal)
		if(istype(get_step(src, direction), /turf/simulated/floor))
			var/turf/simulated/floor/FF = get_step(src, direction)
			FF.update_icon() //so siding get updated properly

/turf/simulated/floor/grass/update_icon()
	if(!broken && !burnt)
		if(!(icon_state in list("grass1","grass2","grass3","grass4")))
			icon_state = "grass[pick("1","2","3","4")]"

/turf/simulated/floor/grass/break_tile()
	icon_state = "sand[pick("1","2","3")]"
	broken = 1

/turf/simulated/floor/grass/burn_tile()
	icon_state = "sand[pick("1","2","3")]"
	burnt = 1

/turf/simulated/floor/grass/return_siding_icon_state()
	. = ..()
	var/dir_sum = 0
	for(var/direction in GLOBL.cardinal)
		var/turf/T = get_step(src, direction)
		if(!istype(T, /turf/simulated/floor/grass))
			dir_sum += direction
	if(dir_sum)
		return "wood_siding[dir_sum]"
	else
		return 0