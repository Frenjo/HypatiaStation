/*
	From stddef.dm, planes & layers built into BYOND:
		FLOAT_PLANE = -32767
		------
		FLOAT_LAYER = -1
		AREA_LAYER = 1
		TURF_LAYER = 2
		OBJ_LAYER = 3
		MOB_LAYER = 4
		FLY_LAYER = 5
		EFFECTS_LAYER = 5000
		TOPDOWN_LAYER = 10000
		BACKGROUND_LAYER = 20000
*/

/*
 * Space and Parallax
*/
#define SPACE_PLANE -98
#define SPACE_PARALLAX_PLANE -97
#define SPACE_DUST_PLANE -96
#define SPACE_PLANE_ABOVE_PARALLAX -95

/*
 * Turf
 */
#define TURF_PLANE -1
	#define TURF_BASE_LAYER -999

/*
 * Default
 */
#define DEFAULT_PLANE 0

/*
 * Lighting/Effects
 */
#define LIGHTING_PLANE 1
#define UNLIT_EFFECTS_PLANE 2

/*
 * Obscurity
 */
#define OBSCURITY_PLANE 3

/*
 * Fullscreen
 */
#define FULLSCREEN_PLANE 4

/*
 * HUD
 */
#define HUD_PLANE 5
	#define HUD_BASE_LAYER 0
	#define HUD_ITEM_LAYER 1
	#define HUD_ABOVE_ITEM_LAYER 2

/*
 * Helper Functions
*/
/atom/proc/reset_plane_and_layer()
	plane = initial(plane)
	layer = initial(layer)

/atom/proc/copy_initial_plane_and_layer(atom/to_copy)
	plane = initial(to_copy.plane)
	layer = initial(to_copy.layer)

/atom/proc/layer_to_hud()
	plane = HUD_PLANE
	layer = HUD_ITEM_LAYER