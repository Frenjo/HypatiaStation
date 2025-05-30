GLOBAL_GLOBL_LIST_NEW(client/clients)	// List of all clients.
GLOBAL_GLOBL_LIST_NEW(client/admins)	// List of all clients whom are admins.
GLOBAL_GLOBL_ALIST_NEW(directory)		// Associative list of all ckeys with their associated client.

// Since it didn't really belong in any other category, I'm putting this here
// This is for procs to replace all the goddamn 'in world's that are chilling around the code

GLOBAL_GLOBL_ALIST_NEW(mannequins_by_ckey)

GLOBAL_GLOBL_LIST_NEW(mob/player_list)					// List of all mobs **with clients attached**. Excludes /mob/dead/new_player.
GLOBAL_GLOBL_LIST_NEW(mob/mob_list)						// List of all mobs, including clientless.
GLOBAL_GLOBL_LIST_NEW(mob/living/silicon/ai/ai_list)	// List of all AI mobs, including clientless.
GLOBAL_GLOBL_LIST_NEW(mob/living_mob_list)				// List of all alive mobs, including clientless. Excludes /mob/dead/new_player.
GLOBAL_GLOBL_LIST_NEW(mob/dead_mob_list)				// List of all dead mobs, including clientless. Includes /mob/dead/new_player.

GLOBAL_GLOBL_LIST_NEW(mob/med_hud_users) // List of all entities using a medical HUD.
GLOBAL_GLOBL_LIST_NEW(mob/sec_hud_users) // List of all entities using a security HUD.