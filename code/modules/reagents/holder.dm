//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

///////////////////////////////////////////////////////////////////////////////////

/datum/reagents
	var/list/datum/reagent/reagent_list = list()
	var/total_volume = 0
	var/maximum_volume = 100
	var/atom/my_atom = null

/datum/reagents/New(maximum = 100)
	maximum_volume = maximum

/datum/reagents/Destroy()
	for(var/datum/reagent/R in reagent_list)
		qdel(R)
	reagent_list.Cut()
	reagent_list = null
	if(my_atom?.reagents == src)
		my_atom.reagents = null
	return ..()

/datum/reagents/proc/remove_any(amount = 1)
	var/total_transfered = 0
	var/current_list_element = 1

	current_list_element = rand(1, length(reagent_list))

	while(total_transfered != amount)
		if(total_transfered >= amount)
			break
		if(total_volume <= 0 || !length(reagent_list))
			break

		if(current_list_element > length(reagent_list))
			current_list_element = 1
		var/datum/reagent/current_reagent = reagent_list[current_list_element]

		remove_reagent(current_reagent.id, 1)

		current_list_element++
		total_transfered++
		update_total()

	handle_reactions()
	return total_transfered

/datum/reagents/proc/get_master_reagent_name()
	var/the_name = null
	var/the_volume = 0
	for(var/datum/reagent/A in reagent_list)
		if(A.volume > the_volume)
			the_volume = A.volume
			the_name = A.name

	return the_name

/datum/reagents/proc/get_master_reagent_id()
	var/the_id = null
	var/the_volume = 0
	for(var/datum/reagent/A in reagent_list)
		if(A.volume > the_volume)
			the_volume = A.volume
			the_id = A.id

	return the_id

/datum/reagents/proc/trans_to(obj/target, amount = 1, multiplier = 1, preserve_data = 1)//if preserve_data=0, the reagents data will be lost. Usefull if you use data for some strange stuff and don't want it to be transferred.
	if(isnull(target?.reagents) || total_volume <= 0)
		return
	var/datum/reagents/R = target.reagents
	amount = min(min(amount, total_volume), R.maximum_volume - R.total_volume)
	var/part = amount / total_volume
	var/trans_data = null
	for(var/datum/reagent/current_reagent in reagent_list)
		if(isnull(current_reagent))
			continue
		if(istype(current_reagent, /datum/reagent/blood) && ishuman(target))
			var/mob/living/carbon/human/H = target
			H.inject_blood(my_atom, amount)
			continue
		var/current_reagent_transfer = current_reagent.volume * part
		if(preserve_data)
			trans_data = current_reagent.data

		R.add_reagent(current_reagent.id, (current_reagent_transfer * multiplier), trans_data, safety = 1)	//safety checks on these so all chemicals are transferred
		remove_reagent(current_reagent.id, current_reagent_transfer, safety = 1)							// to the target container before handling reactions

	update_total()
	R.update_total()
	R.handle_reactions()
	handle_reactions()
	return amount

/datum/reagents/proc/trans_to_ingest(obj/target, amount = 1, multiplier = 1, preserve_data = 1) // For items ingested. A delay is added between ingestion and addition of the reagents
	if(isnull(target?.reagents) || total_volume <= 0)
		return

	/*var/datum/reagents/R = target.reagents

	var/obj/item/reagent_containers/glass/beaker/noreact/B = new /obj/item/reagent_containers/glass/beaker/noreact //temporary holder

	amount = min(min(amount, total_volume), R.maximum_volume-R.total_volume)
	var/part = amount / total_volume
	var/trans_data = null
	for (var/datum/reagent/current_reagent in reagent_list)
		if (!current_reagent)
			continue
		//if (current_reagent.id == "blood" && ishuman(target))
		//	var/mob/living/carbon/human/H = target
		//	H.inject_blood(my_atom, amount)
		//	continue
		var/current_reagent_transfer = current_reagent.volume * part
		if(preserve_data)
			trans_data = current_reagent.data

		B.add_reagent(current_reagent.id, (current_reagent_transfer * multiplier), trans_data, safety = 1)	//safety checks on these so all chemicals are transferred
		remove_reagent(current_reagent.id, current_reagent_transfer, safety = 1)							// to the target container before handling reactions

	update_total()
	B.update_total()
	B.handle_reactions()
	handle_reactions()*/

	var/obj/item/reagent_containers/glass/beaker/noreact/B = new /obj/item/reagent_containers/glass/beaker/noreact //temporary holder
	B.volume = 1000

	var/datum/reagents/BR = B.reagents
	var/datum/reagents/R = target.reagents

	amount = min(min(amount, total_volume), R.maximum_volume - R.total_volume)

	trans_to(B, amount)

	spawn(95)
		BR.reaction(target, INGEST)
		spawn(5)
			BR.trans_to(target, BR.total_volume)
			qdel(B)

	return amount

