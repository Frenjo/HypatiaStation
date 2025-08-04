#define ORE_PROC_IRON BITFLAG(0)
#define ORE_PROC_COAL BITFLAG(1)
#define ORE_PROC_GLASS BITFLAG(2)
#define ORE_PROC_SILVER BITFLAG(3)
#define ORE_PROC_GOLD BITFLAG(4)
#define ORE_PROC_DIAMOND BITFLAG(5)
#define ORE_PROC_URANIUM BITFLAG(6)
#define ORE_PROC_PLASMA BITFLAG(7)
#define ORE_PROC_BANANIUM BITFLAG(8)
#define ORE_PROC_TRANQUILITE BITFLAG(9)

/*
 * Mineral Processing Unit Console
 */
/obj/machinery/mineral/processing_unit_console
	name = "production machine console"
	icon_state = "console"

	var/obj/machinery/mineral/processing_unit/machine = null
	var/machinedir = EAST

/obj/machinery/mineral/processing_unit_console/initialise()
	. = ..()
	machine = locate(/obj/machinery/mineral/processing_unit, get_step(src, machinedir))
	if(isnotnull(machine))
		machine.console = src
	else
		qdel(src)

/obj/machinery/mineral/processing_unit_console/process()
	updateDialog()

/obj/machinery/mineral/processing_unit_console/attack_hand(mob/user)
	add_fingerprint(user)
	interact(user)

