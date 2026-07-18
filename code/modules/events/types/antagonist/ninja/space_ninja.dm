/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+++++++++++++++++++++++++++++++++++++//                //++++++++++++++++++++++++++++++++++
======================================SPACE NINJA SETUP====================================
___________________________________________________________________________________________
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

/*
	README:

	Data:

	>> space_ninja.dm << is this file. It contains a variety of procs related to either spawning space ninjas,
	modifying their verbs, various help procs, testing debug-related content, or storing unused procs for later.
	Similar functions should go into this file, along with anything else that may not have an explicit category.
	IMPORTANT: actual ninja suit, gloves, etc, are stored under the appropriate clothing files. If you need to change
	variables or look them up, look there. Easiest way is through the map file browser.

	>> ninja_abilities.dm << contains all the ninja-related powers. Spawning energy swords, teleporting, and the like.
	If more powers are added, or perhaps something related to powers, it should go there. Make sure to describe
	what an ability/power does so it's easier to reference later without looking at the code.
	IMPORTANT: verbs are still somewhat funky to work with. If an argument is specified but is not referenced in a way
	BYOND likes, in the code content, the verb will fail to trigger. Nothing will happen, literally, when clicked.
	This can be bypassed by either referencing the argument properly, or linking to another proc with the argument
	attached. The latter is what I like to do for certain cases--sometimes it's necessary to do that regardless.

	>> ninja_equipment.dm << deals with all the equipment-related procs for a ninja. Primarily it has the suit, gloves,
	and mask. The suit is by far the largest section of code out of the three and includes a lot of code that ties in
	to other functions. This file has gotten kind of large so breaking it up may be in order. I use section hearders.
	IMPORTANT: not much to say here. Follow along with the comments and adding new functions should be a breeze. Also
	know that certain equipment pieces are linked in other files. The energy blade, for example, has special
	functions defined in the appropriate files (airlock, securestorage, etc).

	General Notes:

	I created space ninjas with the expressed purpose of spicing up boring rounds. That is, ninjas are to xenos as marauders are to
	death squads. Ninjas are stealthy, tech-savvy, and powerful. Not to say marauders are all of those things, but a clever ninja
	should have little problem murderampaging their way through just about anything. Short of admin wizards maybe.
	HOWEVER!
	Ninjas also have a fairly great weakness as they require energy to use abilities. If, theoretically, there is a game
	mode based around space ninjas, make sure to account for their energy needs.

	Admin Notes:

	Ninjas are not admin PCs--please do not use them for that purpose. They are another way to participate in the game post-death,
	like pais, xenos, death squads, and cyborgs.
	I'm currently looking for feedback from regular players since beta testing is largely done. I would appreciate if
	you spawned regular players as ninjas when rounds are boring. Or exciting, it's all good as long as there is feedback.
	You can also spawn ninja gear manually if you want to.

	How to do that:
	Make sure your character has a mind.
	Change their assigned_role to "MODE", no quotes. Otherwise, the suit won't initialize.
	Change their special_role to "Ninja", no quotes. Otherwise, the character will be gibbed.
	Spawn ninja gear, put it on, hit initialize. Let the suit do the rest. You are now a space ninja.
	I don't recommend messing with suit variables unless you really know what you're doing.

	Miscellaneous Notes:

	Potential Upgrade Tree:
		Energy Shield:
			Extra Ability
			Syndicate Shield device?
				Works like the force wall spell, except can be kept indefinitely as long as energy remains. Toggled on or off.
				Would block bullets and the like.
		Phase Shift
			Extra Ability
			Advanced Sensors?
				Instead of being unlocked at the start, Phase Shieft would become available once requirements are met.
		Uranium-based Recharger:
			Suit Upgrade
			Unsure
				Instead of losing energy each second, the suit would regain the same amount of energy.
				This would not count in activating stealth and similar.
		Extended Battery Life:
			Suit Upgrade
			Battery of higher capacity
				Already implemented. Replace current battery with one of higher capacity.
		Advanced Cloak-Tech device.
			Suit Upgrade
			Syndicate Cloaking Device?
				Remove cloak failure rate.
*/

