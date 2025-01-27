//mob verbs are faster than object verbs. See above.
/mob/living/point(atom/A as mob|obj|turf in view())
	if(src.stat || !src.canmove || src.restrained())
		return 0
	if(src.status_flags & FAKEDEATH)
		return 0
	if(!..())
		return 0

	usr.visible_message("<b>[src]</b> points to [A].")
	return 1


/*one proc, four uses
swapping: if it's 1, the mobs are trying to switch, if 0, non-passive is pushing passive
default behaviour is:
 - non-passive mob passes the passive version
 - passive mob checks to see if its mob_bump_flag is in the non-passive's mob_bump_flags
 - if si, the proc returns
*/
/mob/living/proc/can_move_mob(mob/living/swapped, swapping = 0, passive = 0)
	if(!swapped)
		return 1
	if(!passive)
		return swapped.can_move_mob(src, swapping, 1)
	else
		var/context_flags = 0
		if(swapping)
			context_flags = swapped.mob_swap_flags
		else
			context_flags = swapped.mob_push_flags
		if(!mob_bump_flag) //nothing defined, go wild
			return 1
		if(mob_bump_flag & context_flags)
			return 1
		return 0

/mob/living/Bump(atom/movable/AM, yes)
	spawn(0)
		if((!yes || now_pushing) || !loc)
			return
		now_pushing = 1
		if(isliving(AM))
			var/mob/living/tmob = AM
			for(var/mob/living/M in range(tmob, 1))
				if(length(tmob.pinned) || ((M.pulling == tmob && (tmob.restrained() && !M.restrained() && M.stat == CONSCIOUS)) || locate(/obj/item/grab, length(tmob.grabbed_by))))
					if(!(world.time % 5))
						to_chat(src, SPAN_WARNING("[tmob] is restrained, you cannot push past."))
					now_pushing = 0
					return
				if(tmob.pulling == M && (M.restrained() && !tmob.restrained() && tmob.stat == CONSCIOUS))
					if(!(world.time % 5))
						to_chat(src, SPAN_WARNING("[tmob] is restraining [M], you cannot push past."))
					now_pushing = 0
					return

			//BubbleWrap: people in handcuffs are always switched around as if they were on 'help' intent to prevent a person being pulled from being seperated from their puller
			var/dense = 0
			if(loc.density)
				dense = 1
			for_no_type_check(var/atom/movable/mover, GET_TURF(src))
				if(mover == src)
					continue
				if(mover.density)
					if(HAS_ATOM_FLAGS(mover, ATOM_FLAG_ON_BORDER))
						dense = !mover.CanPass(src, loc)
					else
						dense = 1
				if(dense)
					break

			//Leaping mobs just land on the tile, no pushing, no anything.
			if(status_flags & LEAPING)
				loc = tmob.loc
				status_flags &= ~LEAPING
				now_pushing = 0
				return

			if((tmob.mob_always_swap || (tmob.a_intent == "help" || tmob.restrained()) && (a_intent == "help" || src.restrained())) && tmob.canmove && canmove && !dense && can_move_mob(tmob, 1, 0)) // mutual brohugs all around!
				var/turf/oldloc = loc
				loc = tmob.loc
				tmob.forceMove(oldloc)
				now_pushing = 0
				for(var/mob/living/carbon/slime/slime in view(1, tmob))
					if(slime.Victim == tmob)
						slime.UpdateFeed()
				return

			if(!can_move_mob(tmob, 0, 0))
				now_pushing = 0
				return
			if(ishuman(tmob) && (MUTATION_FAT in tmob.mutations))
				if(prob(40) && !(MUTATION_FAT in src.mutations))
					to_chat(src, SPAN_DANGER("You fail to push [tmob]'s fat ass out of the way."))
					now_pushing = 0
					return
			if(tmob.r_hand && istype(tmob.r_hand, /obj/item/shield/riot))
				if(prob(99))
					now_pushing = 0
					return
			if(tmob.l_hand && istype(tmob.l_hand, /obj/item/shield/riot))
				if(prob(99))
					now_pushing = 0
					return
			if(!(tmob.status_flags & CANPUSH))
				now_pushing = 0
				return

			tmob.LAssailant = src

		now_pushing = 0
		spawn(0)
			..()
			if(!ismovable(AM))
				return
			if(!now_pushing)
				now_pushing = 1

				if(!AM.anchored)
					var/t = get_dir(src, AM)
					if(istype(AM, /obj/structure/window))
						for(var/obj/structure/window/win in get_step(AM, t))
							now_pushing = 0
							return
					step(AM, t)
				now_pushing = 0
			return
	return

