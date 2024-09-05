/////////////////////////////
///// Part Fabricator ///////
/////////////////////////////

/obj/machinery/mecha_part_fabricator
	name = "exosuit fabricator"
	desc = "Nothing is being built."
	icon = 'icons/obj/machines/fabricators.dmi'
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
	var/list/stored_materials = list(
		/decl/material/steel	= 0,
		/decl/material/glass	= 0,
		/decl/material/silver	= 0,
		/decl/material/gold		= 0,
		/decl/material/diamond	= 0,
		/decl/material/uranium	= 0,
		/decl/material/plasma	= 0,
		/decl/material/bananium	= 0
		// Re-enabled bananium. -Frenjo
	)
	var/res_max_amount = 200000
	var/datum/research/files
	var/id
	var/sync = 0
	var/part_set
	var/obj/being_built
	var/list/queue = list()
	var/processing_queue = 0
	var/screen = "main"
	var/opened = FALSE
	var/temp
	var/list/part_sets = list( //set names must be unique
		"Robot" = list(
			/obj/item/robot_parts/robot_suit,
			/obj/item/robot_parts/chest,
			/obj/item/robot_parts/head,
			/obj/item/robot_parts/l_arm,
			/obj/item/robot_parts/r_arm,
			/obj/item/robot_parts/l_leg,
			/obj/item/robot_parts/r_leg,
			/obj/item/robot_parts/robot_component/binary_communication_device,
			/obj/item/robot_parts/robot_component/radio,
			/obj/item/robot_parts/robot_component/actuator,
			/obj/item/robot_parts/robot_component/diagnosis_unit,
			/obj/item/robot_parts/robot_component/camera,
			/obj/item/robot_parts/robot_component/armour
		),
		"Ripley" = list(
			/obj/item/mecha_part/chassis/ripley,
			/obj/item/mecha_part/part/ripley_torso,
			/obj/item/mecha_part/part/ripley_left_arm,
			/obj/item/mecha_part/part/ripley_right_arm,
			/obj/item/mecha_part/part/ripley_left_leg,
			/obj/item/mecha_part/part/ripley_right_leg
		),
		"Odysseus" = list(
			/obj/item/mecha_part/chassis/odysseus,
			/obj/item/mecha_part/part/odysseus_torso,
			/obj/item/mecha_part/part/odysseus_head,
			/obj/item/mecha_part/part/odysseus_left_arm,
			/obj/item/mecha_part/part/odysseus_right_arm,
			/obj/item/mecha_part/part/odysseus_left_leg,
			/obj/item/mecha_part/part/odysseus_right_leg
		),
		"Gygax" = list(
			/obj/item/mecha_part/chassis/gygax,
			/obj/item/mecha_part/part/gygax_torso,
			/obj/item/mecha_part/part/gygax_head,
			/obj/item/mecha_part/part/gygax_left_arm,
			/obj/item/mecha_part/part/gygax_right_arm,
			/obj/item/mecha_part/part/gygax_left_leg,
			/obj/item/mecha_part/part/gygax_right_leg,
			/obj/item/mecha_part/part/gygax_armour
		),
		"Durand" = list(
			/obj/item/mecha_part/chassis/durand,
			/obj/item/mecha_part/part/durand_torso,
			/obj/item/mecha_part/part/durand_head,
			/obj/item/mecha_part/part/durand_left_arm,
			/obj/item/mecha_part/part/durand_right_arm,
			/obj/item/mecha_part/part/durand_left_leg,
			/obj/item/mecha_part/part/durand_right_leg,
			/obj/item/mecha_part/part/durand_armour
		),
		"H.O.N.K" = list(
			/obj/item/mecha_part/chassis/honker,
			/obj/item/mecha_part/part/honker_torso,
			/obj/item/mecha_part/part/honker_head,
			/obj/item/mecha_part/part/honker_left_arm,
			/obj/item/mecha_part/part/honker_right_arm,
			/obj/item/mecha_part/part/honker_left_leg,
			/obj/item/mecha_part/part/honker_right_leg
		),
		"Exosuit Equipment" = list(
			/obj/item/mecha_part/equipment/tool/hydraulic_clamp,
			/obj/item/mecha_part/equipment/tool/drill,
			/obj/item/mecha_part/equipment/tool/extinguisher,
			/obj/item/mecha_part/equipment/tool/cable_layer,
			/obj/item/mecha_part/equipment/tool/passenger, // Ported this from NSS Eternal along with the hoverpod. -Frenjo
			/obj/item/mecha_part/equipment/tool/sleeper,
			/obj/item/mecha_part/equipment/tool/syringe_gun,
			/obj/item/mecha_part/chassis/firefighter,
			/obj/item/mecha_part/equipment/repair_droid, // Re-enabled this. -Frenjo
			/obj/item/mecha_part/equipment/generator,
			///obj/item/mecha_part/equipment/jetpack, //TODO MECHA JETPACK SPRITE MISSING
			/obj/item/mecha_part/equipment/weapon/energy/taser,
			/obj/item/mecha_part/equipment/weapon/ballistic/lmg,
			/obj/item/mecha_part/equipment/weapon/ballistic/missile_rack/banana_mortar/mousetrap_mortar,
			/obj/item/mecha_part/equipment/weapon/ballistic/missile_rack/banana_mortar,
			/obj/item/mecha_part/equipment/weapon/honker
		),
		"Robotic Upgrade Modules" = list(
			/obj/item/borg/upgrade/reset,
			/obj/item/borg/upgrade/rename,
			/obj/item/borg/upgrade/restart,
			/obj/item/borg/upgrade/vtec,
			/obj/item/borg/upgrade/tasercooler,
			/obj/item/borg/upgrade/jetpack
		),
		"Misc" = list(
			/obj/item/mecha_part/tracking
		)
	)

