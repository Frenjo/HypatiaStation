/*
 * Base tile type.
 */
/obj/item/stack/tile
	name = "base tile"
	singular_name = "base tile"
	desc = "A base floor tile. If you ever see this, something's gone wrong!"
	icon = 'icons/obj/items/stacks/tiles.dmi'

	force = 1
	throwforce = 1
	throw_speed = 5
	throw_range = 20

	max_amount = 60

	var/turf_path = null

/obj/item/stack/tile/New(loc, amount = null)
	pixel_x = rand(1, 14)
	pixel_y = rand(1, 14)
	. = ..()