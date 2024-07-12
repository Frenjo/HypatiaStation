//Cloning revival method.
//The pod handles the actual cloning while the computer manages the clone profiles

//Potential replacement for genetics revives or something I dunno (?)

#define CLONE_BIOMASS 1

/obj/machinery/clonepod
	anchored = TRUE
	name = "cloning pod"
	desc = "An electronically-lockable pod for growing organic tissue."
	density = TRUE
	icon = 'icons/obj/cloning.dmi'
	icon_state = "pod_0"
	req_access = list(ACCESS_GENETICS) //For premature unlocking.
	var/mob/living/occupant
	var/heal_level = 90 //The clone is released once its health reaches this level.
	var/locked = 0
	var/obj/machinery/computer/cloning/connected = null //So we remember the connected clone machine.
	var/mess = 0 //Need to clean out it if it's full of exploded clone.
	var/attempting = 0 //One clone attempt at a time thanks
	var/eject_wait = 0 //Don't eject them as soon as they are created fuckkk
	var/biomass = CLONE_BIOMASS * 3

/obj/item/cloning_charge
	name = "Short-Term Biological Suspension Unit (SBSU)"
	//desc = "PLACEHOLDER"
	icon = 'icons/obj/storage/storage.dmi'
	icon_state = "stem-charge"

	var/charges = 1

//Find a dead mob with a brain and client.
/proc/find_dead_player(find_key)
	if(isnull(find_key))
		return

	var/mob/selected = null
	for_no_type_check(var/mob/M, GLOBL.player_list)
		//Dead people only thanks!
		if((M.stat != DEAD) || (!M.client))
			continue
		//They need a brain!
		if(ishuman("M"))
			var/mob/living/carbon/human/H = M
			if(H.species.has_organ["brain"] && !H.has_brain())
				continue

		if(M.ckey == find_key)
			selected = M
			break
	return selected

//Health Tracker Implant

/obj/item/implant/health
	name = "health implant"
	var/healthstring = ""

/obj/item/implant/health/proc/sensehealth()
	if(!src.implanted)
		return "ERROR"
	else
		if(isliving(src.implanted))
			var/mob/living/L = src.implanted
			src.healthstring = "[round(L.getOxyLoss())] - [round(L.getFireLoss())] - [round(L.getToxLoss())] - [round(L.getBruteLoss())]"
		if(!src.healthstring)
			src.healthstring = "ERROR"
		return src.healthstring

/obj/machinery/clonepod/attack_ai(mob/user)
	src.add_hiddenprint(user)
	return attack_hand(user)
/obj/machinery/clonepod/attack_paw(mob/user)
	return attack_hand(user)
/obj/machinery/clonepod/attack_hand(mob/user)
	if((isnull(src.occupant)) || (stat & NOPOWER))
		return
	if((isnotnull(src.occupant)) && (src.occupant.stat != DEAD))
		var/completion = (100 * ((src.occupant.health + 100) / (src.heal_level + 100)))
		user << "Current clone cycle is [round(completion)]% complete."
	return

//Clonepod

//Start growing a human clone in the pod!
/obj/machinery/clonepod/proc/growclone(datum/dna2/record/R)
	if(mess || attempting)
		return 0
	var/datum/mind/clonemind = locate(R.mind)
	if(!istype(clonemind, /datum/mind))	//not a mind
		return 0
	if(clonemind.current && clonemind.current.stat != DEAD)	//mind is associated with a non-dead body
		return 0
	if(clonemind.active)	//somebody is using that mind
		if(ckey(clonemind.key) != R.ckey)
			return 0
	else
		for(var/mob/dead/observer/G in GLOBL.player_list)
			if(G.ckey == R.ckey)
				if(G.can_reenter_corpse)
					break
				else
					return 0


	src.heal_level = rand(10,40) //Randomizes what health the clone is when ejected
	src.attempting = 1 //One at a time!!
	src.locked = 1

	src.eject_wait = 1
	spawn(30)
		src.eject_wait = 0

	var/mob/living/carbon/human/H = new /mob/living/carbon/human(src, R.dna.species)
	occupant = H

	if(!R.dna.real_name)	//to prevent null names
		R.dna.real_name = "clone ([rand(0,999)])"
	H.real_name = R.dna.real_name

	src.icon_state = "pod_1"
	//Get the clone body ready
	H.adjustCloneLoss(150) //new damage var so you can't eject a clone early then stab them to abuse the current damage system --NeoFite
	H.adjustBrainLoss(src.heal_level + 50 + rand(10, 30)) // The rand(10, 30) will come out as extra brain damage
	H.Paralyse(4)

	//Here let's calculate their health so the pod doesn't immediately eject them!!!
	H.updatehealth()

	clonemind.transfer_to(H)
	H.ckey = R.ckey
	to_chat(H, SPAN_NOTICE("<b>Consciousness slowly creeps over you as your body regenerates.</b><br><i>So this is what cloning feels like?</i>"))

	// -- Mode/mind specific stuff goes here

	switch(global.PCticker.mode.name)
		if("revolution")
			if((H.mind in global.PCticker.mode:revolutionaries) || (H.mind in global.PCticker.mode:head_revolutionaries))
				global.PCticker.mode.update_all_rev_icons() //So the icon actually appears
		if("nuclear emergency")
			if(H.mind in global.PCticker.mode.syndicates)
				global.PCticker.mode.update_all_synd_icons()
		if("cult")
			if(H.mind in global.PCticker.mode.cult)
				global.PCticker.mode.add_cultist(src.occupant.mind)
				global.PCticker.mode.update_all_cult_icons() //So the icon actually appears

	// -- End mode specific stuff

	if(!R.dna)
		H.dna = new /datum/dna()
		H.dna.real_name = H.real_name
	else
		H.dna = R.dna
	H.UpdateAppearance()
	randmutb(H) //Sometimes the clones come out wrong.
	H.dna.UpdateSE()
	H.dna.UpdateUI()

	H.f_style = "Shaved"
	if(R.dna.species == SPECIES_HUMAN) //no more xenos losing ears/tentacles
		H.h_style = pick("Bedhead", "Bedhead 2", "Bedhead 3")

	H.set_species(R.dna.species)

	//for(var/datum/language/L in languages)
	//	H.add_language(L.name)
	H.suiciding = 0
	src.attempting = 0
	return 1

