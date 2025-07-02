/datum/mind/Topic(href, href_list)
	if(!check_rights(R_ADMIN))
		return

	if(href_list["role_edit"])
		var/new_role = input("Select new role", "Assigned role", assigned_role) as null | anything in GLOBL.all_jobs
		if(isnull(new_role))
			return
		assigned_role = new_role

	else if(href_list["memory_edit"])
		var/new_memo = copytext(sanitize(input("Write new memory", "Memory", memory) as null | message), 1, MAX_MESSAGE_LEN)
		if(isnull(new_memo))
			return
		memory = new_memo

	else if(href_list["obj_edit"] || href_list["obj_add"])
		var/datum/objective/objective
		var/objective_pos
		var/def_value

		if(href_list["obj_edit"])
			objective = locate(href_list["obj_edit"])
			if(!objective)
				return
			objective_pos = objectives.Find(objective)

			// Text strings are easy to manipulate. Revised for simplicity.
			var/temp_obj_type = "[objective.type]" // Convert path into a text string.
			def_value = copytext(temp_obj_type, 19) // Convert last part of path into an objective keyword.
			if(!def_value) // If it's a custom objective, it will be an empty string.
				def_value = "custom"

		var/new_obj_type = input("Select objective type:", "Objective type", def_value) as null | anything in list("assassinate", "debrain", "protect", "prevent", "harm", "brig", "hijack", "escape", "survive", "steal", "download", "nuclear", "capture", "absorb", "custom")
		if(isnull(new_obj_type))
			return

		var/datum/objective/new_objective = null

		switch(new_obj_type)
			if("assassinate", "protect", "debrain", "harm", "brig")
				// To determine what to name the objective in explanation text.
				var/objective_type_capital = uppertext(copytext(new_obj_type, 1, 2)) // Capitalize first letter.
				var/objective_type_text = copytext(new_obj_type, 2) // Leave the rest of the text.
				var/objective_type = "[objective_type_capital][objective_type_text]" // Add them together into a text string.

				var/list/possible_targets = list("Free objective")
				for_no_type_check(var/datum/mind/possible_target, global.PCticker.minds)
					if((possible_target != src) && ishuman(possible_target.current))
						possible_targets.Add(possible_target.current)

				var/mob/def_target = null
				var/list/objective_list = list(/datum/objective/assassinate, /datum/objective/protect, /datum/objective/debrain)
				if(objective && (objective.type in objective_list) && objective:target)
					var/datum/objective/objec = objective
					def_target = objec.target.current

				var/new_target = input("Select target:", "Objective target", def_target) as null|anything in possible_targets
				if(isnull(new_target))
					return

				var/objective_path = text2path("/datum/objective/[new_obj_type]")
				if(new_target == "Free objective")
					new_objective = new objective_path()
					new_objective.owner = src
					new_objective:target = null
					new_objective.explanation_text = "Free objective"
				else
					new_objective = new objective_path
					new_objective.owner = src
					new_objective:target = new_target:mind
					// Will display as special role if the target is set as MODE. Ninjas/commandos/nuke ops.
					new_objective.explanation_text = "[objective_type] [new_target:real_name], the [new_target:mind:assigned_role == "MODE" ? (new_target:mind:special_role) : (new_target:mind:assigned_role)]."

			if("prevent")
				new_objective = new /datum/objective/block()
				new_objective.owner = src

			if("hijack")
				new_objective = new /datum/objective/hijack()
				new_objective.owner = src

			if("escape")
				new_objective = new /datum/objective/escape()
				new_objective.owner = src

			if("survive")
				new_objective = new /datum/objective/survive()
				new_objective.owner = src

			if("nuclear")
				new_objective = new /datum/objective/nuclear()
				new_objective.owner = src

			if("steal")
				if(!istype(objective, /datum/objective/steal))
					new_objective = new /datum/objective/steal()
					new_objective.owner = src
				else
					new_objective = objective
				var/datum/objective/steal/steal = new_objective
				if(!steal.select_target())
					return

			if("download", "capture", "absorb")
				var/def_num
				if(objective?.type == text2path("/datum/objective/[new_obj_type]"))
					def_num = objective.target_amount

				var/target_number = input("Input target number:", "Objective", def_num) as num | null
				if(isnull(target_number)) // Ordinarily, you wouldn't need isnull. In this case, the value may already exist.
					return

				switch(new_obj_type)
					if("download")
						new_objective = new /datum/objective/download()
						new_objective.explanation_text = "Download [target_number] research levels."
					if("capture")
						new_objective = new /datum/objective/capture()
						new_objective.explanation_text = "Accumulate [target_number] capture points."
					if("absorb")
						new_objective = new /datum/objective/absorb()
						new_objective.explanation_text = "Absorb [target_number] compatible genomes."
				new_objective.owner = src
				new_objective.target_amount = target_number

			if("custom")
				var/expl = copytext(sanitize(input("Custom objective:", "Objective", objective ? objective.explanation_text : "") as text | null), 1, MAX_MESSAGE_LEN)
				if(isnull(expl))
					return
				new_objective = new /datum/objective()
				new_objective.owner = src
				new_objective.explanation_text = expl

		if(isnull(new_objective))
			return

		if(isnotnull(objective))
			objectives.Remove(objective)
			objectives.Insert(objective_pos, new_objective)
		else
			objectives.Add(new_objective)

	else if(href_list["obj_delete"])
		var/datum/objective/objective = locate(href_list["obj_delete"])
		if(!istype(objective))
			return
		objectives.Remove(objective)

	else if(href_list["obj_completed"])
		var/datum/objective/objective = locate(href_list["obj_completed"])
		if(!istype(objective))
			return
		objective.completed = !objective.completed

	else if(href_list["implant"])
		var/mob/living/carbon/human/H = current
		BITSET(H.hud_updateflag, IMPLOYAL_HUD)	// Updates that players HUD images so secHUD's pick up they are implanted or not.
		switch(href_list["implant"])
			if("shieldremove")
				for(var/obj/item/implant/mindshield/I in H.contents)
					for(var/datum/organ/external/organs in H.organs)
						if(I in organs.implants)
							qdel(I)
							break
				to_chat(H, SPAN_INFO_B("<font size=3>Your mindshield implant has been deactivated.</font>"))

			if("shieldadd")
				var/obj/item/implant/mindshield/shield = new/obj/item/implant/mindshield(H)
				shield.imp_in = H
				shield.implanted = 1
				var/datum/organ/external/affected = H.organs_by_name["head"]
				affected.implants.Add(shield)
				shield.part = affected
				to_chat(H, SPAN_DANGER("<font size=3>You have somehow become the recipient of a mindshield implant, and it just activated!</font>"))

			if("loyaltyremove")
				for(var/obj/item/implant/loyalty/I in H.contents)
					for(var/datum/organ/external/organs in H.organs)
						if(I in organs.implants)
							qdel(I)
							break
				to_chat(H, SPAN_INFO_B("<font size=3>Your loyalty implant has been deactivated.</font>"))

			if("loyaltyadd")
				var/obj/item/implant/loyalty/L = new/obj/item/implant/loyalty(H)
				L.imp_in = H
				L.implanted = 1
				var/datum/organ/external/affected = H.organs_by_name["head"]
				affected.implants.Add(L)
				L.part = affected

				to_chat(H, SPAN_DANGER("<font size=3>You have somehow become the recipient of a loyalty implant, and it just activated!</font>"))
				if(src in global.PCticker.mode.revolutionaries)
					special_role = null
					global.PCticker.mode.revolutionaries.Remove(src)
					to_chat(src, SPAN_DANGER("<font size=3>The nanobots in the loyalty implant remove all thoughts about being a revolutionary. Get back to work!</font>"))
				if(src in global.PCticker.mode.head_revolutionaries)
					special_role = null
					global.PCticker.mode.head_revolutionaries.Remove(src)
					to_chat(src, SPAN_DANGER("<font size=3>The nanobots in the loyalty implant remove all thoughts about being a revolutionary. Get back to work!</font>"))
				if(src in global.PCticker.mode.cult)
					global.PCticker.mode.cult.Remove(src)
					global.PCticker.mode.update_cult_icons_removed(src)
					special_role = null
					var/datum/game_mode/cult/cult = global.PCticker.mode
					if(istype(cult))
						cult.memoize_cult_objectives(src)
					to_chat(current, SPAN_DANGER("<font size=3>The nanobots in the loyalty implant remove all thoughts about being in a cult. Have a productive day!</font>"))
					memory = ""
				if(src in global.PCticker.mode.traitors)
					global.PCticker.mode.traitors.Remove(src)
					special_role = null
					to_chat(current, SPAN_DANGER("<font size=3>The nanobots in the loyalty implant remove all thoughts about being a traitor to NanoTrasen. Have a nice day!</font>"))
					log_admin("[key_name_admin(usr)] has de-traitor'ed [current].")

	else if(href_list["revolution"])
		BITSET(current.hud_updateflag, SPECIALROLE_HUD)
		switch(href_list["revolution"])
			if("clear")
				if(src in global.PCticker.mode.revolutionaries)
					global.PCticker.mode.revolutionaries.Remove(src)
					to_chat(current, SPAN_DANGER("<font size=3>You have been brainwashed! You are no longer a revolutionary!</font>"))
					global.PCticker.mode.update_rev_icons_removed(src)
					special_role = null
				if(src in global.PCticker.mode.head_revolutionaries)
					global.PCticker.mode.head_revolutionaries.Remove(src)
					to_chat(current, SPAN_DANGER("<font size=3>You have been brainwashed! You are no longer a head revolutionary!</font>"))
					global.PCticker.mode.update_rev_icons_removed(src)
					special_role = null
					current.verbs.Remove(/mob/living/carbon/human/proc/RevConvert)
				log_admin("[key_name_admin(usr)] has de-rev'ed [current].")

			if("rev")
				if(src in global.PCticker.mode.head_revolutionaries)
					global.PCticker.mode.head_revolutionaries.Remove(src)
					global.PCticker.mode.update_rev_icons_removed(src)
					to_chat(current, SPAN_DANGER("<font size=3>Revolution has been disappointed of your leader traits! You are a regular revolutionary now!</font>"))
				else if(!(src in global.PCticker.mode.revolutionaries))
					to_chat(current, SPAN_WARNING("<font size=3>You are now a revolutionary! Help your cause. Do not harm your fellow freedom fighters. You can identify your comrades by the red \"R\" icons, and your leaders by the blue \"R\" icons. Help them kill the heads to win the revolution!</font>"))
					FEEDBACK_ANTAGONIST_GREETING_GUIDE(current)
				else
					return
				global.PCticker.mode.revolutionaries.Add(src)
				global.PCticker.mode.update_rev_icons_added(src)
				special_role = "Revolutionary"
				log_admin("[key_name(usr)] has rev'ed [current].")

			if("headrev")
				if(src in global.PCticker.mode.revolutionaries)
					global.PCticker.mode.revolutionaries.Remove(src)
					global.PCticker.mode.update_rev_icons_removed(src)
					to_chat(current, SPAN_DANGER("<font size=3>You have proved your devotion to revoltion! You are a head revolutionary now!</font>"))
					FEEDBACK_ANTAGONIST_GREETING_GUIDE(current)
				else if(!(src in global.PCticker.mode.head_revolutionaries))
					to_chat(current, SPAN_INFO("You are a member of the revolutionaries' leadership now!"))
				else
					return
				if(length(global.PCticker.mode.head_revolutionaries))
					// copy targets
					var/datum/mind/valid_head = locate() in global.PCticker.mode.head_revolutionaries
					if(isnotnull(valid_head))
						for(var/datum/objective/mutiny/O in valid_head.objectives)
							var/datum/objective/mutiny/rev_obj = new /datum/objective/mutiny()
							rev_obj.owner = src
							rev_obj.target = O.target
							rev_obj.explanation_text = "Assassinate [O.target.name], the [O.target.assigned_role]."
							objectives.Add(rev_obj)
						global.PCticker.mode.greet_revolutionary(src, 0)
				current.verbs.Add(/mob/living/carbon/human/proc/RevConvert)
				global.PCticker.mode.head_revolutionaries.Add(src)
				global.PCticker.mode.update_rev_icons_added(src)
				special_role = "Head Revolutionary"
				log_admin("[key_name_admin(usr)] has head-rev'ed [current].")

			if("autoobjectives")
				global.PCticker.mode.forge_revolutionary_objectives(src)
				global.PCticker.mode.greet_revolutionary(src, 0)
				to_chat(usr, SPAN_INFO("The objectives for revolution have been generated and shown to [key]."))

			if("flash")
				if(!global.PCticker.mode.equip_revolutionary(current))
					to_chat(usr, SPAN_WARNING("Spawning flash failed!"))

			if("takeflash")
				var/list/L = current.get_contents()
				var/obj/item/flash/flash = locate() in L
				if(isnull(flash))
					to_chat(usr, SPAN_WARNING("Deleting flash failed!"))
				qdel(flash)

			if("repairflash")
				var/list/L = current.get_contents()
				var/obj/item/flash/flash = locate() in L
				if(isnull(flash))
					to_chat(usr, SPAN_WARNING("Repairing flash failed!"))
				else
					flash.broken = 0

			if("reequip")
				var/list/L = current.get_contents()
				var/obj/item/flash/flash = locate() in L
				qdel(flash)
				take_uplink()
				var/fail = FALSE
				fail |= !global.PCticker.mode.equip_traitor(current, 1)
				fail |= !global.PCticker.mode.equip_revolutionary(current)
				if(fail)
					to_chat(usr, SPAN_WARNING("Re-equipping revolutionary goes wrong!"))

	else if(href_list["cult"])
		BITSET(current.hud_updateflag, SPECIALROLE_HUD)
		switch(href_list["cult"])
			if("clear")
				if(src in global.PCticker.mode.cult)
					global.PCticker.mode.cult.Remove(src)
					global.PCticker.mode.update_cult_icons_removed(src)
					special_role = null
					var/datum/game_mode/cult/cult = global.PCticker.mode
					if(istype(cult))
						if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
							cult.memoize_cult_objectives(src)
					to_chat(current, SPAN_DANGER("<font size=3>You have been brainwashed! You are no longer a cultist!</font>"))
					memory = ""
					log_admin("[key_name_admin(usr)] has de-cult'ed [current].")
			if("cultist")
				if(!(src in global.PCticker.mode.cult))
					global.PCticker.mode.cult.Add(src)
					global.PCticker.mode.update_cult_icons_added(src)
					special_role = "Cultist"
					to_chat(current, "<font color=\"purple\"><b><i>You catch a glimpse of the Realm of Nar-Sie, The Geometer of Blood. You now see how flimsy the world is, you see that it should be open to the knowledge of Nar-Sie.</b></i></font>")
					to_chat(current, "<font color=\"purple\"><b><i>Assist your new compatriots in their dark dealings. Their goal is yours, and yours is theirs. You serve the Dark One above all else. Bring It back.</b></i></font>")
					FEEDBACK_ANTAGONIST_GREETING_GUIDE(current)
					var/datum/game_mode/cult/cult = global.PCticker.mode
					if(istype(cult))
						if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
							cult.memoize_cult_objectives(src)
					log_admin("[key_name_admin(usr)] has cult'ed [current].")
			if("tome")
				var/mob/living/carbon/human/H = current
				if(istype(H))
					var/obj/item/tome/T = new(H)

					var/list/slots = list (
						"backpack" = SLOT_ID_IN_BACKPACK,
						"left pocket" = SLOT_ID_L_POCKET,
						"right pocket" = SLOT_ID_R_POCKET,
						"left hand" = SLOT_ID_L_HAND,
						"right hand" = SLOT_ID_R_HAND,
					)
					var/where = H.equip_in_one_of_slots(T, slots)
					if(isnull(where))
						to_chat(usr, SPAN_WARNING("Spawning tome failed!"))
					else
						to_chat(H, "A tome, a message from your new master, appears in your [where].")

			if("amulet")
				if(!global.PCticker.mode.equip_cultist(current))
					to_chat(usr, SPAN_WARNING("Spawning amulet failed!"))

	else if(href_list["wizard"])
		BITSET(current.hud_updateflag, SPECIALROLE_HUD)
		switch(href_list["wizard"])
			if("clear")
				if(src in global.PCticker.mode.wizards)
					global.PCticker.mode.wizards.Remove(src)
					special_role = null
					current.spellremove(current, CONFIG_GET(/decl/configuration_entry/feature_object_spell_system) ? "object": "verb")
					to_chat(current, SPAN_DANGER("<font size=3>You have been brainwashed! You are no longer a wizard!</font>"))
					log_admin("[key_name_admin(usr)] has de-wizard'ed [current].")
			if("wizard")
				if(!(src in global.PCticker.mode.wizards))
					global.PCticker.mode.wizards.Add(src)
					special_role = "Wizard"
					//ticker.mode.learn_basic_spells(current)
					to_chat(current, SPAN_DANGER("You are the Space Wizard!"))
					FEEDBACK_ANTAGONIST_GREETING_GUIDE(current)
					log_admin("[key_name_admin(usr)] has wizard'ed [current].")
			if("lair")
				current.forceMove(pick(GLOBL.wizardstart))
			if("dressup")
				global.PCticker.mode.equip_wizard(current)
			if("name")
				global.PCticker.mode.name_wizard(current)
			if("autoobjectives")
				if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
					global.PCticker.mode.forge_wizard_objectives(src)
					to_chat(usr, SPAN_INFO("The objectives for wizard [key] have been generated. You can edit them and anounce manually."))

	else if(href_list["changeling"])
		BITSET(current.hud_updateflag, SPECIALROLE_HUD)
		switch(href_list["changeling"])
			if("clear")
				if(src in global.PCticker.mode.changelings)
					global.PCticker.mode.changelings.Remove(src)
					special_role = null
					current.remove_changeling_powers()
					current.verbs.Remove(/datum/changeling/proc/EvolutionMenu)
					if(isnotnull(changeling))
						qdel(changeling)
					to_chat(current, SPAN_DANGER("<font size=3>You grow weak and lose your powers! You are no longer a changeling and are stuck in your current form!</font>"))
					log_admin("[key_name_admin(usr)] has de-changeling'ed [current].")
			if("changeling")
				if(!(src in global.PCticker.mode.changelings))
					global.PCticker.mode.changelings.Add(src)
					global.PCticker.mode.grant_changeling_powers(current)
					special_role = "Changeling"
					to_chat(current, SPAN_DANGER("Your powers are awoken. A flash of memory returns to us... we are a changeling!"))
					if(CONFIG_GET(/decl/configuration_entry/objectives_disabled))
						FEEDBACK_ANTAGONIST_GREETING_GUIDE(current)
					log_admin("[key_name_admin(usr)] has changeling'ed [current].")
			if("autoobjectives")
				if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
					global.PCticker.mode.forge_changeling_objectives(src)
				to_chat(usr, SPAN_INFO("The objectives for changeling [key] have been generated. You can edit them and anounce manually."))

			if("initialdna")
				if(isnull(changeling) || !length(changeling.absorbed_dna))
					to_chat(usr, SPAN_WARNING("Resetting DNA failed!"))
				else
					current.dna = changeling.absorbed_dna[1]
					current.real_name = current.dna.real_name
					current.UpdateAppearance()
					domutcheck(current, null)

	else if(href_list["nuclear"])
		var/mob/living/carbon/human/H = current
		BITSET(current.hud_updateflag, SPECIALROLE_HUD)
		switch(href_list["nuclear"])
			if("clear")
				if(src in global.PCticker.mode.syndicates)
					global.PCticker.mode.syndicates.Remove(src)
					global.PCticker.mode.update_synd_icons_removed(src)
					special_role = null
					for(var/datum/objective/nuclear/O in objectives)
						objectives.Remove(O)
					to_chat(current, SPAN_DANGER("<font size=3>You have been brainwashed! You are no longer a Syndicate operative!</font>"))
					log_admin("[key_name_admin(usr)] has de-nuke op'ed [current].")
			if("nuclear")
				if(!(src in global.PCticker.mode.syndicates))
					global.PCticker.mode.syndicates.Add(src)
					global.PCticker.mode.update_synd_icons_added(src)
					if(length(global.PCticker.mode.syndicates) == 1)
						global.PCticker.mode.prepare_syndicate_leader(src)
					else
						current.real_name = "[syndicate_name()] Operative #[length(global.PCticker.mode.syndicates) - 1]"
					special_role = "Syndicate"
					to_chat(current, SPAN_INFO("You are a [syndicate_name()] agent!"))
					if(CONFIG_GET(/decl/configuration_entry/objectives_disabled))
						FEEDBACK_ANTAGONIST_GREETING_GUIDE(current)
					else
						global.PCticker.mode.forge_syndicate_objectives(src)
					global.PCticker.mode.greet_syndicate(src)
					log_admin("[key_name_admin(usr)] has nuke op'ed [current].")
			if("lair")
				current.forceMove(GET_TURF(locate("landmark*Syndicate-Spawn")))
			if("dressup")
				qdel(H.belt)
				qdel(H.back)
				qdel(H.l_ear)
				qdel(H.r_ear)
				qdel(H.gloves)
				qdel(H.head)
				qdel(H.shoes)
				qdel(H.id_store)
				qdel(H.wear_suit)
				qdel(H.wear_uniform)

				if(!H.equip_outfit(/decl/hierarchy/outfit/syndicate/nuclear))
					to_chat(usr, SPAN_WARNING("Equipping a Syndicate failed!"))
			if("tellcode")
				var/code
				for_no_type_check(var/obj/machinery/nuclearbomb/bombue, GET_MACHINES_TYPED(/obj/machinery/nuclearbomb))
					if(length(bombue.r_code) <= 5 && bombue.r_code != "LOLNO" && bombue.r_code != "ADMIN")
						code = bombue.r_code
						break
				if(code)
					store_memory("<B>Syndicate Nuclear Bomb Code</B>: [code]", 0, 0)
					to_chat(current, "The nuclear authorisation code is: <B>[code]</B>.")
				else
					to_chat(usr, SPAN_WARNING("No valid nuke found!"))

	else if(href_list["traitor"])
		BITSET(current.hud_updateflag, SPECIALROLE_HUD)
		switch(href_list["traitor"])
			if("clear")
				if(src in global.PCticker.mode.traitors)
					global.PCticker.mode.traitors.Remove(src)
					special_role = null
					to_chat(current, SPAN_DANGER("<font size=3>You have been brainwashed! You are no longer a traitor!</font>"))
					log_admin("[key_name_admin(usr)] has de-traitor'ed [current].")
					if(isAI(current))
						var/mob/living/silicon/ai/A = current
						A.set_zeroth_law("")
						A.show_laws()

			if("traitor")
				if(!(src in global.PCticker.mode.traitors))
					global.PCticker.mode.traitors.Add(src)
					special_role = "traitor"
					to_chat(current, SPAN_DANGER("You are a traitor!"))
					log_admin("[key_name_admin(usr)] has traitor'ed [current].")
					if(CONFIG_GET(/decl/configuration_entry/objectives_disabled))
						FEEDBACK_ANTAGONIST_GREETING_GUIDE(current)
					if(issilicon(current))
						var/mob/living/silicon/A = current
						call(/datum/game_mode/proc/add_law_zero)(A)
						A.show_laws()

			if("autoobjectives")
				if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
					global.PCticker.mode.forge_traitor_objectives(src)
					to_chat(usr, SPAN_INFO("The objectives for traitor [key] have been generated. You can edit them and anounce manually."))

	else if(href_list["monkey"])
		var/mob/living/L = current
		if(L.monkeyizing)
			return
		switch(href_list["monkey"])
			if("healthy")
				if(usr.client.holder.rights & R_ADMIN)
					var/mob/living/carbon/human/H = current
					var/mob/living/carbon/monkey/M = current
					if(istype(H))
						log_admin("[key_name(usr)] attempting to monkeyize [key_name(current)].")
						message_admins(SPAN_INFO("[key_name_admin(usr)] attempting to monkeyize [key_name_admin(current)]."))
						qdel(src)
						M = H.monkeyize()
						src = M.mind
						//to_world("DEBUG: \"healthy\": M=[M], M.mind=[M.mind], src=[src]!")
					else if(istype(M) && length(M.viruses))
						for(var/datum/disease/D in M.viruses)
							D.cure(0)
						sleep(0) //because deleting of virus is done through spawn(0)
			if("infected")
				if(usr.client.holder.rights & R_ADMIN)
					var/mob/living/carbon/human/H = current
					var/mob/living/carbon/monkey/M = current
					if(istype(H))
						log_admin("[key_name(usr)] attempting to monkeyize and infect [key_name(current)].")
						message_admins(SPAN_INFO("[key_name_admin(usr)] attempting to monkeyize and infect [key_name_admin(current)]."), 1)
						qdel(src)
						M = H.monkeyize()
						src = M.mind
						current.contract_disease(new /datum/disease/jungle_fever, 1, 0)
					else if(istype(M))
						current.contract_disease(new /datum/disease/jungle_fever, 1, 0)
			if("human")
				var/mob/living/carbon/monkey/M = current
				if(istype(M))
					for(var/datum/disease/D in M.viruses)
						if(istype(D, /datum/disease/jungle_fever))
							D.cure(0)
							sleep(0) //because deleting of virus is doing throught spawn(0)
					log_admin("[key_name(usr)] attempting to humanize [key_name(current)].")
					message_admins(SPAN_INFO("[key_name_admin(usr)] attempting to humanize [key_name_admin(current)]."))
					var/obj/item/dnainjector/m2h/m2h = new
					var/obj/item/implant/mobfinder = new(M) //hack because humanizing deletes mind --rastaf0
					qdel(src)
					m2h.inject(M)
					src = mobfinder.loc:mind
					qdel(mobfinder)
					current.radiation -= 50

	else if(href_list["silicon"])
		BITSET(current.hud_updateflag, SPECIALROLE_HUD)
		switch(href_list["silicon"])
			if("unmalf")
				if(src in global.PCticker.mode.malf_ai)
					global.PCticker.mode.malf_ai.Remove(src)
					special_role = null

					var/mob/living/silicon/ai/malf = src.current
					malf.verbs.Remove(
						/mob/living/silicon/ai/proc/choose_modules,
						/datum/game_mode/malfunction/proc/takeover,
						/datum/game_mode/malfunction/proc/ai_win,
						/client/proc/fireproof_core,
						/client/proc/upgrade_turrets,
						/client/proc/disable_rcd,
						/client/proc/overload_machine,
						/client/proc/blackout,
						/client/proc/interhack,
						/client/proc/reactivate_camera
					)

					malf.laws = new /datum/ai_laws/nanotrasen()
					qdel(malf.malf_picker)
					malf.show_laws()
					current.icon_state = "ai"

					to_chat(current, SPAN_DANGER("<font size=3>You have been patched! You are no longer malfunctioning!</font>"))
					log_admin("[key_name_admin(usr)] has de-malf'ed [current].")

			if("malf")
				make_ai_malfunction()
				log_admin("[key_name_admin(usr)] has malf'ed [current].")

			if("unemag")
				var/mob/living/silicon/robot/robby = current
				if(istype(robby))
					robby.unemag()
					log_admin("[key_name_admin(usr)] has unemag'ed [robby].")

			if("unemagcyborgs")
				if(isAI(current))
					var/mob/living/silicon/ai/ai = current
					for(var/mob/living/silicon/robot/robby in ai.connected_robots)
						robby.unemag()
					log_admin("[key_name_admin(usr)] has unemag'ed [ai]'s Cyborgs.")

	else if(href_list["common"])
		switch(href_list["common"])
			if("undress")
				for(var/obj/item/W in current)
					current.drop_from_inventory(W)
			if("takeuplink")
				take_uplink()
				memory = null // Remove any memory they may have had.
			if("crystals")
				if(usr.client.holder.rights & R_FUN)
					var/obj/item/uplink/hidden/suplink = find_syndicate_uplink()
					var/crystals = suplink?.uses
					crystals = input("Amount of telecrystals for [key]", "Syndicate uplink", crystals) as null | num
					if(isnotnull(crystals))
						suplink?.uses = crystals
			if("uplink")
				if(!global.PCticker.mode.equip_traitor(current, !(src in global.PCticker.mode.traitors)))
					to_chat(usr, SPAN_WARNING("Equipping a Syndicate failed!"))

	else if(href_list["obj_announce"])
		var/obj_count = 1
		to_chat(current, SPAN_INFO("Your current objectives:"))
		for(var/datum/objective/objective in objectives)
			to_chat(current, "<B>Objective #[obj_count]</B>: [objective.explanation_text]")
			obj_count++

	edit_memory()