//turf-only flags
#define NOJAUNT 1

//This was a define, but I changed it to a variable so it can be changed in-game. -Errorage
/var/global/max_explosion_range = 14
//#define MAX_EXPLOSION_RANGE		14					// Defaults to 12 (was 8) -- TLE

/var/global/list/accessable_z_levels = list("1" = 5, "3" = 10, "4" = 15, "5" = 10, "6" = 60)
//This list contains the z-level numbers which can be accessed via space travel and the percentile chances to get there.
//(Exceptions: extended, sandbox and nuke) -Errorage
//Was list("3" = 30, "4" = 70).
//Spacing should be a reliable method of getting rid of a body -- Urist.
//Go away Urist, I'm restoring this to the longer list. ~Errorage

#define TRANSITIONEDGE	7 //Distance from edge to move to another z-level