/mob/living/verb/succumb()
	set hidden = 1
	if((src.health < 0 && src.health > -95.0))
		src.adjustOxyLoss(src.health + 200)
		src.health = 100 - src.getOxyLoss() - src.getToxLoss() - src.getFireLoss() - src.getBruteLoss()
		to_chat(src, SPAN_INFO("You have given up life and succumbed to death."))

/mob/living/proc/updatehealth()
	if(status_flags & GODMODE)
		health = 100
		stat = CONSCIOUS
	else
		health = maxHealth - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss() - getCloneLoss() - halloss

//This proc is used for mobs which are affected by pressure to calculate the amount of pressure that actually
//affects them once clothing is factored in. ~Errorage
/mob/living/proc/calculate_affecting_pressure(pressure)
	return 0

//sort of a legacy burn method for /electrocute, /shock, and the e_chair
/mob/living/proc/burn_skin(burn_amount)
	if(ishuman(src))
		//to_world("DEBUG: burn_skin(), mutations=[mutations]")
		if(MUTATION_SHOCK_PROOF in src.mutations) //shockproof
			return 0
		if(MUTATION_COLD_RESISTANCE in src.mutations) //fireproof
			return 0
		var/mob/living/carbon/human/H = src	//make this damage method divide the damage to be done among all the body parts, then burn each body part for that much damage. will have better effect then just randomly picking a body part
		var/divided_damage = burn_amount / length(H.organs)
		var/extradam = 0	//added to when organ is at max dam
		for(var/datum/organ/external/affecting in H.organs)
			if(!affecting)
				continue
			if(affecting.take_damage(0, divided_damage + extradam))	//TODO: fix the extradam stuff. Or, ebtter yet...rewrite this entire proc ~Carn
				H.UpdateDamageIcon()
		H.updatehealth()
		return 1
	else if(ismonkey(src))
		if(MUTATION_COLD_RESISTANCE in src.mutations) //fireproof
			return 0
		var/mob/living/carbon/monkey/M = src
		M.adjustFireLoss(burn_amount)
		M.updatehealth()
		return 1
	else if(isAI(src))
		return 0

/mob/living/proc/adjustBodyTemp(actual, desired, incrementboost)
	var/temperature = actual
	var/difference = abs(actual - desired)	//get difference
	var/increments = difference / 10 //find how many increments apart they are
	var/change = increments * incrementboost	// Get the amount to change by (x per increment)

	// Too cold
	if(actual < desired)
		temperature += change
		if(actual > desired)
			temperature = desired
	// Too hot
	if(actual > desired)
		temperature -= change
		if(actual < desired)
			temperature = desired
//	if(ishuman(src))
		//to_world("[src] ~ [src.bodytemperature] ~ [temperature]")
	return temperature


// ++++ROCKDTBEN++++ MOB PROCS -- Ask me before touching.
// Stop! ... Hammertime! ~Carn
// I touched them without asking... I'm soooo edgy ~Erro (added nodamage checks)

/mob/living/proc/getBruteLoss()
	return bruteloss

/mob/living/proc/adjustBruteLoss(amount)
	if(status_flags & GODMODE)
		return 0	//godmode
	bruteloss = min(max(bruteloss + amount, 0), (maxHealth * 2))

/mob/living/proc/getOxyLoss()
	return oxyloss

/mob/living/proc/adjustOxyLoss(amount)
	if(status_flags & GODMODE)
		return 0	//godmode
	oxyloss = min(max(oxyloss + amount, 0), (maxHealth * 2))

/mob/living/proc/setOxyLoss(amount)
	if(status_flags & GODMODE)
		return 0	//godmode
	oxyloss = amount

/mob/living/proc/getToxLoss()
	return toxloss

/mob/living/proc/adjustToxLoss(amount)
	if(status_flags & GODMODE)
		return 0	//godmode
	toxloss = min(max(toxloss + amount, 0), (maxHealth * 2))

/mob/living/proc/setToxLoss(amount)
	if(status_flags & GODMODE)
		return 0	//godmode
	toxloss = amount

/mob/living/proc/getFireLoss()
	return fireloss

