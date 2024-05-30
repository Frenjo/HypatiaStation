#define ORE_PROC_GOLD 1
#define ORE_PROC_SILVER 2
#define ORE_PROC_DIAMOND 4
#define ORE_PROC_GLASS 8
#define ORE_PROC_PLASMA 16
#define ORE_PROC_URANIUM 32
#define ORE_PROC_IRON 64
#define ORE_PROC_BANANIUM 128

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
			html += "(<A href='byond:://?src=\ref[src];sel_iron=no'><font color='green'>Smelting</font></A>)"
		else
			html += "(<A href='byond:://?src=\ref[src];sel_iron=yes'><font color='red'>Not Smelting</font></A>)"
		html += "<br>"
		has_materials = TRUE
	else
		machine.selected &= ~ORE_PROC_IRON

	//sand - glass
	if(machine.ore_amounts[/obj/item/ore/glass])
		html += "Sand: [machine.ore_amounts[/obj/item/ore/glass]] "
		if(machine.selected & ORE_PROC_GLASS)
			html += "(<A href='byond:://?src=\ref[src];sel_glass=no'><font color='green'>Smelting</font></A>)"
		else
			html += "(<A href='byond:://?src=\ref[src];sel_glass=yes'><font color='red'>Not Smelting</font></A>)"
		html += "<br>"
		has_materials = TRUE
	else
		machine.selected &= ~ORE_PROC_GLASS

	//plasma
	if(machine.ore_amounts[/obj/item/ore/plasma])
		html += "Plasma: [machine.ore_amounts[/obj/item/ore/plasma]] "
		if(machine.selected & ORE_PROC_PLASMA)
			html += "(<A href='byond:://?src=\ref[src];sel_plasma=no'><font color='green'>Smelting</font></A>)"
		else
			html += "(<A href='byond:://?src=\ref[src];sel_plasma=yes'><font color='red'>Not Smelting</font></A>)"
		html += "<br>"
		has_materials = TRUE
	else
		machine.selected &= ~ORE_PROC_PLASMA

	//uranium
	if(machine.ore_amounts[/obj/item/ore/uranium])
		html += "Uranium: [machine.ore_amounts[/obj/item/ore/uranium]] "
		if(machine.selected & ORE_PROC_URANIUM)
			html += "(<A href='byond:://?src=\ref[src];sel_uranium=no'><font color='green'>Smelting</font></A>)"
		else
			html += "(<A href='byond:://?src=\ref[src];sel_uranium=yes'><font color='red'>Not Smelting</font></A>)"
		html += "<br>"
		has_materials = TRUE
	else
		machine.selected &= ~ORE_PROC_URANIUM

	//gold
	if(machine.ore_amounts[/obj/item/ore/gold])
		html += "Gold: [machine.ore_amounts[/obj/item/ore/gold]] "
		if(machine.selected & ORE_PROC_GOLD)
			html += "(<A href='byond:://?src=\ref[src];sel_gold=no'><font color='green'>Smelting</font></A>)"
		else
			html += "(<A href='byond:://?src=\ref[src];sel_gold=yes'><font color='red'>Not Smelting</font></A>)"
		html += "<br>"
		has_materials = TRUE
	else
		machine.selected &= ~ORE_PROC_GOLD

	//silver
	if(machine.ore_amounts[/obj/item/ore/silver])
		html += "Silver: [machine.ore_amounts[/obj/item/ore/silver]] "
		if(machine.selected & ORE_PROC_SILVER)
			html += "(<A href='byond:://?src=\ref[src];sel_silver=no'><font color='green'>Smelting</font></A>)"
		else
			html += "(<A href='byond:://?src=\ref[src];sel_silver=yes'><font color='red'>Not Smelting</font></A>)"
		html += "<br>"
		has_materials = TRUE
	else
		machine.selected &= ~ORE_PROC_SILVER

	//diamond
	if(machine.ore_amounts[/obj/item/ore/diamond])
		html += "Diamond: [machine.ore_amounts[/obj/item/ore/diamond]] "
		if(machine.selected & ORE_PROC_DIAMOND)
			html += "(<A href='byond:://?src=\ref[src];sel_diamond=no'><font color='green'>Smelting</font></A>)"
		else
			html += "(<A href='byond:://?src=\ref[src];sel_diamond=yes'><font color='red'>Not Smelting</font></A>)"
		html += "<br>"
		has_materials = TRUE
	else
		machine.selected &= ~ORE_PROC_DIAMOND

	//bananium
	if(machine.ore_amounts[/obj/item/ore/bananium])
		html += "Bananium: [machine.ore_amounts[/obj/item/ore/bananium]] "
		if(machine.selected & ORE_PROC_BANANIUM)
			html += "(<A href='byond:://?src=\ref[src];sel_bananium=no'><font color='green'>Smelting</font></A>)"
		else
			html += "(<A href='byond:://?src=\ref[src];sel_bananium=yes'><font color='red'>Not Smelting</font></A>)"
		html += "<br>"
		has_materials = TRUE
	else
		machine.selected &= ~ORE_PROC_BANANIUM

	if(has_materials)
		// On or off.
		html += "<br>Machine is currently: "
		if(machine.on)
			html += "<A href='byond:://?src=\ref[src];set_on=off'>On</A>"
		else
			html += "<A href='byond:://?src=\ref[src];set_on=on'>Off</A>"
	else
		html += "---No Materials Loaded---"

	user << browse(html, "window=console_processing_unit")
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
	if(href_list["sel_glass"])
		if(href_list["sel_glass"] == "yes")
			machine.selected |= ORE_PROC_GLASS
		else
			machine.selected &= ~ORE_PROC_GLASS
	if(href_list["sel_plasma"])
		if(href_list["sel_plasma"] == "yes")
			machine.selected |= ORE_PROC_PLASMA
		else
			machine.selected &= ~ORE_PROC_PLASMA
	if(href_list["sel_uranium"])
		if(href_list["sel_uranium"] == "yes")
			machine.selected |= ORE_PROC_URANIUM
		else
			machine.selected &= ~ORE_PROC_URANIUM
	if(href_list["sel_gold"])
		if(href_list["sel_gold"] == "yes")
			machine.selected |= ORE_PROC_GOLD
		else
			machine.selected &= ~ORE_PROC_GOLD
	if(href_list["sel_silver"])
		if(href_list["sel_silver"] == "yes")
			machine.selected |= ORE_PROC_SILVER
		else
			machine.selected &= ~ORE_PROC_SILVER
	if(href_list["sel_diamond"])
		if(href_list["sel_diamond"] == "yes")
			machine.selected |= ORE_PROC_DIAMOND
		else
			machine.selected &= ~ORE_PROC_DIAMOND
	if(href_list["sel_bananium"])
		if(href_list["sel_bananium"] == "yes")
			machine.selected |= ORE_PROC_BANANIUM
		else
			machine.selected &= ~ORE_PROC_BANANIUM

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
		/obj/item/ore/glass = 0,
		/obj/item/ore/gold = 0,
		/obj/item/ore/silver = 0,
		/obj/item/ore/diamond = 0,
		/obj/item/ore/plasma = 0,
		/obj/item/ore/uranium = 0,
		/obj/item/ore/bananium = 0
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
	GLOBL.processing_objects.Add(src)

