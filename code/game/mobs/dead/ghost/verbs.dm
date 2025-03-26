GLOBAL_GLOBL_INIT(mouse_respawn_time, 5 MINUTES) // Amount of time that must pass between a player dying as a mouse and repawning as a mouse.

/mob/dead/ghost/verb/reenter_corpse()
	set category = PANEL_GHOST
	set name = "Re-enter Corpse"

	if(isnull(client))
		return
	if(isnull(mind?.current) || !can_reenter_corpse)
		to_chat(src, SPAN_WARNING("You have no body."))
		return
	if(isnotnull(mind.current.key) && copytext(mind.current.key, 1, 2) != "@")	//makes sure we don't accidentally kick any clients
		to_chat(src, SPAN_WARNING("Another consciousness is in your body... It is resisting you."))
		return
	if(ishuman(mind.current))
		var/mob/living/carbon/human/H = mind.current
		if(H.ajourn && H.stat != DEAD)	//check if the corpse is astral-journeying (it's client ghosted using a cultist rune).
			var/obj/effect/rune/R = locate() in H.loc	//whilst corpse is alive, we can only reenter the body if it's on the rune
			if(!(isnotnull(R) && R.word1 == cultwords["hell"] && R.word2 == cultwords["travel"] && R.word3 == cultwords["self"]))	//astral journeying rune
				to_chat(src, SPAN_WARNING("The astral cord that ties your body and your spirit has been severed. You are likely to wander the realm beyond until your body is finally dead and thus reunited with you."))
				return
		H.ajourn = FALSE

	// Ensures that the space parallax state updates if the ghost is in a different area to the body.
	var/area/mind_area = GET_AREA(mind.current)
	if(GET_AREA(src) != mind_area)
		mind.current.client.set_parallax_space(mind_area.parallax_type)

	mind.current.key = key

	return 1

/mob/dead/ghost/verb/toggle_medHUD()
	set category = PANEL_GHOST
	set name = "Toggle MedicHUD"
	set desc = "Toggles Medical HUD allowing you to see how everyone is doing"

	if(isnull(client))
		return

	medHUD = !medHUD
	to_chat(src, SPAN_INFO_B("Medical HUD [medHUD ? "Enabled" : "Disabled"]"))

/mob/dead/ghost/verb/toggle_antagHUD()
	set category = PANEL_GHOST
	set name = "Toggle AntagHUD"
	set desc = "Toggles AntagHUD allowing you to see who is the antagonist"

	if(isnull(client))
		return
	if(!CONFIG_GET(/decl/configuration_entry/antag_hud_allowed) && isnull(client.holder))
		to_chat(src, SPAN_WARNING("Admins have disabled this for this round."))
		return
	var/mob/dead/ghost/M = src
	if(jobban_isbanned(M, "AntagHUD"))
		to_chat(src, SPAN_DANGER("You have been banned from using this feature."))
		return
	if(CONFIG_GET(/decl/configuration_entry/antag_hud_restricted) && !M.has_enabled_antagHUD && isnull(client.holder))
		var/response = alert(src, "If you turn this on, you will not be able to take any part in the round.", "Are you sure you want to turn this feature on?", "Yes", "No")
		if(response == "No")
			return
		M.can_reenter_corpse = FALSE

	if(!M.has_enabled_antagHUD && isnull(client.holder))
		M.has_enabled_antagHUD = TRUE

	M.antagHUD = !M.antagHUD
	to_chat(src, SPAN_INFO_B("AntagHUD [M.antagHUD ? "Enabled" : "Disabled"]"))

/mob/dead/ghost/verb/follow()
	set category = PANEL_GHOST
	set name = "Follow" // "Haunt"
	set desc = "Follow and haunt a mob."

	var/list/mobs = getmobs()
	var/input = input("Please, select a mob!", "Haunt", null, null) as null|anything in mobs
	var/mob/target = mobs[input]
	ManualFollow(target)

