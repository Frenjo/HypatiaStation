//MEDBOT
//MEDBOT PATHFINDING
//MEDBOT ASSEMBLY

/obj/machinery/bot/medbot
	name = "medibot"
	desc = "A little medical robot. He looks somewhat underwhelmed."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "medibot0"
	layer = 5.0
	density = FALSE
	anchored = FALSE
	health = 20
	maxhealth = 20
	req_access = list(ACCESS_MEDICAL)

	var/stunned = 0 //It can be stunned by tasers. Delicate circuits.
//var/emagged = 0
	var/list/botcard_access = list(ACCESS_MEDICAL)
	var/obj/item/reagent_holder/glass/reagent_glass = null //Can be set to draw from this for reagents.
	var/skin = null //Set to "tox", "ointment" or "o2" for the other two firstaid kits.
	var/frustration = 0
	var/list/path = list()
	var/mob/living/carbon/patient = null
	var/mob/living/carbon/oldpatient = null
	var/oldloc = null
	var/last_found = 0
	var/last_newpatient_speak = 0 //Don't spam the "HEY I'M COMING" messages
	var/currently_healing = 0
	var/injection_amount = 15 //How much reagent do we inject at a time?
	var/heal_threshold = 10 //Start healing when they have this much damage in a category
	var/use_beaker = 0 //Use reagents in beaker instead of default treatment agents.
	//Setting which reagents to use to treat what by default. By id.
	var/treatment_brute = "tricordrazine"
	var/treatment_oxy = "tricordrazine"
	var/treatment_fire = "tricordrazine"
	var/treatment_tox = "tricordrazine"
	var/treatment_virus = "spaceacillin"
	var/shut_up = 0 //self explanatory :)

/obj/machinery/bot/medbot/mysterious
	name = "mysterious medibot"
	desc = "International Medibot of mystery."
	skin = "bezerk"
	treatment_oxy = "dexalinp"
	treatment_brute = "bicaridine"
	treatment_fire = "kelotane"
	treatment_tox = "anti_toxin"

/obj/machinery/bot/medbot/New()
	. = ..()
	icon_state = "medibot[on]"

/obj/machinery/bot/medbot/initialise()
	. = ..()

	if(isnotnull(skin))
		overlays.Add(image('icons/obj/aibots.dmi', "medskin_[skin]"))

	botcard = new /obj/item/card/id(src)
	if(!length(botcard_access))
		var/datum/job/doctor/J = GLOBL.all_jobs["Medical Doctor"]
		botcard.access = J.get_access()
	else
		botcard.access = botcard_access

/obj/machinery/bot/medbot/turn_on()
	. = ..()
	icon_state = "medibot[on]"
	updateUsrDialog()

/obj/machinery/bot/medbot/turn_off()
	. = ..()
	patient = null
	oldpatient = null
	oldloc = null
	path = list()
	currently_healing = 0
	last_found = world.time
	icon_state = "medibot[on]"
	updateUsrDialog()

/obj/machinery/bot/medbot/attack_paw(mob/user)
	return attack_hand(user)

