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

	matter_amounts = list(MATERIAL_METAL = 200)
	origin_tech = list(/decl/tech/magnets = 1, /decl/tech/biotech = 1)

	var/mode = MODE_SHOW_LIMB_DAMAGE

/obj/item/health_analyser/attack(mob/living/M, mob/living/user)
	if(user.stat)
		return
	if(!ishuman(usr) && !IS_GAME_MODE(/datum/game_mode/monkey))
		FEEDBACK_NOT_ENOUGH_DEXTERITY(usr)
		return

	if(((MUTATION_CLUMSY in user.mutations) || user.getBrainLoss() >= 60) && prob(50))
		user.visible_message(
			SPAN_WARNING("[user] tries to analyse the floor's vitals!"),
			SPAN_WARNING("You try to analyse the floor's vitals!")
		)
		user.show_message(SPAN_INFO("Analysing results for the floor:"), 1)
		user.show_message("\t [SPAN_INFO("Overall Status: Healthy")]")
		user.show_message("\t Key: <font color='blue'>Suffocation</font>/<font color='green'>Toxin</font>/<font color='#FFA500'>Burns</font>/<font color='red'>Brute</font>")
		user.show_message("\t Damage Specifics: <font color='blue'>[0]</font> - <font color='green'>[0]</font> - <font color='#FFA500'>[0]</font> - <font color='red'>[0]</font>", 1)
		user.show_message(SPAN_INFO("Body Temperature: ???"), 1)
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

	output_health(user, M)
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

