/decl/special_role/wizard
	name = "Wizard"

	role_type = SPECIAL_ROLE_WIZARD
	role_flag = BE_WIZARD

/decl/special_role/wizard/setup(mob/living/carbon/human/wizard)
	. = ..()
	global.PCticker.mode.wizards.Add(wizard.mind)
	if(!length(GLOBL.wizardstart))
		wizard.forceMove(pick(GLOBL.latejoin))
		to_chat(wizard, "HOT INSERTION, GO GO GO!")
	else
		wizard.forceMove(pick(GLOBL.wizardstart))

	equip_wizard(wizard)
	name_wizard(wizard)
	forge_wizard_objectives(wizard)
	greet_wizard(wizard)

/decl/special_role/wizard/proc/equip_wizard(mob/living/carbon/human/wizard)
	if(!istype(wizard))
		return

	// So zards properly get their items when they are admin-made.
	qdel(wizard.wear_suit)
	qdel(wizard.head)
	qdel(wizard.shoes)
	qdel(wizard.r_hand)
	qdel(wizard.r_pocket)
	qdel(wizard.l_pocket)

	wizard.equip_outfit(/decl/hierarchy/outfit/wizard)
	wizard.update_icons()

	for(var/obj/item/spellbook/S in wizard.contents)
		S.op = 0

/decl/special_role/wizard/proc/name_wizard(mob/living/carbon/human/wizard)
	set waitfor = FALSE

	// Allows the wizard to choose a custom name or go with a random one.
	var/wizard_name_first = pick(GLOBL.wizard_first)
	var/wizard_name_second = pick(GLOBL.wizard_second)
	var/randomname = "[wizard_name_first] [wizard_name_second]"
	var/newname = copytext(sanitize(input(wizard, "You are the Space Wizard. Would you like to change your name to something else?", "Name change", randomname) as null | text), 1, MAX_NAME_LEN)
	if(!newname)
		newname = randomname

	wizard.real_name = newname
	wizard.name = newname
	if(isnotnull(wizard.mind))
		wizard.mind.name = newname

/decl/special_role/wizard/proc/forge_wizard_objectives(mob/living/carbon/human/wizard)
	var/datum/mind/wizard_mind = wizard.mind
	switch(rand(1, 100))
		if(1 to 30)
			var/datum/objective/assassinate/kill_objective = new /datum/objective/assassinate()
			kill_objective.owner = wizard_mind
			kill_objective.find_target()
			wizard_mind.objectives += kill_objective

			if(!(locate(/datum/objective/escape) in wizard_mind.objectives))
				var/datum/objective/escape/escape_objective = new /datum/objective/escape()
				escape_objective.owner = wizard_mind
				wizard_mind.objectives += escape_objective
		if(31 to 60)
			var/datum/objective/steal/steal_objective = new /datum/objective/steal()
			steal_objective.owner = wizard_mind
			steal_objective.find_target()
			wizard_mind.objectives += steal_objective

			if(!(locate(/datum/objective/escape) in wizard_mind.objectives))
				var/datum/objective/escape/escape_objective = new /datum/objective/escape()
				escape_objective.owner = wizard_mind
				wizard_mind.objectives += escape_objective

		if(61 to 100)
			var/datum/objective/assassinate/kill_objective = new /datum/objective/assassinate()
			kill_objective.owner = wizard_mind
			kill_objective.find_target()
			wizard_mind.objectives += kill_objective

			var/datum/objective/steal/steal_objective = new /datum/objective/steal()
			steal_objective.owner = wizard_mind
			steal_objective.find_target()
			wizard_mind.objectives += steal_objective

			if(!(locate(/datum/objective/survive) in wizard_mind.objectives))
				var/datum/objective/survive/survive_objective = new /datum/objective/survive()
				survive_objective.owner = wizard_mind
				wizard_mind.objectives += survive_objective

		else
			if(!(locate(/datum/objective/hijack) in wizard_mind.objectives))
				var/datum/objective/hijack/hijack_objective = new /datum/objective/hijack()
				hijack_objective.owner = wizard_mind
				wizard_mind.objectives += hijack_objective

/decl/special_role/wizard/proc/greet_wizard(mob/living/carbon/human/wizard)
	to_chat(wizard, SPAN_DANGER("<font size=3>You are the Space Wizard!</font>"))
	to_chat(wizard, "You will find a list of available spells in your spell book. Choose your magic arsenal carefully.")
	to_chat(wizard, "In your pockets you will find a teleport scroll. Use it as needed.")
	wizard.mind.store_memory("<B>Remember:</B> do not forget to prepare your spells.")
	to_chat(wizard, "<B>The Space Wizards Federation has given you the following tasks:</B>")
	show_objectives(wizard)