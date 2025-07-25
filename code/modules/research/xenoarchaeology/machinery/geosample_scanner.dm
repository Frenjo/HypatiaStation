/obj/machinery/radiocarbon_spectrometer
	name = "radiocarbon spectrometer"
	desc = "A specialised, complex scanner for gleaning information on all manner of small things."
	anchored = TRUE
	density = TRUE
	icon = 'icons/obj/machines/virology.dmi'
	icon_state = "analyser"

	power_usage = alist(
		USE_POWER_IDLE = 20,
		USE_POWER_ACTIVE = 300
	)

	//var/obj/item/reagent_holder/glass/coolant_container
	var/scanning = 0
	var/report_num = 0
	//
	var/obj/item/scanned_item
	var/last_scan_data = "No scans on record."
	//
	var/last_process_worldtime = 0
	//
	var/scanner_progress = 0
	var/scanner_rate = 1.25			//80 seconds per scan
	var/scanner_rpm = 0
	var/scanner_rpm_dir = 1
	var/scanner_temperature = 0
	var/scanner_seal_integrity = 100
	//
	var/coolant_usage_rate = 0		//measured in u/microsec
	var/fresh_coolant = 0
	var/coolant_purity = 0
	var/datum/reagents/coolant_reagents
	var/used_coolant = 0
	var/list/coolant_reagents_purity = list()
	//
	var/maser_wavelength = 0
	var/optimal_wavelength = 0
	var/optimal_wavelength_target = 0
	var/tleft_retarget_optimal_wavelength = 0
	var/maser_efficiency = 0
	//
	var/radiation = 0				//0-100 mSv
	var/t_left_radspike = 0
	var/rad_shield = 0

/obj/machinery/radiocarbon_spectrometer/initialise()
	. = ..()
	create_reagents(500)
	coolant_reagents_purity[/datum/reagent/water] = 0.5
	coolant_reagents_purity[/datum/reagent/drink/coffee/icecoffee] = 0.6
	coolant_reagents_purity[/datum/reagent/drink/tea/icetea] = 0.6
	coolant_reagents_purity[/datum/reagent/drink/cold/milkshake] = 0.6
	coolant_reagents_purity[/datum/reagent/leporazine] = 0.7
	coolant_reagents_purity[/datum/reagent/kelotane] = 0.7
	coolant_reagents_purity[/datum/reagent/sterilizine] = 0.7
	coolant_reagents_purity[/datum/reagent/dermaline] = 0.7
	coolant_reagents_purity[/datum/reagent/hyperzine] = 0.8
	coolant_reagents_purity[/datum/reagent/cryoxadone] = 0.9
	coolant_reagents_purity[/datum/reagent/coolant] = 1
	coolant_reagents_purity[/datum/reagent/adminordrazine] = 2

/obj/machinery/radiocarbon_spectrometer/attack_hand(mob/user)
	ui_interact(user)

/obj/machinery/radiocarbon_spectrometer/attack_by(obj/item/I, mob/user)
	if(scanning)
		to_chat(user, SPAN_WARNING("You can't do that while \the [src] is scanning!"))
		return TRUE

	if(istype(I, /obj/item/stack/nanopaste))
		var/choice = alert("What do you want to do with \the [I]?", "Radiometric Scanner", "Scan Item", "Fix Seal Integrity")
		if(choice == "Fix Seal Integrity")
			var/obj/item/stack/nanopaste/N = I
			var/amount_used = min(N.amount, 10 - scanner_seal_integrity / 10)
			N.use(amount_used)
			scanner_seal_integrity = round(scanner_seal_integrity + amount_used * 10)
		else
			if(isnull(scanned_item))
				scan_item(I)
		return TRUE

	if(istype(I, /obj/item/reagent_holder/glass))
		var/choice = alert("What do you want to do with \the [I]?", "Radiometric Scanner", "Add Coolant", "Empty Coolant", "Scan Item")
		switch(choice)
			if("Add Coolant")
				var/obj/item/reagent_holder/glass/G = I
				var/amount_transferred = min(reagents.maximum_volume - reagents.total_volume, G.reagents.total_volume)
				G.reagents.trans_to(src, amount_transferred)
				to_chat(user, SPAN_INFO("You empty [amount_transferred]u of coolant into \the [src]."))
				update_coolant()
			if("Empty Coolant")
				var/obj/item/reagent_holder/glass/G = I
				var/amount_transferred = min(G.reagents.maximum_volume - G.reagents.total_volume, reagents.total_volume)
				reagents.trans_to(G, amount_transferred)
				to_chat(user, SPAN_INFO("You remove [amount_transferred]u of coolant from \the [src]."))
				update_coolant()
			else
				if(isnull(scanned_item))
					scan_item(I)
		return TRUE

	if(isnull(scanned_item))
		scan_item(I)
		return TRUE

	return ..()

