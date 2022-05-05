/var/global/list/landmarks_list = list()			//list of all landmarks created

/var/global/list/monkeystart = list()
/var/global/list/wizardstart = list()
/var/global/list/newplayer_start = list()

/var/global/list/prisonwarp = list()		//prisoners go to these
/var/global/list/holdingfacility = list()	//captured people go here
/var/global/list/xeno_spawn = list()		//Aliens spawn at these.

//list/mazewarp = list()
/var/global/list/tdome1 = list()
/var/global/list/tdome2 = list()
/var/global/list/tdomeobserve = list()
/var/global/list/tdomeadmin = list()
/var/global/list/prisonsecuritywarp = list()	//prison security goes to these
var/list/prisonwarped = list()					//list of players already warped
/var/global/list/blobstart = list()
/var/global/list/ninjastart = list()
var/list/cardinal = list(NORTH, SOUTH, EAST, WEST)
var/list/alldirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)

/var/global/list/accessable_z_levels = list("1" = 5, "3" = 10, "4" = 15, "5" = 10, "6" = 60)
//This list contains the z-level numbers which can be accessed via space travel and the percentile chances to get there.
//(Exceptions: extended, sandbox and nuke) -Errorage
//Was list("3" = 30, "4" = 70).
//Spacing should be a reliable method of getting rid of a body -- Urist.
//Go away Urist, I'm restoring this to the longer list. ~Errorage

//Spawnpoints.
/var/list/latejoin = list()
/var/global/list/latejoin_gateway = list()
/var/global/list/latejoin_cryo = list()