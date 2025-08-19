////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Miscellaneous xenoarchaeology tools
/obj/item/gps
	name = "relay positioning device"
	desc = "Triangulates the approximate co-ordinates using a nearby satellite network."
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "locator"
	item_state = "locator"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/gps/attack_self(mob/user)
	var/turf/T = GET_TURF(src)
	to_chat(user, SPAN_INFO("[icon2html(src, user)] [src] flashes <i>[T.x].[rand(0, 9)]:[T.y].[rand(0, 9)]:[T.z].[rand(0, 9)]</i>."))

/obj/item/measuring_tape
	name = "measuring tape"
	desc = "A coiled metallic tape used to check dimensions and lengths."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "measuring"
	w_class = WEIGHT_CLASS_SMALL

//todo: dig site tape
