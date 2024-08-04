/*
 * Circuit Grid Floor Tiles
 */
/obj/item/stack/tile/circuit_grid // This is pretty much just a copypaste of /metal (except for matter_amounts) pending changes.
	desc = "These could work as a pretty decent throwing weapon!"
	force = 6
	matter_amounts = list(MATERIAL_METAL = 937.5, /decl/material/glass = 937.5)
	throwforce = 15
	throw_speed = 5
	throw_range = 20
	obj_flags = OBJ_FLAG_CONDUCT

// Blue
/obj/item/stack/tile/circuit_grid/blue
	name = "blue circuit grid floor tile"
	singular_name = "blue circuit grid floor tile"
	icon_state = "blue_circuit"
	turf_path = /turf/simulated/floor/circuit_grid/blue

// Green
/obj/item/stack/tile/circuit_grid/green
	name = "green circuit grid floor tile"
	singular_name = "green circuit grid floor tile"
	icon_state = "green_circuit"
	turf_path = /turf/simulated/floor/circuit_grid/green