/*
 * Mint
 */
/obj/machinery/mineral/mint
	name = "coin press"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "coinpress0"

	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null
	var/datum/material_container/materials
	var/newCoins = 0	//how many coins the machine made in it's last load
	var/processing = FALSE
	var/decl/material/chosen = /decl/material/iron	//which material will be used to make coins
	var/coinsToProduce = 10

/obj/machinery/mineral/mint/initialise()
	. = ..()
	materials = new /datum/material_container(src, list(
		/decl/material/iron, /decl/material/steel, /decl/material/silver,
		/decl/material/gold, /decl/material/diamond, /decl/material/uranium,
		/decl/material/plasma, /decl/material/bananium, /decl/material/tranquilite,
		/decl/material/adamantine, /decl/material/mythril
	))
	for(var/dir in GLOBL.cardinal)
		input = locate(/obj/machinery/mineral/input, get_step(src, dir))
		if(isnotnull(input))
			break
	for(var/dir in GLOBL.cardinal)
		output = locate(/obj/machinery/mineral/output, get_step(src, dir))
		if(isnotnull(output))
			break
	START_PROCESSING(PCobj, src)

/obj/machinery/mineral/mint/Destroy()
	STOP_PROCESSING(PCobj, src)
	return ..()

/obj/machinery/mineral/mint/process()
	if(isnotnull(input))
		var/obj/item/stack/sheet/O = locate(/obj/item/stack/sheet, input.loc)
		if(isnotnull(O))
			materials.add_sheets(O)

/obj/machinery/mineral/mint/attack_hand(mob/user)
	var/dat = "<b>Coin Press</b><br>"

	if(isnull(input))
		dat += "input connection status: "
		dat += "<b><font color='red'>NOT CONNECTED</font></b><br>"
	if(isnull(output))
		dat += "<br>output connection status: "
		dat += "<b><font color='red'>NOT CONNECTED</font></b><br>"

	for(var/material_path in materials.stored_materials)
		var/decl/material/mat = material_path
		dat += "<br><font color='[initial(mat.colour_code)]'><b>[initial(mat.name)] inserted: </b>[materials.get_type_amount(mat)]cm<sup>3</sup></font> "
		if(chosen == mat)
			dat += "chosen"
		else
			dat += "<A href='byond://?src=\ref[src];choose=[mat]'>Choose</A>"

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
	SHOW_BROWSER(user, dat, "window=mint")

/obj/machinery/mineral/mint/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)

	if(processing)
		to_chat(usr, SPAN_INFO("The machine is processing."))
		return

	var/datum/topic_input/topic_filter = new /datum/topic_input(href, href_list)

	if(href_list["choose"])
		chosen = topic_filter.get_path("choose")

	if(href_list["chooseAmt"])
		coinsToProduce = clamp(coinsToProduce + topic_filter.get_num("chooseAmt"), 0, 1000)

	if(href_list["makeCoins"])
		var/temp_coins = coinsToProduce
		if(isnotnull(output))
			processing = TRUE
			icon_state = "coinpress1"
			var/obj/item/moneybag/M
			while(materials.can_remove_amount(chosen, 20) && coinsToProduce > 0)
				if(locate(/obj/item/moneybag, output.loc))
					M = locate(/obj/item/moneybag, output.loc)
				else
					M = new /obj/item/moneybag(output.loc)
				var/coin_type = initial(chosen.coin_path)
				new coin_type(M)
				materials.remove_amount(chosen, 20)
				coinsToProduce--
				newCoins++
				updateUsrDialog()
				sleep(0.5 SECONDS)
			icon_state = "coinpress0"
			processing = FALSE
			coinsToProduce = temp_coins
	updateUsrDialog()