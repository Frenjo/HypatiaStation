GLOBAL_GLOBL_LIST_INIT(global_map, null)
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
	plane = DEFAULT_PLANE
	layer = 2

	var/level = 2

	// Stores atom-specific bitflag values.
	// Overridden on subtypes or manipulated with *_ATOM_FLAGS(ATOM, FLAGS) macros.
	var/atom_flags
	// Stores pass bitflag values.
	// Overriden on subtypes or manipulated with *_PASS_FLAGS(ATOM, FLAGS) macros.
	var/pass_flags

	var/list/fingerprints
	var/list/hidden_fingerprints
	// The last fingerprints that touched this atom.
	var/last_fingerprints = null

	var/list/blood_DNA
	var/blood_color

	var/last_bumped = 0
	var/throwpass = 0
	// The higher the germ level, the more germ on this atom.
	var/germ_level = GERM_LEVEL_AMBIENT

	// The atom's holder for chemistry reagents.
	var/datum/reagents/reagents = null
	// var/chem_is_open_container has been replaced by the OPENCONTAINER flag and /atom/proc/is_open_container().

	//Detective Work, used for the duplicate data points kept in the scanners
	var/list/original_atom

/atom/New()
	. = ..()
	// If the game is already underway, initialise will no longer be called for us.
	if(global.CTmaster?.initialised)
		queue_for_initialisation(src)

/atom/proc/initialise()
	SHOULD_CALL_PARENT(TRUE)

	if(GC_DESTROYED(src))
		CRASH("GC: -- [type] had initialise() called after qdel() --")

/atom/Del()
	if(!GC_DESTROYED(src) && isnotnull(loc))
		testing("GC: -- [type] was deleted via del() rather than qdel() --")
		Destroy()
	else if(!GC_DESTROYED(src))
		testing("GC: [type] was deleted via GC without qdel()") //Not really a huge issue but from now on, please qdel()
//	else
//		testing("GC: [type] was deleted via GC with qdel()")
	. = ..()

/atom/Destroy()
	dequeue_for_initialisation(src)

	density = FALSE
	invisibility = INVISIBILITY_MAXIMUM
	set_opacity(0)

	if(isnotnull(reagents))
		QDEL_NULL(reagents)

	return ..()

/atom/proc/throw_impact(atom/hit_atom, speed)
	if(isliving(hit_atom))
		var/mob/living/M = hit_atom
		M.hitby(src, speed)

	else if(isobj(hit_atom))
		var/obj/O = hit_atom
		if(!O.anchored)
			step(O, dir)
		O.hitby(src, speed)

	else if(isturf(hit_atom))
		var/turf/T = hit_atom
		if(T.density)
			spawn(2)
				step(src, turn(dir, 180))
			if(isliving(src))
				var/mob/living/M = src
				M.take_organ_damage(20)

/atom/proc/check_eye(mob/user)
	if(isAI(user)) // WHYYYY
		return TRUE
	return FALSE

/atom/proc/on_reagent_change()
	return

/atom/proc/Bumped(atom/movable/AM)
	return

/atom/proc/meteorhit(obj/meteor)
	return

/atom/proc/allow_drop()
	return 1

/atom/proc/CheckExit()
	return 1

/atom/proc/HasProximity(atom/movable/AM)
	return

/atom/proc/in_contents_of(container)//can take class or object instance as argument
	if(ispath(container))
		if(istype(loc, container))
			return TRUE
	else if(src in container)
		return TRUE
	return FALSE

/*
 *	atom/proc/search_contents_for(path,list/filter_path=null)
 * Recursevly searches all atom contens (including contents contents and so on).
 *
 * ARGS: path - search atom contents for atoms of this type
 *		list/filter_path - if set, contents of atoms not of types in this list are excluded from search.
 *
 * RETURNS: list of found atoms
 */
/atom/proc/search_contents_for(path, list/filter_path = null)
	. = list()
	for_no_type_check(var/atom/movable/mover, src)
		if(istype(mover, path))
			. += mover
		if(filter_path)
			var/pass = 0
			for(var/type in filter_path)
				pass |= istype(mover, type)
			if(!pass)
				continue
		if(length(mover.contents))
			. += mover.search_contents_for(path, filter_path)

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

/atom/proc/relaymove()
	return

// Called to set the atom's dir.
// Can be used to add behaviour to dir-changes.
/atom/proc/set_dir(new_dir)
	SHOULD_CALL_PARENT(TRUE)

	. = new_dir != dir
	dir = new_dir

/atom/proc/hitby(atom/movable/AM)
	return

// Returns TRUE if made bloody, returns FALSE otherwise.
/atom/proc/add_blood(mob/living/carbon/human/M)
	if(HAS_ATOM_FLAGS(src, ATOM_FLAG_NO_BLOODY))
		return FALSE
	if(!ishuman(M))
		return FALSE

	if(!istype(M.dna, /datum/dna))
		M.dna = new /datum/dna(null)
		M.dna.real_name = M.real_name
	M.check_dna()
	LAZYINITLIST(blood_DNA) // If our list of DNA doesn't exist yet (or isn't a list) initialise it.
	blood_color = "#A10808"
	if(M.species)
		blood_color = M.species.blood_color
	return TRUE

/atom/proc/add_vomit_floor(mob/living/carbon/M, toxvomit = FALSE)
	if(isopenturf(src))
		var/obj/effect/decal/cleanable/vomit/this = new /obj/effect/decal/cleanable/vomit(src)
		// Make toxins vomit look different
		if(toxvomit)
			this.icon_state = "vomittox_[pick(1, 4)]"

/atom/proc/clean_blood()
	germ_level = 0
	if(islist(blood_DNA))
		qdel(blood_DNA)
		return 1

/atom/proc/get_global_map_pos()
	if(!islist(GLOBL.global_map) || isemptylist(GLOBL.global_map))
		return

	var/cur_x = null
	var/cur_y = null
	var/list/y_arr = null
	for(cur_x in 1 to length(GLOBL.global_map))
		y_arr = GLOBL.global_map[cur_x]
		cur_y = y_arr.Find(src.z)
		if(cur_y)
			break
	//to_world("X = [cur_x]; Y = [cur_y]")
	if(cur_x && cur_y)
		return list("x" = cur_x, "y" = cur_y)
	else
		return 0