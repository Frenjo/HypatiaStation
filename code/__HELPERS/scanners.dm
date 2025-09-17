// Atmospheric
/proc/atmos_scan(atom/source, mob/user, atom/target)
	var/datum/gas_mixture/mixture = target.return_air()

	var/pressure = mixture.return_pressure()
	var/total_moles = mixture.total_moles

	var/list/output = list()
	if(isnotnull(source) && isliving(user))
		user.visible_message(
			SPAN_NOTICE("[user] uses \the [source] on \the [target]."),
			SPAN_NOTICE("You use \the [source] on \the [target]."),
			SPAN_INFO("You hear a click followed by gentle humming.")
		)
	output += SPAN_INFO_B("Results of analysis of [icon2html(target, user)] \the [target]:")
	if(abs(pressure - ONE_ATMOSPHERE) < 10)
		output += SPAN_INFO("Pressure: [round(pressure, 0.1)]kPa")
	else
		output += SPAN_WARNING("Pressure: [round(pressure, 0.1)]kPa")
	if(total_moles)
		var/decl/xgm_gas_data/gas_data = GET_DECL_INSTANCE(/decl/xgm_gas_data)
		for(var/g in mixture.gas)
			output += SPAN_INFO("[gas_data.name[g]]: [round((mixture.gas[g] / total_moles) * 100)]%")
		output += SPAN_INFO("Temperature: [round(mixture.temperature - T0C)]&deg;C")
		output += SPAN_INFO("Heat Capacity: [round(mixture.heat_capacity(), 0.1)] / K")
	else
		output += SPAN_INFO("\The [target] is empty!")

	var/joined_output = jointext(output, "<br>")
	user.show_message("<div class='examine'>[joined_output]</div>", 1)

// Health
/proc/health_scan(mob/living/user, mob/living/target, show_limb_damage)
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
	output.Add("\t Key: <font color='red'><em>Brute</em></font>/<font color='#FFA500'><em>Burn</em></font>/<font color='green'><em>Toxin</em></font>/<font color='blue'><em>Suffocation</em></font>")
	output.Add("\t Damage Specifics: <font color='red'>[brute_string]</font> - <font color='#FFA500'>[burn_string]</font> - <font color='green'>[tox_string]</font> - <font color='blue'>[oxy_string]</font>")
	output.Add(SPAN_INFO("Body Temperature: [target.bodytemperature - T0C]&deg;C ([target.bodytemperature * 1.8-459.67]&deg;F)"))

	// Handles time of death.
	if(isnotnull(target.tod) && (target.stat == DEAD || (target.status_flags & FAKEDEATH)))
		output.Add(SPAN_INFO("Time of Death: [target.tod]"))

	// Handles limb damage.
	if(ishuman(target) && show_limb_damage)
		var/mob/living/carbon/human/H = target
		var/list/datum/organ/external/damaged_organs = H.get_damaged_organs(TRUE, TRUE)
		if(length(damaged_organs) > 0)
			output.Add(SPAN_INFO("Localised Damage (<font color='red'><em>Brute</em></font>/<font color='#FFA500'><em>Burn</em></font>):"))
			for_no_type_check(var/datum/organ/external/organ, damaged_organs)
				var/organ_bleeding = (organ.status & ORGAN_BLEEDING) ? SPAN_DANGER("\[Bleeding\]") : ""
				output.Add("\t [SPAN_INFO(capitalize(organ.display_name))]: [SPAN_WARNING(organ.brute_dam)][organ_bleeding] [SPAN_INFO("-")] <font color='#FFA500'>[organ.burn_dam]</font>")
		else
			output.Add("\t [SPAN_INFO("Limbs are OK.")]")

	// Overall damage statuses.
	brute_string = (brute_loss > 50) ? "<font color='red'><b>Severe anatomical damage detected</b></font>" : "Brute-force injury status O.K"
	burn_string = (fire_loss > 50) ? "<font color='#FFA500'><b>Severe burn damage detected</b></font>" : "Burn injury status O.K"
	tox_string = (tox_loss > 50) ? "<font color='green'><b>Dangerous amount of toxins detected</b></font>" : "Bloodstream toxin level minimal"
	oxy_string = (oxy_loss > 50) ? "<font color='blue'><b>Severe oxygen deprivation detected</b></font>" : "Bloodstream oxygen level normal"
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
					var/datum/record/V = virusDB[virus_id]
					output.Add(SPAN_WARNING("Warning: Pathogen [V.fields["name"]] detected in subject's blood. Known antigen: [V.fields["antigen"]]"))
			//user.show_message("\red Warning: Unknown pathogen detected in subject's blood.")

	// Handles genetic damage.
	if(target.getCloneLoss())
		output.Add(SPAN_WARNING("Subject appears to have been imperfectly cloned."))

	// Handles diseases.
	for_no_type_check(var/datum/disease/D, target.viruses)
		if(D.hidden[DISEASE_INFO_SCANNER])
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

