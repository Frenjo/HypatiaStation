//For the love of god,space out your code! This is a nightmare to read.

//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+++++++++++++++++++++++++++++++++//                    //++++++++++++++++++++++++++++++++++
===================================SPACE NINJA EQUIPMENT===================================
___________________________________________________________________________________________
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

/*
===================================================================================
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<SPACE NINJA SUIT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
===================================================================================
*/

//=======//NEW AND DEL//=======//

/obj/item/clothing/suit/space/space_ninja/New()
	..()
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/init//suit initialize verb
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ai_instruction//for AIs
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ai_holo
	//verbs += /obj/item/clothing/suit/space/space_ninja/proc/display_verb_procs//DEBUG. Doesn't work.
	spark_system = new()//spark initialize
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

	for(var/decl/tech/T, GET_DECL_SUBTYPE_INSTANCES(/decl/tech)) // Store up on research.
		stored_research.Add(T)

	var/reagent_amount//reagent initialize
	for(var/reagent_id in reagent_list)
		reagent_amount += reagent_id == "radium" ? r_maxamount + (a_boost * a_transfer) : r_maxamount // AI can inject radium directly.
	reagents = new(reagent_amount)
	reagents.my_atom = src
	for(var/reagent_id in reagent_list)
		reagent_id == "radium" ? reagents.add_reagent(reagent_id, r_maxamount+(a_boost*a_transfer)) : reagents.add_reagent(reagent_id, r_maxamount)//It will take into account radium used for adrenaline boosting.
	cell = new/obj/item/cell/high//The suit should *always* have a battery because so many things rely on it.
	cell.charge = 9000//Starting charge should not be higher than maximum charge. It leads to problems with recharging.

/obj/item/clothing/suit/space/space_ninja/Destroy()
	if(affecting)//To make sure the window is closed.
		affecting << browse(null, "window=hack spideros")
	if(isnotnull(AI))//If there are AIs present when the ninja kicks the bucket.
		killai()
	if(isnotnull(hologram))//If there is a hologram
		QDEL_NULL(hologram.i_attached)//Delete it and the attached image.
		QDEL_NULL(hologram)
	return ..()

//Simply deletes all the attachments and self, killing all related procs.
/obj/item/clothing/suit/space/space_ninja/proc/terminate()
	qdel(n_hood)
	qdel(n_gloves)
	qdel(n_shoes)
	qdel(src)

/obj/item/clothing/suit/space/space_ninja/proc/killai(mob/living/silicon/ai/A = AI)
	if(A.client)
		to_chat(A, SPAN_WARNING("Self-erase protocol dete-- *bzzzzz*"))
		A << browse(null, "window=hack spideros")
	AI = null
	A.death(1)//Kill, deleting mob.
	qdel(A)
	return

//=======//SUIT VERBS//=======//
//Verbs link to procs because verb-like procs have a bug which prevents their use if the arguments are not readily referenced.

/obj/item/clothing/suit/space/space_ninja/proc/init()
	set name = "Initialize Suit"
	set desc = "Initializes the suit for field operation."
	set category = "Ninja Equip"

	ninitialize()
	return

/obj/item/clothing/suit/space/space_ninja/proc/deinit()
	set name = "De-Initialize Suit"
	set desc = "Begins procedure to remove the suit."
	set category = "Ninja Equip"

	if(s_control&&!s_busy)
		deinitialize()
	else
		to_chat(affecting, SPAN_WARNING("The function did not trigger!"))
	return

/obj/item/clothing/suit/space/space_ninja/proc/spideros()
	set name = "Display SpiderOS"
	set desc = "Utilize built-in computer system."
	set category = "Ninja Equip"

	if(s_control&&!s_busy&&!kamikaze)
		display_spideros()
	else
		to_chat(affecting, SPAN_WARNING("The interface is locked!"))
	return

/obj/item/clothing/suit/space/space_ninja/proc/stealth()
	set name = "Toggle Stealth"
	set desc = "Utilize the internal CLOAK-tech device to activate or deactivate stealth-camo."
	set category = "Ninja Equip"

	if(s_control&&!s_busy)
		toggle_stealth()
	else
		to_chat(affecting, SPAN_WARNING("Stealth does not appear to work!"))
	return

//=======//PROCESS PROCS//=======//

/obj/item/clothing/suit/space/space_ninja/proc/ntick(mob/living/carbon/human/U = affecting)
	set background = BACKGROUND_ENABLED

	//Runs in the background while the suit is initialized.
	spawn while(cell.charge>=0)

		//Let's check for some safeties.
		if(s_initialized&&!affecting)	terminate()//Kills the suit and attached objects.
		if(!s_initialized)	return//When turned off the proc stops.
		if(AI&&AI.stat==2)//If there is an AI and it's ded. Shouldn't happen without purging, could happen.
			if(!s_control)
				ai_return_control()//Return control to ninja if the AI was previously in control.
			killai()//Delete AI.

		//Now let's do the normal processing.
		if(s_coold)	s_coold--//Checks for ability s_cooldown first.
		var/A = s_cost//s_cost is the default energy cost each ntick, usually 5.
		if(!kamikaze)
			if(blade_check(U))//If there is a blade held in hand.
				A += s_acost
			if(s_active)//If stealth is active.
				A += s_acost
		else
			if(prob(s_delay))//Suit delay is used as probability. May change later.
				U.adjustBruteLoss(k_damage)//Default damage done, usually 1.
			A = k_cost//kamikaze cost.
		cell.charge-=A
		if(cell.charge<=0)
			if(kamikaze)
				U.say("I DIE TO LIVE AGAIN!")
				U << browse(null, "window=spideros")//Just in case.
				U.death()
				return
			cell.charge=0
			cancel_stealth()
		sleep(10)//Checks every second.

//=======//INITIALIZE//=======//

/obj/item/clothing/suit/space/space_ninja/proc/ninitialize(delay = s_delay, mob/living/carbon/human/U = loc)
	if(U.mind && U.mind.assigned_role=="MODE" && !s_initialized && !s_busy)//Shouldn't be busy... but anything is possible I guess.
		s_busy = 1
		for(var/i,i<7,i++)
			switch(i)
				if(0)
					to_chat(U, SPAN_INFO("Now initializing..."))
				if(1)
					if(!lock_suit(U))//To lock the suit onto wearer.
						break
					to_chat(U, "\blue Securing external locking mechanism...\nNeural-net established.")
				if(2)
					to_chat(U, "\blue Extending neural-net interface...\nNow monitoring brain wave pattern...")
				if(3)
					if(U.stat==2||U.health<=0)
						to_chat(U, "\red <B>FĆAL �Rr�R</B>: 344--93#�&&21 BR��N |/|/aV� PATT$RN <B>RED</B>\nA-A-aB�rT�NG...")
						unlock_suit()
						break
					lock_suit(U,1)//Check for icons.
					U.regenerate_icons()
					to_chat(U, "\blue Linking neural-net interface...\nPattern \green <B>GREEN</B>\blue, continuing operation.")
				if(4)
					to_chat(U, "\blue VOID-shift device status: <B>ONLINE</B>.\nCLOAK-tech device status: <B>ONLINE</B>.")
				if(5)
					to_chat(U, "\blue Primary system status: <B>ONLINE</B>.\nBackup system status: <B>ONLINE</B>.\nCurrent energy capacity: <B>[cell.charge]</B>.")
				if(6)
					to_chat(U, "\blue All systems operational. Welcome to <B>SpiderOS</B>, [U.real_name].")
					grant_ninja_verbs()
					grant_equip_verbs()
					ntick()
			sleep(delay)
		s_busy = 0
	else
		if(!U.mind||U.mind.assigned_role!="MODE")//Your run of the mill persons shouldn't know what it is. Or how to turn it on.
			to_chat(U, "You do not understand how this suit functions. Where the heck did it even come from?")
		else if(s_initialized)
			to_chat(U, "\red The suit is already functioning. \black <b>Please report this bug.</b>")
		else
			to_chat(U, "\red <B>ERROR</B>: \black You cannot use this function at this time.")
	return

//=======//DEINITIALIZE//=======//

/obj/item/clothing/suit/space/space_ninja/proc/deinitialize(delay = s_delay)
	if(affecting==loc&&!s_busy)
		var/mob/living/carbon/human/U = affecting
		if(!s_initialized)
			to_chat(U, "\red The suit is not initialized. \black <b>Please report this bug.</b>")
			return
		if(alert("Are you certain you wish to remove the suit? This will take time and remove all abilities.",,"Yes","No")=="No")
			return
		if(s_busy||flush)
			to_chat(U, "\red <B>ERROR</B>: \black You cannot use this function at this time.")
			return
		s_busy = 1
		for(var/i = 0,i<7,i++)
			switch(i)
				if(0)
					to_chat(U, SPAN_INFO("Now de-initializing..."))
					remove_kamikaze(U)//Shutdowns kamikaze.
					spideros = 0//Spideros resets.
				if(1)
					to_chat(U, "\blue Logging off, [U:real_name]. Shutting down <B>SpiderOS</B>.")
					remove_ninja_verbs()
				if(2)
					to_chat(U, "\blue Primary system status: <B>OFFLINE</B>.\nBackup system status: <B>OFFLINE</B>.")
				if(3)
					to_chat(U, "\blue VOID-shift device status: <B>OFFLINE</B>.\nCLOAK-tech device status: <B>OFFLINE</B>.")
					cancel_stealth()//Shutdowns stealth.
				if(4)
					to_chat(U, "\blue Disconnecting neural-net interface...\green<B>Success</B>\blue.")
				if(5)
					to_chat(U, "\blue Disengaging neural-net interface...\green<B>Success</B>\blue.")
				if(6)
					to_chat(U, "\blue Unsecuring external locking mechanism...\nNeural-net abolished.\nOperation status: <B>FINISHED</B>.")
					blade_check(U,2)
					remove_equip_verbs()
					unlock_suit()
					U.regenerate_icons()
			sleep(delay)
		s_busy = 0
	return

