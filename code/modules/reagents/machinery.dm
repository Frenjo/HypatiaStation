#define MAX_PILL_SPRITE 20 //max icon state of the pill sprites
#define MAX_BOTTLE_SPRITE 20 //max icon state of the bottle sprites

/obj/machinery/chem_dispenser
	name = "chem dispenser"
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/chemical.dmi'
	icon_state = "dispenser"

	power_state = USE_POWER_OFF
	power_usage = alist(
		USE_POWER_IDLE = 40
	)

	var/ui_title = "Chem Dispenser 5000"
	var/energy = 100
	var/max_energy = 100
	var/amount = 30
	var/accept_glass = 0
	var/obj/item/reagent_holder/beaker = null
	var/recharged = 0
	var/hackedcheck = 0
	var/list/dispensable_reagents = list(
		"hydrogen", "lithium", "carbon", "nitrogen", "oxygen", "fluorine",
		"sodium", "aluminum", "silicon", "phosphorus", "sulfur", "chlorine", "potassium", "iron",
		"copper", "mercury", "radium", "water", "ethanol", "sugar", "sacid", "tungsten"
	)
	var/list/broken_requirements = list()
	var/broken_on_spawn = 0

/obj/machinery/chem_dispenser/initialise()
	. = ..()
	recharge()
	dispensable_reagents = sortList(dispensable_reagents)

	if(broken_on_spawn)
		var/amount = pick(1, 2, 2, 3, 4)
		var/list/options = list()
		options[/obj/item/stock_part/capacitor/adv] = "Add an advanced capacitor to fix it."
		options[/obj/item/stock_part/console_screen] = "Replace the console screen to fix it."
		options[/obj/item/stock_part/manipulator/pico] = "Upgrade to a pico manipulator to fix it."
		options[/obj/item/stock_part/matter_bin/adv] = "Give it an advanced matter bin to fix it."
		options[/obj/item/stack/sheet/diamond] = "Line up a cut diamond with the nozzle to fix it."
		options[/obj/item/stack/sheet/uranium] = "Position a uranium sheet inside to fix it."
		options[/obj/item/stack/sheet/plasma] = "Enter a block of plasma to fix it."
		options[/obj/item/stack/sheet/silver] = "Cover the internals with a silver lining to fix it."
		options[/obj/item/stack/sheet/gold] = "Wire a golden filament to fix it."
		options[/obj/item/stack/sheet/plasteel] = "Surround the outside with a plasteel cover to fix it."
		options[/obj/item/stack/sheet/glass/reinforced] = "Insert a pane of reinforced glass to fix it."
		stat |= BROKEN
		while(amount > 0)
			amount -= 1

			var/index = pick(options)
			broken_requirements[index] = options[index]
			options -= index

/obj/machinery/chem_dispenser/proc/recharge()
	if(stat & (BROKEN|NOPOWER))
		return
	var/addenergy = 1
	var/oldenergy = energy
	energy = min(energy + addenergy, max_energy)
	if(energy != oldenergy)
		use_power(1500) // This thing uses up alot of power (this is still low as shit for creating reagents from thin air)
		global.PCnanoui.update_uis(src) // update all UIs attached to src

/obj/machinery/chem_dispenser/power_change()
	if(powered())
		stat &= ~NOPOWER
	else
		spawn(rand(0, 15))
			stat |= NOPOWER
	global.PCnanoui.update_uis(src) // update all UIs attached to src

/obj/machinery/chem_dispenser/process()
	if(recharged <= 0)
		recharge()
		recharged = 15
	else
		recharged -= 1

/obj/machinery/chem_dispenser/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return

/obj/machinery/chem_dispenser/blob_act()
	if(prob(50))
		qdel(src)

/obj/machinery/chem_dispenser/meteorhit()
	qdel(src)
	return

 /**
  * The ui_interact proc is used to open and update Nano UIs
  * If ui_interact is not used then the UI will not update correctly
  * ui_interact is currently defined for /atom/movable
  *
  * @param user /mob The mob who is interacting with this ui
  * @param ui_key string A string key to use for this ui. Allows for multiple unique uis on one obj/mob (defaut value "main")
  *
  * @return nothing
  */
/obj/machinery/chem_dispenser/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null)
	if(length(broken_requirements))
		to_chat(user, SPAN_WARNING("[src] is broken. [broken_requirements[broken_requirements[1]]]"))
		return
	if(stat & (BROKEN|NOPOWER))
		return
	if(user.stat || user.restrained())
		return

	var/has_beaker = isnotnull(beaker)
	// this is the data which will be sent to the ui
	var/alist/data = alist(
		"amount" = amount,
		"energy" = energy,
		"maxEnergy" = max_energy,
		"isBeakerLoaded" = has_beaker,
		"glass" = accept_glass
	)
	var/list/beakerContents = list()
	var/beakerCurrentVolume = 0
	if(has_beaker && isnotnull(beaker.reagents) && length(beaker.reagents.reagent_list))
		for(var/datum/reagent/R in beaker.reagents.reagent_list)
			beakerContents.Add(list(list("name" = R.name, "volume" = R.volume))) // list in a list because Byond merges the first list...
			beakerCurrentVolume += R.volume
	data["beakerContents"] = beakerContents

	if(has_beaker)
		data["beakerCurrentVolume"] = beakerCurrentVolume
		data["beakerMaxVolume"] = beaker:volume
	else
		data["beakerCurrentVolume"] = null
		data["beakerMaxVolume"] = null

	var/list/chemicals = list()
	for(var/re in dispensable_reagents)
		var/datum/reagent/temp = GLOBL.chemical_reagents_list[re]
		if(temp)
			chemicals.Add(list(list("title" = temp.name, "id" = temp.id, "commands" = list("dispense" = temp.id)))) // list in a list because Byond merges the first list...
	data["chemicals"] = chemicals

	// update the ui if it exists, returns null if no ui is passed/found
	ui = global.PCnanoui.try_update_ui(user, src, ui_key, ui, data)
	if(isnull(ui))
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new /datum/nanoui(user, src, ui_key, "chem_dispenser.tmpl", ui_title, 380, 650)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()

