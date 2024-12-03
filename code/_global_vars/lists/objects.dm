GLOBAL_GLOBL_LIST_NEW(movable_atom_list) // A list of all movable atoms in the world. Explicitly typing this as /atom/movable causes things to break for some reason.

GLOBAL_GLOBL_LIST_NEW(obj/structure/cable/cable_list)	// Index for all cables, so that powernets don't have to look through the entire world all the time
GLOBAL_GLOBL_LIST_NEW(mechas_list)	//list of all mechs. Used by hostile mobs target tracking.

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

GLOBAL_GLOBL_LIST_NEW(obj/item/pda/pda_list)
GLOBAL_GLOBL_LIST_NEW(pda_chatrooms)

GLOBAL_GLOBL_LIST_NEW(obj/machinery/door/airlock/airlocks_list)
GLOBAL_GLOBL_LIST_NEW(obj/machinery/door/airlock/maintenance/maintenance_airlocks_list)

GLOBAL_GLOBL_LIST_NEW(obj/machinery/conveyor/conveyors_list)

// A list of all newscasters in existence.
GLOBAL_GLOBL_LIST_NEW(obj/machinery/newscaster/all_newscasters)

GLOBAL_GLOBL_LIST_NEW(obj/machinery/bot/bots_list)