/*
 * Mineral Stacking Unit Console
 */
/obj/machinery/mineral/stacking_unit_console
	name = "stacking machine console"
	icon_state = "console"

	var/obj/machinery/mineral/stacking_machine/machine = null
	var/machinedir = SOUTHEAST

/obj/machinery/mineral/stacking_unit_console/initialise()
	. = ..()
	machine = locate(/obj/machinery/mineral/stacking_machine, get_step(src, machinedir))
	if(isnotnull(machine))
		machine.console = src
	else
		qdel(src)

/obj/machinery/mineral/stacking_unit_console/process()
	updateDialog()

/obj/machinery/mineral/stacking_unit_console/attack_hand(mob/user)
	add_fingerprint(user)
	interact(user)

/obj/machinery/mineral/stacking_unit_console/interact(mob/user)
	user.set_machine(src)

	var/dat
	dat += "<b>Stacking unit console</b><br><br>"

	if(machine.ore_iron)
		dat += "Iron: [machine.ore_iron] <A href='?src=\ref[src];release=[MATERIAL_METAL]'>Release</A><br>"
	if(machine.ore_plasteel)
		dat += "Plasteel: [machine.ore_plasteel] <A href='?src=\ref[src];release=[MATERIAL_PLASTEEL]'>Release</A><br>"
	if(machine.ore_glass)
		dat += "Glass: [machine.ore_glass] <A href='?src=\ref[src];release=[MATERIAL_GLASS]'>Release</A><br>"
	if(machine.ore_rglass)
		dat += "Reinforced Glass: [machine.ore_rglass] <A href='?src=\ref[src];release=[MATERIAL_RGLASS]'>Release</A><br>"
	if(machine.ore_plasma)
		dat += "Plasma: [machine.ore_plasma] <A href='?src=\ref[src];release=[MATERIAL_PLASMA]'>Release</A><br>"
	if(machine.ore_plasmaglass)
		dat += "Plasma Glass: [machine.ore_plasmaglass] <A href='?src=\ref[src];release=[MATERIAL_PLASMAGLASS]'>Release</A><br>"
	if(machine.ore_plasmarglass)
		dat += "Reinforced Plasma Glass: [machine.ore_plasmarglass] <A href='?src=\ref[src];release=[MATERIAL_PLASMA_RGLASS]'>Release</A><br>"
	if(machine.ore_gold)
		dat += "Gold: [machine.ore_gold] <A href='?src=\ref[src];release=[MATERIAL_GOLD]'>Release</A><br>"
	if(machine.ore_silver)
		dat += "Silver: [machine.ore_silver] <A href='?src=\ref[src];release=[MATERIAL_SILVER]'>Release</A><br>"
	if(machine.ore_uranium)
		dat += "Uranium: [machine.ore_uranium] <A href='?src=\ref[src];release=[MATERIAL_URANIUM]'>Release</A><br>"
	if(machine.ore_diamond)
		dat += "Diamond: [machine.ore_diamond] <A href='?src=\ref[src];release=[MATERIAL_DIAMOND]'>Release</A><br>"
	if(machine.ore_wood)
		dat += "Wood: [machine.ore_wood] <A href='?src=\ref[src];release=[MATERIAL_WOOD]'>Release</A><br>"
	if(machine.ore_cardboard)
		dat += "Cardboard: [machine.ore_cardboard] <A href='?src=\ref[src];release=[MATERIAL_CARDBOARD]'>Release</A><br>"
	if(machine.ore_cloth)
		dat += "Cloth: [machine.ore_cloth] <A href='?src=\ref[src];release=[MATERIAL_CLOTH]'>Release</A><br>"
	if(machine.ore_leather)
		dat += "Leather: [machine.ore_leather] <A href='?src=\ref[src];release=[MATERIAL_LEATHER]'>Release</A><br>"
	if(machine.ore_bananium)
		dat += "Bananium: [machine.ore_bananium] <A href='?src=\ref[src];release=[MATERIAL_BANANIUM]'>Release</A><br>"
	if(machine.ore_adamantine)
		dat += "Adamantine: [machine.ore_adamantine] <A href='?src=\ref[src];release=[MATERIAL_ADAMANTINE]'>Release</A><br>"
	if(machine.ore_mythril)
		dat += "Mythril: [machine.ore_mythril] <A href='?src=\ref[src];release=[MATERIAL_MYTHRIL]'>Release</A><br>"

	dat += "<br>Stacking: [machine.stack_amt]<br><br>"

	user << browse("[dat]", "window=console_stacking_machine")
	onclose(user, "console_stacking_machine")

