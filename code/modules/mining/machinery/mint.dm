/*
 * Mint
 */
/obj/machinery/mineral/mint
	name = "coin press"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "coinpress0"

	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null
	var/amt_silver = 0	//amount of silver
	var/amt_gold = 0	//amount of gold
	var/amt_diamond = 0
	var/amt_iron = 0
	var/amt_plasma = 0
	var/amt_uranium = 0
	var/amt_bananium = 0
	var/amt_adamantine = 0
	var/amt_mythril = 0
	var/newCoins = 0	//how many coins the machine made in it's last load
	var/processing = FALSE
	var/chosen = MATERIAL_METAL	//which material will be used to make coins
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
		var/obj/item/stack/sheet/O
		O = locate(/obj/item/stack/sheet, input.loc)
		if(isnotnull(O))
			if(istype(O, /obj/item/stack/sheet/gold))
				amt_gold += 100 * O.amount
				qdel(O)
			if(istype(O, /obj/item/stack/sheet/silver))
				amt_silver += 100 * O.amount
				qdel(O)
			if(istype(O, /obj/item/stack/sheet/diamond))
				amt_diamond += 100 * O.amount
				qdel(O)
			if(istype(O, /obj/item/stack/sheet/plasma))
				amt_plasma += 100 * O.amount
				qdel(O)
			if(istype(O, /obj/item/stack/sheet/uranium))
				amt_uranium += 100 * O.amount
				qdel(O)
			if(istype(O, /obj/item/stack/sheet/metal))
				amt_iron += 100 * O.amount
				qdel(O)
			if(istype(O, /obj/item/stack/sheet/bananium))
				amt_bananium += 100 * O.amount
				qdel(O)
			if(istype(O, /obj/item/stack/sheet/adamantine))
				amt_adamantine += 100 * O.amount
				qdel(O)
			if(istype(O, /obj/item/stack/sheet/mythril))
				amt_mythril += 100 * O.amount
				qdel(O)

