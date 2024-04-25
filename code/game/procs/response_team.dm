//STRIKE TEAMS
//Thanks to Kilakk for the admin-button portion of this code.

GLOBAL_GLOBL_LIST_NEW(response_team_members)
GLOBAL_GLOBL_INIT(send_emergency_team, FALSE)	// Used for automagic response teams
												// 'admin_emergency_team' for admin-spawned response teams
GLOBAL_GLOBL_INIT(ert_base_chance, 10)	// Default base chance. Will be incremented by increment ERT chance.
GLOBAL_GLOBL(can_call_ert)

/client/proc/response_team()
	set category = PANEL_SPECIAL_VERBS
	set name = "Dispatch Emergency Response Team"
	set desc = "Send an emergency response team to the station"

	if(isnull(holder))
		FEEDBACK_COMMAND_ADMIN_ONLY(usr)
		return
	if(isnull(global.PCticker))
		to_chat(usr, SPAN_WARNING("The game hasn't started yet!"))
		return
	if(global.PCticker.current_state == GAME_STATE_PREGAME)
		to_chat(usr, SPAN_WARNING("The round hasn't started yet!"))
		return
	if(GLOBL.send_emergency_team)
		to_chat(usr, SPAN_WARNING("Central Command has already dispatched an emergency response team!"))
		return
	if(alert("Do you want to dispatch an Emergency Response Team?", , "Yes", "No") != "Yes")
		return
	if(!IS_SEC_LEVEL(/decl/security_level/red)) // Allow admins to reconsider if the alert level isn't Red
		switch(alert("The station is not in red alert. Do you still want to dispatch a response team?", , "Yes", "No"))
			if("No")
				return
	if(GLOBL.send_emergency_team)
		to_chat(usr, SPAN_WARNING("Looks like somebody beat you to it!"))
		return

	message_admins("[key_name_admin(usr)] is dispatching an Emergency Response Team.", 1)
	log_admin("[key_name(usr)] used Dispatch Response Team.")
	trigger_armed_response_team(1)


/client/verb/JoinResponseTeam()
	set category = PANEL_IC

	if(isobserver(usr) || isnewplayer(usr))
		if(!GLOBL.send_emergency_team)
			to_chat(usr, "No emergency response team is currently being sent.")
			return
	/*	if(admin_emergency_team)
			usr << "An emergency response team has already been sent."
			return */
		if(jobban_isbanned(usr, "Syndicate") || jobban_isbanned(usr, "Emergency Response Team") || jobban_isbanned(usr, "Security Officer"))
			to_chat(usr, "<font color=red><b>You are jobbanned from the emergency reponse team!")
			return

		if(length(GLOBL.response_team_members) > 5)
			to_chat(usr, "The emergency response team is already full!")

		for_no_type_check(var/obj/effect/landmark/L, GLOBL.landmark_list)
			if(L.name == "Commando")
				L.name = null//Reserving the place.
				var/new_name = input(usr, "Pick a name", "Name") as null|text
				if(!new_name)//Somebody changed his mind, place is available again.
					L.name = "Commando"
					return
				var/leader_selected = isemptylist(GLOBL.response_team_members)
				var/mob/living/carbon/human/new_commando = create_response_team(L.loc, leader_selected, new_name)
				qdel(L)
				new_commando.mind.key = usr.key
				new_commando.key = usr.key

				to_chat(new_commando, SPAN_INFO("You are [!leader_selected ? "a member" : "the <B>LEADER</B>"] of an Emergency Response Team, a type of military division, under CentCom's service. There is a code red alert on [station_name()], you are tasked to go and fix the problem."))
				to_chat(new_commando, "<b>You should first gear up and discuss a plan with your team. More members may be joining, don't move out before you're ready.")
				if(!leader_selected)
					to_chat(new_commando, "<b>As member of the Emergency Response Team, you answer only to your leader and CentCom officials.</b>")
				else
					to_chat(new_commando, "<b>As leader of the Emergency Response Team, you answer only to CentCom, and have authority to override the Captain where it is necessary to achieve your mission goals. It is recommended that you attempt to cooperate with the captain where possible, however.")
				return

	else
		to_chat(usr, "You need to be an observer or new player to use this.")

// returns a number of dead players in %
/proc/percentage_dead()
	var/total = 0
	var/deadcount = 0
	for(var/mob/living/carbon/human/H in GLOBL.mob_list)
		if(H.client) // Monkeys and mice don't have a client, amirite?
			if(H.stat == DEAD)
				deadcount++
			total++

	if(total == 0)
		return 0
	else
		return round(100 * deadcount / total)

