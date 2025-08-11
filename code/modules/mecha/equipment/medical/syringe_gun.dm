// Syringe Gun
/obj/item/mecha_equipment/medical/syringe_gun
	name = "syringe gun"
	desc = "An exosuit-mounted syringe gun with integrated chemical synthesiser. Any contained reagents are held in stasis, so no reactions will occur. \
		(Can be attached to: Medical Exosuits)"
	icon_state = "syringe_gun"
	matter_amounts = /datum/design/mechfab/equipment/syringe_gun::materials
	origin_tech = /datum/design/mechfab/equipment/syringe_gun::req_tech

	equip_cooldown = 1 SECOND
	energy_drain = 10
	equip_range = MECHA_EQUIP_MELEE | MECHA_EQUIP_RANGED

	var/list/syringes
	var/list/known_reagents
	var/list/processed_reagents
	var/max_syringes = 10
	var/max_volume = 75 //max reagent volume
	var/synth_speed = 5 //[num] reagent units per cycle

	var/mode = 0 //0 - fire syringe, 1 - analyse reagents.

/obj/item/mecha_equipment/medical/syringe_gun/initialise()
	. = ..()
	SET_ATOM_FLAGS(src, ATOM_FLAG_NO_REACT)
	syringes = list()
	known_reagents = list(
		"inaprovaline" = "Inaprovaline",
		"anti_toxin" = "Anti-Toxin (Dylovene)"
	)
	processed_reagents = list()
	create_reagents(max_volume)

/obj/item/mecha_equipment/medical/syringe_gun/Destroy()
	STOP_PROCESSING(PCobj, src)
	return ..()

/obj/item/mecha_equipment/medical/syringe_gun/detach()
	STOP_PROCESSING(PCobj, src)
	return ..()

/obj/item/mecha_equipment/medical/syringe_gun/critfail()
	. = ..()
	UNSET_ATOM_FLAGS(src, ATOM_FLAG_NO_REACT)

/obj/item/mecha_equipment/medical/syringe_gun/get_equip_info()
	if(isnull(reagents))
		return ""
	. = "[..()] \[<a href='byond://?src=\ref[src];toggle_mode=1'>[mode ? "Analyse" : "Launch"]</a>\]<br>\[Syringes: [length(syringes)]/[max_syringes] | Reagents: [reagents.total_volume]/[reagents.maximum_volume]\]<br><a href='byond://?src=\ref[src];show_reagents=1'>Reagents list</a>"

/obj/item/mecha_equipment/medical/syringe_gun/action(atom/movable/target)
	if(!..())
		return FALSE
	if(istype(target, /obj/item/reagent_holder/syringe))
		return load_syringe(target)
	if(istype(target, /obj/item/storage))//Loads syringes from boxes
		var/result = FALSE
		for(var/obj/item/reagent_holder/syringe/S in target.contents)
			result = result || load_syringe(S)
		return result
	if(mode)
		return analyse_reagents(target)
	if(!length(syringes))
		occupant_message(SPAN_ALERT("No syringes loaded."))
		return FALSE
	if(reagents.total_volume <= 0)
		occupant_message(SPAN_ALERT("No available reagents to load syringe with."))
		return FALSE

	var/turf/trg = GET_TURF(target)
	var/obj/item/reagent_holder/syringe/S = syringes[1]
	S.forceMove(GET_TURF(chassis))
	reagents.trans_to(S, min(S.volume, reagents.total_volume))
	syringes.Remove(S)
	S.icon = 'icons/obj/chemical.dmi'
	S.icon_state = "syringeproj"
	playsound(chassis, 'sound/items/syringeproj.ogg', 50, 1)
	log_message("Launched [S] from [src], targeting [target].")
	spawn(-1)
		qdel(src) //if src is deleted, still process the syringe
		for(var/i = 0, i < 6, i++)
			if(!S)
				break
			if(step_towards(S, trg))
				var/list/mobs = list()
				for(var/mob/living/carbon/M in S.loc)
					mobs.Add(M)
				var/mob/living/carbon/M = safepick(mobs)
				if(isnotnull(M))
					S.icon_state = initial(S.icon_state)
					S.icon = initial(S.icon)
					S.reagents.trans_to(M, S.reagents.total_volume)
					M.take_organ_damage(2)
					S.visible_message("<span class=\"attack\"> [M] was hit by the syringe!</span>")
					break
				else if(S.loc == trg)
					S.icon_state = initial(S.icon_state)
					S.icon = initial(S.icon)
					S.update_icon()
					break
			else
				S.icon_state = initial(S.icon_state)
				S.icon = initial(S.icon)
				S.update_icon()
				break
			sleep(1)
	start_cooldown()
	return TRUE

