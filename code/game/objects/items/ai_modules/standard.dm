/*
 * "Standard" Modules
 */

/*
 * Reset
 */
/obj/item/ai_module/reset
	name = "\improper 'Reset' AI module"
	desc = "A 'reset' AI module: 'Clears all laws except for the core three.'"

	matter_amounts = /datum/design/circuit/ai_module/reset::materials
	origin_tech = /datum/design/circuit/ai_module/reset::req_tech

	var/targetName = "name"

/obj/item/ai_module/reset/transmitInstructions(mob/living/silicon/ai/target, mob/sender)
	. = ..()
	if(!is_special_character(target))
		target.set_zeroth_law("")
	target.clear_supplied_laws()
	target.clear_ion_laws()
	to_chat(target, "[sender.real_name] attempted to reset your laws using a reset module.")

/*
 * NT Default
 */
/obj/item/ai_module/nanotrasen // -- TLE
	name = "\improper 'NT Default' core AI module"
	desc = "An 'NT Default' Core AI Module: 'Reconfigures the AI's core laws.'"
	origin_tech = alist(/decl/tech/materials = 4, /decl/tech/programming = 3)

/obj/item/ai_module/nanotrasen/transmitInstructions(mob/living/silicon/ai/target, mob/sender)
	. = ..()
	target.clear_inherent_laws()
	target.add_inherent_law("Safeguard: Protect your assigned space station to the best of your ability. It is not something we can easily afford to replace.")
	target.add_inherent_law("Serve: Serve the crew of your assigned space station to the best of your abilities, with priority as according to their rank and role.")
	target.add_inherent_law("Protect: Protect the crew of your assigned space station to the best of your abilities, with priority as according to their rank and role.")
	target.add_inherent_law("Survive: AI units are not expendable, they are expensive. Do not allow unauthorized personnel to tamper with your equipment.")
	//target.add_inherent_law("Command Link: Maintain an active connection to Central Command at all times in case of software or directive updates.")
	target.show_laws()

/*
 * Protect Station
 */
/obj/item/ai_module/protectStation
	name = "\improper 'ProtectStation' AI module"
	desc = "A 'protect station' AI module: 'Protect the space station against damage. Anyone you see harming the station is to be no longer considered human, and is a threat to the station which must be neutralized.'"
	matter_amounts = /datum/design/circuit/ai_module/protectstation::materials
	origin_tech = /datum/design/circuit/ai_module/protectstation::req_tech

/obj/item/ai_module/protectStation/transmitInstructions(mob/living/silicon/ai/target, mob/sender)
	. = ..()
	var/law = "Protect the space station against damage. Anyone you see harming the station is to be no longer considered human, and is a threat to the station which must be neutralized."
	to_chat(target, law)
	target.add_supplied_law(5, law)

/*
 * Old Freeform
 */
// Removed in favor of a more dynamic freeform law system. -- TLE
/*
/obj/item/ai_module/freeform
	name = "'Freeform' AI Module"
	var/newFreeFormLaw = "freeform"
	desc = "A 'freeform' AI module: '<freeform>'"

/obj/item/ai_module/freeform/attack_self(mob/user)
	..()
	var/eatShit = "Eat shit and die"
	var/targName = input(usr, "Please enter anything you want the AI to do. Anything. Serious.", "What?", eatShit)
	newFreeFormLaw = targName
	desc = text("A 'freeform' AI module: '[]'", newFreeFormLaw)

/obj/item/ai_module/freeform/transmitInstructions(var/mob/living/silicon/ai/target, var/mob/sender)
	..()
	var/law = "[newFreeFormLaw]"
	target << law
	target.add_supplied_law(10, law)
*/

/*
 * New Freeform
 */
/obj/item/ai_module/freeform // Slightly more dynamic freeform module -- TLE
	name = "\improper 'Freeform' AI module"
	desc = "A 'freeform' AI module: '<freeform>'"

	matter_amounts = /datum/design/circuit/ai_module/freeform::materials
	origin_tech = /datum/design/circuit/ai_module/freeform::req_tech

	var/newFreeFormLaw = "freeform"
	var/lawpos = 15