/obj/machinery/chem_dispenser/Topic(href, href_list)
	if(stat & (NOPOWER|BROKEN))
		return 0 // don't update UIs attached to this object

	if(href_list["amount"])
		amount = round(text2num(href_list["amount"]), 5) // round to nearest 5
		if(amount < 0) // Since the user can actually type the commands himself, some sanity checking
			amount = 0
		if(amount > 100)
			amount = 100

	if(href_list["dispense"])
		if(dispensable_reagents.Find(href_list["dispense"]) && beaker != null)
			var/obj/item/reagent_holder/B = src.beaker
			var/datum/reagents/R = B.reagents
			var/space = R.maximum_volume - R.total_volume

			R.add_reagent(href_list["dispense"], min(amount, energy * 10, space))
			energy = max(energy - min(amount, energy * 10, space) / 10, 0)

	if(href_list["ejectBeaker"])
		if(beaker)
			var/obj/item/reagent_holder/B = beaker
			B.forceMove(loc)
			beaker = null

	add_fingerprint(usr)
	return 1 // update UIs attached to this object

/obj/machinery/chem_dispenser/attackby(obj/item/reagent_holder/B, mob/user)
	if(isrobot(user))
		return

	if(length(broken_requirements) && B.type == broken_requirements[1])
		broken_requirements -= broken_requirements[1]
		to_chat(user, SPAN_NOTICE("You fix [src]."))
		if(istype(B, /obj/item/stack))
			var/obj/item/stack/S = B
			S.use(1)
		else
			user.drop_item()
			qdel(B)
		if(!length(broken_requirements))
			stat ^= BROKEN
		return
	if(src.beaker)
		to_chat(user, "Something is already loaded into the machine.")
		return
	if(istype(B, /obj/item/reagent_holder/glass) || istype(B, /obj/item/reagent_holder/food))
		if(!accept_glass && istype(B, /obj/item/reagent_holder/food))
			to_chat(user, SPAN_NOTICE("This machine only accepts beakers."))
		src.beaker =  B
		user.drop_item()
		B.forceMove(src)
		to_chat(user, "You set [B] on the machine.")
		global.PCnanoui.update_uis(src) // update all UIs attached to src
		return

/obj/machinery/chem_dispenser/attack_ai(mob/user)
	return src.attack_hand(user)

/obj/machinery/chem_dispenser/attack_paw(mob/user)
	return src.attack_hand(user)

/obj/machinery/chem_dispenser/attack_hand(mob/user)
	if(stat & BROKEN)
		return

	ui_interact(user)

/obj/machinery/chem_dispenser/soda
	icon_state = "soda_dispenser"
	name = "soda fountain"
	desc = "A drink fabricating machine, capable of producing many sugary drinks with just one touch."
	ui_title = "Soda Dispens-o-matic"
	energy = 100
	accept_glass = 1
	max_energy = 100
	dispensable_reagents = list("water", "ice", "coffee", "cream", "tea", "icetea", "cola", "spacemountainwind", "dr_gibb", "space_up", "tonic", "sodawater", "lemon_lime", "sugar", "orangejuice", "limejuice", "watermelonjuice")

/obj/machinery/chem_dispenser/soda/attackby(obj/item/B, mob/user)
	..()
	if(ismultitool(B))
		if(hackedcheck == 0)
			to_chat(user, "You change the mode from 'McNano' to 'Pizza King'.")
			dispensable_reagents += list("thirteenloko", "grapesoda")
			hackedcheck = 1
			return
		else
			to_chat(user, "You change the mode from 'Pizza King' to 'McNano'.")
			dispensable_reagents -= list("thirteenloko")
			hackedcheck = 0
			return

/obj/machinery/chem_dispenser/beer
	icon_state = "booze_dispenser"
	name = "booze dispenser"
	ui_title = "Booze Portal 9001"
	energy = 100
	accept_glass = 1
	max_energy = 100
	desc = "A technological marvel, supposedly able to mix just the mixture you'd like to drink the moment you ask for one."
	dispensable_reagents = list("lemon_lime", "sugar", "orangejuice", "limejuice", "sodawater", "tonic", "beer", "kahlua", "whiskey", "wine", "vodka", "gin", "rum", "tequilla", "vermouth", "cognac", "ale", "mead")

/obj/machinery/chem_dispenser/beer/attackby(obj/item/B, mob/user)
	..()
	if(ismultitool(B))
		if(hackedcheck == 0)
			to_chat(user, "You disable the 'nanotrasen-are-cheap-bastards' lock, enabling hidden and very expensive boozes.")
			dispensable_reagents += list("goldschlager", "patron", "watermelonjuice", "berryjuice")
			hackedcheck = 1
			return
		else
			to_chat(user, "You re-enable the 'nanotrasen-are-cheap-bastards' lock, disabling hidden and very expensive boozes.")
			dispensable_reagents -= list("goldschlager", "patron", "watermelonjuice", "berryjuice")
			hackedcheck = 0
			return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/chem_master
	name = "ChemMaster 3000"
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0"

	power_usage = alist(
		USE_POWER_IDLE = 20
	)

	var/beaker = null
	var/obj/item/storage/pill_bottle/loaded_pill_bottle = null
	var/mode = 0
	var/condi = 0
	var/useramount = 30 // Last used amount
	var/pillamount = 10
	var/bottlesprite = "1" //yes, strings
	var/pillsprite = "1"
	var/client/has_sprites = list()
	var/max_pill_count = 20

/obj/machinery/chem_master/initialise()
	. = ..()
	create_reagents(100)

/obj/machinery/chem_master/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return

/obj/machinery/chem_master/blob_act()
	if(prob(50))
		qdel(src)

/obj/machinery/chem_master/meteorhit()
	qdel(src)
	return

