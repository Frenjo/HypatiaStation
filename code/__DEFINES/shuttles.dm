// Ported 'shuttles' module from Heaven's Gate - NSS Eternal...
// As part of the docking controller port, because rewriting that code is spaghetti.
// And I ain't doing it. -Frenjo
/*
	Shuttles
*/

// these define the time taken for the shuttle to get to SS13
// and the time before it leaves again
#define SHUTTLE_PREPTIME				300	// 5 minutes = 300 seconds - after this time, the shuttle departs centcom and cannot be recalled
#define SHUTTLE_LEAVETIME				180	// 3 minutes = 180 seconds - the duration for which the shuttle will wait at the station after arriving
#define SHUTTLE_TRANSIT_DURATION		300	// 5 minutes = 300 seconds - how long it takes for the shuttle to get to the station
#define SHUTTLE_TRANSIT_DURATION_RETURN 120	// 2 minutes = 120 seconds - for some reason it takes less time to come back, go figure.

//Shuttle moving status
#define SHUTTLE_IDLE		0
#define SHUTTLE_WARMUP		1
#define SHUTTLE_INTRANSIT	2

//Ferry shuttle processing status
#define IDLE_STATE		0
#define WAIT_LAUNCH		1
#define FORCE_LAUNCH	2
#define WAIT_ARRIVE		3
#define WAIT_FINISH		4