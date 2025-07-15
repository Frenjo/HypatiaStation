/*
 * Airless
 */
/turf/open/floor/airless
	name = "airless floor"
	icon_state = "floor"
	initial_gases = null
	temperature = TCMB

/turf/open/floor/airless/initialise()
	. = ..()
	name = "floor"

/turf/open/floor/airless/ceiling
	icon_state = "rockvault"

/*
 * Vault
 */
/turf/open/floor/vault
	icon_state = "rockvault"

/turf/open/floor/vault/New(location, type)
	. = ..()
	icon_state = "[type]vault"

/turf/open/floor/vault/relativewall()
	return