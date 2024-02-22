#define HUMAN_STRIP_DELAY (4 SECONDS) // How long it takes, in deciseconds, to strip someone. Default is 4 seconds.

#define SHOES_SLOWDOWN -1.0			// How much shoes slow you down by default. Negative values speed you up

//Object specific defines
#define CANDLE_LUM 3 //For how bright candles are

//ITEM INVENTORY SLOT BITMASKS
// These are used by /obj/item/var/slot_flags.
#define SLOT_OCLOTHING	BITFLAG(1)
#define SLOT_ICLOTHING	BITFLAG(2)
#define SLOT_GLOVES		BITFLAG(3)
#define SLOT_EYES		BITFLAG(4)
#define SLOT_EARS		BITFLAG(5)
#define SLOT_MASK		BITFLAG(6)
#define SLOT_HEAD		BITFLAG(7)
#define SLOT_FEET		BITFLAG(8)
#define SLOT_ID			BITFLAG(9)
#define SLOT_BELT		BITFLAG(10)
#define SLOT_BACK		BITFLAG(11)
#define SLOT_POCKET		BITFLAG(12)	//this is to allow items with a w_class of 3 or 4 to fit in pockets.
#define SLOT_DENYPOCKET	BITFLAG(13)	//this is to deny items with a w_class of 2 or 1 to fit in pockets.
#define SLOT_TWOEARS	BITFLAG(14)
#define SLOT_LEGS		BITFLAG(15)

//FLAGS BITMASK
#define STOPSPRESSUREDAMAGE BITFLAG(0)	//This flag is used on the flags variable for SUIT and HEAD items which stop pressure damage.
										//To successfully stop you taking all pressure damage you must have both a suit and head item with this flag.

#define USEDELAY	BITFLAG(1)	// 1 second extra delay on use (Can be used once every 2s)
#define NODELAY		BITFLAG(2)	// 1 second attackby delay skipped (Can be used once every 0.2s). Most objects have a 1s attackby delay, which doesn't require a flag.
#define AIRTIGHT	BITFLAG(3)	// mask allows internals
#define NOSHIELD	BITFLAG(4)	// weapon not affected by shield
#define CONDUCT		BITFLAG(5)	// conducts electricity (metal etc.)
#define ON_BORDER	BITFLAG(6)	// item has priority to check when entering or leaving
#define NOBLUDGEON	BITFLAG(7)	// when an item has this it produces no "X has been hit by Y with Z" message with the default handler
#define NOBLOODY	BITFLAG(8)	// used to items if they don't want to get a blood overlay

// TODO: Possibly merge these down into generic COVERSEYES and COVERSMOUTH.
#define GLASSESCOVERSEYES	BITFLAG(9)
#define MASKCOVERSEYES		BITFLAG(9)	// get rid of some of the other retardation in these flags
#define HEADCOVERSEYES		BITFLAG(9)	// feel free to realloc these numbers for other purposes
#define MASKCOVERSMOUTH		BITFLAG(10)	// on other items, these are just for mask/head
#define HEADCOVERSMOUTH		BITFLAG(10)

#define NOSLIP	BITFLAG(11)	//prevents from slipping on wet floors, in space etc

#define OPENCONTAINER	BITFLAG(12)	// is an open container for chemistry purposes

#define BLOCK_GAS_SMOKE_EFFECT	BITFLAG(13)	// blocks the effect that chemical clouds would have on a mob --glasses, mask and helmets ONLY!
#define ONESIZEFITSALL			BITFLAG(14)
#define PLASMAGUARD				BITFLAG(15)	//Does not get contaminated by plasma.

#define	NOREACT	BITFLAG(16)	//Reagents dont' react inside this container.

#define BLOCKHEADHAIR	BITFLAG(17)	// temporarily removes the user's hair overlay. Leaves facial hair.
#define BLOCKHAIR		BITFLAG(18)	// temporarily removes the user's hair, facial and otherwise.

