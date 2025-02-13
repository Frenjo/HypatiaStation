//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
/obj/machinery/autolathe
	name = "autolathe"
	desc = "It produces items using steel and glass."
	icon = 'icons/obj/machines/fabricators/autolathe.dmi'
	icon_state = "autolathe"
	density = TRUE
	anchored = TRUE

	power_usage = list(
		USE_POWER_IDLE = 10,
		USE_POWER_ACTIVE = 100
	)

	var/list/stored_materials = list(/decl/material/steel = 0, /decl/material/glass = 0)
	var/list/storage_capacity = list(/decl/material/steel = 0, /decl/material/glass = 0) // This gets determined by the installed matter bins.

	var/panel_open = 0

	var/datum/research/files

	var/hacked = 0
	var/disabled = 0
	var/shocked = 0

	var/datum/wires/autolathe/wires = null

	var/busy = FALSE

/obj/machinery/autolathe/New()
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
	for(var/material_path in storage_capacity)
		storage_capacity[material_path] = total_rating * 2

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
	var/dat
	var/total_stored = 0
	var/total_capacity = 0
	for(var/material_path in stored_materials)
		var/decl/material/mat = material_path
		total_stored += stored_materials[mat]
		total_capacity += storage_capacity[mat]
		dat += "<font color='[initial(mat.mint_colour_code)]'><b>[initial(mat.name)] Amount:</b></font> [stored_materials[mat]]cm<sup>3</sup>"
		dat += " (MAX: [storage_capacity[mat]]cm<sup>3</sup>)"
		dat += "<br>"
	dat += "<b>Total Amount:</b> [total_stored]cm<sup>3</sup> (MAX: [total_capacity]cm<sup>3</sup>)"
	dat += "<hr>"

	for_no_type_check(var/datum/design/D, files.known_designs)
		if(!(D.build_type & DESIGN_TYPE_AUTOLATHE))
			continue
		var/obj/part = D.build_path
		var/title = "[initial(part.name)] ([output_part_cost(D)])"
		if(!check_resources(D))
			dat += title
			dat += "<br>"
			continue
		dat += "<A href='byond://?src=\ref[src];make=[D.type]'>[title]</A>"
		if(ispath(D.build_path, /obj/item/stack))
			var/obj/item/stack/S = D.build_path
			var/max_multiplier = initial(S.max_amount)
			var/list/matter_amounts = initial(S.matter_amounts)
			for(var/material_path in matter_amounts)
				max_multiplier = min(max_multiplier, round(stored_materials[material_path] / matter_amounts[material_path]))
			if(max_multiplier > 1)
				dat += " |"
			if(max_multiplier > 10)
				dat += " <A href='byond://?src=\ref[src];make=[D.type];multiplier=10'>x10</A>"
			if(max_multiplier > 25)
				dat += " <A href='byond://?src=\ref[src];make=[D.type];multiplier=25'>x25</A>"
			if(max_multiplier > 1)
				dat += " <A href='byond://?src=\ref[src];make=[D.type];multiplier=[max_multiplier]'>x[max_multiplier]</A>"
		dat += "<br>"
	user << browse("<HTML><HEAD><TITLE>Autolathe Control Panel</TITLE></HEAD><BODY><TT>[dat]</TT></BODY></HTML>", "window=autolathe_regular")
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
			for(var/material_path in stored_materials)
				var/decl/material/mat = material_path
				var/per_unit = initial(mat.per_unit)
				if(stored_materials[material_path] >= per_unit)
					var/sheet_path = initial(mat.sheet_path)
					new sheet_path(loc, round(stored_materials[material_path] / per_unit))
			qdel(src)
			return TRUE

	return ..()

/obj/machinery/autolathe/attack_by(obj/item/I, mob/user)
	// If it doesn't have any matter then we obviously can't recycle it.
	if(!length(I.matter_amounts))
		to_chat(user, SPAN_WARNING("\The [I] does not contain sufficient material to be accepted by \the [src]."))
		return TRUE

	for(var/material_path in I.matter_amounts)
		// If it has any matter that we can't accept, then we also can't recycle it.
		if(!(material_path in stored_materials))
			to_chat(user, SPAN_WARNING("\The [src] cannot accept \the [I]."))
			return TRUE
		// Finally, if any of the required material storages are full, then we again can't recycle it.
		if(stored_materials[material_path] + I.matter_amounts[material_path] > storage_capacity[material_path])
			var/decl/material/mat = material_path
			to_chat(user, SPAN_WARNING("\The [src] is full. Please remove [lowertext(initial(mat.name))] from \the [src] in order to insert more."))
			return TRUE

	return ..()

/obj/machinery/autolathe/attackby(obj/item/O, mob/user)
	var/amount = 1
	var/m_amt = O.matter_amounts[MATERIAL_METAL]
	var/g_amt = O.matter_amounts[/decl/material/glass]
	if(istype(O, /obj/item/stack))
		var/obj/item/stack/stack = O
		amount = stack.amount
		if(m_amt)
			amount = min(amount, round((storage_capacity[MATERIAL_METAL] - stored_materials[MATERIAL_METAL]) / m_amt))
			flick("autolathe_o", src)//plays metal insertion animation
		if(g_amt)
			amount = min(amount, round((storage_capacity[/decl/material/glass] - stored_materials[/decl/material/glass]) / g_amt))
			flick("autolathe_r", src)//plays glass insertion animation
		stack.use(amount)
	else
		usr.before_take_item(O)
		O.forceMove(src)

	icon_state = "autolathe"
	busy = TRUE
	use_power(max(1000, (m_amt + g_amt) * amount / 10))
	stored_materials[MATERIAL_METAL] += m_amt * amount
	stored_materials[/decl/material/glass] += g_amt * amount
	to_chat(user, SPAN_INFO("You insert [amount] sheet\s into \the [src]."))
	if(O?.loc == src)
		qdel(O)
	busy = FALSE
	updateUsrDialog()

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
		var/build_path = topic_filter.getPath("make")
		var/multiplier = topic_filter.getNum("multiplier")
		for_no_type_check(var/datum/design/D, files.known_designs)
			if(!(D.build_type & DESIGN_TYPE_AUTOLATHE))
				continue
			if(D.type == build_path)
				build_part(D, isnotnull(multiplier) ? multiplier : 1)

/obj/machinery/autolathe/proc/output_part_cost(datum/design/D)
	var/i = 0
	for(var/material_path in D.materials)
		if(material_path in stored_materials)
			var/decl/material/mat = material_path
			. += "[i ? " / " : null][D.materials[material_path]]cm<sup>3</sup> [lowertext(initial(mat.name))]"
			i++

/obj/machinery/autolathe/proc/check_resources(datum/design/D)
	for(var/material_path in D.materials)
		if(material_path in stored_materials)
			if(stored_materials[material_path] < D.materials[material_path])
				return FALSE
		else
			return FALSE
	return TRUE

/obj/machinery/autolathe/proc/set_hacked(new_hacked)
	hacked = new_hacked
	files.show_hidden_designs = hacked
	files.refresh_research()

/obj/machinery/autolathe/proc/build_part(datum/design/D, multiplier)
	busy = TRUE
	var/total_amount_used = 0
	for(var/material_path in D.materials)
		var/amount = D.materials[material_path]
		stored_materials[material_path] -= amount * multiplier
		total_amount_used += amount
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