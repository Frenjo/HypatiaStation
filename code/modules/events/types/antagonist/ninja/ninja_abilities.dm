/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+++++++++++++++++++++++++++++++++//                    //++++++++++++++++++++++++++++++++++
==================================SPACE NINJA ABILITIES====================================
___________________________________________________________________________________________
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//=======//SAFETY CHECK//=======//
/*
X is optional, tells the proc to check for specific stuff. C is also optional.
All the procs here assume that the character is wearing the ninja suit if they are using the procs.
They should, as I have made every effort for that to be the case.
In the case that they are not, I imagine the game will run-time error like crazy.
s_cooldown ticks off each second based on the suit recharge proc, in seconds. Default of 1 seconds. Some abilities have no cool down.
*/
/obj/item/clothing/suit/space/space_ninja/proc/ninjacost(C = 0, X = 0)
	var/mob/living/carbon/human/U = affecting
	if((U.stat || U.incorporeal_move) && X != 3)	//Will not return if user is using an adrenaline booster since you can use them when stat==1.
		to_chat(U, SPAN_WARNING("You must be conscious and solid to do this."))	//It's not a problem of stat==2 since the ninja will explode anyway if they die.
		return 1
	else if(C && cell.charge < C * 10)
		to_chat(U, SPAN_WARNING("Not enough energy."))
		return 1
	switch(X)
		if(1)
			cancel_stealth()	//Get rid of it.
		if(2)
			if(s_bombs <= 0)
				to_chat(U, SPAN_WARNING("There are no more smoke bombs remaining."))
				return 1
		if(3)
			if(a_boost <= 0)
				to_chat(U, SPAN_WARNING("You do not have any more adrenaline boosters."))
				return 1
	return (s_coold)	//Returns the value of the variable which counts down to zero.

//=======//TELEPORT GRAB CHECK//=======//
/obj/item/clothing/suit/space/space_ninja/proc/handle_teleport_grab(turf/T, mob/living/U)
	var/turf/destination = locate(T.x + rand(-1, 1), T.y + rand(-1, 1), T.z)
	if(istype(U.get_active_hand(), /obj/item/grab))//Handles grabbed persons.
		var/obj/item/grab/G = U.get_active_hand()
		G.affecting.forceMove(destination) //variation of position.
	if(istype(U.get_inactive_hand(), /obj/item/grab))
		var/obj/item/grab/G = U.get_inactive_hand()
		G.affecting.forceMove(destination) //variation of position.
	return

//=======//SMOKE//=======//
/*Summons smoke in radius of user.
Not sure why this would be useful (it's not) but whatever. Ninjas need their smoke bombs.*/
/obj/item/clothing/suit/space/space_ninja/proc/ninjasmoke()
	set name = "Smoke Bomb"
	set desc = "Blind your enemies momentarily with a well-placed smoke bomb."
	set category = "Ninja Ability"
	set popup_menu = 0	//Will not see it when right clicking.

	if(!ninjacost(, 2))
		var/mob/living/carbon/human/U = affecting
		to_chat(U, SPAN_INFO("There are <B>[s_bombs]</B> smoke bombs remaining."))
		make_bad_smoke(10, FALSE, U.loc)
		playsound(U.loc, 'sound/effects/bamf.ogg', 50, 2)
		s_bombs--
		s_coold = 1
	return


//=======//RIGHT CLICK TELEPORT//=======//
//Right click to teleport somewhere, almost exactly like admin jump to turf.
/obj/item/clothing/suit/space/space_ninja/proc/ninjashift(turf/T in oview())
	set name = "Phase Shift (400E)"
	set desc = "Utilizes the internal VOID-shift device to rapidly transit to a destination in view."
	set category = null	//So it does not show up on the panel but can still be right-clicked.
	set src = usr.contents	//Fixes verbs not attaching properly for objects. Praise the DM reference guide!

	var/C = 40
	if(!ninjacost(C, 1))
		var/mob/living/carbon/human/U = affecting
		var/turf/mobloc = GET_TURF(U)	//To make sure that certain things work properly below.
		if(!T.density && isturf(mobloc))
			spawn(0)
				playsound(U.loc, 'sound/effects/sparks/sparks4.ogg', 50, 1)
				anim(mobloc, src, 'icons/mob/mob.dmi', , "phaseout", , U.dir)

			cell.use(C * 10)
			handle_teleport_grab(T, U)
			U.forceMove(T)

			spawn(0)
				spark_system.start()
				playsound(U.loc, 'sound/effects/phasein.ogg', 25, 1)
				playsound(U.loc, 'sound/effects/sparks/sparks2.ogg', 50, 1)
				anim(U.loc, U, 'icons/mob/mob.dmi', , "phasein", , U.dir)
		else
			to_chat(U, SPAN_WARNING("You cannot teleport into solid walls or from solid matter."))
	return

