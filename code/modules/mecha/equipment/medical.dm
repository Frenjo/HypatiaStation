// Sleeper
/obj/item/mecha_equipment/medical/sleeper
	name = "mounted sleeper"
	desc = "An exosuit-mounted medical sleeper. (Can be attached to: Medical Exosuits)"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper_0"
	matter_amounts = /datum/design/mechfab/equipment/sleeper::materials
	origin_tech = /datum/design/mechfab/equipment/sleeper::req_tech
	energy_drain = 20
	range = MELEE
	reliability = 1000
	equip_cooldown = 2 SECONDS
	salvageable = FALSE

	var/mob/living/carbon/patient = null
	var/datum/global_iterator/pr_mech_sleeper
	var/inject_amount = 10

/obj/item/mecha_equipment/medical/sleeper/New()
	. = ..()
	pr_mech_sleeper = new /datum/global_iterator/mech_sleeper(list(src), 0)
	pr_mech_sleeper.set_delay(equip_cooldown)

/obj/item/mecha_equipment/medical/sleeper/Destroy()
	var/turf/T = GET_TURF(src)
	for_no_type_check(var/atom/movable/mover, src)
		mover.forceMove(T)
	QDEL_NULL(pr_mech_sleeper)
	patient = null
	return ..()

/obj/item/mecha_equipment/medical/sleeper/allow_drop()
	return FALSE

/obj/item/mecha_equipment/medical/sleeper/Exit(atom/movable/O)
	return FALSE

/obj/item/mecha_equipment/medical/sleeper/action(mob/living/carbon/target)
	if(!action_checks(target))
		return
	if(!istype(target))
		return
	if(target.buckled)
		occupant_message(SPAN_WARNING("[target] will not fit into the sleeper because they are buckled to [target.buckled]."))
		return
	if(isnotnull(patient))
		occupant_message(SPAN_WARNING("The sleeper is already occupied"))
		return
	for(var/mob/living/carbon/slime/M in range(1, target))
		if(M.Victim == target)
			occupant_message(SPAN_WARNING("[target] will not fit into the sleeper because they have a slime latched onto their head."))
			return
	occupant_message(SPAN_INFO("You start putting \the [target] into \the [src]."))
	chassis.visible_message("[chassis] starts putting \the [target] into the \the [src].")
	var/C = chassis.loc
	var/T = target.loc
	if(do_after_cooldown(target))
		if(chassis.loc != C || target.loc != T)
			return
		if(isnotnull(patient))
			occupant_message(SPAN_WARNING("The sleeper is already occupied!"))
			return
		target.forceMove(src)
		patient = target
		target.reset_view(src)
		/*
		if(target.client)
			target.client.perspective = EYE_PERSPECTIVE
			target.client.eye = chassis
		*/
		set_ready_state(0)
		pr_mech_sleeper.start()
		occupant_message(SPAN_INFO("[target] successfully loaded into \the [src]. Life support functions engaged."))
		chassis.visible_message(SPAN_INFO("[chassis] loads \the [target] into \the [src]."))
		log_message("[target] loaded. Life support functions engaged.")

/obj/item/mecha_equipment/medical/sleeper/proc/go_out()
	if(isnull(patient))
		return
	patient.forceMove(GET_TURF(src))
	occupant_message(SPAN_INFO("[patient] ejected. Life support functions disabled."))
	log_message(SPAN_INFO("[patient] ejected. Life support functions disabled."))
	patient.reset_view()
	/*
	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	*/
	patient = null
	pr_mech_sleeper.stop()
	set_ready_state(1)

/obj/item/mecha_equipment/medical/sleeper/detach()
	if(isnotnull(patient))
		occupant_message(SPAN_WARNING("Unable to detach \the [src] - equipment occupied."))
		return
	pr_mech_sleeper.stop()
	return ..()

