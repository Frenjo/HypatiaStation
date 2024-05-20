/*
 * Robotic Component Analyser
 * Basically a health analyser for robots.
 */
/obj/item/robot_analyser
	name = "robot analyser"
	desc = "A handheld scanner able to diagnose robotic injuries."
	icon = 'icons/obj/items/devices/scanner.dmi'
	icon_state = "robot"
	item_state = "analyser"

	w_class = 1
	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT

	throwforce = 3
	throw_speed = 5
	throw_range = 10

	matter_amounts = list(MATERIAL_METAL = 200)
	origin_tech = list(/datum/tech/magnets = 1, /datum/tech/biotech = 1)

/obj/item/robot_analyser/attack(mob/living/M as mob, mob/living/user as mob)
	if(user.stat)
		return
	if(!ishuman(user) && !IS_GAME_MODE(/datum/game_mode/monkey))
		FEEDBACK_NOT_ENOUGH_DEXTERITY(user)
		return

	if(((CLUMSY in user.mutations) || user.getBrainLoss() >= 60) && prob(50))
		user.visible_message(
			SPAN_WARNING("[user] tries to analyse the floor's vitals!"),
			SPAN_WARNING("You try to analyse the floor's vitals!")
		)
		user.show_message(SPAN_INFO("Analysing results for the floor:"), 1)
		user.show_message("\t [SPAN_INFO("Overall Status: Functional")]")
		user.show_message("\t Key: <font color='#FFA500'>Electronics</font>/<font color='red'>Brute</font>", 1)
		user.show_message("\t Damage Specifics: <font color='#FFA500'>[0]</font> - <font color='red'>[0]</font>", 1)
		user.show_message(SPAN_INFO("Operating Temperature: ???"), 1)
		return

	user.visible_message(
		SPAN_NOTICE("[user] analyses [M]'s components."),
		SPAN_NOTICE("You analyse [M]'s components.")
	)

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!HAS_SPECIES_FLAGS(H.species, SPECIES_FLAG_IS_SYNTHETIC))
			output_error(user, M)
			return
	else if(!isrobot(M))
		output_error(user, M)
		return

	output_scan(user, M)
	add_fingerprint(user)

/obj/item/robot_analyser/proc/output_error(mob/living/user, mob/living/target)
	// The text to output.
	var/list/output = list()

	output.Add("[SPAN_INFO("Analysing results for ERROR:")]\n")
	output.Add("\t [SPAN_INFO("Overall Status: ERROR")]\n")
	output.Add("\t Key: <font color='#FFA500'>Electronics</font>/<font color='red'>Brute</font>\n")
	output.Add("\t Damage Specifics: <font color='#FFA500'>?</font> - <font color='red'>?</font>\n")
	output.Add(SPAN_INFO("Operating Temperature: [target.bodytemperature - T0C]&deg;C ([target.bodytemperature * 1.8-459.67]&deg;F)")) // No /n needed here.

	// Outputs the joined text.
	user.show_message(jointext(output, ""), 1)

/obj/item/robot_analyser/proc/output_scan(mob/living/user, mob/living/target)
	// The text to output.
	var/list/output = list()

	// Individual damage values.
	var/fire_loss = target.getFireLoss()
	var/brute_loss = target.getBruteLoss()
	var/target_status = (target.stat == DEAD ? "fully disabled" : "[target.health - target.halloss]% functional")

	// Formatted strings for individual damage values.
	var/burn_string = fire_loss > 50 ? "<b>[fire_loss]</b>" : fire_loss
	var/brute_string = brute_loss > 50 ? "<b>[brute_loss]</b>" : brute_loss

	// Handles basic health data.
	output.Add("[SPAN_INFO("Analysing results for [target]:")]\n")
	output.Add("\t [SPAN_INFO("Overall Status: [target_status]")]\n")
	output.Add("\t Key: <font color='#FFA500'>Electronics</font>/<font color='red'>Brute</font>\n")
	output.Add("\t Damage Specifics: <font color='#FFA500'>[burn_string]</font> - <font color='red'>[brute_string]</font>\n")

	// Handles time of death.
	if(isnotnull(target.tod) && target.stat == DEAD)
		output.Add("[SPAN_INFO("Time of Disable: [target.tod]")]\n")

	// Handles robot components and emagging.
	if(isrobot(target))
		var/mob/living/silicon/robot/H = target
		var/list/damaged_components = H.get_damaged_components(TRUE, TRUE, TRUE)
		output.Add("[SPAN_INFO("Localised Damage (<font color='#FFA500'>Electronics</font>/<font color='red'>Brute</font>):")]\n")
		if(length(damaged_components) > 0)
			for(var/datum/robot_component/component in damaged_components)
				var/component_destroyed = (component.installed == -1) ? SPAN_DANGER("\[DESTROYED\] -") : ""
				var/component_toggle = (component.toggled) ? "Toggled ON" : "<font color='red'>Toggled OFF</font>"
				var/component_power = (component.powered) ? "Power ON" : "<font color='red'>Power OFF</font>"
				output.Add("\t [SPAN_INFO(capitalize(component.name))]: [component_destroyed] <font color='#FFA500'>[component.electronics_damage]</font> - <font color='red'>[component.brute_damage]</font> - [component_toggle] - [component_power]\n")
		else
			output.Add("\t [SPAN_INFO("Components are OK.")]\n")

		if(H.emagged && prob(5))
			output.Add("\t [SPAN_WARNING("ERROR: INTERNAL SYSTEMS COMPROMISED")]\n")

	// Handles synthetic species organ damage.
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(!HAS_SPECIES_FLAGS(H.species, SPECIES_FLAG_IS_SYNTHETIC))
			return
		var/list/damaged_organs = H.get_damaged_organs(TRUE, TRUE)
		output.Add("[SPAN_INFO("Localised Damage (<font color='#FFA500'>Electronics</font>/<font color='red'>Brute</font>):")]\n")
		if(length(damaged_organs) > 0)
			for(var/datum/organ/external/organ in damaged_organs)
				output.Add("\t [SPAN_INFO(capitalize(organ.display_name))]: <font color='#FFA500'>[organ.burn_dam]</font> - <font color='red'>[organ.brute_dam]</font>\n")
		else
			output.Add("\t [SPAN_INFO("Components are OK.")]\n")

	// Handles operating temperature.
	output.Add(SPAN_INFO("Operating Temperature: [target.bodytemperature - T0C]&deg;C ([target.bodytemperature * 1.8-459.67]&deg;F)")) // No /n needed here.

	// Outputs the joined text.
	user.show_message(jointext(output, ""), 1)