/obj/machinery/mecha_part_fabricator/New()
	. = ..()
	component_parts = list(
		new /obj/item/circuitboard/mechfab(src),
		new /obj/item/stock_part/matter_bin(src),
		new /obj/item/stock_part/matter_bin(src),
		new /obj/item/stock_part/manipulator(src),
		new /obj/item/stock_part/micro_laser(src),
		new /obj/item/stock_part/console_screen(src)
	)
	RefreshParts()

	//	part_sets["Cyborg Upgrade Modules"] = typesof(/obj/item/borg/upgrade/) - /obj/item/borg/upgrade/  // Eh.  This does it dymaically, but to support having the items referenced otherwhere in the code but not being constructable, going to do it manaully.

	for(var/part_set in part_sets)
		convert_part_set(part_set)
	files = new /datum/research(src) //Setup the research data holder.
	/*
	if(!id)
		for(var/obj/machinery/r_n_d/server/centcom/S in GLOBL.machines)
			S.initialize()
			break
	*/

/obj/machinery/mecha_part_fabricator/RefreshParts()
	var/T = 0
	for(var/obj/item/stock_part/matter_bin/M in component_parts)
		T += M.rating
	res_max_amount = ((MATERIAL_AMOUNT_PER_SHEET * 50) + (T * (MATERIAL_AMOUNT_PER_SHEET * 100)))
	T = 0
	for(var/obj/item/stock_part/micro_laser/Ma in component_parts)
		T += Ma.rating
	if(T >= 1)
		T -= 1
	var/diff
	diff = round(initial(resource_coeff) - (initial(resource_coeff) * (T)) / 25, 0.01)
	if(resource_coeff != diff)
		resource_coeff = diff
	T = 0
	for(var/obj/item/stock_part/manipulator/Ml in component_parts)
		T += Ml.rating
	if(T >= 1)
		T -= 1
	diff = round(initial(time_coeff) - (initial(time_coeff) * (T)) / 25, 0.01)
	if(time_coeff != diff)
		time_coeff = diff

/obj/machinery/mecha_part_fabricator/Destroy()
	for(var/atom/A in src)
		qdel(A)
	return ..()

/obj/machinery/mecha_part_fabricator/proc/operation_allowed(mob/M)
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

