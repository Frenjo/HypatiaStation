/obj/item/mecha_part/equipment/tool/sleeper
	name = "mounted sleeper"
	desc = "Mounted Sleeper. (Can be attached to: Medical Exosuits)"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper_0"
	origin_tech = list(/datum/tech/biotech = 3, /datum/tech/programming = 2)
	energy_drain = 20
	range = MELEE
	construction_cost = list(MATERIAL_METAL = 5000, /decl/material/glass = 10000)
	reliability = 1000
	equip_cooldown = 20
	salvageable = 0

	var/mob/living/carbon/occupant = null
	var/datum/global_iterator/pr_mech_sleeper
	var/inject_amount = 10

/obj/item/mecha_part/equipment/tool/sleeper/can_attach(obj/mecha/medical/M)
	if(..())
		if(istype(M))
			return TRUE
	return FALSE

/obj/item/mecha_part/equipment/tool/sleeper/New()
	. = ..()
	pr_mech_sleeper = new /datum/global_iterator/mech_sleeper(list(src), 0)
	pr_mech_sleeper.set_delay(equip_cooldown)

/obj/item/mecha_part/equipment/tool/sleeper/allow_drop()
	return FALSE

/obj/item/mecha_part/equipment/tool/sleeper/destroy()
	for(var/atom/movable/AM in src)
		AM.forceMove(GET_TURF(src))
	return ..()

/obj/item/mecha_part/equipment/tool/sleeper/Exit(atom/movable/O)
	return FALSE

/obj/item/mecha_part/equipment/tool/sleeper/action(mob/living/carbon/target)
	if(!action_checks(target))
		return
	if(!istype(target))
		return
	if(target.buckled)
		occupant_message(SPAN_WARNING("[target] will not fit into the sleeper because they are buckled to [target.buckled]."))
		return
	if(occupant)
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
		if(occupant)
			occupant_message(SPAN_WARNING("The sleeper is already occupied!"))
			return
		target.forceMove(src)
		occupant = target
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

/obj/item/mecha_part/equipment/tool/sleeper/proc/go_out()
	if(isnull(occupant))
		return
	occupant.forceMove(GET_TURF(src))
	occupant_message(SPAN_INFO("[occupant] ejected. Life support functions disabled."))
	log_message(SPAN_INFO("[occupant] ejected. Life support functions disabled."))
	occupant.reset_view()
	/*
	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	*/
	occupant = null
	pr_mech_sleeper.stop()
	set_ready_state(1)

/obj/item/mecha_part/equipment/tool/sleeper/detach()
	if(isnotnull(occupant))
		occupant_message(SPAN_WARNING("Unable to detach \the [src] - equipment occupied."))
		return
	pr_mech_sleeper.stop()
	return ..()

/obj/item/mecha_part/equipment/tool/sleeper/get_equip_info()
	. = ..()
	if(.)
		if(isnull(occupant))
			return
		. += "<br />\[Occupant: [occupant] (Health: [occupant.health]%)\]<br /><a href='byond://?src=\ref[src];view_stats=1'>View stats</a>|<a href='byond://?src=\ref[src];eject=1'>Eject</a>"

/obj/item/mecha_part/equipment/tool/sleeper/Topic(href, href_list)
	. = ..()
	var/datum/topic_input/new_filter = new /datum/topic_input(href, href_list)
	if(new_filter.get("eject"))
		go_out()
	if(new_filter.get("view_stats"))
		chassis.occupant << browse(get_occupant_stats(),"window=msleeper")
		onclose(chassis.occupant, "msleeper")
		return
	if(new_filter.get("inject"))
		inject_reagent(new_filter.getType("inject", /datum/reagent), new_filter.getObj("source"))