//Bit flags for the flags_inv variable, which determine when a piece of clothing hides another. IE a helmet hiding glasses.
// These apply only to the exterior suit:
#define HIDEGLOVES		BITFLAG(0)
#define HIDESUITSTORAGE	BITFLAG(1)
#define HIDEJUMPSUIT	BITFLAG(2)
#define HIDESHOES		BITFLAG(3)
#define HIDETAIL 		BITFLAG(4)
// These apply only to helmets/masks:
#define HIDEMASK	BITFLAG(0)
#define HIDEEARS	BITFLAG(1)	// Ears means headsets and such.
#define HIDEEYES	BITFLAG(2)	// Eyes means glasses.
#define HIDEFACE	BITFLAG(3)	// Dictates whether we appear as unknown.

// Slot ID defines.
#define SLOT_ID_BACK		1
#define SLOT_ID_WEAR_MASK	2
#define SLOT_ID_HANDCUFFED	3
#define SLOT_ID_L_HAND		4
#define SLOT_ID_R_HAND		5
#define SLOT_ID_BELT		6
#define SLOT_ID_WEAR_ID		7
#define SLOT_ID_L_EAR		8
#define SLOT_ID_GLASSES		9
#define SLOT_ID_GLOVES		10
#define SLOT_ID_HEAD		11
#define SLOT_ID_SHOES		12
#define SLOT_ID_WEAR_SUIT	13
#define SLOT_ID_W_UNIFORM	14
#define SLOT_ID_L_STORE		15
#define SLOT_ID_R_STORE		16
#define SLOT_ID_S_STORE		17
#define SLOT_ID_IN_BACKPACK	18
#define SLOT_ID_LEGCUFFED	19
#define SLOT_ID_R_EAR		20
#define SLOT_ID_LEGS		21

//Cant seem to find a mob bitflags area other than the powers one

// bitflags for clothing parts
#define HEAD			BITFLAG(0)
#define UPPER_TORSO		BITFLAG(1)
#define LOWER_TORSO		BITFLAG(2)
#define LEG_LEFT		BITFLAG(3)
#define LEG_RIGHT		BITFLAG(4)
#define LEGS			(LEG_LEFT | LEG_RIGHT)
#define FOOT_LEFT		BITFLAG(5)
#define FOOT_RIGHT		BITFLAG(6)
#define FEET			(FOOT_LEFT | FOOT_RIGHT)
#define ARM_LEFT		BITFLAG(7)
#define ARM_RIGHT		BITFLAG(8)
#define ARMS			(ARM_LEFT | ARM_RIGHT)
#define HAND_LEFT		BITFLAG(9)
#define HAND_RIGHT		BITFLAG(10)
#define HANDS			(HAND_LEFT | HAND_RIGHT)
#define FULL_BODY		(HEAD | UPPER_TORSO | LEGS | FEET | ARMS | HANDS)

// bitflags for the percentual amount of protection a piece of clothing which covers the body part offers.
// Used with human/proc/get_heat_protection() and human/proc/get_cold_protection()
// The values here should add up to 1.
// Hands and feet have 2.5%, arms and legs 7.5%, each of the torso parts has 15% and the head has 30%
#define THERMAL_PROTECTION_HEAD			0.3
#define THERMAL_PROTECTION_UPPER_TORSO	0.15
#define THERMAL_PROTECTION_LOWER_TORSO	0.15
#define THERMAL_PROTECTION_LEG_LEFT		0.075
#define THERMAL_PROTECTION_LEG_RIGHT	0.075
#define THERMAL_PROTECTION_FOOT_LEFT	0.025
#define THERMAL_PROTECTION_FOOT_RIGHT	0.025
#define THERMAL_PROTECTION_ARM_LEFT		0.075
#define THERMAL_PROTECTION_ARM_RIGHT	0.075
#define THERMAL_PROTECTION_HAND_LEFT	0.025
#define THERMAL_PROTECTION_HAND_RIGHT	0.025

// Pressure limits.
#define HAZARD_HIGH_PRESSURE	550		//This determins at what pressure the ultra-high pressure red icon is displayed. (This one is set as a constant)
#define WARNING_HIGH_PRESSURE	325		//This determins when the orange pressure icon is displayed (it is 0.7 * HAZARD_HIGH_PRESSURE)
#define WARNING_LOW_PRESSURE	50		//This is when the gray low pressure icon is displayed. (it is 2.5 * HAZARD_LOW_PRESSURE)
#define HAZARD_LOW_PRESSURE		20		//This is when the black ultra-low pressure icon is displayed. (This one is set as a constant)

