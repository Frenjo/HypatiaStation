/* Types of tanks!
 * Contains:
 *		Oxygen
 *		Anesthetic
 *		Air
 *		Plasma
 *		Wearable Plasma
 *		Emergency Oxygen
 */

/*
 * Oxygen
 */
/obj/item/weapon/tank/oxygen
	name = "oxygen tank"
	desc = "A tank of oxygen."
	icon_state = "oxygen"
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD

/obj/item/weapon/tank/oxygen/New()
	. = ..()
	air_contents.adjust_gas(/decl/xgm_gas/oxygen, (6 * ONE_ATMOSPHERE) * volume / (R_IDEAL_GAS_EQUATION * T20C))

/obj/item/weapon/tank/oxygen/examine()
	set src in usr
	..()
	if(air_contents.gas[/decl/xgm_gas/oxygen] < 10)
		to_chat(usr, SPAN_DANGER("The meter on the [src.name] indicates you are almost out of air!"))
		playsound(usr, 'sound/effects/alert.ogg', 50, 1)

/obj/item/weapon/tank/oxygen/yellow
	desc = "A tank of oxygen, this one is yellow."
	icon_state = "oxygen_f"

/obj/item/weapon/tank/oxygen/red
	desc = "A tank of oxygen, this one is red."
	icon_state = "oxygen_fr"

/*
 * Anesthetic
 */
/obj/item/weapon/tank/anesthetic
	name = "anesthetic tank"
	desc = "A tank with an N2O/O2 gas mix."
	icon_state = "anesthetic"
	item_state = "an_tank"

/obj/item/weapon/tank/anesthetic/New()
	. = ..()
	air_contents.gas[/decl/xgm_gas/oxygen] = (3 * ONE_ATMOSPHERE) * 70 / (R_IDEAL_GAS_EQUATION * T20C) * O2STANDARD
	air_contents.gas[/decl/xgm_gas/sleeping_agent] = (3 * ONE_ATMOSPHERE) * 70 / (R_IDEAL_GAS_EQUATION * T20C) * N2STANDARD
	air_contents.update_values()

/*
 * Air
 */
/obj/item/weapon/tank/air
	name = "air tank"
	desc = "Mixed anyone?"
	icon_state = "oxygen"

/obj/item/weapon/tank/air/New()
	. = ..()
	air_contents.adjust_multi(
		/decl/xgm_gas/oxygen, (6 * ONE_ATMOSPHERE) * volume / (R_IDEAL_GAS_EQUATION * T20C) * O2STANDARD,
		/decl/xgm_gas/nitrogen, (6 * ONE_ATMOSPHERE) * volume / (R_IDEAL_GAS_EQUATION * T20C) * N2STANDARD
	)
	air_contents.update_values()

/obj/item/weapon/tank/air/examine()
	set src in usr
	..()
	if(air_contents.gas[/decl/xgm_gas/oxygen] < 1 && loc==usr)
		to_chat(usr, SPAN_DANGER("The meter on the [src.name] indicates you are almost out of air!"))
		usr << sound('sound/effects/alert.ogg')

/*
 * Plasma
 */
/obj/item/weapon/tank/plasma
	name = "plasma tank"
	desc = "Contains dangerous plasma. Do not inhale. Warning: extremely flammable."
	icon_state = "plasma"
	flags = CONDUCT
	slot_flags = null	//they have no straps!

/obj/item/weapon/tank/plasma/New()
	. = ..()

	air_contents.adjust_gas(/decl/xgm_gas/plasma, (3 * ONE_ATMOSPHERE) * 70 / (R_IDEAL_GAS_EQUATION * T20C))
	air_contents.update_values()

/obj/item/weapon/tank/plasma/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()

	if(istype(W, /obj/item/weapon/flamethrower))
		var/obj/item/weapon/flamethrower/F = W
		if((!F.status)||(F.ptank))
			return
		src.master = F
		F.ptank = src
		user.before_take_item(src)
		src.loc = F
	return

/*
 * Plasma2 - Wearable Plasma
 */
/obj/item/weapon/tank/plasma2
	name = "wearable plasma tank"
	desc = "A wearable tank containing dangerous plasma, unless you're a Plasmalin that is. Warning: extremely flammable."
	icon_state = "plasma2"
	slot_flags = SLOT_BELT
	distribute_pressure = ((ONE_ATMOSPHERE*O2STANDARD) - 5)