/mob/living/proc/adjustFireLoss(amount)
	if(status_flags & GODMODE)
		return 0	//godmode
	fireloss = min(max(fireloss + amount, 0), (maxHealth * 2))

/mob/living/proc/getCloneLoss()
	return cloneloss

/mob/living/proc/adjustCloneLoss(amount)
	if(status_flags & GODMODE)
		return 0	//godmode
	cloneloss = min(max(cloneloss + amount, 0), (maxHealth * 2))

/mob/living/proc/setCloneLoss(amount)
	if(status_flags & GODMODE)
		return 0	//godmode
	cloneloss = amount

/mob/living/proc/getBrainLoss()
	return brainloss

/mob/living/proc/adjustBrainLoss(amount)
	if(status_flags & GODMODE)
		return 0	//godmode
	brainloss = min(max(brainloss + amount, 0), (maxHealth * 2))

/mob/living/proc/setBrainLoss(amount)
	if(status_flags & GODMODE)
		return 0	//godmode
	brainloss = amount

/mob/living/proc/getHalLoss()
	return halloss

/mob/living/proc/adjustHalLoss(amount)
	if(status_flags & GODMODE)
		return 0	//godmode
	halloss = min(max(halloss + amount, 0), (maxHealth * 2))

/mob/living/proc/setHalLoss(amount)
	if(status_flags & GODMODE)
		return 0	//godmode
	halloss = amount

/mob/living/proc/getMaxHealth()
	return maxHealth

/mob/living/proc/setMaxHealth(newMaxHealth)
	maxHealth = newMaxHealth

// ++++ROCKDTBEN++++ MOB PROCS //END


/mob/proc/get_contents()


//Recursive function to find everything a mob is holding.
/mob/living/get_contents(obj/item/storage/Storage = null)
	var/list/L = list()

	if(Storage) //If it called itself
		L += Storage.return_inv()

		//Leave this commented out, it will cause storage items to exponentially add duplicate to the list
		//for(var/obj/item/storage/S in Storage.return_inv()) //Check for storage items
		//	L += get_contents(S)

		for(var/obj/item/gift/G in Storage.return_inv()) //Check for gift-wrapped items
			L += G.gift
			if(istype(G.gift, /obj/item/storage))
				L += get_contents(G.gift)

		for(var/obj/item/small_delivery/D in Storage.return_inv()) //Check for package wrapped items
			L += D.wrapped
			if(istype(D.wrapped, /obj/item/storage)) //this should never happen
				L += get_contents(D.wrapped)
		return L

	else

		L += src.contents
		for(var/obj/item/storage/S in src.contents)	//Check for storage items
			L += get_contents(S)

		for(var/obj/item/gift/G in src.contents) //Check for gift-wrapped items
			L += G.gift
			if(istype(G.gift, /obj/item/storage))
				L += get_contents(G.gift)

		for(var/obj/item/small_delivery/D in src.contents) //Check for package wrapped items
			L += D.wrapped
			if(istype(D.wrapped, /obj/item/storage)) //this should never happen
				L += get_contents(D.wrapped)
		return L

/mob/living/proc/check_contents_for(A)
	var/list/L = src.get_contents()

	for(var/obj/B in L)
		if(B.type == A)
			return 1
	return 0


/mob/living/proc/electrocute_act(shock_damage, obj/source, siemens_coeff = 1.0)
	  return 0 //only carbon liveforms have this proc

/mob/living/emp_act(severity)
	var/list/L = src.get_contents()
	for(var/obj/O in L)
		O.emp_act(severity)
	..()

/mob/living/proc/get_organ_target()
	var/mob/shooter = src
	var/t = shooter.zone_sel.selecting
	if((t in list("eyes", "mouth")))
		t = "head"
	var/datum/organ/external/def_zone = ran_zone(t)
	return def_zone


// heal ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/heal_organ_damage(brute, burn)
	adjustBruteLoss(-brute)
	adjustFireLoss(-burn)
	src.updatehealth()

// damage ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/take_organ_damage(brute, burn)
	if(status_flags & GODMODE)
		return 0	//godmode
	adjustBruteLoss(brute)
	adjustFireLoss(burn)
	src.updatehealth()

// heal MANY external organs, in random order
/mob/living/proc/heal_overall_damage(brute, burn)
	adjustBruteLoss(-brute)
	adjustFireLoss(-burn)
	src.updatehealth()