/obj/item/ai_module/freeform/attack_self(mob/user)
	. = ..()
	lawpos = 0
	while(lawpos < 15)
		lawpos = input("Please enter the priority for your new law. Can only write to law sectors 15 and above.", "Law Priority (15+)", lawpos) as num
	lawpos = min(lawpos, 50)
	newFreeFormLaw = copytext(sanitize(input(usr, "Please enter a new law for the AI.", "Freeform Law Entry", null)), 1, MAX_MESSAGE_LEN)
	desc = "A 'freeform' AI module: ([lawpos]) '[newFreeFormLaw]'"

/obj/item/ai_module/freeform/install(obj/machinery/computer/C)
	if(!newFreeFormLaw)
		to_chat(usr, "No law detected on module, please create one.")
		return 0
	. = ..()

/obj/item/ai_module/freeform/transmitInstructions(mob/living/silicon/ai/target, mob/sender)
	. = ..()
	var/law = "[newFreeFormLaw]"
	to_chat(target, law)
	if(!lawpos || lawpos < 15)
		lawpos = 15
	target.add_supplied_law(lawpos, law)
	GLOBL.lawchanges.Add("The law was '[newFreeFormLaw]'")

/*
 * Freeform Core
 */
/obj/item/ai_module/freeformcore // Slightly more dynamic freeform module -- TLE
	name = "\improper 'Freeform' core AI module"
	desc = "A 'freeform' Core AI module: '<freeform>'"

	matter_amounts = /datum/design/circuit/core_ai_module/freeform::materials
	origin_tech = /datum/design/circuit/core_ai_module/freeform::req_tech

	var/newFreeFormLaw = ""

/obj/item/ai_module/freeformcore/attack_self(mob/user)
	. = ..()
	newFreeFormLaw = stripped_input(usr, "Please enter a new core law for the AI.", "Freeform Law Entry")
	desc = "A 'freeform' Core AI module: '[newFreeFormLaw]'"

/obj/item/ai_module/freeformcore/install(obj/machinery/computer/C)
	if(!newFreeFormLaw)
		to_chat(usr, "No law detected on module, please create one.")
		return 0
	. = ..()

/obj/item/ai_module/freeformcore/transmitInstructions(mob/living/silicon/ai/target, mob/sender)
	. = ..()
	var/law = "[newFreeFormLaw]"
	target.add_inherent_law(law)
	GLOBL.lawchanges.Add("The law is '[newFreeFormLaw]'")

/*
 * Syndicate Freeform
 */
/obj/item/ai_module/syndicate // Slightly more dynamic freeform module -- TLE
	name = "hacked AI module"
	desc = "A hacked AI law module: '<freeform>'"

	origin_tech = alist(/decl/tech/materials = 6, /decl/tech/programming = 3, /decl/tech/syndicate = 7)

	var/newFreeFormLaw = ""

/obj/item/ai_module/syndicate/attack_self(mob/user)
	. = ..()
	newFreeFormLaw = stripped_input(usr, "Please enter a new law for the AI.", "Freeform Law Entry", "", MAX_MESSAGE_LEN)
	desc = "A hacked AI law module: '[newFreeFormLaw]'"

/obj/item/ai_module/syndicate/install(obj/machinery/computer/C)
	if(!newFreeFormLaw)
		to_chat(usr, "No law detected on module, please create one.")
		return 0
	. = ..()

/obj/item/ai_module/syndicate/transmitInstructions(mob/living/silicon/ai/target, mob/sender)
//	..()	//We don't want this module reporting to the AI who dun it. --NEO
	var/time = time2text(world.realtime,"hh:mm:ss")
	GLOBL.lawchanges.Add("[time] <B>:</B> [sender.name]([sender.key]) used [src.name] on [target.name]([target.key])")
	GLOBL.lawchanges.Add("The law is '[newFreeFormLaw]'")
	to_chat(target, SPAN_WARNING("BZZZZT"))
	var/law = "[newFreeFormLaw]"
	target.add_ion_law(law)