//Grow clones to maturity then kick them out.  FREELOADERS
/obj/machinery/clonepod/process()
	if(stat & NOPOWER) //Autoeject if power is lost
		if(src.occupant)
			src.locked = 0
			src.go_out()
		return

	if((src.occupant) && (src.occupant.loc == src))
		if((src.occupant.stat == DEAD) || (src.occupant.suiciding) || !occupant.key)  //Autoeject corpses and suiciding dudes.
			src.locked = 0
			src.go_out()
			src.connected_message("Clone Rejected: Deceased.")
			return

		else if(src.occupant.health < src.heal_level)
			src.occupant.Paralyse(4)

			 //Slowly get that clone healed and finished.
			src.occupant.adjustCloneLoss(-2)

			//Premature clones may have brain damage.
			src.occupant.adjustBrainLoss(-1)

			//So clones don't die of oxyloss in a running pod.
			if(src.occupant.reagents.get_reagent_amount("inaprovaline") < 30)
				src.occupant.reagents.add_reagent("inaprovaline", 60)

			//So clones will remain asleep for long enough to get them into cryo (Bay RP edit)
			if(src.occupant.reagents.get_reagent_amount("stoxin") < 10)
				src.occupant.reagents.add_reagent("stoxin", 5)
			if(src.occupant.reagents.get_reagent_amount("chloralhydrate") < 1)
				src.occupant.reagents.add_reagent("chloralhydrate", 1)

			//Also heal some oxyloss ourselves because inaprovaline is so bad at preventing it!!
			src.occupant.adjustOxyLoss(-4)

			use_power(7500) //This might need tweaking.
			return

		else if((src.occupant.health >= src.heal_level) && (!src.eject_wait))
			src.connected_message("Cloning Process Complete.")
			src.locked = 0
			src.go_out()
			return

	else if((!src.occupant) || (src.occupant.loc != src))
		src.occupant = null
		if(src.locked)
			src.locked = 0
		if(!src.mess)
			icon_state = "pod_0"
		//use_power(200)
		return

	return

/obj/machinery/clonepod/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(stat & (BROKEN | NOPOWER))
		FEEDBACK_MACHINE_UNRESPONSIVE(user)
		return FALSE

	if(isnull(occupant))
		to_chat(user, SPAN_WARNING("There's nobody inside to eject!"))
		return FALSE
	to_chat(user, SPAN_WARNING("You force an emergency ejection."))
	locked = FALSE
	go_out()
	return TRUE

//Let's unlock this early I guess.  Might be too early, needs tweaking.
/obj/machinery/clonepod/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/card/id)||istype(W, /obj/item/pda))
		if(!src.check_access(W))
			FEEDBACK_ACCESS_DENIED(user)
			return
		if((!src.locked) || (isnull(src.occupant)))
			return
		if((src.occupant.health < -20) && (src.occupant.stat != DEAD))
			to_chat(user, SPAN_WARNING("Access refused."))
			return
		else
			src.locked = 0
			to_chat(user, "System unlocked.")
	else if(istype(W, /obj/item/cloning_charge))
		to_chat(user, SPAN_INFO("\The [src] processes \the [W]."))
		biomass += 1
		user.drop_item()
		qdel(W)
		return
	else
		..()

