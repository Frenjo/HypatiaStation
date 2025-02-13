////////////////////////////////////
///// Base Robotics Fabricator /////
////////////////////////////////////
/obj/machinery/robotics_fabricator
	desc = "Nothing is being built."
	icon_state = "fab-idle"
	density = TRUE
	anchored = TRUE

	power_usage = list(
		USE_POWER_IDLE = 20,
		USE_POWER_ACTIVE = 5000
	)

	req_access = list(ACCESS_ROBOTICS)

	var/time_coeff = 1.5 //can be upgraded with research
	var/resource_coeff = 1.5 //can be upgraded with research
	var/datum/material_container/materials

	var/ui_id = null

	var/datum/research/files
	var/design_flag = null

	var/id
	var/sync = 0
	var/part_set
	var/datum/design/being_built
	var/list/datum/design/queue = list()
	var/processing_queue = 0
	var/screen = "main"
	var/opened = FALSE
	var/temp
	var/list/part_sets = list() //set names must be unique

/obj/machinery/robotics_fabricator/New()
	materials = new /datum/material_container(src, list(
		/decl/material/steel, /decl/material/glass, /decl/material/silver,
		/decl/material/gold, /decl/material/diamond, /decl/material/uranium,
		/decl/material/plasma, /decl/material/bananium
	))
	. = ..()
	files = new /datum/research(src) // Sets up the research data holder.

/obj/machinery/robotics_fabricator/Destroy()
	QDEL_NULL(files)
	QDEL_NULL(being_built)
	for_no_type_check(var/datum/design/queued, queue)
		queue.Remove(queued)
		qdel(queued)
	queue.Cut()
	part_sets.Cut()
	return ..()

/obj/machinery/robotics_fabricator/add_parts()
	component_parts = list(
		new /obj/item/stock_part/matter_bin(src),
		new /obj/item/stock_part/matter_bin(src),
		new /obj/item/stock_part/manipulator(src),
		new /obj/item/stock_part/micro_laser(src),
		new /obj/item/stock_part/console_screen(src)
	)
	return TRUE

/obj/machinery/robotics_fabricator/refresh_parts()
	var/total_rating = 0
	for(var/obj/item/stock_part/matter_bin/bin in component_parts)
		total_rating += bin.rating
	materials.set_max_capacity((MATERIAL_AMOUNT_PER_SHEET * 50) + (total_rating * (MATERIAL_AMOUNT_PER_SHEET * 100)))

	total_rating = 0
	for(var/obj/item/stock_part/micro_laser/laser in component_parts)
		total_rating += laser.rating
	if(total_rating >= 1)
		total_rating -= 1
	var/coeff_diff = round(initial(resource_coeff) - (initial(resource_coeff) * total_rating) / 25, 0.01)
	if(resource_coeff != coeff_diff)
		resource_coeff = coeff_diff

	total_rating = 0
	for(var/obj/item/stock_part/manipulator/manipulator in component_parts)
		total_rating += manipulator.rating
	if(total_rating >= 1)
		total_rating -= 1
	coeff_diff = round(initial(time_coeff) - (initial(time_coeff) * total_rating) / 25, 0.01)
	if(time_coeff != coeff_diff)
		time_coeff = coeff_diff

/obj/machinery/robotics_fabricator/proc/operation_allowed(mob/M)
	if(isrobot(M) || isAI(M))
		return 1
	if(!length(req_access))
		return 1
	else if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/ID in list(H.get_active_hand(), H.id_store, H.belt))
			if(check_access(ID))
				return 1
	FEEDBACK_ACCESS_DENIED(M)
	return 0

/obj/machinery/robotics_fabricator/check_access(obj/item/card/id/I)
	if(istype(I, /obj/item/pda))
		var/obj/item/pda/pda = I
		I = pda.id
	if(!istype(I) || !I.access) //not ID or no access
		return 0
	for(var/req in req_access)
		if(!(req in I.access)) //doesn't have this access
			return 0
	return 1

