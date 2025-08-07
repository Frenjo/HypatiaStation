/*
 * Health Analyser
 */
#define MODE_HIDE_LIMB_DAMAGE 0
#define MODE_SHOW_LIMB_DAMAGE 1

/obj/item/health_analyser
	name = "health analyser"
	desc = "A handheld body scanner able to distinguish vital signs of the subject."
	icon = 'icons/obj/items/devices/scanner.dmi'
	icon_state = "health"
	item_state = "health_analyser"

	w_class = 1
	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT

	throwforce = 3
	throw_speed = 5
	throw_range = 10

	matter_amounts = alist(/decl/material/plastic = 200, /decl/material/glass = 50)
	origin_tech = alist(/decl/tech/magnets = 1, /decl/tech/biotech = 1)

	var/mode = MODE_SHOW_LIMB_DAMAGE

/obj/item/health_analyser/attack(mob/living/M, mob/living/user)
	if(user.stat)
		return
	if(!ishuman(usr) && !IS_GAME_MODE(/datum/game_mode/monkey))
		FEEDBACK_NOT_ENOUGH_DEXTERITY(usr)
		return

	if(((MUTATION_CLUMSY in user.mutations) || user.getBrainLoss() >= 60) && prob(50))
		var/turf/target = GET_TURF(M)
		user.visible_message(
			SPAN_WARNING("[user] tries to analyse the floor's vitals!"),
			SPAN_WARNING("You try to analyse the floor's vitals!")
		)
		output_error(user, target, TRUE)
		return

	user.visible_message(
		SPAN_NOTICE("[user] analyses [M]'s vitals."),
		SPAN_NOTICE("You analyse [M]'s vitals.")
	)

	if(!iscarbon(M))
		//these sensors are designed for organic life
		output_error(user, M)
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(HAS_SPECIES_FLAGS(H.species, SPECIES_FLAG_IS_SYNTHETIC))
			output_error(user, H)
			return

	output_health(user, M, mode == MODE_SHOW_LIMB_DAMAGE)
	add_fingerprint(user)

/obj/item/health_analyser/verb/toggle_mode()
	set category = PANEL_OBJECT
	set name = "Switch Verbosity"

	mode = !mode
	switch(mode)
		if(MODE_SHOW_LIMB_DAMAGE)
			to_chat(usr, "The scanner now shows specific limb damage.")
		if(MODE_HIDE_LIMB_DAMAGE)
			to_chat(usr, "The scanner no longer shows limb damage.")

