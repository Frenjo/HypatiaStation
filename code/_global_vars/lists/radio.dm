// Central command frequencies, i.e deathsquid & response teams.
GLOBAL_GLOBL_LIST_INIT(cent_freqs, list(FREQUENCY_RESPONSETEAM, FREQUENCY_DEATHSQUAD))

// Depenging helpers
GLOBAL_GLOBL_LIST_INIT(dept_freqs, list(
	FREQUENCY_SYNDICATE,

	FREQUENCY_DEATHSQUAD,
	FREQUENCY_RESPONSETEAM,

	FREQUENCY_SUPPLY,
	FREQUENCY_SERVICE,
	FREQUENCY_SCIENCE,
	FREQUENCY_COMMAND,
	FREQUENCY_MEDICAL,
	FREQUENCY_ENGINEERING,
	FREQUENCY_SECURITY,
	FREQUENCY_MINING
))

GLOBAL_GLOBL_LIST_INIT(radio_channels, list(
	CHANNEL_SYNDICATE		= FREQUENCY_SYNDICATE,

	CHANNEL_DEATHSQUAD		= FREQUENCY_DEATHSQUAD,
	CHANNEL_RESPONSETEAM	= FREQUENCY_RESPONSETEAM,

	CHANNEL_SUPPLY			= FREQUENCY_SUPPLY,
	CHANNEL_SERVICE			= FREQUENCY_SERVICE,
	CHANNEL_SCIENCE			= FREQUENCY_SCIENCE,
	CHANNEL_COMMAND			= FREQUENCY_COMMAND,
	CHANNEL_MEDICAL			= FREQUENCY_MEDICAL,
	CHANNEL_ENGINEERING		= FREQUENCY_ENGINEERING,
	CHANNEL_SECURITY		= FREQUENCY_SECURITY,
	CHANNEL_MINING			= FREQUENCY_MINING,

	CHANNEL_AI_PRIVATE		= FREQUENCY_AI_PRIVATE,
	CHANNEL_COMMON			= FREQUENCY_COMMON
))