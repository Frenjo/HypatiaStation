///////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////NEW SLIME CORE REACTIONS/////////////////////////////////////////////
//Grey
/datum/chemical_reaction/slimespawn
	name = "Slime Spawn"
	result = null
	required_reagents = list("plasma" = 5)
	result_amount = 1
	required_container = /obj/item/slime_extract/grey
	required_other = 1

/datum/chemical_reaction/slimespawn/on_reaction(datum/reagents/holder)
	var/turf/location = GET_TURF(holder.my_atom)
	location.visible_message(SPAN_WARNING("Infused with plasma, the core begins to quiver and grow, and soon a new baby slime emerges from it!"))
	new /mob/living/carbon/slime(location)

/datum/chemical_reaction/slimemonkey
	name = "Slime Monkey"
	result = null
	required_reagents = list("blood" = 5)
	result_amount = 1
	required_container = /obj/item/slime_extract/grey
	required_other = 1

/datum/chemical_reaction/slimemonkey/on_reaction(datum/reagents/holder)
	var/turf/location = GET_TURF(holder.my_atom)
	for(var/i = 1, i <= 3, i++)
		new /obj/item/reagent_holder/food/snacks/monkeycube(location)

//Green
/datum/chemical_reaction/slimemutate
	name = "Mutation Toxin"
	result = "mutationtoxin"
	required_reagents = list("plasma" = 5)
	result_amount = 1
	required_other = 1
	required_container = /obj/item/slime_extract/green

//Metal
/datum/chemical_reaction/slimemetal
	name = "Slime Metal"
	result = null
	required_reagents = list("plasma" = 5)
	result_amount = 1
	required_container = /obj/item/slime_extract/metal
	required_other = 1

/datum/chemical_reaction/slimemetal/on_reaction(datum/reagents/holder)
	var/turf/location = GET_TURF(holder.my_atom)
	new /obj/item/stack/sheet/steel(location, 15)
	new /obj/item/stack/sheet/plasteel(location, 5)

//Gold
/datum/chemical_reaction/slimecrit
	name = "Slime Crit"
	result = null
	required_reagents = list("plasma" = 5)
	result_amount = 1
	required_container = /obj/item/slime_extract/gold
	required_other = 1

/datum/chemical_reaction/slimecrit/on_reaction(datum/reagents/holder)
	/*var/blocked = list(/mob/living/simple/hostile,
		/mob/living/simple/hostile/pirate,
		/mob/living/simple/hostile/pirate/ranged,
		/mob/living/simple/hostile/russian,
		/mob/living/simple/hostile/russian/ranged,
		/mob/living/simple/hostile/syndicate,
		/mob/living/simple/hostile/syndicate/melee,
		/mob/living/simple/hostile/syndicate/melee/space,
		/mob/living/simple/hostile/syndicate/ranged,
		/mob/living/simple/hostile/syndicate/ranged/space,
		/mob/living/simple/hostile/alien/queen/large,
		/mob/living/simple/hostile/faithless,
		/mob/living/simple/hostile/panther,
		/mob/living/simple/hostile/snake,
		/mob/living/simple/hostile/retaliate,
		/mob/living/simple/hostile/retaliate/clown
		)//exclusion list for things you don't want the reaction to create.
	var/list/critters = typesof(/mob/living/simple/hostile) - blocked // list of possible hostile mobs

	playsound(get_turf_loc(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)

	for(var/mob/living/carbon/human/M in viewers(get_turf_loc(holder.my_atom), null))
		if(M:eyecheck() <= 0)
			flick("e_flash", M.flash)

	for(var/i = 1, i <= 5, i++)
		var/chosen = pick(critters)
		var/mob/living/simple/hostile/C = new chosen
		C.faction = "slimesummon"
		C.loc = get_turf_loc(holder.my_atom)
		if(prob(50))
			for(var/j = 1, j <= rand(1, 3), j++)
				step(C, pick(NORTH,SOUTH,EAST,WEST))*/
	holder.my_atom.visible_message(SPAN_WARNING("The slime core fizzles disappointingly..."))

//Silver
/datum/chemical_reaction/slimebork
	name = "Slime Bork"
	result = null
	required_reagents = list("plasma" = 5)
	result_amount = 1
	required_container = /obj/item/slime_extract/silver
	required_other = 1