//=======//RANDOM EVENT//=======//

GLOBAL_GLOBL_INIT(toggle_space_ninja, FALSE)	//If ninjas can spawn or not.
GLOBAL_GLOBL_INIT(sent_ninja_to_station, FALSE)	//If a ninja is already on the station.

/proc/space_ninja_arrival(assign_key = null, assign_mission = null)
	// ID index of which ninja selection is being ran
	var/static/ninja_selection_id = 1
	// ID of the ninja selection process that has been confirmed by the player, so a player can't accept the role of a latter ninja selection or whatever
	var/static/ninja_confirmed_selection = 0
	// Prevents this proc from running if it's already being ran
	var/static/ninja_selection_active = FALSE

	if(ninja_selection_active)
		to_chat(usr, SPAN_WARNING("Ninja selection already in progress. Please wait until it ends."))
		return

	var/ninja_key = assign_key
	var/mob/candidate_mob

	if(!ninja_key)
		var/list/candidates = list()	//list of candidate keys
		for(var/mob/dead/ghost/observer in GLOBL.player_list)
			if(!observer.client || observer.client.holder || observer.client.is_afk())
				continue
			if(!(observer.client.prefs.be_special & BE_NINJA))
				continue
			if(observer.mind?.current?.stat != DEAD)
				continue
			candidates += observer

		if(!length(candidates))
			return

		candidates = shuffle(candidates)//Incorporating Donkie's list shuffle
		while(!ninja_key && length(candidates))
			candidate_mob = pick_n_take(candidates)
			if(sd_Alert(candidate_mob, "Would you like to spawn as a space ninja?", buttons = list("Yes", "No"), duration = 150) == "Yes")
				ninja_key = candidate_mob.key

		if(!ninja_key)
			return

	candidate_mob ||= get_mob_by_key(ninja_key)
	if(!candidate_mob || !candidate_mob.client)
		to_chat(usr, SPAN_WARNING("The randomly chosen mob was not found in the second check."))
		return

	ninja_selection_active = TRUE
	ninja_selection_id++
	var/this_selection_id = ninja_selection_id

	spawn(1)
		if(alert(candidate_mob, "You have been selected to play as a space ninja. Would you like to play as this role? (You have 30 seconds to accept - You will spawn in 30 seconds if you accept)",,"Yes", "No") != "Yes")
			to_chat(usr, SPAN_WARNING("The selected candidate for space ninja declined."))
			return

		ninja_confirmed_selection = this_selection_id

	spawn(30 SECONDS)
		if(!ninja_selection_active || (this_selection_id != ninja_selection_id ))
			ninja_selection_active = FALSE
			to_chat(candidate_mob, SPAN_WARNING("Sorry, you were too late. You only had 30 seconds to accept."))
			return

		if(ninja_confirmed_selection != ninja_selection_id)
			ninja_selection_active = FALSE
			to_chat(usr, SPAN_WARNING("The ninja did not accept the role in time."))
			return

		ninja_selection_active = FALSE

		//The ninja will be created on the right spawn point or at late join.
		var/mob/living/carbon/human/new_ninja = create_space_ninja()
		if(isnull(new_ninja))
			to_chat(usr, SPAN_WARNING("Failed to spawn the space ninja, likely due to no spawn points being available."))

		else
			new_ninja.key = ninja_key
			var/decl/special_role/ninja/ninja_role = GET_DECL_INSTANCE(__IMPLIED_TYPE__)
			ninja_role.give_mission(new_ninja, pick(NINJA_HEEL, NINJA_FACE), assign_mission)

		GLOBL.sent_ninja_to_station = TRUE // And we're done.

//=======//CURRENT PLAYER VERB//=======//

