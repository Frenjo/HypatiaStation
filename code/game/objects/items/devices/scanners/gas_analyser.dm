/*
 * Gas Analyser
 */
/obj/item/gas_analyser
	name = "gas analyser"
	desc = "A handheld environmental scanner which reports current gas levels."
	icon = 'icons/obj/items/devices/scanner.dmi'
	icon_state = "atmos"
	item_state = "analyser"

	w_class = 2
	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT

	throwforce = 5
	throw_speed = 4
	throw_range = 20

	matter_amounts = alist(/decl/material/plastic = 30, /decl/material/glass = 20)
	origin_tech = alist(/decl/tech/magnets = 1, /decl/tech/engineering = 1)

/obj/item/gas_analyser/attack_self(mob/user)
	if(user.stat)
		return
	if(!ishuman(usr) && !IS_GAME_MODE(/datum/game_mode/monkey))
		FEEDBACK_NOT_ENOUGH_DEXTERITY(usr)
		return
	var/turf/location = user.loc
	if(!isturf(location))
		return

	atmos_scan(user, location)

	add_fingerprint(user)

/proc/atmos_scan(mob/user, atom/target)
	var/datum/gas_mixture/mixture = target.return_air()

	var/pressure = mixture.return_pressure()
	var/total_moles = mixture.total_moles

	var/list/message = list()
	if(isliving(user))
		user.visible_message(
			SPAN_NOTICE("[user] uses the analyser on \the \icon[target] [target]."),
			SPAN_NOTICE("You use the analyser on \the \icon[target] [target]."),
			SPAN_INFO("You hear a click followed by gentle humming.")
		)
	message += SPAN_INFO_B("Results of analysis of \the \icon[target] [target]:")
	if(abs(pressure - ONE_ATMOSPHERE) < 10)
		message += SPAN_INFO("Pressure: [round(pressure, 0.1)] kPa")
	else
		message += SPAN_WARNING("Pressure: [round(pressure, 0.1)] kPa")
	if(total_moles)
		var/decl/xgm_gas_data/gas_data = GET_DECL_INSTANCE(/decl/xgm_gas_data)
		for(var/g in mixture.gas)
			message += SPAN_INFO("[gas_data.name[g]]: [round((mixture.gas[g] / total_moles) * 100)]%")
		message += SPAN_INFO("Temperature: [round(mixture.temperature - T0C)]&deg;C")
		message += SPAN_INFO("Heat Capacity: [round(mixture.heat_capacity(), 0.1)] / K")
	else
		message += SPAN_INFO("\The [target] is empty!")

	to_chat(user, jointext(message, "\n"))