// counts the number of antagonists in %
/proc/percentage_antagonists()
	var/total = 0
	var/antagonists = 0
	for(var/mob/living/carbon/human/H in GLOBL.mob_list)
		if(is_special_character(H) >= 1)
			antagonists++
		total++

	if(total == 0)
		return 0
	else
		return round(100 * antagonists / total)

// Increments the ERT chance automatically, so that the later it is in the round,
// the more likely an ERT is to be able to be called.
/proc/increment_ert_chance()
	while(!GLOBL.send_emergency_team) // There is no ERT at the time.
		GLOBL.ert_base_chance += GLOBL.security_level.ert_base_chance_mod
		sleep(3 MINUTES)


/proc/trigger_armed_response_team(force = 0)
	if(!GLOBL.can_call_ert && !force)
		return
	if(GLOBL.send_emergency_team)
		return

	var/send_team_chance = GLOBL.ert_base_chance // Is incremented by increment_ert_chance.
	send_team_chance += 2 * percentage_dead() // the more people are dead, the higher the chance
	send_team_chance += percentage_antagonists() // the more antagonists, the higher the chance
	send_team_chance = min(send_team_chance, 100)

	if(force)
		send_team_chance = 100

	// there's only a certain chance a team will be sent
	if(!prob(send_team_chance))
		command_alert("It would appear that an emergency response team was requested for [station_name()]. Unfortunately, we were unable to send one at this time.", "Central Command")
		GLOBL.can_call_ert = FALSE // Only one call per round, ladies.
		return

	command_alert("It would appear that an emergency response team was requested for [station_name()]. We will prepare and send one as soon as possible.", "Central Command")

	GLOBL.can_call_ert = FALSE // Only one call per round, gentleman.
	GLOBL.send_emergency_team = TRUE

	sleep(5 MINUTES)
	GLOBL.send_emergency_team = FALSE // Can no longer join the ERT.

/*	var/area/security/nuke_storage/nukeloc = locate()//To find the nuke in the vault
	var/obj/machinery/nuclearbomb/nuke = locate() in nukeloc
	if(!nuke)
		nuke = locate() in world
	var/obj/item/paper/P = new
	P.info = "Your orders, Commander, are to use all means necessary to return the station to a survivable condition.<br>To this end, you have been provided with the best tools we can give in the three areas of Medicine, Engineering, and Security. The nuclear authorisation code is: <b>[ nuke ? nuke.r_code : "AHH, THE NUKE IS GONE!"]</b>. Be warned, if you detonate this without good reason, we will hold you to account for damages. Memorise this code, and then burn this message."
	P.name = "Emergency Nuclear Code, and ERT Orders"
	for_no_type_check(var/obj/effect/landmark/A, GLOBL.landmark_list)
		if (A.name == "nukecode")
			P.loc = A.loc
			del(A)
			continue
*/

/client/proc/create_response_team(obj/spawn_location, leader_selected = 0, commando_name)
	//usr << "\red ERT has been temporarily disabled. Talk to a coder."
	//return

	var/mob/living/carbon/human/M = new(null)
	GLOBL.response_team_members |= M

	//todo: god damn this.
	//make it a panel, like in character creation
	var/new_facial = input("Please select facial hair color.", "Character Generation") as color
	if(new_facial)
		M.r_facial = hex2num(copytext(new_facial, 2, 4))
		M.g_facial = hex2num(copytext(new_facial, 4, 6))
		M.b_facial = hex2num(copytext(new_facial, 6, 8))

	var/new_hair = input("Please select hair color.", "Character Generation") as color
	if(new_facial)
		M.r_hair = hex2num(copytext(new_hair, 2, 4))
		M.g_hair = hex2num(copytext(new_hair, 4, 6))
		M.b_hair = hex2num(copytext(new_hair, 6, 8))

	var/new_eyes = input("Please select eye color.", "Character Generation") as color
	if(new_eyes)
		M.r_eyes = hex2num(copytext(new_eyes, 2, 4))
		M.g_eyes = hex2num(copytext(new_eyes, 4, 6))
		M.b_eyes = hex2num(copytext(new_eyes, 6, 8))

	var/new_tone = input("Please select skin tone level: 1-220 (1=albino, 35=caucasian, 150=black, 220='very' black)", "Character Generation") as text

	if(!new_tone)
		new_tone = 35
	M.s_tone = max(min(round(text2num(new_tone)), 220), 1)
	M.s_tone = -M.s_tone + 35

	// Hair.
	var/new_hstyle = input(usr, "Select a hair style", "Grooming") as null | anything in GLOBL.hair_styles_list
	if(isnotnull(new_hstyle))
		M.h_style = new_hstyle

	// Facial hair.
	var/new_fstyle = input(usr, "Select a facial hair style", "Grooming") as null | anything in GLOBL.facial_hair_styles_list
	if(isnotnull(new_fstyle))
		M.f_style = new_fstyle

	var/new_gender = alert(usr, "Please select gender.", "Character Generation", "Male", "Female")
	if(new_gender)
		if(new_gender == "Male")
			M.gender = MALE
		else
			M.gender = FEMALE
	//M.rebuild_appearance()
	M.update_hair()
	M.update_body()
	M.check_dna(M)

	M.real_name = commando_name
	M.name = commando_name
	M.age = !leader_selected ? rand(23, 35) : rand(35, 45)

	M.dna.ready_dna(M)	//Creates DNA.

	//Creates mind stuff.
	M.mind = new
	M.mind.current = M
	M.mind.original = M
	M.mind.assigned_role = "MODE"
	M.mind.special_role = "Response Team"
	if(!(M.mind in global.PCticker.minds))
		global.PCticker.minds.Add(M.mind)	//Adds them to regular mind list.
	M.loc = spawn_location
	M.equip_strike_team(leader_selected)
	return M