/obj/machinery/mineral/stacking_unit_console/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)
	if(href_list["release"])
		switch(href_list["release"])
			if(MATERIAL_PLASMA)
				if(machine.ore_plasma > 0)
					var/obj/item/stack/sheet/mineral/plasma/G = new /obj/item/stack/sheet/mineral/plasma(machine.output.loc)
					G.amount = machine.ore_plasma
					machine.ore_plasma = 0
			if(MATERIAL_PLASMAGLASS)
				if(machine.ore_plasmaglass > 0)
					var/obj/item/stack/sheet/glass/plasmaglass/G = new /obj/item/stack/sheet/glass/plasmaglass(machine.output.loc)
					G.amount = machine.ore_plasmaglass
					machine.ore_plasmaglass = 0
			if(MATERIAL_PLASMA_RGLASS)
				if(machine.ore_plasmarglass > 0)
					var/obj/item/stack/sheet/glass/plasmarglass/G = new /obj/item/stack/sheet/glass/plasmarglass(machine.output.loc)
					G.amount = machine.ore_plasmarglass
					machine.ore_plasmarglass = 0
			if(MATERIAL_URANIUM)
				if(machine.ore_uranium > 0)
					var/obj/item/stack/sheet/mineral/uranium/G = new /obj/item/stack/sheet/mineral/uranium(machine.output.loc)
					G.amount = machine.ore_uranium
					machine.ore_uranium = 0
			if(MATERIAL_GLASS)
				if(machine.ore_glass > 0)
					var/obj/item/stack/sheet/glass/G = new /obj/item/stack/sheet/glass(machine.output.loc)
					G.amount = machine.ore_glass
					machine.ore_glass = 0
			if(MATERIAL_RGLASS)
				if(machine.ore_rglass > 0)
					var/obj/item/stack/sheet/rglass/G = new /obj/item/stack/sheet/rglass(machine.output.loc)
					G.amount = machine.ore_rglass
					machine.ore_rglass = 0
			if(MATERIAL_GOLD)
				if(machine.ore_gold > 0)
					var/obj/item/stack/sheet/mineral/gold/G = new /obj/item/stack/sheet/mineral/gold(machine.output.loc)
					G.amount = machine.ore_gold
					machine.ore_gold = 0
			if(MATERIAL_SILVER)
				if(machine.ore_silver > 0)
					var/obj/item/stack/sheet/mineral/silver/G = new /obj/item/stack/sheet/mineral/silver(machine.output.loc)
					G.amount = machine.ore_silver
					machine.ore_silver = 0
			if(MATERIAL_DIAMOND)
				if(machine.ore_diamond > 0)
					var/obj/item/stack/sheet/mineral/diamond/G = new /obj/item/stack/sheet/mineral/diamond(machine.output.loc)
					G.amount = machine.ore_diamond
					machine.ore_diamond = 0
			if(MATERIAL_METAL)
				if(machine.ore_iron > 0)
					var/obj/item/stack/sheet/metal/G = new /obj/item/stack/sheet/metal(machine.output.loc)
					G.amount = machine.ore_iron
					machine.ore_iron = 0
			if(MATERIAL_PLASTEEL)
				if(machine.ore_plasteel > 0)
					var/obj/item/stack/sheet/plasteel/G = new /obj/item/stack/sheet/plasteel(machine.output.loc)
					G.amount = machine.ore_plasteel
					machine.ore_plasteel = 0
			if(MATERIAL_WOOD)
				if(machine.ore_wood > 0)
					var/obj/item/stack/sheet/wood/G = new /obj/item/stack/sheet/wood(machine.output.loc)
					G.amount = machine.ore_wood
					machine.ore_wood = 0
			if(MATERIAL_CARDBOARD)
				if(machine.ore_cardboard > 0)
					var/obj/item/stack/sheet/cardboard/G = new /obj/item/stack/sheet/cardboard(machine.output.loc)
					G.amount = machine.ore_cardboard
					machine.ore_cardboard = 0
			if(MATERIAL_CLOTH)
				if(machine.ore_cloth > 0)
					var/obj/item/stack/sheet/cloth/G = new /obj/item/stack/sheet/cloth(machine.output.loc)
					G.amount = machine.ore_cloth
					machine.ore_cloth = 0
			if(MATERIAL_LEATHER)
				if(machine.ore_leather > 0)
					var/obj/item/stack/sheet/leather/G = new /obj/item/stack/sheet/leather(machine.output.loc)
					G.amount = machine.ore_diamond
					machine.ore_leather = 0
			if(MATERIAL_BANANIUM)
				if(machine.ore_bananium > 0)
					var/obj/item/stack/sheet/mineral/bananium/G = new /obj/item/stack/sheet/mineral/bananium(machine.output.loc)
					G.amount = machine.ore_bananium
					machine.ore_bananium = 0
			if(MATERIAL_ADAMANTINE)
				if(machine.ore_adamantine > 0)
					var/obj/item/stack/sheet/mineral/adamantine/G = new /obj/item/stack/sheet/mineral/adamantine(machine.output.loc)
					G.amount = machine.ore_adamantine
					machine.ore_adamantine = 0
			if(MATERIAL_MYTHRIL)
				if(machine.ore_mythril > 0)
					var/obj/item/stack/sheet/mineral/mythril/G = new /obj/item/stack/sheet/mineral/mythril(machine.output.loc)
					G.amount = machine.ore_mythril
					machine.ore_mythril = 0
	updateUsrDialog()

