// V. The centrifuge spins inserted food items. It is intended to squeeze out the reagents that are common food catalysts (enzymes currently)
/obj/machinery/centrifuge
	name = "\improper Centrifuge"
	desc = "It is a machine that spins produce."
	icon = 'icons/obj/machines/fabricators.dmi'
	icon_state = "autolathe"
	density = TRUE
	anchored = TRUE

	power_usage = list(
		USE_POWER_IDLE = 10,
		USE_POWER_ACTIVE = 10000
	)

	var/list/obj/item/reagent_containers/food/input = list()
	var/list/obj/item/reagent_containers/food/output = list()
	var/obj/item/reagent_containers/food/centrifuging_item
	var/busy = 0
	var/progress = 0
	var/error = 0
	var/enzymes = 0
	var/water = 0

/obj/machinery/centrifuge/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/reagent_containers/food))
		user.u_equip(W)
		W.loc = src
		input += W
	else
		..()

/obj/machinery/centrifuge/attack_hand(mob/user as mob)
	for(var/obj/item/reagent_containers/food/F in output)
		F.loc = src.loc
		output -= F
	while(enzymes >= 50)
		enzymes -= 50
		new/obj/item/reagent_containers/food/condiment/enzyme(src.loc)

/obj/machinery/centrifuge/process()
	if(error)
		return

	if(!busy)
		update_power_state(USE_POWER_IDLE)
		if(length(input))
			centrifuging_item = input[1]
			input -= centrifuging_item
			progress = 0
			busy = 1
			update_power_state(USE_POWER_ACTIVE)
		return

	progress++
	if(progress < CENTRIFUGE_MAX_PROGRESS)
		return	//Not done yet.

	var/transfer_enzymes = centrifuging_item.reagents.get_reagent_amount("enzyme")

	if(transfer_enzymes)
		enzymes += transfer_enzymes
		centrifuging_item.reagents.remove_reagent("enzyme", transfer_enzymes)

	output += centrifuging_item
	busy = 0