// damage MANY external organs, in random order
/mob/living/proc/take_overall_damage(brute, burn, used_weapon = null)
	if(status_flags & GODMODE)
		return 0	//godmode
	adjustBruteLoss(brute)
	adjustFireLoss(burn)
	src.updatehealth()

/mob/living/proc/restore_all_organs()
	return



/mob/living/proc/revive()
	rejuvenate()
	buckled = initial(src.buckled)
	if(iscarbon(src))
		var/mob/living/carbon/C = src

		if(C.handcuffed && !initial(C.handcuffed))
			C.drop_from_inventory(C.handcuffed)
		C.handcuffed = initial(C.handcuffed)

		if(C.legcuffed && !initial(C.legcuffed))
			C.drop_from_inventory(C.legcuffed)
		C.legcuffed = initial(C.legcuffed)
	BITSET(hud_updateflag, HEALTH_HUD)
	BITSET(hud_updateflag, STATUS_HUD)
	ExtinguishMob()
	fire_stacks = 0

/mob/living/proc/rejuvenate()
	// shut down various types of badness
	setToxLoss(0)
	setOxyLoss(0)
	setCloneLoss(0)
	setBrainLoss(0)
	SetParalysis(0)
	SetStunned(0)
	SetWeakened(0)

	// shut down ongoing problems
	radiation = 0
	bodytemperature = T20C
	sdisabilities = 0
	disabilities = 0

	// fix blindness and deafness
	blinded = 0
	eye_blind = 0
	eye_blurry = 0
	ear_deaf = 0
	ear_damage = 0
	heal_overall_damage(getBruteLoss(), getFireLoss())

	// restore all of a human's blood
	if(ishuman(src))
		var/mob/living/carbon/human/human_mob = src
		human_mob.restore_blood()

	// fix all of our organs
	restore_all_organs()

	// remove the character from the list of the dead
	if(stat == DEAD)
		GLOBL.dead_mob_list.Remove(src)
		GLOBL.living_mob_list.Add(src)
		tod = null

	// restore us to conciousness
	stat = CONSCIOUS

	// make the icons look correct
	regenerate_icons()

	BITSET(hud_updateflag, HEALTH_HUD)
	BITSET(hud_updateflag, STATUS_HUD)
	return

/mob/living/proc/UpdateDamageIcon()
	return


/mob/living/proc/Examine_OOC()
	set category = PANEL_OOC
	set name = "Examine Meta-Info (OOC)"
	set src in view()

	if(CONFIG_GET(/decl/configuration_entry/allow_metadata))
		if(client)
			to_chat(usr, "[src]'s Metainfo:<br>[client.prefs.metadata]")
		else
			to_chat(usr, "[src] does not have any stored infomation!")
	else
		to_chat(usr, "OOC Metadata is not supported by this server!")

	return

/mob/living/Move(a, b, flag)
	if(buckled)
		return

	if(restrained())
		stop_pulling()


	var/t7 = 1
	if(restrained())
		for(var/mob/living/M in range(src, 1))
			if((M.pulling == src && M.stat == CONSCIOUS && !M.restrained()))
				t7 = null
	if((t7 && (pulling && ((get_dist(src, pulling) <= 1 || pulling.loc == loc) && (client && client.moving)))))
		var/turf/T = loc
		. = ..()

		if(pulling && pulling.loc)
			if(!(isturf(pulling.loc)))
				stop_pulling()
				return

		/////
		if(pulling && pulling.anchored)
			stop_pulling()
			return

		if(!restrained())
			var/diag = get_dir(src, pulling)
			if((diag - 1) & diag)
			else
				diag = null
			if((get_dist(src, pulling) > 1 || diag))
				if(isliving(pulling))
					var/mob/living/M = pulling
					var/ok = 1
					if(locate(/obj/item/grab, M.grabbed_by))
						if(prob(75))
							var/obj/item/grab/G = pick(M.grabbed_by)
							if(istype(G, /obj/item/grab))
								M.visible_message(SPAN_WARNING("[G.affecting] has been pulled from [G.assailant]'s grip by [src]!"))
								//G = null
								qdel(G)
						else
							ok = 0
						if(locate(/obj/item/grab, length(M.grabbed_by)))
							ok = 0
					if(ok)
						var/atom/movable/t = M.pulling
						M.stop_pulling()

						//this is the gay blood on floor shit -- Added back -- Skie
						if(M.lying && (prob(M.getBruteLoss() / 6)))
							var/turf/location = M.loc
							if(isopenturf(location))
								location.add_blood(M)
						//pull damage with injured people
							if(prob(25))
								M.adjustBruteLoss(1)
								visible_message(SPAN_WARNING("\The [M]'s wounds open more from being dragged!"))
						if(M.pull_damage())
							if(prob(25))
								M.adjustBruteLoss(2)
								visible_message(SPAN_WARNING("\The [M]'s wounds worsen terribly from being dragged!"))
								var/turf/location = M.loc
								if(isopenturf(location))
									location.add_blood(M)
									if(ishuman(M))
										var/mob/living/carbon/human/H = M
										var/blood_volume = round(H.vessel.get_reagent_amount("blood"))
										if(blood_volume > 0)
											H.vessel.remove_reagent("blood",1)


						step(pulling, get_dir(pulling.loc, T))
						M.start_pulling(t)
				else
					if(pulling)
						if(istype(pulling, /obj/structure/window))
							if(pulling:ini_dir == NORTHWEST || pulling:ini_dir == NORTHEAST || pulling:ini_dir == SOUTHWEST || pulling:ini_dir == SOUTHEAST)
								for(var/obj/structure/window/win in get_step(pulling, get_dir(pulling.loc, T)))
									stop_pulling()
					if(pulling)
						step(pulling, get_dir(pulling.loc, T))
	else
		stop_pulling()
		. = ..()
	if((s_active && !(s_active in contents)))
		s_active.close(src)

	if(update_slimes)
		for(var/mob/living/carbon/slime/M in view(1, src))
			M.UpdateFeed(src)

