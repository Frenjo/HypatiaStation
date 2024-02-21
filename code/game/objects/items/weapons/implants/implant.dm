#define MALFUNCTION_TEMPORARY 1
#define MALFUNCTION_PERMANENT 2

/obj/item/implant
	name = "implant"
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "implant"

	var/implanted = null
	var/mob/imp_in = null
	var/datum/organ/external/part = null
	item_color = "b"
	var/allow_reagents = 0
	var/malfunction = 0

/obj/item/implant/proc/trigger(emote, source as mob)
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

/obj/item/implant/proc/hear(message, source as mob)
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
	if(part)
		part.implants.Remove(src)
	return ..()


/obj/item/implant/tracking
	name = "tracking implant"
	desc = "Track with this."
	var/id = 1.0

/obj/item/implant/tracking/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
<b>Name:</b> Tracking Beacon<BR>
<b>Life:</b> 10 minutes after death of host<BR>
<b>Important Notes:</b> None<BR>
<HR>
<b>Implant Details:</b> <BR>
<b>Function:</b> Continuously transmits low power signal. Useful for tracking.<BR>
<b>Special Features:</b><BR>
<i>Neuro-Safe</i>- Specialized shell absorbs excess voltages self-destructing the chip if
a malfunction occurs thereby securing safety of subject. The implant will melt and
disintegrate into bio-safe elements.<BR>
<b>Integrity:</b> Gradient creates slight risk of being overcharged and frying the
circuitry. As a result neurotoxins can cause massive damage.<HR>
Implant Specifics:<BR>"}
	return dat

/obj/item/implant/tracking/emp_act(severity)
	if(malfunction)	//no, dawg, you can't malfunction while you are malfunctioning
		return
	malfunction = MALFUNCTION_TEMPORARY

	var/delay = 20
	switch(severity)
		if(1)
			if(prob(60))
				meltdown()
		if(2)
			delay = rand(5 * 60 * 10, 15 * 60 * 10)	//from 5 to 15 minutes of free time

	spawn(delay)
		malfunction--


/obj/item/implant/dexplosive
	name = "explosive"
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


/obj/item/implant/dexplosive/trigger(emote, source as mob)
	if(emote == "deathgasp")
		src.activate("death")
	return


/obj/item/implant/dexplosive/activate(cause)
	if((!cause) || (!src.imp_in))
		return 0
	explosion(src, -1, 0, 2, 3, 0)//This might be a bit much, dono will have to see.
	if(src.imp_in)
		src.imp_in.gib()

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

