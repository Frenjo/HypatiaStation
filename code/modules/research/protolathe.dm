/*
Protolathe

Similar to an autolathe, you load glass and metal sheets (but not other objects) into it to be used as raw materials for the stuff
it creates. All the menus and other manipulation commands are in the R&D console.

Note: Must be placed west/left of and R&D console to function.

*/
/obj/machinery/r_n_d/protolathe
	name = "protolathe"
	icon_state = "protolathe"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER

	accepted_materials = list(
		MATERIAL_METAL, /decl/material/glass, /decl/material/silver, /decl/material/gold,
		/decl/material/diamond, /decl/material/uranium, /decl/material/plasma, /decl/material/bananium,
		/decl/material/adamantine
	)
	max_storage_capacity = 100000

/obj/machinery/r_n_d/protolathe/add_parts()
	component_parts = list(
		new /obj/item/circuitboard/protolathe(src),
		new /obj/item/stock_part/matter_bin(src),
		new /obj/item/stock_part/matter_bin(src),
		new /obj/item/stock_part/manipulator(src),
		new /obj/item/stock_part/manipulator(src),
		new /obj/item/reagent_holder/glass/beaker(src),
		new /obj/item/reagent_holder/glass/beaker(src)
	)
	return TRUE

/obj/machinery/r_n_d/protolathe/refresh_parts()
	var/total_rating = 0
	for(var/obj/item/reagent_holder/glass/container in component_parts)
		total_rating += container.reagents.maximum_volume
	create_reagents(total_rating) // Holder for the reagents used as materials.
	total_rating = 0
	for(var/obj/item/stock_part/matter_bin/bin in component_parts)
		total_rating += bin.rating
	max_storage_capacity = total_rating * 75000

/obj/machinery/r_n_d/protolathe/attackby(obj/item/O, mob/user)
	if(..())
		return 1
	if(O.is_open_container())
		return 1

	if(isscrewdriver(O))
		if(!opened)
			opened = TRUE
			if(linked_console)
				linked_console.linked_lathe = null
				linked_console = null
			icon_state = "protolathe_t"
		else
			opened = FALSE
			icon_state = "protolathe"
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
			to_chat(user, SPAN_WARNING("You can't load the [src.name] while it's opened."))
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
	if(get_total_stored_materials() + stack.perunit > max_storage_capacity)
		to_chat(user, SPAN_WARNING("The [src.name]'s material bin is full. Please remove material before adding more."))
		return 1

	var/num_sheets = round(input("How many sheets do you want to add?") as num) // No decimals.
	if(num_sheets < 0) // No negative numbers.
		num_sheets = 0
	if(num_sheets == 0)
		return
	if(num_sheets > stack.amount)
		num_sheets = stack.amount
	if(max_storage_capacity - get_total_stored_materials() < (num_sheets * stack.perunit)) // Can't overfill.
		num_sheets = min(stack.amount, round((max_storage_capacity - get_total_stored_materials()) / stack.perunit))

	overlays.Add("protolathe_[stack.name]")

	busy = TRUE
	use_power(max(1000, (3750 * num_sheets / 10)))
	stack.use(num_sheets)
	if(do_after(user, 16))
		to_chat(user, SPAN_INFO("You add [num_sheets] sheets to the [src.name]."))
		stored_materials[stack.material.type] += (num_sheets * stack.perunit)
	else
		new stack.type(src.loc, num_sheets)
	busy = FALSE

	overlays.Remove("protolathe_[stack.name]")

	updateUsrDialog()
	return 1