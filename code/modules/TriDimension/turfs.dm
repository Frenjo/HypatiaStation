/turf/open/floor/open
	name = "open space"
	icon_state = "black"

	density = FALSE

	intact = 0
	pathweight = 100000 //Seriously, don't try and path over this one numbnuts

	var/icon/darkoverlays = null
	var/turf/floorbelow
	var/list/overlay_references

/turf/open/floor/open/New()
	. = ..()
	getbelow()

/turf/open/floor/open/Enter(atom/movable/enterer)
	if(..()) //TODO make this check if gravity is active (future use) - Sukasa
		spawn(1)
			// only fall down in defined areas (read: areas with artificial gravitiy)
			if(!floorbelow) //make sure that there is actually something below
				if(!getbelow())
					return
			if(enterer)
				var/area/areacheck = get_area(src)
				var/blocked = FALSE
				var/soft = FALSE
				for(var/atom/A in floorbelow.contents)
					if(A.density)
						blocked = TRUE
						break
					if(istype(A, /obj/machinery/atmospherics/pipe/zpipe/up) && istype(enterer, /obj/item/pipe))
						blocked = TRUE
						break
					if(istype(A, /obj/structure/disposalpipe/up) && istype(enterer, /obj/item/pipe))
						blocked = TRUE
						break
					if(istype(A, /obj/multiz/stairs))
						soft = TRUE
						//dont break here, since we still need to be sure that it isnt blocked

				if(soft || (!blocked && !(istype(areacheck, /area/space))))
					enterer.Move(floorbelow)
					if(!soft && ishuman(enterer))
						var/mob/living/carbon/human/H = enterer
						var/damage = 5
						H.apply_damage(min(rand(-damage, damage), 0), BRUTE, "head")
						H.apply_damage(min(rand(-damage, damage), 0), BRUTE, "chest")
						H.apply_damage(min(rand(-damage, damage), 0), BRUTE, "l_leg")
						H.apply_damage(min(rand(-damage, damage), 0), BRUTE, "r_leg")
						H.apply_damage(min(rand(-damage, damage), 0), BRUTE, "l_arm")
						H.apply_damage(min(rand(-damage, damage), 0), BRUTE, "r_arm")
						H:weakened = max(H:weakened, 2)
						H:updatehealth()
	return ..()

// override to make sure nothing is hidden
/turf/open/floor/open/levelupdate()
	for(var/obj/O in src)
		if(O.level == 1)
			O.hide(0)

//overwrite the attackby of space to transform it to openspace if necessary
/turf/space/attackby(obj/item/C, mob/user)
	if(istype(C, /obj/item/stack/cable_coil) && src.hasbelow())
		var/turf/open/floor/open/W = ChangeTurf(/turf/open/floor/open)
		W.attackby(C, user)
		return
	. = ..()

/turf/open/floor/open/ex_act(severity)
	// cant destroy empty space with an ordinary bomb
	return

/turf/open/floor/open/attackby(obj/item/C, mob/user)
	..(C, user)
	if(istype(C, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/cable = C
		cable.turf_place(src, user)
		return

	if(istype(C, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return
		var/obj/item/stack/rods/R = C
		to_chat(user, SPAN_INFO("Constructing support lattice..."))
		playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
		ReplaceWithLattice()
		R.use(1)
		return

	if(istype(C, /obj/item/stack/tile/metal/grey))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/metal/grey/S = C
			qdel(L)
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			S.build(src)
			S.use(1)
			return
		else
			to_chat(user, SPAN_WARNING("The plating is going to need some support."))
	return

/turf/open/floor/open/proc/getbelow()
	var/turf/controllerlocation = locate(1, 1, z)
	for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
		// check if there is something to draw below
		if(!controller.down)
			ChangeTurf(get_base_turf_by_area(src))
			return FALSE
		else
			floorbelow = locate(x, y, controller.down_target)
			return TRUE
	return TRUE

/turf/proc/hasbelow()
	var/turf/controllerlocation = locate(1, 1, z)
	for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
		if(controller.down)
			return TRUE
	return FALSE