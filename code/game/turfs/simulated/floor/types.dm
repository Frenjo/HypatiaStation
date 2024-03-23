/*
 * Airless
 */
/turf/simulated/floor/airless
	name = "airless floor"
	icon_state = "floor"
	initial_gases = null
	temperature = TCMB

/turf/simulated/floor/airless/New()
	. = ..()
	name = "floor"

/turf/simulated/floor/airless/ceiling
	icon_state = "rockvault"

/*
 * Vault
 */
/turf/simulated/floor/vault
	icon_state = "rockvault"

/turf/simulated/floor/vault/New(location, type)
	. = ..()
	icon_state = "[type]vault"

/turf/simulated/wall/vault
	icon_state = "rockvault"

/turf/simulated/wall/vault/New(location, type)
	. = ..()
	icon_state = "[type]vault"

/turf/simulated/wall/vault/relativewall()
	return