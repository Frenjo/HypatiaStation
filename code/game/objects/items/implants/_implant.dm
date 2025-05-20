#define MALFUNCTION_TEMPORARY 1
#define MALFUNCTION_PERMANENT 2

/obj/item/implant
	name = "implant"
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "implant"

	item_color = "b"

	var/implanted = null
	var/mob/imp_in = null
	var/datum/organ/external/part = null

	var/allow_reagents = 0
	var/malfunction = 0

/obj/item/implant/proc/trigger(emote, mob/source)
	return

/obj/item/implant/proc/activate()
	return

// What does the implant do upon injection?
// return 0 if the implant fails (ex. Revhead and loyalty implant.)
// return 1 if the implant succeeds (ex. Nonrevhead and loyalty implant.)
/obj/item/implant/proc/implanted(mob/source)
	return 1

/obj/item/implant/proc/get_data()
	return "No information available"

/obj/item/implant/proc/hear(message, mob/source)
	return

/obj/item/implant/proc/islegal()
	return 0

/obj/item/implant/proc/meltdown()	//breaks it down, making implant unrecongizible
	to_chat(imp_in, SPAN_WARNING("You feel something melting inside [part ? "your [part.display_name]" : "you"]!"))
	if(part)
		part.take_damage(burn = 15, used_weapon = "Electronics meltdown")
	else
		var/mob/living/M = imp_in
		M.apply_damage(15, BURN)
	name = "melted implant"
	desc = "Charred circuit in melted plastic case. Wonder what that used to be..."
	icon_state = "implant_melted"
	malfunction = MALFUNCTION_PERMANENT

/obj/item/implant/Destroy()
	part?.implants.Remove(src)
	return ..()