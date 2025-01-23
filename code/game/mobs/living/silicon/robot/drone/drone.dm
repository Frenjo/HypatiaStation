/mob/living/silicon/robot/drone
	name = "drone"
	real_name = "drone"
	icon = 'icons/mob/silicon/robot/drone.dmi'
	icon_state = "repairbot"
	maxHealth = 35
	health = 35
	universal_speak = 0
	universal_understand = 1
	gender = NEUTER
	pass_flags = PASS_FLAG_TABLE
	braintype = "Robot"
	lawupdate = FALSE
	density = FALSE
	integrated_light_power = 3
	local_transmit = 1

	mob_bump_flag = SIMPLE_ANIMAL
	mob_swap_flags = SIMPLE_ANIMAL
	mob_push_flags = SIMPLE_ANIMAL
	mob_always_swap = 1

	// We need to keep track of a few module items so we don't need to do list operations
	// every time we need them. These get set in New() after the module is chosen.

	var/obj/item/stack/sheet/steel/cyborg/stack_metal = null
	var/obj/item/stack/sheet/wood/cyborg/stack_wood = null
	var/obj/item/stack/sheet/glass/cyborg/stack_glass = null
	var/obj/item/stack/sheet/plastic/cyborg/stack_plastic = null
	var/obj/item/matter_decompiler/decompiler = null

	// Used for self-mailing.
	var/mail_destination = 0

/mob/living/silicon/robot/drone/New()
	. = ..()

	verbs.Add(/mob/living/proc/ventcrawl)
	verbs.Add(/mob/living/proc/hide)

	remove_language("Robot Talk")
	add_language("Robot Talk", FALSE)
	add_language("Drone Talk")

	// They are unable to be upgraded, so let's give them a bit of a better battery.
	cell.maxcharge = 10000
	cell.charge = 10000

	// NO BRAIN.
	mmi = null

	// We need to screw with their HP a bit. They have around one fifth as much HP as a full borg.
	for(var/V in components) if(V != "power cell")
		var/datum/robot_component/C = components[V]
		C.max_damage = 10

	verbs.Remove(/mob/living/silicon/robot/verb/namepick)
	module = new /obj/item/robot_model/drone(src)

	// Grab stacks.
	stack_metal = locate(/obj/item/stack/sheet/steel/cyborg) in module
	stack_wood = locate(/obj/item/stack/sheet/wood/cyborg) in module
	stack_glass = locate(/obj/item/stack/sheet/glass/cyborg) in module
	stack_plastic = locate(/obj/item/stack/sheet/plastic/cyborg) in module

	// Grab decompiler.
	decompiler = locate(/obj/item/matter_decompiler) in module

	// Some tidying-up.
	flavor_text = "It's a tiny little repair drone. The casing is stamped with an NT log and the subscript: 'NanoTrasen Recursive Repair Systems: Fixing Tomorrow's Problem, Today!'"
	updatename()
	updateicon()

// Redefining some robot procs...
/mob/living/silicon/robot/drone/updatename()
	real_name = "maintenance drone ([rand(100, 999)])"
	name = real_name

/mob/living/silicon/robot/drone/updateicon()
	overlays.Cut()
	if(stat == CONSCIOUS)
		overlays.Add("eyes-[icon_state]")
	else
		overlays.Remove("eyes")

/mob/living/silicon/robot/drone/choose_icon()
	return

/mob/living/silicon/robot/drone/pick_module()
	return

// Sick of trying to get this to display properly without redefining it.
/mob/living/silicon/robot/drone/show_system_integrity()
	if(!stat)
		var/temphealth = health + 35 //Brings it to 0.
		if(temphealth < 0)
			temphealth = 0
		//Convert to percentage.
		temphealth = (temphealth / (maxHealth * 2)) * 100

		stat(null, text("System integrity: [temphealth]%"))
	else
		stat(null, text("Systems nonfunctional"))

/mob/living/silicon/robot/drone/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(isnull(client) || stat == DEAD)
		to_chat(user, SPAN_WARNING("There's not much point subverting this heap of junk."))
		return FALSE

	if(emagged)
		to_chat(src, SPAN_WARNING("[user] attempts to load subversive software into you, but your hacked subroutines ignore the attempt."))
		to_chat(user, SPAN_WARNING("You attempt to subvert [src], but the sequencer has no effect."))
		return FALSE

	to_chat(user, SPAN_WARNING("You swipe the sequencer across [src]'s interface and watch its eyes flicker."))
	to_chat(src, SPAN_WARNING("You feel a sudden burst of malware loaded into your execute-as-root buffer. Your tiny brain methodically parses, loads and executes the script."))

	var/time = time2text(world.realtime,"hh:mm:ss")
	GLOBL.lawchanges.Add("[time] <B>:</B> [user.name]([user.key]) emagged [name]([key])")
	message_admins("[key_name_admin(user)] emagged drone [key_name_admin(src)]. Laws overridden.")
	log_game("[key_name(user)] emagged drone [key_name(src)].  Laws overridden.")

	emagged = TRUE
	lawupdate = FALSE
	connected_ai = null
	clear_supplied_laws()
	clear_inherent_laws()
	laws = new /datum/ai_laws/syndicate_override
	set_zeroth_law("Only [user.real_name] and people he designates as being such are Syndicate Agents.")

	to_chat(src, "<b>Obey these laws:</b>")
	laws.show_laws(src)
	to_chat(src, SPAN_DANGER("ALERT: [user.real_name] is your new master. Obey your new laws and his commands."))
	return TRUE

