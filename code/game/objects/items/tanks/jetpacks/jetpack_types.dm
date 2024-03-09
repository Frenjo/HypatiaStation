/*
 * Jetpacks
 *
 * Contains:
 *	Void (Oxygen)
 *	Oxygen
 *	Carbon Dioxide
 */

/*
 * Void
 */
/obj/item/tank/jetpack/void
	name = "void jetpack (oxygen)"
	desc = "It works well in a void."
	icon_state = "jetpack-void"
	item_state = "jetpack-void"

	alert_gas_type = /decl/xgm_gas/oxygen

/obj/item/tank/jetpack/void/New()
	. = ..()
	air_contents.adjust_gas(/decl/xgm_gas/oxygen, (6 * ONE_ATMOSPHERE) * volume / (R_IDEAL_GAS_EQUATION * T20C))

/*
 * Oxygen
 */
/obj/item/tank/jetpack/oxygen
	name = "jetpack (oxygen)"
	desc = "A tank of compressed oxygen for use as propulsion in zero-gravity areas. Use with caution."

	alert_gas_type = /decl/xgm_gas/oxygen

/obj/item/tank/jetpack/oxygen/New()
	. = ..()
	air_contents.adjust_gas(/decl/xgm_gas/oxygen, (6 * ONE_ATMOSPHERE) * volume / (R_IDEAL_GAS_EQUATION * T20C))

/*
 * Carbon Dioxide
 */
/obj/item/tank/jetpack/carbon_dioxide
	name = "jetpack (carbon dioxide)"
	desc = "A tank of compressed carbon dioxide for use as propulsion in zero-gravity areas. Painted black to indicate that it should not be used as a source for internals."
	icon_state = "jetpack-black"
	item_state = "jetpack-black"

	distribute_pressure = 0

	alert_gas_type = /decl/xgm_gas/carbon_dioxide

/obj/item/tank/jetpack/carbon_dioxide/New()
	. = ..()
	air_contents.adjust_gas(/decl/xgm_gas/carbon_dioxide, (6 * ONE_ATMOSPHERE) * volume / (R_IDEAL_GAS_EQUATION * T20C))