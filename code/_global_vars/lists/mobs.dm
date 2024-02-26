GLOBAL_GLOBL_LIST_NEW(client/clients)	// List of all clients.
GLOBAL_GLOBL_LIST_NEW(admins)			// List of all clients whom are admins.
GLOBAL_GLOBL_LIST_NEW(directory)		// List of all ckeys with associated client.

// Since it didn't really belong in any other category, I'm putting this here
// This is for procs to replace all the goddamn 'in world's that are chilling around the code

GLOBAL_GLOBL_LIST_NEW(player_list)						// List of all mobs **with clients attached**. Excludes /mob/new_player.
GLOBAL_GLOBL_LIST_NEW(mob/mob_list)						// List of all mobs, including clientless.
GLOBAL_GLOBL_LIST_NEW(mob/living/silicon/ai/ai_list)	// List of all AI mobs, including clientless.
GLOBAL_GLOBL_LIST_NEW(mob/living_mob_list)				// List of all alive mobs, including clientless. Excludes /mob/new_player.
GLOBAL_GLOBL_LIST_NEW(mob/dead_mob_list)				// List of all dead mobs, including clientless. Includes /mob/new_player.

GLOBAL_GLOBL_LIST_NEW(med_hud_users) // List of all entities using a medical HUD.
GLOBAL_GLOBL_LIST_NEW(sec_hud_users) // List of all entities using a security HUD.