//=======//EM PULSE//=======//
//Disables nearby tech equipment.
/obj/item/clothing/suit/space/space_ninja/proc/ninjapulse()
	set name = "EM Burst (2,000E)"
	set desc = "Disable any nearby technology with a electro-magnetic pulse."
	set category = "Ninja Ability"
	set popup_menu = 0

	var/C = 200
	if(!ninjacost(C, 0)) // EMP's now cost 1,000Energy about 30%
		var/mob/living/carbon/human/U = affecting
		playsound(U.loc, 'sound/effects/EMPulse.ogg', 60, 2)
		empulse(U, 2, 3) //Procs sure are nice. Slightly weaker than wizard's disable tch.
		s_coold = 2
		cell.use(C * 10)
	return

//=======//ENERGY BLADE//=======//
//Summons a blade of energy in active hand.
/obj/item/clothing/suit/space/space_ninja/proc/ninjablade()
	set name = "Energy Blade (500E)"
	set desc = "Create a focused beam of energy in your active hand."
	set category = "Ninja Ability"
	set popup_menu = 0

	var/C = 50
	if(!ninjacost(C, 0)) //Same spawn cost but higher upkeep cost
		var/mob/living/carbon/human/U = affecting
		if(!kamikaze)
			if(!U.get_active_hand() && !istype(U.get_inactive_hand(), /obj/item/melee/energy/blade))
				var/obj/item/melee/energy/blade/W = new()
				spark_system.start()
				playsound(U.loc, "sparks", 50, 1)
				U.put_in_hands(W)
				cell.use(C * 10)
			else
				to_chat(U, SPAN_WARNING("You can only summon one blade. Try dropping an item first."))
		else	//Else you can run around with TWO energy blades. I don't know why you'd want to but cool factor remains.
			if(!U.get_active_hand())
				var/obj/item/melee/energy/blade/W = new()
				U.put_in_hands(W)
			if(!U.get_inactive_hand())
				var/obj/item/melee/energy/blade/W = new()
				U.put_in_inactive_hand(W)
			spark_system.start()
			playsound(U.loc, "sparks", 50, 1)
			s_coold = 1
	return

//=======//NINJA STARS//=======//
/*Shoots ninja stars at random people.
This could be a lot better but I'm too tired atm.*/
/obj/item/clothing/suit/space/space_ninja/proc/ninjastar()
	set name = "Energy Star (800E)"
	set desc = "Launches an energy star at a random living target."
	set category = "Ninja Ability"
	set popup_menu = 0

	var/C = 80
	if(!ninjacost(C, 1))
		var/mob/living/carbon/human/U = affecting
		var/list/targets = list()	//So yo can shoot while yo throw dawg
		for(var/mob/living/M in oview(loc))
			if(M.stat)
				continue //Doesn't target corpses or paralyzed persons.
			targets.Add(M)
		if(length(targets))
			var/mob/living/target = pick(targets)	//The point here is to pick a random, living mob in oview to shoot stuff at.
			var/turf/curloc = U.loc
			var/atom/targloc = GET_TURF(target)
			if(!isturf(targloc) || isnull(curloc))
				return
			if(targloc == curloc)
				return
			var/obj/item/projectile/energy/dart/A = new /obj/item/projectile/energy/dart(U.loc)
			A.current = curloc
			A.yo = targloc.y - curloc.y
			A.xo = targloc.x - curloc.x
			cell.use(C * 10)
			A.process()
		else
			to_chat(U, SPAN_WARNING("There are no targets in view."))
	return