//=======//SPIDEROS PROC//=======//

/obj/item/clothing/suit/space/space_ninja/proc/display_spideros()
	if(!affecting)	return//If no mob is wearing the suit. I almost forgot about this variable.
	var/mob/living/carbon/human/U = affecting
	var/mob/living/silicon/ai/A = AI
	var/display_to = s_control ? U : A//Who do we want to display certain messages to?

	var/dat = "<html><head><title>SpiderOS</title></head><body bgcolor=\"#3D5B43\" text=\"#B65B5B\"><style>a, a:link, a:visited, a:active, a:hover { color: #B65B5B; }img {border-style:none;}</style>"
	dat += "<a href='byond://?src=\ref[src];choice=Refresh'><img src=sos_7.png> Refresh</a>"
	if(spideros)
		dat += " | <a href='byond://?src=\ref[src];choice=Return'><img src=sos_1.png> Return</a>"
	dat += " | <a href='byond://?src=\ref[src];choice=Close'><img src=sos_8.png> Close</a>"
	dat += "<br>"
	if(s_control)
		dat += "<h2 ALIGN=CENTER>SpiderOS v.1.337</h2>"
		dat += "Welcome, <b>[U.real_name]</b>.<br>"
	else
		dat += "<h2 ALIGN=CENTER>SpiderOS v.<b>ERR-RR00123</b></h2>"
	dat += "<br>"
	dat += "<img src=sos_10.png> Current Time: [worldtime2text()]<br>"
	dat += "<img src=sos_9.png> Battery Life: [round(cell.charge/100)]%<br>"
	dat += "<img src=sos_11.png> Smoke Bombs: \Roman [s_bombs]<br>"
	dat += "<img src=sos_14.png> pai Device: "
	if(pai)
		dat += "<a href='byond://?src=\ref[src];choice=Configure pAI'>Configure</a>"
		dat += " | "
		dat += "<a href='byond://?src=\ref[src];choice=Eject pAI'>Eject</a>"
	else
		dat += "None Detected"
	dat += "<br><br>"

	switch(spideros)
		if(0)
			dat += "<h4><img src=sos_1.png> Available Functions:</h4>"
			dat += "<ul>"
			dat += "<li><a href='byond://?src=\ref[src];choice=7'><img src=sos_4.png> Research Stored</a></li>"
			if(s_control)
				if(AI)
					dat += "<li><a href='byond://?src=\ref[src];choice=5'><img src=sos_13.png> AI Status</a></li>"
			else
				dat += "<li><a href='byond://?src=\ref[src];choice=Shock'><img src=sos_4.png> Shock [U.real_name]</a></li>"
				dat += "<li><a href='byond://?src=\ref[src];choice=6'><img src=sos_6.png> Activate Abilities</a></li>"
			dat += "<li><a href='byond://?src=\ref[src];choice=3'><img src=sos_3.png> Medical Screen</a></li>"
			dat += "<li><a href='byond://?src=\ref[src];choice=1'><img src=sos_5.png> Atmos Scan</a></li>"
			dat += "<li><a href='byond://?src=\ref[src];choice=2'><img src=sos_12.png> Messenger</a></li>"
			if(s_control)
				dat += "<li><a href='byond://?src=\ref[src];choice=4'><img src=sos_6.png> Other</a></li>"
			dat += "</ul>"
		if(3)
			dat += "<h4><img src=sos_3.png> Medical Report:</h4>"
			if(U.dna)
				dat += "<b>Fingerprints</b>: <i>[md5(U.dna.uni_identity)]</i><br>"
				dat += "<b>Unique identity</b>: <i>[U.dna.unique_enzymes]</i><br>"
			dat += "<h4>Overall Status: [U.stat > 1 ? "dead" : "[U.health]% healthy"]</h4>"
			dat += "<h4>Nutrition Status: [U.nutrition]</h4>"
			dat += "Oxygen loss: [U.getOxyLoss()]"
			dat += " | Toxin levels: [U.getToxLoss()]<br>"
			dat += "Burn severity: [U.getFireLoss()]"
			dat += " | Brute trauma: [U.getBruteLoss()]<br>"
			dat += "Radiation Level: [U.radiation] rad<br>"
			dat += "Body Temperature: [U.bodytemperature-T0C]&deg;C ([U.bodytemperature*1.8-459.67]&deg;F)<br>"

			for_no_type_check(var/datum/disease/D, U.viruses)
				dat += "Warning: Virus Detected. Name: [D.name].Type: [D.spread]. Stage: [D.stage]/[D.max_stages]. Possible Cure: [D.cure].<br>"
			dat += "<ul>"
			for_no_type_check(var/datum/reagent/R, reagents.reagent_list)
				if(istype(R, /datum/reagent/radium) && s_control)//Can only directly inject radium when AI is in control.
					continue
				dat += "<li><a href='byond://?src=\ref[src];choice=Inject;name=[R.name];tag=[R.id]'><img src=sos_2.png> Inject [R.name]: [(reagents.get_reagent_amount(R.id) - (istype(R, /datum/reagent/radium) ? (a_boost * a_transfer) : 0)) / (istype(R, /datum/reagent/nutriment) ? 5 : a_transfer)] left</a></li>"
			dat += "</ul>"
		if(1)
			dat += "<h4><img src=sos_5.png> Atmospheric Scan:</h4>"//Headers don't need breaks. They are automatically placed.
			var/turf/T = GET_TURF(U)
			if (isnull(T))
				dat += "Unable to obtain a reading."
			else
				var/datum/gas_mixture/environment = T.return_air()

				var/pressure = environment.return_pressure()
				var/total_moles = environment.total_moles

				dat += "Air Pressure: [round(pressure,0.1)] kPa"

				if(total_moles)
					var/decl/xgm_gas_data/gas_data = GET_DECL_INSTANCE(/decl/xgm_gas_data)
					for(var/g in environment.gas)
						dat += "<li>[gas_data.name[g]]: [round((environment.gas[g] / total_moles) * 100)]%</li>"
					dat += "</ul>"
					dat += "Temperature: [round(environment.temperature-T0C)]&deg;C"
		if(2)
			if(k_unlock==7||!s_control)
				dat += "<a href='byond://?src=\ref[src];choice=32'><img src=sos_1.png> Hidden Menu</a>"
			dat += "<h4><img src=sos_12.png> Anonymous Messenger:</h4>"//Anonymous because the receiver will not know the sender's identity.
			dat += "<h4><img src=sos_6.png> Detected PDAs:</h4>"
			dat += "<ul>"
			var/count = 0
			for (var/obj/item/pda/P in GLOBL.movable_atom_list)
				if (!P.owner||P.toff)
					continue
				dat += "<li><a href='byond://?src=\ref[src];choice=Message;target=\ref[P]'>[P]</a>"
				dat += "</li>"
				count++
			dat += "</ul>"
			if (count == 0)
				dat += "None detected.<br>"
		if(32)
			dat += "<h4><img src=sos_1.png> Hidden Menu:</h4>"
			if(s_control)
				dat += "Please input password: "
				dat += "<a href='byond://?src=\ref[src];choice=Unlock Kamikaze'><b>HERE</b></a><br>"
				dat += "<br>"
				dat += "Remember, you will not be able to recharge energy during this function. If energy runs out, the suit will auto self-destruct.<br>"
				dat += "Use with caution. De-initialize the suit when energy is low."
			else
				//Only leaving this in for funnays. CAN'T LET YOU DO THAT STAR FOX
				dat += "<b>WARNING</b>: Hostile runtime intrusion detected: operation locked. The Spider Clan is watching you, <b>INTRUDER</b>."
				dat += "<b>ERROR</b>: TARANTULA.v.4.77.12 encryption algorithm detected. Unable to decrypt archive.<br>"
		if(4)
			dat += {"
					<h4><img src=sos_6.png> Ninja Manual:</h4>
					<h5>Who they are:</h5>
					Space ninjas are a special type of ninja, specifically one of the space-faring type. The vast majority of space ninjas belong to the Spider Clan, a cult-like sect, which has existed for several hundred years. The Spider Clan practice a sort of augmentation of human flesh in order to achieve a more perfect state of being and follow Postmodern Space Bushido. They also kill people for money. Their leaders are chosen from the oldest of the grand-masters, people that have lived a lot longer than any mortal man should.<br>Being a sect of technology-loving fanatics, the Spider Clan have the very best to choose from in terms of hardware--cybernetic implants, exoskeleton rigs, hyper-capacity batteries, and you get the idea. Some believe that much of the Spider Clan equipment is based on reverse-engineered alien technology while others doubt such claims.<br>Whatever the case, their technology is absolutely superb.
					<h5>How they relate to other SS13 organisations:</h5>
					<ul>
					<li>*<b>NanoTrasen</b> and the Syndicate are two sides of the same coin and that coin is valuable.</li>
					<li>*<b>The Space Wizard Federation</b> is a problem, mainly because they are an extremely dangerous group of unpredictable individuals--not to mention the wizards hate technology and are in direct opposition of the Spider Clan. Best avoided or left well-enough alone. How to battle: wizards possess several powerful abilities to steer clear off. Blind in particular is a nasty spell--jaunt away if you are blinded and never approach a wizard in melee. Stealth may also work if the wizard is not wearing thermal scanners--don't count on this. Run away if you feel threatened and await a better opportunity.</li>
					<li>*<b>Changeling Hivemind</b>: extremely dangerous and to be killed on sight. How to battle: they will likely try to absorb you. Adrenaline boost, then phase shift into them. If you get stung, use SpiderOS to inject counter-agents. Stealth may also work but detecting a changeling is the real battle.</li>
					<li>*<b>Xeno Hivemind</b>: their skulls make interesting kitchen decorations and are challenging to best, especially in larger nests. How to battle: they can see through your stealth guise and energy stars will not work on them. Best killed with a Phase Shift or at range. If you happen on a projectile stun weapon, use it and then close in to melee.</li>
					</ul>
					<h5>The reason they (you) are here:</h5>
					Space ninjas are renowned throughout the known controlled space as fearless spies, infiltrators, and assassins. They are sent on missions of varying nature by NanoTrasen, the Syndicate, and other shady organisations and people. To hire a space ninja means serious business.
					<h5>Their playstyle:</h5>
					A mix of traitor, changeling, and wizard. Ninjas rely on energy, or electricity to be precise, to keep their suits running (when out of energy, a suit hibernates). Suits gain energy from objects or creatures that contain electrical charge. APCs, cell batteries, rechargers, SMES batteries, cyborgs, mechs, and exposed wires are currently supported. Through energy ninjas gain access to special powers--while all powers are tied to the ninja suit, the most useful of them are verb activated--to help them in their mission.<br>It is a constant struggle for a ninja to remain hidden long enough to recharge the suit and accomplish their objective; despite their arsenal of abilities, ninjas can die like any other. Unlike wizards, ninjas do not possess good crowd control and are typically forced to play more subdued in order to achieve their goals. Some of their abilities are specifically designed to confuse and disorient others.<br>With that said, it should be perfectly possible to completely flip the fuck out and rampage as a ninja.
					<h5>Their powers:</h5>
					There are two primary types: Equipment and Abilties. Passive effect are always on. Active effect must be turned on and remain active only when there is energy to do so. Ability costs are listed next to them.
					<b>Equipment</b>: cannot be tracked by AI (passive), faster speed (passive), stealth (active), vision switch (passive if toggled), voice masking (passive), SpiderOS (passive if toggled), energy drain (passive if toggled).
					<ul>
					<li><i>Voice masking</i> generates a random name the ninja can use over the radio and in-person. Although, the former use is recommended.</li>
					<li><i>Toggling vision</i> cycles to one of the following: thermal, meson, or darkness vision. The starting mode allows one to scout the identity of those in view, revealing their role. Traitors, revolutionaries, wizards, and other such people will be made known to you.</li>
					<li><i>Stealth</i>, when activated, drains more battery charge and works similarly to a Syndicate cloak. The cloak will deactivate when most Abilities are utilized.</li>
					<li><i>On-board AI</i>: The suit is able to download an AI much like an intelicard. Check with SpiderOS for details once downloaded.</li>
					<li><i>SpiderOS</i> is a specialized, PDA-like screen that allows for a small variety of functions, such as injecting healing chemicals directly from the suit. You are using it now, if that was not already obvious. You may also download AI modules directly to the OS.</li>
					</ul>
					<b>Abilities</b>:
					<ul>
					<li>*<b>Phase Shift</b> (<i>2000E</i>) and <b>Phase Jaunt</b> (<i>1000E</i>) are unique powers in that they can both be used for defense and offense. Jaunt launches the ninja forward facing up to 9 squares, somewhat randomly selecting the final destination. Shift can only be used on turf in view but is precise (cannot be used on walls). Any living mob in the area teleported to is instantly gibbed (mechs are damaged, huggers and other similar critters are killed). It is possible to teleport with a target, provided you grab them before teleporting.</li>
					<li>*<b>Energy Blade</b> (<i>500E</i>) is a highly effective weapon. It is summoned directly to the ninja's hand and can also function as an EMAG for certain objects (doors/lockers/etc). You may also use it to cut through walls and disabled doors. Experiment! The blade will crit humans in two hits. This item cannot be placed in containers and when dropped or thrown disappears. Having an energy blade drains more power from the battery each tick.</li>
					<li>*<b>EM Pulse</b> (<i>2500E</i>) is a highly useful ability that will create an electromagnetic shockwave around the ninja, disabling technology whenever possible. If used properly it can render a security force effectively useless. Of course, getting beat up with a toolbox is not accounted for.</li>
					<li>*<b>Energy Star</b> (<i>500E</i>) is a ninja star made of green energy AND coated in poison. It works by picking a random living target within range and can be spammed to great effect in incapacitating foes. Just remember that the poison used is also used by the Xeno Hivemind (and will have no effect on them).</li>
					<li>*<b>Energy Net</b> (<i>2000E</i>) is a non-lethal solution to incapacitating humanoids. The net is made of non-harmful phase energy and will halt movement as long as it remains in effect--it can be destroyed. If the net is not destroyed, after a certain time it will teleport the target to a holding facility for the Spider Clan and then vanish. You will be notified if the net fails or succeeds in capturing a target in this manner. Combine with energy stars or stripping to ensure success. Abduction never looked this leet.</li>
					<li>*<b>Adrenaline Boost</b> (<i>1 E. Boost/3</i>) recovers the user from stun, weakness, and paralysis. Also injects 20 units of radium into the bloodstream.</li>
					<li>*<b>Smoke Bomb</b> (<i>1 Sm.Bomb/10</i>) is a weak but potentially useful ability. It creates harmful smoke and can be used in tandem with other powers to confuse enemies.</li>
					<li>*<b>???</b>: unleash the <b>True Ultimate Power!</b></li>
					<h4>IMPORTANT:</h4>
					<ul>
					<li>*Make sure to toggle Special Interaction from the Ninja Equipment menu to interact differently with certain objects.</li>
					<li>*Your starting power cell can be replaced if you find one with higher maximum energy capacity by clicking on your suit with the higher capacity cell.</li>
					<li>*Conserve your energy. Without it, you are very vulnerable.</li>
					</ul>
					That is all you will need to know. The rest will come with practice and talent. Good luck!
					<h4>Master /N</h4>
					"}//This has always bothered me but not anymore!
		if(5)
			var/laws
			dat += "<h4><img src=sos_13.png> AI Control:</h4>"
			//var/mob/living/silicon/ai/A = AI
			if(AI)//If an AI exists.
				dat += "Stored AI: <b>[A.name]</b><br>"
				dat += "System integrity: [(A.health+100)/2]%<br>"

				//I personally think this makes things a little more fun. Ninjas can override all but law 0.
				//if (A.laws.zeroth)
				//	laws += "<li>0: [A.laws.zeroth]</li>"

				for(var/index = 1, index <= length(A.laws.ion), index++)
					var/law = A.laws.ion[index]
					if (length(law) > 0)
						var/num = ionnum()
						laws += "<li>[num]. [law]</li>"

				var/number = 1
				for(var/index = 1, index <= length(A.laws.inherent), index++)
					var/law = A.laws.inherent[index]
					if (length(law) > 0)
						laws += "<li>[number]: [law]</li>"
						number++

				for(var/index = 1, index <= length(A.laws.supplied), index++)
					var/law = A.laws.supplied[index]
					if (length(law) > 0)
						laws += "<li>[number]: [law]</li>"
						number++

				dat += "<h4>Laws:</h4><ul>[laws]<li><a href='byond://?src=\ref[src];choice=Override AI Laws'><i>*Override Laws*</i></a></li></ul>"

				if (!flush)
					dat += "<A href='byond://?src=\ref[src];choice=Purge AI'>Purge AI</A><br>"
				else
					dat += "<b>Purge in progress...</b><br>"
				dat += " <A href='byond://?src=\ref[src];choice=Wireless AI'>[A.control_disabled ? "Enable" : "Disable"] Wireless Activity</A>"
		if(6)
			dat += {"
					<h4><img src=sos_6.png> Activate Abilities:</h4>
					<ul>
					<li><a href='byond://?src=\ref[src];choice=Trigger Ability;name=Phase Jaunt;cost= (10E)'><img src=sos_13.png> Phase Jaunt</a></li>
					<li><a href='byond://?src=\ref[src];choice=Trigger Ability;name=Phase Shift;cost= (20E)'><img src=sos_13.png> Phase Shift</a></li>
					<li><a href='byond://?src=\ref[src];choice=Trigger Ability;name=Energy Blade;cost= (5E)'><img src=sos_13.png> Energy Blade</a></li>
					<li><a href='byond://?src=\ref[src];choice=Trigger Ability;name=Energy Star;cost= (5E)'><img src=sos_13.png> Energy Star</a></li>
					<li><a href='byond://?src=\ref[src];choice=Trigger Ability;name=Energy Net;cost= (20E)'><img src=sos_13.png> Energy Net</a></li>
					<li><a href='byond://?src=\ref[src];choice=Trigger Ability;name=EM Burst;cost= (25E)'><img src=sos_13.png> EM Pulse</a></li>
					<li><a href='byond://?src=\ref[src];choice=Trigger Ability;name=Smoke Bomb;cost='><img src=sos_13.png> Smoke Bomb</a></li>
					<li><a href='byond://?src=\ref[src];choice=Trigger Ability;name=Adrenaline Boost;cost='><img src=sos_13.png> Adrenaline Boost</a></li>
					</ul>
					"}
		if(7)
			dat += "<h4><img src=sos_4.png> Research Stored:</h4>"
			if(t_disk)
				dat += "<a href='byond://?src=\ref[src];choice=Eject Disk'>Eject Disk</a><br>"
			dat += "<ul>"
			if(islist(stored_research)) // If there is stored research. Should be but just in case.
				for(var/decl/tech/current_data in stored_research)
					dat += "<li>"
					dat += "[current_data.name]: [current_data.level]"
					if(t_disk)//If there is a disk inserted. We can either write or overwrite.
						dat += " <a href='byond://?src=\ref[src];choice=Copy to Disk;target=\ref[current_data]'><i>*Copy to Disk</i></a><br>"
					dat += "</li>"
			dat += "</ul>"
	dat += "</body></html>"

	//Setting the can>resize etc to 0 remove them from the drag bar but still allows the window to be draggable.
	display_to << browse(dat,"window=spideros;size=400x444;border=1;can_resize=1;can_close=0;can_minimize=0")

//=======//SPIDEROS TOPIC PROC//=======//

/obj/item/clothing/suit/space/space_ninja/Topic(href, href_list)
	..()
	var/mob/living/carbon/human/U = affecting
	var/mob/living/silicon/ai/A = AI
	var/display_to = s_control ? U : A//Who do we want to display certain messages to?

	if(s_control)
		if(!affecting||U.stat||!s_initialized)//Check to make sure the guy is wearing the suit after clicking and it's on.
			to_chat(U, SPAN_WARNING("Your suit must be worn and active to use this function."))
			U << browse(null, "window=spideros")//Closes the window.
			return

		if(k_unlock!=7&&href_list["choice"]!="Return")
			var/u1=text2num(href_list["choice"])
			var/u2=(u1?abs(abs(k_unlock-u1)-2):1)
			k_unlock=(!u2? k_unlock+1:0)
			if(k_unlock==7)
				to_chat(U, "Anonymous Messenger blinks.")
	else
		if(!affecting||A.stat||!s_initialized||A.loc!=src)
			to_chat(A, SPAN_WARNING("This function is not available at this time."))
			A << browse(null, "window=spideros")//Closes the window.
			return

	switch(href_list["choice"])
		if("Close")
			display_to << browse(null, "window=spideros")
			return
		if("Refresh")//Refresh, goes to the end of the proc.
		if("Return")//Return
			if(spideros<=9)
				spideros=0
			else
				spideros = round(spideros/10)//Best way to do this, flooring to nearest integer.

		if("Shock")
			var/damage = min(cell.charge, rand(50,150))//Uses either the current energy left over or between 50 and 150.
			if(damage>1)//So they don't spam it when energy is a factor.
				spark_system.start()//SPARKS THERE SHALL BE SPARKS
				U.electrocute_act(damage, src,0.1,1)//The last argument is a safety for the human proc that checks for gloves.
				if(cell.charge < damage)
					cell.use(cell.charge)
				else
					cell.use(damage)
			else
				to_chat(A, "\red <b>ERROR</b>: \black Not enough energy remaining.")

		if("Message")
			var/obj/item/pda/P = locate(href_list["target"])
			var/t = input(U, "Please enter untraceable message.") as text
			t = copytext(sanitize(t), 1, MAX_MESSAGE_LEN)
			if(!t||U.stat||U.wear_suit!=src||!s_initialized)//Wow, another one of these. Man...
				display_to << browse(null, "window=spideros")
				return
			if(isnull(P)||P.toff)//So it doesn't freak out if the object no-longer exists.
				to_chat(display_to, SPAN_WARNING("Error: unable to deliver message."))
				display_spideros()
				return
			P.tnote += "<i><b>&larr; From [!s_control?(A):"an unknown source"]:</b></i><br>[t]<br>"
			if (!P.silent)
				playsound(P.loc, 'sound/machines/twobeep.ogg', 50, 1)
				for (var/mob/O in hearers(3, P.loc))
					O.show_message("\icon[P] *[P.ttone]*")
			P.cut_overlays()
			P.add_overlay(image('icons/obj/items/devices/pda.dmi', "pda-r"))

		if("Inject")
			if( (href_list["tag"]=="radium"? (reagents.get_reagent_amount("radium"))<=(a_boost*a_transfer) : !reagents.get_reagent_amount(href_list["tag"])) )//Special case for radium. If there are only a_boost*a_transfer radium units left.
				to_chat(display_to, SPAN_WARNING("Error: the suit cannot perform this function. Out of [href_list["name"]]."))
			else
				reagents.reaction(U, 2)
				reagents.trans_id_to(U, href_list["tag"], href_list["tag"]=="nutriment"?5:a_transfer)//Nutriment is a special case since it's very potent. Shouldn't influence actual refill amounts or anything.
				to_chat(display_to, "Injecting...")
				to_chat(U, "You feel a tiny prick and a sudden rush of substance in to your veins.")

		if("Trigger Ability")
			var/ability_name = href_list["name"]+href_list["cost"]//Adds the name and cost to create the full proc name.
			var/proc_arguments//What arguments to later pass to the proc, if any.
			var/list/targets = list() // To later check for.
			var/safety = 0//To later make sure we're triggering the proc when needed.
			switch(href_list["name"])//Special case.
				if("Phase Shift")
					safety = 1
					for(var/turf/T in oview(5,loc))
						targets.Add(T)
				if("Energy Net")
					safety = 1
					for(var/mob/living/carbon/M in oview(5,loc))
						targets.Add(M)
			if(length(targets))//Let's create an argument for the proc if needed.
				proc_arguments = pick(targets)
				safety = 0
			if(!safety)
				to_chat(A, "You trigger [href_list["name"]].")
				to_chat(U, "[href_list["name"]] suddenly triggered!")
				call(src,ability_name)(proc_arguments)
			else
				to_chat(A, "There are no potential [href_list["name"]=="Phase Shift"?"destinations" : "targets"] in view.")

		if("Unlock Kamikaze")
			if(input(U)=="Divine Wind")
				if( !(U.stat||U.wear_suit!=src||!s_initialized) )
					if( !(cell.charge<=1||s_busy) )
						s_busy = 1
						for(var/i, i<4, i++)
							switch(i)
								if(0)
									to_chat(U, "\blue Engaging mode...\n\black<b>CODE NAME</b>: \red <b>KAMIKAZE</b>")
								if(1)
									to_chat(U, "\blue Re-routing power nodes... \nUnlocking limiter...")
								if(2)
									to_chat(U, "\blue Power nodes re-routed. \nLimiter unlocked.")
								if(3)
									grant_kamikaze(U)//Give them verbs and change variables as necessary.
									U.regenerate_icons()//Update their clothing.
									ninjablade()//Summon two energy blades.
									message_admins(SPAN_INFO("[key_name_admin(U)] used KAMIKAZE mode."))//Let the admins know.
									s_busy = 0
									return
							sleep(s_delay)
					else
						to_chat(U, "\red <b>ERROR<b>: \black Unable to initiate mode.")
				else
					U << browse(null, "window=spideros")
					s_busy = 0
					return
			else
				to_chat(U, SPAN_WARNING("ERROR: WRONG PASSWORD!"))
				k_unlock = 0
				spideros = 0
			s_busy = 0

		if("Eject Disk")
			var/turf/T = GET_TURF(src)
			if(!U.get_active_hand())
				U.put_in_hands(t_disk)
				t_disk.add_fingerprint(U)
				t_disk = null
			else
				if(isnotnull(T))
					t_disk.forceMove(T)
					t_disk = null
				else
					to_chat(U, "\red <b>ERROR<b>: \black Could not eject disk.")

		if("Copy to Disk")
			var/decl/tech/current_data = locate(href_list["target"])
			to_chat(U, "[current_data.name] successfully [(!t_disk.stored) ? "copied" : "overwritten"] to disk.")
			t_disk.stored = current_data

		if("Configure pAI")
			pai.attack_self(U)

		if("Eject pAI")
			var/turf/T = GET_TURF(src)
			if(!U.get_active_hand())
				U.put_in_hands(pai)
				pai.add_fingerprint(U)
				pai = null
			else
				if(isnotnull(T))
					pai.forceMove(T)
					pai = null
				else
					to_chat(U, "\red <b>ERROR<b>: \black Could not eject pAI card.")

		if("Override AI Laws")
			var/law_zero = A.laws.zeroth//Remembers law zero, if there is one.
			A.laws = new /datum/ai_laws/ninja_override
			A.set_zeroth_law(law_zero)//Adds back law zero if there was one.
			A.show_laws()
			to_chat(U, SPAN_INFO("Law Override: <b>SUCCESS</b>."))

		if("Purge AI")
			var/confirm = alert("Are you sure you want to purge the AI? This cannot be undone once started.", "Confirm purge", "Yes", "No")
			if(U.stat||U.wear_suit!=src||!s_initialized)
				U << browse(null, "window=spideros")
				return
			if(confirm == "Yes"&&AI)
				if(A.laws.zeroth)//Gives a few seconds to re-upload the AI somewhere before it takes full control.
					s_busy = 1
					for(var/i,i<5,i++)
						if(AI==A)
							switch(i)
								if(0)
									to_chat(A, "\red <b>WARNING</b>: \black purge procedure detected. \nNow hacking host...")
									to_chat(U, "\red <b>WARNING</b>: HACKING AT��TEMP� IN PR0GRESs!")
									spideros = 0
									k_unlock = 0
									U << browse(null, "window=spideros")
								if(1)
									to_chat(A, "Disconnecting neural interface...")
									to_chat(U, SPAN_WARNING("<b>WAR�NING</b>: �R�O0�Gr�--S 2&3%"))
								if(2)
									to_chat(A, "Shutting down external protocol...")
									to_chat(U, SPAN_WARNING("<b>WARNING</b>: P����RֆGr�5S 677^%"))
									cancel_stealth()
								if(3)
									to_chat(A, "Connecting to kernel...")
									to_chat(U, SPAN_WARNING("<b>WARNING</b>: �R�r�R_404"))
									A.control_disabled = FALSE
								if(4)
									to_chat(A, "Connection established and secured. Menu updated.")
									to_chat(U, "\red <b>W�r#nING</b>: #%@!!WȆ|_4�54@ \nUn�B88l3 T� L�-�o-L�CaT2 ##$!�RN�0..%..")
									grant_AI_verbs()
									return
							sleep(s_delay)
						else	break
					s_busy = 0
					to_chat(U, SPAN_INFO("Hacking attempt disconnected. Resuming normal operation."))
				else
					flush = 1
					A.suiciding = 1
					to_chat(A, "Your core files are being purged! This is the end...")
					spawn(0)
						display_spideros()//To refresh the screen and let this finish.
					while (A.stat != DEAD)
						A.adjustOxyLoss(2)
						A.updatehealth()
						sleep(10)
					killai()
					to_chat(U, "Artificial Intelligence was terminated. Rebooting...")
					flush = 0

		if("Wireless AI")
			A.control_disabled = !A.control_disabled
			to_chat(A, "AI wireless has been [A.control_disabled ? "disabled" : "enabled"].")
		else//If it's not a defined function, it's a menu.
			spideros=text2num(href_list["choice"])

	display_spideros()//Refreshes the screen by calling it again (which replaces current screen with new screen).
	return

//=======//SPECIAL AI FUNCTIONS//=======//

/obj/item/clothing/suit/space/space_ninja/proc/ai_holo(turf/T in oview(3, affecting))//To have an internal AI display a hologram to the AI and ninja only.
	set name = "Display Hologram"
	set desc = "Channel a holographic image directly to the user's field of vision. Others will not see it."
	set category = null
	set src = usr.loc

	if(s_initialized && affecting && affecting.client && isturf(affecting.loc))//If the host exists and they are playing, and their location is a turf.
		if(!hologram)//If there is not already a hologram.
			hologram = new(T)//Spawn a blank effect at the location.
			hologram.invisibility = INVISIBILITY_MAXIMUM//So that it doesn't show up, ever. This also means one could attach a number of images to a single obj and display them differently to differnet people.
			hologram.anchored = TRUE//So it cannot be dragged by space wind and the like.
			hologram.set_dir(get_dir(T, affecting.loc))
			var/image/I = image(AI.holo_icon, hologram)//Attach an image to object.
			hologram.i_attached = I//To attach the image in order to later reference.
			AI << I
			affecting << I
			to_chat(affecting, "<i>An image flicks to life nearby. It appears visible to you only.</i>")

			verbs += /obj/item/clothing/suit/space/space_ninja/proc/ai_holo_clear

			ai_holo_process()//Move to initialize
		else
			to_chat(AI, "\red ERROR: \black Image feed in progress.")
	else
		to_chat(AI, "\red ERROR: \black Unable to project image.")
	return

/obj/item/clothing/suit/space/space_ninja/proc/ai_holo_process()
	set background = BACKGROUND_ENABLED

	spawn while(hologram&&s_initialized&&AI)//Suit on and there is an AI present.
		if(!s_initialized||get_dist(affecting,hologram.loc)>3)//Once suit is de-initialized or hologram reaches out of bounds.
			qdel(hologram.i_attached)
			qdel(hologram)

			verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ai_holo_clear
			return
		sleep(10)//Checks every second.

/obj/item/clothing/suit/space/space_ninja/proc/ai_instruction()//Let's the AI know what they can do.
	set name = "Instructions"
	set desc = "Displays a list of helpful information."
	set category = "AI Ninja Equip"
	set src = usr.loc

	to_chat(AI, "The menu you are seeing will contain other commands if they become available.\nRight click a nearby turf to display an AI Hologram. It will only be visible to you and your host. You can move it freely using normal movement keys--it will disappear if placed too far away.")

/obj/item/clothing/suit/space/space_ninja/proc/ai_holo_clear()
	set name = "Clear Hologram"
	set desc = "Stops projecting the current holographic image."
	set category = "AI Ninja Equip"
	set src = usr.loc

	qdel(hologram.i_attached)
	qdel(hologram)

	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ai_holo_clear
	return

/obj/item/clothing/suit/space/space_ninja/proc/ai_hack_ninja()
	set name = "Hack SpiderOS"
	set desc = "Hack directly into the Black Widow(tm) neuro-interface."
	set category = "AI Ninja Equip"
	set src = usr.loc

	display_spideros()
	return

/obj/item/clothing/suit/space/space_ninja/proc/ai_return_control()
	set name = "Relinquish Control"
	set desc = "Return control to the user."
	set category = "AI Ninja Equip"
	set src = usr.loc

	AI << browse(null, "window=spideros")//Close window
	to_chat(AI, "You have seized your hacking attempt. [affecting.real_name] has regained control.")
	to_chat(affecting, "<b>UPDATE</b>: [AI.real_name] has ceased hacking attempt. All systems clear.")

	remove_AI_verbs()
	return

//=======//GENERAL SUIT PROCS//=======//

/obj/item/clothing/suit/space/space_ninja/attackby(obj/item/I, mob/U)
	if(U==affecting)//Safety, in case you try doing this without wearing the suit/being the person with the suit.
		if(istype(I, /obj/item/aicard))//If it's an AI card.
			if(s_control)
				I:transfer_ai("NINJASUIT","AICARD",src,U)
			else
				to_chat(U, "\red <b>ERROR</b>: \black Remote access channel disabled.")
			return//Return individually so that ..() can run properly at the end of the proc.
		else if(istype(I, /obj/item/paicard) && !pai)//If it's a pai card.
			U:drop_item()
			I.forceMove(src)
			pai = I
			to_chat(U, SPAN_INFO("You slot \the [I] into \the [src]."))
			updateUsrDialog()
			return
		else if(istype(I, /obj/item/reagent_holder/glass))//If it's a glass beaker.
			var/total_reagent_transfer//Keep track of this stuff.
			for(var/reagent_id in reagent_list)
				var/datum/reagent/R = I.reagents.has_reagent(reagent_id)//Mostly to pull up the name of the reagent after calculating. Also easier to use than writing long proc paths.
				if(R&&reagents.get_reagent_amount(reagent_id)<r_maxamount+(reagent_id == "radium"?(a_boost*a_transfer):0)&&R.volume>=a_transfer)//Radium is always special.
					//Here we determine how much reagent will actually transfer if there is enough to transfer or there is a need of transfer. Minimum of max amount available (using a_transfer) or amount needed.
					var/amount_to_transfer = min( (r_maxamount+(reagent_id == "radium"?(a_boost*a_transfer):0)-reagents.get_reagent_amount(reagent_id)) ,(round(R.volume/a_transfer))*a_transfer)//In the end here, we round the amount available, then multiply it again.
					R.volume -= amount_to_transfer//Remove from reagent volume. Don't want to delete the reagent now since we need to perserve the name.
					reagents.add_reagent(reagent_id, amount_to_transfer)//Add to suit. Reactions are not important.
					total_reagent_transfer += amount_to_transfer//Add to total reagent trans.
					to_chat(U, "Added [amount_to_transfer] units of [R.name].") // Reports on the specific reagent added.
					I.reagents.update_total()//Now we manually update the total to make sure everything is properly shoved under the rug.

			to_chat(U, "Replenished a total of [total_reagent_transfer ? total_reagent_transfer : "zero"] chemical units.") // Let the player know how much total volume was added.
			return
		else if(istype(I, /obj/item/cell))
			if(I:maxcharge>cell.maxcharge&&n_gloves&&n_gloves.candrain)
				to_chat(U, "\blue Higher maximum capacity detected.\nUpgrading...")
				if (n_gloves&&n_gloves.candrain&&do_after(U,s_delay))
					U.drop_item()
					I.forceMove(src)
					I:charge = min(I:charge+cell.charge, I:maxcharge)
					var/obj/item/cell/old_cell = cell
					old_cell.charge = 0
					U.put_in_hands(old_cell)
					old_cell.add_fingerprint(U)
					old_cell.corrupt()
					old_cell.updateicon()
					cell = I
					to_chat(U, SPAN_INFO("Upgrade complete. Maximum capacity: <b>[round(cell.maxcharge / 100)]</b>%"))
				else
					to_chat(U, SPAN_WARNING("Procedure interrupted. Protocol terminated."))
			return
		else if(istype(I, /obj/item/disk/tech))//If it's a data disk, we want to copy the research on to the suit.
			var/obj/item/disk/tech/TD = I
			if(TD.stored)//If it has something on it.
				to_chat(U, "Research information detected, processing...")
				if(do_after(U,s_delay))
					for(var/decl/tech/current_data in stored_research)
						if(current_data.type == TD.stored.type)
							if(current_data.level<TD.stored.level)
								current_data.level=TD.stored.level
							break
					TD.stored = null
					to_chat(U, SPAN_INFO("Data analysed and updated. Disk erased."))
				else
					to_chat(U, "\red <b>ERROR</b>: \black Procedure interrupted. Process terminated.")
			else
				I.forceMove(src)
				t_disk = I
				to_chat(U, SPAN_INFO("You slot \the [I] into \the [src]."))
			return
	..()

/obj/item/clothing/suit/space/space_ninja/proc/toggle_stealth()
	var/mob/living/carbon/human/U = affecting
	if(s_active)
		cancel_stealth()
	else
		anim(U.loc,U,'icons/mob/mob.dmi',,"cloak",,U.dir)
		s_active=!s_active
		icon_state = U.gender==FEMALE ? "s-ninjasf" : "s-ninjas"
		U.regenerate_icons()	//update their icons
		to_chat(U, SPAN_INFO("You are now invisible to normal detection."))
		for(var/mob/O in oviewers(U))
			O.show_message("[U.name] vanishes into thin air!",1)
		U.invisibility = INVISIBILITY_OBSERVER
	return

/obj/item/clothing/suit/space/space_ninja/proc/cancel_stealth()
	var/mob/living/carbon/human/U = affecting
	if(s_active)
		anim(U.loc,U,'icons/mob/mob.dmi',,"uncloak",,U.dir)
		s_active=!s_active
		to_chat(U, SPAN_INFO("You are now visible."))
		U.invisibility = 0
		for(var/mob/O in oviewers(U))
			O.show_message("[U.name] appears from thin air!",1)
		icon_state = U.gender==FEMALE ? "s-ninjanf" : "s-ninjan"
		U.regenerate_icons()	//update their icons
		return 1
	return 0

/obj/item/clothing/suit/space/space_ninja/proc/blade_check(mob/living/carbon/U, X = 1)//Default to checking for blade energy.
	switch(X)
		if(1)
			if(istype(U.get_active_hand(), /obj/item/melee/energy/blade))
				if(cell.charge<=0)//If no charge left.
					U.drop_item()//Blade is dropped from active hand (and deleted).
				else	return 1
			else if(istype(U.get_inactive_hand(), /obj/item/melee/energy/blade))
				if(cell.charge<=0)
					U.swap_hand()//swap hand
					U.drop_item()//drop blade
				else	return 1
		if(2)
			if(istype(U.get_active_hand(), /obj/item/melee/energy/blade))
				U.drop_item()
			if(istype(U.get_inactive_hand(), /obj/item/melee/energy/blade))
				U.swap_hand()
				U.drop_item()
	return 0

/obj/item/clothing/suit/space/space_ninja/examine()
	set src in view()
	..()
	if(s_initialized)
		var/mob/living/carbon/human/U = affecting
		if(s_control)
			to_chat(U, "All systems operational. Current energy capacity: <B>[cell.charge]</B>.")
			if(!kamikaze)
				to_chat(U, "The CLOAK-tech device is <B>[s_active ? "active" : "inactive"]</B>.")
			else
				to_chat(U, SPAN_WARNING("KAMIKAZE MODE ENGAGED!"))
			to_chat(U, "There are <B>[s_bombs]</B> smoke bombs remaining.")
			to_chat(U, "There are <B>[a_boost]</B> adrenaline boosters remaining.")
		else
			to_chat(U, "�rr�R �a��a�� No-�-� f��N� 3RR�r")

/*
===================================================================================
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<SPACE NINJA GLOVES>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
===================================================================================
*/

//=======//ENERGY DRAIN PROCS//=======//

/obj/item/clothing/gloves/space_ninja/proc/drain(target_type as text, target, obj/suit)
//Var Initialize
	var/obj/item/clothing/suit/space/space_ninja/S = suit
	var/mob/living/carbon/human/U = S.affecting
	var/obj/item/clothing/gloves/space_ninja/G = S.n_gloves

	var/drain = 0//To drain from battery.
	var/maxcapacity = 0//Safety check for full battery.
	var/totaldrain = 0//Total energy drained.

	G.draining = 1

	if(target_type!="RESEARCH")//I lumped research downloading here for ease of use.
		to_chat(U, SPAN_INFO("Now charging battery..."))

	switch(target_type)

		if("APC")
			var/obj/machinery/power/apc/A = target
			if(A.cell&&A.cell.charge)
				while(G.candrain&&A.cell.charge>0&&!maxcapacity)
					drain = rand(G.mindrain,G.maxdrain)
					if(A.cell.charge<drain)
						drain = A.cell.charge
					if(S.cell.charge+drain>S.cell.maxcharge)
						drain = S.cell.maxcharge-S.cell.charge
						maxcapacity = 1//Reached maximum battery capacity.
					if (do_after(U,10))
						make_sparks(5, FALSE, A.loc)
						playsound(A.loc, "sparks", 50, 1)
						A.cell.charge-=drain
						S.cell.charge+=drain
						totaldrain+=drain
					else	break
				to_chat(U, SPAN_INFO("Gained <B>[totaldrain]</B> energy from the APC."))
				if(!A.emagged)
					flick("apc-spark", src)
					A.emagged = 1
					A.locked = 0
					A.update_icon()
			else
				to_chat(U, SPAN_WARNING("This APC has run dry of power. You must find another source."))

		if("SMES")
			var/obj/machinery/power/smes/A = target
			if(A.charge)
				while(G.candrain&&A.charge>0&&!maxcapacity)
					drain = rand(G.mindrain,G.maxdrain)
					if(A.charge<drain)
						drain = A.charge
					if(S.cell.charge+drain>S.cell.maxcharge)
						drain = S.cell.maxcharge-S.cell.charge
						maxcapacity = 1
					if (do_after(U,10))
						make_sparks(5, FALSE, A.loc)
						playsound(A.loc, "sparks", 50, 1)
						A.charge-=drain
						S.cell.charge+=drain
						totaldrain+=drain
					else	break
				to_chat(U, SPAN_INFO("Gained <B>[totaldrain]</B> energy from the SMES cell."))
			else
				to_chat(U, SPAN_WARNING("This SMES cell has run dry of power. You must find another source."))

		if("CELL")
			var/obj/item/cell/A = target
			if(A.charge)
				if (G.candrain&&do_after(U,30))
					to_chat(U, SPAN_INFO("Gained <B>[A.charge]</B> energy from the cell."))
					if(S.cell.charge+A.charge>S.cell.maxcharge)
						S.cell.charge=S.cell.maxcharge
					else
						S.cell.charge+=A.charge
					A.charge = 0
					G.draining = 0
					A.corrupt()
					A.updateicon()
				else
					to_chat(U, SPAN_WARNING("Procedure interrupted. Protocol terminated."))
			else
				to_chat(U, SPAN_WARNING("This cell is empty and of no use."))

		if("MACHINERY")//Can be applied to generically to all powered machinery. I'm leaving this alone for now.
			var/obj/machinery/A = target
			if(A.powered())//If powered.
				var/obj/machinery/power/apc/B = A.loc.loc:get_apc()//Object.turf.area find APC
				if(B)//If APC exists. Might not if the area is unpowered like CentCom.
					var/datum/powernet/PN = B.terminal.powernet
					while(G.candrain&&!maxcapacity&&isnotnull(A))//And start a proc similar to drain from wire.
						drain = rand(G.mindrain,G.maxdrain)
						var/drained = 0
						if(PN&&do_after(U,10))
							drained = min(drain, PN.avail)
							PN.draw_power(drained)
							if(drained < drain)//if no power on net, drain apcs
								for(var/obj/machinery/power/terminal/T in PN.nodes)
									if(istype(T.master, /obj/machinery/power/apc))
										var/obj/machinery/power/apc/AP = T.master
										if(AP.operating && AP.cell && AP.cell.charge>0)
											AP.cell.charge = max(0, AP.cell.charge - 5)
											drained += 5
						else	break
						S.cell.charge += drained
						if(S.cell.charge>S.cell.maxcharge)
							totaldrain += (drained-(S.cell.charge-S.cell.maxcharge))
							S.cell.charge = S.cell.maxcharge
							maxcapacity = 1
						else
							totaldrain += drained
						make_sparks(5, FALSE, A.loc)
						if(drained==0)	break
					to_chat(U, SPAN_INFO("Gained <B>[totaldrain]</B> energy from the power network."))
				else
					to_chat(U, SPAN_WARNING("Power network could not be found. Aborting."))
			else
				to_chat(U, SPAN_WARNING("This recharger is not providing energy. You must find another source."))

		if("RESEARCH")
			var/obj/machinery/A = target
			to_chat(U, SPAN_INFO("Hacking \the [A]..."))
			spawn(0)
				var/turf/location = GET_TURF(U)
				for(var/mob/living/silicon/ai/ai in GLOBL.player_list)
					to_chat(ai, SPAN_DANGER("Network Alert: Hacking attempt detected[location ? " in [location]" : ". Unable to pinpoint location"]."))
			// These colons really need to be removed but I honestly don't feel like entirely rewriting this section right now.
			if(A:files && istype(A:files, /datum/research))
				var/datum/research/files = A:files
				if(length(files.known_tech))
					for(var/decl/tech/current_data in S.stored_research)
						to_chat(U, SPAN_INFO("Checking \the [current_data] database."))
						if(do_after(U, S.s_delay) && G.candrain && isnotnull(A))
							for_no_type_check(var/decl/tech/analyzing_data, files.known_tech)
								if(current_data.type == analyzing_data.type)
									if(analyzing_data.level > current_data.level)
										to_chat(U, "\blue Database: \black <b>UPDATED</b>.")
										current_data.level = analyzing_data.level
									break //Move on to next.
						else
							break //Otherwise, quit processing.
			to_chat(U, SPAN_INFO("Data analysed. Process finished."))

		if("WIRE")
			var/obj/structure/cable/A = target
			var/datum/powernet/PN = A.get_powernet()
			while(G.candrain&&!maxcapacity&&isnotnull(A))
				drain = (round((rand(G.mindrain,G.maxdrain))/2))
				var/drained = 0
				if(PN&&do_after(U,10))
					drained = min(drain, PN.avail)
					PN.draw_power(drained)
					if(drained < drain)//if no power on net, drain apcs
						for(var/obj/machinery/power/terminal/T in PN.nodes)
							if(istype(T.master, /obj/machinery/power/apc))
								var/obj/machinery/power/apc/AP = T.master
								if(AP.operating && AP.cell && AP.cell.charge>0)
									AP.cell.charge = max(0, AP.cell.charge - 5)
									drained += 5
				else	break
				S.cell.charge += drained
				if(S.cell.charge>S.cell.maxcharge)
					totaldrain += (drained-(S.cell.charge-S.cell.maxcharge))
					S.cell.charge = S.cell.maxcharge
					maxcapacity = 1
				else
					totaldrain += drained
				S.spark_system.start()
				if(drained==0)	break
			to_chat(U, SPAN_INFO("Gained <B>[totaldrain]</B> energy from the power network."))

		if("MECHA")
			var/obj/mecha/A = target
			A.occupant_message("\red Warning: Unauthorized access through sub-route 4, block H, detected.")
			if(A.get_charge())
				while(G.candrain&&A.cell.charge>0&&!maxcapacity)
					drain = rand(G.mindrain,G.maxdrain)
					if(A.cell.charge<drain)
						drain = A.cell.charge
					if(S.cell.charge+drain>S.cell.maxcharge)
						drain = S.cell.maxcharge-S.cell.charge
						maxcapacity = 1
					if (do_after(U,10))
						A.spark_system.start()
						playsound(A.loc, "sparks", 50, 1)
						A.cell.use(drain)
						S.cell.charge+=drain
						totaldrain+=drain
					else	break
				to_chat(U, SPAN_INFO("Gained <B>[totaldrain]</B> energy from [src]."))
			else
				to_chat(U, SPAN_WARNING("The exosuit's battery has run dry. You must find another source of power."))

		if("CYBORG")
			var/mob/living/silicon/robot/A = target
			to_chat(A, SPAN_WARNING("Warning: Unauthorized access through sub-route 12, block C, detected."))
			G.draining = 1
			if(A.cell&&A.cell.charge)
				while(G.candrain&&A.cell.charge>0&&!maxcapacity)
					drain = rand(G.mindrain,G.maxdrain)
					if(A.cell.charge<drain)
						drain = A.cell.charge
					if(S.cell.charge+drain>S.cell.maxcharge)
						drain = S.cell.maxcharge-S.cell.charge
						maxcapacity = 1
					if (do_after(U,10))
						A.spark_system.start()
						playsound(A.loc, "sparks", 50, 1)
						A.cell.charge-=drain
						S.cell.charge+=drain
						totaldrain+=drain
					else	break
				to_chat(U, SPAN_INFO("Gained <B>[totaldrain]</B> energy from [A]."))
			else
				to_chat(U, SPAN_WARNING("Their battery has run dry of power. You must find another source."))

		else//Else nothing :<

	G.draining = 0

	return

//=======//GENERAL PROCS//=======//

/obj/item/clothing/gloves/space_ninja/proc/toggled()
	set name = "Toggle Interaction"
	set desc = "Toggles special interaction on or off."
	set category = "Ninja Equip"

	var/mob/living/carbon/human/U = loc
	to_chat(U, "You <b>[candrain ? "disable" : "enable"]</b> special interaction.")
	candrain=!candrain

/obj/item/clothing/gloves/space_ninja/examine()
	set src in view()
	..()
	if(!can_remove)
		var/mob/living/carbon/human/U = loc
		to_chat(U, "The energy drain mechanism is: <B>[candrain ? "active" : "inactive"]</B>.")

/*
===================================================================================
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<SPACE NINJA HUD>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
===================================================================================
*/

/obj/item/clothing/glasses/hud/ninja
	name = "Ninja Scanner HUD"
	desc = "Assesses targets"
	body_parts_covered = 0

/obj/item/clothing/glasses/hud/ninja/process_hud(mob/M)
	var/list/target_list = list()
	for(var/mob/living/target in oview(M))
		if(target.mind && (target.mind.special_role || issilicon(target))) //They need to have a mind.
			target_list += target
	if(length(target_list))
		assess_targets(target_list, M)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(!C.druggy)
			M.see_invisible = SEE_INVISIBLE_LIVING

/obj/item/clothing/glasses/hud/ninja/proc/assess_targets(list/target_list, mob/living/carbon/U)
	var/icon/tempHud = 'icons/hud/hud.dmi'
	for(var/mob/living/target in target_list)
		if(iscarbon(target))
			switch(target.mind.special_role)
				if("traitor")
					U.client.images += image(tempHud,target,"hudtraitor")
				if("Revolutionary","Head Revolutionary")
					U.client.images += image(tempHud,target,"hudrevolutionary")
				if("Cultist")
					U.client.images += image(tempHud,target,"hudcultist")
				if("Changeling")
					U.client.images += image(tempHud,target,"hudchangeling")
				if("Wizard","Fake Wizard")
					U.client.images += image(tempHud,target,"hudwizard")
				if("Hunter","Sentinel","Drone","Queen")
					U.client.images += image(tempHud,target,"hudalien")
				if("Syndicate")
					U.client.images += image(tempHud,target,"hudoperative")
				if("Death Commando")
					U.client.images += image(tempHud,target,"huddeathsquad")
				if("Ninja")
					U.client.images += image(tempHud,target,"hudninja")
				else//If we don't know what role they have but they have one.
					U.client.images += image(tempHud,target,"hudunknown1")
		else//If the silicon mob has no law datum, no inherent laws, or a law zero, add them to the hud.
			var/mob/living/silicon/silicon_target = target
			if(!silicon_target.laws || (silicon_target.laws && (silicon_target.laws.zeroth || !length(silicon_target.laws.inherent))))
				if(isrobot(silicon_target))//Different icons for robutts and AI.
					U.client.images += image(tempHud,silicon_target,"hudmalborg")
				else
					U.client.images += image(tempHud,silicon_target,"hudmalai")
	return 1

/*
===================================================================================
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<SPACE NINJA MASK>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
===================================================================================
*/

/datum/ninja_vision
	var/mode
	var/obj/item/clothing/glasses/glasses

/datum/ninja_vision/scouter
	mode = "Scouter"
	glasses = new /obj/item/clothing/glasses/hud/ninja()

/datum/ninja_vision/nvg
	mode = "Night Vision"
	glasses = new /obj/item/clothing/glasses/night()

/datum/ninja_vision/thermal
	mode = "Thermal Scanner"
	glasses = new /obj/item/clothing/glasses/thermal()

/datum/ninja_vision/meson
	mode = "Meson Scanner"
	glasses = new /obj/item/clothing/glasses/meson()

/obj/item/clothing/mask/gas/voice/space_ninja
	var/datum/ninja_vision/ninja_vision
	var/list/datum/ninja_vision/ninja_visions

/obj/item/clothing/mask/gas/voice/space_ninja/New()
	. = ..()
	ninja_visions = list(new /datum/ninja_vision/scouter(), new /datum/ninja_vision/nvg(), new /datum/ninja_vision/thermal(), new /datum/ninja_vision/meson())
	ninja_vision = ninja_visions[1]
	verbs.Add(/obj/item/clothing/mask/gas/voice/space_ninja/proc/togglev)
	verbs.Add(/obj/item/clothing/mask/gas/voice/space_ninja/proc/switchm)

/obj/item/clothing/mask/gas/voice/space_ninja/proc/togglev()
	set name = "Toggle Voice"
	set desc = "Toggles the voice synthesizer on or off."
	set category = "Ninja Equip"

	var/mob/U = loc//Can't toggle voice when you're not wearing the mask.
	var/vchange = (alert("Would you like to synthesize a new name or turn off the voice synthesizer?",,"New Name","Turn Off"))
	if(vchange=="New Name")
		var/chance = rand(1,100)
		switch(chance)
			if(1 to 50)//High chance of a regular name.
				voice = "[rand(0, 1) == 1 ? pick(GLOBL.first_names_female) : pick(GLOBL.first_names_male)] [pick(GLOBL.last_names)]"
			if(51 to 80)//Smaller chance of a clown name.
				voice = "[pick(GLOBL.clown_names)]"
			if(81 to 90)//Small chance of a wizard name.
				voice = "[pick(GLOBL.wizard_first)] [pick(GLOBL.wizard_second)]"
			if(91 to 100)//Small chance of an existing crew name.
				var/list/names = list()
				for(var/mob/living/carbon/human/M in GLOBL.player_list)
					if(M==U||!M.client||!M.real_name)	continue
					names.Add(M.real_name)
				voice = !length(names) ? "Cuban Pete" : pick(names)
		to_chat(U, "You are now mimicking <B>[voice]</B>.")
	else
		to_chat(U, "The voice synthesizer is [voice != "Unknown" ? "now" : "already"] deactivated.")
		voice = "Unknown"
	return

/obj/item/clothing/mask/gas/voice/space_ninja/proc/switchm()
	set name = "Switch Mode"
	set desc = "Switches between Night Vision, Meson, or Thermal vision modes."
	set category = "Ninja Equip"

	var/index = ninja_visions.Find(ninja_vision) + 1
	if(index > length(ninja_visions))
		index = 1
	ninja_vision = ninja_visions[index]
	var/mob/U = loc
	to_chat(U, "Switching mode to <B>[ninja_vision.mode]</B>.")

/obj/item/clothing/mask/gas/voice/space_ninja/examine()
	set src in view()
	..()

	to_chat(usr, "<B>[ninja_vision.mode]</B> is active.")//Leaving usr here since it may be on the floor or on a person.
	to_chat(usr, "Voice mimicking algorithm is set <B>[!vchange ? "inactive" : "active"]</B>.")

/*
===================================================================================
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<SPACE NINJA NET>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
===================================================================================
*/

/*
It will teleport people to a holding facility after 30 seconds. (Check the process() proc to change where teleport goes)
It is possible to destroy the net by the occupant or someone else.
*/

/obj/effect/energy_net
	name = "energy net"
	desc = "It's a net made of green energy."
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"

	density = TRUE//Can't pass through.
	opacity = FALSE//Can see through.
	mouse_opacity = TRUE//So you can hit it with stuff.
	anchored = TRUE//Can't drag/grab the trapped mob.

	var/health = 25//How much health it has.
	var/mob/living/affecting = null//Who it is currently affecting, if anyone.
	var/mob/living/master = null//Who shot web. Will let this person know if the net was successful or failed.

/obj/effect/energy_net/proc/healthcheck()
	if(health <= 0)
		density = FALSE
		if(affecting)
			var/mob/living/carbon/M = affecting
			M.anchored = FALSE
			visible_message(
				"[M.name] was recovered from the energy net!",
				"You hear a grunt."
			)
			if(isnotnull(master))//As long as they still exist.
				to_chat(master, "\red <b>ERROR</b>: \black unable to initiate transport protocol. Procedure terminated.")
		qdel(src)
	return

/obj/effect/energy_net/process(mob/living/carbon/M)
	var/check = 60//30 seconds before teleportation. Could be extended I guess. - Extended to one minute
	var/mob_name = affecting.name//Since they will report as null if terminated before teleport.
	//The person can still try and attack the net when inside.
	while(isnotnull(M)&&isnotnull(src)&&check>0)//While M and net exist, and 60 seconds have not passed.
		check--
		sleep(10)

	if(isnull(M)||M.loc!=loc)//If mob is gone or not at the location.
		if(isnotnull(master))//As long as they still exist.
			to_chat(master, "\red <b>ERROR</b>: \black unable to locate \the [mob_name]. Procedure terminated.")
		qdel(src)//Get rid of the net.
		return

	if(isnotnull(src))//As long as both net and person exist.
		//No need to check for countdown here since while() broke, it's implicit that it finished.

		density = FALSE//Make the net pass-through.
		invisibility = INVISIBILITY_MAXIMUM//Make the net invisible so all the animations can play out.
		health = INFINITY//Make the net invincible so that an explosion/something else won't kill it while, spawn() is running.
		for(var/obj/item/W in M)
			if(ishuman(M))
				if(W==M:wear_uniform)	continue//So all they're left with are shoes and uniform.
				if(W==M:shoes)	continue
			M.drop_from_inventory(W)

		spawn(0)
			playsound(M.loc, 'sound/effects/sparks/sparks4.ogg', 50, 1)
			anim(M.loc,M,'icons/mob/mob.dmi',,"phaseout",,M.dir)

		M.forceMove(pick(GLOBL.holdingfacility)) // Throw mob in to the holding facility.
		to_chat(M, SPAN_WARNING("You appear in a strange place!"))

		spawn(0)
			make_sparks(5, FALSE, M.loc)
			playsound(M.loc, 'sound/effects/phasein.ogg', 25, 1)
			playsound(M.loc, 'sound/effects/sparks/sparks2.ogg', 50, 1)
			anim(M.loc,M,'icons/mob/mob.dmi',,"phasein",,M.dir)
			qdel(src)//Wait for everything to finish, delete the net. Else it will stop everything once net is deleted, including the spawn(0).

		visible_message(
			"[M] vanishes!",
			"You hear sparks flying!"
		)

		if(isnotnull(master))//As long as they still exist.
			to_chat(master, "\blue <b>SUCCESS</b>: \black transport procedure of \the [affecting] complete.")

		M.captured = 0 //Important.
		M.anchored = initial(M.anchored) //Changes the mob's anchored status to the original one; this is not handled by the can_move proc.

	else//And they are free.
		to_chat(M, SPAN_INFO("You are free of the net!"))
	return

/obj/effect/energy_net/bullet_act(obj/item/projectile/bullet)
	if(bullet.damage_type == BRUTE || bullet.damage_type == BURN)
		health -= bullet.damage
		healthcheck()
	return 0

/obj/effect/energy_net/ex_act(severity)
	switch(severity)
		if(1.0)
			health-=50
		if(2.0)
			health-=50
		if(3.0)
			health-=prob(50)?50:25
	healthcheck()
	return

/obj/effect/energy_net/blob_act()
	health-=50
	healthcheck()
	return

/obj/effect/energy_net/meteorhit()
	health-=50
	healthcheck()
	return

/obj/effect/energy_net/hitby(atom/movable/AM)
	..()
	visible_message(SPAN_DANGER("[src] was hit by [AM]."))
	var/tforce = 0
	if(ismob(AM))
		tforce = 10
	else
		tforce = AM:throwforce
	playsound(src, 'sound/weapons/melee/slash.ogg', 80, 1)
	health = max(0, health - tforce)
	healthcheck()
	..()
	return

/obj/effect/energy_net/attack_hand()
	if(MUTATION_HULK in usr.mutations)
		usr.visible_message(
			SPAN_WARNING("[usr] rips the energy net apart!"),
			SPAN_INFO("You easily destroy the energy net.")
		)
		health -= 50
	else if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		if(H.species.can_shred(H))
			H.visible_message(
				SPAN_WARNING("[H] claws at the energy net!"),
				SPAN_ALIUM("You claw at the energy net.")
			)
			playsound(src, 'sound/weapons/melee/slash.ogg', 80, 1)
			health -= rand(10, 20)
			if(health <= 0)
				H.visible_message(
					SPAN_WARNING("[H] slices the energy net apart!"),
					SPAN_ALIUM("You slice the energy net to pieces.")
				)
	healthcheck()
	return

/obj/effect/energy_net/attack_paw()
	return attack_hand()

/obj/effect/energy_net/attackby(obj/item/W, mob/user)
	var/aforce = W.force
	health = max(0, health - aforce)
	healthcheck()
	return TRUE