/datum/chemical_reaction/slimebork/on_reaction(datum/reagents/holder)
	var/turf/location = GET_TURF(holder.my_atom)
	var/list/borks = SUBTYPESOF(/obj/item/reagent_holder/food/snacks)
	// BORK BORK BORK

	playsound(location, 'sound/effects/phasein.ogg', 100, 1)

	for(var/mob/living/carbon/human/M in viewers(location, null))
		if(M.eyecheck() <= 0)
			flick("e_flash", M.flash)

	for(var/i = 1, i <= 4 + rand(1, 2), i++)
		var/chosen = pick(borks)
		var/obj/B = new chosen(location)
		if(isnotnull(B))
			if(prob(50))
				for(var/j = 1, j <= rand(1, 3), j++)
					step(B, pick(NORTH, SOUTH, EAST, WEST))

//Blue
/datum/chemical_reaction/slimefrost
	name = "Slime Frost Oil"
	result = "frostoil"
	required_reagents = list("plasma" = 5)
	result_amount = 10
	required_container = /obj/item/slime_extract/blue
	required_other = 1

//Dark Blue
/datum/chemical_reaction/slimefreeze
	name = "Slime Freeze"
	result = null
	required_reagents = list("plasma" = 5)
	result_amount = 1
	required_container = /obj/item/slime_extract/darkblue
	required_other = 1

/datum/chemical_reaction/slimefreeze/on_reaction(datum/reagents/holder)
	var/turf/location = GET_TURF(holder.my_atom)
	holder.my_atom.visible_message(SPAN_WARNING("The slime extract begins to vibrate violently!"))
	sleep(50)
	playsound(location, 'sound/effects/phasein.ogg', 100, 1)
	for(var/mob/living/M in range(location, 7))
		M.bodytemperature -= 140
		to_chat(M, SPAN_INFO("You feel a chill!"))

//Orange
/datum/chemical_reaction/slimecasp
	name = "Slime Capsaicin Oil"
	result = "capsaicin"
	required_reagents = list("blood" = 5)
	result_amount = 10
	required_container = /obj/item/slime_extract/orange
	required_other = 1

/datum/chemical_reaction/slimefire
	name = "Slime fire"
	result = null
	required_reagents = list("plasma" = 5)
	result_amount = 1
	required_container = /obj/item/slime_extract/orange
	required_other = 1

/datum/chemical_reaction/slimefire/on_reaction(datum/reagents/holder)
	var/turf/location = GET_TURF(holder.my_atom)
	holder.my_atom.visible_message(SPAN_WARNING("The slime extract begins to vibrate violently!"))
	sleep(50)
	for(var/turf/open/floor/target_tile in range(0, location))
		target_tile.assume_gas(/decl/xgm_gas/plasma, 25, 1400)
		spawn(0)
			target_tile.hotspot_expose(700, 400)

//Yellow
/datum/chemical_reaction/slimeoverload
	name = "Slime EMP"
	result = null
	required_reagents = list("blood" = 5)
	result_amount = 1
	required_container = /obj/item/slime_extract/yellow
	required_other = 1

/datum/chemical_reaction/slimeoverload/on_reaction(datum/reagents/holder, created_volume)
	empulse(GET_TURF(holder.my_atom), 3, 7)

/datum/chemical_reaction/slimecell
	name = "Slime Powercell"
	result = null
	required_reagents = list("plasma" = 5)
	result_amount = 1
	required_container = /obj/item/slime_extract/yellow
	required_other = 1

/datum/chemical_reaction/slimecell/on_reaction(datum/reagents/holder, created_volume)
	new /obj/item/cell/slime(GET_TURF(holder.my_atom))

/datum/chemical_reaction/slimeglow
	name = "Slime Glow"
	result = null
	required_reagents = list("water" = 5)
	result_amount = 1
	required_container = /obj/item/slime_extract/yellow
	required_other = 1

/datum/chemical_reaction/slimeglow/on_reaction(datum/reagents/holder)
	var/turf/location = GET_TURF(holder.my_atom)
	holder.my_atom.visible_message(SPAN_WARNING("The slime begins to emit a soft light."))
	new /obj/item/flashlight/slime(location)

//Purple
/datum/chemical_reaction/slimepsteroid
	name = "Slime Steroid"
	result = null
	required_reagents = list("plasma" = 5)
	result_amount = 1
	required_container = /obj/item/slime_extract/purple
	required_other = 1

/datum/chemical_reaction/slimepsteroid/on_reaction(datum/reagents/holder)
	new /obj/item/slimesteroid(GET_TURF(holder.my_atom))

/datum/chemical_reaction/slimejam
	name = "Slime Jam"
	result = "slimejelly"
	required_reagents = list("sugar" = 5)
	result_amount = 10
	required_container = /obj/item/slime_extract/purple
	required_other = 1

