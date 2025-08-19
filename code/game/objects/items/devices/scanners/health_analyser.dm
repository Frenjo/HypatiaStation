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

	w_class = WEIGHT_CLASS_TINY
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
			SPAN_WARNING("[user] tries to analyse \the [target]'s vitals!"),
			SPAN_WARNING("You try to analyse \the [target]'s vitals!")
		)
		output_error(user, target, TRUE)
		return

	user.visible_message(
		SPAN_INFO("[user] analyses [M]'s vitals."),
		SPAN_INFO("You analyse [M]'s vitals.")
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

	health_scan(user, M, mode == MODE_SHOW_LIMB_DAMAGE)
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
		output.Add("\t Key: <font color='red'><em>Brute</em></font>/<font color='#FFA500'><em>Burn</em></font>/<font color='green'><em>Toxin</em></font>/<font color='blue'><em>Suffocation</em></font>")
		output.Add("\t Damage Specifics: <font color='red'>?</font> - <font color='#FFA500'>?</font> - <font color='green'>?</font> - <font color='blue'>?</font>")
		output.Add(SPAN_INFO("Body Temperature: [L.bodytemperature - T0C]&deg;C ([L.bodytemperature * 1.8-459.67]&deg;F)"))
		output.Add("[SPAN_DANGER("Warning: Blood Level ERROR: --% --cl.")] [SPAN_INFO("Type: ERROR")]")
		output.Add("[SPAN_INFO("Subject's pulse:")] <font color='red'>-- bpm.</font>")
	else
		output.Add(SPAN_INFO("Analysing results for <em>\the [target]</em>:"))
		output.Add("\t [SPAN_INFO("Overall Status: <em>Healthy</em>")]")
		output.Add("\t Key: <font color='red'><em>Brute</em></font>/<font color='#FFA500'><em>Burn</em></font>/<font color='green'><em>Toxin</em></font>/<font color='blue'><em>Suffocation</em></font>")
		output.Add("\t Damage Specifics: <font color='red'>[0]</font> - <font color='#FFA500'>[0]</font> - <font color='green'>[0]</font> - <font color='blue'>[0]</font>")
		output.Add(SPAN_INFO("Body Temperature: ???"))

	// Outputs the joined text.
	var/joined_output = jointext(output, "<br>")
	user.show_message("<div class='examine'>[joined_output]</div>", 1)

#undef MODE_SHOW_LIMB_DAMAGE
#undef MODE_HIDE_LIMB_DAMAGE