/obj/item/module
	icon = 'icons/obj/items/module.dmi'
	icon_state = "std_module"
	w_class = WEIGHT_CLASS_SMALL
	item_state = "electronic"
	obj_flags = OBJ_FLAG_CONDUCT

	var/mtype = 1						// 1=electronic 2=hardware

/obj/item/module/card_reader
	name = "card reader module"
	desc = "An electronic module for reading data and ID cards."
	icon_state = "card_mod"

/obj/item/module/power_control
	name = "power control module"
	desc = "Heavy-duty switching circuits for power control."
	icon_state = "power_mod"
	matter_amounts = /datum/design/autolathe/power_control_module::materials
	origin_tech = /datum/design/autolathe/power_control_module::req_tech

/obj/item/module/power_control/attack_tool(obj/item/tool, mob/user)
	if(ismultitool(tool))
		var/obj/item/circuitboard/cell_rack/makeshift/new_circuit = new /obj/item/circuitboard/cell_rack/makeshift(user.loc)
		qdel(src)
		user.put_in_hands(new_circuit)
		return TRUE
	return ..()

/obj/item/module/id_auth
	name = "\improper ID authentication module"
	desc = "A module allowing secure authorisation of ID cards."
	icon_state = "id_mod"

/obj/item/module/cell_power
	name = "power cell regulator module"
	desc = "A converter and regulator allowing the use of power cells."
	icon_state = "power_mod"

/obj/item/module/cell_power
	name = "power cell charger module"
	desc = "Charging circuits for power cells."
	icon_state = "power_mod"