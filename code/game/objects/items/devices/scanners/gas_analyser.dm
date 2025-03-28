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

	var/datum/gas_mixture/environment = location.return_air()
	var/pressure = environment.return_pressure()
	var/total_moles = environment.total_moles

	user.show_message(SPAN_INFO_B("Results:"), 1)
	if(abs(pressure - ONE_ATMOSPHERE) < 10)
		user.show_message(SPAN_INFO("Pressure: [round(pressure, 0.1)] kPa"), 1)
	else
		user.show_message(SPAN_WARNING("Pressure: [round(pressure, 0.1)] kPa"), 1)
	if(total_moles)
		var/decl/xgm_gas_data/gas_data = GET_DECL_INSTANCE(/decl/xgm_gas_data)
		for(var/g in environment.gas)
			user.show_message(SPAN_INFO("[gas_data.name[g]]: [round((environment.gas[g] / total_moles) * 100)]%"), 1)
		user.show_message(SPAN_INFO("Temperature: [round(environment.temperature - T0C)]&deg;C"), 1)

	add_fingerprint(user)