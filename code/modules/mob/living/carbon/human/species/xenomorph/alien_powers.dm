/proc/alien_queen_exists(ignore_self, mob/living/carbon/human/self)
	for(var/mob/living/carbon/human/Q in GLOBL.living_mob_list)
		if(self && ignore_self && self == Q)
			continue
		if(Q.species.name != "Xenomorph Queen")
			continue
		if(!Q.key || !Q.client || Q.stat)
			continue
		return 1
	return 0

/mob/living/carbon/human/proc/gain_plasma(amount)
	var/datum/organ/internal/xenos/plasmavessel/I = internal_organs_by_name["plasma vessel"]
	if(!istype(I))
		return

	if(amount)
		I.stored_plasma += amount
	I.stored_plasma = max(0, min(I.stored_plasma, I.max_plasma))

/mob/living/carbon/human/proc/check_alien_ability(cost, needs_foundation, needs_organ)
	var/datum/organ/internal/xenos/plasmavessel/P = internal_organs_by_name["plasma vessel"]
	if(!istype(P))
		to_chat(src, SPAN_DANGER("Your plasma vessel has been removed!"))
		return

	if(needs_organ)
		var/datum/organ/internal/I = internal_organs_by_name[needs_organ]
		if(!I)
			to_chat(src, SPAN_DANGER("Your [needs_organ] has been removed!"))
			return
		else if(I.is_broken())
			to_chat(src, SPAN_DANGER("Your [needs_organ] is too damaged to function!"))
			return

	if(P.stored_plasma < cost)
		to_chat(src, SPAN_WARNING("You don't have enough plasma stored to do that."))
		return 0

	if(needs_foundation)
		var/turf/T = get_turf(src)
		var/has_foundation
		if(T)
			//TODO: Work out the actual conditions this needs.
			if(!istype(T, /turf/space))
				has_foundation = 1
		if(!has_foundation)
			to_chat(src, SPAN_WARNING("You need a solid foundation to do that on."))
			return 0

	P.stored_plasma -= cost
	return 1

// Free abilities.
/mob/living/carbon/human/proc/transfer_plasma(mob/living/carbon/human/M as mob in oview())
	set name = "Transfer Plasma"
	set desc = "Transfer Plasma to another alien"
	set category = "Abilities"

	if(get_dist(src, M) <= 1)
		to_chat(src, SPAN_ALIUM("You need to be closer."))
		return

	var/datum/organ/internal/xenos/plasmavessel/I = M.internal_organs_by_name["plasma vessel"]
	if(!istype(I))
		to_chat(src, SPAN_ALIUM("Their plasma vessel is missing."))
		return

	var/amount = input("Amount:", "Transfer Plasma to [M]") as num
	if(amount)
		amount = abs(round(amount))
		if(check_alien_ability(amount, 0, "plasma vessel"))
			M.gain_plasma(amount)
			to_chat(M, SPAN_ALIUM("[src] has transfered [amount] plasma to you."))
			to_chat(src, SPAN_ALIUM("You have transferred [amount] plasma to [M]."))
	return

// Queen verbs.
/mob/living/carbon/human/proc/lay_egg()
	set name = "Lay Egg (75)"
	set desc = "Lay an egg to produce huggers to impregnate prey with."
	set category = "Abilities"

	if(!global.aliens_allowed)
		to_chat(src, "You begin to lay an egg, but hesitate. You suspect it isn't allowed.")
		verbs -= /mob/living/carbon/human/proc/lay_egg
		return

	if(locate(/obj/effect/alien/egg) in get_turf(src))
		to_chat(src, "There's already an egg here.")
		return

	if(check_alien_ability(75, 1, "egg sac"))
		for(var/mob/O in viewers(src, null))
			O.show_message(SPAN_RADIOACTIVE("[src] has laid an egg!"), 1)
		new /obj/effect/alien/egg(loc)

	return

// Drone verbs.
/mob/living/carbon/human/proc/evolve()
	set name = "Evolve (500)"
	set desc = "Produce an interal egg sac capable of spawning children. Only one queen can exist at a time."
	set category = "Abilities"

	if(alien_queen_exists())
		to_chat(src, SPAN_NOTICE("We already have an active queen."))
		return

	if(check_alien_ability(500))
		to_chat(src, SPAN_ALIUM("You begin to evolve!"))
		for(var/mob/O in viewers(src, null))
			O.show_message(SPAN_RADIOACTIVE("[src] begins to twist and contort!"), 1)
		src.set_species("Xenomorph Queen")

	return

