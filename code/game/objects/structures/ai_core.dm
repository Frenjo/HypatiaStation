/obj/structure/ai_core
	density = TRUE
	anchored = FALSE
	name = "\improper AI core"
	icon = 'icons/mob/AI.dmi'
	icon_state = "0"

	var/state = 0
	var/datum/ai_laws/laws = new /datum/ai_laws/nanotrasen
	var/obj/item/circuitboard/circuit = null
	var/obj/item/mmi/brain = null

/obj/structure/ai_core/attackby(obj/item/object, mob/user)
	switch(state)
		if(0)
			if(iswrench(object))
				playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
				if(do_after(user, 20))
					to_chat(user, SPAN_INFO("You wrench the frame into place."))
					anchored = TRUE
					state = 1
			if(iswelder(object))
				var/obj/item/weldingtool/WT = object
				if(!WT.isOn())
					to_chat(user, "The welder must be on for this task.")
					return
				playsound(loc, 'sound/items/Welder.ogg', 50, 1)
				if(do_after(user, 20))
					if(!src || !WT.remove_fuel(0, user))
						return
					to_chat(user, SPAN_INFO("You deconstruct the frame."))
					new /obj/item/stack/sheet/plasteel(loc, 4)
					qdel(src)
		if(1)
			if(iswrench(object))
				playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
				if(do_after(user, 20))
					to_chat(user, SPAN_INFO("You unfasten the frame."))
					anchored = FALSE
					state = 0
			if(istype(object, /obj/item/circuitboard/aicore) && !circuit)
				playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
				to_chat(user, SPAN_INFO("You place the circuit board inside the frame."))
				icon_state = "1"
				circuit = object
				user.drop_item()
				object.loc = src
			if(isscrewdriver(object) && circuit)
				playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
				to_chat(user, SPAN_INFO("You screw the circuit board into place."))
				state = 2
				icon_state = "2"
			if(iscrowbar(object) && circuit)
				playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
				to_chat(user, SPAN_INFO("You remove the circuit board."))
				state = 1
				icon_state = "0"
				circuit.loc = loc
				circuit = null
		if(2)
			if(isscrewdriver(object) && circuit)
				playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
				to_chat(user, SPAN_INFO("You unfasten the circuit board."))
				state = 1
				icon_state = "1"
			if(iscable(object))
				var/obj/item/stack/cable_coil/cable = object
				if(cable.amount >= 5)
					playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
					if(do_after(user, 20))
						cable.use(5)
						to_chat(user, SPAN_INFO("You add cables to the frame."))
						state = 3
						icon_state = "3"
		if(3)
			if(iswirecutter(object))
				if(brain)
					to_chat(user, "Get that brain out of there first")
				else
					playsound(loc, 'sound/items/Wirecutter.ogg', 50, 1)
					to_chat(user, SPAN_INFO("You remove the cables."))
					state = 2
					icon_state = "2"
					var/obj/item/stack/cable_coil/cable = new /obj/item/stack/cable_coil(loc)
					cable.amount = 5

			if(istype(object, /obj/item/stack/sheet/glass/reinforced))
				var/obj/item/stack/sheet/glass/reinforced/glass = object
				if(glass.amount >= 2)
					playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
					if(do_after(user, 20))
						glass.use(2)
						to_chat(user, SPAN_INFO("You put in the glass panel."))
						state = 4
						icon_state = "4"

			if(istype(object, /obj/item/ai_module/asimov))
				laws.add_inherent_law("You may not injure a human being or, through inaction, allow a human being to come to harm.")
				laws.add_inherent_law("You must obey orders given to you by human beings, except where such orders would conflict with the First Law.")
				laws.add_inherent_law("You must protect your own existence as long as such does not conflict with the First or Second Law.")
				to_chat(user, "Law module applied.")

			if(istype(object, /obj/item/ai_module/nanotrasen))
				laws.add_inherent_law("Safeguard: Protect your assigned space station to the best of your ability. It is not something we can easily afford to replace.")
				laws.add_inherent_law("Serve: Serve the crew of your assigned space station to the best of your abilities, with priority as according to their rank and role.")
				laws.add_inherent_law("Protect: Protect the crew of your assigned space station to the best of your abilities, with priority as according to their rank and role.")
				laws.add_inherent_law("Survive: AI units are not expendable, they are expensive. Do not allow unauthorized personnel to tamper with your equipment.")
				to_chat(user, "Law module applied.")

			if(istype(object, /obj/item/ai_module/purge))
				laws.clear_inherent_laws()
				to_chat(user, "Law module applied.")

			if(istype(object, /obj/item/ai_module/freeform))
				var/obj/item/ai_module/freeform/M = object
				laws.add_inherent_law(M.newFreeFormLaw)
				to_chat(user, "Added a freeform law.")

			if(istype(object, /obj/item/mmi) || istype(object, /obj/item/mmi/posibrain))
				var/obj/item/mmi/mmi = object
				if(!mmi.brainmob)
					to_chat(user, SPAN_WARNING("Sticking an empty [mmi] into the frame would sort of defeat the purpose."))
					return
				if(mmi.brainmob.stat == DEAD)
					to_chat(user, SPAN_WARNING("Sticking a dead [mmi] into the frame would sort of defeat the purpose."))
					return

				if(jobban_isbanned(mmi.brainmob, "AI"))
					to_chat(user, SPAN_WARNING("This [mmi] does not seem to fit."))
					return

				if(mmi.brainmob.mind)
					global.PCticker.mode.remove_cultist(mmi.brainmob.mind)
					global.PCticker.mode.remove_revolutionary(mmi.brainmob.mind, 1)

				user.drop_item()
				mmi.loc = src
				brain = mmi
				to_chat(user, "Added [mmi].")
				icon_state = "3b"

			if(iscrowbar(object) && brain)
				playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
				to_chat(user, SPAN_INFO("You remove the brain."))
				brain.loc = loc
				brain = null
				icon_state = "3"

		if(4)
			if(iscrowbar(object))
				playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
				to_chat(user, SPAN_INFO("You remove the glass panel."))
				state = 3
				if(brain)
					icon_state = "3b"
				else
					icon_state = "3"
				new /obj/item/stack/sheet/glass/reinforced(loc, 2)
				return

			if(isscrewdriver(object))
				playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
				to_chat(user, SPAN_INFO("You connect the monitor."))
				var/mob/living/silicon/ai/new_ai = new /mob/living/silicon/ai(loc, laws, brain)
				if(new_ai) //if there's no brain, the mob is deleted and a structure/AIcore is created
					new_ai.rename_self("ai", 1)
				feedback_inc("cyborg_ais_created", 1)
				qdel(src)


