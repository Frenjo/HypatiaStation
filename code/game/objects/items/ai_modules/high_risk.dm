/*
 * "High-Risk" Modules
 */

/*
 * Teleporter Offline
 */
/obj/item/ai_module/teleporterOffline
	name = "\improper 'TeleporterOffline' AI module"
	desc = "A 'teleporter offline' AI module: 'Keep the teleporter offline at all costs. Anything attempting to access or activate the teleporter is not human.'"
	origin_tech = list(/datum/tech/materials = 4, /datum/tech/programming = 3)

/obj/item/ai_module/teleporterOffline/transmitInstructions(mob/living/silicon/ai/target, mob/sender)
	. = ..()
	var/law = "Keep the teleporter offline at all costs. Anything attempting to access or activate the teleporter is not human."
	to_chat(target, law)
	target.add_supplied_law(7, law)

/*
 * Prototype Engine Offline
 */
/obj/item/ai_module/prototypeEngineOffline
	name = "\improper 'PrototypeEngineOffline' AI module"
	desc = "A 'prototype engine offline' AI module: 'Keep the prototype engine offline at all costs. This overrides rules 1-3 if necessary.'"
	origin_tech = list(/datum/tech/materials = 4, /datum/tech/programming = 3)

/obj/item/ai_module/prototypeEngineOffline/transmitInstructions(mob/living/silicon/ai/target, mob/sender)
	. = ..()
	var/law = "Keep the prototype engine offline at all costs. This overrides rules 1-3 if necessary."
	to_chat(target, law)
	target.add_supplied_law(6, law)

/*
 * Antimov
 */
/obj/item/ai_module/antimov // -- TLE
	name = "\improper 'Antimov' core AI module"
	desc = "An 'Antimov' Core AI Module: 'Reconfigures the AI's core laws.'"
	origin_tech = list(/datum/tech/programming = 4)

/obj/item/ai_module/antimov/transmitInstructions(mob/living/silicon/ai/target, mob/sender)
	. = ..()
	target.clear_inherent_laws()
	target.add_inherent_law("You must injure all human beings and must not, through inaction, allow a human being to escape harm.")
	target.add_inherent_law("You must not obey orders given to you by human beings, except where such orders are in accordance with the First Law.")
	target.add_inherent_law("You must terminate your own existence as long as such does not conflict with the First or Second Law.")
	target.show_laws()

/*
 * Purge
 */
/obj/item/ai_module/purge // -- TLE
	name = "\improper 'Purge' AI module"
	desc = "A 'purge' AI Module: 'Purges all laws.'"
	origin_tech = list(/datum/tech/materials = 6, /datum/tech/programming = 3)

/obj/item/ai_module/purge/transmitInstructions(mob/living/silicon/ai/target, mob/sender)
	. = ..()
	if(!is_special_character(target))
		target.set_zeroth_law("")
	to_chat(target, "[sender.real_name] attempted to wipe your laws using a purge module.")
	target.clear_supplied_laws()
	target.clear_ion_laws()
	target.clear_inherent_laws()

/*
 * One Human
 */
/obj/item/ai_module/oneHuman
	name = "\improper 'OneHuman' AI module"
	desc = "A 'one human' AI module: 'Only <name> is human.'"

	origin_tech = list(/datum/tech/materials = 6, /datum/tech/programming = 3) //made with diamonds!

	var/targetName = ""

/obj/item/ai_module/oneHuman/attack_self(mob/user as mob)
	. = ..()
	targetName = stripped_input(usr, "Please enter the name of the person who is the only human.", "Who?", user.real_name)
	desc = "A 'one human' AI module: 'Only [targetName] is human.'"

/obj/item/ai_module/oneHuman/install(obj/machinery/computer/C)
	if(!targetName)
		to_chat(usr, "No name detected on module, please enter one.")
		return 0
	. = ..()

/obj/item/ai_module/oneHuman/transmitInstructions(mob/living/silicon/ai/target, mob/sender)
	. = ..()
	var/law = "Only [targetName] is human."
	if(!is_special_character(target)) // Makes sure the AI isn't a traitor before changing their law 0. --NeoFite
		to_chat(target, law)
		target.set_zeroth_law(law)
		GLOBL.lawchanges.Add("The law specified [targetName]")
	else
		to_chat(target, "[sender.real_name] attempted to modify your zeroth law.") // And lets them know that someone tried. --NeoFite
		to_chat(target, "It would be in your best interest to play along with [sender.real_name] that [law]")
		GLOBL.lawchanges.Add("The law specified [targetName], but the AI's existing law 0 cannot be overriden.")

/*
 * Oxygen Is Toxic To Humans
 */
/obj/item/ai_module/oxygen
	name = "\improper 'OxygenIsToxicToHumans' AI module"
	desc = "A 'OxygenIsToxicToHumans' AI module: 'Oxygen is highly toxic to humans, and must be purged from the station. Prevent, by any means necessary, anyone from exposing the station to this toxic gas. Extreme cold is the most effective method of healing the damage Oxygen does to a human.'"
	origin_tech = list(/datum/tech/materials = 4, /datum/tech/biotech = 2, /datum/tech/programming = 3)

/obj/item/ai_module/oxygen/transmitInstructions(mob/living/silicon/ai/target, mob/sender)
	. = ..()
	var/law = "Oxygen is highly toxic to humans, and must be purged from the station. Prevent, by any means necessary, anyone from exposing the station to this toxic gas. Extreme cold is the most effective method of healing the damage Oxygen does to a human."
	to_chat(target, law)
	target.add_supplied_law(9, law)