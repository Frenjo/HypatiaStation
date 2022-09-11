/*
### TODO: Update this comment to match the definitions below and figure out what changed. -Frenjo ###

Frequency range: 1200 to 1600
Radiochat range: 1441 to 1489 (most devices refuse to be tune to other frequency, even during mapmaking)

Radio:
1459 - standard radio chat
1351 - Science
1353 - Command
1355 - Medical
1357 - Engineering
1359 - Security
1441 - death squad
1443 - Confession Intercom
1347 - Cargo techs
1349 - Mining

Devices:
1451 - tracking implant
1457 - RSD default

On the map:
1311 for prison shuttle console (in fact, it is not used)
1435 for status displays
1437 for atmospherics/fire alerts
1439 for engine components
1439 for air pumps, air scrubbers, atmo control
1441 for atmospherics - supply tanks
1443 for atmospherics - distribution loop/mixed air tank
1445 for bot nav beacons
1447 for mulebot, secbot and ed209 control
1449 for airlock controls, electropack, magnets
1451 for toxin lab access
1453 for engineering access
1455 for AI access
*/

/*
All frequencies in order:
	RADIO_MINIMUM	- 120.0
	SYNDICATE		- 121.3
	DEATHSQUAD		- 134.1
	RESPONSETEAM	- 134.5
	SUPPLY			- 134.7
	SERVICE			- 134.9
	SCIENCE			- 135.1
	COMMAND			- 135.3
	MEDICAL			- 135.5
	ENGINEERING		- 135.7
	SECURITY		- 135.9
	MINING			- 136.1
	FREE_MINIMUM	- 144.1
	AI				- 144.7
	COMMON			- 145.9
	FREE_MAXIMUM	- 148.9
	RADIO_MAXIMUM	- 160.0
*/

// Radio frequencies.
#define FREQUENCY_SYNDICATE		1213

// Central command frequencies, i.e deathsquid & response teams.
#define FREQUENCY_DEATHSQUAD	1341
#define FREQUENCY_RESPONSETEAM	1345

// Department frequencies.
#define FREQUENCY_SUPPLY		1347
#define FREQUENCY_SERVICE		1349
#define FREQUENCY_SCIENCE		1351
#define FREQUENCY_COMMAND		1353 // Command, colored gold in chat window
#define FREQUENCY_MEDICAL		1355
#define FREQUENCY_ENGINEERING	1357
#define FREQUENCY_SECURITY		1359
#define FREQUENCY_MINING		1361

// Free use frequencies.
#define FREQUENCY_FREE_MINIMUM	1441 // Minimum free-use frequency.

#define FREQUENCY_AI_PRIVATE	1447

#define FREQUENCY_COMMON		1459

#define FREQUENCY_FREE_MAXIMUM	1489 // Maximum free-use frequency.

// Radio channel names.
#define CHANNEL_SYNDICATE		"#unkn"

// Central command channels, i.e deathsquid & response teams.
#define CHANNEL_DEATHSQUAD		"Special Ops"
#define CHANNEL_RESPONSETEAM	"Response Team"

// Department channels.
#define CHANNEL_SUPPLY			"Supply"
#define CHANNEL_SERVICE			"Service"
#define CHANNEL_SCIENCE			"Science"
#define CHANNEL_COMMAND			"Command"
#define CHANNEL_MEDICAL			"Medical"
#define CHANNEL_ENGINEERING		"Engineering"
#define CHANNEL_SECURITY		"Security"
#define CHANNEL_MINING			"Mining"

// Free use channels.
#define CHANNEL_AI_PRIVATE		"AI Private"
#define CHANNEL_COMMON			"Common"

// Stuff moved from communications.dm.
#define TRANSMISSION_WIRE	0
#define TRANSMISSION_RADIO	1
#define TRANSMISSION_SUBSPACE 2

/* filters */
#define RADIO_TO_AIRALARM "1"
#define RADIO_FROM_AIRALARM "2"
#define RADIO_CHAT "3"
#define RADIO_ATMOSIA "4"
#define RADIO_NAVBEACONS "5"
#define RADIO_AIRLOCK "6"
#define RADIO_SECBOT "7"
#define RADIO_MULEBOT "8"
#define RADIO_MAGNETS "9"