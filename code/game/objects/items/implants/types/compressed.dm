/obj/item/implant/compressed
	name = "compressed matter implant"
	desc = "Based on compressed matter technology, can store a single item."
	icon_state = "implant_evil"

	is_legal = FALSE

	var/activation_emote = "sigh"
	var/obj/item/scanned = null

/obj/item/implant/compressed/get_data()
	var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> NanoTrasen \"Profit Margin\" Class Employee Lifesign Sensor<BR>
<b>Life:</b> Activates upon death.<BR>
<b>Important Notes:</b> Alerts crew to crewmember death.<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Contains a compact radio signaler that triggers when the host's lifesigns cease.<BR>
<b>Special Features:</b> Alerts crew to crewmember death.<BR>
<b>Integrity:</b> Implant will occasionally be degraded by the body's immune system and thus will occasionally malfunction."}
	return dat

/obj/item/implant/compressed/trigger(emote, mob/source)
	if(src.scanned == null)
		return 0

	if(emote == src.activation_emote)
		to_chat(source, "The air glows as \the [src.scanned.name] uncompresses.")
		activate()

/obj/item/implant/compressed/activate()
	var/turf/t = GET_TURF(src)
	if(imp_in)
		imp_in.put_in_hands(scanned)
	else
		scanned.forceMove(t)
	qdel(src)

/obj/item/implant/compressed/implanted(mob/source)
	src.activation_emote = input("Choose activation emote:") in list("blink", "blink_r", "eyebrow", "chuckle", "twitch_s", "frown", "nod", "blush", "giggle", "grin", "groan", "shrug", "smile", "pale", "sniff", "whimper", "wink")
	if(source.mind)
		source.mind.store_memory("Compressed matter implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate.", 0, 0)
	to_chat(source, "The implanted compressed matter implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate.")
	return 1

// Implanter
/obj/item/implanter/compressed
	name = "implanter (C)"
	icon_state = "cimplanter1"

	imp_type = /obj/item/implant/compressed

/obj/item/implanter/compressed/update()
	if(isnotnull(imp))
		var/obj/item/implant/compressed/c = imp
		if(isnull(c.scanned))
			icon_state = "cimplanter1"
		else
			icon_state = "cimplanter2"
	else
		icon_state = "cimplanter0"

/obj/item/implanter/compressed/attack(mob/M, mob/user)
	var/obj/item/implant/compressed/c = imp
	if(isnull(c))
		return
	if(isnull(c.scanned))
		to_chat(user, "Please scan an object with the implanter first.")
		return
	return ..()

/obj/item/implanter/compressed/afterattack(atom/A, mob/user)
	if(isitem(A) && isnotnull(imp))
		var/obj/item/implant/compressed/c = imp
		if(isnotnull(c.scanned))
			to_chat(user, SPAN_WARNING("Something is already scanned inside the implant!"))
			return
		c.scanned = A
		if(ishuman(A.loc))
			var/mob/living/carbon/human/H = A.loc
			H.u_equip(A)
		else if(istype(A.loc, /obj/item/storage))
			var/obj/item/storage/S = A.loc
			S.remove_from_storage(A)
		A.loc.contents.Remove(A)
		update()