/var/global/list/global_map = null
//list/global_map = list(list(1,5),list(4,3))//an array of map Z levels.
//Resulting sector map looks like
//|_1_|_4_|
//|_5_|_3_|
//
//1 - SS13
//4 - Derelict
//3 - AI satellite
//5 - empty space

/atom
	layer = 2
	var/level = 2
	var/flags
	var/list/fingerprints
	var/list/fingerprintshidden
	var/fingerprintslast = null
	var/list/blood_DNA
	var/blood_color
	var/last_bumped = 0
	var/pass_flags = 0
	var/throwpass = 0
	var/germ_level = GERM_LEVEL_AMBIENT // The higher the germ level, the more germ on the atom.
	var/simulated = 1 //filter for actions - used by lighting overlays

	///Chemistry.
	var/datum/reagents/reagents = null

	//var/chem_is_open_container = 0
	// replaced by OPENCONTAINER flags and atom/proc/is_open_container()
	///Chemistry.

	//Detective Work, used for the duplicate data points kept in the scanners
	var/list/original_atom

/atom/Destroy()
	density = FALSE
	invisibility = 101
	set_opacity(0)

	if(reagents)
		qdel(reagents)
		reagents = null
	for(var/atom/movable/AM in contents)
		qdel(AM)
	return ..()

/atom/proc/throw_impact(atom/hit_atom, speed)
	if(isliving(hit_atom))
		var/mob/living/M = hit_atom
		M.hitby(src, speed)

	else if(isobj(hit_atom))
		var/obj/O = hit_atom
		if(!O.anchored)
			step(O, src.dir)
		O.hitby(src, speed)

	else if(isturf(hit_atom))
		var/turf/T = hit_atom
		if(T.density)
			spawn(2)
				step(src, turn(src.dir, 180))
			if(isliving(src))
				var/mob/living/M = src
				M.take_organ_damage(20)

/atom/proc/assume_air(datum/gas_mixture/giver)
	return null

/atom/proc/remove_air(amount)
	return null

/atom/proc/return_air()
	if(loc)
		return loc.return_air()
	else
		return null

/atom/proc/check_eye(user as mob)
	if(isAI(user)) // WHYYYY
		return 1
	return

/atom/proc/on_reagent_change()
	return

/atom/proc/Bumped(AM as mob|obj)
	return

// Convenience proc to see if a container is open for chemistry handling
// returns true if open
// false if closed
/atom/proc/is_open_container()
	return flags & OPENCONTAINER

/*//Convenience proc to see whether a container can be accessed in a certain way.

	proc/can_subract_container()
		return flags & EXTRACT_CONTAINER

	proc/can_add_container()
		return flags & INSERT_CONTAINER
*/

/atom/proc/meteorhit(obj/meteor as obj)
	return

/atom/proc/allow_drop()
	return 1

/atom/proc/CheckExit()
	return 1

/atom/proc/HasProximity(atom/movable/AM as mob|obj)
	return

/atom/proc/emp_act(severity)
	return

/atom/proc/bullet_act(obj/item/projectile/Proj)
	return 0

/atom/proc/in_contents_of(container)//can take class or object instance as argument
	if(ispath(container))
		if(istype(src.loc, container))
			return 1
	else if(src in container)
		return 1
	return

/*
 *	atom/proc/search_contents_for(path,list/filter_path=null)
 * Recursevly searches all atom contens (including contents contents and so on).
 *
 * ARGS: path - search atom contents for atoms of this type
 *	   list/filter_path - if set, contents of atoms not of types in this list are excluded from search.
 *
 * RETURNS: list of found atoms
 */

/atom/proc/search_contents_for(path, list/filter_path = null)
	var/list/found = list()
	for(var/atom/A in src)
		if(istype(A, path))
			found += A
		if(filter_path)
			var/pass = 0
			for(var/type in filter_path)
				pass |= istype(A, type)
			if(!pass)
				continue
		if(A.contents.len)
			found += A.search_contents_for(path, filter_path)
	return found