/obj/machinery/radiocarbon_spectrometer/proc/scan_item(obj/item/item_to_scan, mob/item_holder)
	item_holder.drop_item()
	item_to_scan.forceMove(src)
	scanned_item = item_to_scan

/obj/machinery/radiocarbon_spectrometer/proc/update_coolant()
	var/total_purity = 0
	fresh_coolant = 0
	coolant_purity = 0
	var/num_reagent_types = 0
	for(var/datum/reagent/current_reagent in src.reagents.reagent_list)
		if(!current_reagent)
			continue
		var/cur_purity = coolant_reagents_purity[current_reagent.type]
		if(!cur_purity)
			cur_purity = 0.1
		else if(cur_purity > 1)
			cur_purity = 1
		total_purity += cur_purity * current_reagent.volume
		fresh_coolant += current_reagent.volume
		num_reagent_types += 1
	if(total_purity && fresh_coolant)
		coolant_purity = total_purity / fresh_coolant

/obj/machinery/radiocarbon_spectrometer/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null)
	if(user.stat)
		return

	var/has_scanned_item = isnotnull(scanned_item)
	// this is the data which will be sent to the ui
	var/alist/data = alist(
		"scanned_item" = has_scanned_item ? scanned_item.name : "",
		"scanned_item_desc" = has_scanned_item ? (scanned_item.desc ? scanned_item.desc : "No information on record.") : "",
		"last_scan_data" = last_scan_data,
		//
		"scan_progress" = round(scanner_progress),
		"scanning" = scanning,
		//
		"scanner_seal_integrity" = round(scanner_seal_integrity),
		"scanner_rpm" = round(scanner_rpm),
		"scanner_temperature" = round(scanner_temperature),
		//
		"coolant_usage_rate" = coolant_usage_rate,
		"unused_coolant_abs" = round(fresh_coolant),
		"unused_coolant_per" = round(fresh_coolant / reagents.maximum_volume * 100),
		"coolant_purity" = coolant_purity * 100,
		//
		"optimal_wavelength" = round(optimal_wavelength),
		"maser_wavelength" = round(maser_wavelength),
		"maser_efficiency" = round(maser_efficiency * 100),
		//
		"radiation" = round(radiation),
		"t_left_radspike" = round(t_left_radspike),
		"rad_shield_on" = rad_shield
	)

	// update the ui if it exists, returns null if no ui is passed/found
	ui = global.PCnanoui.try_update_ui(user, src, ui_key, ui, data)
	if(isnull(ui))
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new /datum/nanoui(user, src, ui_key, "geoscanner.tmpl", "High Res Radiocarbon Spectrometer", 900, 825)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update()