/obj/machinery/bot/medbot/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	var/dat
	dat += "<TT><B>Automatic Medical Unit v1.0</B></TT><BR><BR>"
	dat += "Status: <A href='byond://?src=\ref[src];power=1'>[on ? "On" : "Off"]</A><BR>"
	dat += "Maintenance panel panel is [open ? "opened" : "closed"]<BR>"
	dat += "Beaker: "
	if(reagent_glass)
		dat += "<A href='byond://?src=\ref[src];eject=1'>Loaded \[[reagent_glass.reagents.total_volume]/[reagent_glass.reagents.maximum_volume]\]</a>"
	else
		dat += "None Loaded"
	dat += "<br>Behaviour controls are [locked ? "locked" : "unlocked"]<hr>"
	if(!locked || issilicon(user))
		dat += "<TT>Healing Threshold: "
		dat += "<a href='byond://?src=\ref[src];adj_threshold=-10'>--</a> "
		dat += "<a href='byond://?src=\ref[src];adj_threshold=-5'>-</a> "
		dat += "[heal_threshold] "
		dat += "<a href='byond://?src=\ref[src];adj_threshold=5'>+</a> "
		dat += "<a href='byond://?src=\ref[src];adj_threshold=10'>++</a>"
		dat += "</TT><br>"

		dat += "<TT>Injection Level: "
		dat += "<a href='byond://?src=\ref[src];adj_inject=-5'>-</a> "
		dat += "[injection_amount] "
		dat += "<a href='byond://?src=\ref[src];adj_inject=5'>+</a> "
		dat += "</TT><br>"

		dat += "Reagent Source: "
		dat += "<a href='byond://?src=\ref[src];use_beaker=1'>[use_beaker ? "Loaded Beaker (When available)" : "Internal Synthesizer"]</a><br>"

		dat += "The speaker switch is [shut_up ? "off" : "on"]. <a href='byond://?src=\ref[src];togglevoice=[1]'>Toggle</a>"

	user << browse("<HEAD><TITLE>Medibot v1.0 controls</TITLE></HEAD>[dat]", "window=automed")
	onclose(user, "automed")

/obj/machinery/bot/medbot/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)
	if(href_list["power"] && allowed(usr))
		if(on)
			turn_off()
		else
			turn_on()

	else if(href_list["adj_threshold"] && (!locked || issilicon(usr)))
		var/adjust_num = text2num(href_list["adj_threshold"])
		heal_threshold += adjust_num
		if(heal_threshold < 5)
			heal_threshold = 5
		if(heal_threshold > 75)
			heal_threshold = 75

	else if(href_list["adj_inject"] && (!locked || issilicon(usr)))
		var/adjust_num = text2num(href_list["adj_inject"])
		injection_amount += adjust_num
		if(injection_amount < 5)
			injection_amount = 5
		if(injection_amount > 15)
			injection_amount = 15

	else if(href_list["use_beaker"] && (!locked || issilicon(usr)))
		use_beaker = !use_beaker

	else if(href_list["eject"] && isnotnull(reagent_glass))
		if(!locked)
			reagent_glass.loc = GET_TURF(src)
			reagent_glass = null
		else
			to_chat(usr, SPAN_NOTICE("You cannot eject the beaker because the panel is locked."))

	else if(href_list["togglevoice"] && (!locked || issilicon(usr)))
		shut_up = !shut_up

	updateUsrDialog()

/obj/machinery/bot/medbot/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/card/id)||istype(W, /obj/item/pda))
		if(allowed(user) && !open && !emagged)
			locked = !locked
			FEEDBACK_TOGGLE_CONTROLS_LOCK(user, locked)
			updateUsrDialog()
		else
			if(emagged)
				FEEDBACK_ERROR_GENERIC(user)
			if(open)
				to_chat(user, SPAN_WARNING("Please close the access panel before locking it."))
			else
				FEEDBACK_ACCESS_DENIED(user)

	else if(istype(W, /obj/item/reagent_holder/glass))
		if(locked)
			to_chat(user, SPAN_NOTICE("You cannot insert a beaker because the panel is locked."))
			return
		if(isnotnull(reagent_glass))
			to_chat(user, SPAN_NOTICE("There is already a beaker loaded."))
			return

		user.drop_item()
		W.loc = src
		reagent_glass = W
		to_chat(user, SPAN_NOTICE("You insert [W]."))
		updateUsrDialog()
		return

	else
		..()
		if(health < maxhealth && !isscrewdriver(W) && W.force)
			step_to(src, (get_step_away(src, user)))

/obj/machinery/bot/medbot/Emag(mob/user)
	. = ..()
	if(open && !locked)
		if(isnotnull(user))
			to_chat(user, SPAN_WARNING("You short out \the [src]'s reagent synthesis circuits."))
		spawn(0)
			for(var/mob/O in hearers(src, null))
				O.show_message(SPAN_DANGER("[src] buzzes oddly!"), 1)
		flick("medibot_spark", src)
		patient = null
		if(user)
			oldpatient = user
		currently_healing = 0
		last_found = world.time
		anchored = FALSE
		emagged = 2
		on = TRUE
		icon_state = "medibot[on]"

