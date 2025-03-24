/*
 * Sight
 */
/obj/item/borg/sight
	icon = 'icons/obj/effects/decals.dmi'
	icon_state = "securearea"

	var/sight_mode = null

/obj/item/borg/sight/xray
	name = "\proper x-ray vision"
	sight_mode = BORGXRAY

/obj/item/borg/sight/thermal
	name = "\proper thermal vision"
	sight_mode = BORGTHERM
	icon_state = "thermal"
	icon = 'icons/obj/items/clothing/glasses.dmi'

/obj/item/borg/sight/meson
	name = "\proper meson vision"
	sight_mode = BORGMESON
	icon_state = "meson"
	icon = 'icons/obj/items/clothing/glasses.dmi'