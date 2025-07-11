
/datum/game_mode
	var/list/datum/mind/wizards = list()

/datum/game_mode/wizard
	name = "wizard"
	config_tag = "wizard"
	required_players = 2
	required_players_secret = 10
	required_enemies = 1
	recommended_enemies = 1

	uplink_welcome = "Wizardly Uplink Console:"
	uplink_uses = 10

	var/finished = 0

/datum/game_mode/wizard/get_announce_content()
	. = list()
	. += "<B>The current game mode is - Wizard!</B>"
	. += "<B>There is a [SPAN_WARNING("SPACE WIZARD")] on the station. You can't let them achieve their objective!</B>"

/datum/game_mode/wizard/can_start()//This could be better, will likely have to recode it later
	if(!..())
		return 0
	var/list/datum/mind/possible_wizards = get_players_for_role(BE_WIZARD)
	if(!length(possible_wizards))
		return 0
	var/datum/mind/wizard = pick(possible_wizards)
	wizards += wizard
	modePlayer += wizard
	wizard.assigned_role = "MODE" //So they aren't chosen for other jobs.
	wizard.special_role = "Wizard"
	wizard.original = wizard.current
	if(!length(GLOBL.wizardstart))
		to_chat(wizard.current, SPAN_DANGER("A starting location for you could not be found, please report this bug!"))
		return 0
	return 1

/datum/game_mode/wizard/pre_setup()
	for_no_type_check(var/datum/mind/wizard, wizards)
		wizard.current.forceMove(pick(GLOBL.wizardstart))
	return 1

/datum/game_mode/wizard/post_setup()
	. = ..()
	for_no_type_check(var/datum/mind/wizard, wizards)
		if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
			forge_wizard_objectives(wizard)
		//learn_basic_spells(wizard.current)
		equip_wizard(wizard.current)
		name_wizard(wizard.current)
		greet_wizard(wizard)

/datum/game_mode/proc/forge_wizard_objectives(datum/mind/wizard)
	switch(rand(1, 100))
		if(1 to 30)
			var/datum/objective/assassinate/kill_objective = new
			kill_objective.owner = wizard
			kill_objective.find_target()
			wizard.objectives += kill_objective

			if(!(locate(/datum/objective/escape) in wizard.objectives))
				var/datum/objective/escape/escape_objective = new
				escape_objective.owner = wizard
				wizard.objectives += escape_objective
		if(31 to 60)
			var/datum/objective/steal/steal_objective = new
			steal_objective.owner = wizard
			steal_objective.find_target()
			wizard.objectives += steal_objective

			if(!(locate(/datum/objective/escape) in wizard.objectives))
				var/datum/objective/escape/escape_objective = new
				escape_objective.owner = wizard
				wizard.objectives += escape_objective

		if(61 to 100)
			var/datum/objective/assassinate/kill_objective = new
			kill_objective.owner = wizard
			kill_objective.find_target()
			wizard.objectives += kill_objective

			var/datum/objective/steal/steal_objective = new
			steal_objective.owner = wizard
			steal_objective.find_target()
			wizard.objectives += steal_objective

			if(!(locate(/datum/objective/survive) in wizard.objectives))
				var/datum/objective/survive/survive_objective = new
				survive_objective.owner = wizard
				wizard.objectives += survive_objective

		else
			if(!(locate(/datum/objective/hijack) in wizard.objectives))
				var/datum/objective/hijack/hijack_objective = new
				hijack_objective.owner = wizard
				wizard.objectives += hijack_objective
	return


/datum/game_mode/proc/name_wizard(mob/living/carbon/human/wizard_mob)
	//Allows the wizard to choose a custom name or go with a random one. Spawn 0 so it does not lag the round starting.
	var/wizard_name_first = pick(GLOBL.wizard_first)
	var/wizard_name_second = pick(GLOBL.wizard_second)
	var/randomname = "[wizard_name_first] [wizard_name_second]"
	spawn(0)
		var/newname = copytext(sanitize(input(wizard_mob, "You are the Space Wizard. Would you like to change your name to something else?", \
											"Name change", randomname) as null | text), 1, MAX_NAME_LEN)

		if(!newname)
			newname = randomname

		wizard_mob.real_name = newname
		wizard_mob.name = newname
		if(wizard_mob.mind)
			wizard_mob.mind.name = newname
	return


/datum/game_mode/proc/greet_wizard(datum/mind/wizard, you_are = 1)
	if(you_are)
		to_chat(wizard.current, SPAN_DANGER("You are the Space Wizard!"))
	to_chat(wizard.current, "<B>The Space Wizards Federation has given you the following tasks:</B>")
	if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
		var/obj_count = 1
		for_no_type_check(var/datum/objective/objective, wizard.objectives)
			to_chat(wizard.current, "<B>Objective #[obj_count]</B>: [objective.explanation_text]")
			obj_count++
	else
		FEEDBACK_ANTAGONIST_GREETING_GUIDE(wizard.current)
	return


