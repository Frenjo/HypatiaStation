// I. The mill is intended to be loaded with produce and returns ground up items. For example: Wheat should become flour and grapes should become raisins.
/obj/machinery/mill
	name = "\improper Mill"
	desc = "It is a machine that grinds produce."
	icon_state = "autolathe"
	density = TRUE
	anchored = TRUE
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 1000

	var/list/obj/item/weapon/reagent_containers/food/input = list()
	var/list/obj/item/weapon/reagent_containers/food/output = list()
	var/obj/item/weapon/reagent_containers/food/milled_item
	var/busy = 0
	var/progress = 0
	var/error = 0

/obj/machinery/mill/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/reagent_containers/food))
		user.u_equip(W)
		W.loc = src
		input += W
	else
		..()

/obj/machinery/mill/attack_hand(mob/user as mob)
	for(var/obj/item/weapon/reagent_containers/food/F in output)
		F.loc = src.loc
		output -= F

/obj/machinery/mill/process()
	if(error)
		return

	if(!busy)
		use_power = 1
		if(length(input))
			milled_item = input[1]
			input -= milled_item
			progress = 0
			busy = 1
			use_power = 2
		return

	progress++
	if(progress < MILL_MAX_PROGRESS)
		return	//Not done yet.

	switch(milled_item.type)
		if(/obj/item/weapon/reagent_containers/food/snacks/grown/wheat)	//Wheat becomes flour
			var/obj/item/weapon/reagent_containers/food/snacks/flour/F = new(src)
			output += F
		if(/obj/item/weapon/reagent_containers/food/snacks/flour)	//Flour is still flour
			var/obj/item/weapon/reagent_containers/food/snacks/flour/F = new(src)
			output += F
		else
			error = 1

	qdel(milled_item)
	busy = 0