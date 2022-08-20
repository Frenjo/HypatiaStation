// IV. The squeezer is intended to destroy inserted food items, but return some of the reagents they contain.
/obj/machinery/squeezer
	name = "\improper Squeezer"
	desc = "It is a machine that squeezes extracts from produce."
	icon_state = "autolathe"
	density = TRUE
	anchored = TRUE
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 500

	var/list/obj/item/weapon/reagent_containers/food/input = list()
	var/obj/item/weapon/reagent_containers/food/squeezed_item
	var/water_level = 0
	var/busy = 0
	var/progress = 0
	var/error = 0