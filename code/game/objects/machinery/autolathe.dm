//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
/obj/machinery/autolathe
	name = "autolathe"
	desc = "It produces items using steel and glass."
	icon = 'icons/obj/machines/fabricators/autolathe.dmi'
	icon_state = "autolathe"
	density = TRUE
	anchored = TRUE

	power_usage = alist(
		USE_POWER_IDLE = 10,
		USE_POWER_ACTIVE = 100
	)

	var/panel_open = FALSE

	var/datum/research/files

	var/hacked = FALSE
	var/disabled = FALSE
	var/shocked = FALSE

	var/datum/wires/autolathe/wires = null

	var/busy = FALSE

/obj/machinery/autolathe/New()
	AddComponent(/datum/component/material_container, list(
		/decl/material/iron, /decl/material/steel,
		/decl/material/plastic, /decl/material/glass
	))
	. = ..()
	files = new /datum/research(src) // Sets up the research data holder.
	wires = new /datum/wires/autolathe(src)

/obj/machinery/autolathe/Destroy()
	QDEL_NULL(files)
	QDEL_NULL(wires)
	return ..()

/obj/machinery/autolathe/add_parts()
	component_parts = list(
		new /obj/item/circuitboard/autolathe(src),
		new /obj/item/stock_part/matter_bin(src),
		new /obj/item/stock_part/matter_bin(src),
		new /obj/item/stock_part/matter_bin(src),
		new /obj/item/stock_part/manipulator(src),
		new /obj/item/stock_part/console_screen(src)
	)
	return TRUE

/obj/machinery/autolathe/refresh_parts()
	var/total_rating = 0
	for(var/obj/item/stock_part/matter_bin/bin in component_parts)
		total_rating += bin.rating
	total_rating *= 25000
	GET_COMPONENT(materials, /datum/component/material_container)
	materials.set_max_capacity(total_rating * 2)

/obj/machinery/autolathe/interact(mob/user)
	if(..())
		return

	if(shocked)
		shock(user, 50)

	if(panel_open)
		wires_win(user, 50)
		return

	if(disabled)
		to_chat(user, SPAN_WARNING("You press the button, but nothing happens."))
		return

	regular_win(user)
	return

/obj/machinery/autolathe/proc/wires_win(mob/user)
	var/dat
	dat += "Autolathe Wires:"
	dat += "<br>"
	dat += wires.GetInteractWindow()

/obj/machinery/autolathe/proc/regular_win(mob/user)
	var/dat = "<html><head><title>[name]</title></head><body>"
	dat += "<tt>"
	GET_COMPONENT(materials, /datum/component/material_container)
	for(var/material_path in materials.stored_materials)
		var/decl/material/mat = material_path
		dat += "<font color='[initial(mat.colour_code)]'><b>[initial(mat.name)]:</b></font> [materials.get_type_amount(mat)]cm<sup>3</sup>"
		dat += " (MAX: [materials.get_total_type_capacity(mat)]cm<sup>3</sup>)"
		dat += "<br>"
	dat += "<b>Total Amount:</b> [materials.get_total_amount()]cm<sup>3</sup> (MAX: [materials.get_total_capacity()]cm<sup>3</sup>)"
	dat += "<hr>"

	for_no_type_check(var/datum/design/D, files.known_designs)
		if(!(D.build_type & DESIGN_TYPE_AUTOLATHE))
			continue
		var/obj/thing = D.build_path
		var/title = "[initial(thing.name)] ([output_item_cost(D)])"
		if(!materials.has_materials(D.materials))
			dat += title
			dat += "<br>"
			continue
		dat += "<A href='byond://?src=\ref[src];make=[D.type]'>[title]</A>"
		if(ispath(D.build_path, /obj/item/stack))
			var/obj/item/stack/S = thing
			var/max_multiplier = initial(S.max_amount)
			var/list/matter_amounts = initial(S.matter_amounts)
			for(var/material_path in matter_amounts)
				max_multiplier = min(max_multiplier, round(materials.get_type_amount(material_path) / matter_amounts[material_path]))
			if(max_multiplier > 1)
				dat += " |"
			if(max_multiplier > 10)
				dat += " <A href='byond://?src=\ref[src];make=[D.type];multiplier=10'>x10</A>"
			if(max_multiplier > 25)
				dat += " <A href='byond://?src=\ref[src];make=[D.type];multiplier=25'>x25</A>"
			if(max_multiplier > 1)
				dat += " <A href='byond://?src=\ref[src];make=[D.type];multiplier=[max_multiplier]'>x[max_multiplier]</A>"
		dat += "<br>"
	dat += "</tt></body></html>"
	SHOW_BROWSER(user, dat, "window=autolathe_regular;size=600x800")
	onclose(user, "autolathe_regular")

/obj/machinery/autolathe/proc/shock(mob/user, prb)
	if(stat & (BROKEN | NOPOWER))		// unpowered, no shock
		return 0
	if(!prob(prb))
		return 0
	make_sparks(5, TRUE, src)
	if(electrocute_mob(user, GET_AREA(src), src, 0.7))
		return 1
	else
		return 0