//Dark Purple
/datum/chemical_reaction/slimeplasma
	name = "Slime Plasma"
	result = null
	required_reagents = list("plasma" = 5)
	result_amount = 1
	required_container = /obj/item/slime_extract/darkpurple
	required_other = 1

/datum/chemical_reaction/slimeplasma/on_reaction(datum/reagents/holder)
	new /obj/item/stack/sheet/plasma(GET_TURF(holder.my_atom), 10)

//Red
/datum/chemical_reaction/slimeglycerol
	name = "Slime Glycerol"
	result = "glycerol"
	required_reagents = list("plasma" = 5)
	result_amount = 8
	required_container = /obj/item/slime_extract/red
	required_other = 1

/datum/chemical_reaction/slimebloodlust
	name = "Bloodlust"
	result = null
	required_reagents = list("blood" = 5)
	result_amount = 1
	required_container = /obj/item/slime_extract/red
	required_other = 1

/datum/chemical_reaction/slimebloodlust/on_reaction(datum/reagents/holder)
	for(var/mob/living/carbon/slime/slime in viewers(GET_TURF(holder.my_atom), null))
		slime.tame = 0
		slime.rabid = 1
		slime.visible_message(SPAN_WARNING("The [slime] is driven into a frenzy!"))

//Pink
/datum/chemical_reaction/slimeppotion
	name = "Slime Potion"
	result = null
	required_reagents = list("plasma" = 5)
	result_amount = 1
	required_container = /obj/item/slime_extract/pink
	required_other = 1

/datum/chemical_reaction/slimeppotion/on_reaction(datum/reagents/holder)
	new /obj/item/slimepotion(GET_TURF(holder.my_atom))

//Black
/datum/chemical_reaction/slimemutate2
	name = "Advanced Mutation Toxin"
	result = "amutationtoxin"
	required_reagents = list("plasma" = 5)
	result_amount = 1
	required_other = 1
	required_container = /obj/item/slime_extract/black

//Oil
/datum/chemical_reaction/slimeexplosion
	name = "Slime Explosion"
	result = null
	required_reagents = list("plasma" = 5)
	result_amount = 1
	required_container = /obj/item/slime_extract/oil
	required_other = 1

/datum/chemical_reaction/slimeexplosion/on_reaction(datum/reagents/holder)
	holder.my_atom.visible_message(SPAN_WARNING("The slime extract begins to vibrate violently!"))
	sleep(50)
	explosion(GET_TURF(holder.my_atom), 1 , 3, 6)

//Light Pink
/datum/chemical_reaction/slimepotion2
	name = "Slime Potion 2"
	result = null
	result_amount = 1
	required_container = /obj/item/slime_extract/lightpink
	required_reagents = list("plasma" = 5)
	required_other = 1

/datum/chemical_reaction/slimepotion2/on_reaction(datum/reagents/holder)
	new /obj/item/slimepotion2(GET_TURF(holder.my_atom))

//Adamantine
/datum/chemical_reaction/slimegolem
	name = "Slime Golem"
	result = null
	required_reagents = list("plasma" = 5)
	result_amount = 1
	required_container = /obj/item/slime_extract/adamantine
	required_other = 1

/datum/chemical_reaction/slimegolem/on_reaction(datum/reagents/holder)
	var/obj/effect/golemrune/Z = new /obj/effect/golemrune(GET_TURF(holder.my_atom))
	Z.announce_to_ghosts()

