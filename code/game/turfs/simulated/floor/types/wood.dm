/*
 * Wood
 */
/turf/simulated/floor/wood
	name = "floor"
	icon_state = "wood"
	tile_path = /obj/item/stack/tile/wood

/turf/simulated/floor/wood/attack_tool(obj/item/tool, mob/user)
	if(iscrowbar(tool))
		to_chat(user, SPAN_WARNING("You forcefully pry off the planks, destroying them in the process."))
		playsound(src, 'sound/items/Crowbar.ogg', 80, 1)
		make_plating()
		return TRUE

	if(isscrewdriver(tool))
		to_chat(user, SPAN_INFO("You unscrew the planks."))
		playsound(src, 'sound/items/Screwdriver.ogg', 80, 1)
		new tile_path(src)
		make_plating()
		return TRUE

	return ..()

/turf/simulated/floor/wood/update_icon()
	if(!broken && !burnt)
		if(!(icon_state in wood_icons))
			icon_state = "wood"
			//to_world("[icon_state]y's got [icon_state]")

/turf/simulated/floor/wood/break_tile()
	icon_state = "wood-broken"
	broken = 1

/turf/simulated/floor/wood/burn_tile()
	icon_state = "wood-broken"
	burnt = 1