/mob/dead/ghost/verb/jumptomob() // Moves the ghost instead of just changing the ghosts's eye -Nodrak
	set category = PANEL_GHOST
	set name = "Jump to Mob"
	set desc = "Teleport to a mob"

	if(isghost(usr)) // Make sure they're an observer!
		var/list/dest = list() // List of possible destinations (mobs)
		var/target = null // Chosen target.

		dest.Add(getmobs()) // Fill list, prompt user with list
		target = input("Please, select a player!", "Jump to Mob", null, null) as null|anything in dest

		if(isnull(target)) // Make sure we actually have a target
			return
		else
			var/mob/M = dest[target] // Destination mob
			var/mob/A = src			 // Source mob
			var/turf/T = GET_TURF(M) // Turf of the destination mob

			if(isturf(T))	// Make sure the turf exists, then move the source to that destination.
				A.forceMove(T)
			else
				to_chat(A, "This mob is not located in the game world.")

/*
/mob/dead/ghost/verb/boo()
	set category = PANEL_GHOST
	set name = "Boo!"
	set desc= "Scare your crew members because of boredom!"

	if(bootime > world.time) return
	var/obj/machinery/light/L = locate(/obj/machinery/light) in view(1, src)
	if(L)
		L.flicker()
		bootime = world.time + 600
		return
	//Maybe in the future we can add more <i>spooky</i> code here!
	return
*/

/mob/dead/ghost/verb/analyse_air()
	set category = PANEL_GHOST
	set name = "Analyse Air"

	if(!isghost(usr))
		return

	// Shamelessly copied from the Gas Analysers
	if(!isturf(usr.loc))
		return

	var/datum/gas_mixture/environment = usr.loc.return_air()

	var/pressure = environment.return_pressure()
	var/total_moles = environment.total_moles

	to_chat(src, SPAN_INFO_B("Results:"))
	if(abs(pressure - ONE_ATMOSPHERE) < 10)
		to_chat(src, SPAN_INFO("Pressure: [round(pressure, 0.1)] kPa"))
	else
		to_chat(src, SPAN_WARNING("Pressure: [round(pressure,0.1)] kPa"))
	if(total_moles)
		var/decl/xgm_gas_data/gas_data = GET_DECL_INSTANCE(/decl/xgm_gas_data)
		for(var/g in environment.gas)
			to_chat(src, SPAN_INFO("[gas_data.name[g]]: [round((environment.gas[g] / total_moles) * 100)]% ([round(environment.gas[g], 0.01)] moles)"))
		to_chat(src, SPAN_INFO("Temperature: [round(environment.temperature - T0C, 0.1)]&deg;C"))
		to_chat(src, SPAN_INFO("Heat Capacity: [round(environment.heat_capacity(), 0.1)]"))

/mob/dead/ghost/verb/toggle_darkness()
	set category = PANEL_GHOST
	set name = "Toggle Darkness"

	if(see_invisible == SEE_INVISIBLE_OBSERVER_NOLIGHTING)
		see_invisible = SEE_INVISIBLE_OBSERVER
	else
		see_invisible = SEE_INVISIBLE_OBSERVER_NOLIGHTING

/mob/dead/ghost/verb/become_mouse()
	set category = PANEL_GHOST
	set name = "Become Mouse"

	if(CONFIG_GET(/decl/configuration_entry/disable_player_mice))
		to_chat(src, SPAN_WARNING("Spawning as a mouse is currently disabled."))
		return

	var/mob/dead/ghost/M = usr
	if(CONFIG_GET(/decl/configuration_entry/antag_hud_restricted) && M.has_enabled_antagHUD)
		to_chat(src, SPAN_WARNING("antagHUD restrictions prevent you from spawning in as a mouse."))
		return

	var/time_difference = world.time - client.time_died_as_mouse
	if(client.time_died_as_mouse && time_difference <= GLOBL.mouse_respawn_time)
		var/time_difference_text = time2text(GLOBL.mouse_respawn_time - time_difference, "mm:ss")
		to_chat(src, SPAN_WARNING("You may only spawn again as a mouse more than [GLOBL.mouse_respawn_time / 600] minutes after your death. You have [time_difference_text] left."))
		return

	var/response = alert(src, "Are you -sure- you want to become a mouse?", "Are you sure you want to squeek?", "Squeek!", "Nope!")
	if(response != "Squeek!")
		return // Hit the wrong key...again.

	// Find a viable mouse candidate.
	var/mob/living/simple/mouse/host
	var/obj/machinery/atmospherics/unary/vent_pump/vent_found
	var/list/found_vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/v in GLOBL.machines)
		if(!v.welded && v.z == src.z)
			found_vents.Add(v)
	if(length(found_vents))
		vent_found = pick(found_vents)
		host = new /mob/living/simple/mouse(vent_found.loc)
	else
		to_chat(src, SPAN_WARNING("Unable to find any unwelded vents to spawn mice at."))

	if(isnotnull(host))
		if(CONFIG_GET(/decl/configuration_entry/uneducated_mice))
			host.universal_understand = FALSE
		host.ckey = src.ckey
		to_chat(host, SPAN_INFO("You are now a mouse. Try to avoid interaction with players, and do not give hints away that you are more than a simple rodent."))