/obj/machinery/radiocarbon_spectrometer/process()
	if(scanning)
		if(!scanned_item || scanned_item.loc != src)
			scanned_item = null
			stop_scanning()
		else if(scanner_progress >= 100)
			complete_scan()
		else
			//calculate time difference
			var/deltaT = (world.time - last_process_worldtime) * 0.1

			//modify the RPM over time
			//i want 1u to last for 10 sec at 500 RPM, scaling linearly
			scanner_rpm += scanner_rpm_dir * 50 * deltaT
			if(scanner_rpm > 1000)
				scanner_rpm = 1000
				scanner_rpm_dir = -1 * pick(0.5, 2.5, 5.5)
			else if(scanner_rpm < 1)
				scanner_rpm = 1
				scanner_rpm_dir = 1 * pick(0.5, 2.5, 5.5)

			//heat up according to RPM
			//each unit of coolant
			scanner_temperature += scanner_rpm * deltaT * 0.05

			//radiation
			t_left_radspike -= deltaT
			if(t_left_radspike > 0)
				//ordinary radiation
				radiation = rand() * 15
			else
				//radspike
				if(t_left_radspike > -5)
					radiation = rand() * 15 + 85
					if(!rad_shield)
						//irradiate nearby mobs
						for(var/mob/living/M in view(7,src))
							M.apply_effect(radiation / 25, IRRADIATE, 0)
				else
					t_left_radspike = pick(10,15,25)

			//use some coolant to cool down
			if(coolant_usage_rate > 0)
				var/coolant_used = min(fresh_coolant, coolant_usage_rate * deltaT)
				if(coolant_used > 0)
					fresh_coolant -= coolant_used
					used_coolant += coolant_used
					scanner_temperature = max(scanner_temperature - coolant_used * coolant_purity * 20, 0)

			//modify the optimal wavelength
			tleft_retarget_optimal_wavelength -= deltaT
			if(tleft_retarget_optimal_wavelength <= 0)
				tleft_retarget_optimal_wavelength = pick(4,8,15)
				optimal_wavelength_target = rand() * 9900 + 100
			//
			if(optimal_wavelength < optimal_wavelength_target)
				optimal_wavelength = min(optimal_wavelength + 700 * deltaT, optimal_wavelength_target)
			else if(optimal_wavelength > optimal_wavelength_target)
				optimal_wavelength = max(optimal_wavelength - 700 * deltaT, optimal_wavelength_target)
			//
			maser_efficiency = 1 - max(min(10000, abs(optimal_wavelength - maser_wavelength) * 3), 1) / 10000

			//make some scan progress
			if(!rad_shield)
				scanner_progress = min(100, scanner_progress + scanner_rate * maser_efficiency * deltaT)

				//degrade the seal over time according to temperature
				//i want temperature of 50K to degrade at 1%/sec
				scanner_seal_integrity -= (max(scanner_temperature, 1) / 1000) * deltaT

			//emergency stop if seal integrity reaches 0
			if(scanner_seal_integrity <= 0 || (scanner_temperature >= 1273 && !rad_shield))
				stop_scanning()
				src.visible_message(SPAN_INFO("\icon[src] buzzes unhappily. It has failed mid-scan!"), 2)

			if(prob(5))
				src.visible_message(SPAN_INFO("\icon[src] [pick("whirrs", "chuffs", "clicks")][pick(" excitedly", " energetically", " busily")]."), 2)
	else
		//gradually cool down over time
		if(scanner_temperature > 0)
			scanner_temperature = max(scanner_temperature - 5 - 10 * rand(), 0)
		if(prob(0.75))
			src.visible_message(SPAN_INFO("\icon[src] [pick("plinks", "hisses")][pick(" quietly", " softly", " sadly", " plaintively")]."), 2)
	last_process_worldtime = world.time

/obj/machinery/radiocarbon_spectrometer/proc/stop_scanning()
	scanning = 0
	scanner_rpm_dir = 1
	scanner_rpm = 0
	optimal_wavelength = 0
	maser_efficiency = 0
	maser_wavelength = 0
	coolant_usage_rate = 0
	radiation = 0
	t_left_radspike = 0
	if(used_coolant)
		src.reagents.remove_any(used_coolant)
		used_coolant = 0