/*
Beam code by Gunbuddy

Beam() proc will only allow one beam to come from a source at a time.  Attempting to call it more than
once at a time per source will cause graphical errors.
Also, the icon used for the beam will have to be vertical and 32x32.
The math involved assumes that the icon is vertical to begin with so unless you want to adjust the math,
its easier to just keep the beam vertical.
BeamTarget represents the target for the beam, basically just means the other end.
Time is the duration to draw the beam
Icon is obviously which icon to use for the beam, default is beam.dmi
Icon_state is what icon state is used. Default is b_beam which is a blue beam.
Maxdistance is the longest range the beam will persist before it gives up.
*/
/atom/proc/Beam(atom/BeamTarget, icon_state = "b_beam", icon = 'icons/effects/beam.dmi', time = 50, maxdistance = 10, beam_type = /obj/effect/ebeam)
	var/datum/beam/newbeam = new(src, BeamTarget, icon, icon_state, time, maxdistance, beam_type)
	spawn(0)
		newbeam.Start()
	return newbeam

//All atoms
/atom/proc/examine(mob/user, distance = -1)
	//This reformat names to get a/an properly working on item descriptions when they are bloody
	var/f_name = "\a [src]."
	if(src.blood_DNA && !istype(src, /obj/effect/decal))
		if(gender == PLURAL)
			f_name = "some "
		else
			f_name = "a "
		f_name += "<span class='danger'>blood-stained</span> [name]!"

	to_chat(user, "\icon[src] That's [f_name]")

	if(desc)
		to_chat(user, desc)

	return distance == -1 || (get_dist(src, user) <= distance)

/atom/proc/relaymove()
	return

//called to set the atom's dir and used to add behaviour to dir-changes
/atom/proc/set_dir(new_dir)
	. = new_dir != dir
	dir = new_dir

/atom/proc/ex_act()
	return

/atom/proc/blob_act()
	return

/atom/proc/fire_act()
	return

/atom/proc/hitby(atom/movable/AM as mob|obj)
	return

/atom/proc/add_hiddenprint(mob/living/M as mob)
	if(isnull(M))
		return
	if(isnull(M.key))
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!istype(H.dna, /datum/dna))
			return 0
		if(H.gloves)
			if(src.fingerprintslast != H.key)
				src.fingerprintshidden += "\[[time_stamp()]\] (Wearing gloves). Real name: [H.real_name], Key: [H.key]"
				src.fingerprintslast = H.key
			return 0
		if(!src.fingerprints)
			if(src.fingerprintslast != H.key)
				src.fingerprintshidden += "\[[time_stamp()]\] Real name: [H.real_name], Key: [H.key]"
				src.fingerprintslast = H.key
			return 1
	else
		if(src.fingerprintslast != M.key)
			src.fingerprintshidden += "\[[time_stamp()]\] Real name: [M.real_name], Key: [M.key]"
			src.fingerprintslast = M.key
	return