/obj/item/mecha_equipment/medical/syringe_gun/process()
	if(..() == PROCESS_KILL)
		return PROCESS_KILL

	var/synth_energy_drain = energy_drain * 10
	if(!length(processed_reagents) || reagents.total_volume >= reagents.maximum_volume || !chassis.has_charge(synth_energy_drain))
		occupant_message(SPAN_ALERT("Reagent processing stopped."))
		log_message("Reagent processing stopped.")
		set_ready_state(TRUE)
		return PROCESS_KILL

	if(anyprob(reliability))
		critfail()
	var/amount = synth_speed / processed_reagents.len
	for(var/reagent in processed_reagents)
		reagents.add_reagent(reagent,amount)
		chassis.use_power(energy_drain)

/obj/item/mecha_equipment/medical/syringe_gun/handle_topic(mob/user, datum/topic_input/topic)
	. = ..()
	if(!.)
		return FALSE

	if(topic.has("toggle_mode"))
		mode = !mode
		update_equip_info()
		return
	if(topic.has("select_reagents"))
		processed_reagents.len = 0
		var/m = 0
		var/message
		for(var/i = 1 to known_reagents.len)
			if(m >= synth_speed)
				break
			var/reagent = topic.get("reagent_[i]")
			if(reagent && (reagent in known_reagents))
				message = "[m ? ", " : null][known_reagents[reagent]]"
				processed_reagents += reagent
				m++
		if(processed_reagents.len)
			message += " added to production"
			START_PROCESSING(PCobj, src)
			occupant_message(message)
			occupant_message("Reagent processing started.")
			log_message("Reagent processing started.")
		return
	if(topic.has("show_reagents"))
		SHOW_BROWSER(chassis.occupant, get_reagents_page(), "window=msyringegun")
		return
	if(topic.has("purge_reagent"))
		var/reagent_type = topic.get_path("purge_reagent")
		if(isnotnull(reagent_type))
			reagents.del_reagent(reagent_type)
		return
	if(topic.has("purge_all"))
		reagents.clear_reagents()
		return