/obj/machinery/mineral/processing_unit_console/interact(mob/user)
	user.set_machine(src)

	var/html = "<b>Smelter Control Console</b><br><br>"
	var/has_materials = FALSE

	//iron
	if(machine.ore_amounts[/obj/item/ore/iron])
		html += "Iron: [machine.ore_amounts[/obj/item/ore/iron]] "
		if(machine.selected & ORE_PROC_IRON)
			html += "(<A href='byond://?src=\ref[src];sel_iron=no'><font color='green'>Smelting</font></A>)"
		else
			html += "(<A href='byond://?src=\ref[src];sel_iron=yes'><font color='red'>Not Smelting</font></A>)"
		html += "<br>"
		has_materials = TRUE
	else
		machine.selected &= ~ORE_PROC_IRON

	// Coal/Carbon
	if(machine.ore_amounts[/obj/item/ore/coal])
		html += "Coal: [machine.ore_amounts[/obj/item/ore/coal]] "
		if(machine.selected & ORE_PROC_COAL)
			html += "(<A href='byond://?src=\ref[src];sel_coal=no'><font color='green'>Alloying</font></A>)"
		else
			html += "(<A href='byond://?src=\ref[src];sel_coal=yes'><font color='red'>Not Alloying</font></A>)"
		html += "<br>"
		has_materials = TRUE
	else
		machine.selected &= ~ORE_PROC_COAL

	//sand - glass
	if(machine.ore_amounts[/obj/item/ore/glass])
		html += "Sand: [machine.ore_amounts[/obj/item/ore/glass]] "
		if(machine.selected & ORE_PROC_GLASS)
			html += "(<A href='byond://?src=\ref[src];sel_glass=no'><font color='green'>Smelting</font></A>)"
		else
			html += "(<A href='byond://?src=\ref[src];sel_glass=yes'><font color='red'>Not Smelting</font></A>)"
		html += "<br>"
		has_materials = TRUE
	else
		machine.selected &= ~ORE_PROC_GLASS

	//silver
	if(machine.ore_amounts[/obj/item/ore/silver])
		html += "Silver: [machine.ore_amounts[/obj/item/ore/silver]] "
		if(machine.selected & ORE_PROC_SILVER)
			html += "(<A href='byond://?src=\ref[src];sel_silver=no'><font color='green'>Smelting</font></A>)"
		else
			html += "(<A href='byond://?src=\ref[src];sel_silver=yes'><font color='red'>Not Smelting</font></A>)"
		html += "<br>"
		has_materials = TRUE
	else
		machine.selected &= ~ORE_PROC_SILVER

	//gold
	if(machine.ore_amounts[/obj/item/ore/gold])
		html += "Gold: [machine.ore_amounts[/obj/item/ore/gold]] "
		if(machine.selected & ORE_PROC_GOLD)
			html += "(<A href='byond://?src=\ref[src];sel_gold=no'><font color='green'>Smelting</font></A>)"
		else
			html += "(<A href='byond://?src=\ref[src];sel_gold=yes'><font color='red'>Not Smelting</font></A>)"
		html += "<br>"
		has_materials = TRUE
	else
		machine.selected &= ~ORE_PROC_GOLD

	//diamond
	if(machine.ore_amounts[/obj/item/ore/diamond])
		html += "Diamond: [machine.ore_amounts[/obj/item/ore/diamond]] "
		if(machine.selected & ORE_PROC_DIAMOND)
			html += "(<A href='byond://?src=\ref[src];sel_diamond=no'><font color='green'>Smelting</font></A>)"
		else
			html += "(<A href='byond://?src=\ref[src];sel_diamond=yes'><font color='red'>Not Smelting</font></A>)"
		html += "<br>"
		has_materials = TRUE
	else
		machine.selected &= ~ORE_PROC_DIAMOND

	//uranium
	if(machine.ore_amounts[/obj/item/ore/uranium])
		html += "Uranium: [machine.ore_amounts[/obj/item/ore/uranium]] "
		if(machine.selected & ORE_PROC_URANIUM)
			html += "(<A href='byond://?src=\ref[src];sel_uranium=no'><font color='green'>Smelting</font></A>)"
		else
			html += "(<A href='byond://?src=\ref[src];sel_uranium=yes'><font color='red'>Not Smelting</font></A>)"
		html += "<br>"
		has_materials = TRUE
	else
		machine.selected &= ~ORE_PROC_URANIUM

	//plasma
	if(machine.ore_amounts[/obj/item/ore/plasma])
		html += "Plasma: [machine.ore_amounts[/obj/item/ore/plasma]] "
		if(machine.selected & ORE_PROC_PLASMA)
			html += "(<A href='byond://?src=\ref[src];sel_plasma=no'><font color='green'>Smelting</font></A>)"
		else
			html += "(<A href='byond://?src=\ref[src];sel_plasma=yes'><font color='red'>Not Smelting</font></A>)"
		html += "<br>"
		has_materials = TRUE
	else
		machine.selected &= ~ORE_PROC_PLASMA

	//bananium
	if(machine.ore_amounts[/obj/item/ore/bananium])
		html += "Bananium: [machine.ore_amounts[/obj/item/ore/bananium]] "
		if(machine.selected & ORE_PROC_BANANIUM)
			html += "(<A href='byond://?src=\ref[src];sel_bananium=no'><font color='green'>Smelting</font></A>)"
		else
			html += "(<A href='byond://?src=\ref[src];sel_bananium=yes'><font color='red'>Not Smelting</font></A>)"
		html += "<br>"
		has_materials = TRUE
	else
		machine.selected &= ~ORE_PROC_BANANIUM

	// Tranquilite
	if(machine.ore_amounts[/obj/item/ore/tranquilite])
		html += "Tranquilite: [machine.ore_amounts[/obj/item/ore/tranquilite]] "
		if(machine.selected & ORE_PROC_TRANQUILITE)
			html += "(<A href='byond://?src=\ref[src];sel_tranquilite=no'><font color='green'>Smelting</font></A>)"
		else
			html += "(<A href='byond://?src=\ref[src];sel_tranquilite=yes'><font color='red'>Not Smelting</font></A>)"
		html += "<br>"
		has_materials = TRUE
	else
		machine.selected &= ~ORE_PROC_TRANQUILITE

	if(has_materials)
		// On or off.
		html += "<br>Machine is currently: "
		if(machine.on)
			html += "<A href='byond://?src=\ref[src];set_on=off'>On</A>"
		else
			html += "<A href='byond://?src=\ref[src];set_on=on'>Off</A>"
	else
		html += "---No Materials Loaded---"

	SHOW_BROWSER(user, html, "window=console_processing_unit")
	onclose(user, "console_processing_unit")

