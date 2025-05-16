/*
 * Sight
 */
/obj/item/robot_module/sight
	icon = 'icons/obj/effects/decals.dmi'
	icon_state = "securearea"

	var/sight_mode = null

/obj/item/robot_module/sight/xray
	name = "\proper x-ray vision"
	sight_mode = BORGXRAY

/obj/item/robot_module/sight/thermal
	name = "\proper thermal vision"
	sight_mode = BORGTHERM
	icon_state = "thermal"
	icon = 'icons/obj/items/clothing/glasses.dmi'

/obj/item/robot_module/sight/meson
	name = "\proper meson vision"
	sight_mode = BORGMESON
	icon_state = "meson"
	icon = 'icons/obj/items/clothing/glasses.dmi'