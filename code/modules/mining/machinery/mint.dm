/*
 * Mint
 */
/obj/machinery/mint
	name = "coin press"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "coinpress0"

	var/turf/input_turf = null
	var/turf/output_turf = null
	var/newCoins = 0	//how many coins the machine made in it's last load
	var/processing = FALSE
	var/decl/material/chosen = /decl/material/iron	//which material will be used to make coins
	var/coinsToProduce = 10

/obj/machinery/mint/initialise()
	. = ..()
	add_component(/datum/component/material_container, list(
		/decl/material/iron, /decl/material/steel, /decl/material/silver,
		/decl/material/gold, /decl/material/diamond, /decl/material/uranium,
		/decl/material/plasma, /decl/material/bananium, /decl/material/tranquilite,
		/decl/material/adamantine, /decl/material/mythril
	))
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

/obj/machinery/mint/Destroy()
	STOP_PROCESSING(PCobj, src)
	return ..()

/obj/machinery/mint/process()
	if(isnotnull(input_turf))
		var/obj/item/stack/sheet/O = locate(/obj/item/stack/sheet, input_turf)
		if(isnotnull(O))
			GET_COMPONENT(container, /datum/component/material_container)
			container.add_sheets(O)

/obj/machinery/mint/attack_hand(mob/user)
	var/dat = "<b>Coin Press</b><br>"

	if(isnull(input_turf))
		dat += "input connection status: "
		dat += "<b><font color='red'>NOT CONNECTED</font></b><br>"
	if(isnull(output_turf))
		dat += "<br>output connection status: "
		dat += "<b><font color='red'>NOT CONNECTED</font></b><br>"

	GET_COMPONENT(container, /datum/component/material_container)
	var/alist/materials = container.get_all_materials()
	for(var/material_path in materials)
		var/decl/material/mat = material_path
		dat += "<br><font color='[initial(mat.colour_code)]'><b>[initial(mat.name)] inserted: </b>[materials[material_path]]cm<sup>3</sup></font> "
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

/obj/machinery/mint/Topic(href, href_list)
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
		if(isnotnull(output_turf))
			processing = TRUE
			icon_state = "coinpress1"
			var/obj/item/moneybag/M
			GET_COMPONENT(container, /datum/component/material_container)
			while(container.can_remove_amount(chosen, 20) && coinsToProduce > 0)
				if(locate(/obj/item/moneybag, output_turf))
					M = locate(/obj/item/moneybag, output_turf)
				else
					M = new /obj/item/moneybag(output_turf)
				var/coin_type = initial(chosen.coin_path)
				new coin_type(M)
				container.remove_amount(chosen, 20)
				coinsToProduce--
				newCoins++
				updateUsrDialog()
				sleep(0.5 SECONDS)
			icon_state = "coinpress0"
			processing = FALSE
			coinsToProduce = temp_coins
	updateUsrDialog()