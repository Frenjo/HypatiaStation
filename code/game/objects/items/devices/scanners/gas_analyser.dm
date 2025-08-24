/*
 * Gas Analyser
 */
/obj/item/gas_analyser
	name = "gas analyser"
	desc = "A handheld environmental scanner which reports current gas levels."
	icon = 'icons/obj/items/devices/scanner.dmi'
	icon_state = "atmos"
	item_state = "analyser"

	w_class = WEIGHT_CLASS_SMALL
	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT

	throwforce = 5
	throw_speed = 4
	throw_range = 20

	matter_amounts = /datum/design/autolathe/gas_analyser::materials
	origin_tech = /datum/design/autolathe/gas_analyser::req_tech

/obj/item/gas_analyser/attack_self(mob/user)
	if(user.stat)
		return
	if(!ishuman(usr) && !IS_GAME_MODE(/datum/game_mode/monkey))
		FEEDBACK_NOT_ENOUGH_DEXTERITY(usr)
		return
	var/turf/location = user.loc
	if(!isturf(location))
		return

	atmos_scan(src, user, location)

	add_fingerprint(user)