/datum/reagents/proc/copy_to(obj/target, amount = 1, multiplier = 1, preserve_data = 1, safety = 0)
	if(isnull(target?.reagents) || total_volume <= 0)
		return
	var/datum/reagents/R = target.reagents
	amount = min(min(amount, total_volume), R.maximum_volume - R.total_volume)
	var/part = amount / total_volume
	var/trans_data = null
	for(var/datum/reagent/current_reagent in reagent_list)
		var/current_reagent_transfer = current_reagent.volume * part
		if(preserve_data)
			trans_data = current_reagent.data
		R.add_reagent(current_reagent.id, (current_reagent_transfer * multiplier), trans_data, safety = 1)	//safety check so all chemicals are transferred before reacting

	update_total()
	R.update_total()
	if(!safety)
		R.handle_reactions()
		handle_reactions()
	return amount

/datum/reagents/proc/trans_id_to(obj/target, reagent, amount = 1, preserve_data = 1)//Not sure why this proc didn't exist before. It does now! /N
	if(isnull(target?.reagents) || total_volume <= 0 || !get_reagent_amount(reagent))
		return

	var/datum/reagents/R = target.reagents
	if(get_reagent_amount(reagent)<amount)
		amount = get_reagent_amount(reagent)
	amount = min(amount, R.maximum_volume - R.total_volume)
	var/trans_data = null
	for(var/datum/reagent/current_reagent in reagent_list)
		if(current_reagent.id == reagent)
			if(preserve_data)
				trans_data = current_reagent.data
			R.add_reagent(current_reagent.id, amount, trans_data)
			remove_reagent(current_reagent.id, amount, 1)
			break

	update_total()
	R.update_total()
	R.handle_reactions()
	//handle_reactions() Don't need to handle reactions on the source since you're (presumably isolating and) transferring a specific reagent.
	return amount

/*
	if(!target)
		return
	var/total_transfered = 0
	var/current_list_element = 1
	var/datum/reagents/R = target.reagents
	var/trans_data = null
	//if(R.total_volume + amount > R.maximum_volume) return 0

	current_list_element = rand(1, length(reagent_list)) //Eh, bandaid fix.

	while(total_transfered != amount)
		if(total_transfered >= amount)
			break //Better safe than sorry.
		if(total_volume <= 0 || !length(reagent_list))
			break
		if(R.total_volume >= R.maximum_volume)
			break

		if(current_list_element > length(reagent_list)) current_list_element = 1
		var/datum/reagent/current_reagent = reagent_list[current_list_element]
		if(preserve_data)
			trans_data = current_reagent.data
		R.add_reagent(current_reagent.id, (1 * multiplier), trans_data)
		remove_reagent(current_reagent.id, 1)

		current_list_element++
		total_transfered++
		update_total()
		R.update_total()
	R.handle_reactions()
	handle_reactions()

	return total_transfered
*/

/datum/reagents/proc/metabolize(mob/living/M, alien)
	for(var/datum/reagent/R in reagent_list)
		if(isnotnull(M) && isnotnull(R))
			R.on_mob_life(M, alien)
	update_total()

/datum/reagents/proc/conditional_update_move(atom/A, Running = 0)
	for(var/datum/reagent/R in reagent_list)
		R.on_move(A, Running)
	update_total()

/datum/reagents/proc/conditional_update(atom/A)
	for(var/datum/reagent/R in reagent_list)
		R.on_update(A)
	update_total()

