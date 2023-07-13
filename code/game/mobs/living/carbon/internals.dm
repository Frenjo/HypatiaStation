/mob/living/carbon/ui_toggle_internals()
	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		if(!C.stat && !C.stunned && !C.paralysis && !C.restrained())
			if(isnotnull(C.internal))
				C.internal = null
				to_chat(C, SPAN_NOTICE("No longer running on internals."))
				C.internals?.icon_state = "internal0"
				return

			if(!istype(C.wear_mask, /obj/item/clothing/mask))
				to_chat(C, SPAN_NOTICE("You are not wearing a mask."))
				return

			var/breathes = /decl/xgm_gas/oxygen // Default, we'll check later.
			var/list/slot_names = null
			var/list/slots_to_check = null
			var/list/contents = list()

			if(ishuman(C))
				var/mob/living/carbon/human/H = C
				breathes = H.species.breath_type
				slot_names = list("suit", "back", "belt", "right hand", "left hand", "left pocket", "right pocket")
				slots_to_check = list(H.s_store, C.back, H.belt, C.r_hand, C.l_hand, H.l_store, H.r_store)
			else
				slot_names = list("Right Hand", "Left Hand", "Back")
				slots_to_check = list(C.r_hand, C.l_hand, C.back)

			for(var/i = 1, i < length(slots_to_check) + 1, ++i)
				if(istype(slots_to_check[i], /obj/item/tank))
					var/obj/item/tank/t = slots_to_check[i]
					if(isnotnull(t.manipulated_by) && t.manipulated_by != C.real_name && findtext(t.desc, breathes))
						// Someone messed with the tank and put unknown gases in it, so we're going to believe the tank is what it says it is.
						contents.Add(t.air_contents.total_moles)
						continue
					switch(breathes)
						// These tanks we're sure of their contents.
						// So we're a bit more picky about them.
						if(/decl/xgm_gas/nitrogen)
							if(t.air_contents.gas[/decl/xgm_gas/nitrogen] && !t.air_contents.gas[/decl/xgm_gas/oxygen])
								contents.Add(t.air_contents.gas[/decl/xgm_gas/nitrogen])
							else
								contents.Add(0)

						if(/decl/xgm_gas/oxygen)
							if(t.air_contents.gas[/decl/xgm_gas/oxygen] && !t.air_contents.gas[/decl/xgm_gas/plasma])
								contents.Add(t.air_contents.gas[/decl/xgm_gas/oxygen])
							else
								contents.Add(0)

						// No races breathe this, but never know about downstream servers.
						if(/decl/xgm_gas/carbon_dioxide)
							if(t.air_contents.gas[/decl/xgm_gas/carbon_dioxide] && !t.air_contents.gas[/decl/xgm_gas/plasma])
								contents.Add(t.air_contents.gas[/decl/xgm_gas/carbon_dioxide])
							else
								contents.Add(0)

						// Plasmalins breathe this.
						if(/decl/xgm_gas/plasma)
							if(t.air_contents.gas[/decl/xgm_gas/plasma] && !t.air_contents.gas[/decl/xgm_gas/oxygen])
								contents.Add(t.air_contents.gas[/decl/xgm_gas/plasma])
							else
								contents.Add(0)
				else
					// No tank so we set contents to 0.
					contents.Add(0)

			// Alright now we know the contents of the tanks so we have to pick the best one.
			var/best = null
			var/best_contents = null
			for(var/i = 1, i < length(contents) + 1, ++i)
				if(!contents[i])
					continue
				if(contents[i] > best_contents)
					best = i
					best_contents = contents[i]

			// We've determined the best container now we set it as our internals.
			if(isnotnull(best))
				to_chat(C, SPAN_NOTICE("You are now running on internals from [slots_to_check[best]] on your [slot_names[best]]."))
				C.internal = slots_to_check[best]

			if(isnotnull(C.internal))
				C.internals?.icon_state = "internal1"
			else
				to_chat(C, SPAN_NOTICE("You don't have a[breathes == /decl/xgm_gas/oxygen ? "n oxygen" : addtext(" ", breathes)] tank."))