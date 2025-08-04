// Sleeper
/obj/item/mecha_equipment/medical/sleeper
	name = "mounted sleeper"
	desc = "An exosuit-mounted medical sleeper. (Can be attached to: Medical Exosuits)"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper_0"
	matter_amounts = /datum/design/mechfab/equipment/sleeper::materials
	origin_tech = /datum/design/mechfab/equipment/sleeper::req_tech

	equip_cooldown = 2 SECONDS
	energy_drain = 20
	equip_range = MECHA_EQUIP_MELEE

	salvageable = FALSE

	var/mob/living/carbon/patient = null
	var/inject_amount = 10

/obj/item/mecha_equipment/medical/sleeper/Destroy()
	STOP_PROCESSING(PCobj, src)
	var/turf/T = GET_TURF(src)
	for_no_type_check(var/atom/movable/mover, src)
		mover.forceMove(T)
	patient = null
	return ..()

/obj/item/mecha_equipment/medical/sleeper/allow_drop()
	return FALSE

/obj/item/mecha_equipment/medical/sleeper/Exit(atom/movable/O)
	return FALSE

/obj/item/mecha_equipment/medical/sleeper/action(mob/living/carbon/target)
	if(!..())
		return FALSE
	if(!istype(target))
		return FALSE
	if(target.buckled)
		occupant_message(SPAN_WARNING("[target] will not fit into the sleeper because they are buckled to [target.buckled]."))
		return FALSE
	if(isnotnull(patient))
		occupant_message(SPAN_WARNING("The sleeper is already occupied"))
		return FALSE
	for(var/mob/living/carbon/slime/M in range(1, target))
		if(M.Victim == target)
			occupant_message(SPAN_WARNING("[target] will not fit into the sleeper because they have a slime latched onto their head."))
			return FALSE
	occupant_message(SPAN_INFO("You start putting \the [target] into \the [src]."))
	chassis.visible_message("[chassis] starts putting \the [target] into the \the [src].")

	if(do_after_cooldown(target))
		if(isnotnull(patient))
			occupant_message(SPAN_WARNING("The sleeper is already occupied!"))
			return FALSE
		target.forceMove(src)
		patient = target
		target.reset_view(src)

		START_PROCESSING(PCobj, src)
		update_equip_info()

		occupant_message(SPAN_INFO("[target] successfully loaded into \the [src]. Life support functions engaged."))
		chassis.visible_message(SPAN_INFO("[chassis] loads \the [target] into \the [src]."))
		log_message("[target] loaded. Life support functions engaged.")
		return TRUE

/obj/item/mecha_equipment/medical/sleeper/process()
	if(..() == PROCESS_KILL)
		return PROCESS_KILL

	if(!chassis.has_charge(energy_drain))
		log_message("Deactivated.")
		occupant_message(SPAN_WARNING("[src] deactivated - no power."))
		set_ready_state(TRUE)
		return PROCESS_KILL

	var/mob/living/carbon/M = patient
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
	chassis.use_power(energy_drain)
	update_equip_info()

/obj/item/mecha_equipment/medical/sleeper/proc/go_out()
	if(isnull(patient))
		return
	patient.forceMove(GET_TURF(src))
	occupant_message(SPAN_INFO("[patient] ejected. Life support functions disabled."))
	log_message(SPAN_INFO("[patient] ejected. Life support functions disabled."))
	patient.reset_view()

	STOP_PROCESSING(PCobj, src)
	update_equip_info()

/obj/item/mecha_equipment/medical/sleeper/attach(obj/mecha/M)
	. = ..()
	START_PROCESSING(PCobj, src)

/obj/item/mecha_equipment/medical/sleeper/detach()
	if(isnotnull(patient))
		occupant_message(SPAN_WARNING("Unable to detach \the [src] - equipment occupied."))
		return
	STOP_PROCESSING(PCobj, src)
	update_equip_info()
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
		SHOW_BROWSER(chassis.occupant, get_patient_stats(),"window=msleeper")
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