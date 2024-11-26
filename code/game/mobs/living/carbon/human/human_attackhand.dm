/mob/living/carbon/human/attack_hand(mob/living/carbon/human/M)
	var/datum/organ/external/temp = M:organs_by_name["r_hand"]
	if(M.hand)
		temp = M:organs_by_name["l_hand"]
	if(temp && !temp.is_usable())
		to_chat(M, SPAN_WARNING("You can't use your [temp.display_name]."))
		return

	..()

	if((M != src) && check_shields(0, M.name))
		visible_message(SPAN_DANGER("[M] attempted to touch [src]!"))
		return 0

	if(M.gloves && istype(M.gloves, /obj/item/clothing/gloves))
		var/obj/item/clothing/gloves/G = M.gloves
		if(G.cell)
			if(M.a_intent == "hurt")//Stungloves. Any contact will stun the alien.
				if(G.cell.charge >= 2500)
					G.cell.use(2500)
					visible_message(SPAN_DANGER("[src] has been touched with the stun gloves by [M]!"))
					M.attack_log += text("\[[time_stamp()]\] <font color='red'>Stungloved [src.name] ([src.ckey])</font>")
					src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been stungloved by [M.name] ([M.ckey])</font>")

					msg_admin_attack("[M.name] ([M.ckey]) stungloved [src.name] ([src.ckey]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[M.x];Y=[M.y];Z=[M.z]'>JMP</a>)")

					var/armorblock = run_armor_check(M.zone_sel.selecting, "energy")
					apply_effects(5, 5, 0, 0, 5, 0, 0, armorblock)
					return 1
				else
					to_chat(M, SPAN_WARNING("Not enough charge!"))
					visible_message(SPAN_DANGER("[src] has been touched with the stun gloves by [M]!"))
				return

		if(istype(M.gloves, /obj/item/clothing/gloves/boxing/hologlove))
			var/damage = rand(0, 9)
			if(!damage)
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				visible_message(SPAN_DANGER("[M] has attempted to punch [src]!"))
				return 0
			var/datum/organ/external/affecting = get_organ(ran_zone(M.zone_sel.selecting))
			var/armor_block = run_armor_check(affecting, "melee")

			if(MUTATION_HULK in M.mutations)			damage += 5

			playsound(loc, "punch", 25, 1, -1)

			visible_message(SPAN_DANGER("[M] has punched [src]!"))

			apply_damage(damage, HALLOSS, affecting, armor_block)
			if(damage >= 9)
				visible_message(SPAN_DANGER("[M] has weakened [src]!"))
				apply_effect(4, WEAKEN, armor_block)

			return
	else
		if(iscarbon(M))
//			log_debug("No gloves, [M] is truing to infect [src]")
			M.spread_disease_to(src, "Contact")


	switch(M.a_intent)
		if("help")
			if(health >= CONFIG_GET(health_threshold_crit))
				help_shake_act(M)
				return 1
