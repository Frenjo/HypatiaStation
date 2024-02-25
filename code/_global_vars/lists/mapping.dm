// Directions
GLOBAL_GLOBL_LIST_INIT(cardinal, list(NORTH, SOUTH, EAST, WEST))
GLOBAL_GLOBL_LIST_INIT(alldirs, list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
GLOBAL_GLOBL_LIST_INIT(reverse_dir, list(	// reverse_dir[dir] = reverse of dir
	2, 1, 3, 8, 10, 9, 11, 4, 6, 5, 7,
	12, 14, 13, 15, 32, 34, 33, 35, 40,
	42, 41, 43, 36, 38, 37, 39, 44, 46,
	45, 47, 16, 18, 17, 19, 24, 26, 25,
	27, 20, 22, 21, 23, 28, 30, 29, 31,
	48, 50, 49, 51, 56, 58, 57, 59, 52,
	54, 53, 55, 60, 62, 61, 63
))

GLOBAL_GLOBL_LIST_INIT(accessible_z_levels, list("1" = 5, "3" = 10, "4" = 15, "5" = 10, "6" = 60))
// This list contains the z-level numbers which can be accessed via space travel and the percentile chances to get there.
// (Exceptions: extended, sandbox and nuke) -Errorage
// Was list("3" = 30, "4" = 70).
// Spacing should be a reliable method of getting rid of a body -- Urist.
// Go away Urist, I'm restoring this to the longer list. ~Errorage

// Areas
GLOBAL_GLOBL_LIST_NEW(area/area_list) // A list of all areas in the world.
GLOBAL_GLOBL_LIST_NEW(turf/simulated/simulated_turf_list) // A list of all simulated turfs in the world.

// Landmarks
GLOBAL_GLOBL_LIST_NEW(obj/effect/landmark/landmark_list) // A list of all created landmarks.

// Starts
GLOBAL_GLOBL_LIST_NEW(newplayer_start)
GLOBAL_GLOBL_LIST_NEW(monkeystart)
GLOBAL_GLOBL_LIST_NEW(wizardstart)
GLOBAL_GLOBL_LIST_NEW(blobstart)
GLOBAL_GLOBL_LIST_NEW(ninjastart)
GLOBAL_GLOBL_LIST_NEW(xeno_spawn)	// Aliens spawn at these.

// Holding Facility
GLOBAL_GLOBL_LIST_NEW(holdingfacility)	// Captured people go here.

// Maze (Unused)
//GLOBAL_GLOBL_LIST_NEW(mazewarp)

// Thunderdome
GLOBAL_GLOBL_LIST_NEW(tdome1)
GLOBAL_GLOBL_LIST_NEW(tdome2)
GLOBAL_GLOBL_LIST_NEW(tdomeobserve)
GLOBAL_GLOBL_LIST_NEW(tdomeadmin)

// Prison
GLOBAL_GLOBL_LIST_NEW(prisonwarp)			// Prisoners go to these.
GLOBAL_GLOBL_LIST_NEW(prisonsecuritywarp)	// Prison security goes to these.
GLOBAL_GLOBL_LIST_NEW(prisonwarped)			// List of players already warped.

// Spawnpoints
GLOBAL_GLOBL_LIST_NEW(latejoin)
GLOBAL_GLOBL_LIST_NEW(latejoin_gateway)
GLOBAL_GLOBL_LIST_NEW(latejoin_cryo)

// Away Missions
GLOBAL_GLOBL_LIST_NEW(awaydestinations)	// A list of landmarks that the warpgate can take you to.