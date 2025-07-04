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

	// Was list("3" = 30, "4" = 70).
	// Spacing should be a reliable method of getting rid of a body -- Urist.
	// Go away Urist, I'm restoring this to the longer list. ~Errorage
	accessible_z_levels = list("1" = 5, "3" = 10, "4" = 15, "5" = 10, "6" = 60)

// Just putting this here since it's the best place I can think of.
/obj/structure/sign/hypatia_plaque
	name = "\improper Commissioning Plaque"
	desc = "NSS Hypatia\nA retrofitted G4407-series TG4407-type 'Box'-class station.\nDesigned 2554, commissioned 2555."
	icon_state = "goonplaque"