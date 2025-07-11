//STRIKE TEAMS

var/const/commandos_possible = 6 //if more Commandos are needed in the future
GLOBAL_GLOBL_INIT(sent_strike_team, 0)

/client/proc/strike_team()
	if(!global.PCticker)
		usr << "<font color='red'>The game hasn't started yet!</font>"
		return
	if(world.time < 6000)
		usr << "<font color='red'>There are [(6000-world.time)/10] seconds remaining before it may be called.</font>"
		return
	if(GLOBL.sent_strike_team)
		usr << "<font color='red'>CentCom is already sending a team.</font>"
		return
	if(alert("Do you want to send in the CentCom death squad? Once enabled, this is irreversible.",,"Yes","No")!="Yes")
		return
	alert("This 'mode' will go on until everyone is dead or the station is destroyed. You may also admin-call the evac shuttle when appropriate. Spawned commandos have internals cameras which are viewable through a monitor inside the Spec. Ops. Office. Assigning the team's detailed task is recommended from there. While you will be able to manually pick the candidates from active ghosts, their assignment in the squad will be random.")

	var/input = null
	while(!input)
		input = copytext(sanitize(input(src, "Please specify which mission the death commando squad shall undertake.", "Specify Mission", "")),1,MAX_MESSAGE_LEN)
		if(!input)
			if(alert("Error, no mission set. Do you want to exit the setup process?",,"Yes","No")=="Yes")
				return

	if(GLOBL.sent_strike_team)
		usr << "Looks like someone beat you to it."
		return

	GLOBL.sent_strike_team = 1

	if(global.PCemergency.can_recall() && global.PCemergency.online())
		global.PCemergency.recall()

	var/commando_number = commandos_possible //for selecting a leader
	var/leader_selected = 0 //when the leader is chosen. The last person spawned.

//Code for spawning a nuke auth code.
	var/nuke_code
	var/temp_code
	FOR_MACHINES_TYPED(bomb, /obj/machinery/nuclearbomb)
		temp_code = text2num(bomb.r_code)
		if(temp_code)//if it's actually a number. It won't convert any non-numericals.
			nuke_code = bomb.r_code
			break

//Generates a list of commandos from active ghosts. Then the user picks which characters to respawn as the commandos.
	var/list/candidates = list()	//candidates for being a commando out of all the active ghosts in world.
	var/list/commandos = list()			//actual commando ghosts as picked by the user.
	for(var/mob/dead/ghost/G	 in GLOBL.player_list)
		if(!G.client.holder && !G.client.is_afk())	//Whoever called/has the proc won't be added to the list.
			if(!(G.mind && G.mind.current && G.mind.current.stat != DEAD))
				candidates += G.key
	for(var/i = commandos_possible, i > 0 && length(candidates), i--) //Decrease with every commando selected.
		var/candidate = input("Pick characters to spawn as the commandos. This will go on until there either no more ghosts to pick from or the slots are full.", "Active Players") as null|anything in candidates	//It will auto-pick a person when there is only one candidate.
		candidates -= candidate		//Subtract from candidates.
		commandos += candidate//Add their ghost to commandos.

//Spawns commandos and equips them.
	for_no_type_check(var/obj/effect/landmark/L, GLOBL.landmark_list)
		if(commando_number<=0)	break
		if (L.name == "Commando")
			leader_selected = commando_number == 1?1:0

			var/mob/living/carbon/human/new_commando = create_death_commando(L, leader_selected)

			if(length(commandos))
				new_commando.key = pick(commandos)
				commandos -= new_commando.key
				new_commando.internal = new_commando.suit_store
				new_commando.internals.icon_state = "internal1"

			//So they don't forget their code or mission.
			if(nuke_code)
				new_commando.mind.store_memory("<B>Nuke Code:</B> \red [nuke_code].")
			new_commando.mind.store_memory("<B>Mission:</B> \red [input].")

			new_commando << "\blue You are a Special Ops. [!leader_selected?"commando":"<B>LEADER</B>"] in the service of Central Command. Check the table ahead for detailed instructions.\nYour current mission is: \red<B>[input]</B>"

			commando_number--

