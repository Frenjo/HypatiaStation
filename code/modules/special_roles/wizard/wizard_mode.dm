
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

	var/list/selected_wizards = list()

	var/finished = 0

/datum/game_mode/wizard/get_announce_content()
	. = list()
	. += "<B>The current game mode is - Wizard!</B>"
	. += "<B>There is a [SPAN_WARNING("SPACE WIZARD")] on the station. You can't let them achieve their objective!</B>"

/datum/game_mode/wizard/pre_setup()
	. = ..()
	var/list/datum/mind/possible_wizards = get_players_for_role(/decl/special_role/wizard)
	if(!length(possible_wizards))
		return 0

	var/datum/mind/wizard = pick(possible_wizards)
	selected_wizards.Add(wizard)
	wizard.original = wizard.current

	if(!length(GLOBL.wizardstart))
		to_chat(wizard.current, SPAN_DANGER("A starting location for you could not be found, please report this bug!"))
		return 0

/datum/game_mode/wizard/post_setup()
	. = ..()
	var/decl/special_role/wizard/wizard_role = GET_DECL_INSTANCE(__IMPLIED_TYPE__)
	for_no_type_check(var/datum/mind/wizard, selected_wizards)
		wizard_role.setup(wizard.current)

/*/datum/game_mode/proc/learn_basic_spells(mob/living/carbon/human/wizard_mob)
	if (!istype(wizard_mob))
		return
	if(!CONFIG_GET(/decl/configuration_entry/feature_object_spell_system))
		wizard_mob.verbs += /client/proc/jaunt
		wizard_mob.mind.special_verbs += /client/proc/jaunt
	else
		wizard_mob.spell_list += new /obj/effect/proc_holder/spell/targeted/ethereal_jaunt(usr)
*/

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