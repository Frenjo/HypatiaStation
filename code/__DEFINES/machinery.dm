#define CELLRATE	0.002	// multiplier for watts per tick <> cell storage (eg: 0.02 means if there is a load of 1000 watts, 20 units will be taken from a cell per second)
#define CHARGELEVEL	0.0005	// Cap for how fast cells charge, as a percentage-per-tick (0.01 means cellcharge is capped to 1% per second)

#define SMESRATE 0.05			// rate of internal charge to external power

// Doors!
#define DOOR_CRUSH_DAMAGE 10
#define DOOR_OPEN 1
#define DOOR_CLOSED 2

// Values for the power_state variable.
#define USE_POWER_OFF		0 // Don't run the auto.
#define USE_POWER_IDLE		1 // Run auto, use idle.
#define USE_POWER_ACTIVE	2 // Run auto, use active.

// Values for the power_channel variable.
#define EQUIP	"equip" // Use the equipment power channel.
#define LIGHT	"light" // Use the lighting power channel.
#define ENVIRON	"environ" // Use the environment power channel.
#define TOTAL	"total" // For total power used only.
#define CHARGING "charging" // For APC charging only.

// bitflags for machine stat variable
#define BROKEN		BITFLAG(0)
#define NOPOWER		BITFLAG(1)
#define POWEROFF	BITFLAG(2) // tbd
#define MAINT		BITFLAG(3) // under maintaince
#define EMPED		BITFLAG(4) // temporary broken by EMP pulse

//bitflags for door switches.
#define OPEN	BITFLAG(0)
#define IDSCAN	BITFLAG(1)
#define BOLTS	BITFLAG(2)
#define SHOCK	BITFLAG(3)
#define SAFE	BITFLAG(4)

#define ENGINE_EJECT_Z	3