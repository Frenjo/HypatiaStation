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
	var/area/t = GET_AREA(M)
	switch(cause)
		if("death")
			var/obj/item/radio/headset/a = new /obj/item/radio/headset(null)
			if(istype(t, /area/shuttle/syndicate) || istype(t, /area/enemy/syndicate/mothership))
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

/obj/item/implant/death_alarm/implanted(mob/source)
	mobname = source.real_name
	GLOBL.processing_objects.Add(src)
	return 1

// Case
/obj/item/implantcase/death_alarm
	name = "glass case - 'death alarm'"
	desc = "A case containing a death alarm implant."
	icon = 'icons/obj/items.dmi'
	icon_state = "implantcase-b"

	imp_type = /obj/item/implant/death_alarm