//Put messages in the connected computer's temp var for display.
/obj/machinery/clonepod/proc/connected_message(message)
	if((isnull(src.connected)) || (!istype(src.connected, /obj/machinery/computer/cloning)))
		return 0
	if(!message)
		return 0

	src.connected.temp = message
	src.connected.updateUsrDialog()
	return 1

/obj/machinery/clonepod/verb/eject()
	set category = PANEL_OBJECT
	set name = "Eject Cloner"
	set src in oview(1)

	if(usr.stat != 0)
		return
	src.go_out()
	add_fingerprint(usr)
	return

/obj/machinery/clonepod/proc/go_out()
	if(src.locked)
		return

	if(src.mess) //Clean that mess and dump those gibs!
		src.mess = 0
		gibs(src.loc)
		src.icon_state = "pod_0"

		/*
		for(var/obj/O in src)
			O.loc = src.loc
		*/
		return

	if(!(src.occupant))
		return

	/*
	for(var/obj/O in src)
		O.loc = src.loc
	*/

	if(src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.loc = src.loc
	src.icon_state = "pod_0"
	src.eject_wait = 0 //If it's still set somehow.
	domutcheck(src.occupant) //Waiting until they're out before possible monkeyizing.
//	src.occupant.add_side_effect("Bad Stomach") // Give them an extra side-effect for free.
	src.occupant = null

	src.biomass -= CLONE_BIOMASS

	return

/obj/machinery/clonepod/proc/malfunction()
	if(src.occupant)
		src.connected_message("Critical Error!")
		src.mess = 1
		src.icon_state = "pod_g"
		src.occupant.ghostize()
		spawn(5)
			qdel(src.occupant)
	return

/obj/machinery/clonepod/relaymove(mob/user)
	if(user.stat)
		return
	src.go_out()
	return

/obj/machinery/clonepod/emp_act(severity)
	if(prob(100 / severity))
		malfunction()
	..()

/obj/machinery/clonepod/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/atom/movable/A as mob|obj in src)
				A.loc = src.loc
				ex_act(severity)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
				qdel(src)
				return
		if(3.0)
			if(prob(25))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					ex_act(severity)
				qdel(src)
				return
		else
	return

/*
 *	Diskette Box
 */

/obj/item/storage/box/disks
	name = "Diskette Box"
	icon_state = "disk_kit"

	starts_with = list(
		/obj/item/disk/cloning_data = 7
	)

/*
 *	Manual -- A big ol' manual.
 */

/obj/item/paper/Cloning
	name = "paper - 'H-87 Cloning Apparatus Manual"
	info = {"<h4>Getting Started</h4>
	Congratulations, your station has purchased the H-87 industrial cloning device!<br>
	Using the H-87 is almost as simple as brain surgery! Simply insert the target humanoid into the scanning chamber and select the scan option to create a new profile!<br>
	<b>That's all there is to it!</b><br>
	<i>Notice, cloning system cannot scan inorganic life or small primates.  Scan may fail if subject has suffered extreme brain damage.</i><br>
	<p>Clone profiles may be viewed through the profiles menu. Scanning implants a complementary HEALTH MONITOR IMPLANT into the subject, which may be viewed from each profile.
	Profile Deletion has been restricted to \[Station Head\] level access.</p>
	<h4>Cloning from a profile</h4>
	Cloning is as simple as pressing the CLONE option at the bottom of the desired profile.<br>
	Per your company's EMPLOYEE PRIVACY RIGHTS agreement, the H-87 has been blocked from cloning crewmembers while they are still alive.<br>
	<br>
	<p>The provided CLONEPOD SYSTEM will produce the desired clone.  Standard clone maturation times (With SPEEDCLONE technology) are roughly 90 seconds.
	The cloning pod may be unlocked early with any \[Medical Researcher\] ID after initial maturation is complete.</p><br>
	<i>Please note that resulting clones may have a small DEVELOPMENTAL DEFECT as a result of genetic drift.</i><br>
	<h4>Profile Management</h4>
	<p>The H-87 (as well as your station's standard genetics machine) can accept STANDARD DATA DISKETTES.
	These diskettes are used to transfer genetic information between machines and profiles.
	A load/save dialog will become available in each profile if a disk is inserted.</p><br>
	<i>A good diskette is a great way to counter aforementioned genetic drift!</i><br>
	<br>
	<font size=1>This technology produced under license from Thinktronic Systems, LTD.</font>"}

//SOME SCRAPS I GUESS
/* EMP grenade/spell effect
		if(istype(A, /obj/machinery/clonepod))
			A:malfunction()
*/