/obj/machinery/chem_master/power_change()
	if(powered())
		stat &= ~NOPOWER
	else
		spawn(rand(0, 15))
			stat |= NOPOWER

/obj/machinery/chem_master/attackby(obj/item/B, mob/user)
	if(istype(B, /obj/item/reagent_holder/glass))
		if(src.beaker)
			to_chat(user, "A beaker is already loaded into the machine.")
			return
		src.beaker = B
		user.drop_item()
		B.forceMove(src)
		to_chat(user, "You add the beaker to the machine!")
		src.updateUsrDialog()
		icon_state = "mixer1"

	else if(istype(B, /obj/item/storage/pill_bottle))
		if(src.loaded_pill_bottle)
			to_chat(user, "A pill bottle is already loaded into the machine.")
			return

		src.loaded_pill_bottle = B
		user.drop_item()
		B.forceMove(src)
		to_chat(user, "You add the pill bottle into the dispenser slot!")
		src.updateUsrDialog()
	return

/obj/machinery/chem_master/Topic(href, href_list)
	if(stat & (BROKEN|NOPOWER))
		return
	if(usr.stat || usr.restrained())
		return
	if(!in_range(src, usr))
		return

	src.add_fingerprint(usr)
	usr.set_machine(src)

	if(href_list["ejectp"])
		if(loaded_pill_bottle)
			loaded_pill_bottle.forceMove(loc)
			loaded_pill_bottle = null
	else if(href_list["close"])
		usr << browse(null, "window=chemmaster")
		usr.unset_machine()
		return

	if(beaker)
		var/datum/reagents/R = beaker:reagents
		if(href_list["analyse"])
			var/dat = ""
			if(!condi)
				if(href_list["name"] == "Blood")
					var/datum/reagent/blood/G
					for(var/datum/reagent/F in R.reagent_list)
						if(F.name == href_list["name"])
							G = F
							break
					var/A = G.name
					var/B = G.data["blood_type"]
					var/C = G.data["blood_DNA"]
					dat += "<TITLE>Chemmaster 3000</TITLE>Chemical infos:<BR><BR>Name:<BR>[A]<BR><BR>Description:<BR>Blood Type: [B]<br>DNA: [C]<BR><BR><BR><A href='byond://?src=\ref[src];main=1'>(Back)</A>"
				else
					dat += "<TITLE>Chemmaster 3000</TITLE>Chemical infos:<BR><BR>Name:<BR>[href_list["name"]]<BR><BR>Description:<BR>[href_list["desc"]]<BR><BR><BR><A href='byond://?src=\ref[src];main=1'>(Back)</A>"
			else
				dat += "<TITLE>Condimaster 3000</TITLE>Condiment infos:<BR><BR>Name:<BR>[href_list["name"]]<BR><BR>Description:<BR>[href_list["desc"]]<BR><BR><BR><A href='byond://?src=\ref[src];main=1'>(Back)</A>"
			usr << browse(dat, "window=chem_master;size=575x400")
			return

		else if(href_list["add"])
			if(href_list["amount"])
				var/id = href_list["add"]
				var/amount = text2num(href_list["amount"])
				R.trans_id_to(src, id, amount)

		else if(href_list["addcustom"])
			var/id = href_list["addcustom"]
			useramount = input("Select the amount to transfer.", 30, useramount) as num
			useramount = isgoodnumber(useramount)
			src.Topic(null, list("amount" = "[useramount]", "add" = "[id]"))

		else if(href_list["remove"])
			if(href_list["amount"])
				var/id = href_list["remove"]
				var/amount = text2num(href_list["amount"])
				if(mode)
					reagents.trans_id_to(beaker, id, amount)
				else
					reagents.remove_reagent(id, amount)

		else if(href_list["removecustom"])
			var/id = href_list["removecustom"]
			useramount = input("Select the amount to transfer.", 30, useramount) as num
			useramount = isgoodnumber(useramount)
			src.Topic(null, list("amount" = "[useramount]", "remove" = "[id]"))

		else if(href_list["toggle"])
			mode = !mode

		else if(href_list["main"])
			attack_hand(usr)
			return

		else if(href_list["eject"])
			if(beaker)
				beaker:loc = src.loc
				beaker = null
				reagents.clear_reagents()
				icon_state = "mixer0"

		else if(href_list["createpill"] || href_list["createpill_multiple"])
			var/count = 1

			if(reagents.total_volume/count < 1) //Sanity checking.
				return

			if(href_list["createpill_multiple"])
				count = clamp(isgoodnumber(input("Select the number of pills to make.", 10, pillamount) as num), 1, max_pill_count)

			if(reagents.total_volume/count < 1) //Sanity checking.
				return

			var/amount_per_pill = reagents.total_volume/count
			if(amount_per_pill > 50)
				amount_per_pill = 50

			var/name = reject_bad_text(input(usr, "Name:", "Name your pill!", "[reagents.get_master_reagent_name()] ([amount_per_pill] units)"))

			if(reagents.total_volume / count < 1) //Sanity checking.
				return

			while(count--)
				var/obj/item/reagent_holder/pill/P = new/obj/item/reagent_holder/pill(src.loc)
				if(!name)
					name = reagents.get_master_reagent_name()
				P.name = "[name] pill"
				P.pixel_x = rand(-7, 7) //random position
				P.pixel_y = rand(-7, 7)
				P.icon_state = "pill" + pillsprite
				reagents.trans_to(P, amount_per_pill)
				if(src.loaded_pill_bottle)
					if(length(loaded_pill_bottle.contents) < loaded_pill_bottle.storage_slots)
						P.forceMove(loaded_pill_bottle)
						src.updateUsrDialog()

		else if (href_list["createbottle"])
			if(!condi)
				var/name = reject_bad_text(input(usr, "Name:", "Name your bottle!", reagents.get_master_reagent_name()))
				var/obj/item/reagent_holder/glass/bottle/P = new/obj/item/reagent_holder/glass/bottle(src.loc)
				if(!name)
					name = reagents.get_master_reagent_name()
				P.name = "[name] bottle"
				P.pixel_x = rand(-7, 7) //random position
				P.pixel_y = rand(-7, 7)
				P.icon_state = "bottle" + bottlesprite
				reagents.trans_to(P, 30)
			else
				var/obj/item/reagent_holder/food/condiment/P = new/obj/item/reagent_holder/food/condiment(src.loc)
				reagents.trans_to(P, 50)
		else if(href_list["change_pill"])
			var/dat = "<table>"
			for(var/i = 1 to MAX_PILL_SPRITE)
				dat += "<tr><td><a href=\"?src=\ref[src]&pill_sprite=[i]\"><img src=\"pill[i].png\" /></a></td></tr>"
			dat += "</table>"
			usr << browse(dat, "window=chem_master")
			return
		else if(href_list["change_bottle"])
			var/dat = "<table>"
			for(var/i = 1 to MAX_BOTTLE_SPRITE)
				dat += "<tr><td><a href=\"?src=\ref[src]&bottle_sprite=[i]\"><img src=\"bottle[i].png\" /></a></td></tr>"
			dat += "</table>"
			usr << browse(dat, "window=chem_master")
			return
		else if(href_list["pill_sprite"])
			pillsprite = href_list["pill_sprite"]
		else if(href_list["bottle_sprite"])
			bottlesprite = href_list["bottle_sprite"]

	src.updateUsrDialog()
	return

