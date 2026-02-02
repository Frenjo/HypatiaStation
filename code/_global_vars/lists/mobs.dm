GLOBAL_GLOBL_LIST_TYPED_NEW(clients, /client) // List of all clients.
GLOBAL_GLOBL_LIST_TYPED_NEW(admins, /client) // List of all clients whom are admins.
GLOBAL_GLOBL_ALIST_NEW(directory) // Associative list of all ckeys with their associated client.

// Since it didn't really belong in any other category, I'm putting this here
// This is for procs to replace all the goddamn 'in world's that are chilling around the code

GLOBAL_GLOBL_ALIST_NEW(mannequins_by_ckey)

GLOBAL_GLOBL_LIST_TYPED_NEW(player_list, /mob) // List of all mobs **with clients attached**. Excludes /mob/dead/new_player.
GLOBAL_GLOBL_LIST_TYPED_NEW(mob_list, /mob) // List of all mobs, including clientless.
GLOBAL_GLOBL_LIST_TYPED_NEW(ai_list, /mob/living/silicon/ai) // List of all AI mobs, including clientless.
GLOBAL_GLOBL_LIST_TYPED_NEW(living_mob_list, /mob) // List of all alive mobs, including clientless. Excludes /mob/dead/new_player.
GLOBAL_GLOBL_LIST_TYPED_NEW(dead_mob_list, /mob) // List of all dead mobs, including clientless. Includes /mob/dead/new_player.

GLOBAL_GLOBL_LIST_TYPED_NEW(med_hud_users, /mob) // List of all entities using a medical HUD.
GLOBAL_GLOBL_LIST_TYPED_NEW(sec_hud_users, /mob) // List of all entities using a security HUD.