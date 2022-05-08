// The lighting system
//
// consists of light fixtures (/obj/machinery/light) and light tube/bulb items (/obj/item/weapon/light)

#define LIGHT_POWER_FACTOR 20	//20W per unit luminosity

// status values shared between lighting fixtures and items
#define LIGHT_OK		0
#define LIGHT_EMPTY		1
#define LIGHT_BROKEN	2
#define LIGHT_BURNED	3

// Fixture construction stage values.
#define LIGHT_STAGE_ONE		1
#define LIGHT_STAGE_TWO		2
#define LIGHT_STAGE_THREE	3

// Lighting modes.
#define LIGHT_MODE_EMERGENCY "emergency_lighting"