/obj/machinery/bot/medbot/process()
	set background = BACKGROUND_ENABLED

	if(!on)
		stunned = 0
		return

	if(stunned)
		icon_state = "medibota"
		stunned--

		oldpatient = patient
		patient = null
		currently_healing = 0

		if(stunned <= 0)
			icon_state = "medibot[on]"
			stunned = 0
		return

	if(frustration > 8)
		oldpatient = patient
		patient = null
		currently_healing = 0
		last_found = world.time
		path = list()

	if(!patient)
		if(!shut_up && prob(1))
			var/message = pick(
				"Radar, put a mask on!", "There's always a catch, and it's the best there is.", "I knew it, I should've been a plastic surgeon.", \
				"What kind of medbay is this? Everyone's dropping like dead flies.", "Delicious!" \
			)
			speak(message)

		for(var/mob/living/carbon/C in view(7, src)) //Time to find a patient!
			if(C.stat == DEAD || !ishuman(C))
				continue

			if(C == oldpatient && (world.time < last_found + 100))
				continue

			if(assess_patient(C))
				patient = C
				oldpatient = C
				last_found = world.time
				spawn(0)
					if((last_newpatient_speak + 100) < world.time) //Don't spam these messages!
						var/message = pick("Hey, you! Hold on, I'm coming.", "Wait! I want to help!", "You appear to be injured!")
						speak(message)
						last_newpatient_speak = world.time
					visible_message("<b>[src]</b> points at [C.name]!")
				break
			else
				continue

	if(patient && (get_dist(src, patient) <= 1))
		if(!currently_healing)
			currently_healing = 1
			frustration = 0
			medicate_patient(patient)
		return

	else if(patient && length(path) && get_dist(patient, path[length(path)]) > 2)
		path = list()
		currently_healing = 0
		last_found = world.time

	if(patient && !length(path) && (get_dist(src, patient) > 1))
		spawn(0)
			path = AStar(loc, GET_TURF(patient), /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 30,id=botcard)
			if(!path)
				path = list()
			if(!length(path))
				oldpatient = patient
				patient = null
				currently_healing = 0
				last_found = world.time
		return

	if(length(path) && patient)
		step_to(src, path[1])
		path -= path[1]
		spawn(3)
			if(length(path))
				step_to(src, path[1])
				path -= path[1]

	if(length(path) > 8 && patient)
		frustration++

/obj/machinery/bot/medbot/proc/assess_patient(mob/living/carbon/C)
	//Time to see if they need medical help!
	if(C.stat == DEAD)
		return 0 //welp too late for them!

	if(C.suiciding)
		return 0 //Kevorkian school of robotic medical assistants.

	if(emagged == 2) //Everyone needs our medicine. (Our medicine is toxins)
		return 1

	//If they're injured, we're using a beaker, and don't have one of our WONDERCHEMS.
	if(reagent_glass && use_beaker && ((C.getBruteLoss() >= heal_threshold) || (C.getToxLoss() >= heal_threshold) || (C.getToxLoss() >= heal_threshold) || (C.getOxyLoss() >= (heal_threshold + 15))))
		for(var/datum/reagent/R in reagent_glass.reagents.reagent_list)
			if(!C.reagents.has_reagent(R))
				return 1
			continue

	//They're injured enough for it!
	if((C.getBruteLoss() >= heal_threshold) && !C.reagents.has_reagent(treatment_brute))
		return 1 //If they're already medicated don't bother!

	if((C.getOxyLoss() >= (15 + heal_threshold)) && !C.reagents.has_reagent(treatment_oxy))
		return 1

	if((C.getFireLoss() >= heal_threshold) && !C.reagents.has_reagent(treatment_fire))
		return 1

	if((C.getToxLoss() >= heal_threshold) && !C.reagents.has_reagent(treatment_tox))
		return 1

	for(var/datum/disease/D in C.viruses)
		if((D.stage > 1) || (D.spread_type == AIRBORNE))
			if(!C.reagents.has_reagent(treatment_virus))
				return 1 //STOP DISEASE FOREVER

	return 0