/mob/living/verb/resist()
	set category = PANEL_IC
	set name = "Resist"

	if(!isliving(usr) || usr.next_move > world.time)
		return
	usr.next_move = world.time + 20

	var/mob/living/L = usr

	//Getting out of someone's inventory.
	if(istype(src.loc, /obj/item/holder))
		var/obj/item/holder/H = src.loc	//Get our item holder.
		var/mob/M = H.loc						//Get our mob holder (if any).
		if(istype(M))
			M.drop_from_inventory(H)
			to_chat(M, "[H] wriggles out of your grip!")
			to_chat(src, "You wriggle out of [M]'s grip!")

		else if(isitem(H.loc))
			to_chat(src, "You struggle free of [H.loc].")
			H.forceMove(GET_TURF(H))
		return

	//Resisting control by an alien mind.
	if(istype(src.loc, /mob/living/simple/borer))
		var/mob/living/simple/borer/B = src.loc
		var/mob/living/captive_brain/H = src

		to_chat(H, SPAN_DANGER("You begin doggedly resisting the parasite's control (this will take approximately sixty seconds)."))
		to_chat(B.host, SPAN_DANGER("You feel the captive mind of [src] begin to resist your control."))

		spawn(rand(350, 450) + B.host.brainloss)
			if(!B || !B.controlling)
				return

			B.host.adjustBrainLoss(rand(5, 10))
			to_chat(H, SPAN_DANGER("With an immense exertion of will, you regain control of your body!"))
			to_chat(B.host, SPAN_DANGER("You feel control of the host brain ripped from your grasp, and retract your probosci before the wild neural impulses can damage you."))
			B.controlling = 0

			B.ckey = B.host.ckey
			B.host.ckey = H.ckey

			H.ckey = null
			H.name = "host brain"
			H.real_name = "host brain"

			verbs -= /mob/living/carbon/proc/release_control
			verbs -= /mob/living/carbon/proc/punish_host
			verbs -= /mob/living/carbon/proc/spawn_larvae

			return

	//resisting grabs (as if it helps anyone...)
	if(!L.stat && !L.restrained())
		var/resisting = 0
		for(var/obj/O in L.requests)
			L.requests.Remove(O)
			qdel(O)
			resisting++
		for(var/obj/item/grab/G in usr.grabbed_by)
			resisting++
			switch(G.state)
				if(GRAB_PASSIVE)
					qdel(G)
				if(GRAB_AGGRESSIVE)
					if(prob(60)) //same chance of breaking the grab as disarm
						L.visible_message(SPAN_WARNING("[L] has broken free of [G.assailant]'s grip!"))
						qdel(G)
				if(GRAB_NECK)
					//If the you move when grabbing someone then it's easier for them to break free. Same if the affected mob is immune to stun.
					if(((world.time - G.assailant.l_move_time < 20 || !L.stunned) && prob(15)) || prob(3))
						L.visible_message(SPAN_WARNING("[L] has broken free of [G.assailant]'s headlock!"))
						qdel(G)

		if(resisting)
			L.visible_message(SPAN_DANGER("[L] resists!"))

	//unbuckling yourself
	if(L.buckled && (L.last_special <= world.time))
		if(iscarbon(L))
			var/mob/living/carbon/C = L
			if(C.handcuffed)
				C.next_move = world.time + 100
				C.last_special = world.time + 100
				C.visible_message(
					SPAN_DANGER("[usr] attempts to unbuckle themselves!"),
					SPAN_WARNING("You attempt to unbuckle yourself. (This will take around 2 minutes and you need to stand still.)")
				)
				spawn(0)
					if(do_after(usr, 1200))
						if(!C.buckled)
							return
						C.visible_message(
							SPAN_DANGER("[usr] manages to unbuckle themselves!"),
							SPAN_INFO("You successfully unbuckle yourself.")
						)
						C.buckled.manual_unbuckle(C)
		else
			L.buckled.manual_unbuckle(L)

	//Breaking out of a locker?
	else if(src.loc && (istype(src.loc, /obj/structure/closet)))
		var/breakout_time = 2 //2 minutes by default

		var/obj/structure/closet/C = L.loc
		if(C.opened)
			return //Door's open... wait, why are you in it's contents then?
		if(istype(L.loc, /obj/structure/closet/secure))
			var/obj/structure/closet/secure/SC = L.loc
			if(!SC.locked && !SC.welded)
				return //It's a secure closet, but isn't locked. Easily escapable from, no need to 'resist'
		else
			if(!C.welded)
				return //closed but not welded...
		//	else Meh, lets just keep it at 2 minutes for now
		//		breakout_time++ //Harder to get out of welded lockers than locked lockers

		//okay, so the closet is either welded or locked... resist!!!
		usr.next_move = world.time + 100
		L.last_special = world.time + 100
		L.visible_message(
			SPAN_DANGER("The [L.loc] begins to shake violently!"),
			SPAN_WARNING("You lean on the back of \the [C] and start pushing the door open. (This will take about [breakout_time] minutes.)")
		)

		spawn(0)
			if(do_after(usr, (breakout_time * 60 * 10))) //minutes * 60seconds * 10deciseconds
				if(!C || !L || L.stat != CONSCIOUS || L.loc != C || C.opened) //closet/user destroyed OR user dead/unconcious OR user no longer in closet OR closet opened
					return

				//Perform the same set of checks as above for weld and lock status to determine if there is even still a point in 'resisting'...
				if(istype(L.loc, /obj/structure/closet/secure))
					var/obj/structure/closet/secure/SC = L.loc
					if(!SC.locked && !SC.welded)
						return
				else
					if(!C.welded)
						return

				//Well then break it!
				if(istype(usr.loc, /obj/structure/closet/secure))
					var/obj/structure/closet/secure/SC = L.loc
					SC.desc = "It appears to be broken."
					SC.icon_state = SC.icon_off
					flick(SC.icon_broken, SC)
					sleep(10)
					flick(SC.icon_broken, SC)
					sleep(10)
					SC.broken = 1
					SC.locked = 0
					usr.visible_message(
						SPAN_DANGER("\the [usr] successfully broke out of \the [SC]!"),
						SPAN_WARNING("You successfully break out!")
					)
					if(istype(SC.loc, /obj/structure/big_delivery)) //Do this to prevent contents from being opened into nullspace (read: bluespace)
						var/obj/structure/big_delivery/BD = SC.loc
						BD.attack_hand(usr)
					SC.open()
				else
					C.welded = 0
					usr.visible_message(
						SPAN_DANGER("\the [usr] successfully broke out of \the [C]!"),
						SPAN_WARNING("You successfully break out!")
					)
					if(istype(C.loc, /obj/structure/big_delivery)) //nullspace ect.. read the comment above
						var/obj/structure/big_delivery/BD = C.loc
						BD.attack_hand(usr)
					C.open()

	//drop && roll or breaking out of handcuffs
	else if(iscarbon(L))
		var/mob/living/carbon/CM = L
		if(CM.on_fire && CM.canmove)
			CM.fire_stacks -= 5
			CM.Weaken(3)
			CM.spin(32, 2)
			CM.visible_message(
				SPAN_DANGER("[CM] rolls on the floor, trying to put themselves out!"),
				SPAN_NOTICE("You stop, drop, and roll!")
			)
			sleep(30)
			if(fire_stacks <= 0)
				CM.visible_message(
					SPAN_DANGER("[CM] has successfully extinguished themselves!"),
					SPAN_NOTICE("You extinguish yourself.")
				)
				ExtinguishMob()
			return
		if(CM.handcuffed && CM.canmove && (CM.last_special <= world.time))
			CM.next_move = world.time + 100
			CM.last_special = world.time + 100
			if(MUTATION_HULK in usr.mutations) //Don't want to do a lot of logic gating here.
				CM.visible_message(
					SPAN_DANGER("[CM] is trying to break the handcuffs!"),
					SPAN_WARNING("You attempt to break your handcuffs. (This will take around 5 seconds and you need to stand still.)")
				)
				spawn(0)
					if(do_after(CM, 50))
						if(!CM.handcuffed || CM.buckled)
							return
						CM.visible_message(
							SPAN_DANGER("[CM] manages to break the handcuffs!"),
							SPAN_WARNING("You successfully break your handcuffs.")
						)
						CM.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!"))
						qdel(CM.handcuffed)
						CM.handcuffed = null
						CM.update_inv_handcuffed()
			else
				var/obj/item/handcuffs/HC = CM.handcuffed
				var/breakouttime = 1200 //A default in case you are somehow handcuffed with something that isn't an /obj/item/handcuffs type
				var/displaytime = 2 //Minutes to display in the "this will take X minutes."
				if(istype(HC)) //If you are handcuffed with actual handcuffs... Well what do I know, maybe someone will want to handcuff you with toilet paper in the future...
					breakouttime = HC.breakouttime
					displaytime = breakouttime / 600 //Minutes
				CM.visible_message(
					SPAN_DANGER("[usr] attempts to remove \the [HC]!"),
					SPAN_WARNING("You attempt to remove \the [HC]. (This will take around [displaytime] minutes and you need to stand still.)")
				)
				spawn(0)
					if(do_after(CM, breakouttime))
						if(!CM.handcuffed || CM.buckled)
							return // time leniency for lag which also might make this whole thing pointless but the server lags so hard that 40s isn't lenient enough - Quarxink
						CM.visible_message(
							SPAN_DANGER("[CM] manages to remove the handcuffs!"),
							SPAN_INFO("You successfully remove \the [CM.handcuffed].")
						)
						CM.drop_from_inventory(CM.handcuffed)

		else if(CM.legcuffed && CM.canmove && (CM.last_special <= world.time))
			CM.next_move = world.time + 100
			CM.last_special = world.time + 100
			if(MUTATION_HULK in usr.mutations) //Don't want to do a lot of logic gating here.
				CM.visible_message(
					SPAN_DANGER("[CM] is trying to break the legcuffs!"),
					SPAN_WARNING("You attempt to break your legcuffs. (This will take around 5 seconds and you need to stand still.)")
				)
				spawn(0)
					if(do_after(CM, 50))
						if(!CM.legcuffed || CM.buckled)
							return
						CM.visible_message(
							SPAN_DANGER("[CM] manages to break the legcuffs!"),
							SPAN_WARNING("You successfully break your legcuffs.")
						)
						CM.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!"))
						qdel(CM.legcuffed)
						CM.legcuffed = null
						CM.update_inv_legcuffed()
			else
				var/obj/item/legcuffs/HC = CM.legcuffed
				var/breakouttime = 1200 //A default in case you are somehow legcuffed with something that isn't an /obj/item/legcuffs type
				var/displaytime = 2 //Minutes to display in the "this will take X minutes."
				if(istype(HC)) //If you are legcuffed with actual legcuffs... Well what do I know, maybe someone will want to legcuff you with toilet paper in the future...
					breakouttime = HC.breakouttime
					displaytime = breakouttime / 600 //Minutes
				CM.visible_message(
					SPAN_DANGER("[usr] attempts to remove \the [HC]!"),
					SPAN_WARNING("You attempt to remove \the [HC]. (This will take around [displaytime] minutes and you need to stand still.)")
				)
				spawn(0)
					if(do_after(CM, breakouttime))
						if(!CM.legcuffed || CM.buckled)
							return // time leniency for lag which also might make this whole thing pointless but the server lags so hard that 40s isn't lenient enough - Quarxink
						CM.visible_message(
							SPAN_DANGER("[CM] manages to remove the legcuffs!"),
							SPAN_INFO("You successfully remove \the [CM.legcuffed].")
						)
						CM.drop_from_inventory(CM.legcuffed)
						CM.legcuffed = null
						CM.update_inv_legcuffed()

