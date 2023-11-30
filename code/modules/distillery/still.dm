// III. The still is a machine that is loaded with food items and returns hard liquor, such as vodka.
/obj/machinery/still
	name = "\improper Still"
	desc = "It is a machine that produces hard liquor from alcoholic drinks."
	icon_state = "autolathe"
	density = TRUE
	anchored = TRUE

	power_usage = list(
		USE_POWER_IDLE = 10,
		USE_POWER_ACTIVE = 10000
	)

	var/list/obj/item/reagent_containers/food/input = list()
	var/list/obj/item/reagent_containers/food/output = list()
	var/obj/item/reagent_containers/food/distilling_item
	var/busy = 0
	var/progress = 0
	var/error = 0

/obj/machinery/still/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/reagent_containers/food))
		user.u_equip(W)
		W.loc = src
		input += W
	else
		..()

/obj/machinery/still/attack_hand(mob/user as mob)
	for(var/obj/item/reagent_containers/food/F in output)
		F.loc = src.loc
		output -= F

/obj/machinery/still/process()
	if(error)
		return

	if(!busy)
		update_power_state(USE_POWER_IDLE)
		if(length(input))
			distilling_item = input[1]
			input -= distilling_item
			progress = 0
			busy = 1
			update_power_state(USE_POWER_ACTIVE)
		return

	progress++
	if(progress < STILL_MAX_PROGRESS)
		return	//Not done yet.

	switch(distilling_item.type)
		if(/obj/item/reagent_containers/food/drinks/cans/beer)
			var/obj/item/reagent_containers/food/drinks/bottle/vodka/V = new(src)
			output += V
		else
			error = 1

	qdel(distilling_item)
	busy = 0