/*/datum/game_mode/proc/learn_basic_spells(mob/living/carbon/human/wizard_mob)
	if (!istype(wizard_mob))
		return
	if(!CONFIG_GET(/decl/configuration_entry/feature_object_spell_system))
		wizard_mob.verbs += /client/proc/jaunt
		wizard_mob.mind.special_verbs += /client/proc/jaunt
	else
		wizard_mob.spell_list += new /obj/effect/proc_holder/spell/targeted/ethereal_jaunt(usr)
*/

/datum/game_mode/proc/equip_wizard(mob/living/carbon/human/wizard_mob)
	if(!istype(wizard_mob))
		return

	//So zards properly get their items when they are admin-made.
	qdel(wizard_mob.wear_suit)
	qdel(wizard_mob.head)
	qdel(wizard_mob.shoes)
	qdel(wizard_mob.r_hand)
	qdel(wizard_mob.r_pocket)
	qdel(wizard_mob.l_pocket)

	wizard_mob.equip_outfit(/decl/hierarchy/outfit/wizard)

	to_chat(wizard_mob, "You will find a list of available spells in your spell book. Choose your magic arsenal carefully.")
	to_chat(wizard_mob, "In your pockets you will find a teleport scroll. Use it as needed.")
	wizard_mob.mind.store_memory("<B>Remember:</B> do not forget to prepare your spells.")
	wizard_mob.update_icons()
	return 1

/datum/game_mode/wizard/check_finished()
	if(CONFIG_GET(/decl/configuration_entry/continous_rounds))
		return ..()

	var/wizards_alive = 0
	for_no_type_check(var/datum/mind/wizard, wizards)
		if(!iscarbon(wizard.current))
			continue
		if(wizard.current.stat == DEAD)
			continue
		wizards_alive++

	if(wizards_alive)
		return ..()
	else
		finished = 1
		return 1

/datum/game_mode/wizard/declare_completion()
	if(finished)
		feedback_set_details("round_end_result", "loss - wizard killed")
		to_world(SPAN_DANGER("<FONT size = 3>The wizard[(length(wizards) > 1) ? "s" : ""] has been killed by the crew! The Space Wizards Federation has been taught a lesson they will not soon forget!</FONT>"))
	..()
	return 1

/datum/game_mode/proc/auto_declare_completion_wizard()
	if(!length(wizards))
		return

	var/text = "<FONT size = 2><B>The wizards/witches were:</B></FONT>"
	for_no_type_check(var/datum/mind/wizard, wizards)
		text += "<br>[wizard.key] was [wizard.name] ("
		if(isnotnull(wizard.current))
			if(wizard.current.stat == DEAD)
				text += "died"
			else
				text += "survived"
			if(wizard.current.real_name != wizard.name)
				text += " as [wizard.current.real_name]"
		else
			text += "body destroyed"
		text += ")"

		var/count = 1
		var/wizardwin = TRUE
		if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
			for_no_type_check(var/datum/objective/objective, wizard.objectives)
				if(objective.check_completion())
					text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='green'><B>Success!</B></font>"
					feedback_add_details("wizard_objective", "[objective.type]|SUCCESS")
				else
					text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='red'>Fail.</font>"
					feedback_add_details("wizard_objective", "[objective.type]|FAIL")
					wizardwin = FALSE
				count++

			if(isnotnull(wizard.current) && wizard.current.stat != DEAD && wizardwin)
				text += "<br><font color='green'><B>The wizard was successful!</B></font>"
				feedback_add_details("wizard_success", "SUCCESS")
			else
				text += "<br><font color='red'><B>The wizard has failed!</B></font>"
				feedback_add_details("wizard_success", "FAIL")
	to_world(text)

//OTHER PROCS

//To batch-remove wizard spells. Linked to mind.dm.
/mob/proc/spellremove(mob/M)
	for(var/obj/effect/proc_holder/spell/spell_to_remove in src.spell_list)
		qdel(spell_to_remove)

/*Checks if the wizard can cast spells.
Made a proc so this is not repeated 14 (or more) times.*/
/mob/proc/casting()
//Removed the stat check because not all spells require clothing now.
	if(!istype(usr:wear_suit, /obj/item/clothing/suit/wizrobe))
		to_chat(usr, "I don't feel strong enough without my robe.")
		return 0
	if(!istype(usr:shoes, /obj/item/clothing/shoes/sandal))
		to_chat(usr, "I don't feel strong enough without my sandals.")
		return 0
	if(!istype(usr:head, /obj/item/clothing/head/wizard))
		to_chat(usr, "I don't feel strong enough without my hat.")
		return 0
	else
		return 1