/obj/item/health_analyser/proc/output_error(mob/living/user, atom/target, clumsy = FALSE)
	// The text to output.
	var/list/output = list()

	if(!clumsy)
		var/mob/living/L = target
		output.Add(SPAN_INFO("Analysing results for <em>ERROR</em>:"))
		output.Add("\t [SPAN_INFO("Overall Status: <em>ERROR</em>")]")
		output.Add("\t Key: <font color='red'><em>Brute</em></font>/<font color='#FFA500'><em>Burns</em></font>/<font color='green'><em>Toxin</em></font>/<font color='blue'><em>Suffocation</em></font>")
		output.Add("\t Damage Specifics: <font color='red'>?</font> - <font color='#FFA500'>?</font> - <font color='green'>?</font> - <font color='blue'>?</font>")
		output.Add(SPAN_INFO("Body Temperature: [L.bodytemperature - T0C]&deg;C ([L.bodytemperature * 1.8-459.67]&deg;F)"))
		output.Add("[SPAN_DANGER("Warning: Blood Level ERROR: --% --cl.")] [SPAN_INFO("Type: ERROR")]")
		output.Add("[SPAN_INFO("Subject's pulse:")] <font color='red'>-- bpm.</font>")
	else
		output.Add(SPAN_INFO("Analysing results for <em>\the [target]</em>:"))
		output.Add("\t [SPAN_INFO("Overall Status: <em>Healthy</em>")]")
		output.Add("\t Key: <font color='red'><em>Brute</em></font>/<font color='#FFA500'><em>Burns</em></font>/<font color='green'><em>Toxin</em></font>/<font color='blue'><em>Suffocation</em></font>")
		output.Add("\t Damage Specifics: <font color='red'>[0]</font> - <font color='#FFA500'>[0]</font> - <font color='green'>[0]</font> - <font color='blue'>[0]</font>")
		output.Add(SPAN_INFO("Body Temperature: ???"))

	// Outputs the joined text.
	var/joined_output = jointext(output, "<br>")
	user.show_message("<div class='examine'>[joined_output]</div>", 1)

/obj/item/health_analyser/proc/output_health(mob/living/user, mob/living/target, show_limb_damage)
	// The text to output.
	var/list/output = list()

	// Individual damage values.
	var/brute_loss = target.getBruteLoss()
	var/fire_loss = target.getFireLoss()
	var/tox_loss = target.getToxLoss()
	var/oxy_loss = target.getOxyLoss()
	var/target_status = (target.stat == DEAD ? "dead" : "[target.health - target.halloss]% healthy")

	// Handles FAKEDEATH status flag.
	if(target.status_flags & FAKEDEATH)
		target_status = "dead"
		oxy_loss = max(rand(1, 40), oxy_loss, (300 - (tox_loss + fire_loss + brute_loss)))

	// Formatted strings for individual damage values.
	var/brute_string = (brute_loss > 50) ? "<b>[brute_loss]</b>" : brute_loss
	var/burn_string = (fire_loss > 50) ? "<b>[fire_loss]</b>" : fire_loss
	var/tox_string = (tox_loss > 50) ? "<b>[tox_loss]</b>" : tox_loss
	var/oxy_string = (oxy_loss > 50) ? "<b>[oxy_loss]</b>" : oxy_loss

	// Handles basic health data.
	output.Add(SPAN_INFO("Analysing results for [target]:"))
	output.Add("\t [SPAN_INFO("Overall Status: [target_status]")]")
	output.Add("\t Key: <font color='red'><em>Brute</em></font>/<font color='#FFA500'><em>Burns</em></font>/<font color='green'><em>Toxin</em></font>/<font color='blue'><em>Suffocation</em></font>")
	output.Add("\t Damage Specifics: <font color='red'>[brute_string]</font> - <font color='#FFA500'>[burn_string]</font> - <font color='green'>[tox_string]</font> - <font color='blue'>[oxy_string]</font>")
	output.Add(SPAN_INFO("Body Temperature: [target.bodytemperature - T0C]&deg;C ([target.bodytemperature * 1.8-459.67]&deg;F)"))

	// Handles time of death.
	if(isnotnull(target.tod) && (target.stat == DEAD || (target.status_flags & FAKEDEATH)))
		output.Add(SPAN_INFO("Time of Death: [target.tod]"))

	// Handles limb damage.
	if(ishuman(target) && show_limb_damage)
		var/mob/living/carbon/human/H = target
		var/list/damaged_organs = H.get_damaged_organs(TRUE, TRUE)
		if(length(damaged_organs) > 0)
			output.Add(SPAN_INFO("Localised Damage (<font color='red'><em>Brute</em></font>/<font color='#FFA500'><em>Burn</em></font>):"))
			for(var/datum/organ/external/organ in damaged_organs)
				var/organ_bleeding = (organ.status & ORGAN_BLEEDING) ? SPAN_DANGER("\[Bleeding\]") : ""
				output.Add("\t [SPAN_INFO(capitalize(organ.display_name))]: [SPAN_WARNING(organ.brute_dam)][organ_bleeding] [SPAN_INFO("-")] <font color='#FFA500'>[organ.burn_dam]</font>")
		else
			output.Add("\t [SPAN_INFO("Limbs are OK.")]")

	// Overall damage statuses.
	brute_string = (brute_loss > 50) ? "<font color='red'><b>Severe anatomical damage detected</b></font>" : "Subject brute-force injury status O.K"
	burn_string = (fire_loss > 50) ? "<font color='#FFA500'><b>Severe burn damage detected</b></font>" : "Subject burn injury status O.K"
	tox_string = (tox_loss > 50) ? "<font color='green'><b>Dangerous amount of toxins detected</b></font>" : "Subject bloodstream toxin level minimal"
	oxy_string = (oxy_loss > 50) ? "<font color='blue'><b>Severe oxygen deprivation detected</b></font>" : "Subject bloodstream oxygen level normal"
	output.Add("[brute_string] | [burn_string] | [tox_string] | [oxy_string]")

	// Handles carbon-specific health features.
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		// Reagents.
		if(C.reagents.total_volume > 0)
			output.Add(SPAN_WARNING("Warning: Unknown substance detected in subject's blood."))
		// Pathogens.
		if(length(C.virus2))
			for(var/virus_id in C.virus2)
				if(virus_id in virusDB)
					var/datum/data/record/V = virusDB[virus_id]
					output.Add(SPAN_WARNING("Warning: Pathogen [V.fields["name"]] detected in subject's blood. Known antigen: [V.fields["antigen"]]"))
			//user.show_message("\red Warning: Unknown pathogen detected in subject's blood.")

	// Handles genetic damage.
	if(target.getCloneLoss())
		output.Add(SPAN_WARNING("Subject appears to have been imperfectly cloned."))

	// Handles diseases.
	for(var/datum/disease/D in target.viruses)
		if(D.hidden[SCANNER])
			continue
		output.Add(SPAN_DANGER("Warning: [D.form] detected!"))
		output.Add(SPAN_DANGER("Name: [D.name]."))
		output.Add(SPAN_DANGER("Type: [D.spread]."))
		output.Add(SPAN_DANGER("Stage: [D.stage]/[D.max_stages]."))
		output.Add(SPAN_DANGER("Possible Cure: [D.cure]."))

	// Handles rejuvenation chemicals.
	if(isnotnull(target.reagents))
		var/inaprovaline_amount = target.reagents.get_reagent_amount("inaprovaline")
		if(inaprovaline_amount != 0)
			output.Add(SPAN_INFO("Bloodstream analysis located [inaprovaline_amount] units of rejuvenation chemicals."))

	// Handles brain status.
	if(target.has_brain_worms())
		output.Add(SPAN_WARNING("Subject suffering from aberrant brain activity. Recommend further scanning."))
	else
		var/brain_loss = target.getBrainLoss()
		if(brain_loss >= 100 || ishuman(target) && target:brain_op_stage == 4)
			output.Add(SPAN_WARNING("Subject is brain dead."))
		else if(brain_loss >= 60)
			output.Add(SPAN_WARNING("Severe brain damage detected. Subject likely to have mental impairment."))
		else if(brain_loss >= 10)
			output.Add(SPAN_WARNING("Significant brain damage detected. Subject may have had a concussion."))

	// Handles human-specific health features.
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		// Fractures and infected wounds.
		for(var/organ_name in H.organs_by_name)
			var/datum/organ/external/e = H.organs_by_name[organ_name]
			var/limb = e.display_name
			if(e.status & ORGAN_BROKEN)
				if((e.name == "l_arm" || e.name == "r_arm" || e.name == "l_leg" || e.name == "r_leg") && !(e.status & ORGAN_SPLINTED))
					output.Add(SPAN_WARNING("Unsecured fracture in subject [limb]. Splinting recommended for transport."))
			if(e.has_infected_wound())
				output.Add(SPAN_WARNING("Infected wound detected in subject [limb]. Disinfection recommended."))
		for(var/organ_name in H.organs_by_name)
			var/datum/organ/external/e = H.organs_by_name[organ_name]
			if(e.status & ORGAN_BROKEN)
				output.Add(SPAN_WARNING("Bone fractures detected. Advanced scanner required for location."))
				break
		// Internal bleeding.
		for(var/datum/organ/external/e in H.organs)
			for(var/datum/wound/W in e.wounds)
				if(W.internal)
					output.Add(SPAN_WARNING("Internal bleeding detected. Advanced scanner required for location."))
					break
		// Blood level.
		if(H.vessel)
			var/blood_volume = round(H.vessel.get_reagent_amount("blood"))
			var/blood_percent = blood_volume / 560
			blood_percent *= 100
			if(blood_volume <= 500)
				output.Add(SPAN_DANGER("Warning: Blood Level LOW: [blood_percent]% [blood_volume]cl"))
			else if(blood_volume <= 336)
				output.Add(SPAN_DANGER("Warning: Blood Level CRITICAL: [blood_percent]% [blood_volume]cl"))
			else
				output.Add(SPAN_INFO("Blood Level Normal: [blood_percent]% [blood_volume]cl"))
		// Pulse.
		var/pulse_string = "<font color='[H.pulse == PULSE_THREADY || H.pulse == PULSE_NONE ? "red" : "blue"]'>[H.get_pulse(GETPULSE_TOOL)] bpm.</font>"
		output.Add("[SPAN_INFO("Subject's pulse:")] [pulse_string]")

	// Outputs the joined text.
	var/joined_output = jointext(output, "<br>")
	user.show_message("<div class='examine'>[joined_output]</div>", 1)

#undef MODE_SHOW_LIMB_DAMAGE
#undef MODE_HIDE_LIMB_DAMAGE