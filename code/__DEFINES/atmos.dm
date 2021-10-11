#define CELL_VOLUME 		2500 //liters in a cell
#define MOLES_CELLSTANDARD	(ONE_ATMOSPHERE * CELL_VOLUME / (T20C * R_IDEAL_GAS_EQUATION)) //moles in a 2.5 m^3 cell at 101.325 Pa and 20 degC

#define O2STANDARD 0.21
#define N2STANDARD 0.79

#define MOLES_O2STANDARD (MOLES_CELLSTANDARD * O2STANDARD) // O2 standard value (21%)
#define MOLES_N2STANDARD (MOLES_CELLSTANDARD * N2STANDARD) // N2 standard value (79%)

#define MIN_PLASMA_DAMAGE 1
#define MAX_PLASMA_DAMAGE 10

#define BREATH_VOLUME		0.5 //liters in a normal breath
#define BREATH_MOLES		(ONE_ATMOSPHERE * BREATH_VOLUME / (T20C * R_IDEAL_GAS_EQUATION))
#define BREATH_PERCENTAGE	(BREATH_VOLUME / CELL_VOLUME)
//Amount of air to take a from a tile
#define HUMAN_NEEDED_OXYGEN	(MOLES_CELLSTANDARD * BREATH_PERCENTAGE * 0.16)
//Amount of air needed before pass out/suffocation commences

#define SOUND_MINIMUM_PRESSURE 10

#define PRESSURE_DAMAGE_COEFFICIENT	4 //The amount of pressure damage someone takes is equal to (pressure / HAZARD_HIGH_PRESSURE)*PRESSURE_DAMAGE_COEFFICIENT, with the maximum of MAX_PRESSURE_DAMAGE
#define MAX_HIGH_PRESSURE_DAMAGE	4 //This used to be 20... I got this much random rage for some retarded decision by polymorph?! Polymorph now lies in a pool of blood with a katana jammed in his spleen. ~Errorage --PS: The katana did less than 20 damage to him :(
#define LOW_PRESSURE_DAMAGE			2 //The amounb of damage someone takes when in a low pressure area (The pressure threshold is so low that it doesn't make sense to do any calculations, so it just applies this flat value).

#define MINIMUM_AIR_RATIO_TO_SUSPEND 0.05
//Minimum ratio of air that must move to/from a tile to suspend group processing
#define MINIMUM_AIR_TO_SUSPEND (MOLES_CELLSTANDARD * MINIMUM_AIR_RATIO_TO_SUSPEND)
//Minimum amount of air that has to move before a group processing can be suspended

#define MINIMUM_MOLES_DELTA_TO_MOVE (MOLES_CELLSTANDARD * MINIMUM_AIR_RATIO_TO_SUSPEND) //Either this must be active
#define MINIMUM_TEMPERATURE_TO_MOVE	T20C + 100 		  //or this (or both, obviously)

#define MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND 0.012
#define MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND 4
//Minimum temperature difference before group processing is suspended
#define MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER 0.5
//Minimum temperature difference before the gas temperatures are just set to be equal

#define MINIMUM_TEMPERATURE_FOR_SUPERCONDUCTION		T20C + 10
#define MINIMUM_TEMPERATURE_START_SUPERCONDUCTION	T20C + 200

#define FLOOR_HEAT_TRANSFER_COEFFICIENT		0.4
#define WALL_HEAT_TRANSFER_COEFFICIENT		0.0
#define DOOR_HEAT_TRANSFER_COEFFICIENT		0.0
#define SPACE_HEAT_TRANSFER_COEFFICIENT		0.2 //a hack to partly simulate radiative heat
#define OPEN_HEAT_TRANSFER_COEFFICIENT		0.4
#define WINDOW_HEAT_TRANSFER_COEFFICIENT	0.1 //a hack for now
//Must be between 0 and 1. Values closer to 1 equalize temperature faster
//Should not exceed 0.4 else strange heat flow occur

/*
#define FIRE_MINIMUM_TEMPERATURE_TO_SPREAD	150+T0C
#define FIRE_MINIMUM_TEMPERATURE_TO_EXIST	100+T0C
#define FIRE_SPREAD_RADIOSITY_SCALE		0.85
#define FIRE_CARBON_ENERGY_RELEASED	  500000 //Amount of heat released per mole of burnt carbon into the tile
#define FIRE_PLASMA_ENERGY_RELEASED	 3000000 //Amount of heat released per mole of burnt plasma into the tile
#define FIRE_GROWTH_RATE			40000 //For small fires

#define WATER_BOIL_TEMP 393 */

//Used to be used by FEA
//var/turf/space/Space_Tile = locate(/turf/space) // A space tile to reference when atmos wants to remove excess heat.

// Fire Damage
#define CARBON_LIFEFORM_FIRE_RESISTANCE 200 + T0C
#define CARBON_LIFEFORM_FIRE_DAMAGE		4

//Plasma fire properties
#define PLASMA_MINIMUM_BURN_TEMPERATURE		100 + T0C
#define PLASMA_FLASHPOINT					246 + T0C
#define PLASMA_UPPER_TEMPERATURE			1370 + T0C
#define PLASMA_MINIMUM_OXYGEN_NEEDED		2
#define PLASMA_MINIMUM_OXYGEN_PLASMA_RATIO	20
#define PLASMA_OXYGEN_FULLBURN				10

//XGM gas flags
#define XGM_GAS_FUEL		1
#define XGM_GAS_OXIDIZER	2
#define XGM_GAS_CONTAMINANT	4

#define TANK_LEAK_PRESSURE		(30. * ONE_ATMOSPHERE)	// Tank starts leaking
#define TANK_RUPTURE_PRESSURE	(40. * ONE_ATMOSPHERE) // Tank spills all contents into atmosphere

#define TANK_FRAGMENT_PRESSURE	(50. * ONE_ATMOSPHERE) // Boom 3x3 base explosion
#define TANK_FRAGMENT_SCALE		(10. * ONE_ATMOSPHERE) // +1 for each SCALE kPa aboe threshold
								// was 2 atm

#define NORMPIPERATE 30					//pipe-insulation rate divisor
#define HEATPIPERATE 8					//heat-exch pipe insulation

#define FLOWFRAC 0.99				// fraction of gas transfered per process

//Flags for zone sleeping
#define ZONE_ACTIVE		1
#define ZONE_SLEEPING	0

// Gas ID defines
#define GAS_OXYGEN "oxygen"
#define GAS_NITROGEN "nitrogen"
#define GAS_CARBON_DIOXIDE "carbon_dioxide"
#define GAS_PLASMA "plasma"
#define GAS_VOLATILE_FUEL "volatile_fuel"
#define GAS_SLEEPING_AGENT "sleeping_agent"
#define GAS_OXYGEN_AGENT_B "oxygen_agent_b"