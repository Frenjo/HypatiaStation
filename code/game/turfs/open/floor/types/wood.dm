/*
 * Wood
 */
/turf/open/floor/wood
	name = "wood floor"
	icon_state = "wood"
	tile_path = /obj/item/stack/tile/wood

/turf/open/floor/wood/attack_tool(obj/item/tool, mob/user)
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

/turf/open/floor/wood/update_icon()
	. = ..()
	if(!.)
		return FALSE
	if(broken || burnt)
		return FALSE

	if(!(icon_state in wood_icons))
		icon_state = "wood"
		//to_world("[icon_state]y's got [icon_state]")

/turf/open/floor/wood/break_tile()
	. = ..()
	if(.)
		icon_state = "wood-broken"

/turf/open/floor/wood/burn_tile()
	. = ..()
	if(.)
		icon_state = "wood-broken"