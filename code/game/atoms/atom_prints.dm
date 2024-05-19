/atom/proc/add_hiddenprint(mob/living/M)
	if(isnull(M))
		return
	if(isnull(M.key))
		return

	// Add the list if it does not exist.
	if(isnull(hidden_fingerprints))
		hidden_fingerprints = list()

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!istype(H.dna, /datum/dna))
			return 0
		if(isnotnull(H.gloves))
			if(last_fingerprints != H.key)
				hidden_fingerprints.Add("\[[time_stamp()]\] (Wearing gloves). Real name: [H.real_name], Key: [H.key]")
				last_fingerprints = H.key
			return 0
		if(isnull(fingerprints))
			if(last_fingerprints != H.key)
				hidden_fingerprints.Add("\[[time_stamp()]\] Real name: [H.real_name], Key: [H.key]")
				last_fingerprints = H.key
			return 1
	else
		if(last_fingerprints != M.key)
			hidden_fingerprints.Add("\[[time_stamp()]\] Real name: [M.real_name], Key: [M.key]")
			last_fingerprints = M.key

/atom/proc/add_fingerprint(mob/living/M)
	if(isnull(M))
		return
	if(isAI(M))
		return
	if(isnull(M.key))
		return

	// Add the list if it does not exist.
	if(isnull(hidden_fingerprints))
		hidden_fingerprints = list()

	if(ishuman(M))
		// Fibers~
		add_fibers(M)

		// He has no prints!
		if(mFingerprints in M.mutations)
			if(last_fingerprints != M.key)
				hidden_fingerprints.Add("(Has no fingerprints) Real name: [M.real_name], Key: [M.key]")
				last_fingerprints = M.key
			return 0 // Now, lets get to the dirty work.

		// First, make sure their DNA makes sense.
		var/mob/living/carbon/human/H = M
		if(!istype(H.dna, /datum/dna) || !H.dna.uni_identity || length(H.dna.uni_identity) != 32)
			if(!istype(H.dna, /datum/dna))
				H.dna = new /datum/dna(null)
				H.dna.real_name = H.real_name
		H.check_dna()

		// Now, deal with gloves.
		if(isnotnull(H.gloves) && H.gloves != src)
			if(last_fingerprints != H.key)
				hidden_fingerprints.Add("\[[time_stamp()]\](Wearing gloves). Real name: [H.real_name], Key: [H.key]")
				last_fingerprints = H.key
			H.gloves.add_fingerprint(M)

		// Deal with gloves the pass finger/palm prints.
		if(H.gloves != src)
			if(prob(75) && istype(H.gloves, /obj/item/clothing/gloves/latex))
				return 0
			else if(H.gloves && !istype(H.gloves, /obj/item/clothing/gloves/latex))
				return 0

		// More adminstuffz.
		if(last_fingerprints != H.key)
			hidden_fingerprints.Add("\[[time_stamp()]\]Real name: [H.real_name], Key: [H.key]")
			last_fingerprints = H.key

		// Make the list if it does not exist.
		if(isnull(fingerprints))
			fingerprints = list()

		// Hash this shit.
		var/full_print = md5(H.dna.uni_identity)

		// Add the fingerprints.
		if(fingerprints[full_print])
			switch(stringpercent(fingerprints[full_print])) // Tells us how many stars are in the current prints.
				if(28 to 32)
					if(prob(1))
						fingerprints[full_print] = full_print // You rolled a one buddy.
					else
						fingerprints[full_print] = stars(full_print, rand(0, 40)) // 24 to 32

				if(24 to 27)
					if(prob(3))
						fingerprints[full_print] = full_print // Sucks to be you.
					else
						fingerprints[full_print] = stars(full_print, rand(15, 55)) // 20 to 29

				if(20 to 23)
					if(prob(5))
						fingerprints[full_print] = full_print // Had a good run didn't ya.
					else
						fingerprints[full_print] = stars(full_print, rand(30, 70)) // 15 to 25

				if(16 to 19)
					if(prob(5))
						fingerprints[full_print] = full_print // Welp.
					else
						fingerprints[full_print]  = stars(full_print, rand(40, 100))  // 0 to 21

				if(0 to 15)
					if(prob(5))
						fingerprints[full_print] = stars(full_print, rand(0, 50)) // Small chance you can smudge.
					else
						fingerprints[full_print] = full_print
		else
			fingerprints[full_print] = stars(full_print, rand(0, 20)) // Initial touch, not leaving much evidence the first time.

		return 1
	else
		// Smudge up dem prints some.
		if(last_fingerprints != M.key)
			hidden_fingerprints.Add("\[[time_stamp()]\]Real name: [M.real_name], Key: [M.key]")
			last_fingerprints = M.key

	//Cleaning up shit.
	if(isnotnull(fingerprints) && !length(fingerprints))
		qdel(fingerprints)

/atom/proc/transfer_fingerprints_to(atom/A)
	if(!islist(A.fingerprints))
		A.fingerprints = list()
	if(!islist(A.hidden_fingerprints))
		A.hidden_fingerprints = list()

	//skytodo
	//A.fingerprints |= fingerprints			//detective
	//A.fingerprintshidden |= fingerprintshidden	//admin
	if(isnotnull(fingerprints))
		A.fingerprints |= fingerprints.Copy()			//detective
	if(isnotnull(hidden_fingerprints))
		A.hidden_fingerprints |= hidden_fingerprints.Copy()	//admin	A.fingerprintslast = fingerprintslast