/obj/machinery/chem_master/attack_ai(mob/user)
	return src.attack_hand(user)

/obj/machinery/chem_master/attack_paw(mob/user)
	return src.attack_hand(user)

/obj/machinery/chem_master/attack_hand(mob/user)
	if(stat & BROKEN)
		return
	user.set_machine(src)
	if(!(user.client in has_sprites))
		spawn()
			has_sprites += user.client
			for(var/i = 1 to MAX_PILL_SPRITE)
				usr << browse_rsc(icon('icons/obj/chemical.dmi', "pill" + num2text(i)), "pill[i].png")
			for(var/i = 1 to MAX_BOTTLE_SPRITE)
				usr << browse_rsc(icon('icons/obj/chemical.dmi', "bottle" + num2text(i)), "bottle[i].png")
	var/dat = ""
	if(!beaker)
		dat = "Please insert beaker.<BR>"
		if(src.loaded_pill_bottle)
			dat += "<A href='byond://?src=\ref[src];ejectp=1'>Eject Pill Bottle \[[length(loaded_pill_bottle.contents)]/[loaded_pill_bottle.storage_slots]\]</A><BR><BR>"
		else
			dat += "No pill bottle inserted.<BR><BR>"
		dat += "<A href='byond://?src=\ref[src];close=1'>Close</A>"
	else
		var/datum/reagents/R = beaker:reagents
		dat += "<A href='byond://?src=\ref[src];eject=1'>Eject beaker and Clear Buffer</A><BR>"
		if(src.loaded_pill_bottle)
			dat += "<A href='byond://?src=\ref[src];ejectp=1'>Eject Pill Bottle \[[length(loaded_pill_bottle.contents)]/[loaded_pill_bottle.storage_slots]\]</A><BR><BR>"
		else
			dat += "No pill bottle inserted.<BR><BR>"
		if(!R.total_volume)
			dat += "Beaker is empty."
		else
			dat += "Add to buffer:<BR>"
			for(var/datum/reagent/G in R.reagent_list)
				dat += "[G.name], [G.volume] Units - " // Removed a space between [G.name] and the folllowing comma for OCD reasons. -Frenjo
				dat += "<A href='byond://?src=\ref[src];analyse=1;desc=[G.description];name=[G.name]'>(Analyse)</A> "
				dat += "<A href='byond://?src=\ref[src];add=[G.id];amount=1'>(1)</A> "
				dat += "<A href='byond://?src=\ref[src];add=[G.id];amount=5'>(5)</A> "
				dat += "<A href='byond://?src=\ref[src];add=[G.id];amount=10'>(10)</A> "
				dat += "<A href='byond://?src=\ref[src];add=[G.id];amount=[G.volume]'>(All)</A> "
				dat += "<A href='byond://?src=\ref[src];addcustom=[G.id]'>(Custom)</A><BR>"

		dat += "<HR>Transfer to <A href='byond://?src=\ref[src];toggle=1'>[(!mode ? "disposal" : "beaker")]:</A><BR>"
		if(reagents.total_volume)
			for(var/datum/reagent/N in reagents.reagent_list)
				dat += "[N.name] , [N.volume] Units - "
				dat += "<A href='byond://?src=\ref[src];analyse=1;desc=[N.description];name=[N.name]'>(Analyse)</A> "
				dat += "<A href='byond://?src=\ref[src];remove=[N.id];amount=1'>(1)</A> "
				dat += "<A href='byond://?src=\ref[src];remove=[N.id];amount=5'>(5)</A> "
				dat += "<A href='byond://?src=\ref[src];remove=[N.id];amount=10'>(10)</A> "
				dat += "<A href='byond://?src=\ref[src];remove=[N.id];amount=[N.volume]'>(All)</A> "
				dat += "<A href='byond://?src=\ref[src];removecustom=[N.id]'>(Custom)</A><BR>"
		else
			dat += "Empty<BR>"
		if(!condi)
			dat += "<HR><BR><A href='byond://?src=\ref[src];createpill=1'>Create pill (50 units max)</A><a href=\"?src=\ref[src]&change_pill=1\"><img src=\"pill[pillsprite].png\" /></a><BR>"
			dat += "<A href='byond://?src=\ref[src];createpill_multiple=1'>Create multiple pills</A><BR>"
			dat += "<A href='byond://?src=\ref[src];createbottle=1'>Create bottle (30 units max)<a href=\"?src=\ref[src]&change_bottle=1\"><img src=\"bottle[bottlesprite].png\" /></A>"
		else
			dat += "<A href='byond://?src=\ref[src];createbottle=1'>Create bottle (50 units max)</A>"
	if(!condi)
		user << browse("<TITLE>Chemmaster 3000</TITLE>Chemmaster menu:<BR><BR>[dat]", "window=chem_master;size=575x400")
	else
		user << browse("<TITLE>Condimaster 3000</TITLE>Condimaster menu:<BR><BR>[dat]", "window=chem_master;size=575x400")
	onclose(user, "chem_master")
	return