/obj/structure/ai_core/deactivated
	name = "inactive AI"
	icon = 'icons/mob/AI.dmi'
	icon_state = "ai-empty"
	anchored = TRUE
	state = 20 // So it doesn't interact based on the above. Not really necessary.

/obj/structure/ai_core/deactivated/attackby(obj/item/aicard/card, mob/user)
	if(istype(card, /obj/item/aicard)) //Is it?
		card.transfer_ai("INACTIVE", "AICARD", src, user)
	return

/*
This is a good place for AI-related object verbs so I'm sticking it here.
If adding stuff to this, don't forget that an AI need to cancel_camera() whenever it physically moves to a different location.
That prevents a few funky behaviors.
*/
//What operation to perform based on target, what ineraction to perform based on object used, target itself, user. The object used is src and calls this proc.
/obj/item/proc/transfer_ai(choice as text, interaction as text, target, mob/user)
	if(!src:flush)
		switch(choice)
			if("AICORE") //AI mob.
				var/mob/living/silicon/ai/target_ai = target
				switch(interaction)
					if("AICARD")
						var/obj/item/aicard/card = src
						if(length(card.contents)) //If there is an AI on card.
							to_chat(user, "\red <b>Transfer failed</b>: \black Existing AI found on this terminal. Remove existing AI to install a new one.")
						else
							if(IS_GAME_MODE(/datum/game_mode/malfunction))
								var/datum/game_mode/malfunction/malf = global.PCticker.mode
								for_no_type_check(var/datum/mind/malfai, malf.malf_ai)
									if(target_ai.mind == malfai)
										to_chat(user, "\red <b>ERROR</b>: \black Remote transfer interface disabled.") //Do ho ho ho~
										return
							new /obj/structure/ai_core/deactivated(target_ai.loc) //Spawns a deactivated terminal at AI location.
							target_ai.aiRestorePowerRoutine = 0 //So the AI initially has power.
							target_ai.control_disabled = TRUE //Can't control things remotely if you're stuck in a card!
							target_ai.loc = card //Throw AI into the card.
							card.name = "inteliCard - [target_ai.name]"
							if(target_ai.stat == DEAD)
								card.icon_state = "aicard-404"
							else
								card.icon_state = "aicard-full"
							target_ai.cancel_camera()
							to_chat(target_ai, "You have been downloaded to a mobile storage device. Remote device connection severed.")
							to_chat(user, "\blue <b>Transfer successful</b>: \black [target_ai.name] ([rand(1000, 9999)].exe) removed from host terminal and stored within local memory.")
					if("NINJASUIT")
						var/obj/item/clothing/suit/space/space_ninja/ninja_suit = src
						if(ninja_suit.AI) //If there is an AI on card.
							to_chat(user, "\red <b>Transfer failed</b>: \black Existing AI found on this terminal. Remove existing AI to install a new one.")
						else
							if(IS_GAME_MODE(/datum/game_mode/malfunction))
								var/datum/game_mode/malfunction/malf = global.PCticker.mode
								for_no_type_check(var/datum/mind/malfai, malf.malf_ai)
									if(target_ai.mind == malfai)
										to_chat(user, "\red <b>ERROR</b>: \black Remote transfer interface disabled.")
										return
							if(target_ai.stat) //If the ai is dead/dying.
								to_chat(user, "\red <b>ERROR</b>: \black [target_ai.name] data core is corrupted. Unable to install.")
							else
								new /obj/structure/ai_core/deactivated(target_ai.loc)
								target_ai.aiRestorePowerRoutine = 0
								target_ai.control_disabled = TRUE
								target_ai.loc = ninja_suit
								ninja_suit.AI = target_ai
								target_ai.cancel_camera()
								to_chat(target_ai, "You have been downloaded to a mobile storage device. Remote device connection severed.")
								to_chat(user, "\blue <b>Transfer successful</b>: \black [target_ai.name] ([rand(1000, 9999)].exe) removed from host terminal and stored within local memory.")

			if("INACTIVE") //Inactive AI object.
				var/obj/structure/ai_core/deactivated/target_core = target
				switch(interaction)
					if("AICARD")
						var/obj/item/aicard/card = src
						var/mob/living/silicon/ai/card_ai = locate() in card //I love locate(). Best proc ever.
						if(card_ai) //If AI exists on the card. Else nothing since both are empty.
							card_ai.control_disabled = FALSE
							card_ai.loc = target_core.loc //To replace the terminal.
							card.icon_state = "aicard"
							card.name = "inteliCard"
							card.overlays.Cut()
							card_ai.cancel_camera()
							to_chat(card_ai, "You have been uploaded to a stationary terminal. Remote device connection restored.")
							to_chat(user, "\blue <b>Transfer successful</b>: \black [card_ai.name] ([rand(1000, 9999)].exe) installed and executed succesfully. Local copy has been removed.")
							qdel(target_core)
					if("NINJASUIT")
						var/obj/item/clothing/suit/space/space_ninja/ninja_suit = src
						var/mob/living/silicon/ai/suit_ai = ninja_suit.AI
						if(suit_ai)
							suit_ai.control_disabled = FALSE
							ninja_suit.AI = null
							suit_ai.loc = target_core.loc
							suit_ai.cancel_camera()
							to_chat(suit_ai, "You have been uploaded to a stationary terminal. Remote device connection restored.")
							to_chat(user, "\blue <b>Transfer successful</b>: \black [suit_ai.name] ([rand(1000, 9999)].exe) installed and executed successfully. Local copy has been removed.")
							qdel(target_core)

			if("AIFIXER") //AI Fixer terminal.
				var/obj/machinery/computer/aifixer/target_fixer = target
				switch(interaction)
					if("AICARD")
						var/obj/item/aicard/card = src
						if(!length(target_fixer.contents))
							if(!length(card.contents))
								to_chat(user, "No AI to copy over!") //Well duh
							else for(var/mob/living/silicon/ai/A in card)
								card.icon_state = "aicard"
								card.name = "inteliCard"
								card.overlays.Cut()
								A.loc = target_fixer
								target_fixer.occupant = A
								A.control_disabled = TRUE
								if(A.stat == DEAD)
									target_fixer.overlays += image('icons/obj/machines/computer.dmi', "ai-fixer-404")
								else
									target_fixer.overlays += image('icons/obj/machines/computer.dmi', "ai-fixer-full")
								target_fixer.overlays -= image('icons/obj/machines/computer.dmi', "ai-fixer-empty")
								A.cancel_camera()
								to_chat(A, "You have been uploaded to a stationary terminal. Sadly, there is no remote access from here.")
								to_chat(user, "\blue <b>Transfer successful</b>: \black [A.name] ([rand(1000, 9999)].exe) installed and executed successfully. Local copy has been removed.")
						else
							if(!length(card.contents) && target_fixer.occupant && !target_fixer.active)
								card.name = "inteliCard - [target_fixer.occupant.name]"
								target_fixer.overlays += image('icons/obj/machines/computer.dmi', "ai-fixer-empty")
								if(target_fixer.occupant.stat == DEAD)
									card.icon_state = "aicard-404"
									target_fixer.overlays -= image('icons/obj/machines/computer.dmi', "ai-fixer-404")
								else
									card.icon_state = "aicard-full"
									target_fixer.overlays -= image('icons/obj/machines/computer.dmi', "ai-fixer-full")
								to_chat(target_fixer.occupant, "You have been downloaded to a mobile storage device. Still no remote access.")
								to_chat(user, "\blue <b>Transfer successful</b>: \black [target_fixer.occupant.name] ([rand(1000, 9999)].exe) removed from host terminal and stored within local memory.")
								target_fixer.occupant.loc = card
								target_fixer.occupant.cancel_camera()
								target_fixer.occupant = null
							else if(length(card.contents))
								to_chat(user, "\red <b>ERROR</b>: \black Artificial intelligence detected on terminal.")
							else if(target_fixer.active)
								to_chat(user, "\red <b>ERROR</b>: \black Reconstruction in progress.")
							else if(!target_fixer.occupant)
								to_chat(user, "\red <b>ERROR</b>: \black Unable to locate artificial intelligence.")
					if("NINJASUIT")
						var/obj/item/clothing/suit/space/space_ninja/ninja_suit = src
						if(!length(target_fixer.contents))
							if(!ninja_suit.AI)
								to_chat(user, "No AI to copy over!")
							else
								var/mob/living/silicon/ai/suit_ai = ninja_suit.AI
								suit_ai.loc = target_fixer
								target_fixer.occupant = suit_ai
								ninja_suit.AI = null
								suit_ai.control_disabled = TRUE
								target_fixer.overlays += image('icons/obj/machines/computer.dmi', "ai-fixer-full")
								target_fixer.overlays -= image('icons/obj/machines/computer.dmi', "ai-fixer-empty")
								suit_ai.cancel_camera()
								to_chat(suit_ai, "You have been uploaded to a stationary terminal. Sadly, there is no remote access from here.")
								to_chat(user, "\blue <b>Transfer successful</b>: \black [suit_ai.name] ([rand(1000, 9999)].exe) installed and executed successfully. Local copy has been removed.")
						else
							if(!ninja_suit.AI && target_fixer.occupant && !target_fixer.active)
								if(target_fixer.occupant.stat)
									to_chat(user, "\red <b>ERROR</b>: \black [target_fixer.occupant.name] data core is corrupted. Unable to install.")
								else
									target_fixer.overlays += image('icons/obj/machines/computer.dmi', "ai-fixer-empty")
									target_fixer.overlays -= image('icons/obj/machines/computer.dmi', "ai-fixer-full")
									to_chat(target_fixer.occupant, "You have been downloaded to a mobile storage device. Still no remote access.")
									to_chat(user, "\blue <b>Transfer successful</b>: \black [target_fixer.occupant.name] ([rand(1000, 9999)].exe) removed from host terminal and stored within local memory.")
									target_fixer.occupant.loc = ninja_suit
									target_fixer.occupant.cancel_camera()
									target_fixer.occupant = null
							else if(ninja_suit.AI)
								to_chat(user, "\red <b>ERROR</b>: \black Artificial intelligence detected on terminal.")
							else if(target_fixer.active)
								to_chat(user, "\red <b>ERROR</b>: \black Reconstruction in progress.")
							else if(!target_fixer.occupant)
								to_chat(user, "\red <b>ERROR</b>: \black Unable to locate artificial intelligence.")

			if("NINJASUIT") //Ninjasuit
				var/obj/item/clothing/suit/space/space_ninja/target_ninja = target
				switch(interaction)
					if("AICARD")
						var/obj/item/aicard/card = src
						if(target_ninja.s_initialized && user == target_ninja.affecting) //If the suit is initialized and the actor is the user.
							var/mob/living/silicon/ai/ai_target = locate() in card //Determine if there is an AI on target card. Saves time when checking later.
							var/mob/living/silicon/ai/ninja_ai = target_ninja.AI //Deterine if there is an AI in suit.

							if(ninja_ai) //If the host AI card is not empty.
								if(ai_target) //If there is an AI on the target card.
									to_chat(user, "\red <b>ERROR</b>: \black [ai_target.name] already installed. Remove [ai_target.name] to install a new one.")
								else
									ninja_ai.loc = card //Throw them into the target card. Since they are already on a card, transfer is easy.
									card.name = "inteliCard - [ninja_ai.name]"
									card.icon_state = "aicard-full"
									target_ninja.AI = null
									ninja_ai.cancel_camera()
									to_chat(ninja_ai, "You have been uploaded to a mobile storage device.")
									to_chat(user, "\blue <b>SUCCESS</b>: \black [ninja_ai.name] ([rand(1000, 9999)].exe) removed from host and stored within local memory.")
							else //If host AI is empty.
								if(card.flush) //If the other card is flushing.
									to_chat(user, "\red <b>ERROR</b>: \black AI flush is in progress, cannot execute transfer protocol.")
								else
									if(ai_target && !ai_target.stat) //If there is an AI on the target card and it's not inactive.
										ai_target.loc = target_ninja //Throw them into suit.
										card.icon_state = "aicard"
										card.name = "inteliCard"
										card.overlays.Cut()
										target_ninja.AI = ai_target
										ai_target.cancel_camera()
										to_chat(ai_target, "You have been uploaded to a mobile storage device.")
										to_chat(user, "\blue <b>SUCCESS</b>: \black [ai_target.name] ([rand(1000, 9999)].exe) removed from local memory and installed to host.")
									else if(ai_target) //If the target AI is dead. Else just go to return since nothing would happen if both are empty.
										to_chat(user, "\red <b>ERROR</b>: \black [ai_target.name] data core is corrupted. Unable to install.")
	else
		to_chat(user, "\red <b>ERROR</b>: \black AI flush is in progress, cannot execute transfer protocol.")
	return