/mob/dead/ghost/verb/view_manifest()
	set category = PANEL_GHOST
	set name = "View Crew Manifest"

	var/dat
	dat += "<h4>Crew Manifest</h4>"
	dat += GLOBL.data_core.get_manifest()

	src << browse(dat, "window=manifest;size=370x420;can_close=1")

// Used for drawing on walls with blood puddles as a spooky ghost.
/mob/dead/ghost/verb/bloody_doodle()
	set category = PANEL_GHOST
	set name = "Write in blood"
	set desc = "If the round is sufficiently spooky, write a short message in blood on the floor or a wall. Remember, no IC in OOC or OOC in IC."

	if(!CONFIG_GET(/decl/configuration_entry/cult_ghostwriter))
		to_chat(src, SPAN_WARNING("That verb is not currently permitted."))
		return

	if(!src.stat)
		return

	if(usr != src)
		return 0 //something is terribly wrong

	var/ghosts_can_write
	if(IS_GAME_MODE(/datum/game_mode/cult))
		var/datum/game_mode/cult/cult = global.PCticker.mode
		if(length(cult.cult) > CONFIG_GET(/decl/configuration_entry/cult_ghostwriter_req_cultists))
			ghosts_can_write = TRUE

	if(!ghosts_can_write)
		to_chat(src, SPAN_WARNING("The veil is not thin enough for you to do that."))
		return

	var/list/choices = list()
	for(var/obj/effect/decal/cleanable/blood/B in view(1, src))
		if(B.amount > 0)
			choices.Add(B)

	if(!length(choices))
		to_chat(src, SPAN_WARNING("There is no blood to use nearby."))
		return

	var/obj/effect/decal/cleanable/blood/choice = input(src,"What blood would you like to use?") in null|choices

	var/direction = input(src, "Which way?", "Tile selection") as anything in list("Here", "North", "South", "East", "West")
	var/turf/open/T = src.loc
	if(direction != "Here")
		T = get_step(T, text2dir(direction))

	if(!istype(T))
		to_chat(src, SPAN_WARNING("You cannot doodle there."))
		return

	if(isnull(choice) || choice.amount == 0 || !src.Adjacent(choice))
		return

	var/doodle_color = (choice.basecolor) ? choice.basecolor : "#A10808"

	var/num_doodles = 0
	for(var/obj/effect/decal/cleanable/blood/writing/W in T)
		num_doodles++
	if(num_doodles > 4)
		to_chat(src, SPAN_WARNING("There is no space to write on!"))
		return

	var/max_length = 50

	var/message = stripped_input(src, "Write a message. It cannot be longer than [max_length] characters.", "Blood writing", "")

	if(message)
		if(length(message) > max_length)
			message += "-"
			to_chat(src, SPAN_WARNING("You ran out of blood to write with!"))

		var/obj/effect/decal/cleanable/blood/writing/W = new /obj/effect/decal/cleanable/blood/writing(T)
		W.basecolor = doodle_color
		W.update_icon()
		W.message = message
		W.add_hiddenprint(src)
		W.visible_message(SPAN_WARNING("Invisible fingers crudely paint something in blood on [T]..."))

/mob/dead/ghost/verb/join_response_team()
	set category = PANEL_GHOST
	set name = "Join Emergency Response Team"

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
			var/mob/living/carbon/human/new_commando = client.create_response_team(L.loc, leader_selected, new_name)
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