/datum/reagents/proc/handle_reactions()
	if(HAS_ATOM_FLAGS(my_atom, ATOM_FLAG_NO_REACT))
		return // Yup, no reactions here. No siree.

	var/reaction_occured = 0
	do
		reaction_occured = 0
		for(var/datum/reagent/R in reagent_list) // Usually a small list
			// Was a big list but now it should be smaller since we filtered it with our reagent id.
			for(var/datum/chemical_reaction/C in GLOBL.chemical_reactions_list[R.id])
				if(isnull(C))
					continue

				//check if this recipe needs to be heated to mix
				if(C.requires_heating)
					if(istype(my_atom.loc, /obj/machinery/bunsen_burner))
						var/obj/machinery/bunsen_burner/bunsen = my_atom.loc
						if(!bunsen.heated)
							continue
					else
						continue

				var/total_required_reagents = length(C.required_reagents)
				var/total_matching_reagents = 0
				var/total_required_catalysts = length(C.required_catalysts)
				var/total_matching_catalysts = 0
				var/matching_container = 0
				var/matching_other = 0
				var/list/multipliers = list()

				for(var/B in C.required_reagents)
					if(!has_reagent(B, C.required_reagents[B]))
						break
					total_matching_reagents++
					multipliers += round(get_reagent_amount(B) / C.required_reagents[B])
				for(var/B in C.required_catalysts)
					if(!has_reagent(B, C.required_catalysts[B]))
						break
					total_matching_catalysts++

				if(!C.required_container)
					matching_container = 1

				else
					if(my_atom.type == C.required_container)
						matching_container = 1

				if(!C.required_other)
					matching_other = 1

				else
					/*
					if(istype(my_atom, /obj/item/slime_core))
						var/obj/item/slime_core/M = my_atom

						if(M.POWERFLAG == C.required_other && M.Uses > 0) // added a limit to slime cores -- Muskets requested this
							matching_other = 1
					*/
					if(istype(my_atom, /obj/item/slime_extract))
						var/obj/item/slime_extract/M = my_atom
						if(M.Uses > 0) // added a limit to slime cores -- Muskets requested this
							matching_other = 1


				if(total_matching_reagents == total_required_reagents && total_matching_catalysts == total_required_catalysts && matching_container && matching_other)
					var/multiplier = min(multipliers)
					var/preserved_data = null
					for(var/B in C.required_reagents)
						if(!preserved_data)
							preserved_data = get_data(B)
						remove_reagent(B, (multiplier * C.required_reagents[B]), safety = 1)

					var/created_volume = C.result_amount * multiplier
					if(C.result)
						feedback_add_details("chemical_reaction", "[C.result]|[C.result_amount * multiplier]")
						multiplier = max(multiplier, 1) //this shouldnt happen ...
						add_reagent(C.result, C.result_amount * multiplier)
						set_data(C.result, preserved_data)

						//add secondary products
						for(var/S in C.secondary_results)
							add_reagent(S, C.result_amount * C.secondary_results[S] * multiplier)

					my_atom.visible_message(SPAN_INFO("\icon[my_atom] The solution begins to bubble."))

				/*
					if(istype(my_atom, /obj/item/slime_core))
						var/obj/item/slime_core/ME = my_atom
						ME.Uses--
						if(ME.Uses <= 0) // give the notification that the slime core is dead
							for(var/mob/M in viewers(4, get_turf(my_atom)) )
								M << "\blue \icon[my_atom] The innards begin to boil!"
				*/

					if(istype(my_atom, /obj/item/slime_extract))
						var/obj/item/slime_extract/ME2 = my_atom
						ME2.Uses--
						if(ME2.Uses <= 0) // give the notification that the slime core is dead
							my_atom.visible_message(SPAN_INFO("\icon[my_atom] The [my_atom]'s power is consumed in the reaction."))
							ME2.name = "used slime extract"
							ME2.desc = "This extract has been used up."

					playsound(get_turf(my_atom), 'sound/effects/bubbles.ogg', 80, 1)

					C.on_reaction(src, created_volume)
					reaction_occured = 1
					break

	while(reaction_occured)
	update_total()
	return 0

/datum/reagents/proc/isolate_reagent(reagent_type)
	for(var/datum/reagent/R in reagent_list)
		if(R.type != reagent_type)
			del_reagent(R.type)
			update_total()

/datum/reagents/proc/del_reagent(reagent_type)
	for(var/datum/reagent/R in reagent_list)
		if(R.type == reagent_type)
			reagent_list.Remove(R)
			qdel(R)
			update_total()
			my_atom.on_reagent_change()
			return 0
	return 1

/datum/reagents/proc/update_total()
	total_volume = 0
	for(var/datum/reagent/R in reagent_list)
		if(R.volume < 0.1)
			del_reagent(R.type)
		else
			total_volume += R.volume
	return 0

/datum/reagents/proc/clear_reagents()
	for(var/datum/reagent/R in reagent_list)
		del_reagent(R.type)
		return 0

/datum/reagents/proc/reaction(atom/A, method = TOUCH, volume_modifier = 0)
	switch(method)
		if(TOUCH)
			for(var/datum/reagent/R in reagent_list)
				if(isnull(R))
					continue
				if(ismob(A))
					spawn(0)
						R.reaction_mob(A, TOUCH, R.volume + volume_modifier)
				if(isturf(A))
					spawn(0)
						R.reaction_turf(A, R.volume + volume_modifier)
				if(isobj(A))
					spawn(0)
						R.reaction_obj(A, R.volume + volume_modifier)
		if(INGEST)
			for(var/datum/reagent/R in reagent_list)
				if(isnull(R))
					continue
				if(ismob(A))
					spawn(0)
						R.reaction_mob(A, INGEST, R.volume + volume_modifier)
				if(isturf(A))
					spawn(0)
						R.reaction_turf(A, R.volume + volume_modifier)
				if(isobj(A))
					spawn(0)
						R.reaction_obj(A, R.volume + volume_modifier)