/////////////////////////////////////OLD SLIME CORE REACTIONS ///////////////////////////////
/*
/datum/chemical_reaction/slimepepper
	name = "Slime Condensedcapaicin"
	result = "condensedcapsaicin"
	required_reagents = list("sugar" = 1)
	result_amount = 1
	required_container = /obj/item/slime_core
	required_other = 1


/datum/chemical_reaction/slimefrost
	name = "Slime Frost Oil"
	result = "frostoil"
	required_reagents = list("water" = 1)
	result_amount = 1
	required_container = /obj/item/slime_core
	required_other = 1


/datum/chemical_reaction/slimeglycerol
	name = "Slime Glycerol"
	result = "glycerol"
	required_reagents = list("blood" = 1)
	result_amount = 1
	required_container = /obj/item/slime_core
	required_other = 1


/datum/chemical_reaction/slime_explosion
	name = "Slime Explosion"
	result = null
	required_reagents = list("blood" = 1)
	result_amount = 2
	required_container = /obj/item/slime_core
	required_other = 2

/datum/chemical_reaction/slime_explosion/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/turf/location = GET_TURF(holder.my_atom)
	var/datum/effect/system/reagents_explosion/e = new()
	e.set_up(round (created_volume/10, 1), location, 0, 0)
	e.start()

	holder.clear_reagents()


/datum/chemical_reaction/slimejam
	name = "Slime Jam"
	result = "slimejelly"
	required_reagents = list("water" = 1)
	result_amount = 1
	required_container = /obj/item/slime_core
	required_other = 2


/datum/chemical_reaction/slimesynthi
	name = "Slime Synthetic Flesh"
	result = null
	required_reagents = list("sugar" = 1)
	result_amount = 1
	required_container = /obj/item/slime_core
	required_other = 2

/datum/chemical_reaction/slimesynthi/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/turf/location = GET_TURF(holder.my_atom)
	new /obj/item/reagent_holder/food/snacks/meat/syntiflesh(location)


/datum/chemical_reaction/slimeenzyme
	name = "Slime Enzyme"
	result = "enzyme"
	required_reagents = list("blood" = 1, "water" = 1)
	result_amount = 2
	required_container = /obj/item/slime_core
	required_other = 3


/datum/chemical_reaction/slimeplasma
	name = "Slime Plasma"
	result = "plasma"
	required_reagents = list("sugar" = 1, "blood" = 2)
	result_amount = 2
	required_container = /obj/item/slime_core
	required_other = 3


/datum/chemical_reaction/slimevirus
	name = "Slime Virus"
	result = null
	required_reagents = list("sugar" = 1, "sacid" = 1)
	result_amount = 2
	required_container = /obj/item/slime_core
	required_other = 3

/datum/chemical_reaction/slimevirus/on_reaction(var/datum/reagents/holder, var/created_volume)
	holder.clear_reagents()

	var/virus = pick(/datum/disease/advance/flu, /datum/disease/advance/cold, \
		/datum/disease/pierrot_throat, /datum/disease/fake_gbs, \
		/datum/disease/brainrot, /datum/disease/magnitis)

	var/datum/disease/F = new virus(0)
	var/list/data = list("viruses"= list(F))
	holder.add_reagent("blood", 20, data)

	holder.add_reagent("cyanide", rand(1,10))


/datum/chemical_reaction/slimeteleport
	name = "Slime Teleport"
	result = null
	required_reagents = list("pacid" = 2, "mutagen" = 2)
	required_catalysts = list("plasma" = 1)
	result_amount = 1
	required_container = /obj/item/slime_core
	required_other = 4

/datum/chemical_reaction/slimeteleport/on_reaction(var/datum/reagents/holder, var/created_volume)
	// Calculate new position (searches through beacons in world)
	var/obj/item/radio/beacon/chosen
	var/list/possible = list()
	for(var/obj/item/radio/beacon/W in GLOBL.movable_atom_list)
		possible += W

	if(length(possible))
		chosen = pick(possible)

	if(chosen)
	// Calculate previous position for transition
		var/turf/FROM = get_turf_loc(holder.my_atom) // the turf of origin we're travelling FROM
		var/turf/TO = get_turf_loc(chosen)			 // the turf of origin we're travelling TO

		playsound(TO, 'sound/effects/phasein.ogg', 100, 1)

		var/list/flashers = list()
		for(var/mob/living/carbon/human/M in viewers(TO, null))
			if(M:eyecheck() <= 0)
				flick("e_flash", M.flash)
				flashers += M

		var/y_distance = TO.y - FROM.y
		var/x_distance = TO.x - FROM.x
		for (var/atom/movable/A in range(2, FROM )) // iterate thru list of mobs in the area
			if(istype(A, /obj/item/radio/beacon))
				continue // don't teleport beacons because that's just insanely stupid
			if(A.anchored && !isghost(A))
				continue // don't teleport anchored things (computers, tables, windows, grilles, etc) because this causes problems!
			// do teleport ghosts however because hell why not

			var/turf/newloc = locate(A.x + x_distance, A.y + y_distance, TO.z) // calculate the new place
			if(!A.Move(newloc)) // if the atom, for some reason, can't move, FORCE them to move! :) We try Move() first to invoke any movement-related checks the atom needs to perform after moving
				A.loc = locate(A.x + x_distance, A.y + y_distance, TO.z)

			spawn()
				if(ismob(A) && !(A in flashers)) // don't flash if we're already doing an effect
					var/mob/M = A
					if(M.client)
						var/obj/blueeffect = new /obj(src)
						blueeffect.screen_loc = "WEST,SOUTH to EAST,NORTH"
						blueeffect.icon = 'icons/effects/effects.dmi'
						blueeffect.icon_state = "shieldsparkles"
						blueeffect.layer = 17
						blueeffect.mouse_opacity = FALSE
						M.client.screen += blueeffect
						sleep(20)
						M.client.screen -= blueeffect
						del(blueeffect)


/datum/chemical_reaction/slimecrit
	name = "Slime Crit"
	result = null
	required_reagents = list("sacid" = 1, "blood" = 1)
	required_catalysts = list("plasma" = 1)
	result_amount = 1
	required_container = /obj/item/slime_core
	required_other = 4

/datum/chemical_reaction/slimecrit/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/blocked = list(/mob/living/simple/hostile,
		/mob/living/simple/hostile/pirate,
		/mob/living/simple/hostile/pirate/ranged,
		/mob/living/simple/hostile/russian,
		/mob/living/simple/hostile/russian/ranged,
		/mob/living/simple/hostile/syndicate,
		/mob/living/simple/hostile/syndicate/melee,
		/mob/living/simple/hostile/syndicate/melee/space,
		/mob/living/simple/hostile/syndicate/ranged,
		/mob/living/simple/hostile/syndicate/ranged/space,
		/mob/living/simple/hostile/alien/queen/large,
		/mob/living/simple/clown
		)//exclusion list for things you don't want the reaction to create.
	var/list/critters = typesof(/mob/living/simple/hostile) - blocked // list of possible hostile mobs

	playsound(get_turf_loc(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)

	for(var/mob/living/carbon/human/M in viewers(get_turf_loc(holder.my_atom), null))
		if(M:eyecheck() <= 0)
			flick("e_flash", M.flash)

	for(var/i = 1, i <= created_volume, i++)
		var/chosen = pick(critters)
		var/mob/living/simple/hostile/C = new chosen
		C.loc = get_turf_loc(holder.my_atom)
		if(prob(50))
			for(var/j = 1, j <= rand(1, 3), j++)
				step(C, pick(NORTH, SOUTH, EAST, WEST))


/datum/chemical_reaction/slimebork
	name = "Slime Bork"
	result = null
	required_reagents = list("sugar" = 1, "water" = 1)
	result_amount = 2
	required_container = /obj/item/slime_core
	required_other = 4

/datum/chemical_reaction/slimebork/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/list/borks = typesof(/obj/item/reagent_holder/food/snacks) - /obj/item/reagent_holder/food/snacks
	// BORK BORK BORK
	playsound(get_turf_loc(holder.my_atom), 'sound/effects/phasein.ogg', 100, 1)

	for(var/mob/living/carbon/human/M in viewers(get_turf_loc(holder.my_atom), null))
		if(M:eyecheck() <= 0)
			flick("e_flash", M.flash)

	for(var/i = 1, i <= created_volume + rand(1,2), i++)
		var/chosen = pick(borks)
		var/obj/B = new chosen
		if(B)
			B.loc = get_turf_loc(holder.my_atom)
			if(prob(50))
				for(var/j = 1, j <= rand(1, 3), j++)
					step(B, pick(NORTH, SOUTH, EAST, WEST))


/datum/chemical_reaction/slimechloral
	name = "Slime Chloral"
	result = "chloralhydrate"
	required_reagents = list("blood" = 1, "water" = 2)
	result_amount = 2
	required_container = /obj/item/slime_core
	required_other = 5


/datum/chemical_reaction/slimeretro
	name = "Slime Retro"
	result = null
	required_reagents = list("sugar" = 1)
	result_amount = 1
	required_container = /obj/item/slime_core
	required_other = 5

/datum/chemical_reaction/slimeretro/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/datum/disease/F = new /datum/disease/dna_retrovirus(0)
	var/list/data = list("viruses"= list(F))
	holder.add_reagent("blood", 20, data)


/datum/chemical_reaction/slimefoam
	name = "Slime Foam"
	result = null
	required_reagents = list("sacid" = 1)
	result_amount = 2
	required_container = /obj/item/slime_core
	required_other = 5

/datum/chemical_reaction/slimefoam/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/turf/location = GET_TURF(holder.my_atom)
	for(var/mob/M in viewers(5, location))
		M << "\red The solution violently bubbles!"

	location = GET_TURF(holder.my_atom)

	for(var/mob/M in viewers(5, location))
		M << "\red The solution spews out foam!"

	//to_world("Holder volume is [holder.total_volume]")
	//for(var/datum/reagent/R in holder.reagent_list)
		//to_world("[R.name] = [R.volume]")

	var/datum/effect/system/foam_spread/s = new()
	s.set_up(created_volume, location, holder, 0)
	s.start()
	holder.clear_reagents()
	return
*/