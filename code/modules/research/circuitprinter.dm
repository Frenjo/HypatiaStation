/*///////////////Circuit Imprinter (By Darem)////////////////////////
	Used to print new circuit boards (for computers and similar systems) and AI modules. Each circuit board pattern are stored in
a /datum/desgin on the linked R&D console. You can then print them out in a fasion similar to a regular lathe. However, instead of
using metal and glass, it uses glass and reagents (usually sulfuric acis).

*/
/obj/machinery/r_n_d/circuit_imprinter
	name = "circuit imprinter"
	icon_state = "circuit_imprinter"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER

	accepted_materials = list(/decl/material/glass, /decl/material/gold, /decl/material/diamond, /decl/material/uranium)
	max_storage_capacity = 75000

/obj/machinery/r_n_d/circuit_imprinter/add_parts()
	component_parts = list(
		new /obj/item/circuitboard/circuit_imprinter(src),
		new /obj/item/stock_part/matter_bin(src),
		new /obj/item/stock_part/manipulator(src),
		new /obj/item/reagent_holder/glass/beaker(src),
		new /obj/item/reagent_holder/glass/beaker(src)
	)
	return TRUE

/obj/machinery/r_n_d/circuit_imprinter/refresh_parts()
	var/total_rating = 0
	for(var/obj/item/reagent_holder/glass/container in component_parts)
		total_rating += container.reagents.maximum_volume
	create_reagents(total_rating) // Holder for the reagents used as materials.
	total_rating = 0
	for(var/obj/item/stock_part/matter_bin/bin in component_parts)
		total_rating += bin.rating
	max_storage_capacity = total_rating * 75000

/obj/machinery/r_n_d/circuit_imprinter/blob_act()
	if(prob(50))
		qdel(src)

/obj/machinery/r_n_d/circuit_imprinter/meteorhit()
	qdel(src)
	return

/obj/machinery/r_n_d/circuit_imprinter/attackby(obj/item/O, mob/user)
	if(..())
		return 1
	if(O.is_open_container())
		return 0

	if(isscrewdriver(O))
		if(!opened)
			opened = TRUE
			if(linked_console)
				linked_console.linked_imprinter = null
				linked_console = null
			icon_state = "circuit_imprinter_t"
		else
			opened = FALSE
			icon_state = "circuit_imprinter"
		playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
		FEEDBACK_TOGGLE_MAINTENANCE_PANEL(user, opened)
		return 1
	if(opened)
		if(iscrowbar(O))
			playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
			var/obj/machinery/constructable_frame/machine_frame/M = new /obj/machinery/constructable_frame/machine_frame(src.loc)
			M.state = 2
			M.icon_state = "box_1"
			for_no_type_check(var/obj/item/part, component_parts)
				if(istype(part, /obj/item/reagent_holder/glass/beaker))
					reagents.trans_to(part, reagents.total_volume)
				if(part.reliability != 100 && crit_fail)
					part.crit_fail = 1
				part.loc = src.loc
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
	if(!(stack.material.type in accepted_materials))
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
		stored_materials[stack.material.type] += (num_sheets * stack.perunit)
	else
		new stack.type(src.loc, num_sheets)
	busy = FALSE

	updateUsrDialog()
	return 1