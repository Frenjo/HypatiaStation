//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/implant/freedom
	name = "freedom implant"
	desc = "Use this to escape from those evil Red Shirts."
	matter_amounts = /datum/design/implant/free::materials
	origin_tech = /datum/design/implant/free::req_tech
	item_color = "r"
	var/activation_emote = "chuckle"
	var/uses = 1.0

/obj/item/implant/freedom/New()
	src.activation_emote = pick("blink", "blink_r", "eyebrow", "chuckle", "twitch_s", "frown", "nod", "blush", "giggle", "grin", "groan", "shrug", "smile", "pale", "sniff", "whimper", "wink")
	src.uses = rand(1, 5)
	..()
	return

/obj/item/implant/freedom/trigger(emote, mob/living/carbon/source)
	if(src.uses < 1)
		return 0
	if(emote == src.activation_emote)
		src.uses--
		to_chat(source, "You feel a faint click.")
		if(source.handcuffed)
			var/obj/item/W = source.handcuffed
			source.handcuffed = null
			source.update_inv_handcuffed()
			if(source.client)
				source.client.screen -= W
			if(W)
				W.forceMove(source.loc)
				dropped(source)
				if(W)
					W.reset_plane_and_layer()
		if(source.legcuffed)
			var/obj/item/W = source.legcuffed
			source.legcuffed = null
			source.update_inv_legcuffed()
			if(source.client)
				source.client.screen -= W
			if(W)
				W.forceMove(source.loc)
				dropped(source)
				if(W)
					W.reset_plane_and_layer()
	return

/obj/item/implant/freedom/implanted(mob/living/carbon/source)
	source.mind.store_memory("Freedom implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate.", 0, 0)
	to_chat(source, "The implanted freedom implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate.")
	return 1

/obj/item/implant/freedom/get_data()
	var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Freedom Beacon<BR>
<b>Life:</b> optimum 5 uses<BR>
<b>Important Notes:</b> <font color='red'>Illegal</font><BR>
<HR>
<b>Implant Details:</b> <BR>
<b>Function:</b> Transmits a specialized cluster of signals to override handcuff locking
mechanisms<BR>
<b>Special Features:</b><BR>
<i>Neuro-Scan</i>- Analyses certain shadow signals in the nervous system<BR>
<b>Integrity:</b> The battery is extremely weak and commonly after injection its
life can drive down to only 1 use.<HR>
No Implant Specifics"}
	return dat

// Case
/obj/item/implantcase/freedom
	name = "glass case - 'freedom'"
	desc = "A case containing a freedom implant."
	icon = 'icons/obj/items.dmi'
	icon_state = "implantcase-r"

	imp_type = /obj/item/implant/freedom