/obj/machinery/chem_master/proc/isgoodnumber(num)
	if(isnum(num))
		if(num > 200)
			num = 200
		else if(num < 0)
			num = 1
		else
			num = round(num)
		return num
	else
		return 0


/obj/machinery/chem_master/condimaster
	name = "CondiMaster 3000"
	condi = 1

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

/obj/machinery/computer/pandemic
	name = "PanD.E.M.I.C 2200"
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0"
	circuit = /obj/item/circuitboard/pandemic
	//use_power = 1
	//idle_power_usage = 20		//defaults make more sense.
	var/temphtml = ""
	var/wait = null
	var/obj/item/reagent_holder/glass/beaker = null

/obj/machinery/computer/pandemic/set_broken()
	icon_state = (src.beaker ? "mixer1_b" : "mixer0_b")
	stat |= BROKEN

/obj/machinery/computer/pandemic/power_change()
	if(stat & BROKEN)
		icon_state = (src.beaker ? "mixer1_b" : "mixer0_b")

	else if(powered())
		icon_state = (src.beaker ? "mixer1" : "mixer0")
		stat &= ~NOPOWER

	else
		spawn(rand(0, 15))
			src.icon_state = (src.beaker ? "mixer1_nopower" : "mixer0_nopower")
			stat |= NOPOWER


/obj/machinery/computer/pandemic/Topic(href, href_list)
	if(stat & (NOPOWER|BROKEN))
		return
	if(usr.stat || usr.restrained())
		return
	if(!in_range(src, usr))
		return

	usr.set_machine(src)
	if(!beaker)
		return

	if(href_list["create_vaccine"])
		if(!src.wait)
			var/obj/item/reagent_holder/glass/bottle/B = new/obj/item/reagent_holder/glass/bottle(src.loc)
			if(B)
				var/path = href_list["create_vaccine"]
				var/vaccine_type = text2path(path)
				var/datum/disease/D = null

				if(!vaccine_type)
					D = archive_diseases[path]
					vaccine_type = path
				else
					if(vaccine_type in GLOBL.diseases)
						D = new vaccine_type(0, null)

				if(D)
					B.name = "[D.name] vaccine bottle"
					B.reagents.add_reagent("vaccine", 15, vaccine_type)
					wait = 1
					var/datum/reagents/R = beaker.reagents
					var/datum/reagent/blood/Blood = null
					for(var/datum/reagent/blood/L in R.reagent_list)
						if(L)
							Blood = L
							break
					var/list/res = Blood.data["resistances"]
					spawn(length(res) * 200)
						src.wait = null
		else
			src.temphtml = "The replicator is not ready yet."
		src.updateUsrDialog()
		return
	else if (href_list["create_virus_culture"])
		if(!wait)
			var/obj/item/reagent_holder/glass/bottle/B = new/obj/item/reagent_holder/glass/bottle(src.loc)
			B.icon_state = "bottle3"
			var/type = text2path(href_list["create_virus_culture"])//the path is received as string - converting
			var/datum/disease/D = null
			if(!type)
				var/datum/disease/advance/A = archive_diseases[href_list["create_virus_culture"]]
				if(A)
					D = new A.type(0, A)
			else
				if(type in GLOBL.diseases) // Make sure this is a disease
					D = new type(0, null)
			var/list/data = list("viruses" = list(D))
			var/name = sanitize(input(usr, "Name:", "Name the culture", D.name))
			if(!name || name == " ")
				name = D.name
			B.name = "[name] culture bottle"
			B.desc = "A small bottle. Contains [D.agent] culture in synthblood medium."
			B.reagents.add_reagent("blood", 20, data)
			src.updateUsrDialog()
			wait = 1
			spawn(1000)
				src.wait = null
		else
			src.temphtml = "The replicator is not ready yet."
		src.updateUsrDialog()
		return
	else if (href_list["empty_beaker"])
		beaker.reagents.clear_reagents()
		src.updateUsrDialog()
		return
	else if (href_list["eject"])
		beaker:loc = src.loc
		beaker = null
		icon_state = "mixer0"
		src.updateUsrDialog()
		return
	else if(href_list["clear"])
		src.temphtml = ""
		src.updateUsrDialog()
		return
	else if(href_list["name_disease"])
		var/new_name = stripped_input(usr, "Name the Disease", "New Name", "", MAX_NAME_LEN)
		if(stat & (NOPOWER|BROKEN))
			return
		if(usr.stat || usr.restrained())
			return
		if(!in_range(src, usr))
			return
		var/id = href_list["name_disease"]
		if(archive_diseases[id])
			var/datum/disease/advance/A = archive_diseases[id]
			A.AssignName(new_name)
			for(var/datum/disease/advance/AD in global.PCdisease.processing_list)
				AD.Refresh()
		src.updateUsrDialog()


	else
		usr << browse(null, "window=pandemic")
		src.updateUsrDialog()
		return

	src.add_fingerprint(usr)
	return

/obj/machinery/computer/pandemic/attack_ai(mob/user)
	return src.attack_hand(user)

/obj/machinery/computer/pandemic/attack_paw(mob/user)
	return src.attack_hand(user)

