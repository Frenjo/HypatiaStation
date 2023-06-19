// Maths constants.
#define R_IDEAL_GAS_EQUATION	8.31	// kPa * L / (K * mol)
#define ONE_ATMOSPHERE			101.325	// kPa

#define SPEED_OF_LIGHT		3e8 // Not exact but hey!
#define SPEED_OF_LIGHT_SQ	9e+16

#define T0C		273.15	// 0 degrees celsius.
#define T20C	293.15	// 20 degrees celsius.
#define TCMB	2.7		// -270.3 degrees celsius.

// Radiation constants.
#define STEFAN_BOLTZMANN_CONSTANT		5.6704e-8	// W/(m^2 * K^4).
#define IDEAL_GAS_ENTROPY_CONSTANT		1164		// (mol^3 * s^3)/(kg^3 * L)...
// ... Equal to (4 * pi / (avrogadro's number * planck's constant)^2)^(3 / 2) / (avrogadro's number * 1000 Liters per m^3).
#define COSMIC_RADIATION_TEMPERATURE	3.15		// K.
#define AVERAGE_SOLAR_RADIATION			200			// W/m^2. Kind of arbitrary. Really this should depend on the sun position much like solars.
#define RADIATOR_OPTIMUM_PRESSURE		3771		// kPa at 20 C. This should be higher as gases aren't great conductors until they are dense...
// ... Used the critical pressure for air.
#define GAS_CRITICAL_TEMPERATURE		132.65		// K. The critical point temperature for air.

#define RADIATOR_EXPOSED_SURFACE_AREA_RATIO 0.04 // (3cm + 100cm * sin(3deg))/(2 * (3 + 100cm)). Unitless ratio.