/obj/item/mecha_part/equipment/tool/sleeper/proc/get_occupant_stats()
	if(isnull(occupant))
		return
	return {"<html>
				<head>
				<title>[occupant] statistics</title>
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
				[get_occupant_dam()]
				</div>
				<h3>Reagents in bloodstream</h3>
				<div id="reagents">
				[get_occupant_reagents()]
				</div>
				<div id="injectwith">
				[get_available_reagents()]
				</div>
				</body>
				</html>"}

/obj/item/mecha_part/equipment/tool/sleeper/proc/get_occupant_dam()
	var/t1
	switch(occupant.stat)
		if(0)
			t1 = "Conscious"
		if(1)
			t1 = "Unconscious"
		if(2)
			t1 = "*dead*"
		else
			t1 = "Unknown"
	return {"<font color="[occupant.health > 50 ? "blue" : "red"]"><b>Health:</b> [occupant.health]% ([t1])</font><br />
				<font color="[occupant.bodytemperature > 50 ? "blue" : "red"]"><b>Core Temperature:</b> [occupant.bodytemperature-T0C]&deg;C ([occupant.bodytemperature*1.8-459.67]&deg;F)</font><br />
				<font color="[occupant.getBruteLoss() < 60 ? "blue" : "red"]"><b>Brute Damage:</b> [occupant.getBruteLoss()]%</font><br />
				<font color="[occupant.getOxyLoss() < 60 ? "blue" : "red"]"><b>Respiratory Damage:</b> [occupant.getOxyLoss()]%</font><br />
				<font color="[occupant.getToxLoss() < 60 ? "blue" : "red"]"><b>Toxin Content:</b> [occupant.getToxLoss()]%</font><br />
				<font color="[occupant.getFireLoss() < 60 ? "blue" : "red"]"><b>Burn Severity:</b> [occupant.getFireLoss()]%</font><br />
				"}

/obj/item/mecha_part/equipment/tool/sleeper/proc/get_occupant_reagents()
	if(occupant.reagents)
		for(var/datum/reagent/R in occupant.reagents.reagent_list)
			if(R.volume > 0)
				. += "[R]: [round(R.volume, 0.01)]<br />"
	return . || "None"

/obj/item/mecha_part/equipment/tool/sleeper/proc/get_available_reagents()
	var/obj/item/mecha_part/equipment/tool/syringe_gun/SG = locate(/obj/item/mecha_part/equipment/tool/syringe_gun) in chassis
	if(isnotnull(SG) && isnotnull(SG.reagents) && islist(SG.reagents.reagent_list))
		for(var/datum/reagent/R in SG.reagents.reagent_list)
			if(R.volume > 0)
				. += "<a href=\"?src=\ref[src];inject=\ref[R];source=\ref[SG]\">Inject [R.name]</a><br />"

/obj/item/mecha_part/equipment/tool/sleeper/proc/inject_reagent(datum/reagent/R, obj/item/mecha_part/equipment/tool/syringe_gun/SG)
	if(isnull(R) || isnull(occupant) || isnull(SG) || !(SG in chassis.equipment))
		return 0
	var/to_inject = min(R.volume, inject_amount)
	if(to_inject && occupant.reagents.get_reagent_amount(R.id) + to_inject <= inject_amount * 2)
		occupant_message("Injecting [occupant] with [to_inject] units of [R.name].")
		log_message("Injecting [occupant] with [to_inject] units of [R.name].")
		SG.reagents.trans_id_to(occupant, R.id, to_inject)
		update_equip_info()

/obj/item/mecha_part/equipment/tool/sleeper/update_equip_info()
	if(..())
		send_byjax(chassis.occupant, "msleeper.browser", "lossinfo", get_occupant_dam())
		send_byjax(chassis.occupant, "msleeper.browser", "reagents", get_occupant_reagents())
		send_byjax(chassis.occupant, "msleeper.browser", "injectwith", get_available_reagents())
		return 1

/datum/global_iterator/mech_sleeper/process(obj/item/mecha_part/equipment/tool/sleeper/S)
	if(!S.chassis)
		S.set_ready_state(1)
		return stop()
	if(!S.chassis.has_charge(S.energy_drain))
		S.set_ready_state(1)
		S.log_message("Deactivated.")
		S.occupant_message(SPAN_WARNING("[src] deactivated - no power."))
		return stop()
	var/mob/living/carbon/M = S.occupant
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

/obj/item/mecha_part/equipment/tool/syringe_gun
	name = "syringe gun"
	desc = "Exosuit-mounted chem synthesizer with syringe gun. Reagents inside are held in stasis, so no reactions will occur. (Can be attached to: Medical Exosuits)"
	icon = 'icons/obj/weapons/gun.dmi'
	icon_state = "syringegun"
	energy_drain = 10
	range = MELEE|RANGED
	equip_cooldown = 10
	origin_tech = list(
		/datum/tech/materials = 3, /datum/tech/magnets = 4, /datum/tech/biotech = 4,
		/datum/tech/programming = 3
	)
	construction_time = 200
	construction_cost = list(MATERIAL_METAL = 3000, /decl/material/glass = 2000)

	var/list/syringes
	var/list/known_reagents
	var/list/processed_reagents
	var/max_syringes = 10
	var/max_volume = 75 //max reagent volume
	var/synth_speed = 5 //[num] reagent units per cycle

	var/mode = 0 //0 - fire syringe, 1 - analyse reagents.
	var/datum/global_iterator/mech_synth/synth

/obj/item/mecha_part/equipment/tool/syringe_gun/New()
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

/obj/item/mecha_part/equipment/tool/syringe_gun/detach()
	synth.stop()
	return ..()

/obj/item/mecha_part/equipment/tool/syringe_gun/critfail()
	. = ..()
	UNSET_ATOM_FLAGS(src, ATOM_FLAG_NO_REACT)

/obj/item/mecha_part/equipment/tool/syringe_gun/can_attach(obj/mecha/medical/M)
	if(..())
		if(istype(M))
			return TRUE
	return FALSE

/obj/item/mecha_part/equipment/tool/syringe_gun/get_equip_info()
	. = ..()
	if(.)
		. += " \[<a href=\"?src=\ref[src];toggle_mode=1\">[mode ? "Analyse" : "Launch"]</a>\]<br>\[Syringes: [length(syringes)]/[max_syringes] | Reagents: [reagents.total_volume]/[reagents.maximum_volume]\]<br><a href='byond://?src=\ref[src];show_reagents=1'>Reagents list</a>"

/obj/item/mecha_part/equipment/tool/syringe_gun/action(atom/movable/target)
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

/obj/item/mecha_part/equipment/tool/syringe_gun/Topic(href, href_list)
	. = ..()
	var/datum/topic_input/new_filter = new /datum/topic_input(href, href_list)
	if(new_filter.get("toggle_mode"))
		mode = !mode
		update_equip_info()
		return
	if(new_filter.get("select_reagents"))
		processed_reagents.len = 0
		var/m = 0
		var/message
		for(var/i = 1 to known_reagents.len)
			if(m >= synth_speed)
				break
			var/reagent = new_filter.get("reagent_[i]")
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
	if(new_filter.get("show_reagents"))
		chassis.occupant << browse(get_reagents_page(), "window=msyringegun")
	if(new_filter.get("purge_reagent"))
		var/reagent_type = text2path(new_filter.get("purge_reagent"))
		if(isnotnull(reagent_type))
			reagents.del_reagent(reagent_type)
		return
	if(new_filter.get("purge_all"))
		reagents.clear_reagents()
		return

/obj/item/mecha_part/equipment/tool/syringe_gun/proc/get_reagents_page()
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

/obj/item/mecha_part/equipment/tool/syringe_gun/proc/get_reagents_form()
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

/obj/item/mecha_part/equipment/tool/syringe_gun/proc/get_reagents_list()
	for(var/i = 1 to known_reagents.len)
		var/reagent_id = known_reagents[i]
		. += {"<input type="checkbox" value="[reagent_id]" name="reagent_[i]" [(reagent_id in processed_reagents) ? "checked=\"1\"" : null]> [known_reagents[reagent_id]]<br />"}

/obj/item/mecha_part/equipment/tool/syringe_gun/proc/get_current_reagents()
	for(var/datum/reagent/R in reagents.reagent_list)
		if(R.volume > 0)
			. += "[R]: [round(R.volume, 0.001)] - <a href=\"?src=\ref[src];purge_reagent=[R.type]\">Purge Reagent</a><br />"
	if(.)
		. += "Total: [round(reagents.total_volume, 0.001)] / [reagents.maximum_volume] - <a href=\"?src=\ref[src];purge_all=1\">Purge All</a>"
	return . || "None"

/obj/item/mecha_part/equipment/tool/syringe_gun/proc/load_syringe(obj/item/reagent_holder/syringe/S)
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

/obj/item/mecha_part/equipment/tool/syringe_gun/proc/analyse_reagents(atom/A)
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

/obj/item/mecha_part/equipment/tool/syringe_gun/proc/add_known_reagent(r_id, r_name)
	set_ready_state(0)
	do_after_cooldown()
	if(!(r_id in known_reagents))
		known_reagents.Add(r_id)
		known_reagents[r_id] = r_name
		return TRUE
	return FALSE

/obj/item/mecha_part/equipment/tool/syringe_gun/update_equip_info()
	if(..())
		send_byjax(chassis.occupant, "msyringegun.browser", "reagents", get_current_reagents())
		send_byjax(chassis.occupant, "msyringegun.browser", "reagents_form", get_reagents_form())
		return TRUE

/obj/item/mecha_part/equipment/tool/syringe_gun/on_reagent_change()
	. = ..()
	update_equip_info()


/datum/global_iterator/mech_synth
	delay = 100

/datum/global_iterator/mech_synth/process(obj/item/mecha_part/equipment/tool/syringe_gun/S)
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