/obj/machinery/computer/pandemic/attack_hand(mob/user)
	if(stat & (NOPOWER|BROKEN))
		return
	user.set_machine(src)
	var/dat = ""
	if(src.temphtml)
		dat = "[src.temphtml]<BR><BR><A href='byond://?src=\ref[src];clear=1'>Main Menu</A>"
	else if(!beaker)
		dat += "Please insert beaker.<BR>"
		dat += "<A href='byond://?src=\ref[user];mach_close=pandemic'>Close</A>"
	else
		var/datum/reagents/R = beaker.reagents
		var/datum/reagent/blood/Blood = null
		for(var/datum/reagent/blood/B in R.reagent_list)
			if(B)
				Blood = B
				break
		if(!R.total_volume || !length(R.reagent_list))
			dat += "The beaker is empty<BR>"
		else if(!Blood)
			dat += "No blood sample found in beaker"
		else if(!Blood.data)
			dat += "No blood data found in beaker."
		else
			dat += "<h3>Blood sample data:</h3>"
			dat += "<b>Blood DNA:</b> [(Blood.data["blood_DNA"]||"none")]<BR>"
			dat += "<b>Blood Type:</b> [(Blood.data["blood_type"]||"none")]<BR>"

			if(Blood.data["viruses"])
				var/list/vir = Blood.data["viruses"]
				if(length(vir))
					for(var/datum/disease/D in Blood.data["viruses"])
						if(!D.hidden[PANDEMIC])

							var/disease_creation = D.type
							if(istype(D, /datum/disease/advance))

								var/datum/disease/advance/A = D
								D = archive_diseases[A.GetDiseaseID()]
								disease_creation = A.GetDiseaseID()
								if(D.name == "Unknown")
									dat += "<b><a href='byond://?src=\ref[src];name_disease=[A.GetDiseaseID()]'>Name Disease</a></b><BR>"

							if(!D)
								CRASH("We weren't able to get the advance disease from the archive.")

							dat += "<b>Disease Agent:</b> [D?"[D.agent] - <A href='byond://?src=\ref[src];create_virus_culture=[disease_creation]'>Create virus culture bottle</A>":"none"]<BR>"
							dat += "<b>Common name:</b> [(D.name||"none")]<BR>"
							dat += "<b>Description: </b> [(D.desc||"none")]<BR>"
							dat += "<b>Spread:</b> [(D.spread||"none")]<BR>"
							dat += "<b>Possible cure:</b> [(D.cure||"none")]<BR><BR>"

							if(istype(D, /datum/disease/advance))
								var/datum/disease/advance/A = D
								dat += "<b>Symptoms:</b> "
								var/english_symptoms = list()
								for(var/datum/symptom/S in A.symptoms)
									english_symptoms += S.name
								dat += english_list(english_symptoms)

			dat += "<BR><b>Contains antibodies to:</b> "
			if(Blood.data["resistances"])
				var/list/res = Blood.data["resistances"]
				if(length(res))
					dat += "<ul>"
					for(var/type in Blood.data["resistances"])
						var/disease_name = "Unknown"

						if(!ispath(type))
							var/datum/disease/advance/A = archive_diseases[type]
							if(A)
								disease_name = A.name
						else
							var/datum/disease/D = new type(0, null)
							disease_name = D.name

						dat += "<li>[disease_name] - <A href='byond://?src=\ref[src];create_vaccine=[type]'>Create vaccine bottle</A></li>"
					dat += "</ul><BR>"
				else
					dat += "nothing<BR>"
			else
				dat += "nothing<BR>"
		dat += "<BR><A href='byond://?src=\ref[src];eject=1'>Eject beaker</A>[(R.total_volume && length(R.reagent_list) ? "-- <A href='byond://?src=\ref[src];empty_beaker=1'>Empty beaker</A>" : "")]<BR>"
		dat += "<A href='byond://?src=\ref[user];mach_close=pandemic'>Close</A>"

	user << browse("<TITLE>[src.name]</TITLE><BR>[dat]", "window=pandemic;size=575x400")
	onclose(user, "pandemic")
	return

/obj/machinery/computer/pandemic/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/reagent_holder/glass))
		if(stat & (NOPOWER | BROKEN))
			return TRUE
		if(isnotnull(beaker))
			to_chat(user, SPAN_WARNING("A beaker is already loaded into the machine."))
			return TRUE

		beaker = I
		user.drop_item()
		I.forceMove(src)
		to_chat(user, SPAN_INFO("You add the beaker to the machine!"))
		updateUsrDialog()
		icon_state = "mixer1"
		return TRUE

	return ..()

////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
/obj/machinery/reagentgrinder
	name = "All-In-One Grinder"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "juicer1"
	layer = 2.9
	density = TRUE
	anchored = TRUE

	power_usage = alist(
		USE_POWER_IDLE = 5,
		USE_POWER_ACTIVE = 100
	)

	var/inuse = 0
	var/obj/item/reagent_holder/beaker = null
	var/limit = 10
	var/list/blend_items = list (
		//Sheets
		/obj/item/stack/sheet/plasma = list("plasma" = 20),
		/obj/item/stack/sheet/uranium = list("uranium" = 20),
		/obj/item/stack/sheet/bananium = list("banana" = 20),
		/obj/item/stack/sheet/silver = list("silver" = 20),
		/obj/item/stack/sheet/gold = list("gold" = 20),
		/obj/item/grown/nettle = list("sacid" = 0),
		/obj/item/grown/deathnettle = list("pacid" = 0),

		//Blender Stuff
		/obj/item/reagent_holder/food/snacks/grown/soybeans = list("soymilk" = 0),
		/obj/item/reagent_holder/food/snacks/grown/tomato = list("ketchup" = 0),
		/obj/item/reagent_holder/food/snacks/grown/corn = list("cornoil" = 0),
		///obj/item/reagent_holder/food/snacks/grown/wheat = list("flour" = -5),
		/obj/item/reagent_holder/food/snacks/grown/ricestalk = list("rice" = -5),
		/obj/item/reagent_holder/food/snacks/grown/cherries = list("cherryjelly" = 0),
		/obj/item/reagent_holder/food/snacks/grown/plastellium = list("plasticide" = 5),

		//archaeology!
		/obj/item/rocksliver = list("ground_rock" = 50),

		//All types that you can put into the grinder to transfer the reagents to the beaker. !Put all recipes above this.!
		/obj/item/reagent_holder/pill = list(),
		/obj/item/reagent_holder/food = list()
	)

	var/list/juice_items = list (
		//Juicer Stuff
		/obj/item/reagent_holder/food/snacks/grown/tomato = list("tomatojuice" = 0),
		/obj/item/reagent_holder/food/snacks/grown/carrot = list("carrotjuice" = 0),
		/obj/item/reagent_holder/food/snacks/grown/berries = list("berryjuice" = 0),
		/obj/item/reagent_holder/food/snacks/grown/banana = list("banana" = 0),
		/obj/item/reagent_holder/food/snacks/grown/potato = list("potato" = 0),
		/obj/item/reagent_holder/food/snacks/grown/lemon = list("lemonjuice" = 0),
		/obj/item/reagent_holder/food/snacks/grown/orange = list("orangejuice" = 0),
		/obj/item/reagent_holder/food/snacks/grown/lime = list("limejuice" = 0),
		/obj/item/reagent_holder/food/snacks/watermelonslice = list("watermelonjuice" = 0),
		/obj/item/reagent_holder/food/snacks/grown/poisonberries = list("poisonberryjuice" = 0),
	)

	var/list/holdingitems = list()

