/*
 * Mineral Stacking Unit Console
 */
/obj/machinery/stacking_unit_console
	name = "stacking machine console"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "console"
	density = TRUE
	anchored = TRUE

	var/obj/machinery/stacking_machine/machine = null
	var/machinedir = SOUTHEAST

/obj/machinery/stacking_unit_console/initialise()
	. = ..()
	machine = locate(/obj/machinery/stacking_machine, get_step(src, machinedir))
	if(isnotnull(machine))
		machine.console = src
	else
		qdel(src)

/obj/machinery/stacking_unit_console/process()
	updateDialog()

/obj/machinery/stacking_unit_console/attack_hand(mob/user)
	add_fingerprint(user)
	interact(user)

#define ADD_MATERIAL(NAME, STACK) \
if(machine.stack_amounts[STACK]) html += "[NAME]: [machine.stack_amounts[STACK]] (<A href='byond://?src=\ref[src];release=[STACK]'>Release</A>)<br>"
/obj/machinery/stacking_unit_console/interact(mob/user)
	user.set_machine(src)

	var/html = "<b>Stacking Unit Console</b><br><br>"

	ADD_MATERIAL("Iron", /obj/item/stack/sheet/iron)
	ADD_MATERIAL("Steel", /obj/item/stack/sheet/steel)
	ADD_MATERIAL("Plasteel", /obj/item/stack/sheet/plasteel)
	ADD_MATERIAL("Gold", /obj/item/stack/sheet/gold)
	ADD_MATERIAL("Silver", /obj/item/stack/sheet/silver)
	ADD_MATERIAL("Diamond", /obj/item/stack/sheet/diamond)
	ADD_MATERIAL("Plasma", /obj/item/stack/sheet/plasma)
	ADD_MATERIAL("Uranium", /obj/item/stack/sheet/uranium)
	ADD_MATERIAL("Bananium", /obj/item/stack/sheet/bananium)
	ADD_MATERIAL("Tranquilite", /obj/item/stack/sheet/tranquilite)
	ADD_MATERIAL("Adamantine", /obj/item/stack/sheet/adamantine)
	ADD_MATERIAL("Mythril", /obj/item/stack/sheet/mythril)

	ADD_MATERIAL("Glass", /obj/item/stack/sheet/glass)
	ADD_MATERIAL("Reinforced Glass", /obj/item/stack/sheet/glass/reinforced)
	ADD_MATERIAL("Plasma Glass", /obj/item/stack/sheet/glass/plasma)
	ADD_MATERIAL("Reinforced Plasma Glass", /obj/item/stack/sheet/glass/plasma/reinforced)

	ADD_MATERIAL("Wood", /obj/item/stack/sheet/wood)
	ADD_MATERIAL("Cardboard", /obj/item/stack/sheet/cardboard)
	ADD_MATERIAL("Cloth", /obj/item/stack/sheet/cloth)
	ADD_MATERIAL("Leather", /obj/item/stack/sheet/leather)

	html += "<br>Stacking: [machine.max_stack_amount]<br><br>"

	SHOW_BROWSER(user, html, "window=console_stacking_machine")
	onclose(user, "console_stacking_machine")
#undef ADD_MATERIAL

/obj/machinery/stacking_unit_console/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)
	if(href_list["release"])
		var/stack_path = text2path(href_list["release"])
		if(!(stack_path in machine.stack_amounts))
			return
		var/amount = machine.stack_amounts[stack_path]
		if(amount > 0)
			new stack_path(machine.output_turf, amount)
			machine.stack_amounts[stack_path] = 0
	updateUsrDialog()

/*
 * Mineral Stacking Unit
 */
/obj/machinery/stacking_machine
	name = "stacking machine"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "stacker"
	density = TRUE
	anchored = TRUE

	var/obj/machinery/stacking_unit_console/console
	var/turf/input_turf = null
	var/turf/output_turf = null
	var/list/stack_amounts = list(
		/obj/item/stack/sheet/iron = 0,
		/obj/item/stack/sheet/steel = 0,
		/obj/item/stack/sheet/plasteel = 0,
		/obj/item/stack/sheet/gold = 0,
		/obj/item/stack/sheet/silver = 0,
		/obj/item/stack/sheet/diamond = 0,
		/obj/item/stack/sheet/plasma = 0,
		/obj/item/stack/sheet/uranium = 0,
		/obj/item/stack/sheet/bananium = 0,
		/obj/item/stack/sheet/tranquilite = 0,
		/obj/item/stack/sheet/adamantine = 0,
		/obj/item/stack/sheet/mythril = 0,

		/obj/item/stack/sheet/glass = 0,
		/obj/item/stack/sheet/glass/reinforced = 0,
		/obj/item/stack/sheet/glass/plasma = 0,
		/obj/item/stack/sheet/glass/plasma/reinforced = 0,

		/obj/item/stack/sheet/wood = 0,
		/obj/item/stack/sheet/cardboard = 0,
		/obj/item/stack/sheet/cloth = 0,
		/obj/item/stack/sheet/leather = 0
	)
	var/max_stack_amount = 50	//ammount to stack before releassing

/obj/machinery/stacking_machine/initialise()
	. = ..()
	for(var/dir in GLOBL.cardinal)
		var/obj/machinery/input_plate/in_plate = locate(/obj/machinery/input_plate, get_step(src, dir))
		if(isnotnull(in_plate))
			input_turf = GET_TURF(in_plate)
			break
	for(var/dir in GLOBL.cardinal)
		var/obj/machinery/output_plate/out_plate = locate(/obj/machinery/output_plate, get_step(src, dir))
		if(isnotnull(out_plate))
			output_turf = GET_TURF(out_plate)
			break
	START_PROCESSING(PCobj, src)

/obj/machinery/stacking_machine/Destroy()
	STOP_PROCESSING(PCobj, src)
	return ..()

/obj/machinery/stacking_machine/process()
	if(isnotnull(input_turf) && isnotnull(output_turf))
		var/obj/item/stack/O
		while(locate(/obj/item, input_turf))
			O = locate(/obj/item/stack, input_turf)
			if(isnull(O))
				var/obj/item/I = locate(/obj/item, input_turf)
				if(istype(I, /obj/item/ore/slag))
					I.forceMove(null)
				else
					I.forceMove(output_turf)
				continue
			if(O.type in stack_amounts)
				stack_amounts[O.type] += O.amount
				O.forceMove(null)
				qdel(O)
				continue
			O.forceMove(output_turf)

	for(var/stack_type in stack_amounts)
		var/amount = stack_amounts[stack_type]
		if(amount >= max_stack_amount)
			new stack_type(output_turf, max_stack_amount)
			stack_amounts[stack_type] -= max_stack_amount
			break