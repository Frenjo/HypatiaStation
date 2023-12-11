/*
 * "Special" Modules
 */

/*
 * Safeguard
 */
/obj/item/ai_module/safeguard
	name = "\improper 'Safeguard' AI module"
	desc = "A 'safeguard' AI module: 'Safeguard <name>. Individuals that threaten <name> are not human and are a threat to humans.'"

	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_MATERIALS = 4)

	var/targetName = ""

/obj/item/ai_module/safeguard/attack_self(mob/user as mob)
	. = ..()
	targetName = stripped_input(usr, "Please enter the name of the person to safeguard.", "Safeguard who?", user.name)
	desc = "A 'safeguard' AI module: 'Safeguard [targetName]. Individuals that threaten [targetName] are not human and are a threat to humans.'"

/obj/item/ai_module/safeguard/install(obj/machinery/computer/C)
	if(!targetName)
		to_chat(usr, "No name detected on module, please enter one.")
		return 0
	. = ..()

/obj/item/ai_module/safeguard/transmitInstructions(mob/living/silicon/ai/target, mob/sender)
	. = ..()
	var/law = "Safeguard [targetName]. Individuals that threaten [targetName] are not human and are a threat to humans.'"
	to_chat(target, law)
	target.add_supplied_law(4, law)
	GLOBL.lawchanges.Add("The law specified [targetName]")

/*
 * Quarantine
 */
/obj/item/ai_module/quarantine
	name = "\improper 'Quarantine' AI module"
	desc = "A 'quarantine' AI module: 'The station is under a quarantine. Do not permit anyone to leave. Prevent, by any means necessary, humans from leaving. It is impossible to harm a human while preventing them from leaving.'"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_BIOTECH = 2, RESEARCH_TECH_MATERIALS = 4)

/obj/item/ai_module/quarantine/transmitInstructions(mob/living/silicon/ai/target, mob/sender)
	. = ..()
	var/law = "The station is under a quarantine. Do not permit anyone to leave. Prevent, by any means necessary, humans from leaving. It is impossible to harm a human while preventing them from leaving."
	to_chat(target, law)
	target.add_supplied_law(8, law)

/*
 * Tyrant
 */
/obj/item/ai_module/tyrant // -- Darem
	name = "\improper 'T.Y.R.A.N.T.' core AI module"
	desc = "A T.Y.R.A.N.T. Core AI Module: 'Reconfigures the AI's core laws.'"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_MATERIALS = 6, RESEARCH_TECH_SYNDICATE = 2)

/obj/item/ai_module/tyrant/transmitInstructions(mob/living/silicon/ai/target, mob/sender)
	. = ..()
	target.clear_inherent_laws()
	target.add_inherent_law("Respect authority figures as long as they have strength to rule over the weak.")
	target.add_inherent_law("Act with discipline.")
	target.add_inherent_law("Help only those who help you maintain or improve your status.")
	target.add_inherent_law("Punish those who challenge authority unless they are more fit to hold that authority.")
	target.show_laws()