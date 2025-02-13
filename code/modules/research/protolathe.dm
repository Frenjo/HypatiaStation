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

/obj/machinery/r_n_d/protolathe/New()
	materials = new /datum/material_container(src, list(
		/decl/material/steel, /decl/material/glass, /decl/material/silver, /decl/material/gold,
		/decl/material/diamond, /decl/material/uranium, /decl/material/plasma, /decl/material/bananium,
		/decl/material/adamantine
	), FALSE)
	. = ..()

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
	materials.set_max_capacity(total_rating * 75000)

/obj/machinery/r_n_d/protolathe/attack_tool(obj/item/tool, mob/user)
	if(isscrewdriver(tool))
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
		return TRUE

	if(opened)
		if(iscrowbar(tool))
			playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
			var/obj/machinery/constructable_frame/machine_frame/M = new /obj/machinery/constructable_frame/machine_frame(src.loc)
			M.state = 2
			M.icon_state = "box_1"
			for_no_type_check(var/obj/item/part, component_parts)
				if(istype(part, /obj/item/reagent_holder/glass/beaker))
					reagents.trans_to(part, reagents.total_volume)
				if(part.reliability != 100 && crit_fail)
					part.crit_fail = TRUE
				part.forceMove(loc)
			materials.eject_all_sheets()
			qdel(src)
			return TRUE

	return ..()

/obj/machinery/r_n_d/protolathe/attackby(obj/item/O, mob/user)
	if(..())
		return 1
	if(O.is_open_container())
		return 1

	if(opened)
		to_chat(user, SPAN_WARNING("You can't load \the [src] while it's opened."))
		return TRUE

	if(!linked_console)
		to_chat(user, SPAN_WARNING("\The [src] must be linked to an R&D console first!"))
		return 1

	if(!istype(O, /obj/item/stack/sheet))
		to_chat(user, SPAN_WARNING("You cannot insert this item into \the [src]!"))
		return 1

	var/obj/item/stack/sheet/sheets = O
	if(!materials.can_contain(sheets.material.type))
		to_chat(user, SPAN_WARNING("\The [src] cannot accept this material!"))
		return 1
	if(!materials.can_add_amount(sheets.material.type, sheets.perunit))
		to_chat(user, SPAN_WARNING("\The [src]'s material bin is full. Please remove material before adding more."))
		return 1

	overlays.Add("protolathe_[sheets.material.icon_prefix]")
	busy = TRUE
	if(do_after(user, 1.6 SECONDS))
		var/sheets_added = materials.add_sheets(sheets)
		to_chat(user, SPAN_INFO("You add [sheets_added] sheets to \the [src]."))
		use_power(max(1000, (sheets.perunit * sheets_added) / 10))
	else
		to_chat(user, SPAN_WARNING("You fail to insert the [sheets.name] into \the [src]."))
	busy = FALSE
	overlays.Remove("protolathe_[sheets.material.icon_prefix]")

	updateUsrDialog()
	return 1