/obj/machinery/robotics_fabricator/proc/emag()
	switch(emagged)
		if(0)
			emagged = 0.5
			visible_message("\icon[src] <b>[src]</b> beeps, \"DB error \[Code 0x00F1\]...\"")
			sleep(10)
			visible_message("\icon[src] <b>[src]</b> beeps, \"Attempting auto-repair...\"")
			sleep(15)
			visible_message("\icon[src] <b>[src]</b> beeps, \"User DB corrupted \[Code 0x00FA\]. Truncating data structure...\"")
			sleep(30)
			visible_message("\icon[src] <b>[src]</b> beeps, \"User DB truncated. Please contact your NanoTrasen system operator for future assistance.\"")
			req_access = null
			emagged = 1
		if(0.5)
			visible_message("\icon[src] <b>[src]</b> beeps, \"DB not responding \[Code 0x0003\]...\"")
		if(1)
			visible_message("\icon[src] <b>[src]</b> beeps, \"No records in User DB.\"")

/obj/machinery/robotics_fabricator/proc/output_parts_list(set_name)
	. = ""
	for_no_type_check(var/datum/design/D, files.known_designs)
		if(D.build_type & design_flag)
			for(var/category in D.categories)
				if(category != set_name)
					continue
				. += "<div class='part'>[output_part_info(D)]<br>\[[has_materials(D) ? "<a href='byond://?src=\ref[src];part=[D.type]'>Build</a> | " : null]<a href='byond://?src=\ref[src];add_to_queue=[D.type]'>Add to queue</a>\]\[<a href='byond://?src=\ref[src];part_desc=[D.type]'>?</a>\]</div>"

/obj/machinery/robotics_fabricator/proc/output_part_info(datum/design/D)
	var/obj/part = D.build_path
	. = "[initial(part.name)] (Cost: [output_part_cost(D)]) [get_construction_time_w_coeff(D) / 10]sec"

/obj/machinery/robotics_fabricator/proc/output_part_cost(datum/design/D)
	var/i = 0
	for(var/material_path in D.materials)
		if(materials.can_contain(material_path))
			var/decl/material/mat = material_path
			. += "[i ? " | " : null][get_resource_cost_w_coeff(D, material_path)] [lowertext(initial(mat.name))]"
			i++

/obj/machinery/robotics_fabricator/proc/output_available_resources()
	for(var/material_path in materials.stored_materials)
		var/decl/material/mat = material_path
		var/amount = materials.get_amount(material_path)
		. += "<span class=\"res_name\">[initial(mat.name)]:</span> [amount]cm<sup>3</sup>"
		if(amount > 0)
			. += "<span style='font-size:80%;'> - Remove \[<a href='byond://?src=\ref[src];remove_mat=1;material=[material_path]'>1</a>\] | \[<a href='byond://?src=\ref[src];remove_mat=10;material=[material_path]'>10</a>\] | \[<a href='byond://?src=\ref[src];remove_mat=[materials.max_capacity];material=[material_path]'>All</a>\]</span>"
		. += "<br/>"

/obj/machinery/robotics_fabricator/proc/build_part(datum/design/D)
	var/obj/part = D.build_path
	being_built = D
	desc = "It's building \a [initial(part.name)]."
	remove_materials(D)
	overlays.Add("fab-active")
	update_power_state(USE_POWER_ACTIVE)
	updateUsrDialog()
	sleep(get_construction_time_w_coeff(D))
	update_power_state(USE_POWER_IDLE)
	overlays.Remove("fab-active")
	desc = initial(desc)

	var/obj/item/output = new D.build_path()
	output.forceMove(get_step(src, SOUTH))
	output.matter_amounts = calculate_materials_with_coeff(D)
	visible_message("\icon[src] <b>[src]</b> beeps, \"The following has been completed: [output.name] is built.\"")
	being_built = null
	updateUsrDialog()
	return 1

/obj/machinery/robotics_fabricator/proc/update_queue_on_page()
	send_byjax(usr, "[ui_id].browser", "queue", list_queue())

/obj/machinery/robotics_fabricator/proc/add_part_set_to_queue(set_name)
	if(set_name in part_sets)
		for_no_type_check(var/datum/design/D, files.known_designs)
			if(D.build_type & design_flag)
				for(var/category in D.categories)
					if(category != set_name)
						continue
					add_to_queue(D)

/obj/machinery/robotics_fabricator/proc/add_to_queue(datum/design/D)
	if(!istype(queue))
		queue = list()
	if(D)
		queue[++queue.len] = D
	return length(queue)

/obj/machinery/robotics_fabricator/proc/remove_from_queue(index)
	if(!isnum(index) || !istype(queue) || (index < 1 || index > length(queue)))
		return 0
	queue.Cut(index, ++index)
	return 1

