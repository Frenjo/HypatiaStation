/*
 * Circuit Grid Floor Tiles
 */
/obj/item/stack/tile/circuit_grid // This is pretty much just a copypaste of /metal (except for matter_amounts) pending changes.
	desc = "These could work as a pretty decent throwing weapon!"
	force = 6
	matter_amounts = list(/decl/material/steel = (MATERIAL_AMOUNT_PER_SHEET / 4), /decl/material/glass = (MATERIAL_AMOUNT_PER_SHEET / 4))
	throwforce = 15
	throw_speed = 5
	throw_range = 20
	obj_flags = OBJ_FLAG_CONDUCT

// Blue
/obj/item/stack/tile/circuit_grid/blue
	name = "blue circuit grid floor tile"
	singular_name = "blue circuit grid floor tile"
	icon_state = "blue_circuit"
	turf_path = /turf/open/floor/circuit_grid/blue

// Green
/obj/item/stack/tile/circuit_grid/green
	name = "green circuit grid floor tile"
	singular_name = "green circuit grid floor tile"
	icon_state = "green_circuit"
	turf_path = /turf/open/floor/circuit_grid/green