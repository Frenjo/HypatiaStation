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

	matter_amounts = alist(/decl/material/plastic = 200, /decl/material/glass = 50)
	origin_tech = alist(/decl/tech/magnets = 1, /decl/tech/biotech = 1)

/obj/item/robot_analyser/attack(mob/living/M, mob/living/user)
	if(user.stat)
		return
	if(!ishuman(user) && !IS_GAME_MODE(/datum/game_mode/monkey))
		FEEDBACK_NOT_ENOUGH_DEXTERITY(user)
		return

	if(((MUTATION_CLUMSY in user.mutations) || user.getBrainLoss() >= 60) && prob(50))
		var/turf/target = GET_TURF(M)
		user.visible_message(
			SPAN_WARNING("[user] tries to analyse \the [target]'s vitals!"),
			SPAN_WARNING("You try to analyse \the [target]'s vitals!")
		)
		output_error(user, target, TRUE)
		return

	user.visible_message(
		SPAN_INFO("[user] analyses [M]'s components."),
		SPAN_INFO("You analyse [M]'s components.")
	)

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!HAS_SPECIES_FLAGS(H.species, SPECIES_FLAG_IS_SYNTHETIC))
			output_error(user, M)
			return
	else if(!isrobot(M))
		output_error(user, M)
		return

	robot_scan(user, M)
	add_fingerprint(user)

/obj/item/robot_analyser/proc/output_error(mob/living/user, atom/target, clumsy = FALSE)
	// The text to output.
	var/list/output = list()

	if(!clumsy)
		var/mob/living/L = target
		output.Add(SPAN_INFO("Analysing results for <em>ERROR</em>:"))
		output.Add("\t [SPAN_INFO("Overall Status: <em>ERROR</em>")]")
		output.Add("\t Key: <font color='red'><em>Brute</em></font>/<font color='#FFA500'><em>Electronics</em></font>")
		output.Add("\t Damage Specifics: <font color='red'>?</font>/<font color='#FFA500'>?</font>")
		output.Add(SPAN_INFO("Operating Temperature: [L.bodytemperature - T0C]&deg;C ([L.bodytemperature * 1.8-459.67]&deg;F)"))
	else
		output.Add(SPAN_INFO("Analysing results for <em>\the [target]</em>:"))
		output.Add("\t [SPAN_INFO("Overall Status: <em>Functional</em>")]")
		output.Add("\t Key: <font color='red'><em>Brute</em></font>/<font color='#FFA500'><em>Electronics</em></font>")
		output.Add("\t Damage Specifics: <font color='red'>[0]</font>/<font color='#FFA500'>[0]</font>")
		output.Add(SPAN_INFO("Operating Temperature: ???"))

	// Outputs the joined text.
	var/joined_output = jointext(output, "<br>")
	user.show_message("<div class='examine'>[joined_output]</div>", 1)