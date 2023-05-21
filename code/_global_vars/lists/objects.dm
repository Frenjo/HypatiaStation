GLOBAL_GLOBL_LIST_NEW(cable_list)	//Index for all cables, so that powernets don't have to look through the entire world all the time
GLOBAL_GLOBL_LIST_NEW(mechas_list)	//list of all mechs. Used by hostile mobs target tracking.

// Posters
GLOBAL_GLOBL_LIST_INIT(poster_designs, SUBTYPESOF(/datum/poster))

// These networks can only be accessed by preexisting terminals. AIs and new terminals can't use them.
GLOBAL_GLOBL_LIST_INIT(restricted_camera_networks, list(
	"thunder",
	"ERT",
	"NUKE"
))

// Reference list for disposal sort junctions. Set the sortType variable on disposal sort junctions to
// the index of the sort department that you want. For example, sortType set to 2 will reroute all packages
// tagged for the Cargo Bay.
GLOBAL_GLOBL_LIST_INIT(tagger_locations, list(
	"Disposals", "Cargo Bay", "QM Office", "Engineering",
	"CE Office", "Atmospherics", "Security", "HoS Office",
	"Medbay", "CMO Office", "Chemistry", "Research",
	"RD Office", "Robotics", "HoP Office", "Library",
	"Chapel", "Theatre", "Bar", "Kitchen", "Hydroponics",
	"Janitor Closet", "Genetics"
))

GLOBAL_GLOBL_LIST_NEW(light_type_cache)
GLOBAL_GLOBL_LIST_NEW(solars_list)

GLOBAL_GLOBL_LIST_NEW(pda_list)
GLOBAL_GLOBL_LIST_NEW(pda_chatrooms)

GLOBAL_GLOBL_LIST_NEW(airlocks_list)
GLOBAL_GLOBL_LIST_NEW(maintenance_airlocks_list)

GLOBAL_GLOBL_LIST_NEW(conveyors_list)