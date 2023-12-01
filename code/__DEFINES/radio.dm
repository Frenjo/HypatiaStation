/*
 * Radio Frequencies
 * Originally compiled and formatted by an unknown author, edited and updated by Frenjo.
 *
 * Frequency Range: 1200 to 1600
 * Radiochat Range: 1441 to 1489
 *	(Most devices refuse to be tuned to other frequencies, even during mapmaking.)
 *
 * Radio:
 *	1200 (120.0) - Radio Minimum Frequency
 *	1213 (121.3) - Syndicate
 *	1341 (134.1) - Deathsquad
 *	1345 (134.5) - Response Team (ERT)
 *	1347 (134.7) - Supply (Cargo)
 *	1349 (134.9) - Service
 *	1351 (135.1) - Science
 *	1353 (135.3) - Command
 *	1355 (135.5) - Medical
 *	1357 (135.7) - Engineering
 *	1359 (135.9) - Security
 *	1361 (136.1) - Mining
 *	1441 (144.1) - Free Minimum Frequency
 *	1447 (144.7) - AI Private
 *	1459 (145.9) - Common (Standard radio chat)
 *	1489 (148.9) - Free Maximum Frequency
 *	1600 (160.0) - Radio Maximum Frequency
 *
 * Devices:
 *	1451 (145.1) - Tracking Implants
 *	1457 (145.7) - Remote Signalling Devices (default)
 *
 * On the map:
 *	1311 (131.1) - Prison Shuttle Console (unused)
 *	1435 (143.5) - Status Displays
 *	1437 (143.7) - Atmospherics and Fire Alerts
 *	1439 (143.9) - Engine Components, Air Pumps/Scrubbers and Atmos Controls
 *	1441 (144.1) - Atmospherics Supply Tanks
 *	1443 (144.3) - Atmospherics Distribution Loop and Mix Tank
 *	1445 (144.5) - Bot Navigation Beacons
 *	1447 (144.7) - Mulebot, Secbot and ED-209 Controls
 *	1449 (144.9) - Airlock Controls, Electropacks and Magnets
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
#define TRANSMISSION_WIRE		0
#define TRANSMISSION_RADIO		1
#define TRANSMISSION_SUBSPACE	2

/* filters */
#define RADIO_TO_AIRALARM	"1"
#define RADIO_FROM_AIRALARM	"2"
#define RADIO_CHAT			"3"
#define RADIO_ATMOSIA		"4"
#define RADIO_NAVBEACONS	"5"
#define RADIO_AIRLOCK		"6"
#define RADIO_SECBOT		"7"
#define RADIO_MULEBOT		"8"
#define RADIO_MAGNETS		"9"