//			if(M.health < -75)	return 0

			if(M.is_mouth_covered())
				to_chat(M, SPAN_INFO_B("Remove their mask!"))
				return 0
			if(is_mouth_covered())
				to_chat(M, SPAN_INFO_B("Remove your mask!"))
				return 0

			var/obj/effect/equip_e/human/O = new /obj/effect/equip_e/human()
			O.source = M
			O.target = src
			O.s_loc = M.loc
			O.t_loc = loc
			O.place = "CPR"
			requests += O
			spawn(0)
				O.process()
			return 1

		if("grab")
			if(M == src || anchored)
				return 0
			if(wear_uniform)
				wear_uniform.add_fingerprint(M)

			var/obj/item/grab/G = new /obj/item/grab(M, src)
			if(buckled)
				to_chat(M, SPAN_NOTICE("You cannot grab [src], \he is buckled in!"))
			if(!G)	//the grab will delete itself in New if affecting is anchored
				return
			M.put_in_active_hand(G)
			grabbed_by += G
			G.synch()
			LAssailant = M

			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			visible_message(SPAN_WARNING("[M] has grabbed [src] passively!"))
			return 1

		if("hurt")
			// See if they can attack, and which attacks to use.
			var/decl/unarmed_attack/attack = null
			for(var/type in M.species.unarmed_attacks)
				var/decl/unarmed_attack/u_attack = GET_DECL_INSTANCE(type)
				if(isnull(u_attack) || !u_attack.is_usable(M))
					continue
				else
					attack = u_attack
					break

			if(isnull(attack))
				return 0

			var/attack_verb = pick(attack.attack_verb)

			M.attack_log += text("\[[time_stamp()]\] <font color='red'>[attack_verb]ed [src.name] ([src.ckey])</font>")
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been [attack_verb]ed by [M.name] ([M.ckey])</font>")
			msg_admin_attack("[key_name(M)] [attack_verb]ed [key_name(src)]")

			var/damage = rand(0, 5)//BS12 EDIT
			if(!damage)
				playsound(loc, attack.miss_sound, 25, 1, -1)
				visible_message(SPAN_DANGER("[M] attempted to [attack_verb] [src]!"))
				return 0

			var/datum/organ/external/affecting = get_organ(ran_zone(M.zone_sel.selecting))
			var/armor_block = run_armor_check(affecting, "melee")

			if(MUTATION_HULK in M.mutations)
				damage += 5

			playsound(loc, attack.attack_sound, 25, 1, -1)

			visible_message(SPAN_DANGER("[M] has [attack_verb]ed [src]!"))
			//Rearranged, so claws don't increase weaken chance.
			if(damage >= 5 && prob(50))
				visible_message(SPAN_DANGER("[M] has weakened [src]!"))
				apply_effect(2, WEAKEN, armor_block)

			damage += attack.damage
			apply_damage(damage, BRUTE, affecting, armor_block, sharp = attack.sharp, edge = attack.edge)

		if("disarm")
			M.attack_log += text("\[[time_stamp()]\] <font color='red'>Disarmed [src.name] ([src.ckey])</font>")
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been disarmed by [M.name] ([M.ckey])</font>")

			msg_admin_attack("[key_name(M)] disarmed [src.name] ([src.ckey])")

			if(wear_uniform)
				wear_uniform.add_fingerprint(M)
			var/datum/organ/external/affecting = get_organ(ran_zone(M.zone_sel.selecting))

			if(istype(r_hand, /obj/item/gun) || istype(l_hand, /obj/item/gun))
				var/obj/item/gun/W = null
				var/chance = 0

				if(istype(l_hand, /obj/item/gun))
					W = l_hand
					chance = hand ? 40 : 20

				if(istype(r_hand,/obj/item/gun))
					W = r_hand
					chance = !hand ? 40 : 20

				if(prob(chance))
					visible_message(SPAN_DANGER("[src]'s [W] goes off during the struggle!"))
					var/list/turfs = list()
					for(var/turf/T in view())
						turfs += T
					var/turf/target = pick(turfs)
					return W.afterattack(target,src)

			var/randn = rand(1, 100)
			if(!HAS_SPECIES_FLAGS(species, SPECIES_FLAG_NO_SLIP) && randn <= 25)
				var/armor_check = run_armor_check(affecting, "melee")
				apply_effect(3, WEAKEN, armor_check)
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
				if(armor_check < 2)
					visible_message(SPAN_DANGER("[M] has pushed [src]!"))
				else
					visible_message(SPAN_WARNING("[M] attempted to push [src]!"))
				return

			var/talked = 0	// BubbleWrap

			if(randn <= 60)
				//BubbleWrap: Disarming breaks a pull
				if(pulling)
					visible_message(SPAN_DANGER("[M] has broken [src]'s grip on [pulling]!"))
					talked = 1
					stop_pulling()

				//BubbleWrap: Disarming also breaks a grab - this will also stop someone being choked, won't it?
				if(istype(l_hand, /obj/item/grab))
					var/obj/item/grab/lgrab = l_hand
					if(lgrab.affecting)
						visible_message(SPAN_DANGER("[M] has broken [src]'s grip on [lgrab.affecting]!"))
						talked = 1
					spawn(1)
						qdel(lgrab)
				if(istype(r_hand, /obj/item/grab))
					var/obj/item/grab/rgrab = r_hand
					if(rgrab.affecting)
						visible_message(SPAN_DANGER("[M] has broken [src]'s grip on [rgrab.affecting]!"))
						talked = 1
					spawn(1)
						qdel(rgrab)
				//End BubbleWrap

				if(!talked)	//BubbleWrap
					drop_item()
					visible_message(SPAN_DANGER("[M] has disarmed [src]!"))
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
				return


			playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
			visible_message(SPAN_DANGER("[M] attempted to disarm [src]!"))
	return

/mob/living/carbon/human/proc/afterattack(atom/target, mob/living/user, inrange, params)
	return