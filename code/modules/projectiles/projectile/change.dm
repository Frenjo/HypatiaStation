/obj/item/projectile/change
	name = "bolt of change"
	icon_state = "ice_1"

	damage = 0
	damage_type = BURN
	nodamage = TRUE
	flag = "energy"

/obj/item/projectile/change/on_hit(atom/change)
	wabbajack(change)

/obj/item/projectile/change/proc/wabbajack(mob/M as mob in GLOBL.living_mob_list)
	if(isliving(M) && M.stat != DEAD)
		if(M.monkeyizing)
			return
		if(M.has_brain_worms())
			return //Borer stuff - RR

		M.monkeyizing = 1
		M.canmove = FALSE
		M.icon = null
		M.cut_overlays()
		M.invisibility = INVISIBILITY_MAXIMUM

		if(isrobot(M))
			var/mob/living/silicon/robot/Robot = M
			if(Robot.mmi)
				qdel(Robot.mmi)
		else
			for(var/obj/item/W in M)
				if(istype(W, /obj/item/implant))	//TODO: Carn. give implants a dropped() or something
					qdel(W)
					continue
				W.reset_plane_and_layer()
				W.forceMove(M.loc)
				W.dropped(M)

		var/mob/living/new_mob

		var/randomize = pick("monkey", "robot", "slime", "xeno", "human")
		switch(randomize)
			if("monkey")
				new_mob = new /mob/living/carbon/monkey(M.loc)
				new_mob.universal_speak = TRUE
			if("robot")
				new_mob = new /mob/living/silicon/robot(M.loc)
				new_mob.gender = M.gender
				new_mob.invisibility = 0
				new_mob.job = "Cyborg"
				var/mob/living/silicon/robot/Robot = new_mob
				Robot.mmi = new /obj/item/mmi(new_mob)
				Robot.mmi.transfer_identity(M)	//Does not transfer key/client.
			if("slime")
				if(prob(50))
					new_mob = new /mob/living/carbon/slime/adult(M.loc)
				else
					new_mob = new /mob/living/carbon/slime(M.loc)
				new_mob.universal_speak = TRUE
			if("xeno")
				var/alien_caste = pick("Hunter", "Sentinel", "Drone", "Larva")
				new_mob = create_new_xenomorph(alien_caste, M.loc)
				new_mob.universal_speak = TRUE
			if("human")
				new_mob = new /mob/living/carbon/human(M.loc, pick(GLOBL.all_species))
				if(M.gender == MALE)
					new_mob.gender = MALE
					new_mob.name = pick(GLOBL.first_names_male)
				else
					new_mob.gender = FEMALE
					new_mob.name = pick(GLOBL.first_names_female)
				new_mob.name += " [pick(GLOBL.last_names)]"
				new_mob.real_name = new_mob.name

				var/datum/preferences/A = new()	//Randomize appearance for the human
				A.randomize_appearance_for(new_mob)

				var/mob/living/carbon/human/H = new_mob
				var/newspecies = pick(GLOBL.all_species)
				H.set_species(newspecies)
			else
				return

		for(var/obj/effect/proc_holder/spell/S in M.spell_list)
			new_mob.spell_list.Add(new S.type())

		new_mob.a_intent = "hurt"
		if(isnotnull(M.mind))
			M.mind.transfer_to(new_mob)
		else
			new_mob.key = M.key

		to_chat(new_mob, "<B>Your form morphs into that of a [randomize].</B>")

		qdel(M)
		return new_mob