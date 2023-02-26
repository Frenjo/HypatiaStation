/*///////////////Circuit Imprinter (By Darem)////////////////////////
	Used to print new circuit boards (for computers and similar systems) and AI modules. Each circuit board pattern are stored in
a /datum/desgin on the linked R&D console. You can then print them out in a fasion similar to a regular lathe. However, instead of
using metal and glass, it uses glass and reagents (usually sulfuric acis).

*/
/obj/machinery/r_n_d/circuit_imprinter
	name = "Circuit Imprinter"
	icon_state = "circuit_imprinter"
	flags = OPENCONTAINER

	accepted_materials = list(MATERIAL_GLASS, MATERIAL_GOLD, MATERIAL_DIAMOND, MATERIAL_URANIUM)
	max_storage_capacity = 75000

/obj/machinery/r_n_d/circuit_imprinter/New()
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/circuit_imprinter(src)
	component_parts += new /obj/item/weapon/stock_part/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_part/manipulator(src)
	component_parts += new /obj/item/weapon/reagent_containers/glass/beaker(src)
	component_parts += new /obj/item/weapon/reagent_containers/glass/beaker(src)
	RefreshParts()

/obj/machinery/r_n_d/circuit_imprinter/RefreshParts()
	var/T = 0
	for(var/obj/item/weapon/reagent_containers/glass/G in component_parts)
		T += G.reagents.maximum_volume
	var/datum/reagents/R = new/datum/reagents(T)		//Holder for the reagents used as materials.
	reagents = R
	R.my_atom = src
	T = 0
	for(var/obj/item/weapon/stock_part/matter_bin/M in component_parts)
		T += M.rating
	max_storage_capacity = T * 75000.0

/obj/machinery/r_n_d/circuit_imprinter/blob_act()
	if(prob(50))
		qdel(src)

/obj/machinery/r_n_d/circuit_imprinter/meteorhit()
	qdel(src)
	return

/obj/machinery/r_n_d/circuit_imprinter/attackby(obj/item/O as obj, mob/user as mob)
	if(..())
		return 1
	if(O.is_open_container())
		return 0

	if(istype(O, /obj/item/weapon/screwdriver))
		if(!opened)
			opened = TRUE
			if(linked_console)
				linked_console.linked_imprinter = null
				linked_console = null
			icon_state = "circuit_imprinter_t"
			to_chat(user, "You open the maintenance hatch of \the [src.name].")
		else
			opened = FALSE
			icon_state = "circuit_imprinter"
			to_chat(user, "You close the maintenance hatch of \the [src.name].")
		return 1
	if(opened)
		if(istype(O, /obj/item/weapon/crowbar))
			playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
			var/obj/machinery/constructable_frame/machine_frame/M = new /obj/machinery/constructable_frame/machine_frame(src.loc)
			M.state = 2
			M.icon_state = "box_1"
			for(var/obj/I in component_parts)
				if(istype(I, /obj/item/weapon/reagent_containers/glass/beaker))
					reagents.trans_to(I, reagents.total_volume)
				if(I.reliability != 100 && crit_fail)
					I.crit_fail = 1
				I.loc = src.loc
			eject_stored_materials()
			qdel(src)
			return 1
		else
			to_chat(user, SPAN_WARNING("You can't load \the [src.name] while it's opened."))
			return 1
	
	if(!linked_console)
		to_chat(user, SPAN_WARNING("\The [src.name] must be linked to an R&D console first!"))
		return 1

	if(!istype(O, /obj/item/stack/sheet))
		to_chat(user, SPAN_WARNING("You cannot insert this item into the [src.name]!"))
		return 1
	
	var/obj/item/stack/sheet/stack = O
	if(!O)
		return
	var/material = get_material_name_by_type(stack.type)
	if(!(material in accepted_materials))
		to_chat(user, SPAN_WARNING("The [src.name] cannot accept this material!"))
		return 1
	if((get_total_stored_materials() + stack.perunit) > max_storage_capacity)
		to_chat(user, SPAN_WARNING("The [src.name]'s material bin is full. Please remove material before adding more."))
		return 1

	var/num_sheets = round(input("How many sheets do you want to add?") as num)
	if(num_sheets < 0)
		num_sheets = 0
	if(num_sheets == 0)
		return
	if(num_sheets > stack.amount)
		num_sheets = min(stack.amount, round((max_storage_capacity - get_total_stored_materials()) / stack.perunit))

	busy = TRUE
	use_power(max(1000, (3750 * num_sheets / 10)))
	stack.use(num_sheets)
	if(do_after(usr, 16))
		to_chat(user, SPAN_INFO("You add [num_sheets] sheets to \the [src.name]."))
		stored_materials[material] += (num_sheets * stack.perunit)
	else
		new stack.type(src.loc, num_sheets)
	busy = FALSE

	updateUsrDialog()
	return 1