/obj/machinery/mineral/processing_unit_console/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)
	if(href_list["sel_iron"])
		if(href_list["sel_iron"] == "yes")
			machine.selected |= ORE_PROC_IRON
		else
			machine.selected &= ~ORE_PROC_IRON
	if(href_list["sel_coal"])
		if(href_list["sel_coal"] == "yes")
			machine.selected |= ORE_PROC_COAL
		else
			machine.selected &= ~ORE_PROC_COAL
	if(href_list["sel_glass"])
		if(href_list["sel_glass"] == "yes")
			machine.selected |= ORE_PROC_GLASS
		else
			machine.selected &= ~ORE_PROC_GLASS
	if(href_list["sel_silver"])
		if(href_list["sel_silver"] == "yes")
			machine.selected |= ORE_PROC_SILVER
		else
			machine.selected &= ~ORE_PROC_SILVER
	if(href_list["sel_gold"])
		if(href_list["sel_gold"] == "yes")
			machine.selected |= ORE_PROC_GOLD
		else
			machine.selected &= ~ORE_PROC_GOLD
	if(href_list["sel_diamond"])
		if(href_list["sel_diamond"] == "yes")
			machine.selected |= ORE_PROC_DIAMOND
		else
			machine.selected &= ~ORE_PROC_DIAMOND
	if(href_list["sel_uranium"])
		if(href_list["sel_uranium"] == "yes")
			machine.selected |= ORE_PROC_URANIUM
		else
			machine.selected &= ~ORE_PROC_URANIUM
	if(href_list["sel_plasma"])
		if(href_list["sel_plasma"] == "yes")
			machine.selected |= ORE_PROC_PLASMA
		else
			machine.selected &= ~ORE_PROC_PLASMA
	if(href_list["sel_bananium"])
		if(href_list["sel_bananium"] == "yes")
			machine.selected |= ORE_PROC_BANANIUM
		else
			machine.selected &= ~ORE_PROC_BANANIUM
	if(href_list["sel_tranquilite"])
		if(href_list["sel_tranquilite"] == "yes")
			machine.selected |= ORE_PROC_TRANQUILITE
		else
			machine.selected &= ~ORE_PROC_TRANQUILITE

	if(href_list["set_on"])
		if(href_list["set_on"] == "on")
			machine.on = TRUE
		else
			machine.on = FALSE
	updateUsrDialog()

/*
 * Mineral Processing Unit
 */
/obj/machinery/mineral/processing_unit
	name = "furnace"
	icon_state = "furnace"
	light_range = 3	//Big fire with window, yeah it puts out a little light.

	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null
	var/obj/machinery/mineral/console = null
	var/list/ore_amounts = list(
		/obj/item/ore/iron = 0,
		/obj/item/ore/coal = 0,
		/obj/item/ore/glass = 0,
		/obj/item/ore/gold = 0,
		/obj/item/ore/silver = 0,
		/obj/item/ore/diamond = 0,
		/obj/item/ore/plasma = 0,
		/obj/item/ore/uranium = 0,
		/obj/item/ore/bananium = 0,
		/obj/item/ore/tranquilite = 0
	)

	var/on = FALSE // This should be fairly self-explanatory.
	var/selected = 0

/obj/machinery/mineral/processing_unit/initialise()
	. = ..()
	for(var/dir in GLOBL.cardinal)
		input = locate(/obj/machinery/mineral/input, get_step(src, dir))
		if(isnotnull(input))
			break
	for(var/dir in GLOBL.cardinal)
		output = locate(/obj/machinery/mineral/output, get_step(src, dir))
		if(isnotnull(output))
			break
	START_PROCESSING(PCobj, src)

/obj/machinery/mineral/processing_unit/Destroy()
	STOP_PROCESSING(PCobj, src)
	return ..()