//=======//ENERGY NET//=======//
/*Allows the ninja to capture people, I guess.
Must right click on a mob to activate.*/
/obj/item/clothing/suit/space/space_ninja/proc/ninjanet(mob/living/carbon/M in oview())//Only living carbon mobs.
	set name = "Energy Net (7,000E)"
	set desc = "Captures a fallen opponent in a net of energy. Will teleport them to a holding facility after 30 seconds."
	set category = null
	set src = usr.contents

	var/C = 700
	if(!ninjacost(C, 0) && iscarbon(M))
		var/mob/living/carbon/human/U = affecting
		if(M.client)	//Monkeys without a client can still step_to() and bypass the net. Also, netting inactive people is lame.
		//if(M)//DEBUG
			if(!locate(/obj/effect/energy_net) in M.loc)	//Check if they are already being affected by an energy net.
				for(var/turf/T in getline(U.loc, M.loc))
					if(T.density)	//Don't want them shooting nets through walls. It's kind of cheesy.
						to_chat(U, "You may not use an energy net through solid obstacles!")
						return
				spawn(0)
					U.Beam(M, "n_beam", , 15)
				M.captured = 1
				U.say("Get over here!")
				var/obj/effect/energy_net/E = new /obj/effect/energy_net(M.loc)
				E.layer = M.layer + 1	//To have it appear one layer above the mob.
				U.visible_message(SPAN_WARNING("[U] caught [M] with an energy net!"))
				E.affecting = M
				E.master = U
				spawn(0)	//Parallel processing.
					E.process(M)
				cell.use(C * 10) // Nets now cost what should be most of a standard battery, since your taking someone out of the round
			else
				to_chat(U, "They are already trapped inside an energy net.")
		else
			to_chat(U, "They will bring no honour to your Clan!")
	return

//=======//ADRENALINE BOOST//=======//
/*Wakes the user so they are able to do their thing. Also injects a decent dose of radium.
Movement impairing would indicate drugs and the like.*/
/obj/item/clothing/suit/space/space_ninja/proc/ninjaboost()
	set name = "Adrenaline Boost"
	set desc = "Inject a secret chemical that will counteract all movement-impairing effect."
	set category = "Ninja Ability"
	set popup_menu = 0

	if(!ninjacost(, 3))//Have to make sure stat is not counted for this ability.
		var/mob/living/carbon/human/U = affecting
		//Wouldn't need to track adrenaline boosters if there was a miracle injection to get rid of paralysis and the like instantly.
		//For now, adrenaline boosters ARE the miracle injection. Well, radium, really.
		U.SetParalysis(0)
		U.SetWeakened(0)
	/*
	Due to lag, it was possible to adrenaline boost but remain helpless while life.dm resets player stat.
	This lead to me and others spamming adrenaline boosters because they failed to kick in on time.
	It's technically possible to come back from crit with this but it is very temporary.
	Life.dm will kick the player back into unconsciosness the next process loop.
	*/
		U.stat = 0	//At least now you should be able to teleport away or shoot ninja stars.
		spawn(30)	//Slight delay so the enemy does not immedietly know the ability was used. Due to lag, this often came before waking up.
			U.say(pick("A CORNERED FOX IS MORE DANGEROUS THAN A JACKAL!", "HURT ME MOOORRREEE!", "IMPRESSIVE!"))
		spawn(70)
			reagents.reaction(U, 2)
			reagents.trans_id_to(U, "radium", a_transfer)
			to_chat(U, SPAN_WARNING("You are beginning to feel the after-effect of the injection."))
		a_boost--
		s_coold = 3
	return

/*
===================================================================================
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<KAMIKAZE MODE>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
===================================================================================
Or otherwise known as anime mode. Which also happens to be ridiculously powerful.
*/

//=======//NINJA MOVEMENT//=======//
//Also makes you move like you're on crack.
/obj/item/clothing/suit/space/space_ninja/proc/ninjawalk()
	set name = "Shadow Walk"
	set desc = "Combines the VOID-shift and CLOAK-tech devices to freely move between solid matter. Toggle on or off."
	set category = "Ninja Ability"
	set popup_menu = 0

	var/mob/living/carbon/human/U = affecting
	if(!U.incorporeal_move)
		U.incorporeal_move = 2
		to_chat(U, SPAN_INFO("You will now phase through solid matter."))
	else
		U.incorporeal_move = 0
		to_chat(U, SPAN_INFO("You will no-longer phase through solid matter."))
	return

