#if !defined(CURRENT_MAP_DATUM)

	#include "tgstation2-hypatia-1.dmm"
	#include "tgstation2-hypatia-2.dmm"
	#include "tgstation2-hypatia-3.dmm"
	#include "tgstation2-hypatia-4.dmm"
	#include "tgstation2-hypatia-5.dmm"
	#include "tgstation2-hypatia-6.dmm"
	#include "tgstation2-hypatia-transit.dmm"

	#define CURRENT_MAP_DATUM /datum/map/tgstation2_hypatia

#else

	#warn A map has already been included, ignoring tgstation2_hypatia.

#endif

/datum/map/tgstation2_hypatia
	name = "tgstation2-hypatia"
	station_name = "NSS Hypatia"
	short_name = "Hypatia"

	station_levels = list(1)
	admin_levels = list(2)
	contact_levels = list(1, 3, 5)
	player_levels = list(1, 3, 4, 5, 6)