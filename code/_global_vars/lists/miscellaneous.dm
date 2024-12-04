GLOBAL_GLOBL_LIST_NEW(decl/surgery_step/surgery_steps) // Sorted list of all surgery steps. |BS12

/var/global/list/reg_dna = list()

/var/list/global_mutations = list() // list of hidden mutation things

// Few global vars to track the blob.
// These were moved from gamemodes/blob/blob.dm so the file could be unticked properly.
GLOBAL_GLOBL_LIST_NEW(blobs)
GLOBAL_GLOBL_LIST_NEW(blob_cores)
GLOBAL_GLOBL_LIST_NEW(blob_nodes)

// Faction related lists.
// These were moved from the game ticker controller due to initialisation order changes.
// TODO: Move these somewhere more proper later.
GLOBAL_GLOBL_LIST_NEW(factions)				// list of all factions
GLOBAL_GLOBL_LIST_NEW(available_factions)	// list of factions with openings
GLOBAL_GLOBL_LIST_NEW(syndicate_coalition)	// list of traitor-compatible factions

GLOBAL_GLOBL_LIST_NEW(all_dreams)