/*
 * World
 *
 * The BYOND world object stores some basic BYOND-level config, and has a few hub specific procs for managing hub visiblity.
 *
 * The /world/New() proc is the root of where a round itself begins, try looking in game/world.dm.
 *
 * Two possibilities exist: either we are alone in the Universe or we are not. Both are equally terrifying. ~ Arthur C. Clarke
*/
/world
	mob = /mob/dead/new_player
	turf = /turf/space
	area = /area/space
	view = "15x15"
	cache_lifespan = 0	//stops player uploaded stuff from being kept in the rsc past the current session

	sleep_offline = TRUE

	hub = "Exadv1.spacestation13"
	hub_password = "kMZy3U5jJHSiBQjr"
	name = "Space Station 13"

/* This is for any host that would like their server to appear on the main SS13 hub.
To use it, simply replace the password above, with the password found below, and it should work.
If not, let us know on the main tgstation IRC channel of irc.rizon.net #tgstation13 we can help you there.

	hub = "Exadv1.spacestation13"
	hub_password = "kMZy3U5jJHSiBQjr"
	name = "Space Station 13"
*/