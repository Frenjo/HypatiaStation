/mob/living/silicon
	gender = NEUTER
	voice_name = "synthesized voice"

	immune_to_ssd = TRUE

	var/syndicate = 0
	var/datum/ai_laws/laws = null	//Now... THEY ALL CAN ALL HAVE LAWS

	var/list/hud_list
	var/list/speech_synthesizer_langs //which languages can be vocalized by the speech synthesizer

	var/local_transmit //If set, can only speak to others of the same type within a short range.

	var/sensor_mode = 0 //Determines the current HUD.
	#define SEC_HUD 1 //Security HUD mode
	#define MED_HUD 2 //Medical HUD mode

/mob/living/silicon/New()
	hud_list = list()
	speech_synthesizer_langs = list()
	. = ..()

/mob/living/silicon/drop_item()
	return

/mob/living/silicon/restrained()
	return FALSE

/mob/living/silicon/emp_act(severity)
	switch(severity)
		if(1)
			take_organ_damage(20)
			Stun(rand(5, 10))
		if(2)
			take_organ_damage(10)
			Stun(rand(1, 5))
	flick("noise", src:flash)
	to_chat(src, SPAN_DANGER("*BZZZT*"))
	to_chat(src, SPAN_WARNING("Warning: Electromagnetic pulse detected."))
	..()

/mob/living/silicon/IsAdvancedToolUser()
	return 1

/mob/living/silicon/blob_act()
	if(stat != DEAD)
		adjustBruteLoss(60)
		updatehealth()
		return 1
	return 0

/mob/living/silicon/bullet_act(obj/item/projectile/proj)
	if(!proj.nodamage)
		adjustBruteLoss(proj.damage)
	proj.on_hit(src, 2)

	updatehealth()
	return 2

/mob/living/silicon/apply_effect(effect = 0, effecttype = STUN, blocked = 0)
	return 0//The only effect that can hit them atm is flashes and they still directly edit so this works for now
/*
	if(!effect || (blocked >= 2))	return 0
	switch(effecttype)
		if(STUN)
			stunned = max(stunned,(effect/(blocked+1)))
		if(WEAKEN)
			weakened = max(weakened,(effect/(blocked+1)))
		if(PARALYZE)
			paralysis = max(paralysis,(effect/(blocked+1)))
		if(IRRADIATE)
			radiation += min((effect - (effect*getarmor(null, "rad"))), 0)//Rads auto check armor
		if(STUTTER)
			stuttering = max(stuttering,(effect/(blocked+1)))
		if(EYE_BLUR)
			eye_blurry = max(eye_blurry,(effect/(blocked+1)))
		if(DROWSY)
			drowsyness = max(drowsyness,(effect/(blocked+1)))
	updatehealth()
	return 1*/

/mob/living/silicon/ex_act(severity)
	if(!blinded)
		flick("flash", flash)

	switch(severity)
		if(1)
			if(stat != DEAD)
				adjustBruteLoss(100)
				adjustFireLoss(100)
				if(!anchored)
					gib()
		if(2)
			if(stat != DEAD)
				adjustBruteLoss(60)
				adjustFireLoss(60)
		if(3)
			if(stat != DEAD)
				adjustBruteLoss(30)

	updatehealth()

// This adds the basic clock, shuttle recall timer, and malf_ai info to all silicon lifeforms
/mob/living/silicon/Stat()
	. = ..()
	statpanel(PANEL_STATUS)
	if(client.statpanel == PANEL_STATUS)
		show_station_time()
		show_emergency_shuttle_eta()
		show_system_integrity()
		show_malf_ai()

//Silicon mob language procs
/mob/living/silicon/can_speak(datum/language/speaking)
	return universal_speak || (speaking in speech_synthesizer_langs)	//need speech synthesizer support to vocalize a language

/mob/living/silicon/add_language(language, can_speak = TRUE)
	if(..(language) && can_speak)
		speech_synthesizer_langs.Add(GLOBL.all_languages[language])

/mob/living/silicon/remove_language(rem_language)
	..(rem_language)

	for(var/datum/language/L in speech_synthesizer_langs)
		if(L.name == rem_language)
			speech_synthesizer_langs.Remove(L)

/mob/living/silicon/check_languages()
	set category = PANEL_IC
	set name = "Check Known Languages"
	set src = usr

	var/dat = "<b><font size = 5>Known Languages</font></b><br/><br/>"

	for(var/datum/language/L in languages)
		dat += "<b>[L.name] (:[L.key])</b><br/>Speech Synthesizer: <i>[(L in speech_synthesizer_langs)? "YES" : "NOT SUPPORTED"]</i><br/>[L.desc]<br/><br/>"

	src << browse(dat, "window=checklanguage")

/mob/living/silicon/binarycheck()
	return 1

/proc/islinked(mob/living/silicon/robot/bot, mob/living/silicon/ai/ai)
	if(!istype(bot) || !istype(ai))
		return 0
	if(bot.connected_ai == ai)
		return 1
	return 0

/mob/living/silicon/proc/show_laws()
	return

/mob/living/silicon/proc/damage_mob(brute = 0, fire = 0, tox = 0)
	return

// this function shows the health of the pAI in the Status panel
/mob/living/silicon/proc/show_system_integrity()
	if(!stat)
		stat(null, text("System integrity: [(health + 100) / 2]%"))
	else
		stat(null, text("Systems nonfunctional"))

// This is a pure virtual function, it should be overwritten by all subclasses
/mob/living/silicon/proc/show_malf_ai()
	return 0

// this function displays the station time in the status panel
/mob/living/silicon/proc/show_station_time()
	stat(null, "Station Time: [worldtime2text()]")

// this function displays the shuttles ETA in the status panel if the shuttle has been called
/mob/living/silicon/proc/show_emergency_shuttle_eta()
	if(global.PCemergency.online() && !global.PCemergency.returned())
		var/timeleft = global.PCemergency.estimate_arrival_time()
		if(timeleft)
			stat(null, "ETA-[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]")

// this function displays the stations manifest in a separate window
/mob/living/silicon/proc/show_station_manifest()
	var/dat
	dat += "<h4>Crew Manifest</h4>"
	if(isnotnull(GLOBL.data_core))
		dat += GLOBL.data_core.get_manifest(1) // make it monochrome
	dat += "<br>"
	src << browse(dat, "window=airoster")
	onclose(src, "airoster")

/mob/living/silicon/proc/toggle_sensor_mode()
	set name = "Set Sensor Augmentation"
	set desc = "Augment visual feed with internal sensor overlays."

	var/sensor_type = input("Please select sensor type.", "Sensor Integration", null) in list("Security", "Medical", "Disable")
	switch(sensor_type)
		if("Security")
			sensor_mode = SEC_HUD
			to_chat(src, SPAN_NOTICE("Security records overlay enabled."))
		if("Medical")
			sensor_mode = MED_HUD
			to_chat(src, SPAN_NOTICE("Life signs monitor overlay enabled."))
		if("Disable")
			sensor_mode = 0
			to_chat(src, "Sensor augmentations disabled.")