/obj/machinery/robotics_fabricator/proc/process_queue()
	var/datum/design/D = queue[1]
	if(isnull(D))
		remove_from_queue(1)
		if(length(queue))
			return process_queue()
		else
			return
	temp = null
	while(D)
		if(stat & (NOPOWER | BROKEN))
			return 0
		if(!has_materials(D))
			visible_message("\icon[src] <b>[src]</b> beeps, \"Not enough resources. Queue processing stopped\".")
			temp = {"<font color='red'>Not enough resources to build next part.</font><br>
						<a href='byond://?src=\ref[src];process_queue=1'>Try again</a> | <a href='byond://?src=\ref[src];clear_temp=1'>Return</a><a>"}
			return 0
		remove_from_queue(1)
		build_part(D)
		D = listgetindex(queue, 1)
	visible_message("\icon[src] <b>[src]</b> beeps, \"Queue processing finished successfully\".")
	return 1

/obj/machinery/robotics_fabricator/proc/list_queue()
	. = "<b>Queue contains:</b>"
	if(!length(queue))
		. += "<br>Nothing"
	else
		. += "<ol>"
		var/i = 0
		for_no_type_check(var/datum/design/D, queue)
			i++
			var/obj/part = D.build_path
			. += "<li[!has_materials(D) ? " style='color: #f00;'" : null]>[initial(part.name)] - [i > 1 ? "<a href='byond://?src=\ref[src];queue_move=-1;index=[i]' class='arrow'>&uarr;</a>" : null] [i < length(queue) ? "<a href='byond://?src=\ref[src];queue_move=+1;index=[i]' class='arrow'>&darr;</a>" : null] <a href='byond://?src=\ref[src];remove_from_queue=[i]'>Remove</a></li>"
		. += "</ol>"
		. += "\[<a href='byond://?src=\ref[src];process_queue=1'>Process queue</a> | <a href='byond://?src=\ref[src];clear_queue=1'>Clear queue</a>\]"

/obj/machinery/robotics_fabricator/proc/update_tech()
	if(isnull(files))
		return
	for_no_type_check(var/decl/tech/T, files.known_tech)
		if(T?.level > 1)
			var/diff
			switch(T.type) //bad, bad formulas
				if(/decl/tech/materials)
					var/pmat = 0//Calculations to make up for the fact that these parts and tech modify the same thing
					for(var/obj/item/stock_part/micro_laser/Ml in component_parts)
						pmat += Ml.rating
					if(pmat >= 1)
						pmat -= 1//So the equations don't have to be reworked, upgrading a single part from T1 to T2 is == to 1 tech level
					diff = round(initial(resource_coeff) - (initial(resource_coeff) * (T.level + pmat)) / 25, 0.01)
					if(resource_coeff != diff)
						resource_coeff = diff
						. += "Production efficiency increased.<br>"
				if(/decl/tech/programming)
					var/ptime = 0
					for(var/obj/item/stock_part/manipulator/Ma in component_parts)
						ptime += Ma.rating
					if(ptime >= 2)
						ptime -= 2
					diff = round(initial(time_coeff) - (initial(time_coeff) * (T.level + ptime)) / 25, 0.1)
					if(time_coeff != diff)
						time_coeff = diff
						. += "Production routines updated.<br>"

/obj/machinery/robotics_fabricator/proc/sync(silent = null)
	if(!silent)
		temp = "Updating local R&D database..."
		updateUsrDialog()
		sleep(30) //only sleep if called by user
	var/found = 0
	var/area/A = GET_AREA(src)
	for(var/obj/machinery/computer/rdconsole/RDC in A.machines_list)
		if(!RDC.sync)
			continue
		found++
		var/existing_designs = length(files.known_designs)
		for_no_type_check(var/decl/tech/T, RDC.files.known_tech)
			files.AddTech2Known(T)
		for_no_type_check(var/datum/design/D, RDC.files.known_designs)
			files.AddDesign2Known(D)
		files.refresh_research()
		var/i = existing_designs - length(files.known_designs)
		var/tech_output = update_tech()
		if(!silent)
			temp = "Processed [i] equipment designs.<br>"
			temp += tech_output
			temp += "<a href='byond://?src=\ref[src];clear_temp=1'>Return</a>"
			updateUsrDialog()
		if(i || tech_output)
			visible_message("\icon[src] <b>[src]</b> beeps, \"Successfully synchronized with R&D server. New data processed.\"")
	if(found == 0)
		temp = "Couldn't contact R&D server.<br>"
		temp += "<a href='byond://?src=\ref[src];clear_temp=1'>Return</a>"
		updateUsrDialog()
		visible_message("\icon[src] <b>[src]</b> beeps, \"Error! Couldn't connect to R&D server.\"")

/obj/machinery/robotics_fabricator/attack_hand(mob/user)
	var/dat, left_part
	if(..())
		return
	if(!operation_allowed(user))
		return
	user.set_machine(src)
	var/turf/exit = get_step(src, SOUTH)
	if(exit.density)
		visible_message("\icon[src] <b>[src]</b> beeps, \"Error! Part outlet is obstructed\".")
		return
	if(temp)
		left_part = temp
	else if(being_built)
		var/obj/building = being_built.build_path
		left_part = {"<TT>Building [initial(building.name)].<BR>
							Please wait until completion...</TT>"}
	else
		switch(screen)
			if("main")
				left_part = output_available_resources()+"<hr>"
				left_part += "<a href='byond://?src=\ref[src];sync=1'>Sync with R&D servers</a><hr>"
				for(var/part_set in part_sets)
					left_part += "<a href='byond://?src=\ref[src];part_set=[part_set]'>[part_set]</a> - <a href='byond://?src=\ref[src];partset_to_queue=[part_set]'>\[Add all parts to queue\]<br>"
			if("parts")
				left_part += output_parts_list(part_set)
				left_part += "<hr><a href='byond://?src=\ref[src];screen=main'>Return</a>"
	dat = {"<html>
			  <head>
			  <title>[name]</title>
				<style>
				.res_name {font-weight: bold; text-transform: capitalize;}
				.red {color: #f00;}
				.part {margin-bottom: 10px;}
				.arrow {text-decoration: none; font-size: 10px;}
				body, table {height: 100%;}
				td {vertical-align: top; padding: 5px;}
				html, body {padding: 0px; margin: 0px;}
				h1 {font-size: 18px; margin: 5px 0px;}
				</style>
				<script language='javascript' type='text/javascript'>
				[js_byjax]
				</script>
				</head><body>
				<body>
				<table style='width: 100%;'>
				<tr>
				<td style='width: 70%; padding-right: 10px;'>
				[left_part]
				</td>
				<td style='width: 30%; background: #ccc;' id='queue'>
				[list_queue()]
				</td>
				<tr>
				</table>
				</body>
				</html>"}
	user << browse(dat, "window=[ui_id];size=1000x600")
	onclose(user, ui_id)

/obj/machinery/robotics_fabricator/Topic(href, href_list)
	. = ..()
	var/datum/topic_input/topic_filter = new /datum/topic_input(href, href_list)
	if(href_list["part_set"])
		var/tpart_set = topic_filter.getStr("part_set")
		if(tpart_set)
			if(tpart_set == "clear")
				part_set = null
			else
				part_set = tpart_set
				screen = "parts"
	if(href_list["part"])
		var/path = topic_filter.getPath("part")
		for_no_type_check(var/datum/design/D, files.known_designs)
			if(D.build_type & design_flag)
				if(D.type == path)
					if(!processing_queue)
						build_part(D)
					else
						add_to_queue(D)
					break
	if(href_list["add_to_queue"])
		var/path = topic_filter.getPath("add_to_queue")
		for_no_type_check(var/datum/design/D, files.known_designs)
			if(D.build_type & design_flag)
				if(D.type == path)
					add_to_queue(D)
					break
		return update_queue_on_page()
	if(href_list["remove_from_queue"])
		remove_from_queue(topic_filter.getNum("remove_from_queue"))
		return update_queue_on_page()
	if(href_list["partset_to_queue"])
		add_part_set_to_queue(topic_filter.get("partset_to_queue"))
		return update_queue_on_page()
	if(href_list["process_queue"])
		spawn(-1)
			if(processing_queue || being_built)
				return
			processing_queue = TRUE
			process_queue()
			processing_queue = FALSE

	if(href_list["clear_temp"])
		temp = null
	if(href_list["screen"])
		screen = href_list["screen"]
	if(href_list["queue_move"] && href_list["index"])
		var/index = topic_filter.getNum("index")
		var/new_index = index + topic_filter.getNum("queue_move")
		if(isnum(index) && isnum(new_index))
			if(InRange(new_index, 1, length(queue)))
				queue.Swap(index, new_index)
		return update_queue_on_page()
	if(href_list["clear_queue"])
		queue = list()
		return update_queue_on_page()
	if(href_list["sync"])
		queue = list()
		sync()
		return update_queue_on_page()
	if(href_list["part_desc"])
		var/path = topic_filter.getPath("part_desc")
		for_no_type_check(var/datum/design/D, files.known_designs)
			if(D.build_type & design_flag)
				if(D.type == path)
					var/obj/part = D.build_path
					temp = {"<h1>[initial(part.name)] description:</h1>
								[initial(part.desc)]<br>
								<a href='byond://?src=\ref[src];clear_temp=1'>Return</a>
							"}
					break
	if(href_list["remove_mat"] && href_list["material"])
		var/decl/material/mat = topic_filter.getPath("material")
		temp = "Ejected [materials.eject_sheets(mat, topic_filter.getNum("remove_mat"))] sheets of [lowertext(initial(mat.name))]."
		temp += "<br>"
		temp += "<a href='byond://?src=\ref[src];clear_temp=1'>Return</a>"
	updateUsrDialog()

/obj/machinery/robotics_fabricator/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(emagged > 0)
		FEEDBACK_ALREADY_EMAGGED(user)
		return FALSE

	emag()
	files.show_hidden_designs = TRUE
	files.refresh_research()
	return TRUE

/obj/machinery/robotics_fabricator/attack_tool(obj/item/tool, mob/user)
	if(isscrewdriver(tool))
		if(!opened)
			opened = TRUE
			icon_state = "fab-o"
		else
			opened = FALSE
			icon_state = "fab-idle"
		playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
		FEEDBACK_TOGGLE_MAINTENANCE_PANEL(user, opened)
		return TRUE

	if(opened && iscrowbar(tool))
		playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
		var/obj/machinery/constructable_frame/machine_frame/M = new /obj/machinery/constructable_frame/machine_frame(loc)
		M.state = 2
		M.icon_state = "box_1"
		for_no_type_check(var/obj/item/part, component_parts)
			if(part.reliability != 100 && crit_fail)
				part.crit_fail = TRUE
			part.forceMove(loc)
		materials.eject_all_sheets()
		qdel(src)
		return TRUE

	return ..()

/obj/machinery/robotics_fabricator/attackby(obj/W, mob/user)
	if(opened)
		to_chat(user, SPAN_WARNING("You can't load \the [src] while it's opened."))
		return 1

	if(!istype(W, /obj/item/stack/sheet))
		return
	var/obj/item/stack/sheet/stack = W
	if(isnull(stack.material))
		return ..()
	if(being_built)
		to_chat(user, SPAN_WARNING("\The [src] is currently processing. Please wait until completion."))
		return
	if(!materials.can_contain(stack.material.type))
		to_chat(user, SPAN_WARNING("\The [src] cannot accept [stack.name]!"))
		return
	if(!materials.can_add_amount(stack.material.type, stack.material.per_unit))
		to_chat(user, SPAN_WARNING("\The [src] cannot hold more [stack.name]."))
		return

	overlays.Add("fab-load-[lowertext(stack.material.name)]")
	if(do_after(user, 1 SECOND))
		to_chat(user, SPAN_INFO("You insert [materials.add_sheets(stack)] [stack.name] into \the [src]."))
	else
		to_chat(user, SPAN_WARNING("You fail to insert the [stack.name] into \the [src]."))
	overlays.Remove("fab-load-[lowertext(stack.material.name)]")

// Returns TRUE if the internal container has all of the required material amounts.
/obj/machinery/robotics_fabricator/proc/has_materials(datum/design/D)
	return materials.has_materials(calculate_materials_with_coeff(D))

// Removes the provided material amounts from the internal container's stored materials.
/obj/machinery/robotics_fabricator/proc/remove_materials(datum/design/D)
	return materials.remove_materials(calculate_materials_with_coeff(D))

// Helper procs related to calculating material and time coefficients.
/obj/machinery/robotics_fabricator/proc/calculate_materials_with_coeff(datum/design/D)
	. = list()
	for(var/material_path in D.materials)
		.[material_path] = get_resource_cost_w_coeff(D, material_path)

/obj/machinery/robotics_fabricator/proc/get_resource_cost_w_coeff(datum/design/D, material_path, roundto = 1)
	return round(D.materials[material_path] * resource_coeff, roundto)

/obj/machinery/robotics_fabricator/proc/get_construction_time_w_coeff(datum/design/D, roundto = 1)
	return round(D.build_time * time_coeff, roundto)