/var/global/list/cable_list = list()				//Index for all cables, so that powernets don't have to look through the entire world all the time
/var/global/list/mechas_list = list()				//list of all mechs. Used by hostile mobs target tracking.

// Posters
/var/global/list/datum/poster/poster_designs = SUBTYPESOF(/datum/poster)

// These networks can only be accessed by preexisting terminals. AIs and new terminals can't use them.
/var/global/list/restricted_camera_networks = list(
	"thunder",
	"ERT",
	"NUKE"
)

// Reference list for disposal sort junctions. Set the sortType variable on disposal sort junctions to
// the index of the sort department that you want. For example, sortType set to 2 will reroute all packages
// tagged for the Cargo Bay.
/var/global/list/tagger_locations = list(
	"Disposals", "Cargo Bay", "QM Office", "Engineering",
	"CE Office", "Atmospherics", "Security", "HoS Office",
	"Medbay", "CMO Office", "Chemistry", "Research",
	"RD Office", "Robotics", "HoP Office", "Library",
	"Chapel", "Theatre", "Bar", "Kitchen", "Hydroponics",
	"Janitor Closet", "Genetics"
)

/var/global/list/light_type_cache = list()
/var/global/list/solars_list = list()