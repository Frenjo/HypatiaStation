// II. The fermenter is intended to be loaded with food items and returns medium-strength alcohol items, sucha s wine and beer.
/obj/machinery/fermenter
	name = "\improper Fermenter"
	desc = "It is a machine that ferments produce into alcoholic drinks."
	icon_state = "autolathe"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 500

	var/list/obj/item/weapon/reagent_containers/food/input = list()
	var/list/obj/item/weapon/reagent_containers/food/output = list()
	var/obj/item/weapon/reagent_containers/food/fermenting_item
	var/water_level = 0
	var/busy = 0
	var/progress = 0
	var/error = 0

/obj/machinery/fermenter/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/reagent_containers/food))
		user.u_equip(W)
		W.loc = src
		input += W
	else
		..()

/obj/machinery/fermenter/attack_hand(mob/user as mob)
	for(var/obj/item/weapon/reagent_containers/food/F in output)
		F.loc = src.loc
		output -= F

/obj/machinery/fermenter/process()
	if(error)
		return

	if(!busy)
		use_power = 1
		if(input.len)
			fermenting_item = input[1]
			input -= fermenting_item
			progress = 0
			busy = 1
			use_power = 2
		return

	if(!water_level)
		return

	water_level--

	progress++
	if(progress < FERMENTER_MAX_PROGRESS)
		return	//Not done yet.

	switch(fermenting_item.type)
		if(/obj/item/weapon/reagent_containers/food/snacks/flour)	//Flour is still flour
			var/obj/item/weapon/reagent_containers/food/drinks/cans/beer/B = new(src)
			output += B
		else
			error = 1

	qdel(fermenting_item)
	busy = 0