////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Depth scanner - scans rock turfs / boulders and tells players if there is anything interesting inside, logs all finds + coordinates + times
//also known as the x-ray diffractor
/obj/item/depth_scanner
	name = "depth analysis scanner"
	desc = "Used to check spatial depth and density of rock outcroppings."
	icon = 'icons/obj/items/devices/pda.dmi'
	icon_state = "crap"
	item_state = "analyser"
	w_class = 1.0
	slot_flags = SLOT_BELT

	var/list/positive_locations = list()
	var/datum/depth_scan/current

/datum/depth_scan
	var/time = ""
	var/coords = ""
	var/depth = 0
	var/clearance = 0
	var/record_index = 1
	var/dissonance_spread = 1
	var/material = "unknown"

/obj/item/depth_scanner/proc/scan_atom(mob/user, atom/A)
	user.visible_message(SPAN_INFO("[user] scans [A], the air around them humming gently."))
	if(istype(A, /turf/closed/rock))
		var/turf/closed/rock/M = A
		if(length(M.finds) || M.artifact_find)
			//create a new scanlog entry
			var/datum/depth_scan/D = new()
			D.coords = "[M.x].[rand(0, 9)]:[M.y].[rand(0, 9)]:[10 * M.z].[rand(0, 9)]"
			D.time = worldtime2text()
			D.record_index = length(positive_locations) + 1
			D.material = istype(M.ore) ? lowertext(M.ore.name) : "rock"

			//find the first artifact and store it
			if(length(M.finds))
				var/datum/find/F = M.finds[1]
				D.depth = F.excavation_required * 2		//0-100% and 0-200cm
				D.clearance = F.clearance_range * 2
				D.material = get_responsive_reagent(F.find_type)

			positive_locations.Add(D)

			for(var/mob/L in range(src, 1))
				to_chat(L, SPAN_INFO("[icon2html(src, L)] [src] pings."))

	else if(istype(A,/obj/structure/boulder))
		var/obj/structure/boulder/B = A
		if(B.artifact_find)
			//create a new scanlog entry
			var/datum/depth_scan/D = new()
			D.coords = "[10 * B.x].[rand(0, 9)]:[10 * B.y].[rand(0, 9)]:[10 * B.z].[rand(0, 9)]"
			D.time = worldtime2text()
			D.record_index = length(positive_locations) + 1

			//these values are arbitrary
			D.depth = rand(75, 100)
			D.clearance = rand(5, 25)
			D.dissonance_spread = rand(750, 2500) / 100

			positive_locations.Add(D)

			for(var/mob/L in range(src, 1))
				to_chat(L, SPAN_INFO("[icon2html(src, L)] [src] pings [pick("madly", "wildly", "excitedly", "crazily")]!."))

/obj/item/depth_scanner/attack_self(mob/user)
	return src.interact(user)

/obj/item/depth_scanner/interact(mob/user)
	var/dat = "<b>Co-ordinates with positive matches</b><br>"
	dat += "<A href='byond://?src=\ref[src];clear=0'>== Clear all ==</a><br>"
	if(current)
		dat += "Time: [current.time]<br>"
		dat += "Coords: [current.coords]<br>"
		dat += "Anomaly depth: [current.depth] cm<br>"
		dat += "Clearance above anomaly depth: [current.clearance] cm<br>"
		dat += "Dissonance spread: [current.dissonance_spread]<br>"
		var/index = responsive_carriers.Find(current.material)
		if(index > 0 && index <= length(finds_as_strings))
			dat += "Anomaly material: [finds_as_strings[index]]<br>"
		else
			dat += "Anomaly material: Unknown<br>"
		dat += "<A href='byond://?src=\ref[src];clear=[current.record_index]'>clear entry</a><br>"
	else
		dat += "Select an entry from the list<br>"
		dat += "<br>"
		dat += "<br>"
		dat += "<br>"
		dat += "<br>"
	dat += "<hr>"
	if(length(positive_locations))
		for(var/index = 1, index <= length(positive_locations), index++)
			var/datum/depth_scan/D = positive_locations[index]
			dat += "<A href='byond://?src=\ref[src];select=[index]'>[D.time], coords: [D.coords]</a><br>"
	else
		dat += "No entries recorded."
	dat += "<hr>"
	dat += "<A href='byond://?src=\ref[src];refresh=1'>Refresh</a><br>"
	dat += "<A href='byond://?src=\ref[src];close=1'>Close</a><br>"
	SHOW_BROWSER(user, dat,"window=depth_scanner;size=300x500")
	onclose(user, "depth_scanner")

/obj/item/depth_scanner/Topic(href, href_list)
	..()
	usr.set_machine(src)

	if(href_list["select"])
		var/index = text2num(href_list["select"])
		if(index && index <= length(positive_locations))
			current = positive_locations[index]
	else if(href_list["clear"])
		var/index = text2num(href_list["clear"])
		if(index)
			if(index <= length(positive_locations))
				var/datum/depth_scan/D = positive_locations[index]
				positive_locations.Remove(D)
				qdel(D)
		else
			//GC will hopefully pick them up before too long
			positive_locations = list()
			qdel(current)
	else if(href_list["close"])
		usr.unset_machine()
		CLOSE_BROWSER(usr, "window=depth_scanner")

	updateSelfDialog()