/obj/item/health_analyser/proc/output_error(mob/living/user, mob/living/target)
	// The text to output.
	var/list/output = list()

	output.Add("[SPAN_INFO("Analysing results for ERROR:")]\n")
	output.Add("\t [SPAN_INFO("Overall Status: ERROR")]\n")
	output.Add("\t Key: <font color='blue'>Suffocation</font>/<font color='green'>Toxin</font>/<font color='#FFA500'>Burn</font>/<font color='red'>Brute</font>\n")
	output.Add("\t Damage Specifics: <font color='blue'>?</font> - <font color='green'>?</font> - <font color='#FFA500'>?</font> - <font color='red'>?</font>\n")
	output.Add("[SPAN_INFO("Body Temperature: [target.bodytemperature - T0C]&deg;C ([target.bodytemperature * 1.8-459.67]&deg;F)")]\n")
	output.Add("[SPAN_DANGER("Warning: Blood Level ERROR: --% --cl.")] [SPAN_INFO("Type: ERROR")]\n")
	output.Add("[SPAN_INFO("Subject's pulse:")] <font color='red'>-- bpm.</font>")

	// Outputs the joined text.
	user.show_message(jointext(output, ""), 1)

/obj/item/health_analyser/proc/output_health(mob/living/user, mob/living/target)
	// The text to output.
	var/list/output = list()

	// Individual damage values.
	var/oxy_loss = target.getOxyLoss()
	var/tox_loss = target.getToxLoss()
	var/fire_loss = target.getFireLoss()
	var/brute_loss = target.getBruteLoss()
	var/target_status = (target.stat == DEAD ? "dead" : "[target.health - target.halloss]% healthy")

	// Handles FAKEDEATH status flag.
	if(target.status_flags & FAKEDEATH)
		target_status = "dead"
		oxy_loss = max(rand(1, 40), oxy_loss, (300 - (tox_loss + fire_loss + brute_loss)))

	// Formatted strings for individual damage values.
	var/oxy_string = (oxy_loss > 50) ? "<b>[oxy_loss]</b>" : oxy_loss
	var/tox_string = (tox_loss > 50) ? "<b>[tox_loss]</b>" : tox_loss
	var/burn_string = (fire_loss > 50) ? "<b>[fire_loss]</b>" : fire_loss
	var/brute_string = (brute_loss > 50) ? "<b>[brute_loss]</b>" : brute_loss

	// Handles basic health data.
	output.Add("[SPAN_INFO("Analysing results for [target]:")]\n")
	output.Add("\t [SPAN_INFO("Overall Status: [target_status]")]\n")
	output.Add("\t Key: <font color='blue'>Suffocation</font>/<font color='green'>Toxin</font>/<font color='#FFA500'>Burn</font>/<font color='red'>Brute</font>\n")
	output.Add("\t Damage Specifics: <font color='blue'>[oxy_string]</font> - <font color='green'>[tox_string]</font> - <font color='#FFA500'>[burn_string]</font> - <font color='red'>[brute_string]</font>\n")
	output.Add("[SPAN_INFO("Body Temperature: [target.bodytemperature - T0C]&deg;C ([target.bodytemperature * 1.8-459.67]&deg;F)")]\n")

	// Handles time of death.
	if(isnotnull(target.tod) && (target.stat == DEAD || (target.status_flags & FAKEDEATH)))
		output.Add("[SPAN_INFO("Time of Death: [target.tod]")]\n")

	// Handles limb damage.
	if(ishuman(target) && mode == MODE_SHOW_LIMB_DAMAGE)
		var/mob/living/carbon/human/H = target
		output.Add("[SPAN_INFO("Localised Damage (<font color='red'>Brute</font>/<font color='#FFA500'>Burn</font>):")]\n")
		var/list/damaged_organs = H.get_damaged_organs(TRUE, TRUE)
		if(length(damaged_organs) > 0)
			for(var/datum/organ/external/organ in damaged_organs)
				var/organ_bleeding = (organ.status & ORGAN_BLEEDING) ? SPAN_DANGER("\[Bleeding\]") : ""
				output.Add("\t [SPAN_INFO(capitalize(organ.display_name))]: [SPAN_WARNING(organ.brute_dam)][organ_bleeding] [SPAN_INFO("-")] <font color='#FFA500'>[organ.burn_dam]</font>\n")
		else
			output.Add("\t [SPAN_INFO("Limbs are OK.")]\n")

	// Overall damage statuses.
	oxy_string = (oxy_loss > 50) ? "<font color='blue'><b>Severe oxygen deprivation detected</b></font>" : "Subject bloodstream oxygen level normal"
	tox_string = (tox_loss > 50) ? "<font color='green'><b>Dangerous amount of toxins detected</b></font>" : "Subject bloodstream toxin level minimal"
	burn_string = (fire_loss > 50) ? "<font color='#FFA500'><b>Severe burn damage detected</b></font>" : "Subject burn injury status O.K"
	brute_string = (brute_loss > 50) ? "<font color='red'><b>Severe anatomical damage detected</b></font>" : "Subject brute-force injury status O.K"
	output.Add("[oxy_string] | [tox_string] | [burn_string] | [brute_string]\n")

	// Handles carbon-specific health features.
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		// Reagents.
		if(C.reagents.total_volume > 0)
			output.Add("[SPAN_WARNING("Warning: Unknown substance detected in subject's blood.")]\n")
		// Pathogens.
		if(length(C.virus2))
			for(var/virus_id in C.virus2)
				if(virus_id in virusDB)
					var/datum/data/record/V = virusDB[virus_id]
					output.Add("[SPAN_WARNING("Warning: Pathogen [V.fields["name"]] detected in subject's blood. Known antigen: [V.fields["antigen"]]")]\n")
			//user.show_message("\red Warning: Unknown pathogen detected in subject's blood.")

	// Handles genetic damage.
	if(target.getCloneLoss())
		output.Add("[SPAN_WARNING("Subject appears to have been imperfectly cloned.")]\n")

	// Handles diseases.
	for(var/datum/disease/D in target.viruses)
		if(D.hidden[SCANNER])
			continue
		output.Add("[SPAN_DANGER("Warning: [D.form] detected!")]\n")
		output.Add("[SPAN_DANGER("Name: [D.name].")]\n")
		output.Add("[SPAN_DANGER("Type: [D.spread].")]\n")
		output.Add("[SPAN_DANGER("Stage: [D.stage]/[D.max_stages].")]\n")
		output.Add("[SPAN_DANGER("Possible Cure: [D.cure].")]\n")

	// Handles rejuvenation chemicals.
	if(isnotnull(target.reagents))
		var/inaprovaline_amount = target.reagents.get_reagent_amount("inaprovaline")
		if(inaprovaline_amount != 0)
			output.Add("[SPAN_INFO("Bloodstream analysis located [inaprovaline_amount] units of rejuvenation chemicals.")]\n")

	// Handles brain status.
	if(target.has_brain_worms())
		output.Add("[SPAN_WARNING("Subject suffering from aberrant brain activity. Recommend further scanning.")]\n")
	else
		var/brain_loss = target.getBrainLoss()
		if(brain_loss >= 100 || ishuman(target) && target:brain_op_stage == 4)
			output.Add("[SPAN_WARNING("Subject is brain dead.")]\n")
		else if(brain_loss >= 60)
			output.Add("[SPAN_WARNING("Severe brain damage detected. Subject likely to have mental impairment.")]\n")
		else if(brain_loss >= 10)
			output.Add("[SPAN_WARNING("Significant brain damage detected. Subject may have had a concussion.")]\n")

	// Handles human-specific health features.
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		// Fractures and infected wounds.
		for(var/organ_name in H.organs_by_name)
			var/datum/organ/external/e = H.organs_by_name[organ_name]
			var/limb = e.display_name
			if(e.status & ORGAN_BROKEN)
				if((e.name == "l_arm" || e.name == "r_arm" || e.name == "l_leg" || e.name == "r_leg") && !(e.status & ORGAN_SPLINTED))
					output.Add("[SPAN_WARNING("Unsecured fracture in subject [limb]. Splinting recommended for transport.")]\n")
			if(e.has_infected_wound())
				output.Add("[SPAN_WARNING("Infected wound detected in subject [limb]. Disinfection recommended.")]\n")
		for(var/organ_name in H.organs_by_name)
			var/datum/organ/external/e = H.organs_by_name[organ_name]
			if(e.status & ORGAN_BROKEN)
				output.Add("[SPAN_WARNING("Bone fractures detected. Advanced scanner required for location.")]\n")
				break
		// Internal bleeding.
		for(var/datum/organ/external/e in H.organs)
			for(var/datum/wound/W in e.wounds)
				if(W.internal)
					output.Add("[SPAN_WARNING("Internal bleeding detected. Advanced scanner required for location.")]\n")
					break
		// Blood level.
		if(H.vessel)
			var/blood_volume = round(H.vessel.get_reagent_amount("blood"))
			var/blood_percent = blood_volume / 560
			blood_percent *= 100
			if(blood_volume <= 500)
				output.Add("[SPAN_DANGER("Warning: Blood Level LOW: [blood_percent]% [blood_volume]cl")]\n")
			else if(blood_volume <= 336)
				output.Add("[SPAN_DANGER("Warning: Blood Level CRITICAL: [blood_percent]% [blood_volume]cl")]\n")
			else
				output.Add("[SPAN_INFO("Blood Level Normal: [blood_percent]% [blood_volume]cl")]\n")
		// Pulse.
		var/pulse_string = "<font color='[H.pulse == PULSE_THREADY || H.pulse == PULSE_NONE ? "red" : "blue"]'>[H.get_pulse(GETPULSE_TOOL)] bpm.</font>"
		output.Add("[SPAN_INFO("Subject's pulse:")] [pulse_string]") // No /n needed here.

	// Outputs the joined text.
	user.show_message(jointext(output, ""), 1)

#undef MODE_SHOW_LIMB_DAMAGE
#undef MODE_HIDE_LIMB_DAMAGE