/obj/item/mecha_equipment/medical/sleeper/get_equip_info()
	. = ..()
	if(isnull(patient))
		return
	. += "<br>\[Occupant: [patient] (Health: [patient.health]%)\]<br /><a href='byond://?src=\ref[src];view_stats=1'>View stats</a>|<a href='byond://?src=\ref[src];eject=1'>Eject</a>"

/obj/item/mecha_equipment/medical/sleeper/Topic(href, href_list)
	. = ..()
	var/datum/topic_input/topic_filter = new /datum/topic_input(href, href_list)
	if(topic_filter.get("eject"))
		go_out()
	if(topic_filter.get("view_stats"))
		chassis.occupant << browse(get_patient_stats(),"window=msleeper")
		onclose(chassis.occupant, "msleeper")
		return
	if(topic_filter.get("inject"))
		inject_reagent(topic_filter.getType("inject", /datum/reagent), topic_filter.getObj("source"))

/obj/item/mecha_equipment/medical/sleeper/proc/get_patient_stats()
	if(isnull(patient))
		return
	return {"<html>
				<head>
				<title>[patient] statistics</title>
				<script language='javascript' type='text/javascript'>
				[js_byjax]
				</script>
				<style>
				h3 {margin-bottom:2px;font-size:14px;}
				#lossinfo, #reagents, #injectwith {padding-left:15px;}
				</style>
				</head>
				<body>
				<h3>Health statistics</h3>
				<div id="lossinfo">
				[get_patient_dam()]
				</div>
				<h3>Reagents in bloodstream</h3>
				<div id="reagents">
				[get_patient_reagents()]
				</div>
				<div id="injectwith">
				[get_available_reagents()]
				</div>
				</body>
				</html>"}

/obj/item/mecha_equipment/medical/sleeper/proc/get_patient_dam()
	var/t1
	switch(patient.stat)
		if(0)
			t1 = "Conscious"
		if(1)
			t1 = "Unconscious"
		if(2)
			t1 = "*dead*"
		else
			t1 = "Unknown"
	return {"<font color="[patient.health > 50 ? "blue" : "red"]"><b>Health:</b> [patient.health]% ([t1])</font><br />
				<font color="[patient.bodytemperature > 50 ? "blue" : "red"]"><b>Core Temperature:</b> [patient.bodytemperature-T0C]&deg;C ([patient.bodytemperature*1.8-459.67]&deg;F)</font><br />
				<font color="[patient.getBruteLoss() < 60 ? "blue" : "red"]"><b>Brute Damage:</b> [patient.getBruteLoss()]%</font><br />
				<font color="[patient.getOxyLoss() < 60 ? "blue" : "red"]"><b>Respiratory Damage:</b> [patient.getOxyLoss()]%</font><br />
				<font color="[patient.getToxLoss() < 60 ? "blue" : "red"]"><b>Toxin Content:</b> [patient.getToxLoss()]%</font><br />
				<font color="[patient.getFireLoss() < 60 ? "blue" : "red"]"><b>Burn Severity:</b> [patient.getFireLoss()]%</font><br />
				"}

/obj/item/mecha_equipment/medical/sleeper/proc/get_patient_reagents()
	if(isnotnull(patient.reagents))
		for_no_type_check(var/datum/reagent/R, patient.reagents.reagent_list)
			if(R.volume > 0)
				. += "[R]: [round(R.volume, 0.01)]<br />"
	return . || "None"

/obj/item/mecha_equipment/medical/sleeper/proc/get_available_reagents()
	var/obj/item/mecha_equipment/medical/syringe_gun/SG = locate(/obj/item/mecha_equipment/medical/syringe_gun) in chassis
	if(isnotnull(SG) && isnotnull(SG.reagents) && islist(SG.reagents.reagent_list))
		for(var/datum/reagent/R in SG.reagents.reagent_list)
			if(R.volume > 0)
				. += "<a href=\"?src=\ref[src];inject=\ref[R];source=\ref[SG]\">Inject [R.name]</a><br />"

/obj/item/mecha_equipment/medical/sleeper/proc/inject_reagent(datum/reagent/R, obj/item/mecha_equipment/medical/syringe_gun/SG)
	if(isnull(R) || isnull(patient) || isnull(SG) || !(SG in chassis.equipment))
		return 0
	var/to_inject = min(R.volume, inject_amount)
	if(to_inject && patient.reagents.get_reagent_amount(R.id) + to_inject <= inject_amount * 2)
		occupant_message("Injecting [patient] with [to_inject] units of [R.name].")
		log_message("Injecting [patient] with [to_inject] units of [R.name].")
		SG.reagents.trans_id_to(patient, R.id, to_inject)
		update_equip_info()

/obj/item/mecha_equipment/medical/sleeper/update_equip_info()
	if(..())
		send_byjax(chassis.occupant, "msleeper.browser", "lossinfo", get_patient_dam())
		send_byjax(chassis.occupant, "msleeper.browser", "reagents", get_patient_reagents())
		send_byjax(chassis.occupant, "msleeper.browser", "injectwith", get_available_reagents())
		return 1

/datum/global_iterator/mech_sleeper/process(obj/item/mecha_equipment/medical/sleeper/S)
	if(!S.chassis)
		S.set_ready_state(1)
		return stop()
	if(!S.chassis.has_charge(S.energy_drain))
		S.set_ready_state(1)
		S.log_message("Deactivated.")
		S.occupant_message(SPAN_WARNING("[src] deactivated - no power."))
		return stop()
	var/mob/living/carbon/M = S.patient
	if(isnull(M))
		return
	if(M.health > 0)
		M.adjustOxyLoss(-1)
		M.updatehealth()
	M.AdjustStunned(-4)
	M.AdjustWeakened(-4)
	M.AdjustStunned(-4)
	M.Paralyse(2)
	M.Weaken(2)
	M.Stun(2)
	if(M.reagents.get_reagent_amount("inaprovaline") < 5)
		M.reagents.add_reagent("inaprovaline", 5)
	S.chassis.use_power(S.energy_drain)
	S.update_equip_info()

// Syringe Gun
/obj/item/mecha_equipment/medical/syringe_gun
	name = "syringe gun"
	desc = "Exosuit-mounted chem synthesizer with syringe gun. Reagents inside are held in stasis, so no reactions will occur. (Can be attached to: Medical Exosuits)"
	icon = 'icons/obj/weapons/gun.dmi'
	icon_state = "syringegun"
	energy_drain = 10
	range = MELEE|RANGED
	equip_cooldown = 1 SECOND
	matter_amounts = /datum/design/mechfab/equipment/syringe_gun::materials
	origin_tech = /datum/design/mechfab/equipment/syringe_gun::req_tech

	var/list/syringes
	var/list/known_reagents
	var/list/processed_reagents
	var/max_syringes = 10
	var/max_volume = 75 //max reagent volume
	var/synth_speed = 5 //[num] reagent units per cycle

	var/mode = 0 //0 - fire syringe, 1 - analyse reagents.
	var/datum/global_iterator/mech_synth/synth

/obj/item/mecha_equipment/medical/syringe_gun/New()
	. = ..()
	SET_ATOM_FLAGS(src, ATOM_FLAG_NO_REACT)
	syringes = list()
	known_reagents = list(
		"inaprovaline" = "Inaprovaline",
		"anti_toxin" = "Anti-Toxin (Dylovene)"
	)
	processed_reagents = list()
	create_reagents(max_volume)
	synth = new /datum/global_iterator/mech_synth(list(src), 0)

/obj/item/mecha_equipment/medical/syringe_gun/Destroy()
	QDEL_NULL(synth)
	return ..()

/obj/item/mecha_equipment/medical/syringe_gun/detach()
	synth.stop()
	return ..()

/obj/item/mecha_equipment/medical/syringe_gun/critfail()
	. = ..()
	UNSET_ATOM_FLAGS(src, ATOM_FLAG_NO_REACT)

/obj/item/mecha_equipment/medical/syringe_gun/get_equip_info()
	. = "[..()] \[<a href=\"?src=\ref[src];toggle_mode=1\">[mode ? "Analyse" : "Launch"]</a>\]<br>\[Syringes: [length(syringes)]/[max_syringes] | Reagents: [reagents.total_volume]/[reagents.maximum_volume]\]<br><a href='byond://?src=\ref[src];show_reagents=1'>Reagents list</a>"

/obj/item/mecha_equipment/medical/syringe_gun/action(atom/movable/target)
	if(!action_checks(target))
		return
	if(istype(target, /obj/item/reagent_holder/syringe))
		return load_syringe(target)
	if(istype(target, /obj/item/storage))//Loads syringes from boxes
		for(var/obj/item/reagent_holder/syringe/S in target.contents)
			load_syringe(S)
		return
	if(mode)
		return analyse_reagents(target)
	if(!length(syringes))
		occupant_message(SPAN_ALERT("No syringes loaded."))
		return
	if(reagents.total_volume <= 0)
		occupant_message(SPAN_ALERT("No available reagents to load syringe with."))
		return
	set_ready_state(0)
	chassis.use_power(energy_drain)
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
	do_after_cooldown()
	return 1

/obj/item/mecha_equipment/medical/syringe_gun/Topic(href, href_list)
	. = ..()
	var/datum/topic_input/topic_filter = new /datum/topic_input(href, href_list)
	if(topic_filter.get("toggle_mode"))
		mode = !mode
		update_equip_info()
		return
	if(topic_filter.get("select_reagents"))
		processed_reagents.len = 0
		var/m = 0
		var/message
		for(var/i = 1 to known_reagents.len)
			if(m >= synth_speed)
				break
			var/reagent = topic_filter.get("reagent_[i]")
			if(reagent && (reagent in known_reagents))
				message = "[m ? ", " : null][known_reagents[reagent]]"
				processed_reagents += reagent
				m++
		if(processed_reagents.len)
			message += " added to production"
			synth.start()
			occupant_message(message)
			occupant_message("Reagent processing started.")
			log_message("Reagent processing started.")
		return
	if(topic_filter.get("show_reagents"))
		chassis.occupant << browse(get_reagents_page(), "window=msyringegun")
	if(topic_filter.get("purge_reagent"))
		var/reagent_type = text2path(topic_filter.get("purge_reagent"))
		if(isnotnull(reagent_type))
			reagents.del_reagent(reagent_type)
		return
	if(topic_filter.get("purge_all"))
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
			. += "[R]: [round(R.volume, 0.001)] - <a href=\"?src=\ref[src];purge_reagent=[R.type]\">Purge Reagent</a><br />"
	if(.)
		. += "Total: [round(reagents.total_volume, 0.001)] / [reagents.maximum_volume] - <a href=\"?src=\ref[src];purge_all=1\">Purge All</a>"
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
	set_ready_state(0)
	do_after_cooldown()
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

/datum/global_iterator/mech_synth
	delay = 100

/datum/global_iterator/mech_synth/process(obj/item/mecha_equipment/medical/syringe_gun/S)
	if(isnull(S.chassis))
		return stop()
	var/energy_drain = S.energy_drain * 10
	if(!length(S.processed_reagents) || S.reagents.total_volume >= S.reagents.maximum_volume || !S.chassis.has_charge(energy_drain))
		S.occupant_message(SPAN_ALERT("Reagent processing stopped."))
		S.log_message("Reagent processing stopped.")
		return stop()
	if(anyprob(S.reliability))
		S.critfail()
	var/amount = S.synth_speed / S.processed_reagents.len
	for(var/reagent in S.processed_reagents)
		S.reagents.add_reagent(reagent,amount)
		S.chassis.use_power(energy_drain)
	return 1