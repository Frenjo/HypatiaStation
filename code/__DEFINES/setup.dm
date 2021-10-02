//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

//#define DEBUG

//Bluh shields

var/static/list/scarySounds = list(
	'sound/weapons/thudswoosh.ogg', 'sound/weapons/Taser.ogg', 'sound/weapons/armbomb.ogg',
	'sound/voice/hiss1.ogg', 'sound/voice/hiss2.ogg', 'sound/voice/hiss3.ogg', 'sound/voice/hiss4.ogg',
	'sound/voice/hiss5.ogg', 'sound/voice/hiss6.ogg', 'sound/effects/Glassbr1.ogg', 'sound/effects/Glassbr2.ogg',
	'sound/effects/Glassbr3.ogg', 'sound/items/Welder.ogg', 'sound/items/Welder2.ogg', 'sound/machines/airlock.ogg',
	'sound/effects/clownstep1.ogg', 'sound/effects/clownstep2.ogg'
)

var/list/liftable_structures = list(
	/obj/machinery/autolathe,
	/obj/machinery/constructable_frame,
	/obj/machinery/hydroponics,
	/obj/machinery/computer,
	/obj/machinery/optable,
	/obj/structure/dispenser,
	/obj/machinery/gibber,
	/obj/machinery/microwave,
	/obj/machinery/vending,
	/obj/machinery/seed_extractor,
	/obj/machinery/space_heater,
	/obj/machinery/recharge_station,
	/obj/machinery/flasher,
	/obj/structure/stool,
	/obj/structure/closet,
	/obj/machinery/photocopier,
	/obj/structure/filingcabinet,
	/obj/structure/reagent_dispensers,
	/obj/machinery/portable_atmospherics/canister
)

//some arbitrary defines to be used by self-pruning global lists. (see master_controller)
#define PROCESS_KILL 26	//Used to trigger removal from a processing list

// Reference list for disposal sort junctions. Set the sortType variable on disposal sort junctions to
// the index of the sort department that you want. For example, sortType set to 2 will reroute all packages
// tagged for the Cargo Bay.
var/list/TAGGERLOCATIONS = list(
	"Disposals", "Cargo Bay", "QM Office", "Engineering",
	"CE Office", "Atmospherics", "Security", "HoS Office",
	"Medbay", "CMO Office", "Chemistry", "Research",
	"RD Office", "Robotics", "HoP Office", "Library",
	"Chapel", "Theatre", "Bar", "Kitchen", "Hydroponics",
	"Janitor Closet", "Genetics"
)

// Energy gun related modes and settings.
#define GUN_MODE_PULSE 0
#define GUN_MODE_BEAM 1

#define GUN_SETTING_STUN 0
#define GUN_SETTING_DISABLE 1
#define GUN_SETTING_KILL 2
#define GUN_SETTING_DESTROY 3
#define GUN_SETTING_SPECIAL 4