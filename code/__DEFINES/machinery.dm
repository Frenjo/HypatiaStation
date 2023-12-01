#define CELLRATE	0.002	// multiplier for watts per tick <> cell storage (eg: 0.02 means if there is a load of 1000 watts, 20 units will be taken from a cell per second)
#define CHARGELEVEL	0.0005	// Cap for how fast cells charge, as a percentage-per-tick (0.01 means cellcharge is capped to 1% per second)

#define SMESRATE 0.05			// rate of internal charge to external power

// Doors!
#define DOOR_CRUSH_DAMAGE 10

// Values for the power_state variable.
// These must be in string form as they're keys in an associative list.
#define USE_POWER_OFF		"0" // Don't run the auto.
#define USE_POWER_IDLE		"1" // Run auto, use idle.
#define USE_POWER_ACTIVE	"2" // Run auto, use active.

// Values for the power_channel variable.
#define EQUIP	1 // Use the equipment power channel.
#define LIGHT	2 // Use the lighting power channel.
#define ENVIRON	3 // Use the environment power channel.
#define TOTAL	4 // For total power used only.

// bitflags for machine stat variable
#define BROKEN		1
#define NOPOWER		2
#define POWEROFF	4		// tbd
#define MAINT		8		// under maintaince
#define EMPED		16		// temporary broken by EMP pulse

//bitflags for door switches.
#define OPEN	1
#define IDSCAN	2
#define BOLTS	4
#define SHOCK	8
#define SAFE	16

#define ENGINE_EJECT_Z	3

// Door stuff.
#define DOOR_OPEN 1
#define DOOR_CLOSED 2