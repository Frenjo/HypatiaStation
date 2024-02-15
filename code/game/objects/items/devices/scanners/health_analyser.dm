/*
 * Health Analyser
 */
/obj/item/health_analyser
	name = "Health Analyser"
	icon = 'icons/obj/items/devices/scanner.dmi'
	icon_state = "health"
	item_state = "health_analyser"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject."
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = 1.0
	throw_speed = 5
	throw_range = 10
	matter_amounts = list(MATERIAL_METAL = 200)
	origin_tech = list(RESEARCH_TECH_MAGNETS = 1, RESEARCH_TECH_BIOTECH = 1)

	var/mode = 1

/obj/item/health_analyser/attack(mob/living/M as mob, mob/living/user as mob)
	if(((CLUMSY in user.mutations) || user.getBrainLoss() >= 60) && prob(50))
		to_chat(user, SPAN_WARNING("You try to analyse the floor's vitals!"))
		for(var/mob/O in viewers(M, null))
			O.show_message(SPAN_WARNING("[user] has analysed the floor's vitals!"), 1)
		user.show_message("\blue Analyzing Results for The floor:\n\t Overall Status: Healthy", 1)
		user.show_message("\blue \t Damage Specifics: [0]-[0]-[0]-[0]", 1)
		user.show_message("\blue Key: Suffocation/Toxin/Burns/Brute", 1)
		user.show_message("\blue Body Temperature: ???", 1)
		return
	if(!(ishuman(usr) || global.CTticker) && global.CTticker.mode.name != "monkey")
		FEEDBACK_NOT_ENOUGH_DEXTERITY(usr)
		return
	user.visible_message(
		SPAN_NOTICE("[user] has analysed [M]'s vitals."),
		SPAN_NOTICE("You have analysed [M]'s vitals.")
	)

	if(!iscarbon(M))
		//these sensors are designed for organic life
		output_error(user, M)
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.flags & IS_SYNTHETIC)
			output_error(user, H)
			return

	var/fake_oxy = max(rand(1, 40), M.getOxyLoss(), (300 - (M.getToxLoss() + M.getFireLoss() + M.getBruteLoss())))
	var/OX = M.getOxyLoss() > 50 ? "<b>[M.getOxyLoss()]</b>" : M.getOxyLoss()
	var/TX = M.getToxLoss() > 50 ? "<b>[M.getToxLoss()]</b>" : M.getToxLoss()
	var/BU = M.getFireLoss() > 50 ? "<b>[M.getFireLoss()]</b>" : M.getFireLoss()
	var/BR = M.getBruteLoss() > 50 ? "<b>[M.getBruteLoss()]</b>" : M.getBruteLoss()
	if(M.status_flags & FAKEDEATH)
		OX = fake_oxy > 50 	? "<b>[fake_oxy]</b>" : fake_oxy
		user.show_message("\blue Analyzing Results for [M]:\n\t Overall Status: dead")
	else
		user.show_message("\blue Analyzing Results for [M]:\n\t Overall Status: [M.stat > 1 ? "dead" : "[M.health - M.halloss]% healthy"]")
	user.show_message("\t Key: <font color='blue'>Suffocation</font>/<font color='green'>Toxin</font>/<font color='#FFA500'>Burns</font>/<font color='red'>Brute</font>", 1)
	user.show_message("\t Damage Specifics: <font color='blue'>[OX]</font> - <font color='green'>[TX]</font> - <font color='#FFA500'>[BU]</font> - <font color='red'>[BR]</font>")
	user.show_message("\blue Body Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)", 1)
	if(M.tod && (M.stat == DEAD || (M.status_flags & FAKEDEATH)))
		user.show_message("\blue Time of Death: [M.tod]")
	if(ishuman(M) && mode == 1)
		var/mob/living/carbon/human/H = M
		var/list/damaged = H.get_damaged_organs(1, 1)
		user.show_message("\blue Localized Damage, Brute/Burn:", 1)
		if(length(damaged)>0)
			for(var/datum/organ/external/org in damaged)
				user.show_message(text("\blue \t []: [][]\blue - []", \
				capitalize(org.display_name), \
				(org.brute_dam > 0)	? "\red [org.brute_dam]" : 0, \
				(org.status & ORGAN_BLEEDING) ? "\red <b>\[Bleeding\]</b>":"\t", \
				(org.burn_dam > 0) ? "<font color='#FFA500'>[org.burn_dam]</font>" : 0), 1)
		else
			user.show_message("\blue \t Limbs are OK.",1)

	OX = M.getOxyLoss() > 50 ? "<font color='blue'><b>Severe oxygen deprivation detected</b></font>" : "Subject bloodstream oxygen level normal"
	TX = M.getToxLoss() > 50 ? "<font color='green'><b>Dangerous amount of toxins detected</b></font>" : "Subject bloodstream toxin level minimal"
	BU = M.getFireLoss() > 50 ? "<font color='#FFA500'><b>Severe burn damage detected</b></font>" :	"Subject burn injury status O.K"
	BR = M.getBruteLoss() > 50 ? "<font color='red'><b>Severe anatomical damage detected</b></font>" : "Subject brute-force injury status O.K"
	if(M.status_flags & FAKEDEATH)
		OX = fake_oxy > 50 ? "\red Severe oxygen deprivation detected\blue" : "Subject bloodstream oxygen level normal"
	user.show_message("[OX] | [TX] | [BU] | [BR]")
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(C.reagents.total_volume > 0)
			user.show_message(SPAN_WARNING("Warning: Unknown substance detected in subject's blood."))
		if(length(C.virus2))
			for(var/ID in C.virus2)
				if(ID in virusDB)
					var/datum/data/record/V = virusDB[ID]
					user.show_message(SPAN_WARNING("Warning: Pathogen [V.fields["name"]] detected in subject's blood. Known antigen : [V.fields["antigen"]]"))
