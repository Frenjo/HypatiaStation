GLOBAL_GLOBL_LIST_NEW(clients)		// List of all clients.
GLOBAL_GLOBL_LIST_NEW(admins)		// List of all clients whom are admins.
GLOBAL_GLOBL_LIST_NEW(directory)	// List of all ckeys with associated client.

// Since it didn't really belong in any other category, I'm putting this here
// This is for procs to replace all the goddamn 'in world's that are chilling around the code

/var/global/list/player_list = list()				// List of all mobs **with clients attached**. Excludes /mob/new_player
/var/global/list/mob_list = list()					// List of all mobs, including clientless
/var/global/list/living_mob_list = list()			// List of all alive mobs, including clientless. Excludes /mob/new_player
/var/global/list/dead_mob_list = list()				// List of all dead mobs, including clientless. Excludes /mob/new_player

/var/global/list/med_hud_users = list() // List of all entities using a medical HUD.
/var/global/list/sec_hud_users = list() // List of all entities using a security HUD.