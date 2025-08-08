//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/*
Destructive Analyser

It is used to destroy hand-held objects and advance technological research. Controls are in the linked R&D console.

Note: Must be placed within 3 tiles of the R&D Console
*/
/obj/machinery/r_n_d/destructive_analyser
	name = "destructive analyser"
	icon_state = "d_analyser"

	var/obj/item/loaded_item = null
	var/decon_mod = 1

/obj/machinery/r_n_d/destructive_analyser/add_parts()
	component_parts = list(
		new /obj/item/circuitboard/destructive_analyser(src),
		new /obj/item/stock_part/scanning_module(src),
		new /obj/item/stock_part/manipulator(src),
		new /obj/item/stock_part/micro_laser(src)
	)
	return TRUE

/obj/machinery/r_n_d/destructive_analyser/refresh_parts()
	var/total_rating = 0
	for(var/obj/item/stock_part/part in src)
		total_rating += part.rating * 0.1
	total_rating = clamp(total_rating, 0, 1)
	decon_mod = total_rating

/obj/machinery/r_n_d/destructive_analyser/meteorhit()
	qdel(src)
	return

/obj/machinery/r_n_d/destructive_analyser/attackby(obj/item/O, mob/user)
	if(..())
		return 1

	if(isscrewdriver(O))
		if(!opened)
			opened = TRUE
			if(linked_console)
				linked_console.linked_destroy = null
				linked_console = null
			icon_state = "d_analyser_t"
		else
			opened = FALSE
			icon_state = "d_analyser"
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
				part.forceMove(loc)
			qdel(src)
			return 1
		else
			to_chat(user, SPAN_WARNING("You can't load \the [src] while it's opened."))
			return 1

	if(!linked_console)
		to_chat(user, SPAN_WARNING("\The [src] must be linked to an R&D console first!"))
		return 1

	if(!isitem(O) || loaded_item)
		return 1
	if(isrobot(user)) // Don't put your module items in there!
		return 1

	if(!O.origin_tech)
		to_chat(user, SPAN_WARNING("This doesn't seem to have a tech origin!"))
		return 1
	var/list/temp_tech = O.origin_tech
	if(!length(temp_tech))
		to_chat(user, SPAN_WARNING("You cannot deconstruct this item!"))
		return 1
	if(O.reliability < 90 && !O.crit_fail)
		to_chat(user, SPAN_WARNING("This item is neither reliable enough nor broken enough to learn from."))
		return 1

	busy = TRUE
	loaded_item = O
	user.drop_item()
	O.forceMove(src)
	to_chat(user, SPAN_INFO("You add \the [O] to \the [src]!"))
	flick("d_analyser_la", src)
	spawn(10)
		icon_state = "d_analyser_l"
		busy = FALSE
	return 1