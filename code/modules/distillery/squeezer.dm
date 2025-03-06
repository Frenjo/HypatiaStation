// IV. The squeezer is intended to destroy inserted food items, but return some of the reagents they contain.
/obj/machinery/squeezer
	name = "squeezer"
	desc = "It is a machine that squeezes extracts from produce."
	icon = 'icons/obj/machines/fabricators/autolathe.dmi'
	icon_state = "autolathe"
	density = TRUE
	anchored = TRUE

	power_usage = alist(
		USE_POWER_IDLE = 10,
		USE_POWER_ACTIVE = 500
	)

	var/list/obj/item/reagent_holder/food/input = list()
	var/obj/item/reagent_holder/food/squeezed_item
	var/water_level = 0
	var/busy = 0
	var/progress = 0
	var/error = 0