/mob/living/verb/lay_down()
	set category = PANEL_IC
	set name = "Rest"

	resting = !resting
	to_chat(src, SPAN_INFO("You are now [resting ? "resting" : "getting up"]."))

/mob/living/proc/handle_ventcrawl(obj/machinery/atmospherics/unary/vent_pump/vent_found = null, ignore_items = 0) // -- TLE -- Merged by Carn
	if(stat)
		to_chat(src, "You must be conscious to do this!")
		return
	if(lying)
		to_chat(src, "You can't vent crawl while you're stunned!")
		return

	var/special_fail_msg = can_use_vents()
	if(special_fail_msg)
		to_chat(src, SPAN_WARNING("[special_fail_msg]"))
		return

	if(vent_found) // one was passed in, probably from vent/AltClick()
		if(vent_found.welded)
			to_chat(src, "That vent is welded shut.")
			return
		if(!vent_found.Adjacent(src))
			return // don't even acknowledge that
	else
		for(var/obj/machinery/atmospherics/unary/vent_pump/v in range(1, src))
			if(!v.welded)
				if(v.Adjacent(src))
					vent_found = v
	if(!vent_found)
		to_chat(src, "You'll need a non-welded vent to crawl into!")
		return

	if(!vent_found.network || !length(vent_found.network.normal_members))
		to_chat(src, "This vent is not connected to anything.")
		return

	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in vent_found.network.normal_members)
		if(temp_vent.welded)
			continue
		if(temp_vent in loc)
			continue
		var/turf/T = GET_TURF(temp_vent)

		if(isnull(T) || T.z != loc.z)
			continue

		var/i = 1
		var/index = "[T.loc.name]\[[i]\]"
		while(index in vents)
			i++
			index = "[T.loc.name]\[[i]\]"
		vents[index] = temp_vent
	if(!length(vents))
		to_chat(src, SPAN_WARNING("There are no available vents to travel to, they could be welded."))
		return

	var/obj/selection = input("Select a destination.", "Duct System") as null | anything in sortAssoc(vents)
	if(!selection)
		return

	if(!vent_found.Adjacent(src))
		to_chat(src, "Never mind, you left.")
		return

	if(!ignore_items)
		for(var/obj/item/carried_item in contents)//If the monkey got on objects.
			if(!istype(carried_item, /obj/item/implant) && !istype(carried_item, /obj/item/clothing/mask/facehugger)) //If it's not an implant or a facehugger
				to_chat(src, SPAN_WARNING("You can't be carrying items or have items equipped when vent crawling!"))
				return

	if(isslime(src))
		var/mob/living/carbon/slime/S = src
		if(S.Victim)
			to_chat(src, SPAN_WARNING("You'll have to let [S.Victim] go or finish eating \him first."))
			return

	var/obj/machinery/atmospherics/unary/vent_pump/target_vent = vents[selection]
	if(!target_vent)
		return

	visible_message("<B>[src] scrambles into the ventilation ducts!</B>")
	loc = target_vent

	var/travel_time = round(get_dist(loc, target_vent.loc) / 2)

	spawn(travel_time)

		if(!target_vent)
			return
		for(var/mob/O in hearers(target_vent, null))
			O.show_message("You hear something squeezing through the ventilation ducts.",2)

		sleep(travel_time)

		if(!target_vent)
			return
		if(target_vent.welded)			//the vent can be welded while alien scrolled through the list or travelled.
			target_vent = vent_found 	//travel back. No additional time required.
			to_chat(src, SPAN_WARNING("The vent you were heading to appears to be welded."))
		loc = target_vent.loc
		var/area/new_area = GET_AREA(src)
		new_area?.Entered(src)

/mob/living/proc/can_use_vents()
	return "You can't fit into that vent."

/mob/living/proc/has_brain()
	return 1

/mob/living/carbon/proc/spin(spintime, speed)
	spawn()
		var/D = dir
		while(spintime >= speed)
			sleep(speed)
			switch(D)
				if(NORTH)
					D = EAST
				if(SOUTH)
					D = WEST
				if(EAST)
					D = SOUTH
				if(WEST)
					D = NORTH
			set_dir(D)
			spintime -= speed
	return