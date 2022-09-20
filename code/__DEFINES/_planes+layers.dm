/*
	From stddef.dm, planes & layers built into BYOND:
		FLOAT_LAYER = -1
		AREA_LAYER = 1
		TURF_LAYER = 2
		OBJ_LAYER = 3
		MOB_LAYER = 4
		FLY_LAYER = 5
		EFFECTS_LAYER = 5000
		TOPDOWN_LAYER = 10000
		BACKGROUND_LAYER = 20000
		EFFECTS_LAYER = 5000
		TOPDOWN_LAYER = 10000
		BACKGROUND_LAYER = 20000
		------
		FLOAT_PLANE = -32767
*/

/*
 * Space and Parallax
*/
#define SPACE_PLANE -98
#define SPACE_PARALLAX_PLANE -97
#define SPACE_DUST_PLANE -96
#define SPACE_PLANE_ABOVE_PARALLAX -95

/*
 * Helper Functions
*/
/atom/proc/reset_plane_and_layer()
	plane = initial(plane)
	layer = initial(layer)

/atom/proc/copy_initial_plane_and_layer(atom/to_copy)
	plane = initial(to_copy.plane)
	layer = initial(to_copy.layer)