/mob/living/carbon/human/proc/equip_strike_team(leader_selected = 0)
	//Special radio setup
	equip_to_slot_or_del(new /obj/item/radio/headset/ert(src), SLOT_ID_L_EAR)

	//Replaced with new ERT uniform
	equip_to_slot_or_del(new /obj/item/clothing/under/rank/centcom_officer(src), SLOT_ID_WEAR_UNIFORM)
	equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(src), SLOT_ID_SHOES)
	equip_to_slot_or_del(new /obj/item/clothing/gloves/swat(src), SLOT_ID_GLOVES)
	equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses(src), SLOT_ID_GLASSES)
	equip_to_slot_or_del(new /obj/item/storage/satchel(src), SLOT_ID_BACK)
/*

	//Old ERT Uniform
	//Basic Uniform
	equip_to_slot_or_del(new /obj/item/clothing/under/syndicate/tacticool(src), SLOT_ID_WEAR_UNIFORM)
	equip_to_slot_or_del(new /obj/item/flashlight(src), SLOT_ID_L_POCKET)
	equip_to_slot_or_del(new /obj/item/clipboard(src), SLOT_ID_R_POCKET)
	equip_to_slot_or_del(new /obj/item/gun/energy/gun(src), SLOT_ID_BELT)
	equip_to_slot_or_del(new /obj/item/clothing/mask/gas/swat(src), SLOT_ID_WEAR_MASK)

	//Glasses
	equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/sechud(src), SLOT_ID_GLASSES)

	//Shoes & gloves
	equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(src), SLOT_ID_SHOES)
	equip_to_slot_or_del(new /obj/item/clothing/gloves/swat(src), SLOT_ID_GLOVES)

	//Removed
//	equip_to_slot_or_del(new /obj/item/clothing/suit/armor/swat(src), SLOT_ID_WEAR_SUIT)
//	equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/deathsquad(src), SLOT_ID_HEAD)

	//Backpack
	equip_to_slot_or_del(new /obj/item/storage/backpack/security(src), SLOT_ID_BACK)
	equip_to_slot_or_del(new /obj/item/storage/box/engineer(src), SLOT_ID_IN_BACKPACK)
	equip_to_slot_or_del(new /obj/item/storage/firstaid/regular(src), SLOT_ID_IN_BACKPACK)
*/
	var/obj/item/card/id/W = new(src)
	W.assignment = "Emergency Response Team[leader_selected ? " Leader" : ""]"
	W.registered_name = real_name
	W.name = "[real_name]'s ID Card ([W.assignment])"
	W.icon_state = "centcom"
	W.access = get_all_station_access()
	W.access.Add(get_all_centcom_access())
	equip_to_slot_or_del(W, SLOT_ID_ID_STORE)

	return 1

//debug verb (That is horribly coded, LEAVE THIS OFF UNLESS PRIVATELY TESTING. Seriously.
/*client/verb/ResponseTeam()
	set category = PANEL_ADMIN

	if(!send_emergency_team)
		send_emergency_team = 1
*/