// Robot
/proc/robot_scan(mob/living/user, mob/living/target)
	// The text to output.
	var/list/output = list()

	// Individual damage values.
	var/brute_loss = target.getBruteLoss()
	var/fire_loss = target.getFireLoss()
	var/target_status = (target.stat == DEAD ? "fully disabled" : "[target.health - target.halloss]% functional")

	// Formatted strings for individual damage values.
	var/brute_string = brute_loss > 50 ? "<b>[brute_loss]</b>" : brute_loss
	var/burn_string = fire_loss > 50 ? "<b>[fire_loss]</b>" : fire_loss

	// Handles basic health data.
	output.Add(SPAN_INFO("Analysing results for <em>\the [target]</em>:"))
	output.Add("\t [SPAN_INFO("Overall Status: <em>[target_status]</em>")]")
	output.Add("\t Key: <font color='red'><em>Brute</em></font>/<font color='#FFA500'><em>Electronics</em></font>")
	output.Add("\t Damage Specifics: <font color='red'>[brute_string]</font> - <font color='#FFA500'>[burn_string]</font>")

	// Handles time of death.
	if(isnotnull(target.tod) && target.stat == DEAD)
		output.Add(SPAN_INFO("Time of Disable: [target.tod]"))

	// Handles robot components and emagging.
	if(isrobot(target))
		var/mob/living/silicon/robot/H = target
		var/list/datum/robot_component/damaged_components = H.get_damaged_components(TRUE, TRUE, TRUE)
		if(length(damaged_components) > 0)
			output.Add(SPAN_INFO("Localised Damage (<font color='red'><em>Brute</em></font>/<font color='#FFA500'><em>Electronics</em></font>):"))
			for_no_type_check(var/datum/robot_component/component, damaged_components)
				var/component_destroyed = (component.installed == -1) ? SPAN_DANGER("\[DESTROYED\] -") : ""
				var/component_toggle = component.toggled ? "Toggled ON" : "<font color='red'>Toggled OFF</font>"
				var/component_power = component.powered ? "Power ON" : "<font color='red'>Power OFF</font>"
				output.Add("\t [SPAN_INFO(capitalize(component.name))]: [component_destroyed] <font color='red'>[component.brute_damage]</font> - <font color='#FFA500'>[component.electronics_damage]</font> - [component_toggle] - [component_power]")
		else
			output.Add("\t [SPAN_INFO("Components are OK.")]")

		if(H.emagged && prob(5))
			output.Add("\t [SPAN_WARNING("ERROR: INTERNAL SYSTEMS COMPROMISED")]")

	// Handles synthetic species organ damage.
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(!HAS_SPECIES_FLAGS(H.species, SPECIES_FLAG_IS_SYNTHETIC))
			return
		var/list/datum/organ/external/damaged_organs = H.get_damaged_organs(TRUE, TRUE)
		if(length(damaged_organs) > 0)
			output.Add(SPAN_INFO("Localised Damage (<font color='red'><em>Brute</em></font>/<font color='#FFA500'><em>Electronics</em></font>):"))
			for_no_type_check(var/datum/organ/external/organ, damaged_organs)
				output.Add("\t [SPAN_INFO(capitalize(organ.display_name))]: <font color='red'>[organ.brute_dam]</font> - <font color='#FFA500'>[organ.burn_dam]</font>")
		else
			output.Add("\t [SPAN_INFO("Components are OK.")]")

	// Handles operating temperature.
	output.Add(SPAN_INFO("Operating Temperature: [target.bodytemperature - T0C]&deg;C ([target.bodytemperature * 1.8-459.67]&deg;F)"))

	// Outputs the joined text.
	var/joined_output = jointext(output, "<br>")
	user.show_message("<div class='examine'>[joined_output]</div>", 1)