/*
 * Mineral Stacking Unit
 */
/obj/machinery/mineral/stacking_machine
	name = "stacking machine"
	icon_state = "stacker"

	var/obj/machinery/mineral/stacking_unit_console/console
	var/stk_types = list()
	var/stk_amt = list()
	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null
	var/ore_gold = 0
	var/ore_silver = 0
	var/ore_diamond = 0
	var/ore_plasma = 0
	var/ore_plasmaglass = 0
	var/ore_plasmarglass = 0
	var/ore_iron = 0
	var/ore_uranium = 0
	var/ore_bananium = 0
	var/ore_glass = 0
	var/ore_rglass = 0
	var/ore_plasteel = 0
	var/ore_wood = 0
	var/ore_cardboard = 0
	var/ore_cloth = 0
	var/ore_leather = 0
	var/ore_adamantine = 0
	var/ore_mythril = 0
	var/stack_amt = 50	//ammount to stack before releassing

/obj/machinery/mineral/stacking_machine/initialise()
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

/obj/machinery/mineral/stacking_machine/process()
	if(isnotnull(input) && isnotnull(output))
		var/obj/item/stack/O
		while(locate(/obj/item, input.loc))
			O = locate(/obj/item/stack, input.loc)
			if(isnull(O))
				var/obj/item/I = locate(/obj/item, input.loc)
				if(istype(I, /obj/item/ore/slag))
					I.loc = null
				else
					I.loc = output.loc
				continue
			if(istype(O, /obj/item/stack/sheet/metal))
				ore_iron += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/mineral/diamond))
				ore_diamond += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/mineral/plasma))
				ore_plasma += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/mineral/gold))
				ore_gold += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/mineral/silver))
				ore_silver += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/mineral/bananium))
				ore_bananium += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/mineral/uranium))
				ore_uranium += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/glass/plasmaglass))
				ore_plasmaglass += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/glass/plasmarglass))
				ore_plasmarglass += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/glass))
				ore_glass += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/rglass))
				ore_rglass += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/plasteel))
				ore_plasteel += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/mineral/adamantine))
				ore_adamantine += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/mineral/mythril))
				ore_mythril += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/cardboard))
				ore_cardboard += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/wood))
				ore_wood += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/cloth))
				ore_cloth += O.amount
				O.loc = null
				qdel(O)
				continue
			if(istype(O, /obj/item/stack/sheet/leather))
				ore_leather += O.amount
				O.loc = null
				qdel(O)
				continue
			O.loc = output.loc

	if(ore_gold >= stack_amt)
		var/obj/item/stack/sheet/mineral/gold/G = new /obj/item/stack/sheet/mineral/gold(output.loc)
		G.amount = stack_amt
		ore_gold -= stack_amt
		return
	if(ore_silver >= stack_amt)
		var/obj/item/stack/sheet/mineral/silver/G = new /obj/item/stack/sheet/mineral/silver(output.loc)
		G.amount = stack_amt
		ore_silver -= stack_amt
		return
	if(ore_diamond >= stack_amt)
		var/obj/item/stack/sheet/mineral/diamond/G = new /obj/item/stack/sheet/mineral/diamond(output.loc)
		G.amount = stack_amt
		ore_diamond -= stack_amt
		return
	if(ore_plasma >= stack_amt)
		var/obj/item/stack/sheet/mineral/plasma/G = new /obj/item/stack/sheet/mineral/plasma(output.loc)
		G.amount = stack_amt
		ore_plasma -= stack_amt
		return
	if(ore_iron >= stack_amt)
		var/obj/item/stack/sheet/metal/G = new /obj/item/stack/sheet/metal(output.loc)
		G.amount = stack_amt
		ore_iron -= stack_amt
		return
	if(ore_bananium >= stack_amt)
		var/obj/item/stack/sheet/mineral/bananium/G = new /obj/item/stack/sheet/mineral/bananium(output.loc)
		G.amount = stack_amt
		ore_bananium -= stack_amt
		return
	if(ore_uranium >= stack_amt)
		var/obj/item/stack/sheet/mineral/uranium/G = new /obj/item/stack/sheet/mineral/uranium(output.loc)
		G.amount = stack_amt
		ore_uranium -= stack_amt
		return
	if(ore_glass >= stack_amt)
		var/obj/item/stack/sheet/glass/G = new /obj/item/stack/sheet/glass(output.loc)
		G.amount = stack_amt
		ore_glass -= stack_amt
		return
	if(ore_rglass >= stack_amt)
		var/obj/item/stack/sheet/rglass/G = new /obj/item/stack/sheet/rglass(output.loc)
		G.amount = stack_amt
		ore_rglass -= stack_amt
		return
	if(ore_plasmaglass >= stack_amt)
		var/obj/item/stack/sheet/glass/plasmaglass/G = new /obj/item/stack/sheet/glass/plasmaglass(output.loc)
		G.amount = stack_amt
		ore_plasmaglass -= stack_amt
		return
	if(ore_plasmarglass >= stack_amt)
		var/obj/item/stack/sheet/glass/plasmarglass/G = new /obj/item/stack/sheet/glass/plasmarglass(output.loc)
		G.amount = stack_amt
		ore_plasmarglass -= stack_amt
		return
	if(ore_plasteel >= stack_amt)
		var/obj/item/stack/sheet/plasteel/G = new /obj/item/stack/sheet/plasteel(output.loc)
		G.amount = stack_amt
		ore_plasteel -= stack_amt
		return
	if(ore_wood >= stack_amt)
		var/obj/item/stack/sheet/wood/G = new /obj/item/stack/sheet/wood(output.loc)
		G.amount = stack_amt
		ore_wood -= stack_amt
		return
	if(ore_cardboard >= stack_amt)
		var/obj/item/stack/sheet/cardboard/G = new /obj/item/stack/sheet/cardboard(output.loc)
		G.amount = stack_amt
		ore_cardboard -= stack_amt
		return
	if(ore_cloth >= stack_amt)
		var/obj/item/stack/sheet/cloth/G = new /obj/item/stack/sheet/cloth(output.loc)
		G.amount = stack_amt
		ore_cloth -= stack_amt
		return
	if(ore_leather >= stack_amt)
		var/obj/item/stack/sheet/leather/G = new /obj/item/stack/sheet/leather(output.loc)
		G.amount = stack_amt
		ore_leather -= stack_amt
		return
	if(ore_adamantine >= stack_amt)
		var/obj/item/stack/sheet/mineral/adamantine/G = new /obj/item/stack/sheet/mineral/adamantine(output.loc)
		G.amount = stack_amt
		ore_adamantine -= stack_amt
		return
	if(ore_mythril >= stack_amt)
		var/obj/item/stack/sheet/mineral/mythril/G = new /obj/item/stack/sheet/mineral/mythril(output.loc)
		G.amount = stack_amt
		ore_mythril -= stack_amt
		return