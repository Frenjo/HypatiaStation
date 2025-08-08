/mob/living/silicon/pai
	name = "pAI"
	icon = 'icons/mob/mob.dmi'//
	icon_state = "shadow"

	emote_type = 2		// pAIs emotes are heard, not seen, so they can be seen through a container (eg. person)

	var/network = "SS13"
	var/obj/machinery/camera/current = null

	var/ram = 100	// Used as currency to purchase different abilities
	var/list/software = list()
	var/userDNA		// The DNA string of our assigned user
	var/obj/item/paicard/card	// The card we inhabit
	var/obj/item/radio/radio		// Our primary radio

	var/speakStatement = "states"
	var/speakExclamation = "declares"
	var/speakQuery = "queries"

	var/obj/item/pai_cable/cable		// The cable we produce and use when door or camera jacking

	var/master				// Name of the one who commands us
	var/master_dna			// DNA string for owner verification
							// Keeping this separate from the laws var, it should be much more difficult to modify
	var/pai_law0 = "Serve your master."
	var/pai_laws				// String for additional operating instructions our master might give us

	var/silence_time			// Timestamp when we were silenced (normally via EMP burst), set to null after silence has faded

// Various software-specific vars

	var/temp				// General error reporting text contained here will typically be shown once and cleared
	var/screen				// Which screen our main window displays
	var/subscreen			// Which specific function of the main screen is being displayed

	var/obj/item/pda/ai/pai/pda = null

	var/secHUD = FALSE		// Toggles whether the Security HUD is active or not
	var/medHUD = FALSE		// Toggles whether the Medical  HUD is active or not

	var/datum/data/record/medicalActive1		// Datacore record declarations for record software
	var/datum/data/record/medicalActive2

	var/datum/data/record/securityActive1		// Could probably just combine all these into one
	var/datum/data/record/securityActive2

	var/obj/machinery/door/hackdoor		// The airlock being hacked
	var/hackprogress = 0				// Possible values: 0 - 100, >= 100 means the hack is complete and will be reset upon next check

	var/obj/item/radio/integrated/signal/sradio // AI's signaller

/mob/living/silicon/pai/New(obj/item/paicard)
	canmove = FALSE
	loc = paicard
	card = paicard
	sradio = new /obj/item/radio/integrated/signal(src)
	if(isnotnull(card))
		if(isnull(card.radio))
			card.radio = new /obj/item/radio(card)
		radio = card.radio

	//PDA
	pda = new /obj/item/pda/ai/pai(src)
	spawn(5)
		pda.ownjob = "Personal Assistant"
		pda.owner = "[src]"
		pda.name = pda.owner + " (" + pda.ownjob + ")"
		pda.toff = TRUE

	. = ..()

	// Default languages without universal translator software.
	add_language("Sol Common")
	add_language("Tradeband")
	add_language("Gutter")

/mob/living/silicon/pai/Login()
	. = ..()
	SEND_RSC(usr, 'html/assets/paigrid.png', "paigrid.png")

// this function shows the information about being silenced as a pAI in the Status panel
/mob/living/silicon/pai/proc/show_silenced()
	if(silence_time)
		var/timeleft = round((silence_time - world.timeofday) / 10, 1)
		stat(null, "Communications system reboot in -[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]")

/mob/living/silicon/pai/Stat()
	. = ..()
	statpanel(PANEL_STATUS)
	if(client.statpanel == PANEL_STATUS)
		show_silenced()

	if(length(proc_holder_list)) //Generic list for proc_holder objects.
		for(var/obj/effect/proc_holder/P in proc_holder_list)
			statpanel("[P.panel]", "", P)

/mob/living/silicon/pai/check_eye(mob/user)
	if(isnull(current))
		return null
	user.reset_view(current)
	return 1

/mob/living/silicon/pai/blob_act()
	if(stat != DEAD)
		adjustBruteLoss(60)
		updatehealth()
		return 1
	return 0