/obj/machinery/radiocarbon_spectrometer/proc/complete_scan()
	src.visible_message(SPAN_INFO("\icon[src] makes an insistent chime."), 2)

	if(scanned_item)
		//create report
		var/obj/item/paper/P = new(src)
		P.name = "[src] report #[++report_num]: [scanned_item.name]"
		P.stamped = list(/obj/item/stamp)
		P.overlays = list("paper_stamped")

		//work out data
		var/data = " - Mundane object: [scanned_item.desc ? scanned_item.desc : "No information on record."]<br>"
		var/datum/geosample/G
		switch(scanned_item.type)
			if(/obj/item/ore)
				var/obj/item/ore/O = scanned_item
				if(O.geologic_data)
					G = O.geologic_data

			if(/obj/item/rocksliver)
				var/obj/item/rocksliver/O = scanned_item
				if(O.geological_data)
					G = O.geological_data

			if(/obj/item/archaeological_find)
				data = " - Mundane object (archaic xenos origins)<br>"

				var/obj/item/archaeological_find/A = scanned_item
				if(A.speaking_to_players)
					data = " - Exhibits properties consistent with sonic reproduction.<br>"
				if(A.listening_to_players)
					data = " - Exhibits properties similar to audio capture technology.<br>"

		var/anom_found = 0
		if(G)
			data = " - Spectometric analysis on mineral sample has determined type [finds_as_strings[responsive_carriers.Find(G.source_mineral)]]<br>"
			if(G.age_billion > 0)
				data += " - Radiometric dating shows age of [G.age_billion].[G.age_million] billion years<br>"
			else if(G.age_million > 0)
				data += " - Radiometric dating shows age of [G.age_million].[G.age_thousand] million years<br>"
			else
				data += " - Radiometric dating shows age of [G.age_thousand * 1000 + G.age] years<br>"
			data += " - Chromatographic analysis shows the following materials present:<br>"
			for(var/carrier in G.find_presence)
				if(G.find_presence[carrier])
					var/index = responsive_carriers.Find(carrier)
					if(index > 0 && index <= length(finds_as_strings))
						data += "	> [100 * G.find_presence[carrier]]% [finds_as_strings[index]]<br>"

			if(G.artifact_id && G.artifact_distance >= 0)
				anom_found = 1
				data += " - Hyperspectral imaging reveals exotic energy wavelength detected with ID: [G.artifact_id]<br>"
				data += " - Fourier transform analysis on anomalous energy absorption indicates energy source located inside emission radius of [G.artifact_distance]m<br>"

		if(!anom_found)
			data += " - No anomalous data<br>"

		P.info = "<b>[src] analysis report #[report_num]</b><br>"
		P.info += "<b>Scanned item:</b> [scanned_item.name]<br><br>" + data
		last_scan_data = P.info
		P.forceMove(loc)

		scanned_item.forceMove(loc)
		scanned_item = null

/obj/machinery/radiocarbon_spectrometer/Topic(href, href_list)
	if(stat & (NOPOWER | BROKEN))
		return 0 // don't update UIs attached to this object

	if(href_list["scanItem"])
		if(scanning)
			stop_scanning()
		else
			if(scanned_item)
				if(scanner_seal_integrity > 0)
					scanner_progress = 0
					scanning = 1
					t_left_radspike = pick(5, 10, 15)
					to_chat(usr, SPAN_NOTICE("Scan initiated."))
				else
					to_chat(usr, SPAN_WARNING("Could not initiate scan, seal requires replacing."))
			else
				to_chat(usr, SPAN_WARNING("Insert an item to scan."))

	if(href_list["maserWavelength"])
		maser_wavelength = max(min(maser_wavelength + 1000 * text2num(href_list["maserWavelength"]), 10000), 1)

	if(href_list["coolantRate"])
		coolant_usage_rate = max(min(coolant_usage_rate + text2num(href_list["coolantRate"]), 10000), 0)

	if(href_list["toggle_rad_shield"])
		if(rad_shield)
			rad_shield = 0
		else
			rad_shield = 1

	if(href_list["ejectItem"])
		if(scanned_item)
			scanned_item.forceMove(loc)
			scanned_item = null

	add_fingerprint(usr)
	return 1 // update UIs attached to this object