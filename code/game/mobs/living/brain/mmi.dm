//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/mmi
	name = "man-machine interface"
	desc = "The Warrior's bland acronym, MMI, obscures the true horror of this monstrosity."
	icon = 'icons/obj/items/assemblies/assemblies.dmi'
	icon_state = "mmi_empty"

	matter_amounts = /datum/design/medical/mmi::materials
	origin_tech = /datum/design/medical/mmi::req_tech

	req_access = list(ACCESS_ROBOTICS)

	//Revised. Brainmob is now contained directly within object of transfer. MMI in this case.

	var/locked = FALSE
	var/mob/living/brain/brainmob = null // The current occupant.

/obj/item/mmi/Destroy()
	if(isrobot(loc))
		var/mob/living/silicon/robot/borg = loc
		borg.mmi = null
	if(isnotnull(brainmob))
		QDEL_NULL(brainmob)
	return ..()

/obj/item/mmi/attack_by(obj/item/I, mob/user)
	if(isnull(brainmob) && istype(I, /obj/item/brain)) //Time to stick a brain in it --NEO
		var/obj/item/brain/brain = I
		if(isnull(brain.brainmob))
			to_chat(user, SPAN_WARNING("You aren't sure where this brain came from, but you're pretty sure it's useless."))
			return TRUE

		user.visible_message(
			SPAN_INFO("[user] sticks \a [brain] into \the [src]."),
			SPAN_INFO("You stick \the [brain] into \the [src].")
		)

		brainmob = brain.brainmob
		brain.brainmob = null
		brainmob.forceMove(src)
		brainmob.container = src
		brainmob.stat = 0
		GLOBL.dead_mob_list.Remove(brainmob)//Update dem lists
		GLOBL.living_mob_list.Add(brainmob)

		user.drop_item()
		qdel(brain)

		name = "man-machine interface: [brainmob.real_name]"
		icon_state = "mmi_full"

		locked = TRUE

		feedback_inc("cyborg_mmis_filled", 1)
		return TRUE

	if(isnotnull(brainmob) && (istype(I, /obj/item/card/id) || istype(I, /obj/item/pda)))
		if(allowed(user))
			locked = !locked
			to_chat(user, SPAN_NOTICE("You [locked ? "lock" : "unlock"] the brain holder."))
		else
			FEEDBACK_ACCESS_DENIED(user)
		return TRUE

	if(isnotnull(brainmob))
		I.attack(brainmob, user) //Oh noooeeeee
		return TRUE

	return ..()

/obj/item/mmi/attack_self(mob/user)
	if(isnull(brainmob))
		to_chat(user, SPAN_WARNING("You upend the MMI, but there's nothing in it."))
		return

	if(locked)
		to_chat(user, SPAN_WARNING("You upend the MMI, but the brain is clamped into place."))
		return

	to_chat(user, SPAN_INFO("You upend the MMI, spilling the brain onto the floor."))
	var/obj/item/brain/brain = new /obj/item/brain(user.loc)
	brainmob.container = null // Reset brainmob mmi var.
	brainmob.forceMove(brain) // Throw mob into brain.
	GLOBL.living_mob_list.Remove(brainmob) // Get outta here
	brain.brainmob = brainmob // Set the brain to use the brainmob
	brainmob = null // Set mmi brainmob var to null

	icon_state = "mmi_empty"
	name = initial(name)

/obj/item/mmi/emp_act(severity)
	if(isnull(brainmob))
		return

	switch(severity)
		if(1)
			brainmob.emp_damage += rand(20, 30)
		if(2)
			brainmob.emp_damage += rand(10, 20)
		if(3)
			brainmob.emp_damage += rand(0, 10)
	..()

/obj/item/mmi/proc/transfer_identity(mob/living/carbon/human/H)//Same deal as the regular brain proc. Used for human-->robot people.
	brainmob = new /mob/living/brain(src)
	brainmob.name = H.real_name
	brainmob.real_name = H.real_name
	brainmob.dna = H.dna
	brainmob.container = src

	name = "man-machine interface: [brainmob.real_name]"
	icon_state = "mmi_full"
	locked = TRUE

/obj/item/mmi/radio_enabled
	name = "radio-enabled man-machine interface"
	desc = "The Warrior's bland acronym, MMI, obscures the true horror of this monstrosity. This one comes with a built-in radio."

	matter_amounts = /datum/design/medical/mmi_radio::materials
	origin_tech = /datum/design/medical/mmi_radio::req_tech

	var/obj/item/radio/radio = null // Let's give it a radio.

/obj/item/mmi/radio_enabled/New()
	. = ..()
	radio = new /obj/item/radio(src) // Spawns a radio inside the MMI.
	radio.broadcasting = TRUE // So it's broadcasting from the start.

// Allows the brain to toggle the radio functions.
/obj/item/mmi/radio_enabled/verb/toggle_broadcasting()
	set category = "MMI"
	set name = "Toggle Broadcasting"
	set desc = "Toggle broadcasting channel on or off."
	set popup_menu = FALSE
	set src = usr.loc // In user location, or in MMI in this case.

	if(brainmob.stat )// Only the brainmob will trigger these so no further check is necessary.
		to_chat(brainmob, SPAN_WARNING("You can't do that while incapacitated or dead."))

	radio.broadcasting = !radio.broadcasting
	to_chat(brainmob, SPAN_INFO("Radio is [radio.broadcasting ? "now" : "no longer"] broadcasting."))

/obj/item/mmi/radio_enabled/verb/toggle_listening()
	set category = "MMI"
	set name = "Toggle Listening"
	set desc = "Toggle listening channel on or off."
	set popup_menu = FALSE
	set src = usr.loc

	if(brainmob.stat)
		to_chat(brainmob, SPAN_WARNING("You can't do that while incapacitated or dead."))

	radio.listening = !radio.listening
	to_chat(brainmob, SPAN_INFO("Radio is [radio.listening ? "now" : "no longer"] receiving."))