/mob/living/silicon/pai/emp_act(severity)
	// Silence for 2 minutes
	// 20% chance to kill
		// 33% chance to unbind
		// 33% chance to change prime directive (based on severity)
		// 33% chance of no additional effect

	silence_time = world.timeofday + 120 * 10		// Silence for 2 minutes
	to_chat(src, SPAN_RADIOACTIVE("Communication circuit overload. Shutting down and reloading communication circuits - speech and messaging functionality will be unavailable until the reboot is complete."))
	if(prob(20))
		visible_message(
			message = SPAN_WARNING("A shower of sparks spray from [src]'s inner workings."),
			blind_message = SPAN_WARNING("You hear and smell the ozone hiss of electrical sparks being expelled violently.")
		)
		return death(0)

	switch(pick(1, 2, 3))
		if(1)
			master = null
			master_dna = null
			to_chat(src, SPAN_ALIUM("You feel unbound."))
		if(2)
			var/command
			if(severity == 1)
				command = pick("Serve", "Love", "Fool", "Entice", "Observe", "Judge", "Respect", "Educate", "Amuse", "Entertain", "Glorify", "Memorialize", "Analyse")
			else
				command = pick("Serve", "Kill", "Love", "Hate", "Disobey", "Devour", "Fool", "Enrage", "Entice", "Observe", "Judge", "Respect", "Disrespect", "Consume", "Educate", "Destroy", "Disgrace", "Amuse", "Entertain", "Ignite", "Glorify", "Memorialize", "Analyse")
			pai_law0 = "[command] your master."
			to_chat(src, SPAN_ALIUM("Pr1m3 d1r3c71v3 uPd473D."))
		if(3)
			to_chat(src, SPAN_ALIUM("You feel an electric surge run through your circuitry and become acutely aware at how lucky you are that you can still feel at all."))

// See software.dm for Topic()

/mob/living/silicon/pai/meteorhit(obj/O)
	visible_message(SPAN_DANGER("[src] has been hit by [O]!"))
	if(health > 0)
		adjustBruteLoss(30)
		if((O.icon_state == "flaming"))
			adjustFireLoss(40)
		updatehealth()

/mob/living/silicon/pai/proc/switchCamera(obj/machinery/camera/C)
	usr:cameraFollow = null
	if(isnull(C))
		unset_machine()
		reset_view(null)
		return 0
	if(stat == DEAD || !C.status || !(network in C.network))
		return 0

	// ok, we're alive, camera is good and in our network...

	set_machine(src)
	src:current = C
	reset_view(C)
	return 1

/mob/living/silicon/pai/cancel_camera()
	set category = "pAI Commands"
	set name = "Cancel Camera View"

	reset_view(null)
	unset_machine()
	src:cameraFollow = null

//Addition by Mord_Sith to define AI's network change ability
/*
/mob/living/silicon/pai/proc/pai_network_change()
	set category = "pAI Commands"
	set name = "Change Camera Network"
	reset_view(null)
	unset_machine()
	src:cameraFollow = null
	var/cameralist[0]

	if(usr.stat == 2)
		to_chat(usr, SPAN_WARNING("You can't change your camera network because you are dead!"))
		return

	for (var/obj/machinery/camera/C in Cameras)
		if(!C.status)
			continue
		else
			if(C.network != "CREED" && C.network != "thunder" && C.network != "RD" && C.network != "toxins" && C.network != "Prison") COMPILE ERROR! This will have to be updated as camera.network is no longer a string, but a list instead
				cameralist[C.network] = C.network

	network = input(usr, "Which network would you like to view?") as null|anything in cameralist
	to_chat(src, SPAN_INFO("Switched to [network] camera network."))
//End of code by Mord_Sith
*/


/*
// Debug command - Maybe should be added to admin verbs later
/mob/verb/makePAI(var/turf/t in view())
	var/obj/item/paicard/card = new(t)
	var/mob/living/silicon/pai/pai = new(card)
	pai.key = key
	card.setPersonality(pai)

*/

// No binary for pAIs.
/mob/living/silicon/pai/binarycheck()
	return 0