/obj/machinery/bot/medbot/proc/medicate_patient(mob/living/carbon/C)
	if(!on)
		return

	if(!istype(C))
		oldpatient = patient
		patient = null
		currently_healing = 0
		last_found = world.time
		return

	if(C.stat == DEAD)
		var/death_message = pick("No! NO!", "Live, damnit! LIVE!", "I...I've never lost a patient before. Not today, I mean.")
		speak(death_message)
		oldpatient = patient
		patient = null
		currently_healing = 0
		last_found = world.time
		return

	var/reagent_id = null

	//Use whatever is inside the loaded beaker. If there is one.
	if(use_beaker && reagent_glass?.reagents.total_volume)
		reagent_id = "internal_beaker"

	if(emagged == 2) //Emagged! Time to poison everybody.
		reagent_id = "toxin"

	var/virus = 0
	for(var/datum/disease/D in C.viruses)
		virus = 1

	if(!reagent_id && virus)
		if(!C.reagents.has_reagent(treatment_virus))
			reagent_id = treatment_virus

	if(!reagent_id && (C.getBruteLoss() >= heal_threshold))
		if(!C.reagents.has_reagent(treatment_brute))
			reagent_id = treatment_brute

	if(!reagent_id && (C.getOxyLoss() >= (15 + heal_threshold)))
		if(!C.reagents.has_reagent(treatment_oxy))
			reagent_id = treatment_oxy

	if(!reagent_id && (C.getFireLoss() >= heal_threshold))
		if(!C.reagents.has_reagent(treatment_fire))
			reagent_id = treatment_fire

	if(!reagent_id && (C.getToxLoss() >= heal_threshold))
		if(!C.reagents.has_reagent(treatment_tox))
			reagent_id = treatment_tox

	if(!reagent_id) //If they don't need any of that they're probably cured!
		oldpatient = patient
		patient = null
		currently_healing = 0
		last_found = world.time
		var/message = pick("All patched up!", "An apple a day keeps me away.", "Feel better soon!")
		speak(message)
		return
	else
		icon_state = "medibots"
		visible_message(SPAN_DANGER("[src] is trying to inject [patient]!"))
		spawn(30)
			if((get_dist(src, patient) <= 1) && on)
				if(reagent_id == "internal_beaker" && reagent_glass?.reagents.total_volume)
					reagent_glass.reagents.trans_to(patient, injection_amount) //Inject from beaker instead.
					reagent_glass.reagents.reaction(patient, 2)
				else
					patient.reagents.add_reagent(reagent_id, injection_amount)
				visible_message(SPAN_DANGER("[src] injects [patient] with the syringe!"))

			icon_state = "medibot[on]"
			currently_healing = 0
			return

//	speak(reagent_id)
	reagent_id = null
	return

/obj/machinery/bot/medbot/proc/speak(message)
	if((!on) || (!message))
		return
	visible_message("[src] beeps, \"[message]\"")
	return

/obj/machinery/bot/medbot/bullet_act(obj/item/projectile/Proj)
	if(Proj.flag == "taser")
		stunned = min(stunned + 10, 20)
	..()

/obj/machinery/bot/medbot/explode()
	on = 0
	visible_message(SPAN_DANGER("[src] blows apart!"))

	var/turf/T = GET_TURF(src)
	new /obj/item/storage/firstaid(T)
	new /obj/item/assembly/prox_sensor(T)
	new /obj/item/health_analyser(T)

	if(isnotnull(reagent_glass))
		reagent_glass.loc = T
		reagent_glass = null
	if(prob(50))
		new /obj/item/robot_parts/l_arm(T)

	make_sparks(3, TRUE, src)
	return ..()