#define TEMPERATURE_DAMAGE_COEFFICIENT	1.5	//This is used in handle_temperature_damage() for humans, and in reagents that affect body temperature. Temperature damage is multiplied by this amount.
#define BODYTEMP_AUTORECOVERY_DIVISOR	12	//This is the divisor which handles how much of the temperature difference between the current body temperature and 310.15K (optimal temperature) humans auto-regenerate each tick. The higher the number, the slower the recovery. This is applied each tick, so long as the mob is alive.
#define BODYTEMP_AUTORECOVERY_MINIMUM	1	//Minimum amount of kelvin moved toward 310.15K per tick. So long as abs(310.15 - bodytemp) is more than 50.
#define BODYTEMP_COLD_DIVISOR			6	//Similar to the BODYTEMP_AUTORECOVERY_DIVISOR, but this is the divisor which is applied at the stage that follows autorecovery. This is the divisor which comes into play when the human's loc temperature is lower than their body temperature. Make it lower to lose bodytemp faster.
#define BODYTEMP_HEAT_DIVISOR			6	//Similar to the BODYTEMP_AUTORECOVERY_DIVISOR, but this is the divisor which is applied at the stage that follows autorecovery. This is the divisor which comes into play when the human's loc temperature is higher than their body temperature. Make it lower to gain bodytemp faster.
#define BODYTEMP_COOLING_MAX			-30	//The maximum number of degrees that your body can cool in 1 tick, when in a cold area.
#define BODYTEMP_HEATING_MAX			30	//The maximum number of degrees that your body can heat up in 1 tick, when in a hot area.

#define BODYTEMP_HEAT_DAMAGE_LIMIT 360.15 // The limit the human body can take before it starts taking damage from heat.
#define BODYTEMP_COLD_DAMAGE_LIMIT 260.15 // The limit the human body can take before it starts taking damage from coldness.

#define SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE	2.0		//what min_cold_protection_temperature is set to for space-helmet quality headwear. MUST NOT BE 0.
#define SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE		2.0		//what min_cold_protection_temperature is set to for space-suit quality jumpsuits or suits. MUST NOT BE 0.
#define SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE		5000	//These need better heat protect
#define FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE		30000	//what max_heat_protection_temperature is set to for firesuit quality headwear. MUST NOT BE 0.
#define FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE		30000	//for fire helmet quality items (red and white hardhats)
#define HELMET_MIN_COLD_PROTECTION_TEMPERATURE			160		//For normal helmets
#define HELMET_MAX_HEAT_PROTECTION_TEMPERATURE			600		//For normal helmets
#define ARMOR_MIN_COLD_PROTECTION_TEMPERATURE			160		//For armor
#define ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE			600		//For armor

#define GLOVES_MIN_COLD_PROTECTION_TEMPERATURE	2.0		//For some gloves (black and)
#define GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE	1500	//For some gloves
#define SHOE_MIN_COLD_PROTECTION_TEMPERATURE	2.0		//For gloves
#define SHOE_MAX_HEAT_PROTECTION_TEMPERATURE	1500	//For gloves

//Fire
#define FIRE_MIN_STACKS -20
#define FIRE_MAX_STACKS 25
//If the number of stacks goes above this firesuits won't protect you anymore. If not you can walk around while on fire like a badass.
#define FIRE_MAX_FIRESUIT_STACKS 20

#define PRESSURE_SUIT_REDUCTION_COEFFICIENT 0.8 //This is how much (percentual) a suit with the flag STOPSPRESSUREDMAGE reduces pressure.
#define PRESSURE_HEAD_REDUCTION_COEFFICIENT 0.4 //This is how much (percentual) a helmet/hat with the flag STOPSPRESSUREDMAGE reduces pressure.

// Energy gun related modes and settings.
#define GUN_MODE_PULSE	"pulse"
#define GUN_MODE_BEAM	"beam"

#define GUN_SETTING_STUN	"stun"
#define GUN_SETTING_DISABLE	"disable"
#define GUN_SETTING_KILL	"kill"
#define GUN_SETTING_DESTROY	"destroy"
#define GUN_SETTING_SPECIAL	"special"