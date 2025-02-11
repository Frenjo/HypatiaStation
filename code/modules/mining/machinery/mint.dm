/*
 * Mint
 */
/obj/machinery/mineral/mint
	name = "coin press"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "coinpress0"

	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null
	var/list/amount_by_material = list(
		/decl/material/iron = 0,
		/decl/material/steel = 0,
		/decl/material/silver = 0,
		/decl/material/gold = 0,
		/decl/material/diamond = 0,
		/decl/material/uranium = 0,
		/decl/material/plasma = 0,
		/decl/material/bananium = 0,
		/decl/material/adamantine = 0,
		/decl/material/mythril = 0
	)
	var/newCoins = 0	//how many coins the machine made in it's last load
	var/processing = FALSE
	var/chosen = /decl/material/iron	//which material will be used to make coins
	var/coinsToProduce = 10

/obj/machinery/mineral/mint/initialise()
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

/obj/machinery/mineral/mint/process()
	if(isnotnull(input))
		var/obj/item/stack/sheet/O = locate(/obj/item/stack/sheet, input.loc)
		if(isnotnull(O))
			amount_by_material[O.material.type] += 100 * O.amount
			qdel(O)

/obj/machinery/mineral/mint/attack_hand(mob/user)
	var/dat = "<b>Coin Press</b><br>"

	if(isnull(input))
		dat += "input connection status: "
		dat += "<b><font color='red'>NOT CONNECTED</font></b><br>"
	if(isnull(output))
		dat += "<br>output connection status: "
		dat += "<b><font color='red'>NOT CONNECTED</font></b><br>"

	for(var/material_path in amount_by_material)
		var/decl/material/material = GET_DECL_INSTANCE(material_path)
		dat += "<br><font color='[material.mint_colour_code]'><b>[material.name] inserted: </b>[amount_by_material[material_path]]</font> "
		if(chosen == material_path)
			dat += "chosen"
		else
			dat += "<A href='byond://?src=\ref[src];choose=[material_path]'>Choose</A>"

	dat += "<br><br>Will produce [coinsToProduce] [chosen] coins if enough materials are available.<br>"
	//dat += "The dial which controls the number of coins to produce seems to be stuck. A technician has already been dispatched to fix this."
	dat += "<A href='byond://?src=\ref[src];chooseAmt=-10'>-10</A> "
	dat += "<A href='byond://?src=\ref[src];chooseAmt=-5'>-5</A> "
	dat += "<A href='byond://?src=\ref[src];chooseAmt=-1'>-1</A> "
	dat += "<A href='byond://?src=\ref[src];chooseAmt=1'>+1</A> "
	dat += "<A href='byond://?src=\ref[src];chooseAmt=5'>+5</A> "
	dat += "<A href='byond://?src=\ref[src];chooseAmt=10'>+10</A> "

	dat += "<br><br>In total this machine produced <font color='green'><b>[newCoins]</b></font> coins."
	dat += "<br><A href='byond://?src=\ref[src];makeCoins=[1]'>Make coins</A>"
	user << browse("[dat]", "window=mint")

/obj/machinery/mineral/mint/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)
	if(processing)
		to_chat(usr, SPAN_INFO("The machine is processing."))
		return
	if(href_list["choose"])
		chosen = text2path(href_list["choose"])
	if(href_list["chooseAmt"])
		coinsToProduce = clamp(coinsToProduce + text2num(href_list["chooseAmt"]), 0, 1000)
	if(href_list["makeCoins"])
		var/temp_coins = coinsToProduce
		if(output)
			processing = TRUE
			icon_state = "coinpress1"
			var/obj/item/moneybag/M
			if(chosen)
				while(amount_by_material[chosen] > 0 && coinsToProduce > 0)
					if(locate(/obj/item/moneybag, output.loc))
						M = locate(/obj/item/moneybag, output.loc)
					else
						M = new /obj/item/moneybag(output.loc)
					var/decl/material/material = GET_DECL_INSTANCE(chosen)
					new material.coin_path(M)
					amount_by_material[chosen] -= 20
					coinsToProduce--
					newCoins++
					updateUsrDialog()
					sleep(5)
			icon_state = "coinpress0"
			processing = FALSE
			coinsToProduce = temp_coins
	updateUsrDialog()