/mob/living/silicon/robot/drone/attack_tool(obj/item/tool, mob/user)
	if(iscrowbar(tool))
		to_chat(user, SPAN_WARNING("The machine is hermetically sealed, you can't open the case."))
		return TRUE

	return ..()

// Drones cannot be upgraded with borg modules so we need to catch some items before they get used in ..().
/mob/living/silicon/robot/drone/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/borg/upgrade))
		to_chat(user, SPAN_WARNING("The maintenance drone chassis not compatible with \the [I]."))
		return TRUE

	if(istype(I, /obj/item/card/id) || istype(I, /obj/item/pda))
		if(stat == DEAD)
			to_chat(user, SPAN_WARNING("You swipe your ID card through [src], attempting to reboot it."))
			if(!CONFIG_GET(/decl/configuration_entry/allow_drone_spawn) || emagged || health < -35) // It's dead, Dave.
				to_chat(user, SPAN_WARNING("The interface is fried, and a distressing burnt smell wafts from the robot's interior. You're not rebooting this one."))
				return TRUE

			var/drones = 0
			for(var/mob/living/silicon/robot/drone/D in GLOBL.mob_list)
				if(D.key && isnotnull(D.client))
					drones++
			if(drones < CONFIG_GET(/decl/configuration_entry/max_maint_drones))
				request_player()
			return TRUE

		to_chat(src, SPAN_WARNING("[user] swipes an ID card through your card reader."))
		to_chat(user, SPAN_WARNING("You swipe your ID card through [src], attempting to shut it down."))

		if(emagged)
			return TRUE

		if(allowed(usr))
			shut_down()
			return TRUE

		return TRUE

	return ..()

// DRONE LIFE/DEATH

// For some goddamn reason robots have this hardcoded. Redefining it for our fragile friends here.
/mob/living/silicon/robot/drone/updatehealth()
	if(status_flags & GODMODE)
		health = 35
		stat = CONSCIOUS
		return
	health = 35 - (getBruteLoss() + getFireLoss())
	return

// Easiest to check this here, then check again in the robot proc.
//S tandard robots use config for crit, which is somewhat excessive for these guys.
// Drones killed by damage will gib.
/mob/living/silicon/robot/drone/handle_regular_status_updates()
	if(health <= -35 && stat != DEAD)
		gib()
		return
	..()

/mob/living/silicon/robot/drone/death(gibbed)
	if(isnotnull(module))
		var/obj/item/gripper/G = locate(/obj/item/gripper) in module
		if(isnotnull(G))
			G.drop_item()

	..(gibbed)

// DRONE MOVEMENT.
/mob/living/silicon/robot/drone/Process_Spaceslipping(prob_slip)
	//TODO: Consider making a magboot item for drones to equip. ~Z
	return 0

// CONSOLE PROCS
/mob/living/silicon/robot/drone/proc/law_resync()
	if(stat != DEAD)
		if(emagged)
			to_chat(src, SPAN_WARNING("You feel something attempting to modify your programming, but your hacked subroutines are unaffected."))
		else
			to_chat(src, SPAN_WARNING("A reset-to-factory directive packet filters through your data connection, and you obediently modify your programming to suit it."))
			full_law_reset()
			show_laws()

/mob/living/silicon/robot/drone/proc/shut_down()
	if(stat != DEAD)
		if(emagged)
			to_chat(src, SPAN_WARNING("You feel a system kill order percolate through your tiny brain, but it doesn't seem like a good idea to you."))
		else
			to_chat(src, SPAN_WARNING("You feel a system kill order percolate through your tiny brain, and you obediently destroy yourself."))
			death()

/mob/living/silicon/robot/drone/proc/full_law_reset()
	clear_supplied_laws()
	clear_inherent_laws()
	clear_ion_laws()
	laws = new /datum/ai_laws/drone()

// Reboot procs.
/mob/living/silicon/robot/drone/proc/request_player()
	for(var/mob/dead/ghost/O in GLOBL.player_list)
		if(jobban_isbanned(O, "Maintenance Drone"))
			continue
		if(O.client?.prefs.be_special & BE_PAI)
			question(O.client)

/mob/living/silicon/robot/drone/proc/question(client/C)
	spawn(0)
		if(isnull(C))
			return
		var/response = alert(C, "Someone is attempting to reboot a maintenance drone. Would you like to play as one?", "Maintenance drone reboot", "Yes", "No", "Never for this round.")
		if(isnull(C) || ckey)
			return
		if(response == "Yes")
			transfer_personality(C)
		else if(response == "Never for this round")
			C.prefs.be_special ^= BE_PAI

/mob/living/silicon/robot/drone/proc/transfer_personality(client/player)
	if(isnull(player))
		return

	ckey = player.ckey

	if(isnotnull(player.mob?.mind))
		player.mob.mind.transfer_to(src)

	emagged = FALSE
	lawupdate = FALSE
	to_chat(src, "<b>Systems rebooted</b>. Loading base pattern maintenance protocol... <b>loaded</b>.")
	full_law_reset()