/obj/machinery/mecha_part_fabricator/check_access(obj/item/card/id/I)
	if(istype(I, /obj/item/pda))
		var/obj/item/pda/pda = I
		I = pda.id
	if(!istype(I) || !I.access) //not ID or no access
		return 0
	for(var/req in req_access)
		if(!(req in I.access)) //doesn't have this access
			return 0
	return 1

/obj/machinery/mecha_part_fabricator/proc/emag()
	sleep()
	switch(emagged)
		if(0)
			emagged = 0.5
			visible_message("\icon[src] <b>[src]</b> beeps: \"DB error \[Code 0x00F1\]\"")
			sleep(10)
			visible_message("\icon[src] <b>[src]</b> beeps: \"Attempting auto-repair\"")
			sleep(15)
			visible_message("\icon[src] <b>[src]</b> beeps: \"User DB corrupted \[Code 0x00FA\]. Truncating data structure...\"")
			sleep(30)
			visible_message("\icon[src] <b>[src]</b> beeps: \"User DB truncated. Please contact your NanoTrasen system operator for future assistance.\"")
			req_access = null
			emagged = 1
		if(0.5)
			visible_message("\icon[src] <b>[src]</b> beeps: \"DB not responding \[Code 0x0003\]...\"")
		if(1)
			visible_message("\icon[src] <b>[src]</b> beeps: \"No records in User DB\"")

/obj/machinery/mecha_part_fabricator/proc/convert_part_set(set_name as text)
	var/list/parts = part_sets[set_name]
	if(istype(parts, /list))
		for(var/i = 1; i <= length(parts); i++)
			var/path = parts[i]
			var/part = new path(src)
			if(part)
				parts[i] = part
			//debug below
			if(!isitem(parts[i]))
				return 0

/obj/machinery/mecha_part_fabricator/proc/add_part_set(set_name as text, parts = null)
	if(set_name in part_sets)//attempt to create duplicate set
		return 0
	if(isnull(parts))
		part_sets[set_name] = list()
	else
		part_sets[set_name] = parts
	convert_part_set(set_name)
	return 1

/obj/machinery/mecha_part_fabricator/proc/add_part_to_set(set_name as text, part)
	if(!part)
		return 0
	add_part_set(set_name)//if no "set_name" set exists, create
	var/list/part_set = part_sets[set_name]
	var/atom/apart
	if(ispath(part))
		apart = new part(src)
	else
		apart = part
	if(!istype(apart))
		return 0
	for(var/obj/O in part_set)
		if(O.type == apart.type)
			qdel(apart)
			return 0
	part_set[++part_set.len] = apart
	return 1

/obj/machinery/mecha_part_fabricator/proc/remove_part_set(set_name as text)
	for(var/i = 1, i <= length(part_sets), i++)
		if(part_sets[i] == set_name)
			part_sets.Cut(i, ++i)

/*
	proc/sanity_check()
		for(var/p in resources)
			var/index = resources.Find(p)
			index = resources.Find(p, ++index)
			if(index) //duplicate resource
				to_world("Duplicate resource definition for [src](\ref[src])")
				return 0
		for(var/set_name in part_sets)
			var/index = part_sets.Find(set_name)
			index = part_sets.Find(set_name, ++index)
			if(index) //duplicate part set
				to_world("Duplicate part set definition for [src](\ref[src])")
				return 0
		return 1
*/
/*
	New()
		..()
		add_part_to_set("Test",list("result"="/obj/item/mecha_part/part/gygax_armour","time"=600,"metal"=75000,"diamond"=10000))
		add_part_to_set("Test",list("result"="/obj/item/mecha_part/part/ripley_left_arm","time"=200,"metal"=25000))
		remove_part_set("Gygax")
		return
*/

/obj/machinery/mecha_part_fabricator/proc/output_parts_list(set_name)
	var/output = ""
	var/list/part_set = listgetindex(part_sets, set_name)
	if(istype(part_set))
		for(var/obj/item/part in part_set)
			var/resources_available = check_resources(part)
			output += "<div class='part'>[output_part_info(part)]<br>\[[resources_available ? "<a href='byond://?src=\ref[src];part=\ref[part]'>Build</a> | " : null]<a href='byond://?src=\ref[src];add_to_queue=\ref[part]'>Add to queue</a>\]\[<a href='byond://?src=\ref[src];part_desc=\ref[part]'>?</a>\]</div>"
	return output

