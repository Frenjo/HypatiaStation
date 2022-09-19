//The reaction procs must ALWAYS set del(src), this detaches the proc from the object (the reagent)
//so that it can continue working when the reagent is deleted while the proc is still active.

/datum/reagent
	var/name = "Reagent"
	var/id = "reagent"
	var/description = ""
	var/datum/reagents/holder = null
	var/reagent_state = REAGENT_SOLID
	var/list/data = null
	var/volume = 0
	var/nutriment_factor = 0
	var/custom_metabolism = REAGENTS_METABOLISM
	var/overdose = 0
	var/overdose_dam = 1
	//var/list/viruses = list()
	var/color = "#000000" // rgb: 0, 0, 0 (does not support alpha channels - yet!)

/datum/reagent/Destroy() // This should only be called by the holder, so it's already handled clearing its references
	..()
	holder = null

/datum/reagent/proc/reaction_mob(mob/M, method = TOUCH, volume) //By default we have a chance to transfer some
	if(!isliving(M))
		return 0
	var/datum/reagent/self = src
	qdel(src)											//of the reagent to the mob on TOUCHING it.

	if(self.holder)	//for catching rare runtimes
		if(!istype(self.holder.my_atom, /obj/effect/smoke/chem))
			// If the chemicals are in a smoke cloud, do not try to let the chemicals "penetrate" into the mob's system (balance station 13) -- Doohl
			if(method == TOUCH)
				var/chance = 1
				var/block = 0

				for(var/obj/item/clothing/C in M.get_equipped_items())
					if(C.permeability_coefficient < chance)
						chance = C.permeability_coefficient
					if(istype(C, /obj/item/clothing/suit/bio_suit))
						// bio suits are just about completely fool-proof - Doohl
						// kind of a hacky way of making bio suits more resistant to chemicals but w/e
						if(prob(75))
							block = 1

					if(istype(C, /obj/item/clothing/head/bio_hood))
						if(prob(75))
							block = 1

				chance = chance * 100

				if(prob(chance) && !block)
					if(M.reagents)
						M.reagents.add_reagent(self.id, self.volume / 2)
	return 1

/datum/reagent/proc/reaction_obj(obj/O, volume)
	qdel(src)
	//By default we transfer a small part of the reagent to the object if it can hold reagents.
	if(O.reagents)
		O.reagents.add_reagent(id, volume / 3)
	return

/datum/reagent/proc/reaction_turf(turf/T, volume)
	qdel(src)
	return

/datum/reagent/proc/on_mob_life(mob/living/M as mob, alien)
	if(!isliving(M))
		return //Noticed runtime errors from pacid trying to damage ghosts, this should fix. --NEO
	if(overdose > 0 && volume >= overdose) //Overdosing, wooo
		M.adjustToxLoss(overdose_dam)
	holder.remove_reagent(src.id, custom_metabolism) //By default it slowly disappears.
	return

/datum/reagent/proc/on_move(mob/M)
	return

// Called after add_reagents creates a new reagent.
/datum/reagent/proc/on_new(data)
	return

// Called when two reagents of the same are mixing.
/datum/reagent/proc/on_merge(data)
	return

/datum/reagent/proc/on_update(atom/A)
	return