/obj/machinery/reagentgrinder/initialise()
	. = ..()
	beaker = new /obj/item/reagent_holder/glass/beaker/large(src)

/obj/machinery/reagentgrinder/update_icon()
	icon_state = "juicer" + num2text(isnotnull(beaker))
	return


/obj/machinery/reagentgrinder/attackby(obj/item/O, mob/user)

	if(istype(O, /obj/item/reagent_holder/glass) || \
		istype(O, /obj/item/reagent_holder/food/drinks/drinkingglass) || \
		istype(O, /obj/item/reagent_holder/food/drinks/shaker))

		if(beaker)
			return 1
		else
			src.beaker =  O
			user.drop_item()
			O.forceMove(src)
			update_icon()
			src.updateUsrDialog()
			return 0

	if(length(holdingitems) >= limit)
		to_chat(usr, "The machine cannot hold anymore items.")
		return 1

	//Fill machine with the plantbag!
	if(istype(O, /obj/item/storage/bag/plants))
		for(var/obj/item/reagent_holder/food/snacks/grown/G in O.contents)
			O.contents -= G
			G.forceMove(src)
			holdingitems += G
			if(length(holdingitems) >= limit) //Sanity checking so the blender doesn't overfill
				to_chat(user, "You fill the All-In-One grinder to the brim.")
				break

		if(!length(O.contents))
			to_chat(user, "You empty the plant bag into the All-In-One grinder.")

		src.updateUsrDialog()
		return 0

	if(!is_type_in_list(O, blend_items) && !is_type_in_list(O, juice_items))
		to_chat(user, "Cannot refine into a reagent.")
		return 1

	user.before_take_item(O)
	O.forceMove(src)
	holdingitems += O
	src.updateUsrDialog()
	return 0

/obj/machinery/reagentgrinder/attack_paw(mob/user)
	return src.attack_hand(user)

/obj/machinery/reagentgrinder/attack_ai(mob/user)
	return 0

/obj/machinery/reagentgrinder/attack_hand(mob/user)
	user.set_machine(src)
	interact(user)