/obj/machinery/mecha_part_fabricator/proc/output_part_info(obj/item/part)
	var/output = "[part.name] (Cost: [output_part_cost(part)]) [get_construction_time_w_coeff(part) / 10]sec"
	return output

/obj/machinery/mecha_part_fabricator/proc/output_part_cost(obj/item/part)
	var/i = 0
	var/output
	if(part.vars.Find("construction_time") && part.vars.Find("construction_cost"))//The most efficient way to go about this. Not all objects have these vars, but if they don't then they CANNOT be made by the mech fab. Doing it this way reduces a major amount of typecasting and switches, while cutting down maintenece for them as well -Sieve
		for(var/path in part:construction_cost)//The check should ensure that anything without the var doesn't make it to this point
			if(path in stored_materials)
				var/decl/material/material = GET_DECL_INSTANCE(path)
				output += "[i ? " | " : null][get_resource_cost_w_coeff(part, path)] [material.name]"
				i++
		return output
	else
		return 0

/obj/machinery/mecha_part_fabricator/proc/output_available_resources()
	var/output
	for(var/material_path in stored_materials)
		var/decl/material/material = GET_DECL_INSTANCE(material_path)
		var/amount = min(res_max_amount, stored_materials[material_path])
		output += "<span class=\"res_name\">[material.name]: </span>[amount] cm&sup3;"
		if(amount > 0)
			output += "<span style='font-size:80%;'> - Remove \[<a href='byond://?src=\ref[src];remove_mat=1;material=[material_path]'>1</a>\] | \[<a href='byond://?src=\ref[src];remove_mat=10;material=[material_path]'>10</a>\] | \[<a href='byond://?src=\ref[src];remove_mat=[res_max_amount];material=[material_path]'>All</a>\]</span>"
		output += "<br/>"
	return output

/obj/machinery/mecha_part_fabricator/proc/remove_resources(obj/item/part)
//Be SURE to add any new equipment to this switch, but don't be suprised if it spits out children objects
	if(part.vars.Find("construction_time") && part.vars.Find("construction_cost"))
		for(var/resource in part:construction_cost)
			if(resource in stored_materials)
				stored_materials[resource] -= get_resource_cost_w_coeff(part, resource)

/obj/machinery/mecha_part_fabricator/proc/check_resources(obj/item/part)
//		if(istype(part, /obj/item/robot_parts) || istype(part, /obj/item/mecha_part) || istype(part,/obj/item/borg/upgrade))
//Be SURE to add any new equipment to this switch, but don't be suprised if it spits out children objects
	if(part.vars.Find("construction_time") && part.vars.Find("construction_cost"))
		for(var/resource in part:construction_cost)
			if(resource in stored_materials)
				if(stored_materials[resource] < get_resource_cost_w_coeff(part, resource))
					return 0
		return 1
	else
		return 0

/obj/machinery/mecha_part_fabricator/proc/build_part(obj/item/part)
	if(!part)
		return
	being_built = new part.type(src)
	desc = "It's building [being_built]."
	remove_resources(part)
	overlays += "fab-active"
	update_power_state(USE_POWER_ACTIVE)
	updateUsrDialog()
	sleep(get_construction_time_w_coeff(part))
	update_power_state(USE_POWER_IDLE)
	overlays -= "fab-active"
	desc = initial(desc)
	if(being_built)
		being_built.Move(get_step(src, SOUTH))
		visible_message("\icon[src] <b>[src]</b> beeps, \"The following has been completed: [being_built] is built\".")
		being_built = null
	updateUsrDialog()
	return 1

/obj/machinery/mecha_part_fabricator/proc/update_queue_on_page()
	send_byjax(usr, "mecha_fabricator.browser", "queue", list_queue())

/obj/machinery/mecha_part_fabricator/proc/add_part_set_to_queue(set_name)
	if(set_name in part_sets)
		var/list/part_set = part_sets[set_name]
		if(islist(part_set))
			for(var/obj/item/part in part_set)
				add_to_queue(part)