/obj/item/implant/explosive/hear_talk(mob/M as mob, msg)
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
		message_admins("Explosive implant triggered in [T] ([T.key]). (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>JMP</a>) ")
		log_game("Explosive implant triggered in [T] ([T.key]).")
		need_gib = 1

		if(ishuman(imp_in))
			if(elevel == "Localized Limb")
				if(part) //For some reason, small_boom() didn't work. So have this bit of working copypaste.
					imp_in.visible_message("\red Something beeps inside [imp_in][part ? "'s [part.display_name]" : ""]!")
					playsound(loc, 'sound/items/countdown.ogg', 75, 1, -3)
					sleep(25)
					if(istype(part, /datum/organ/external/chest) ||	\
						istype(part, /datum/organ/external/groin) ||	\
						istype(part, /datum/organ/external/head))
						part.createwound(BRUISE, 60)	//mangle them instead
						explosion(get_turf(imp_in), -1, -1, 2, 3)
						qdel(src)
					else
						explosion(get_turf(imp_in), -1, -1, 2, 3)
						part.droplimb(1)
						qdel(src)
			if(elevel == "Destroy Body")
				explosion(get_turf(T), -1, 0, 1, 6)
				T.gib()
			if(elevel == "Full Explosion")
				explosion(get_turf(T), 0, 1, 3, 6)
				T.gib()

		else
			explosion(get_turf(imp_in), 0, 1, 3, 6)

	if(need_gib)
		imp_in.gib()

	var/turf/t = get_turf(imp_in)

	if(t)
		t.hotspot_expose(3500, 125)

/obj/item/implant/explosive/implanted(mob/source as mob)
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
			explosion(get_turf(imp_in), -1, -1, 2, 3)
			qdel(src)


/obj/item/implant/chem
	name = "chemical implant"
	desc = "Injects things."
	allow_reagents = 1

/obj/item/implant/chem/get_data()
	var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Robust Corp MJ-420 Prisoner Management Implant<BR>
<b>Life:</b> Deactivates upon death but remains within the body.<BR>
<b>Important Notes: Due to the system functioning off of nutrients in the implanted subject's body, the subject<BR>
will suffer from an increased appetite.</B><BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Contains a small capsule that can contain various chemicals. Upon receiving a specially encoded signal<BR>
the implant releases the chemicals directly into the blood stream.<BR>
<b>Special Features:</b>
<i>Micro-Capsule</i>- Can be loaded with any sort of chemical agent via the common syringe and can hold 50 units.<BR>
Can only be loaded while still in its original case.<BR>
<b>Integrity:</b> Implant will last so long as the subject is alive. However, if the subject suffers from malnutrition,<BR>
the implant may become unstable and either pre-maturely inject the subject or simply break."}
	return dat

/obj/item/implant/chem/New()
	..()
	var/datum/reagents/R = new/datum/reagents(50)
	reagents = R
	R.my_atom = src

/obj/item/implant/chem/trigger(emote, source as mob)
	if(emote == "deathgasp")
		src.activate(src.reagents.total_volume)
	return

/obj/item/implant/chem/activate(cause)
	if(!cause || !src.imp_in)
		return 0
	var/mob/living/carbon/R = src.imp_in
	src.reagents.trans_to(R, cause)
	to_chat(R, "You hear a faint *beep*.")
	if(!src.reagents.total_volume)
		to_chat(R, "You hear a faint click from your chest.")
		spawn(0)
			qdel(src)
	return

/obj/item/implant/chem/emp_act(severity)
	if(malfunction)
		return
	malfunction = MALFUNCTION_TEMPORARY

	switch(severity)
		if(1)
			if(prob(60))
				activate(20)
		if(2)
			if(prob(30))
				activate(5)

	spawn(20)
		malfunction--

/obj/item/implant/loyalty
	name = "loyalty implant"
	desc = "Makes you loyal or such."

/obj/item/implant/loyalty/get_data()
	var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> NanoTrasen Employee Management Implant<BR>
<b>Life:</b> Ten years.<BR>
<b>Important Notes:</b> Personnel injected with this device tend to be much more loyal to the company.<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Contains a small pod of nanobots that manipulate the host's mental functions.<BR>
<b>Special Features:</b> Will prevent and cure most forms of brainwashing.<BR>
<b>Integrity:</b> Implant will last so long as the nanobots are inside the bloodstream."}
	return dat

/obj/item/implant/loyalty/implanted(mob/M)
	if(!ishuman(M))
		return 0
	var/mob/living/carbon/human/H = M
	if(H.mind in global.PCticker.mode.head_revolutionaries)
		H.visible_message("[H] seems to resist the implant!", "You feel the corporate tendrils of NanoTrasen try to invade your mind!")
		return 0
	else if(H.mind in global.PCticker.mode:revolutionaries)
		global.PCticker.mode:remove_revolutionary(H.mind)
	to_chat(H, SPAN_INFO("You feel a surge of loyalty towards NanoTrasen."))
	return 1


/obj/item/implant/adrenalin
	name = "adrenalin"
	desc = "Removes all stuns and knockdowns."
	var/uses

/obj/item/implant/adrenalin/get_data()
	var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Cybersun Industries Adrenalin Implant<BR>
<b>Life:</b> Five days.<BR>
<b>Important Notes:</b> <font color='red'>Illegal</font><BR>
<HR>
<b>Implant Details:</b> Subjects injected with implant can activate a massive injection of adrenalin.<BR>
<b>Function:</b> Contains nanobots to stimulate body to mass-produce Adrenalin.<BR>
<b>Special Features:</b> Will prevent and cure most forms of brainwashing.<BR>
<b>Integrity:</b> Implant can only be used three times before the nanobots are depleted."}
	return dat

/obj/item/implant/adrenalin/trigger(emote, mob/source as mob)
	if(src.uses < 1)
		return 0
	if(emote == "pale")
		src.uses--
		to_chat(source, SPAN_INFO("You feel a sudden surge of energy!"))
		source.SetStunned(0)
		source.SetWeakened(0)
		source.SetParalysis(0)
	return

/obj/item/implant/adrenalin/implanted(mob/source)
	source.mind.store_memory("A implant can be activated by using the pale emote, <B>say *pale</B> to attempt to activate.", 0, 0)
	to_chat(source, "The implanted freedom implant can be activated by using the pale emote, <B>say *pale</B> to attempt to activate.")
	return 1


/obj/item/implant/death_alarm
	name = "death alarm implant"
	desc = "An alarm which monitors host vital signs and transmits a radio message upon death."
	var/mobname = "Will Robinson"

/obj/item/implant/death_alarm/get_data()
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

/obj/item/implant/death_alarm/process()
	if(!implanted)
		return
	var/mob/M = imp_in

	if(isnull(M)) // If the mob got gibbed
		activate()
	else if(M.stat == DEAD)
		activate("death")

/obj/item/implant/death_alarm/activate(cause)
	var/mob/M = imp_in
	var/area/t = get_area(M)
	switch(cause)
		if("death")
			var/obj/item/radio/headset/a = new /obj/item/radio/headset(null)
			if(istype(t, /area/syndicate_station) || istype(t, /area/syndicate_mothership) || istype(t, /area/shuttle/syndicate_elite))
				//give the syndies a bit of stealth
				a.autosay("[mobname] has died in Space!", "[mobname]'s Death Alarm")
			else
				a.autosay("[mobname] has died in [t.name]!", "[mobname]'s Death Alarm")
			qdel(a)
			GLOBL.processing_objects.Remove(src)
		if("emp")
			var/obj/item/radio/headset/a = new /obj/item/radio/headset(null)
			var/name = prob(50) ? t.name : pick(GLOBL.teleportlocs)
			a.autosay("[mobname] has died in [name]!", "[mobname]'s Death Alarm")
			qdel(a)
		else
			var/obj/item/radio/headset/a = new /obj/item/radio/headset(null)
			a.autosay("[mobname] has died-zzzzt in-in-in...", "[mobname]'s Death Alarm")
			qdel(a)
			GLOBL.processing_objects.Remove(src)

/obj/item/implant/death_alarm/emp_act(severity)			//for some reason alarms stop going off in case they are emp'd, even without this
	if(malfunction)		//so I'm just going to add a meltdown chance here
		return
	malfunction = MALFUNCTION_TEMPORARY

	activate("emp")	//let's shout that this dude is dead
	if(severity == 1)
		if(prob(40))	//small chance of obvious meltdown
			meltdown()
		else if(prob(60))	//but more likely it will just quietly die
			malfunction = MALFUNCTION_PERMANENT
		GLOBL.processing_objects.Remove(src)

	spawn(20)
		malfunction--

/obj/item/implant/death_alarm/implanted(mob/source as mob)
	mobname = source.real_name
	GLOBL.processing_objects.Add(src)
	return 1


/obj/item/implant/compressed
	name = "compressed matter implant"
	desc = "Based on compressed matter technology, can store a single item."
	icon_state = "implant_evil"
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

/obj/item/implant/compressed/trigger(emote, mob/source as mob)
	if(src.scanned == null)
		return 0

	if(emote == src.activation_emote)
		to_chat(source, "The air glows as \the [src.scanned.name] uncompresses.")
		activate()

/obj/item/implant/compressed/activate()
	var/turf/t = get_turf(src)
	if(imp_in)
		imp_in.put_in_hands(scanned)
	else
		scanned.loc = t
	qdel(src)

/obj/item/implant/compressed/implanted(mob/source as mob)
	src.activation_emote = input("Choose activation emote:") in list("blink", "blink_r", "eyebrow", "chuckle", "twitch_s", "frown", "nod", "blush", "giggle", "grin", "groan", "shrug", "smile", "pale", "sniff", "whimper", "wink")
	if(source.mind)
		source.mind.store_memory("Compressed matter implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate.", 0, 0)
	to_chat(source, "The implanted compressed matter implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate.")
	return 1

/obj/item/implant/compressed/islegal()
	return 0


/obj/item/implant/cortical
	name = "cortical stack"
	desc = "A fist-sized mass of biocircuits and chips."
	icon_state = "implant_evil"

#undef MALFUNCTION_TEMPORARY
#undef MALFUNCTION_PERMANENT