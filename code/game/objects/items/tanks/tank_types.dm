/*
 * Types of tanks!
 *
 * Contains:
 *	Oxygen
 *	Nitrogen
 *	Air
 *	Anesthetic
 *	Plasma
 *	Wearable Plasma
 *	Emergency
 *	Emergency Oxygen
 *	Emergency Wearable Plasma
 */

/*
 * Oxygen
 */
/obj/item/tank/oxygen
	name = "oxygen tank"
	desc = "A tank of oxygen."
	icon_state = "oxygen"
	distribute_pressure = ONE_ATMOSPHERE * O2STANDARD

	alert_gas_type = /decl/xgm_gas/oxygen
	alert_gas_amount = 10

/obj/item/tank/oxygen/New()
	. = ..()
	air_contents.adjust_gas(/decl/xgm_gas/oxygen, (6 * ONE_ATMOSPHERE) * volume / (R_IDEAL_GAS_EQUATION * T20C))

/obj/item/tank/oxygen/yellow
	desc = "A tank of oxygen, this one is yellow."
	icon_state = "oxygen_f"

/obj/item/tank/oxygen/red
	desc = "A tank of oxygen, this one is red."
	icon_state = "oxygen_fr"

/*
 * Nitrogen
 */
/obj/item/tank/nitrogen
	name = "nitrogen tank"
	desc = "A tank of nitrogen."
	icon_state = "oxygen_fr"
	distribute_pressure = ONE_ATMOSPHERE * O2STANDARD

	alert_gas_type = /decl/xgm_gas/nitrogen
	alert_gas_amount = 10

/obj/item/tank/nitrogen/New()
	. = ..()
	air_contents.adjust_gas(/decl/xgm_gas/nitrogen, (3 * ONE_ATMOSPHERE) * 70 / (R_IDEAL_GAS_EQUATION * T20C))

/*
 * Air
 */
/obj/item/tank/air
	name = "air tank"
	desc = "Mixed anyone?"
	icon_state = "oxygen"

	alert_gas_type = /decl/xgm_gas/oxygen
	alert_gas_amount = 1

/obj/item/tank/air/New()
	. = ..()
	air_contents.adjust_multi(
		/decl/xgm_gas/oxygen, (6 * ONE_ATMOSPHERE) * volume / (R_IDEAL_GAS_EQUATION * T20C) * O2STANDARD,
		/decl/xgm_gas/nitrogen, (6 * ONE_ATMOSPHERE) * volume / (R_IDEAL_GAS_EQUATION * T20C) * N2STANDARD
	)

/*
 * Anesthetic
 */
/obj/item/tank/anesthetic
	name = "anesthetic tank"
	desc = "A tank with an N2O/O2 gas mix."
	icon_state = "anesthetic"
	item_state = "an_tank"

/obj/item/tank/anesthetic/New()
	. = ..()
	air_contents.adjust_multi(
		/decl/xgm_gas/oxygen, (3 * ONE_ATMOSPHERE) * 70 / (R_IDEAL_GAS_EQUATION * T20C) * O2STANDARD,
		/decl/xgm_gas/nitrous_oxide, (3 * ONE_ATMOSPHERE) * 70 / (R_IDEAL_GAS_EQUATION * T20C) * N2STANDARD
	)

/*
 * Plasma
 */
/obj/item/tank/plasma
	name = "plasma tank"
	desc = "Contains dangerous plasma. Do not inhale. Warning: extremely flammable."
	icon_state = "plasma"
	slot_flags = null	//they have no straps!

/obj/item/tank/plasma/New()
	. = ..()
	air_contents.adjust_gas(/decl/xgm_gas/plasma, (3 * ONE_ATMOSPHERE) * 70 / (R_IDEAL_GAS_EQUATION * T20C))

/obj/item/tank/plasma/attackby(obj/item/W, mob/user)
	. = ..()
	if(istype(W, /obj/item/flamethrower))
		var/obj/item/flamethrower/F = W
		if(!F.status || F.ptank)
			return
		master = F
		F.ptank = src
		user.before_take_item(src)
		loc = F

/*
 * Plasma2 - Wearable Plasma
 */
/obj/item/tank/plasma2
	name = "wearable plasma tank"
	desc = "A wearable tank containing dangerous plasma, unless you're a Plasmalin that is. Warning: extremely flammable."
	icon_state = "plasma2"
	slot_flags = SLOT_BACK | SLOT_BELT
	distribute_pressure = ((ONE_ATMOSPHERE * O2STANDARD) - 5)

	alert_gas_type = /decl/xgm_gas/plasma
	alert_gas_amount = 10

/obj/item/tank/plasma2/New()
	. = ..()
	air_contents.adjust_gas(/decl/xgm_gas/plasma, (6 * ONE_ATMOSPHERE) * volume / (R_IDEAL_GAS_EQUATION * T20C))

/*
 * Emergency
 */
/obj/item/tank/emergency
	name = "emergency tank"
	desc = "Used for emergencies."
	force = 4

	w_class = WEIGHT_CLASS_SMALL
	slot_flags = SLOT_BELT

	volume = 2 // Tiny. Real life equivalents only have 21 breaths of oxygen in them. They're EMERGENCY tanks anyway -errorage (dangercon 2011)

	alert_gas_amount = 0.2

// Oxygen
/obj/item/tank/emergency/oxygen
	name = "emergency oxygen tank"
	desc = "Used for emergencies. Contains very little oxygen, so try to conserve it until you actually need it."
	icon_state = "emergency"
	distribute_pressure = ONE_ATMOSPHERE * O2STANDARD

	alert_gas_type = /decl/xgm_gas/oxygen

/obj/item/tank/emergency/oxygen/New()
	. = ..()
	air_contents.adjust_gas(/decl/xgm_gas/oxygen, (3 * ONE_ATMOSPHERE) * volume / (R_IDEAL_GAS_EQUATION * T20C))

/obj/item/tank/emergency/oxygen/engi
	name = "extended-capacity emergency oxygen tank"
	icon_state = "emergency_engi"
	volume = 6

/obj/item/tank/emergency/oxygen/double
	name = "double emergency oxygen tank"
	icon_state = "emergency_double"
	volume = 10

// Plasma
/obj/item/tank/emergency/plasma
	name = "emergency wearable plasma tank"
	desc = "Used for emergencies. Contains very little plasma, so try to conserve it until you actually need it. Warning: extremely flammable."
	icon_state = "emergency_plasma"
	distribute_pressure = ((ONE_ATMOSPHERE * O2STANDARD) - 5)

	alert_gas_type = /decl/xgm_gas/plasma

/obj/item/tank/emergency/plasma/New()
	. = ..()
	air_contents.adjust_gas(/decl/xgm_gas/plasma, (3 * ONE_ATMOSPHERE) * volume / (R_IDEAL_GAS_EQUATION * T20C))