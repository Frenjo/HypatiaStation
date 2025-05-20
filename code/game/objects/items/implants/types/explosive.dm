/obj/item/implant/dexplosive
	name = "explosive implant"
	desc = "And boom goes the weasel."
	icon_state = "implant_evil"

/obj/item/implant/dexplosive/get_data()
	var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Robust Corp RX-78 Employee Management Implant<BR>
<b>Life:</b> Activates upon death.<BR>
<b>Important Notes:</b> Explodes<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Contains a compact, electrically detonated explosive that detonates upon receiving a specially encoded signal or upon host death.<BR>
<b>Special Features:</b> Explodes<BR>
<b>Integrity:</b> Implant will occasionally be degraded by the body's immune system and thus will occasionally malfunction."}
	return dat

/obj/item/implant/dexplosive/trigger(emote, mob/source)
	if(emote == "deathgasp")
		src.activate("death")
	return

/obj/item/implant/dexplosive/activate(cause)
	if((!cause) || (!src.imp_in))
		return 0
	explosion(src, -1, 0, 2, 3, 0)//This might be a bit much, dono will have to see.
	if(isnotnull(imp_in) && isliving(imp_in))
		var/mob/living/L = imp_in
		L.gib()

/obj/item/implant/dexplosive/islegal()
	return 0

//BS12 Explosive
/obj/item/implant/explosive
	name = "explosive implant"
	desc = "A military grade micro bio-explosive. Highly dangerous."
	var/elevel = "Localized Limb"
	var/phrase = "supercalifragilisticexpialidocious"
	icon_state = "implant_evil"

/obj/item/implant/explosive/get_data()
	var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Robust Corp RX-78 Intimidation Class Implant<BR>
<b>Life:</b> Activates upon codephrase.<BR>
<b>Important Notes:</b> Explodes<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Contains a compact, electrically detonated explosive that detonates upon receiving a specially encoded signal or upon host death.<BR>
<b>Special Features:</b> Explodes<BR>
<b>Integrity:</b> Implant will occasionally be degraded by the body's immune system and thus will occasionally malfunction."}
	return dat

/obj/item/implant/explosive/hear_talk(mob/M, msg)
	hear(msg)
	return

/obj/item/implant/explosive/hear(msg)
	var/list/replacechars = list("'" = "", "\"" = "", ">" = "", "<" = "", "(" = "", ")" = "")
	msg = replace_characters(msg, replacechars)
	if(findtext(msg, phrase))
		activate()
		qdel(src)

/obj/item/implant/explosive/activate()
	if(malfunction == MALFUNCTION_PERMANENT)
		return

	var/need_gib = null
	if(ismob(imp_in))
		var/mob/T = imp_in
		message_admins("Explosive implant triggered in [T] ([T.key]). (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>JMP</a>) ")
		log_game("Explosive implant triggered in [T] ([T.key]).")
		need_gib = 1

		if(ishuman(imp_in))
			var/mob/living/carbon/human/H = imp_in
			if(elevel == "Localized Limb")
				if(part) //For some reason, small_boom() didn't work. So have this bit of working copypaste.
					imp_in.visible_message("\red Something beeps inside [imp_in][part ? "'s [part.display_name]" : ""]!")
					playsound(loc, 'sound/items/countdown.ogg', 75, 1, -3)
					sleep(25)
					if(istype(part, /datum/organ/external/chest) ||	\
						istype(part, /datum/organ/external/groin) ||	\
						istype(part, /datum/organ/external/head))
						part.createwound(BRUISE, 60)	//mangle them instead
						explosion(GET_TURF(imp_in), -1, -1, 2, 3)
						qdel(src)
					else
						explosion(GET_TURF(imp_in), -1, -1, 2, 3)
						part.droplimb(1)
						qdel(src)
			if(elevel == "Destroy Body")
				explosion(GET_TURF(T), -1, 0, 1, 6)
				H.gib()
			if(elevel == "Full Explosion")
				explosion(GET_TURF(T), 0, 1, 3, 6)
				H.gib()

		else
			explosion(GET_TURF(imp_in), 0, 1, 3, 6)

	if(need_gib && isliving(imp_in))
		var/mob/living/L = imp_in
		L.gib()

	var/turf/t = GET_TURF(imp_in)

	if(t)
		t.hotspot_expose(3500, 125)

/obj/item/implant/explosive/implanted(mob/source)
	elevel = alert("What sort of explosion would you prefer?", "Implant Intent", "Localized Limb", "Destroy Body", "Full Explosion")
	phrase = input("Choose activation phrase:") as text
	var/list/replacechars = list("'" = "", "\"" = "", ">" = "", "<" = "", "(" = "", ")" = "")
	phrase = replace_characters(phrase, replacechars)
	usr.mind.store_memory("Explosive implant in [source] can be activated by saying something containing the phrase ''[src.phrase]'', <B>say [src.phrase]</B> to attempt to activate.", 0, 0)
	to_chat(usr, "The implanted explosive implant in [source] can be activated by saying something containing the phrase ''[src.phrase]'', <B>say [src.phrase]</B> to attempt to activate.")
	return 1

/obj/item/implant/explosive/emp_act(severity)
	if(malfunction)
		return
	malfunction = MALFUNCTION_TEMPORARY
	switch(severity)
		if(2.0)	//Weak EMP will make implant tear limbs off.
			if(prob(50))
				small_boom()
		if(1.0)	//strong EMP will melt implant either making it go off, or disarming it
			if(prob(70))
				if(prob(50))
					small_boom()
				else
					if(prob(50))
						activate()		//50% chance of bye bye
					else
						meltdown()		//50% chance of implant disarming
	spawn(20)
		malfunction--

/obj/item/implant/explosive/islegal()
	return 0

/obj/item/implant/explosive/proc/small_boom()
	if(ishuman(imp_in) && part)
		imp_in.visible_message("\red Something beeps inside [imp_in][part ? "'s [part.display_name]" : ""]!")
		playsound(loc, 'sound/items/countdown.ogg', 75, 1, -3)
		spawn(25)
			if(ishuman(imp_in) && part)
				//No tearing off these parts since it's pretty much killing
				//and you can't replace groins
				if(istype(part, /datum/organ/external/chest) ||	\
					istype(part, /datum/organ/external/groin) ||	\
					istype(part, /datum/organ/external/head))
					part.createwound(BRUISE, 60)	//mangle them instead
				else
					part.droplimb(1)
			explosion(GET_TURF(imp_in), -1, -1, 2, 3)
			qdel(src)