/obj/machinery/mineral/mint/attack_hand(mob/user)
	var/dat = "<b>Coin Press</b><br>"

	if(isnull(input))
		dat += "input connection status: "
		dat += "<b><font color='red'>NOT CONNECTED</font></b><br>"
	if(isnull(output))
		dat += "<br>output connection status: "
		dat += "<b><font color='red'>NOT CONNECTED</font></b><br>"

	dat += "<br><font color='#ffcc00'><b>Gold inserted: </b>[amt_gold]</font> "
	if(chosen == MATERIAL_GOLD)
		dat += "chosen"
	else
		dat += "<A href='byond://?src=\ref[src];choose=[MATERIAL_GOLD]'>Choose</A>"
	dat += "<br><font color='#888888'><b>Silver inserted: </b>[amt_silver]</font> "
	if(chosen == MATERIAL_SILVER)
		dat += "chosen"
	else
		dat += "<A href='byond://?src=\ref[src];choose=[MATERIAL_SILVER]'>Choose</A>"
	dat += "<br><font color='#555555'><b>Iron inserted: </b>[amt_iron]</font> "
	if(chosen == MATERIAL_METAL)
		dat += "chosen"
	else
		dat += "<A href='byond://?src=\ref[src];choose=[MATERIAL_METAL]'>Choose</A>"
	dat += "<br><font color='#8888FF'><b>Diamond inserted: </b>[amt_diamond]</font> "
	if(chosen == MATERIAL_DIAMOND)
		dat += "chosen"
	else
		dat += "<A href='byond://?src=\ref[src];choose=[MATERIAL_DIAMOND]'>Choose</A>"
	dat += "<br><font color='#FF8800'><b>Plasma inserted: </b>[amt_plasma]</font> "
	if(chosen == MATERIAL_PLASMA)
		dat += "chosen"
	else
		dat += "<A href='byond://?src=\ref[src];choose=[MATERIAL_PLASMA]'>Choose</A>"
	dat += "<br><font color='#008800'><b>uranium inserted: </b>[amt_uranium]</font> "
	if(chosen == MATERIAL_URANIUM)
		dat += "chosen"
	else
		dat += "<A href='byond://?src=\ref[src];choose=[MATERIAL_URANIUM]'>Choose</A>"
	if(amt_bananium > 0)
		dat += "<br><font color='#AAAA00'><b>Bananium inserted: </b>[amt_bananium]</font> "
		if(chosen == MATERIAL_BANANIUM)
			dat += "chosen"
		else
			dat += "<A href='byond://?src=\ref[src];choose=[MATERIAL_BANANIUM]'>Choose</A>"
	dat += "<br><font color='#888888'><b>Adamantine inserted: </b>[amt_adamantine]</font> " // I don't even know these color codes, so fuck it.
	if(chosen == MATERIAL_ADAMANTINE)
		dat += "chosen"
	else
		dat += "<A href='byond://?src=\ref[src];choose=[MATERIAL_ADAMANTINE]'>Choose</A>"
	dat += "<br><font color='#f30000'><b>Mythril inserted: </b>[amt_mythril]</font> " // I don't even know these color codes, so fuck it.
	if(chosen == MATERIAL_MYTHRIL)
		dat += "chosen"
	else
		dat += "<A href='byond://?src=\ref[src];choose=[MATERIAL_MYTHRIL]'>Choose</A>"

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
		coinsToProduce = between(0, coinsToProduce + text2num(href_list["chooseAmt"]), 1000)
	if(href_list["makeCoins"])
		var/temp_coins = coinsToProduce
		if(output)
			processing = TRUE
			icon_state = "coinpress1"
			var/obj/item/moneybag/M
			switch(chosen)
				if(MATERIAL_METAL)
					while(amt_iron > 0 && coinsToProduce > 0)
						if(locate(/obj/item/moneybag, output.loc))
							M = locate(/obj/item/moneybag, output.loc)
						else
							M = new /obj/item/moneybag(output.loc)
						new/obj/item/coin/iron(M)
						amt_iron -= 20
						coinsToProduce--
						newCoins++
						updateUsrDialog()
						sleep(5)
				if(MATERIAL_GOLD)
					while(amt_gold > 0 && coinsToProduce > 0)
						if(locate(/obj/item/moneybag, output.loc))
							M = locate(/obj/item/moneybag, output.loc)
						else
							M = new /obj/item/moneybag(output.loc)
						new /obj/item/coin/gold(M)
						amt_gold -= 20
						coinsToProduce--
						newCoins++
						updateUsrDialog()
						sleep(5)
				if(MATERIAL_SILVER)
					while(amt_silver > 0 && coinsToProduce > 0)
						if(locate(/obj/item/moneybag, output.loc))
							M = locate(/obj/item/moneybag, output.loc)
						else
							M = new /obj/item/moneybag(output.loc)
						new /obj/item/coin/silver(M)
						amt_silver -= 20
						coinsToProduce--
						newCoins++
						updateUsrDialog()
						sleep(5)
				if(MATERIAL_DIAMOND)
					while(amt_diamond > 0 && coinsToProduce > 0)
						if(locate(/obj/item/moneybag, output.loc))
							M = locate(/obj/item/moneybag, output.loc)
						else
							M = new /obj/item/moneybag(output.loc)
						new /obj/item/coin/diamond(M)
						amt_diamond -= 20
						coinsToProduce--
						newCoins++
						updateUsrDialog()
						sleep(5)
				if(MATERIAL_PLASMA)
					while(amt_plasma > 0 && coinsToProduce > 0)
						if(locate(/obj/item/moneybag, output.loc))
							M = locate(/obj/item/moneybag, output.loc)
						else
							M = new /obj/item/moneybag(output.loc)
						new /obj/item/coin/plasma(M)
						amt_plasma -= 20
						coinsToProduce--
						newCoins++
						updateUsrDialog()
						sleep(5)
				if(MATERIAL_URANIUM)
					while(amt_uranium > 0 && coinsToProduce > 0)
						if(locate(/obj/item/moneybag, output.loc))
							M = locate(/obj/item/moneybag, output.loc)
						else
							M = new /obj/item/moneybag(output.loc)
						new /obj/item/coin/uranium(M)
						amt_uranium -= 20
						coinsToProduce--
						newCoins++
						updateUsrDialog()
						sleep(5)
				if(MATERIAL_BANANIUM)
					while(amt_bananium > 0 && coinsToProduce > 0)
						if(locate(/obj/item/moneybag, output.loc))
							M = locate(/obj/item/moneybag, output.loc)
						else
							M = new /obj/item/moneybag(output.loc)
						new /obj/item/coin/bananium(M)
						amt_bananium -= 20
						coinsToProduce--
						newCoins++
						updateUsrDialog()
						sleep(5)
				if(MATERIAL_ADAMANTINE)
					while(amt_adamantine > 0 && coinsToProduce > 0)
						if(locate(/obj/item/moneybag, output.loc))
							M = locate(/obj/item/moneybag, output.loc)
						else
							M = new /obj/item/moneybag(output.loc)
						new /obj/item/coin/adamantine(M)
						amt_adamantine -= 20
						coinsToProduce--
						newCoins++
						updateUsrDialog()
						sleep(5)
				if(MATERIAL_MYTHRIL)
					while(amt_adamantine > 0 && coinsToProduce > 0)
						if(locate(/obj/item/moneybag, output.loc))
							M = locate(/obj/item/moneybag, output.loc)
						else
							M = new /obj/item/moneybag(output.loc)
						new /obj/item/coin/mythril(M)
						amt_mythril -= 20
						coinsToProduce--
						newCoins++
						updateUsrDialog()
						sleep(5)
			icon_state = "coinpress0"
			processing = FALSE
			coinsToProduce = temp_coins
	updateUsrDialog()