/datum/reagents/proc/add_reagent(reagent, amount, list/data = null, safety = 0)
	if(!isnum(amount))
		return 1
	update_total()
	if(total_volume + amount > maximum_volume)
		amount = (maximum_volume - total_volume) //Doesnt fit in. Make it disappear. Shouldnt happen. Will happen.

	for(var/datum/reagent/R in reagent_list)
		if(R.id == reagent)
			R.volume += amount
			update_total()
			my_atom.on_reagent_change()

			// mix dem viruses
			if(istype(R, /datum/reagent/blood) && reagent == "blood")
				if(isnotnull(R.data) && isnotnull(data))
					if(R.data["viruses"] || data["viruses"])
						var/list/mix1 = R.data["viruses"]
						var/list/mix2 = data["viruses"]

						// Stop issues with the list changing during mixing.
						var/list/to_mix = list()

						for(var/datum/disease/advance/AD in mix1)
							to_mix.Add(AD)
						for(var/datum/disease/advance/AD in mix2)
							to_mix.Add(AD)

						var/datum/disease/advance/AD = Advance_Mix(to_mix)
						if(isnotnull(AD))
							var/list/preserve = list(AD)
							for(var/D in R.data["viruses"])
								if(!istype(D, /datum/disease/advance))
									preserve += D
							R.data["viruses"] = preserve

			if(!safety)
				handle_reactions()
			return 0

	var/datum/reagent/D = GLOBL.chemical_reagents_list[reagent]
	if(isnotnull(D))
		var/datum/reagent/R = new D.type()
		reagent_list.Add(R)
		R.holder = src
		R.volume = amount
		SetViruses(R, data) // Includes setting data

		//debug
		//to_world("Adding data")
		//for(var/D in R.data)
			//to_world("Container data: [D] = [R.data[D]]")
		//debug
		update_total()
		my_atom.on_reagent_change()
		if(!safety)
			handle_reactions()
		return 0
	else
		warning("[my_atom] attempted to add a reagent called '[reagent]' which doesn't exist. ([usr])")

	if(!safety)
		handle_reactions()

	return 1

/datum/reagents/proc/remove_reagent(reagent, amount, safety = 0)//Added a safety check for the trans_id_to
	if(!isnum(amount))
		return 1

	for(var/datum/reagent/R in reagent_list)
		if(R.id == reagent)
			R.volume -= amount
			update_total()
			if(!safety)//So it does not handle reactions when it need not to
				handle_reactions()
			my_atom.on_reagent_change()
			return 0

	return 1

/datum/reagents/proc/has_reagent(reagent, amount = -1)
	for(var/datum/reagent/R in reagent_list)
		if(R.id == reagent)
			if(!amount)
				return R
			else
				if(R.volume >= amount)
					return R
				else return 0

	return 0

/datum/reagents/proc/get_reagent_amount(reagent)
	for(var/datum/reagent/R in reagent_list)
		if(R.id == reagent)
			return R.volume

	return 0

/datum/reagents/proc/get_reagents()
	var/res = ""
	for(var/datum/reagent/A in reagent_list)
		if(res != "")
			res += ","
		res += A.name

	return res

/datum/reagents/proc/remove_all_type(reagent_type, amount, strict = 0, safety = 1) // Removes all reagent of X type. @strict set to 1 determines whether the childs of the type are included.
	if(!isnum(amount))
		return 1

	var/has_removed_reagent = 0

	for(var/datum/reagent/R in reagent_list)
		var/matches = 0
		// Switch between how we check the reagent type
		if(strict)
			if(R.type == reagent_type)
				matches = 1
		else
			if(istype(R, reagent_type))
				matches = 1
		// We found a match, proceed to remove the reagent.	Keep looping, we might find other reagents of the same type.
		if(matches)
			// Have our other proc handle removement
			has_removed_reagent = remove_reagent(R.id, amount, safety)

	return has_removed_reagent

//two helper functions to preserve data across reactions (needed for xenoarch)
/datum/reagents/proc/get_data(reagent_id)
	for(var/datum/reagent/D in reagent_list)
		if(D.id == reagent_id)
			//to_world("proffering a data-carrying reagent ([reagent_id])")
			return D.data

/datum/reagents/proc/set_data(reagent_id, new_data)
	for(var/datum/reagent/D in reagent_list)
		if(D.id == reagent_id)
			//to_world("reagent data set ([reagent_id])")
			D.data = new_data

///////////////////////////////////////////////////////////////////////////////////

// Convenience proc to create a reagents holder for an atom
// Max vol is maximum volume of holder
/atom/proc/create_reagents(max_vol)
	reagents = new/datum/reagents(max_vol)
	reagents.my_atom = src