//Spawns the rest of the commando gear.
	for_no_type_check(var/obj/effect/landmark/L, GLOBL.landmark_list)
		if (L.name == "Commando_Manual")
			//new /obj/item/gun/energy/pulse_rifle(L.loc)
			var/obj/item/paper/P = new(L.loc)
			P.info = "<p><b>Good morning soldier!</b>. This compact guide will familiarize you with standard operating procedure. There are three basic rules to follow:<br>#1 Work as a team.<br>#2 Accomplish your objective at all costs.<br>#3 Leave no witnesses.<br>You are fully equipped and stocked for your mission--before departing on the Spec. Ops. Shuttle due South, make sure that all operatives are ready. Actual mission objective will be relayed to you by Central Command through your headsets.<br>If deemed appropriate, Central Command will also allow members of your team to equip assault power-armor for the mission. You will find the armor storage due West of your position. Once you are ready to leave, utilize the Special Operations shuttle console and toggle the hull doors via the other console.</p><p>In the event that the team does not accomplish their assigned objective in a timely manner, or finds no other way to do so, attached below are instructions on how to operate a NanoTrasen Nuclear Device. Your operations <b>LEADER</b> is provided with a nuclear authentication disk and a pin-pointer for this reason. You may easily recognize them by their rank: Lieutenant, Captain, or Major. The nuclear device itself will be present somewhere on your destination.</p><p>Hello and thank you for choosing NanoTrasen for your nuclear information needs. Today's crash course will deal with the operation of a Fission Class NanoTrasen made Nuclear Device.<br>First and foremost, <b>DO NOT TOUCH ANYTHING UNTIL THE BOMB IS IN PLACE.</b> Pressing any button on the compacted bomb will cause it to extend and bolt itself into place. If this is done to unbolt it one must completely log in which at this time may not be possible.<br>To make the device functional:<br>#1 Place bomb in designated detonation zone<br> #2 Extend and anchor bomb (attack with hand).<br>#3 Insert Nuclear Auth. Disk into slot.<br>#4 Type numeric code into keypad ([nuke_code]).<br>Note: If you make a mistake press R to reset the device.<br>#5 Press the E button to log onto the device.<br>You now have activated the device. To deactivate the buttons at anytime, for example when you have already prepped the bomb for detonation, remove the authentication disk OR press the R on the keypad. Now the bomb CAN ONLY be detonated using the timer. A manual detonation is not an option.<br>Note: Toggle off the <b>SAFETY</b>.<br>Use the - - and + + to set a detonation time between 5 seconds and 10 minutes. Then press the timer toggle button to start the countdown. Now remove the authentication disk so that the buttons deactivate.<br>Note: <b>THE BOMB IS STILL SET AND WILL DETONATE</b><br>Now before you remove the disk if you need to move the bomb you can: Toggle off the anchor, move it, and re-anchor.</p><p>The nuclear authorisation code is: <b>[nuke_code ? nuke_code : "None provided"]</b></p><p><b>Good luck, soldier!</b></p>"
			P.name = "Spec. Ops. Manual"

	for_no_type_check(var/obj/effect/landmark/L, GLOBL.landmark_list)
		if (L.name == "Commando-Bomb")
			new /obj/effect/spawner/newbomb/timer/syndicate(L.loc)
			qdel(L)

	message_admins("\blue [key_name_admin(usr)] has spawned a CentCom strike squad.", 1)
	log_admin("[key_name(usr)] used Spawn Death Squad.")
	return 1

/client/proc/create_death_commando(obj/spawn_location, leader_selected = 0)
	var/mob/living/carbon/human/new_commando = new(spawn_location.loc)
	var/commando_leader_rank = pick("Lieutenant", "Captain", "Major")
	var/commando_rank = pick("Corporal", "Sergeant", "Staff Sergeant", "Sergeant 1st Class", "Master Sergeant", "Sergeant Major")
	var/commando_name = pick(GLOBL.last_names)

	new_commando.gender = pick(MALE, FEMALE)

	var/datum/preferences/A = new()//Randomize appearance for the commando.
	A.randomize_appearance_for(new_commando)

	new_commando.real_name = "[!leader_selected ? commando_rank : commando_leader_rank] [commando_name]"
	new_commando.age = !leader_selected ? rand(23,35) : rand(35,45)

	new_commando.dna.ready_dna(new_commando)//Creates DNA.

	//Creates mind stuff.
	new_commando.mind_initialize()
	new_commando.mind.assigned_role = "MODE"
	new_commando.mind.special_role = "Death Commando"
	global.PCticker.mode.traitors |= new_commando.mind//Adds them to current traitor list. Which is really the extra antagonist list.
	new_commando.equip_outfit(leader_selected ? /decl/hierarchy/outfit/death_commando/leader : /decl/hierarchy/outfit/death_commando/standard)
	return new_commando