//			user.show_message(text("\red Warning: Unknown pathogen detected in subject's blood."))
	if(M.getCloneLoss())
		user.show_message(SPAN_WARNING("Subject appears to have been imperfectly cloned."))
	for(var/datum/disease/D in M.viruses)
		if(!D.hidden[SCANNER])
			user.show_message("\red <b>Warning: [D.form] Detected</b>\nName: [D.name].\nType: [D.spread].\nStage: [D.stage]/[D.max_stages].\nPossible Cure: [D.cure]")
	if(M.reagents && M.reagents.get_reagent_amount("inaprovaline"))
		user.show_message(SPAN_INFO("Bloodstream Analysis located [M.reagents:get_reagent_amount("inaprovaline")] units of rejuvenation chemicals."))
	if(M.has_brain_worms())
		user.show_message(SPAN_WARNING("Subject suffering from aberrant brain activity. Recommend further scanning."))
	else if(M.getBrainLoss() >= 100 || ishuman(M) && M:brain_op_stage == 4.0)
		user.show_message(SPAN_WARNING("Subject is brain dead."))
	else if(M.getBrainLoss() >= 60)
		user.show_message(SPAN_WARNING("Severe brain damage detected. Subject likely to have mental retardation."))
	else if(M.getBrainLoss() >= 10)
		user.show_message(SPAN_WARNING("Significant brain damage detected. Subject may have had a concussion."))
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/name in H.organs_by_name)
			var/datum/organ/external/e = H.organs_by_name[name]
			var/limb = e.display_name
			if(e.status & ORGAN_BROKEN)
				if((e.name == "l_arm" || e.name == "r_arm" || e.name == "l_leg" || e.name == "r_leg") && !(e.status & ORGAN_SPLINTED))
					to_chat(user, SPAN_WARNING("Unsecured fracture in subject [limb]. Splinting recommended for transport."))
			if(e.has_infected_wound())
				to_chat(user, SPAN_WARNING("Infected wound detected in subject [limb]. Disinfection recommended."))

		for(var/name in H.organs_by_name)
			var/datum/organ/external/e = H.organs_by_name[name]
			if(e.status & ORGAN_BROKEN)
				user.show_message(SPAN_WARNING("Bone fractures detected. Advanced scanner required for location."), 1)
				break
		for(var/datum/organ/external/e in H.organs)
			for(var/datum/wound/W in e.wounds) if(W.internal)
				user.show_message(SPAN_WARNING("Internal bleeding detected. Advanced scanner required for location."), 1)
				break
		if(H.vessel)
			var/blood_volume = round(H.vessel.get_reagent_amount("blood"))
			var/blood_percent =  blood_volume / 560
			blood_percent *= 100
			if(blood_volume <= 500)
				user.show_message(SPAN_DANGER("Warning: Blood Level LOW: [blood_percent]% [blood_volume]cl"))
			else if(blood_volume <= 336)
				user.show_message(SPAN_DANGER("Warning: Blood Level CRITICAL: [blood_percent]% [blood_volume]cl"))
			else
				user.show_message(SPAN_INFO("Blood Level Normal: [blood_percent]% [blood_volume]cl"))
		user.show_message("\blue Subject's pulse: <font color='[H.pulse == PULSE_THREADY || H.pulse == PULSE_NONE ? "red" : "blue"]'>[H.get_pulse(GETPULSE_TOOL)] bpm.</font>")
	src.add_fingerprint(user)
	return

/obj/item/health_analyser/verb/toggle_mode()
	set category = PANEL_OBJECT
	set name = "Switch Verbosity"

	mode = !mode
	switch (mode)
		if(1)
			to_chat(usr, "The scanner now shows specific limb damage.")
		if(0)
			to_chat(usr, "The scanner no longer shows limb damage.")

/obj/item/health_analyser/proc/output_error(mob/living/user, mob/living/target)
	user.show_message("\blue Analyzing Results for ERROR:\n\t Overall Status: ERROR")
	user.show_message("\t Key: <font color='blue'>Suffocation</font>/<font color='green'>Toxin</font>/<font color='#FFA500'>Burns</font>/<font color='red'>Brute</font>", 1)
	user.show_message("\t Damage Specifics: <font color='blue'>?</font> - <font color='green'>?</font> - <font color='#FFA500'>?</font> - <font color='red'>?</font>")
	user.show_message("\blue Body Temperature: [target.bodytemperature-T0C]&deg;C ([target.bodytemperature*1.8-459.67]&deg;F)", 1)
	user.show_message("\red <b>Warning: Blood Level ERROR: --% --cl.\blue Type: ERROR")
	user.show_message("\blue Subject's pulse: <font color='red'>-- bpm.</font>")