/obj/machinery/mineral/processing_unit/process()
	if(isnotnull(input) && isnotnull(output))
		var/i
		for(i = 0; i < 10; i++)
			if(on)
				if(selected == ORE_PROC_IRON)
					if(ore_amounts[/obj/item/ore/iron] > 0)
						ore_amounts[/obj/item/ore/iron]--
						new /obj/item/stack/sheet/iron(output.loc)
					else
						on = FALSE
					continue
				if(selected == ORE_PROC_IRON + ORE_PROC_COAL)
					if(ore_amounts[/obj/item/ore/iron] > 0 && ore_amounts[/obj/item/ore/coal] > 0)
						ore_amounts[/obj/item/ore/iron]--
						ore_amounts[/obj/item/ore/coal]--
						new /obj/item/stack/sheet/steel(output.loc)
					else
						on = FALSE
					continue
				if(selected == ORE_PROC_IRON + ORE_PROC_COAL + ORE_PROC_PLASMA)
					if(ore_amounts[/obj/item/ore/iron] > 0 && ore_amounts[/obj/item/ore/plasma] > 0 && ore_amounts[/obj/item/ore/plasma] > 0)
						ore_amounts[/obj/item/ore/iron]--
						ore_amounts[/obj/item/ore/coal]--
						ore_amounts[/obj/item/ore/plasma]--
						new /obj/item/stack/sheet/plasteel(output.loc)
					else
						on = FALSE
					continue
				if(selected == ORE_PROC_GLASS)
					if(ore_amounts[/obj/item/ore/glass] > 0)
						ore_amounts[/obj/item/ore/glass]--
						new /obj/item/stack/sheet/glass(output.loc)
					else
						on = FALSE
					continue
				if(selected == ORE_PROC_GLASS + ORE_PROC_IRON)
					if(ore_amounts[/obj/item/ore/glass] > 0 && ore_amounts[/obj/item/ore/iron] > 0)
						ore_amounts[/obj/item/ore/glass]--
						ore_amounts[/obj/item/ore/iron]--
						new /obj/item/stack/sheet/glass/reinforced(output.loc)
					else
						on = FALSE
					continue
				if(selected == ORE_PROC_SILVER)
					if(ore_amounts[/obj/item/ore/silver] > 0)
						ore_amounts[/obj/item/ore/silver]--
						new /obj/item/stack/sheet/silver(output.loc)
					else
						on = FALSE
					continue
				if(selected == ORE_PROC_GOLD)
					if(ore_amounts[/obj/item/ore/gold] > 0)
						ore_amounts[/obj/item/ore/gold]--
						new /obj/item/stack/sheet/gold(output.loc)
					else
						on = FALSE
					continue
				if(selected == ORE_PROC_DIAMOND)
					if(ore_amounts[/obj/item/ore/diamond] > 0)
						ore_amounts[/obj/item/ore/diamond]--
						new /obj/item/stack/sheet/diamond(output.loc)
					else
						on = FALSE
					continue
				if(selected == ORE_PROC_URANIUM)
					if(ore_amounts[/obj/item/ore/uranium] > 0)
						ore_amounts[/obj/item/ore/uranium]--
						new /obj/item/stack/sheet/uranium(output.loc)
					else
						on = FALSE
					continue
				if(selected == ORE_PROC_PLASMA)
					if(ore_amounts[/obj/item/ore/plasma] > 0)
						ore_amounts[/obj/item/ore/plasma]--
						new /obj/item/stack/sheet/plasma(output.loc)
					else
						on = FALSE
					continue
				if(selected == ORE_PROC_BANANIUM)
					if(ore_amounts[/obj/item/ore/bananium] > 0)
						ore_amounts[/obj/item/ore/bananium]--
						new /obj/item/stack/sheet/bananium(output.loc)
					else
						on = FALSE
					continue
				if(selected == ORE_PROC_TRANQUILITE)
					if(ore_amounts[/obj/item/ore/tranquilite] > 0)
						ore_amounts[/obj/item/ore/tranquilite]--
						new /obj/item/stack/sheet/tranquilite(output.loc)
					else
						on = FALSE
					continue
				if(selected == ORE_PROC_GLASS + ORE_PROC_PLASMA)
					if(ore_amounts[/obj/item/ore/glass] > 0 && ore_amounts[/obj/item/ore/plasma] > 0)
						ore_amounts[/obj/item/ore/glass]--
						ore_amounts[/obj/item/ore/plasma]--
						new /obj/item/stack/sheet/glass/plasma(output.loc)
					else
						on = FALSE
					continue
				if(selected == ORE_PROC_GLASS + ORE_PROC_IRON + ORE_PROC_PLASMA)
					if(ore_amounts[/obj/item/ore/glass] > 0 && ore_amounts[/obj/item/ore/plasma] > 0 && ore_amounts[/obj/item/ore/iron] > 0)
						ore_amounts[/obj/item/ore/glass]--
						ore_amounts[/obj/item/ore/iron]--
						ore_amounts[/obj/item/ore/plasma]--
						new /obj/item/stack/sheet/glass/plasma/reinforced(output.loc)
					else
						on = FALSE
					continue
				if(selected == ORE_PROC_URANIUM + ORE_PROC_DIAMOND)
					if(ore_amounts[/obj/item/ore/uranium] >= 2 && ore_amounts[/obj/item/ore/diamond] >= 1)
						ore_amounts[/obj/item/ore/uranium] -= 2
						ore_amounts[/obj/item/ore/diamond] -= 1
						new /obj/item/stack/sheet/adamantine(output.loc)
					else
						on = FALSE
					continue
				if(selected == ORE_PROC_SILVER + ORE_PROC_PLASMA)
					if(ore_amounts[/obj/item/ore/silver] >= 1 && ore_amounts[/obj/item/ore/plasma] >= 3)
						ore_amounts[/obj/item/ore/silver] -= 1
						ore_amounts[/obj/item/ore/plasma] -= 3
						new /obj/item/stack/sheet/mythril(output.loc)
					else
						on = FALSE
					continue

				//if a non valid combination is selected
				var/b = 1 //this part checks if all required ores are available

				if(!selected)
					b = 0

				if(selected & ORE_PROC_GOLD)
					if(ore_amounts[/obj/item/ore/gold] <= 0)
						b = 0
				if(selected & ORE_PROC_SILVER)
					if(ore_amounts[/obj/item/ore/silver] <= 0)
						b = 0
				if(selected & ORE_PROC_DIAMOND)
					if(ore_amounts[/obj/item/ore/diamond] <= 0)
						b = 0
				if(selected & ORE_PROC_URANIUM)
					if(ore_amounts[/obj/item/ore/uranium] <= 0)
						b = 0
				if(selected & ORE_PROC_PLASMA)
					if(ore_amounts[/obj/item/ore/plasma] <= 0)
						b = 0
				if(selected & ORE_PROC_IRON)
					if(ore_amounts[/obj/item/ore/iron] <= 0)
						b = 0
				if(selected & ORE_PROC_GLASS)
					if(ore_amounts[/obj/item/ore/glass] <= 0)
						b = 0
				if(selected & ORE_PROC_BANANIUM)
					if(ore_amounts[/obj/item/ore/bananium] <= 0)
						b = 0
				if(selected & ORE_PROC_COAL)
					if(ore_amounts[/obj/item/ore/coal] <= 0)
						b = 0

				if(b) //if they are, deduct one from each, produce slag and shut the machine off
					if(selected & ORE_PROC_GOLD)
						ore_amounts[/obj/item/ore/gold]--
					if(selected & ORE_PROC_SILVER)
						ore_amounts[/obj/item/ore/silver]--
					if(selected & ORE_PROC_DIAMOND)
						ore_amounts[/obj/item/ore/diamond]--
					if(selected & ORE_PROC_URANIUM)
						ore_amounts[/obj/item/ore/uranium]--
					if(selected & ORE_PROC_PLASMA)
						ore_amounts[/obj/item/ore/plasma]--
					if(selected & ORE_PROC_IRON)
						ore_amounts[/obj/item/ore/iron]--
					if(selected & ORE_PROC_BANANIUM)
						ore_amounts[/obj/item/ore/bananium]--
					if(selected & ORE_PROC_COAL)
						ore_amounts[/obj/item/ore/coal]--

					new /obj/item/ore/slag(output.loc)
					on = FALSE
				else
					on = FALSE
					break
				break
			else
				break

		for(i = 0; i < 10; i++)
			var/obj/item/O = locate(/obj/item, input.loc)
			if(isnotnull(O))
				if(O.type in ore_amounts)
					ore_amounts[O.type]++
					O.forceMove(null)
					qdel(O)
					continue

				O.forceMove(output.loc)
			else
				break

#undef ORE_PROC_GOLD
#undef ORE_PROC_SILVER
#undef ORE_PROC_DIAMOND
#undef ORE_PROC_GLASS
#undef ORE_PROC_PLASMA
#undef ORE_PROC_URANIUM
#undef ORE_PROC_IRON
#undef ORE_PROC_BANANIUM