/obj/machinery/mineral/processing_unit/process()
	if(isnotnull(input) && isnotnull(output))
		var/i
		for(i = 0; i < 10; i++)
			if(on)
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
				if(selected == ORE_PROC_GOLD)
					if(ore_amounts[/obj/item/ore/gold] > 0)
						ore_amounts[/obj/item/ore/gold]--
						new /obj/item/stack/sheet/gold(output.loc)
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
				if(selected == ORE_PROC_DIAMOND)
					if(ore_amounts[/obj/item/ore/diamond] > 0)
						ore_amounts[/obj/item/ore/diamond]--
						new /obj/item/stack/sheet/diamond(output.loc)
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
				if(selected == ORE_PROC_URANIUM)
					if(ore_amounts[/obj/item/ore/uranium] > 0)
						ore_amounts[/obj/item/ore/uranium]--
						new /obj/item/stack/sheet/uranium(output.loc)
					else
						on = FALSE
					continue
				if(selected == ORE_PROC_IRON)
					if(ore_amounts[/obj/item/ore/iron] > 0)
						ore_amounts[/obj/item/ore/iron]--
						new /obj/item/stack/sheet/metal(output.loc)
					else
						on = FALSE
					continue
				if(selected == ORE_PROC_IRON + ORE_PROC_PLASMA)
					if(ore_amounts[/obj/item/ore/iron] > 0 && ore_amounts[/obj/item/ore/plasma] > 0)
						ore_amounts[/obj/item/ore/iron]--
						ore_amounts[/obj/item/ore/plasma]--
						new /obj/item/stack/sheet/plasteel(output.loc)
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
					O.loc = null
					qdel(O)
					continue

				O.loc = output.loc
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