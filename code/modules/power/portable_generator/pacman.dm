/obj/machinery/power/port_gen/pacman
	name = "\improper P.A.C.M.A.N.-type portable generator"

	var/sheets = 0
	var/max_sheets = 100
	var/sheet_left = 0 // How much is left of the sheet

	var/board_path = /obj/item/circuitboard/pacman
	var/decl/material/fuel_material = /decl/material/plasma
	var/time_per_sheet = 40
	var/heat = 0

/obj/machinery/power/port_gen/pacman/initialise()
	. = ..()
	if(isnotnull(fuel_material))
		fuel_material = GET_DECL_INSTANCE(fuel_material)
	if(anchored)
		connect_to_network()

/obj/machinery/power/port_gen/pacman/Destroy()
	drop_fuel()
	return ..()

/obj/machinery/power/port_gen/pacman/add_parts()
	component_parts = list(
		new /obj/item/stock_part/matter_bin(src),
		new /obj/item/stock_part/micro_laser(src),
		new /obj/item/stack/cable_coil(src),
		new /obj/item/stack/cable_coil(src),
		new /obj/item/stock_part/capacitor(src),
		new board_path(src)
	)
	return TRUE

/obj/machinery/power/port_gen/pacman/refresh_parts()
	var/temp_rating = 0
	var/temp_reliability = 0
	for(var/obj/item/stock_part/part in component_parts)
		if(istype(part, /obj/item/stock_part/matter_bin))
			max_sheets = part.rating * part.rating * 50
		else if(istype(part, /obj/item/stock_part/micro_laser) || istype(part, /obj/item/stock_part/capacitor))
			temp_rating += part.rating
	for_no_type_check(var/obj/item/part, component_parts)
		temp_reliability += part.reliability
	reliability = min(round(temp_reliability / 4), 100)
	power_gen = round(initial(power_gen) * (max(2, temp_rating) / 2))

/obj/machinery/power/port_gen/pacman/examine()
	..()
	to_chat(usr, SPAN_INFO("The generator has [sheets] units of [lowertext(fuel_material.name)] fuel left, producing [power_gen] per cycle."))
	if(crit_fail)
		to_chat(usr, SPAN_WARNING("The generator seems to have broken down."))

/obj/machinery/power/port_gen/pacman/has_fuel()
	if(sheets >= 1 / (time_per_sheet / power_output) - sheet_left)
		return TRUE
	return FALSE

/obj/machinery/power/port_gen/pacman/drop_fuel()
	if(sheets)
		var/fail_safe = 0
		while(sheets > 0 && fail_safe < 100)
			fail_safe += 1
			var/obj/item/stack/sheet/S = new fuel_material.sheet_path(loc)
			var/amount = min(sheets, S.max_amount)
			S.amount = amount
			sheets -= amount

/obj/machinery/power/port_gen/pacman/use_fuel()
	var/needed_sheets = 1 / (time_per_sheet / power_output)
	var/temp = min(needed_sheets, sheet_left)
	needed_sheets -= temp
	sheet_left -= temp
	sheets -= round(needed_sheets)
	needed_sheets -= round(needed_sheets)
	if(sheet_left <= 0 && sheets > 0)
		sheet_left = 1 - needed_sheets
		sheets--

	var/lower_limit = 56 + power_output * 10
	var/upper_limit = 76 + power_output * 10
	var/bias = 0
	if(power_output > 4)
		upper_limit = 400
		bias = power_output * 3
	if(heat < lower_limit)
		heat += 3
	else
		heat += rand(-7 + bias, 7 + bias)
		if(heat < lower_limit)
			heat = lower_limit
		if(heat > upper_limit)
			heat = upper_limit

	if(heat > 300)
		overheat()
		qdel(src)

/obj/machinery/power/port_gen/pacman/handle_inactive()
	if(heat > 0)
		heat = max(heat - 2, 0)
		updateDialog()

/obj/machinery/power/port_gen/pacman/proc/overheat()
	explosion(loc, 2, 5, 2, -1)

/obj/machinery/power/port_gen/pacman/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(emagged)
		return FALSE
	emagged = TRUE
	emp_act(1)
	return TRUE

/obj/machinery/power/port_gen/pacman/attack_tool(obj/item/tool, mob/user)
	if(active)
		return ..()

	if(iswrench(tool))
		anchored = !anchored
		if(anchored)
			connect_to_network()
		else
			disconnect_from_network()
		user.visible_message(
			SPAN_NOTICE("[user] [anchored ? "secure" : "unsecure"]s \the [src] [anchored ? "to" : "from"] the floor."),
			SPAN_NOTICE("You [anchored ? "secure" : "unsecure"] \the [src] [anchored ? "to" : "from"] the floor."),
			SPAN_INFO("You hear a ratchet.")
		)
		playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
		return TRUE

	if(isscrewdriver(tool))
		open = !open
		user.visible_message(
			SPAN_NOTICE("[user] [open ? "open" : "close"]s \the [src]'s access panel."),
			SPAN_NOTICE("You [open ? "open" : "close"] \the [src]'s access panel."),
			SPAN_INFO("You hear someone using a screwdriver.")
		)
		playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
		return TRUE

	if(iscrowbar(tool) && open)
		var/obj/machinery/constructable_frame/machine_frame/new_frame = new /obj/machinery/constructable_frame/machine_frame(loc)
		for_no_type_check(var/obj/item/part, component_parts)
			if(part.reliability < 100)
				part.crit_fail = TRUE
			part.forceMove(loc)
		while(sheets > 0)
			var/obj/item/stack/sheet/G = new fuel_material.sheet_path(loc)
			if(sheets > 50)
				G.amount = 50
			else
				G.amount = sheets
			sheets -= G.amount

		new_frame.state = 2
		new_frame.icon_state = "box_1"
		qdel(src)
		return TRUE

	return ..()