//=======//5 TILE TELEPORT/GIB//=======//
//Allows to gib up to five squares in a straight line. Seriously.
/obj/item/clothing/suit/space/space_ninja/proc/ninjaslayer()
	set name = "Phase Slayer"
	set desc = "Utilizes the internal VOID-shift device to mutilate creatures in a straight line."
	set category = "Ninja Ability"
	set popup_menu = 0

	if(!ninjacost())
		var/mob/living/carbon/human/U = affecting
		var/turf/destination = get_teleport_loc(U.loc, U, 5)
		var/turf/mobloc = GET_TURF(U)	//To make sure that certain things work properly below.
		if(destination && isturf(mobloc))
			U.say("Ai Satsugai!")
			spawn(0)
				playsound(U.loc, "sparks", 50, 1)
				anim(mobloc, U, 'icons/mob/mob.dmi', , "phaseout", , U.dir)

			spawn(0)
				for(var/turf/T in getline(mobloc, destination))
					spawn(0)
						T.kill_creatures(U)
					if(T == mobloc||T == destination)
						continue
					spawn(0)
						anim(T, U, 'icons/mob/mob.dmi', , "phasein", , U.dir)

			handle_teleport_grab(destination, U)
			U.forceMove(destination)

			spawn(0)
				spark_system.start()
				playsound(U.loc, 'sound/effects/phasein.ogg', 25, 1)
				playsound(U.loc, "sparks", 50, 1)
				anim(U.loc, U, 'icons/mob/mob.dmi', , "phasein", , U.dir)
			s_coold = 1
		else
			to_chat(U, SPAN_WARNING("The VOID-shift device is malfunctioning, <B>teleportation failed</B>."))
	return

//=======//TELEPORT BEHIND MOB//=======//
/*Appear behind a randomly chosen mob while a few decoy teleports appear.
This is so anime it hurts. But that's the point.*/
/obj/item/clothing/suit/space/space_ninja/proc/ninjamirage()
	set name = "Spider Mirage"
	set desc = "Utilizes the internal VOID-shift device to create decoys and teleport behind a random target."
	set category = "Ninja Ability"
	set popup_menu = 0

	if(!ninjacost())	//Simply checks for stat.
		var/mob/living/carbon/human/U = affecting
		var/list/targets = list()
		for(var/mob/living/M in oview(6))
			if(M.stat)
				continue	//Doesn't target corpses or paralyzed people.
			targets.Add(M)
		if(length(targets))
			var/mob/living/target = pick(targets)
			var/locx
			var/locy
			var/turf/mobloc = GET_TURF(target)
			var/safety = 0
			switch(target.dir)
				if(NORTH)
					locx = mobloc.x
					locy = (mobloc.y - 1)
					if(locy < 1)
						safety = 1
				if(SOUTH)
					locx = mobloc.x
					locy = (mobloc.y + 1)
					if(locy > world.maxy)
						safety = 1
				if(EAST)
					locy = mobloc.y
					locx = (mobloc.x - 1)
					if(locx < 1)
						safety = 1
				if(WEST)
					locy = mobloc.y
					locx = (mobloc.x + 1)
					if(locx > world.maxx)
						safety = 1
				else
					safety = 1
			if(!safety && isturf(mobloc))
				U.say("Kumo no Shinkiro!")
				var/turf/picked = locate(locx, locy, mobloc.z)
				spawn(0)
					playsound(U.loc, "sparks", 50, 1)
					anim(mobloc, U, 'icons/mob/mob.dmi', , "phaseout", , U.dir)

				spawn(0)
					var/limit = 4
					for(var/turf/T in oview(5))
						if(prob(20))
							spawn(0)
								anim(T, U, 'icons/mob/mob.dmi', , "phasein", , U.dir)
							limit--
						if(limit <= 0)
							break

				handle_teleport_grab(picked, U)
				U.forceMove(picked)
				U.set_dir(target.dir)

				spawn(0)
					spark_system.start()
					playsound(U.loc, 'sound/effects/phasein.ogg', 25, 1)
					playsound(U.loc, "sparks", 50, 1)
					anim(U.loc,U,'icons/mob/mob.dmi',,"phasein",,U.dir)
				s_coold = 1
			else
				to_chat(U, SPAN_WARNING("The VOID-shift device is malfunctioning, <B>teleportation failed</B>."))
		else
			to_chat(U, SPAN_WARNING("There are no targets in view."))
	return