/obj/item/mecha_equipment/medical/syringe_gun/proc/get_reagents_page()
	. = {"<html>
						<head>
						<title>Reagent Synthesizer</title>
						<script language='javascript' type='text/javascript'>
						[js_byjax]
						</script>
						<style>
						h3 {margin-bottom:2px;font-size:14px;}
						#reagents, #reagents_form {}
						form {width: 90%; margin:10px auto; border:1px dotted #999; padding:6px;}
						#submit {margin-top:5px;}
						</style>
						</head>
						<body>
						<h3>Current reagents:</h3>
						<div id="reagents">
						[get_current_reagents()]
						</div>
						<h3>Reagents production:</h3>
						<div id="reagents_form">
						[get_reagents_form()]
						</div>
						</body>
						</html>
						"}

/obj/item/mecha_equipment/medical/syringe_gun/proc/get_reagents_form()
	var/r_list = get_reagents_list()
	var/inputs
	if(r_list)
		inputs += "<input type=\"hidden\" name=\"src\" value=\"\ref[src]\">"
		inputs += "<input type=\"hidden\" name=\"select_reagents\" value=\"1\">"
		inputs += "<input id=\"submit\" type=\"submit\" value=\"Apply settings\">"
	. = {"<form action="byond://" method="get">
						[r_list || "No known reagents"]
						[inputs]
						</form>
						[r_list ? "<span style=\"font-size:80%;\">Only the first [synth_speed] selected reagent\s will be added to production</span>" : null]
						"}

/obj/item/mecha_equipment/medical/syringe_gun/proc/get_reagents_list()
	for(var/i = 1 to known_reagents.len)
		var/reagent_id = known_reagents[i]
		. += {"<input type="checkbox" value="[reagent_id]" name="reagent_[i]" [(reagent_id in processed_reagents) ? "checked=\"1\"" : null]> [known_reagents[reagent_id]]<br />"}

/obj/item/mecha_equipment/medical/syringe_gun/proc/get_current_reagents()
	for(var/datum/reagent/R in reagents.reagent_list)
		if(R.volume > 0)
			. += "[R]: [round(R.volume, 0.001)] - <a href='byond://?src=\ref[src];purge_reagent=[R.type]'>Purge Reagent</a><br />"
	if(.)
		. += "Total: [round(reagents.total_volume, 0.001)] / [reagents.maximum_volume] - <a href='byond://?src=\ref[src];purge_all=1'>Purge All</a>"
	return . || "None"

/obj/item/mecha_equipment/medical/syringe_gun/proc/load_syringe(obj/item/reagent_holder/syringe/S)
	if(length(syringes) < max_syringes)
		if(get_dist(src, S) >= 2)
			occupant_message(SPAN_WARNING("The syringe is too far away."))
			return 0
		for(var/obj/structure/D in S.loc)//Basic level check for structures in the way (Like grilles and windows)
			if(!(D.CanPass(S, loc)))
				occupant_message(SPAN_WARNING("Unable to load syringe."))
				return 0
		for(var/obj/machinery/door/D in S.loc)//Checks for doors
			if(!(D.CanPass(S, loc)))
				occupant_message(SPAN_WARNING("Unable to load syringe."))
				return 0
		S.reagents.trans_to(src, S.reagents.total_volume)
		S.forceMove(src)
		syringes += S
		occupant_message(SPAN_INFO("Syringe loaded."))
		update_equip_info()
		return 1
	occupant_message(SPAN_WARNING("\The [src]'s syringe chamber is full."))
	return 0

/obj/item/mecha_equipment/medical/syringe_gun/proc/analyse_reagents(atom/A)
	if(get_dist(src, A) >= 4)
		occupant_message(SPAN_WARNING("The object is too far away."))
		return 0
	if(!A.reagents || ismob(A))
		occupant_message(SPAN_ALERT("No reagent info gained from \the [A]."))
		return 0
	occupant_message(SPAN_INFO_B("Analysing reagents..."))
	for(var/datum/reagent/R in A.reagents.reagent_list)
		if(R.reagent_state == 2 && add_known_reagent(R.id, R.name))
			occupant_message(SPAN_INFO("Reagent analysed, identified as [R.name] and added to database."))
			send_byjax(chassis.occupant, "msyringegun.browser", "reagents_form", get_reagents_form())
	occupant_message(SPAN_INFO("Analysis complete."))
	return 1

/obj/item/mecha_equipment/medical/syringe_gun/proc/add_known_reagent(r_id, r_name)
	start_cooldown()
	if(!(r_id in known_reagents))
		known_reagents.Add(r_id)
		known_reagents[r_id] = r_name
		return TRUE
	return FALSE

/obj/item/mecha_equipment/medical/syringe_gun/update_equip_info()
	if(..())
		send_byjax(chassis.occupant, "msyringegun.browser", "reagents", get_current_reagents())
		send_byjax(chassis.occupant, "msyringegun.browser", "reagents_form", get_reagents_form())
		return TRUE

/obj/item/mecha_equipment/medical/syringe_gun/on_reagent_change()
	. = ..()
	update_equip_info()