/obj/machinery/bot/medbot/Bump(atom/M) //Leave no door unopened!
	if(istype(M, /obj/machinery/door) && isnotnull(botcard))
		var/obj/machinery/door/D = M
		if(!istype(D, /obj/machinery/door/firedoor) && D.check_access(botcard))
			D.open()
			frustration = 0
	else if(isliving(M) && !anchored)
		loc = M:loc
		frustration = 0

/* terrible
/obj/machinery/bot/medbot/Bumped(atom/movable/M)
	spawn(0)
		if (M)
			var/turf/T = GET_TURF(src)
			M:loc = T
*/

/*
 *	Pathfinding procs, allow the medibot to path through doors it has access to.
 */

//Pretty ugh
/*
/turf/proc/AdjacentTurfsAllowMedAccess()
	var/list/L = list()
	for(var/turf/t in oview(src,1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindowNonDoor(t,get_access("Medical Doctor")))
				L.Add(t)
	return L


//It isn't blocked if we can open it, man.
/proc/TurfBlockedNonWindowNonDoor(turf/loc, var/list/access)
	for(var/obj/O in loc)
		if(O.density && !istype(O, /obj/structure/window) && !istype(O, /obj/machinery/door))
			return 1

		if (O.density && istype(O, /obj/machinery/door) && length(access))
			var/obj/machinery/door/D = O
			for(var/req in D.req_access)
				if(!(req in access)) //doesn't have this access
					return 1

	return 0
*/

/*
 *	Medbot Assembly -- Can be made out of all three medkits.
 */
/obj/item/storage/firstaid/attack_by(obj/item/I, mob/user)
	if(!istype(I, /obj/item/robot_parts/l_arm) && !istype(I, /obj/item/robot_parts/r_arm))
		return ..()

	// Making a medibot!
	if(length(contents))
		to_chat(user, SPAN_WARNING("You need to empty \the [src] out first."))
		return TRUE

	var/obj/item/medbot_assembly/assembly = new /obj/item/medbot_assembly()
	if(istype(src, /obj/item/storage/firstaid/fire))
		assembly.skin = "ointment"
	else if(istype(src, /obj/item/storage/firstaid/toxin))
		assembly.skin = "tox"
	else if(istype(src, /obj/item/storage/firstaid/o2))
		assembly.skin = "o2"

	qdel(I)
	user.put_in_hands(assembly)
	to_chat(user, SPAN_INFO("You add the robot arm to the first aid kit."))
	user.drop_from_inventory(src)
	qdel(src)
	return TRUE

/obj/item/medbot_assembly
	name = "first aid/robot arm assembly"
	desc = "A first aid kit with a robot arm permanently grafted to it."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "firstaid_arm"
	w_class = 3.0

	var/build_step = 0
	var/created_name = "Medibot" // To preserve the name if it's a unique medbot I guess
	var/skin = null // Same as medbot, set to tox or ointment for the respective kits.

/obj/item/medbot_assembly/initialise()
	. = ..()
	if(isnotnull(skin))
		overlays.Add(image('icons/obj/aibots.dmi', "kit_skin_[skin]"))

/obj/item/medbot_assembly/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/pen))
		var/t = copytext(stripped_input(user, "Enter new robot name", name, created_name), 1, MAX_NAME_LEN)
		if(isnull(t))
			return
		if(!in_range(src, usr) && loc != usr)
			return
		created_name = t
		return TRUE

	switch(build_step)
		if(0)
			if(istype(I, /obj/item/health_analyser))
				user.drop_item()
				qdel(I)
				build_step++
				to_chat(user, SPAN_INFO("You add the health sensor to [src]."))
				name = "first aid/robot arm/health analyser assembly"
				overlays.Add(image('icons/obj/aibots.dmi', "na_scanner"))
				return TRUE

		if(1)
			if(isprox(I))
				user.drop_item()
				qdel(I)
				build_step++
				to_chat(user, SPAN_INFO("You complete the Medibot! Beep boop."))
				var/obj/machinery/bot/medbot/S = new /obj/machinery/bot/medbot(GET_TURF(src))
				S.skin = skin
				S.name = created_name
				user.drop_from_inventory(src)
				qdel(src)
				return TRUE

	return ..()