/mob/living/carbon/human/proc/plant()
	set name = "Plant Weeds (50)"
	set desc = "Plants some alien weeds"
	set category = "Abilities"

	if(check_alien_ability(50, 1, "resin spinner"))
		for(var/mob/O in viewers(src, null))
			O.show_message(SPAN_RADIOACTIVE("[src] has planted some alien weeds!"), 1)
		new /obj/effect/alien/weeds/node(loc)
	return

/mob/living/carbon/human/proc/corrosive_acid(O as obj|turf in oview(1)) //If they right click to corrode, an error will flash if its an invalid target./N
	set name = "Corrosive Acid (200)"
	set desc = "Drench an object in acid, destroying it over time."
	set category = "Abilities"

	if(!(O in oview(1)))
		to_chat(src, SPAN_ALIUM("[O] is too far away."))
		return

	// OBJ CHECK
	if(isobj(O))
		var/obj/I = O
		if(I.unacidable)	//So the aliens don't destroy energy fields/singularies/other aliens/etc with their acid.
			to_chat(src, SPAN_ALIUM("You cannot dissolve this object."))
			return

	// TURF CHECK
	else if(istype(O, /turf/simulated))
		var/turf/T = O
		// R WALL
		if(istype(T, /turf/simulated/wall/r_wall))
			to_chat(src, SPAN_ALIUM("You cannot dissolve this object."))
			return
		// R FLOOR
		if(istype(T, /turf/simulated/floor/engine))
			to_chat(src, SPAN_ALIUM("You cannot dissolve this object."))
			return
		else// Not a type we can acid.
			return

	if(check_alien_ability(200, 0, "acid gland"))
		new /obj/effect/alien/acid(get_turf(O), O)
		visible_message(SPAN_RADIOACTIVE("[src] vomits globs of vile stuff all over [O]. It begins to sizzle and melt under the bubbling mess of acid!"))

	return

/mob/living/carbon/human/proc/neurotoxin(mob/target as mob in oview())
	set name = "Spit Neurotoxin (50)"
	set desc = "Spits neurotoxin at someone, paralyzing them for a short time if they are not wearing protective gear."
	set category = "Abilities"

	if(!check_alien_ability(50, 0, "acid gland"))
		return

	to_chat(src, SPAN_ALIUM("You spit neurotoxin at [target]."))
	for(var/mob/O in oviewers())
		if((O.client && !O.blinded))
			to_chat(O, SPAN_WARNING("[src] spits neurotoxin at [target]!"))

	//I'm not motivated enough to revise this. Prjectile code in general needs update.
	// Maybe change this to use throw_at? ~ Z
	var/turf/T = loc
	var/turf/U = (istype(target, /atom/movable) ? target.loc : target)

	if(!U || !T)
		return
	while(U && !isturf(U))
		U = U.loc
	if(!isturf(T))
		return
	if(U == T)
		usr.bullet_act(new /obj/item/projectile/energy/neurotoxin(usr.loc), get_organ_target())
		return
	if(!isturf(U))
		return

	var/obj/item/projectile/energy/neurotoxin/A = new /obj/item/projectile/energy/neurotoxin(usr.loc)
	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x
	A.process()
	return

/mob/living/carbon/human/proc/resin() // -- TLE
	set name = "Secrete Resin (75)"
	set desc = "Secrete tough malleable resin."
	set category = "Abilities"

	var/choice = input("Choose what you wish to shape.", "Resin building") as null | anything in list("resin door", "resin wall", "resin membrane", "resin nest") //would do it through typesof but then the player choice would have the type path and we don't want the internal workings to be exposed ICly - Urist
	if(!choice)
		return

	if(!check_alien_ability(75, 1, "resin spinner"))
		return

	to_chat(src, SPAN_ALIUM("You shape a [choice]."))
	for(var/mob/O in viewers(src, null))
		O.show_message(SPAN_DANGER("[src] vomits up a thick purple substance and begins to shape it!"), 1)
	switch(choice)
		if("resin door")
			new /obj/structure/mineral_door/resin(loc)
		if("resin wall")
			new /obj/effect/alien/resin/wall(loc)
		if("resin membrane")
			new /obj/effect/alien/resin/membrane(loc)
		if("resin nest")
			new /obj/structure/stool/bed/nest(loc)
	return