/atom/proc/add_fingerprint(mob/living/M as mob)
	if(isnull(M))
		return
	if(isAI(M))
		return
	if(isnull(M.key))
		return
	if(ishuman(M))
		//Add the list if it does not exist.
		if(!fingerprintshidden)
			fingerprintshidden = list()

		//Fibers~
		add_fibers(M)

		//He has no prints!
		if(mFingerprints in M.mutations)
			if(fingerprintslast != M.key)
				fingerprintshidden += "(Has no fingerprints) Real name: [M.real_name], Key: [M.key]"
				fingerprintslast = M.key
			return 0		//Now, lets get to the dirty work.
		//First, make sure their DNA makes sense.
		var/mob/living/carbon/human/H = M
		if(!istype(H.dna, /datum/dna) || !H.dna.uni_identity || length(H.dna.uni_identity) != 32)
			if(!istype(H.dna, /datum/dna))
				H.dna = new /datum/dna(null)
				H.dna.real_name = H.real_name
		H.check_dna()

		//Now, deal with gloves.
		if(H.gloves && H.gloves != src)
			if(fingerprintslast != H.key)
				fingerprintshidden += "\[[time_stamp()]\](Wearing gloves). Real name: [H.real_name], Key: [H.key]"
				fingerprintslast = H.key
			H.gloves.add_fingerprint(M)

		//Deal with gloves the pass finger/palm prints.
		if(H.gloves != src)
			if(prob(75) && istype(H.gloves, /obj/item/clothing/gloves/latex))
				return 0
			else if(H.gloves && !istype(H.gloves, /obj/item/clothing/gloves/latex))
				return 0

		//More adminstuffz
		if(fingerprintslast != H.key)
			fingerprintshidden += "\[[time_stamp()]\]Real name: [H.real_name], Key: [H.key]"
			fingerprintslast = H.key

		//Make the list if it does not exist.
		if(!fingerprints)
			fingerprints = list()

		//Hash this shit.
		var/full_print = md5(H.dna.uni_identity)

		// Add the fingerprints
		//
		if(fingerprints[full_print])
			switch(stringpercent(fingerprints[full_print]))		//tells us how many stars are in the current prints.
				if(28 to 32)
					if(prob(1))
						fingerprints[full_print] = full_print		// You rolled a one buddy.
					else
						fingerprints[full_print] = stars(full_print, rand(0, 40)) // 24 to 32

				if(24 to 27)
					if(prob(3))
						fingerprints[full_print] = full_print		//Sucks to be you.
					else
						fingerprints[full_print] = stars(full_print, rand(15, 55)) // 20 to 29

				if(20 to 23)
					if(prob(5))
						fingerprints[full_print] = full_print		//Had a good run didn't ya.
					else
						fingerprints[full_print] = stars(full_print, rand(30, 70)) // 15 to 25

				if(16 to 19)
					if(prob(5))
						fingerprints[full_print] = full_print		//Welp.
					else
						fingerprints[full_print]  = stars(full_print, rand(40, 100))  // 0 to 21

				if(0 to 15)
					if(prob(5))
						fingerprints[full_print] = stars(full_print, rand(0, 50))	// small chance you can smudge.
					else
						fingerprints[full_print] = full_print
		else
			fingerprints[full_print] = stars(full_print, rand(0, 20))	//Initial touch, not leaving much evidence the first time.

		return 1
	else
		//Smudge up dem prints some
		if(fingerprintslast != M.key)
			fingerprintshidden += "\[[time_stamp()]\]Real name: [M.real_name], Key: [M.key]"
			fingerprintslast = M.key

	//Cleaning up shit.
	if(fingerprints && !fingerprints.len)
		qdel(fingerprints)
	return


/atom/proc/transfer_fingerprints_to(atom/A)
	if(!islist(A.fingerprints))
		A.fingerprints = list()
	if(!islist(A.fingerprintshidden))
		A.fingerprintshidden = list()

	//skytodo
	//A.fingerprints |= fingerprints			//detective
	//A.fingerprintshidden |= fingerprintshidden	//admin
	if(fingerprints)
		A.fingerprints |= fingerprints.Copy()			//detective
	if(fingerprintshidden)
		A.fingerprintshidden |= fingerprintshidden.Copy()	//admin	A.fingerprintslast = fingerprintslast


//returns 1 if made bloody, returns 0 otherwise
/atom/proc/add_blood(mob/living/carbon/human/M as mob)
	if(flags & NOBLOODY)
		return 0
	. = 1
	if(!ishuman(M))
		return 0
	if(!istype(M.dna, /datum/dna))
		M.dna = new /datum/dna(null)
		M.dna.real_name = M.real_name
	M.check_dna()
	if(!blood_DNA || !islist(blood_DNA))	//if our list of DNA doesn't exist yet (or isn't a list) initialise it.
		blood_DNA = list()
	blood_color = "#A10808"
	if(M.species)
		blood_color = M.species.blood_color
	return

/atom/proc/add_vomit_floor(mob/living/carbon/M as mob, toxvomit = 0)
	if(istype(src, /turf/simulated))
		var/obj/effect/decal/cleanable/vomit/this = new /obj/effect/decal/cleanable/vomit(src)

		// Make toxins vomit look different
		if(toxvomit)
			this.icon_state = "vomittox_[pick(1, 4)]"


/atom/proc/clean_blood()
	src.germ_level = 0
	if(islist(blood_DNA))
		qdel(blood_DNA)
		return 1


/atom/proc/get_global_map_pos()
	if(!islist(global_map) || isemptylist(global_map))
		return
	var/cur_x = null
	var/cur_y = null
	var/list/y_arr = null
	for(cur_x = 1, cur_x <= global_map.len, cur_x++)
		y_arr = global_map[cur_x]
		cur_y = y_arr.Find(src.z)
		if(cur_y)
			break
//	world << "X = [cur_x]; Y = [cur_y]"
	if(cur_x && cur_y)
		return list("x" = cur_x, "y" = cur_y)
	else
		return 0

/atom/proc/checkpass(passflag)
	return pass_flags & passflag