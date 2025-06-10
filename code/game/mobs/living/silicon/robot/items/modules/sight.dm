/*
 * Sight
 */
/obj/item/robot_module/sight
	var/sight_mode = null

/obj/item/robot_module/sight/xray
	name = "\proper x-ray vision"
	icon_state = "xray"
	sight_mode = BORGXRAY

/obj/item/robot_module/sight/thermal
	name = "\proper thermal vision"
	icon_state = "thermal"
	sight_mode = BORGTHERM

/obj/item/robot_module/sight/meson
	name = "\proper meson vision"
	icon_state = "meson"
	sight_mode = BORGMESON