/obj/machinery/mecha_part_fabricator/proc/add_to_queue(part)
	if(!istype(queue))
		queue = list()
	if(part)
		queue[++queue.len] = part
	return length(queue)

/obj/machinery/mecha_part_fabricator/proc/remove_from_queue(index)
	if(!isnum(index) || !istype(queue) || (index < 1 || index > length(queue)))
		return 0
	queue.Cut(index, ++index)
	return 1

/obj/machinery/mecha_part_fabricator/proc/process_queue()
	var/obj/item/part = listgetindex(queue, 1)
	if(!part)
		remove_from_queue(1)
		if(length(queue))
			return process_queue()
		else
			return
	if(!part.vars.Find("construction_time") || !part.vars.Find("construction_cost"))//If it shouldn't be printed
		remove_from_queue(1)//Take it out of the quene
		return process_queue()//Then reprocess it
	temp = null
	while(part)
		if(stat & (NOPOWER | BROKEN))
			return 0
		if(!check_resources(part))
			visible_message("\icon[src] <b>[src]</b> beeps, \"Not enough resources. Queue processing stopped\".")
			temp = {"<font color='red'>Not enough resources to build next part.</font><br>
						<a href='byond://?src=\ref[src];process_queue=1'>Try again</a> | <a href='byond://?src=\ref[src];clear_temp=1'>Return</a><a>"}
			return 0
		remove_from_queue(1)
		build_part(part)
		part = listgetindex(queue, 1)
	visible_message("\icon[src] <b>[src]</b> beeps, \"Queue processing finished successfully\".")
	return 1

/obj/machinery/mecha_part_fabricator/proc/list_queue()
	var/output = "<b>Queue contains:</b>"
	if(!length(queue))
		output += "<br>Nothing"
	else
		output += "<ol>"
		for(var/i = 1; i <= length(queue); i++)
			var/obj/item/part = listgetindex(queue, i)
			if(istype(part))
				if(part.vars.Find("construction_time") && part.vars.Find("construction_cost"))
					output += "<li[!check_resources(part) ? " style='color: #f00;'" : null]>[part.name] - [i > 1 ? "<a href='byond://?src=\ref[src];queue_move=-1;index=[i]' class='arrow'>&uarr;</a>" : null] [i < length(queue) ? "<a href='byond://?src=\ref[src];queue_move=+1;index=[i]' class='arrow'>&darr;</a>" : null] <a href='byond://?src=\ref[src];remove_from_queue=[i]'>Remove</a></li>"
				else//Prevents junk items from even appearing in the list, and they will be silently removed when the fab processes
					remove_from_queue(i)//Trash it
					return list_queue()//Rebuild it
		output += "</ol>"
		output += "\[<a href='byond://?src=\ref[src];process_queue=1'>Process queue</a> | <a href='byond://?src=\ref[src];clear_queue=1'>Clear queue</a>\]"
	return output

/obj/machinery/mecha_part_fabricator/proc/convert_designs()
	if(!files)
		return
	var/i = 0
	for(var/datum/design/D in files.known_designs)
		if(D.build_type & 16)
			if(D.category in part_sets)//Checks if it's a valid category
				if(add_part_to_set(D.category, D.build_path))//Adds it to said category
					i++
			else
				if(add_part_to_set("Misc", D.build_path))//If in doubt, chunk it into the Misc
					i++
	return i

/obj/machinery/mecha_part_fabricator/proc/update_tech()
	if(!files)
		return
	var/output
	for(var/datum/tech/T in files.known_tech)
		if(T?.level > 1)
			var/diff
			switch(T.type) //bad, bad formulas
				if(/datum/tech/materials)
					var/pmat = 0//Calculations to make up for the fact that these parts and tech modify the same thing
					for(var/obj/item/stock_part/micro_laser/Ml in component_parts)
						pmat += Ml.rating
					if(pmat >= 1)
						pmat -= 1//So the equations don't have to be reworked, upgrading a single part from T1 to T2 is == to 1 tech level
					diff = round(initial(resource_coeff) - (initial(resource_coeff) * (T.level + pmat)) / 25, 0.01)
					if(resource_coeff != diff)
						resource_coeff = diff
						output += "Production efficiency increased.<br>"
				if(/datum/tech/programming)
					var/ptime = 0
					for(var/obj/item/stock_part/manipulator/Ma in component_parts)
						ptime += Ma.rating
					if(ptime >= 2)
						ptime -= 2
					diff = round(initial(time_coeff) - (initial(time_coeff) * (T.level + ptime)) / 25, 0.1)
					if(time_coeff != diff)
						time_coeff = diff
						output += "Production routines updated.<br>"
	return output

/obj/machinery/mecha_part_fabricator/proc/sync(silent = null)
/*		if(length(queue))
			if(!silent)
				temp = "Error.  Please clear processing queue before updating!"
				updateUsrDialog()
			return
*/
	if(!silent)
		temp = "Updating local R&D database..."
		updateUsrDialog()
		sleep(30) //only sleep if called by user
	var/found = 0
	for(var/obj/machinery/computer/rdconsole/RDC in get_area(src))
		if(!RDC.sync)
			continue
		found++
		for(var/datum/tech/T in RDC.files.known_tech)
			files.AddTech2Known(T)
		for(var/datum/design/D in RDC.files.known_designs)
			files.AddDesign2Known(D)
		files.RefreshResearch()
		var/i = convert_designs()
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

/obj/machinery/mecha_part_fabricator/proc/get_resource_cost_w_coeff(obj/item/part, resource, roundto = 1)
//Be SURE to add any new equipment to this switch, but don't be suprised if it spits out children objects
	if(part.vars.Find("construction_time") && part.vars.Find("construction_cost"))
		return round(part:construction_cost[resource] * resource_coeff, roundto)
	else
		return 0

/obj/machinery/mecha_part_fabricator/proc/get_construction_time_w_coeff(obj/item/part, roundto = 1)
//Be SURE to add any new equipment to this switch, but don't be suprised if it spits out children objects
	if(part.vars.Find("construction_time") && part.vars.Find("construction_cost"))
		return round(part:construction_time * time_coeff, roundto)
	else
		return 0

/obj/machinery/mecha_part_fabricator/attack_hand(mob/user)
	var/dat, left_part
	if (..())
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
		left_part = {"<TT>Building [being_built.name].<BR>
							Please wait until completion...</TT>"}
	else
		switch(screen)
			if("main")
				left_part = output_available_resources()+"<hr>"
				left_part += "<a href='byond://?src=\ref[src];sync=1'>Sync with R&D servers</a><hr>"
				for(var/part_set in part_sets)
					left_part += "<a href='byond://?src=\ref[src];part_set=[part_set]'>[part_set]</a> - \[<a href='byond://?src=\ref[src];partset_to_queue=[part_set]'>Add all parts to queue\]<br>"
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
	user << browse(dat, "window=mecha_fabricator;size=1000x400")
	onclose(user, "mecha_fabricator")

/obj/machinery/mecha_part_fabricator/Topic(href, href_list)
	..()
	var/datum/topic_input/new_filter = new /datum/topic_input(href, href_list)
	if(href_list["part_set"])
		var/tpart_set = new_filter.getStr("part_set")
		if(tpart_set)
			if(tpart_set == "clear")
				part_set = null
			else
				part_set = tpart_set
				screen = "parts"
	if(href_list["part"])
		var/list/part = new_filter.getObj("part")
		if(!processing_queue)
			build_part(part)
		else
			add_to_queue(part)
	if(href_list["add_to_queue"])
		add_to_queue(new_filter.getObj("add_to_queue"))
		return update_queue_on_page()
	if(href_list["remove_from_queue"])
		remove_from_queue(new_filter.getNum("remove_from_queue"))
		return update_queue_on_page()
	if(href_list["partset_to_queue"])
		add_part_set_to_queue(new_filter.get("partset_to_queue"))
		return update_queue_on_page()
	if(href_list["process_queue"])
		spawn(-1)
			if(processing_queue || being_built)
				return
			processing_queue = 1
			process_queue()
			processing_queue = 0
/*
		if(href_list["list_queue"])
			list_queue()
*/
	if(href_list["clear_temp"])
		temp = null
	if(href_list["screen"])
		screen = href_list["screen"]
	if(href_list["queue_move"] && href_list["index"])
		var/index = new_filter.getNum("index")
		var/new_index = index + new_filter.getNum("queue_move")
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
		var/obj/part = new_filter.getObj("part_desc")
		if(part)
			temp = {"<h1>[part] description:</h1>
						[part.desc]<br>
						<a href='byond://?src=\ref[src];clear_temp=1'>Return</a>
						"}
	if(href_list["remove_mat"] && href_list["material"])
		temp = "Ejected [remove_material(text2path(href_list["material"]),text2num(href_list["remove_mat"]))] of [href_list["material"]]<br><a href='byond://?src=\ref[src];clear_temp=1'>Return</a>"
	updateUsrDialog()

/obj/machinery/mecha_part_fabricator/proc/remove_material(type, amount)
	var/decl/material/material = GET_DECL_INSTANCE(type)
	if(isnull(material.sheet_path))
		return 0
	var/result = 0
	var/obj/item/stack/sheet/res = new material.sheet_path(src)
	var/total_amount = round(stored_materials[type] / res.perunit)
	res.amount = min(total_amount, amount)
	if(res.amount > 0)
		stored_materials[type] -= res.amount * res.perunit
		res.Move(loc)
		result = res.amount
	else
		qdel(res)
	return result

/obj/machinery/mecha_part_fabricator/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(emagged > 0)
		FEEDBACK_ALREADY_EMAGGED(user)
		return FALSE

	emag()
	return TRUE

/obj/machinery/mecha_part_fabricator/attackby(obj/W, mob/user)
	if(istype(W, /obj/item/screwdriver))
		if(!opened)
			opened = TRUE
			icon_state = "fab-o"
		else
			opened = FALSE
			icon_state = "fab-idle"
		playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
		FEEDBACK_TOGGLE_MAINTENANCE_PANEL(user, opened)
		return

	if(opened)
		if(istype(W, /obj/item/crowbar))
			playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
			var/obj/machinery/constructable_frame/machine_frame/M = new /obj/machinery/constructable_frame/machine_frame(loc)
			M.state = 2
			M.icon_state = "box_1"
			for(var/obj/I in component_parts)
				if(I.reliability != 100 && crit_fail)
					I.crit_fail = 1
				I.loc = loc
			for(var/material_path in stored_materials)
				var/decl/material/material = GET_DECL_INSTANCE(material_path)
				if(stored_materials[material_path] >= material.per_unit)
					new material.sheet_path(loc, round(stored_materials[material_path] / material.per_unit))
			qdel(src)
			return 1
		else
			to_chat(user, SPAN_WARNING("You can't load the [name] while it's opened."))
			return 1

	if(!istype(W, /obj/item/stack/sheet))
		return
	var/obj/item/stack/sheet/stack = W
	if(isnull(stack.material))
		return ..()
	if(being_built)
		to_chat(user, SPAN_WARNING("The fabricator is currently processing. Please wait until completion."))
		return

	if(stored_materials[stack.material.type] < res_max_amount)
		var/count = 0
		//loading animation is now an overlay based on material type. No more spontaneous conversion of all ores to metal. -vey
		overlays.Add("fab-load-[lowertext(stack.material.name)]")
		if(do_after(user, 10))
			if(stack && stack.amount)
				while(stored_materials[stack.material.type] < res_max_amount && stack)
					stored_materials[stack.material.type] += stack.perunit
					stack.use(1)
					count++
				overlays.Remove("fab-load-[lowertext(stack.material.name)]")
				to_chat(user, SPAN_INFO("You insert [count] [stack.name] into the fabricator."))
				updateUsrDialog()
		else
			to_chat(user, SPAN_WARNING("You fail to insert the [stack.name] into the fabricator."))
	else
		to_chat(user, SPAN_WARNING("The fabricator cannot hold more [stack.name]."))