/client/proc/cmd_admin_ninjafy(mob/M in GLOBL.player_list)
	set category = null
	set name = "Make Space Ninja"

	if(!global.PCticker)
		alert("Wait until the game starts")
		return
	if(!GLOBL.toggle_space_ninja)
		alert("Space Ninjas spawning is disabled.")
		return

	var/confirm = alert(src, "You sure?", "Confirm", "Yes", "No")
	if(confirm != "Yes")
		return

	if(ishuman(M))
		var/mob/living/carbon/human/new_ninja = M
		log_admin("[key_name(src)] turned [M.key] into a Space Ninja.")
		spawn(10)
			// throw out all this garbage
			qdel(new_ninja.wear_uniform)
			qdel(new_ninja.wear_suit)
			qdel(new_ninja.wear_mask)
			qdel(new_ninja.head)
			qdel(new_ninja.shoes)
			qdel(new_ninja.gloves)
			// give em the suit and whatnot. does not give out objectives
			var/decl/special_role/ninja/ninja_role = GET_DECL_INSTANCE(__IMPLIED_TYPE__)
			ninja_role.setup(new_ninja)

	else
		alert("Invalid mob")

//=======//CURRENT GHOST VERB//=======//

/client/proc/send_space_ninja()
	set category = PANEL_FUN
	set name = "Spawn Space Ninja"
	set desc = "Spawns a space ninja for when you need a teenager with attitude."
	set popup_menu = 0

	if(!holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return
	if(!global.PCticker.mode)
		alert("The game hasn't started yet!")
		return
	if(!GLOBL.toggle_space_ninja)
		alert("Space Ninjas spawning is disabled.")
		return
	if(alert("Are you sure you want to send in a space ninja?", , "Yes", "No") == "No")
		return

	var/mission
	while(!mission)
		mission = copytext(sanitize(input(src, "Please specify which mission the space ninja shall undertake.", "Specify Mission", "")), 1, MAX_MESSAGE_LEN)
		if(!mission)
			if(alert("Error, no mission set. Do you want to exit the setup process?",,"Yes","No")=="Yes")
				return

	var/input = ckey(input("Pick character to spawn as the Space Ninja", "Key", ""))
	if(!input)
		return

	space_ninja_arrival(input, mission)

	message_admins("\blue [key_name_admin(key)] has spawned [input] as a Space Ninja.<br>Their <b>mission</b> is: [mission]")
	log_admin("[key] used Spawn Space Ninja.")

	return

//=======//NINJA CREATION PROCS//=======//

/proc/find_ninja_start()
	if(!length(GLOBL.ninjastart))
		// Until such a time as people want to place ninja spawn points, carpspawn will do fine.
		for_no_type_check(var/obj/effect/landmark/carpmark, GLOBL.landmark_list)
			if(carpmark.name == "carpspawn")
				GLOBL.ninjastart |= carpmark

	if(length(GLOBL.ninjastart))
		return pick(GLOBL.ninjastart)
	else if(length(GLOBL.latejoin))
		return pick(GLOBL.latejoin)

	return null

/proc/create_space_ninja(obj/spawn_point = find_ninja_start())
	if(isnull(spawn_point))
		warning("No spawnable locations could be found for the space ninja.")
		message_admins("No spawnable locations could be found for the space ninja.")
		return null

	var/mob/living/carbon/human/new_ninja = new(spawn_point.loc)
	var/ninja_title = pick(GLOBL.ninja_titles)
	var/ninja_name = pick(GLOBL.ninja_names)
	new_ninja.gender = pick(MALE, FEMALE)

	var/datum/preferences/A = new()//Randomize appearance for the ninja.
	A.randomize_appearance_for(new_ninja)
	new_ninja.real_name = "[ninja_title] [ninja_name]"
	new_ninja.dna.ready_dna(new_ninja)

	var/decl/special_role/ninja/ninja_role = GET_DECL_INSTANCE(__IMPLIED_TYPE__)
	ninja_role.setup(new_ninja)
	// all this does is set up the ninja it doesn't give them objectives or anything

	return new_ninja

//=======//HELPER PROCS//=======//

//Randomizes suit parameters.
/obj/item/clothing/suit/space/space_ninja/proc/randomize_param()
	passive_energy_drain = rand(1, 20)
	active_energy_drain = rand(20, 100)
	kamikaze_energy_drain = rand(100, 500)
	kamikaze_passive_damage = rand(1, 20)
	suit_action_delay = rand(10, 100)
	smoke_bombs = rand(5, 20)
	adrenaline_boosts = rand(1, 7)

//This proc prevents the suit from being taken off.
/obj/item/clothing/suit/space/space_ninja/proc/lock_suit(mob/living/carbon/human/H, X = 0)
	if(X)//If you want to check for icons.
		icon_state = H.gender == FEMALE ? "s-ninjanf" : "s-ninjan"
		H.gloves.icon_state = "s-ninjan"
		H.gloves.item_state = "s-ninjan"
	else
		if(!H.mind.has_special_role(SPECIAL_ROLE_NINJA))
			to_chat(H, SPAN_WARNING("<B>f�TaL ��RRoR</B>: 382200-*#00C�DE <B>RED</B><br>UNAU�HORIZED US� DET�C���eD<br>CoMM�NCING SUB-R0U�IN3 13...<br>T�RMInATING U-U-US�R..."))
			H.gib()
			return 0
		if(!istype(H.head, /obj/item/clothing/head/helmet/space/space_ninja))
			to_chat(H, SPAN_WARNING("<B>ERROR</B>: 100113 \black UNABLE TO LOCATE HEAD GEAR<br>ABORTING..."))
			return 0
		if(!istype(H.shoes, /obj/item/clothing/shoes/space_ninja))
			to_chat(H, SPAN_WARNING("<B>ERROR</B>: 122011 \black UNABLE TO LOCATE FOOT GEAR<br>ABORTING..."))
			return 0
		if(!istype(H.gloves, /obj/item/clothing/gloves/space_ninja))
			to_chat(H, SPAN_WARNING("<B>ERROR</B>: 110223 \black UNABLE TO LOCATE HAND GEAR<br>ABORTING..."))
			return 0

		affecting = H
		can_remove = FALSE
		slowdown = 0
		n_hood = H.head
		n_hood.can_remove = FALSE
		n_shoes = H.shoes
		n_shoes.can_remove = FALSE
		n_shoes.slowdown--
		n_gloves = H.gloves
		n_gloves.can_remove = FALSE

	return 1

//This proc allows the suit to be taken off.
/obj/item/clothing/suit/space/space_ninja/proc/unlock_suit()
	affecting = null
	can_remove = TRUE
	slowdown = 1
	icon_state = "s-ninja"
	if(n_hood)//Should be attached, might not be attached.
		n_hood.can_remove = TRUE
	if(n_shoes)
		n_shoes.can_remove = TRUE
		n_shoes.slowdown++
	if(n_gloves)
		n_gloves.icon_state = "s-ninja"
		n_gloves.item_state = "s-ninja"
		n_gloves.can_remove = TRUE
		n_gloves.candrain = 0
		n_gloves.draining = 0

//Allows the mob to grab a stealth icon.
/mob/proc/NinjaStealthActive(atom/A)//A is the atom which we are using as the overlay.
	invisibility = INVISIBILITY_LEVEL_TWO//Set ninja invis to 2.
	var/icon/opacity_icon = new(A.icon, A.icon_state)
	var/icon/alpha_mask = getIconMask(src)
	var/icon/alpha_mask_2 = new('icons/effects/effects.dmi', "at_shield1")
	alpha_mask.AddAlphaMask(alpha_mask_2)
	opacity_icon.AddAlphaMask(alpha_mask)
	for(var/i = 0, i < 5, i++)//And now we add it as overlays. It's faster than creating an icon and then merging it.
		var/image/I = image("icon" = opacity_icon, "icon_state" = A.icon_state, "layer" = layer + 0.8)//So it's above other stuff but below weapons and the like.
		switch(i)//Now to determine offset so the result is somewhat blurred.
			if(1)
				I.pixel_x -= 1
			if(2)
				I.pixel_x += 1
			if(3)
				I.pixel_y -= 1
			if(4)
				I.pixel_y += 1

		add_overlay(I) // And finally add the overlay.
	add_overlay(image(icon = 'icons/effects/effects.dmi', icon_state = "electricity", layer = layer + 0.9))

//When ninja steal malfunctions.
/mob/proc/NinjaStealthMalf()
	invisibility = 0//Set ninja invis to 0.
	add_overlay(image(icon = 'icons/effects/effects.dmi', icon_state = "electricity", layer = layer + 0.9))
	playsound(loc, 'sound/effects/stealthoff.ogg', 75, 1)

//=======//GENERIC VERB MODIFIERS//=======//

/obj/item/clothing/suit/space/space_ninja/proc/grant_equip_verbs()
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/init
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/deinit
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/spideros
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/stealth
	n_gloves.verbs += /obj/item/clothing/gloves/space_ninja/proc/toggled

	is_suit_initialized = TRUE

/obj/item/clothing/suit/space/space_ninja/proc/remove_equip_verbs()
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/init
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/deinit
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/spideros
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/stealth
	if(n_gloves)
		n_gloves.verbs -= /obj/item/clothing/gloves/space_ninja/proc/toggled

	is_suit_initialized = FALSE

/obj/item/clothing/suit/space/space_ninja/proc/grant_ninja_verbs()
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjashift
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjasmoke
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjaboost
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjapulse
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjablade
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjastar
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjanet

	is_suit_initialized = TRUE
	slowdown = 0

/obj/item/clothing/suit/space/space_ninja/proc/remove_ninja_verbs()
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjashift
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjaboost
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjapulse
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjablade
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjastar
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjanet

//=======//KAMIKAZE VERBS//=======//

/obj/item/clothing/suit/space/space_ninja/proc/grant_kamikaze(mob/living/carbon/U)
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjashift
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjanet
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjaslayer
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjawalk
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjamirage

	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/stealth

	kamikaze = TRUE

	icon_state = U.gender == FEMALE ? "s-ninjakf" : "s-ninjak"
	if(n_gloves)
		n_gloves.icon_state = "s-ninjak"
		n_gloves.item_state = "s-ninjak"
		n_gloves.candrain = 0
		n_gloves.draining = 0
		n_gloves.verbs -= /obj/item/clothing/gloves/space_ninja/proc/toggled

	cancel_stealth()

	CLOSE_BROWSER(U, "window=spideros")
	to_chat(U, SPAN_WARNING("Do or Die, <b>LET'S ROCK!!</b>"))

/obj/item/clothing/suit/space/space_ninja/proc/remove_kamikaze(mob/living/carbon/U)
	if(kamikaze)
		verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjashift
		verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjapulse
		verbs += /obj/item/clothing/suit/space/space_ninja/proc/ninjastar
		verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjaslayer
		verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjawalk
		verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ninjamirage

		verbs += /obj/item/clothing/suit/space/space_ninja/proc/stealth
		if(n_gloves)
			n_gloves.verbs -= /obj/item/clothing/gloves/space_ninja/proc/toggled

		U.incorporeal_move = 0
		kamikaze = FALSE
		kamikaze_unlock_tracker = 0
		to_chat(U, SPAN_INFO("Disengaging mode...<br>\black<b>CODE NAME</b>: \red <b>KAMIKAZE</b>"))

//=======//AI VERBS//=======//

/obj/item/clothing/suit/space/space_ninja/proc/grant_AI_verbs()
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ai_hack_ninja
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/ai_return_control

	suit_busy = FALSE
	controller = NINJA_AI_CONTROL

/obj/item/clothing/suit/space/space_ninja/proc/remove_AI_verbs()
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ai_hack_ninja
	verbs -= /obj/item/clothing/suit/space/space_ninja/proc/ai_return_control

	controller = NINJA_WEARER_CONTROL


//=======//OLD & UNUSED//=======//

/*

Deprecated. get_dir() does the same thing. Still a nice proc.
Returns direction that the mob or whomever should be facing in relation to the target.
This proc does not grant absolute direction and is mostly useful for 8dir sprite positioning.
I personally used it with getline() to great effect.
/proc/get_dir_to(turf/start,turf/end)//N
	var/xdiff = start.x - end.x//The sign is important.
	var/ydiff = start.y - end.y

	var/direction_x = xdiff<1 ? 4:8//East - west
	var/direction_y = ydiff<1 ? 1:2//North - south
	var/direction_xy = xdiff==0 ? -4:0//If x is the same, subtract 4.
	var/direction_yx = ydiff==0 ? -1:0//If y is the same, subtract 1.
	var/direction_f = direction_x+direction_y+direction_xy+direction_yx//Finally direction tally.
	direction_f = direction_f==0 ? 1:direction_f//If direction is 0(same spot), return north. Otherwise, direction.

	return direction_f

Alternative and inferior method of calculating spideros.
var/temp = num2text(spideros)
var/return_to = copytext(temp, 1, (length(temp)))//length has to be to the length of the thing because by default it's length+1
spideros = text2num(return_to)//Maximum length here is 6. Use (return_to, X) to specify larger strings if needed.

//Old way of draining from wire.
/obj/item/clothing/gloves/space_ninja/proc/drain_wire()
	set name = "Drain From Wire"
	set desc = "Drain energy directly from an exposed wire."
	set category = "Ninja Equip"

	var/obj/structure/cable/attached
	var/mob/living/carbon/human/U = loc
	if(candrain&&!draining)
		var/turf/T = U.loc
		if(isturf(T) && T.is_plating())
			attached = locate() in T
			if(!attached)
				to_chat(U, SPAN_WARNING("Warning: no exposed cable available."))
			else
				to_chat(U, SPAN_INFO("Connecting to wire, stand still..."))
				if(do_after(U,50)&&isnotnull(attached))
					drain("WIRE",attached,U:wear_suit,src)
				else
					to_chat(U, SPAN_WARNING("Procedure interrupted. Protocol terminated."))
	return

I've tried a lot of stuff but adding verbs to the AI while inside an object, inside another object, did not want to work properly.
This was the best work-around I could come up with at the time. Uses objects to then display to panel, based on the object spell system.
Can be added on to pretty easily.

BYOND fixed the verb bugs so this is no longer necessary. I prefer verb panels.

/obj/item/clothing/suit/space/space_ninja/proc/grant_AI_verbs()
	var/obj/effect/proc_holder/ai_return_control/A_C = new(AI)
	var/obj/effect/proc_holder/ai_hack_ninja/B_C = new(AI)
	var/obj/effect/proc_holder/ai_instruction/C_C = new(AI)
	new/obj/effect/proc_holder/ai_holo_clear(AI)
	AI.proc_holder_list += A_C
	AI.proc_holder_list += B_C
	AI.proc_holder_list += C_C

	controller = NINJA_AI_CONTROL

/obj/item/clothing/suit/space/space_ninja/proc/remove_AI_verbs()
	var/obj/effect/proc_holder/ai_return_control/A_C = locate() in AI
	var/obj/effect/proc_holder/ai_hack_ninja/B_C = locate() in AI
	var/obj/effect/proc_holder/ai_instruction/C_C = locate() in AI
	var/obj/effect/proc_holder/ai_holo_clear/D_C = locate() in AI
	del(A_C)
	del(B_C)
	del(C_C)
	del(D_C)
	AI.proc_holder_list = list()
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/deinit
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/spideros
	verbs += /obj/item/clothing/suit/space/space_ninja/proc/stealth

	controller = NINJA_WEARER_CONTROL

//Workaround
/obj/effect/proc_holder/ai_holo_clear
	name = "Clear Hologram"
	desc = "Stops projecting the current holographic image."
	panel = "AI Ninja Equip"
	density = FALSE
	opacity = FALSE


/obj/effect/proc_holder/ai_holo_clear/Click()
	var/obj/item/clothing/suit/space/space_ninja/S = loc.loc//This is so stupid but makes sure certain things work. AI.SUIT
	del(S.hologram.i_attached)
	del(S.hologram)
	var/obj/effect/proc_holder/ai_holo_clear/D_C = locate() in S.AI
	S.AI.proc_holder_list -= D_C
	return

/obj/effect/proc_holder/ai_instruction//Let's the AI know what they can do.
	name = "Instructions"
	desc = "Displays a list of helpful information."
	panel = "AI Ninja Equip"
	density = FALSE
	opacity = FALSE

/obj/effect/proc_holder/ai_instruction/Click()
	to_chat(loc, "The menu you are seeing will contain other commands if they become available.<br>Right click a nearby turf to display an AI Hologram. It will only be visible to you and your host. You can move it freely using normal movement keys--it will disappear if placed too far away.")

/obj/effect/proc_holder/ai_hack_ninja//Generic proc holder to make sure the two verbs below work propely.
	name = "Hack SpiderOS"
	desc = "Hack directly into the Black Widow(tm) neuro-interface."
	panel = "AI Ninja Equip"
	density = FALSE
	opacity = FALSE

/obj/effect/proc_holder/ai_hack_ninja/Click()//When you click on it.
	var/obj/item/clothing/suit/space/space_ninja/S = loc.loc
	S.hack_spideros()
	return

/obj/effect/proc_holder/ai_return_control
	name = "Relinquish Control"
	desc = "Return control to the user."
	panel = "AI Ninja Equip"
	density = FALSE
	opacity = FALSE

/obj/effect/proc_holder/ai_return_control/Click()
	var/mob/living/silicon/ai/A = loc
	var/obj/item/clothing/suit/space/space_ninja/S = A.loc
	CLOSE_BROWSER(A, "window=hack spideros") // Close window
	to_chat(A, "You have seized your hacking attempt. [S.affecting] has regained control.")
	to_chat(S.affecting, "<b>UPDATE</b>: [A.real_name] has ceased hacking attempt. All systems clear.")
	S.remove_AI_verbs()
	return
*/

//=======//DEBUG//=======//
/*
/obj/item/clothing/suit/space/space_ninja/proc/display_verb_procs()
//DEBUG
//Does nothing at the moment. I am trying to see if it's possible to mess around with verbs as variables.
	//for(var/P in verbs)
//		if(P.set.name)
//			to_chat(usr, "[P.set.name], path: [P]")
	return


Most of these are at various points of incomplete.

/mob/verb/grant_object_panel()
	set name = "Grant AI Ninja Verbs Debug"
	set category = "Ninja Debug"
	var/obj/effect/proc_holder/ai_return_control/A_C = new(src)
	var/obj/effect/proc_holder/ai_hack_ninja/B_C = new(src)
	usr:proc_holder_list += A_C
	usr:proc_holder_list += B_C

mob/verb/remove_object_panel()
	set name = "Remove AI Ninja Verbs Debug"
	set category = "Ninja Debug"
	var/obj/effect/proc_holder/ai_return_control/A = locate() in src
	var/obj/effect/proc_holder/ai_hack_ninja/B = locate() in src
	usr:proc_holder_list -= A
	usr:proc_holder_list -= B
	del(A)//First.
	del(B)//Second, to keep the proc going.
	return

/client/verb/grant_verb_ninja_debug1(var/mob/M in view())
	set name = "Grant AI Ninja Verbs Debug"
	set category = "Ninja Debug"

	M.verbs += /mob/living/silicon/ai/verb/ninja_return_control
	M.verbs += /mob/living/silicon/ai/verb/ninja_spideros
	return

/client/verb/grant_verb_ninja_debug2(var/mob/living/carbon/human/M in view())
	set name = "Grant Back Ninja Verbs"
	set category = "Ninja Debug"

	M.wear_suit.verbs += /obj/item/clothing/suit/space/space_ninja/proc/deinit
	M.wear_suit.verbs += /obj/item/clothing/suit/space/space_ninja/proc/spideros
	return

/obj/proc/grant_verb_ninja_debug3(var/mob/living/silicon/ai/A as mob)
	set name = "Grant AI Ninja Verbs"
	set category = "null"
	set hidden = 1
	A.verbs -= /obj/item/clothing/suit/space/space_ninja/proc/deinit
	A.verbs -= /obj/item/clothing/suit/space/space_ninja/proc/spideros
	return

/mob/verb/get_dir_to_target(var/mob/M in oview())
	set name = "Get Direction to Target"
	set category = "Ninja Debug"

	to_world("DIR: [get_dir_to(src.loc,M.loc)]")
	return
//
/mob/verb/kill_self_debug()
	set name = "DEBUG Kill Self"
	set category = "Ninja Debug"

	src:death()

/client/verb/switch_client_debug()
	set name = "DEBUG Switch Client"
	set category = "Ninja Debug"

	mob = mob:loc:loc

/mob/verb/possess_mob(var/mob/M in oview())
	set name = "DEBUG Possess Mob"
	set category = "Ninja Debug"

	client.mob = M

/client/verb/switcharoo(var/mob/M in oview())
	set name = "DEBUG Switch to AI"
	set category = "Ninja Debug"

	var/mob/last_mob = mob
	mob = M
	last_mob:wear_suit:AI:key = key
//
/client/verb/ninjaget(var/mob/M in oview())
	set name = "DEBUG Ninja GET"
	set category = "Ninja Debug"

	mob = M
	M.gib()
	space_ninja()

/mob/verb/set_debug_ninja_target()
	set name = "Set Debug Target"
	set category = "Ninja Debug"

	ninja_debug_target = src//The target is you, brohime.
	to_world("Target: [src]")

/mob/verb/hack_spideros_debug()
	set name = "Debug Hack Spider OS"
	set category = "Ninja Debug"

	var/mob/living/silicon/ai/A = loc:AI
	if(A)
		if(!A.key)
			A.client.mob = loc:affecting
		else
			loc:affecting:client:mob = A
	return

//Tests the net and what it does.
/mob/verb/ninjanet_debug()
	set name = "Energy Net Debug"
	set category = "Ninja Debug"

	var/obj/effect/energy_net/E = new /obj/effect/energy_net(loc)
	E.layer = layer+1//To have it appear one layer above the mob.
	stunned = 10//So they are stunned initially but conscious.
	anchored = TRUE//Anchors them so they can't move.
	E.affecting = src
	spawn(0)//Parallel processing.
		E.process(src)
	return

I made this as a test for a possible ninja ability (or perhaps more) for a certain mob to see hallucinations.
The thing here is that these guys have to be coded to do stuff as they are simply images that you can't even click on.
That is why you attached them to objects.
/mob/verb/TestNinjaShadow()
	set name = "Test Ninja Ability"
	set category = "Ninja Debug"

	if(client)
		var/safety = 4
		for(var/turf/T in oview(5))
			if(prob(20))
				var/current_clone = image('icons/mob/mob.dmi',T,"s-ninja")
				safety--
				spawn(0)
					src << current_clone
					spawn(300)
						del(current_clone)
					spawn while(isnotnull(current_clone))
						step_to(current_clone,src,1)
						sleep(5)
			if(safety<=0)	break
	return */

//Alternate ninja speech replacement.
/*This text is hilarious but also absolutely retarded.
message = replacetextx(message, "l", "r")
message = replacetextx(message, "rr", "ru")
message = replacetextx(message, "v", "b")
message = replacetextx(message, "f", "hu")
message = replacetextx(message, "'t", "")
message = replacetextx(message, "t ", "to ")
message = replacetextx(message, " I ", " ai ")
message = replacetextx(message, "th", "z")
message = replacetextx(message, "ish", "isu")
message = replacetextx(message, "is", "izu")
message = replacetextx(message, "ziz", "zis")
message = replacetextx(message, "se", "su")
message = replacetextx(message, "br", "bur")
message = replacetextx(message, "ry", "ri")
message = replacetextx(message, "you", "yuu")
message = replacetextx(message, "ck", "cku")
message = replacetextx(message, "eu", "uu")
message = replacetextx(message, "ow", "au")
message = replacetextx(message, "are", "aa")
message = replacetextx(message, "ay", "ayu")
message = replacetextx(message, "ea", "ii")
message = replacetextx(message, "ch", "chi")
message = replacetextx(message, "than", "sen")
message = replacetextx(message, ".", "")
message = lowertext(message)
*/