/obj/machinery/power/port_gen/pacman/attack_by(obj/item/I, mob/user)
	if(istype(I, fuel_material.sheet_path))
		var/obj/item/stack/addstack = I
		var/amount = min((max_sheets - sheets), addstack.amount)
		if(amount < 1)
			to_chat(user, SPAN_WARNING("\The [src] is full!"))
			return
		to_chat(user, SPAN_INFO("You add [amount] sheet\s to \the [src]."))
		sheets += amount
		addstack.use(amount)
		updateUsrDialog()
		return TRUE

	return ..()

/obj/machinery/power/port_gen/pacman/attack_hand(mob/user)
	. = ..()
	if(.)
		return TRUE
	user.set_machine(src)
	ui_interact(user)

/obj/machinery/power/port_gen/pacman/attack_ai(mob/user)
	user.set_machine(src)
	ui_interact(user)

/obj/machinery/power/port_gen/pacman/attack_paw(mob/user)
	user.set_machine(src)
	ui_interact(user)

// Commented this out due to NanoUI port. -Frenjo
/*/obj/machinery/power/port_gen/pacman/interact(mob/user)
	if(!in_range(src, user))
		if(!isAI(user))
			user.unset_machine()
			user << browse(null, "window=port_gen")
			return

	user.set_machine(src)

	var/dat = text("<b>[name]</b><br>")
	if (active)
		dat += text("Generator: <A href='byond://?src=\ref[src];action=disable'>On</A><br>")
	else
		dat += text("Generator: <A href='byond://?src=\ref[src];action=enable'>Off</A><br>")
	dat += text("[capitalize(sheet_name)]: [sheets] - <A href='byond://?src=\ref[src];action=eject'>Eject</A><br>")
	var/stack_percent = round(sheet_left * 100, 1)
	dat += text("Current stack: [stack_percent]% <br>")
	dat += text("Power output: <A href='byond://?src=\ref[src];action=lower_power'>-</A> [power_gen * power_output] <A href='byond://?src=\ref[src];action=higher_power'>+</A><br>")
	dat += text("Power current: [(powernet == null ? "Unconnected" : "[avail()]")]<br>")
	dat += text("Heat: [heat]<br>")
	dat += "<br><A href='byond://?src=\ref[src];action=close'>Close</A>"
	user << browse("[dat]", "window=port_gen")
	onclose(user, "port_gen")*/

// Porting this to NanoUI, it looks way better honestly. -Frenjo
/obj/machinery/power/port_gen/pacman/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null)
	if(stat & BROKEN)
		return

	var/alist/data = alist(
		"active" = active,
		"power_gen" = power_gen,
		"power_output" = power_output,
		"fuel_type" = fuel_material.name,
		"sheets" = sheets,
		"fuel_percent" = round(sheet_left * 100, 1),
		"max_sheets" = max_sheets,
		"heat_level" = heat
	)

	// Ported most of this by studying SMES code. -Frenjo
	ui = global.PCnanoui.try_update_ui(user, src, ui_key, ui, data)
	if(isnull(ui))
		ui = new /datum/nanoui(user, src, ui_key, "port_gen.tmpl", name, 540, 460)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update()

/obj/machinery/power/port_gen/pacman/Topic(href, href_list)
	if(..())
		return

	add_fingerprint(usr)
	if(href_list["action"])
		if(href_list["action"] == "enable")
			if(!active && has_fuel() && !crit_fail)
				active = 1
				icon_state = "portgen1"
		if(href_list["action"] == "disable")
			if(active)
				active = 0
				icon_state = "portgen0"
		if(href_list["action"] == "eject")
			if(!active)
				drop_fuel()
		if(href_list["action"] == "lower_power")
			if(power_output > 0) // Edited this so you can 'indirectly' switch it off. -Frenjo
				power_output--
		if(href_list["action"] == "higher_power")
			if(power_output < 4 || emagged)
				power_output++
	updateUsrDialog()

/obj/machinery/power/port_gen/pacman/super
	name = "\improper S.U.P.E.R.P.A.C.M.A.N.-type portable generator"
	icon_state = "portgen1"

	power_gen = 15000

	board_path = /obj/item/circuitboard/pacman/super
	fuel_material = /decl/material/uranium
	time_per_sheet = 65

/obj/machinery/power/port_gen/pacman/super/overheat()
	explosion(loc, 3, 3, 3, -1)

/obj/machinery/power/port_gen/pacman/mrs
	name = "\improper M.R.S.P.A.C.M.A.N.-type portable generator"
	icon_state = "portgen2"

	power_gen = 40000

	board_path = /obj/item/circuitboard/pacman/mrs
	fuel_material = /decl/material/diamond
	time_per_sheet = 80

/obj/machinery/power/port_gen/pacman/mrs/overheat()
	explosion(loc, 4, 4, 4, -1)