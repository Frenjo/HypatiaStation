// I. The mill is intended to be loaded with produce and returns ground up items. For example: Wheat should become flour and grapes should become raisins.
/obj/machinery/mill
	name = "mill"
	desc = "It is a machine that grinds produce."
	icon = 'icons/obj/machines/fabricators/autolathe.dmi'
	icon_state = "autolathe"
	density = TRUE
	anchored = TRUE

	power_usage = list(
		USE_POWER_IDLE = 10,
		USE_POWER_ACTIVE = 1000
	)

	var/list/obj/item/reagent_holder/food/input = list()
	var/list/obj/item/reagent_holder/food/output = list()
	var/obj/item/reagent_holder/food/milled_item
	var/busy = 0
	var/progress = 0
	var/error = 0

/obj/machinery/mill/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/reagent_holder/food))
		user.u_equip(W)
		W.forceMove(src)
		input += W
	else
		..()

/obj/machinery/mill/attack_hand(mob/user)
	for(var/obj/item/reagent_holder/food/F in output)
		F.forceMove(loc)
		output -= F

/obj/machinery/mill/process()
	if(error)
		return

	if(!busy)
		update_power_state(USE_POWER_IDLE)
		if(length(input))
			milled_item = input[1]
			input -= milled_item
			progress = 0
			busy = 1
			update_power_state(USE_POWER_ACTIVE)
		return

	progress++
	if(progress < MILL_MAX_PROGRESS)
		return	//Not done yet.

	switch(milled_item.type)
		if(/obj/item/reagent_holder/food/snacks/grown/wheat)	//Wheat becomes flour
			var/obj/item/reagent_holder/food/snacks/flour/F = new(src)
			output += F
		if(/obj/item/reagent_holder/food/snacks/flour)	//Flour is still flour
			var/obj/item/reagent_holder/food/snacks/flour/F = new(src)
			output += F
		else
			error = 1

	qdel(milled_item)
	busy = 0