/obj/machinery/reagentgrinder/interact(mob/user) // The microwave Menu
	var/is_chamber_empty = 0
	var/is_beaker_ready = 0
	var/processing_chamber = ""
	var/beaker_contents = ""
	var/dat = ""

	if(!inuse)
		for(var/obj/item/O in holdingitems)
			processing_chamber += "\A [O.name]<BR>"

		if(!processing_chamber)
			is_chamber_empty = 1
			processing_chamber = "Nothing."
		if(!beaker)
			beaker_contents = "<B>No beaker attached.</B><br>"
		else
			is_beaker_ready = 1
			beaker_contents = "<B>The beaker contains:</B><br>"
			var/anything = 0
			for(var/datum/reagent/R in beaker.reagents.reagent_list)
				anything = 1
				beaker_contents += "[R.volume] - [R.name]<br>"
			if(!anything)
				beaker_contents += "Nothing<br>"


		dat = {"
	<b>Processing chamber contains:</b><br>
	[processing_chamber]<br>
	[beaker_contents]<hr>
	"}
		if(is_beaker_ready && !is_chamber_empty && !(stat & (NOPOWER|BROKEN)))
			dat += "<A href='byond://?src=\ref[src];action=grind'>Grind the reagents</a><BR>"
			dat += "<A href='byond://?src=\ref[src];action=juice'>Juice the reagents</a><BR><BR>"
		if(length(holdingitems))
			dat += "<A href='byond://?src=\ref[src];action=eject'>Eject the reagents</a><BR>"
		if(beaker)
			dat += "<A href='byond://?src=\ref[src];action=detach'>Detach the beaker</a><BR>"
	else
		dat += "Please wait..."
	user << browse("<HEAD><TITLE>All-In-One Grinder</TITLE></HEAD><TT>[dat]</TT>", "window=reagentgrinder")
	onclose(user, "reagentgrinder")
	return


/obj/machinery/reagentgrinder/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	switch(href_list["action"])
		if ("grind")
			grind()
		if("juice")
			juice()
		if("eject")
			eject()
		if ("detach")
			detach()
	src.updateUsrDialog()
	return

/obj/machinery/reagentgrinder/proc/detach()
	if(usr.stat != 0)
		return
	if(!beaker)
		return
	beaker.forceMove(loc)
	beaker = null
	update_icon()

/obj/machinery/reagentgrinder/proc/eject()
	if(usr.stat != 0)
		return
	if(!length(holdingitems))
		return

	for(var/obj/item/O in holdingitems)
		O.forceMove(loc)
		holdingitems -= O
	holdingitems = list()

/obj/machinery/reagentgrinder/proc/is_allowed(obj/item/reagent_holder/O)
	for(var/i in blend_items)
		if(istype(O, i))
			return 1
	return 0

/obj/machinery/reagentgrinder/proc/get_allowed_by_id(obj/item/grown/O)
	for(var/i in blend_items)
		if(istype(O, i))
			return blend_items[i]

/obj/machinery/reagentgrinder/proc/get_allowed_snack_by_id(obj/item/reagent_holder/food/snacks/O)
	for(var/i in blend_items)
		if(istype(O, i))
			return blend_items[i]

/obj/machinery/reagentgrinder/proc/get_allowed_juice_by_id(obj/item/reagent_holder/food/snacks/O)
	for(var/i in juice_items)
		if(istype(O, i))
			return juice_items[i]

/obj/machinery/reagentgrinder/proc/get_grownweapon_amount(obj/item/grown/O)
	if(!istype(O))
		return 5
	else if(O.potency == -1)
		return 5
	else
		return round(O.potency)

/obj/machinery/reagentgrinder/proc/get_juice_amount(obj/item/reagent_holder/food/snacks/grown/O)
	if(!istype(O))
		return 5
	else if (O.potency == -1)
		return 5
	else
		return round(5*sqrt(O.potency))

/obj/machinery/reagentgrinder/proc/remove_object(obj/item/O)
	holdingitems -= O
	qdel(O)

/obj/machinery/reagentgrinder/proc/juice()
	power_change()
	if(stat & (NOPOWER|BROKEN))
		return
	if(!beaker || (beaker && beaker.reagents.total_volume >= beaker.reagents.maximum_volume))
		return
	playsound(src, 'sound/machines/juicer.ogg', 20, 1)
	inuse = 1
	spawn(50)
		inuse = 0
		interact(usr)

	//Snacks
	for(var/obj/item/reagent_holder/food/snacks/O in holdingitems)
		if(beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
			break

		var/allowed = get_allowed_juice_by_id(O)
		if(isnull(allowed))
			break

		for(var/r_id in allowed)
			var/space = beaker.reagents.maximum_volume - beaker.reagents.total_volume
			var/amount = get_juice_amount(O)

			beaker.reagents.add_reagent(r_id, min(amount, space))

			if(beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
				break

		remove_object(O)

/obj/machinery/reagentgrinder/proc/grind()
	power_change()
	if(stat & (NOPOWER|BROKEN))
		return
	if(!beaker || (beaker && beaker.reagents.total_volume >= beaker.reagents.maximum_volume))
		return
	playsound(src, 'sound/machines/blender.ogg', 50, 1)
	inuse = 1
	spawn(60)
		inuse = 0
		interact(usr)

	//Snacks and Plants
	for(var/obj/item/reagent_holder/food/snacks/O in holdingitems)
		if(beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
			break

		var/allowed = get_allowed_snack_by_id(O)
		if(isnull(allowed))
			break

		for(var/r_id in allowed)

			var/space = beaker.reagents.maximum_volume - beaker.reagents.total_volume
			var/amount = allowed[r_id]
			if(amount <= 0)
				if(amount == 0)
					if(O.reagents != null && O.reagents.has_reagent("nutriment"))
						beaker.reagents.add_reagent(r_id, min(O.reagents.get_reagent_amount("nutriment"), space))
						O.reagents.remove_reagent("nutriment", min(O.reagents.get_reagent_amount("nutriment"), space))
				else
					if(O.reagents != null && O.reagents.has_reagent("nutriment"))
						beaker.reagents.add_reagent(r_id, min(round(O.reagents.get_reagent_amount("nutriment")*abs(amount)), space))
						O.reagents.remove_reagent("nutriment", min(O.reagents.get_reagent_amount("nutriment"), space))

			else
				O.reagents.trans_id_to(beaker, r_id, min(amount, space))

			if(beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
				break

		if(!length(O.reagents.reagent_list))
			remove_object(O)

	//Sheets
	for (var/obj/item/stack/sheet/O in holdingitems)
		var/allowed = get_allowed_by_id(O)
		if(beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
			break
		for(var/i = 1; i <= round(O.amount, 1); i++)
			for(var/r_id in allowed)
				var/space = beaker.reagents.maximum_volume - beaker.reagents.total_volume
				var/amount = allowed[r_id]
				beaker.reagents.add_reagent(r_id,min(amount, space))
				if(space < amount)
					break
			if(i == round(O.amount, 1))
				remove_object(O)
				break

	//Plants
	for(var/obj/item/grown/O in holdingitems)
		if(beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
			break
		var/allowed = get_allowed_by_id(O)
		for(var/r_id in allowed)
			var/space = beaker.reagents.maximum_volume - beaker.reagents.total_volume
			var/amount = allowed[r_id]
			if(amount == 0)
				if(O.reagents != null && O.reagents.has_reagent(r_id))
					beaker.reagents.add_reagent(r_id,min(O.reagents.get_reagent_amount(r_id), space))
			else
				beaker.reagents.add_reagent(r_id,min(amount, space))

			if(beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
				break
		remove_object(O)

	//xenoarch
	for(var/obj/item/rocksliver/O in holdingitems)
		if(beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
			break
		var/allowed = get_allowed_by_id(O)
		for(var/r_id in allowed)
			var/space = beaker.reagents.maximum_volume - beaker.reagents.total_volume
			var/amount = allowed[r_id]
			beaker.reagents.add_reagent(r_id,min(amount, space), O.geological_data)

			if(beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
				break
		remove_object(O)

	//Everything else - Transfers reagents from it into beaker
	for(var/obj/item/reagent_holder/O in holdingitems)
		if(beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
			break
		var/amount = O.reagents.total_volume
		O.reagents.trans_to(beaker, amount)
		if(!O.reagents.total_volume)
			remove_object(O)

#undef MAX_PILL_SPRITE
#undef MAX_BOTTLE_SPRITE