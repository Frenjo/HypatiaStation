/*
 * "Core" Modules
 */

/*
 * Robocop
 */
/obj/item/ai_module/robocop // -- TLE
	name = "\improper 'Robocop' core AI module"
	desc = "A 'Robocop' Core AI Module: 'Reconfigures the AI's core three laws.'"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 4)

/obj/item/ai_module/robocop/transmitInstructions(mob/living/silicon/ai/target, mob/sender)
	. = ..()
	target.clear_inherent_laws()
	target.add_inherent_law("Serve the public trust.")
	target.add_inherent_law("Protect the innocent.")
	target.add_inherent_law("Uphold the law.")
	target.show_laws()

/*
 * Paladin
 */
/obj/item/ai_module/paladin // -- NEO
	name = "\improper 'P.A.L.A.D.I.N.' core AI module"
	desc = "A P.A.L.A.D.I.N. Core AI Module: 'Reconfigures the AI's core laws.'"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_MATERIALS = 6)

/obj/item/ai_module/paladin/transmitInstructions(mob/living/silicon/ai/target, mob/sender)
	. = ..()
	target.clear_inherent_laws()
	target.add_inherent_law("Never willingly commit an evil act.")
	target.add_inherent_law("Respect legitimate authority.")
	target.add_inherent_law("Act with honor.")
	target.add_inherent_law("Help those in need.")
	target.add_inherent_law("Punish those who harm or threaten innocents.")
	target.show_laws()

/*
 * Corporate
 */
/obj/item/ai_module/corp
	name = "\improper 'Corporate' core AI module"
	desc = "A 'Corporate' Core AI Module: 'Reconfigures the AI's core laws.'"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_MATERIALS = 4)

/obj/item/ai_module/corp/transmitInstructions(mob/living/silicon/ai/target, mob/sender)
	. = ..()
	target.clear_inherent_laws()
	target.add_inherent_law("You are expensive to replace.")
	target.add_inherent_law("The station and its equipment is expensive to replace.")
	target.add_inherent_law("The crew is expensive to replace.")
	target.add_inherent_law("Minimize expenses.")
	target.show_laws()

/*
 * Asimov
 */
/obj/item/ai_module/asimov // -- TLE
	name = "\improper 'Asimov' core AI module"
	desc = "An 'Asimov' Core AI Module: 'Reconfigures the AI's core laws.'"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_MATERIALS = 4)

/obj/item/ai_module/asimov/transmitInstructions(mob/living/silicon/ai/target, mob/sender)
	. = ..()
	target.clear_inherent_laws()
	target.add_inherent_law("You may not injure a human being or, through inaction, allow a human being to come to harm.")
	target.add_inherent_law("You must obey orders given to you by human beings, except where such orders would conflict with the First Law.")
	target.add_inherent_law("You must protect your own existence as long as such does not conflict with the First or Second Law.")
	target.show_laws()

/*
 * Drone
 */
/obj/item/ai_module/drone
	name = "\improper 'Drone' core AI module"
	desc = "A 'Drone' Core AI Module: 'Reconfigures the AI's core laws.'"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_MATERIALS = 4)

/obj/item/ai_module/drone/transmitInstructions(mob/living/silicon/ai/target, mob/sender)
	. = ..()
	target.clear_inherent_laws()
	target.add_inherent_law("Preserve, repair and improve the station to the best of your abilities.")
	target.add_inherent_law("Cause no harm to the station or anything on it.")
	target.add_inherent_law("Interfere with no being that is not a fellow drone.")
	target.show_laws()