/obj/item/weapon/tank/plasma2/New()
	. = ..()
	air_contents.adjust_gas(/decl/xgm_gas/plasma, (6 * ONE_ATMOSPHERE) * volume / (R_IDEAL_GAS_EQUATION * T20C))
	air_contents.update_values()

/obj/item/weapon/tank/plasma2/examine()
	..()
	if(air_contents.gas[/decl/xgm_gas/plasma] < 10 && loc == usr)
		to_chat(usr, SPAN_DANGER("The meter on the [name] indicates you are almost out of air!"))
		usr << sound('sound/effects/alert.ogg')

/obj/item/weapon/tank/plasma2/attackby(obj/item/weapon/W as obj, mob/user as mob)
	return

/*
 * Emergency Plasma
 */
/obj/item/weapon/tank/emergency_plasma
	name = "emergency wearable plasma tank"
	desc = "Used for emergencies. Contains very little plasma, so try to conserve it until you actually need it. Warning: extremely flammable."
	icon_state = "emergency_plasma"
	slot_flags = SLOT_BELT
	w_class = 2.0
	force = 4.0
	distribute_pressure = ((ONE_ATMOSPHERE*O2STANDARD) - 5)
	volume = 2

/obj/item/weapon/tank/emergency_plasma/New()
	. = ..()
	air_contents.adjust_gas(/decl/xgm_gas/plasma, (3 * ONE_ATMOSPHERE) * volume / (R_IDEAL_GAS_EQUATION * T20C))
	air_contents.update_values()

/obj/item/weapon/tank/emergency_plasma/examine()
	..()
	if(air_contents.gas[/decl/xgm_gas/plasma] < 0.2 && loc == usr)
		to_chat(usr, SPAN_DANGER("The meter on the [name] indicates you are almost out of air!"))
		usr << sound('sound/effects/alert.ogg')

/obj/item/weapon/tank/emergency_plasma/attackby(obj/item/weapon/W as obj, mob/user as mob)
	return

/*
 * Emergency Oxygen
 */
/obj/item/weapon/tank/emergency_oxygen
	name = "emergency oxygen tank"
	desc = "Used for emergencies. Contains very little oxygen, so try to conserve it until you actually need it."
	icon_state = "emergency"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	w_class = 2.0
	force = 4.0
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	volume = 2 //Tiny. Real life equivalents only have 21 breaths of oxygen in them. They're EMERGENCY tanks anyway -errorage (dangercon 2011)

/obj/item/weapon/tank/emergency_oxygen/New()
	. = ..()
	air_contents.adjust_gas(/decl/xgm_gas/oxygen, (3 * ONE_ATMOSPHERE) * volume / (R_IDEAL_GAS_EQUATION * T20C))
	air_contents.update_values()

/obj/item/weapon/tank/emergency_oxygen/examine()
	set src in usr
	..()
	if(air_contents.gas[/decl/xgm_gas/oxygen] < 0.2 && loc == usr)
		to_chat(usr, SPAN_DANGER("The meter on the [src.name] indicates you are almost out of air!"))
		usr << sound('sound/effects/alert.ogg')

/obj/item/weapon/tank/emergency_oxygen/engi
	name = "extended-capacity emergency oxygen tank"
	icon_state = "emergency_engi"
	volume = 6

/obj/item/weapon/tank/emergency_oxygen/double
	name = "double emergency oxygen tank"
	icon_state = "emergency_double"
	volume = 10

/*
 * Nitrogen
 */
/obj/item/weapon/tank/nitrogen
	name = "nitrogen tank"
	desc = "A tank of nitrogen."
	icon_state = "oxygen_fr"
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD

/obj/item/weapon/tank/nitrogen/New()
	. = ..()
	air_contents.adjust_gas(/decl/xgm_gas/nitrogen, (3 * ONE_ATMOSPHERE) * 70 / (R_IDEAL_GAS_EQUATION * T20C))
	air_contents.update_values()

/obj/item/weapon/tank/nitrogen/examine()
	set src in usr
	..()
	if(air_contents.gas[/decl/xgm_gas/nitrogen] < 10 && loc == usr)
		to_chat(usr, SPAN_DANGER("The meter on the [name] indicates you are almost out of air!"))
		playsound(usr, 'sound/effects/alert.ogg', 50, 1)