/obj/machinery/autolathe/attack_tool(obj/item/tool, mob/user)
	if(stat)
		return TRUE
	if(busy)
		to_chat(user, SPAN_WARNING("The autolathe is busy. Please wait for completion of previous operation."))
		return TRUE

	if(isscrewdriver(tool))
		if(!panel_open)
			icon_state = "autolathe_t"
		else
			icon_state = "autolathe"
		panel_open = !panel_open
		FEEDBACK_TOGGLE_MAINTENANCE_PANEL(user, panel_open)
		playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
		return TRUE

	if(iscrowbar(tool))
		if(panel_open)
			playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
			var/obj/machinery/constructable_frame/machine_frame/M = new /obj/machinery/constructable_frame/machine_frame(loc)
			M.state = 2
			M.icon_state = "box_1"
			for_no_type_check(var/obj/item/part, component_parts)
				part.forceMove(loc)
				if(part.reliability != 100 && crit_fail)
					part.crit_fail = TRUE
			GET_COMPONENT(materials, /datum/component/material_container)
			materials.eject_all_sheets()
			qdel(src)
			return TRUE

	return ..()

/obj/machinery/autolathe/attack_by(obj/item/I, mob/user)
	if(..())
		return TRUE

	// If it doesn't have any matter then we obviously can't recycle it.
	if(!length(I.matter_amounts))
		to_chat(user, SPAN_WARNING("\The [I] does not contain sufficient material to be accepted by \the [src]."))
		return TRUE

	GET_COMPONENT(materials, /datum/component/material_container)
	for(var/material_path in I.matter_amounts)
		// If it has any matter that we can't accept, then we also can't recycle it.
		if(!materials.can_contain(material_path))
			to_chat(user, SPAN_WARNING("\The [src] cannot accept \the [I]!"))
			return TRUE
		// Finally, if any of the required material storages are full, then we again can't recycle it.
		if(!materials.can_add_amount(material_path, I.matter_amounts[material_path]))
			var/decl/material/mat = material_path
			to_chat(user, SPAN_WARNING("\The [src] is full. Please remove [lowertext(initial(mat.name))] from \the [src] in order to insert more."))
			return TRUE

	add_item(I, user)
	return TRUE

/obj/machinery/autolathe/attack_paw(mob/user)
	return attack_hand(user)

/obj/machinery/autolathe/attack_hand(mob/user)
	user.set_machine(src)
	interact(user)

/obj/machinery/autolathe/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)

	if(busy)
		to_chat(usr, SPAN_WARNING("\The [src] is busy. Please wait for completion of the previous operation."))
		return

	var/datum/topic_input/topic_filter = new /datum/topic_input(href, href_list)

	if(href_list["make"])
		var/build_path = topic_filter.get_path("make")
		var/multiplier = topic_filter.get_num("multiplier")
		for_no_type_check(var/datum/design/D, files.known_designs)
			if(!(D.build_type & DESIGN_TYPE_AUTOLATHE))
				continue
			if(D.type == build_path)
				build_item(D, isnotnull(multiplier) ? multiplier : 1)

/obj/machinery/autolathe/proc/output_item_cost(datum/design/D)
	var/i = 0
	GET_COMPONENT(materials, /datum/component/material_container)
	for(var/material_path in D.materials)
		if(materials.can_contain(material_path))
			var/decl/material/mat = material_path
			. += "[i ? " / " : null][D.materials[material_path]]cm<sup>3</sup> [lowertext(initial(mat.name))]"
			i++

/obj/machinery/autolathe/proc/set_hacked(new_hacked)
	hacked = new_hacked
	files.show_hidden_designs = hacked
	files.refresh_research() // Write a custom version of this that doesn't refresh everything but only refreshes the hidden stuff.

/obj/machinery/autolathe/proc/build_item(datum/design/D, multiplier)
	busy = TRUE
	GET_COMPONENT(materials, /datum/component/material_container)
	var/total_amount_used = materials.remove_materials(D.materials)
	icon_state = "autolathe_n"
	power_usage[USE_POWER_ACTIVE] = max(2000, total_amount_used * multiplier / 5)
	update_power_state(USE_POWER_ACTIVE)
	updateUsrDialog()
	sleep(D.build_time)
	update_power_state(USE_POWER_IDLE)
	power_usage[USE_POWER_ACTIVE] = initial(power_usage[USE_POWER_ACTIVE])
	icon_state = "autolathe"

	var/obj/item/output = new D.build_path()
	if(multiplier > 1)
		var/obj/item/stack/output_stack = output
		output_stack.amount = multiplier
	output.forceMove(get_step(src, SOUTH))
	for(var/material_path in D.materials)
		output.matter_amounts[material_path] = D.materials[material_path]
	busy = FALSE
	updateUsrDialog()

/obj/machinery/autolathe/proc/add_item(obj/item/I, mob/user)
	var/amount = 1
	GET_COMPONENT(materials, /datum/component/material_container)
	if(istype(I, /obj/item/stack))
		var/obj/item/stack/input_stack = I
		if(!do_after(user, 0.25 SECONDS))
			to_chat(user, SPAN_WARNING("You fail to insert \the [input_stack] into \the [src]."))
			return TRUE
		amount = input_stack.amount
		for(var/material_path in I.matter_amounts)
			amount = min(amount, round(materials.get_remaining_type_capacity(material_path) / I.matter_amounts[material_path]))
		input_stack.use(amount)
		to_chat(user, SPAN_INFO("You insert [amount] [input_stack.singular_name]\s into \the [src]."))
	else
		to_chat(user, SPAN_INFO("You insert \the [I] into \the [src]."))

	busy = TRUE
	var/total_amount_added = materials.add_materials(I.matter_amounts, amount)
	use_power(max(1000, (total_amount_added * amount) / 10))
	if(isnotnull(I))
		user.drop_from_inventory(I)
		qdel(I)
	busy = FALSE
	updateUsrDialog()
	return TRUE