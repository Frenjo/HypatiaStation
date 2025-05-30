/*
Contains most of the procs that are called when a mob is attacked by something

bullet_act
ex_act
meteor_act
emp_act

*/

/mob/living/carbon/human/bullet_act(obj/item/projectile/P, def_zone)

// BEGIN TASER NERF
					/* Commenting out new-old taser nerf.
					if(C.siemens_coefficient == 0) //If so, is that clothing shock proof?
						if(prob(deflectchance))
							visible_message("\red <B>The [P.name] gets deflected by [src]'s [C.name]!</B>") //DEFLECT!
							visible_message("\red <B> Taser hit for [P.damage] damage!</B>")
							del P
*/
/* Commenting out old Taser nerf
	if(wear_suit && istype(wear_suit, /obj/item/clothing/suit/armor))
		if(istype(P, /obj/item/projectile/energy/electrode))
			visible_message("\red <B>The [P.name] gets deflected by [src]'s [wear_suit.name]!</B>")
			del P
		return -1
*/
// END TASER NERF

	if(isnotnull(wear_suit) && istype(wear_suit, /obj/item/clothing/suit/armor/laserproof))
		if(istype(P, /obj/item/projectile/energy))
			var/reflectchance = 40 - round(P.damage / 3)
			if(!(def_zone in list("chest", "groin")))
				reflectchance /= 2
			if(prob(reflectchance))
				visible_message(SPAN_DANGER("The [P.name] gets reflected by [src]'s [wear_suit.name]!"))

				// Find a turf near or on the original location to bounce to
				if(P.starting)
					var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
					var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
					var/turf/curloc = GET_TURF(src)

					// redirect the projectile
					P.original = locate(new_x, new_y, P.z)
					P.starting = curloc
					P.current = curloc
					P.firer = src
					P.yo = new_y - curloc.y
					P.xo = new_x - curloc.x

				return -1 // complete projectile permutation

	if(check_shields(P.damage, "the [P.name]"))
		P.on_hit(src, 2)
		handle_suit_punctures(P.damage_type, P.damage)
		return 2

//BEGIN BOOK'S TASER NERF.
	if(istype(P, /obj/item/projectile/energy/electrode))
		var/datum/organ/external/select_area = get_organ(def_zone) // We're checking the outside, buddy!
		var/list/body_parts = list(head, wear_mask, wear_suit, wear_uniform, gloves, shoes) // What all are we checking?
		// var/deflectchance=90 //Is it a CRITICAL HIT with that taser?
		for(var/bp in body_parts) //Make an unregulated var to pass around.
			if(!bp)
				continue //Does this thing we're shooting even exist?
			if(bp && istype(bp, /obj/item/clothing)) // If it exists, and it's clothed
				var/obj/item/clothing/C = bp // Then call an argument C to be that clothing!
				if(C.body_parts_covered & select_area.body_part) // Is that body part being targeted covered?
					P.agony = P.agony * C.siemens_coefficient
		apply_effect(P.agony, AGONY, 0)
		flash_pain()
		to_chat(src, SPAN_WARNING("You have been shot!"))
		qdel(P)

		var/obj/item/cloaking_device/C = locate(/obj/item/cloaking_device) in src
		if(C && C.active)
			C.attack_self(src)//Should shut it off
			update_icons()
			to_chat(src, SPAN_INFO("Your [C.name] was disrupted!"))
			Stun(2)

		if(istype(get_active_hand(), /obj/item/assembly/signaler))
			var/obj/item/assembly/signaler/signaler = get_active_hand()
			if(signaler.deadman && prob(80))
				src.visible_message(SPAN_WARNING("[src] triggers their deadman's switch!"))
				signaler.signal()

		return
//END TASER NERF

	var/datum/organ/external/organ = get_organ(check_zone(def_zone))
	var/armor = checkarmor(organ, "bullet")
	if((P.embed && prob(20 + max(P.damage - armor, -10))) && P.damage_type == BRUTE)
		var/obj/item/shard/shrapnel/SP = new()
		(SP.name) = "[P.name] shrapnel"
		(SP.desc) = "[SP.desc] It looks like it was fired from [P.shot_from]."
		(SP.loc) = organ
		organ.implants += SP
		visible_message(SPAN_DANGER("The projectile sticks in the wound!"))
		embedded_flag = 1
		src.verbs += /mob/proc/yank_out_object
		SP.add_blood(src)

	return (..(P , def_zone))


/mob/living/carbon/human/getarmor(def_zone, type)
	var/armorval = 0
	var/organnum = 0

	if(def_zone)
		if(isorgan(def_zone))
			return checkarmor(def_zone, type)
		var/datum/organ/external/affecting = get_organ(ran_zone(def_zone))
		return checkarmor(affecting, type)
		//If a specific bodypart is targetted, check how that bodypart is protected and return the value.

	//If you don't specify a bodypart, it checks ALL your bodyparts for protection, and averages out the values
	for(var/datum/organ/external/organ in organs)
		armorval += checkarmor(organ, type)
		organnum++
	return (armorval/max(organnum, 1))


/mob/living/carbon/human/proc/checkarmor(datum/organ/external/def_zone, type)
	if(!type)
		return 0
	var/protection = 0
	var/list/body_parts = list(head, wear_mask, wear_suit, wear_uniform)
	for(var/bp in body_parts)
		if(!bp)
			continue
		if(bp && istype(bp, /obj/item/clothing))
			var/obj/item/clothing/C = bp
			if(C.body_parts_covered & def_zone.body_part)
				protection += C.armor[type]
	return protection

/mob/living/carbon/human/proc/check_head_coverage()
	var/list/body_parts = list(head, wear_mask, wear_suit, wear_uniform)
	for(var/bp in body_parts)
		if(!bp)
			continue
		if(bp && istype(bp, /obj/item/clothing))
			var/obj/item/clothing/C = bp
			if(C.body_parts_covered & HEAD)
				return 1
	return 0

/mob/living/carbon/human/proc/check_shields(damage = 0, attack_text = "the attack")
	if(l_hand && isitem(l_hand))//Current base is the prob(50-d/3)
		var/obj/item/I = l_hand
		if(I.IsShield() && (prob(50 - round(damage / 3))))
			visible_message(SPAN_DANGER("[src] blocks [attack_text] with the [l_hand.name]!"))
			return 1
	if(r_hand && isitem(r_hand))
		var/obj/item/I = r_hand
		if(I.IsShield() && (prob(50 - round(damage / 3))))
			visible_message(SPAN_DANGER("[src] blocks [attack_text] with the [r_hand.name]!"))
			return 1
	if(wear_suit && isitem(wear_suit))
		var/obj/item/I = wear_suit
		if(I.IsShield() && (prob(35)))
			visible_message(SPAN_DANGER("The reactive teleport system flings [src] clear of [attack_text]!"))
			var/list/turfs = list()
			for_no_type_check(var/turf/T, RANGE_TURFS(src, 6))
				if(isspace(T))
					continue
				if(T.density)
					continue
				if(T.x > world.maxx-6 || T.x < 6)
					continue
				if(T.y > world.maxy-6 || T.y < 6)
					continue
				turfs += T
			if(!length(turfs))
				turfs += pick(/turf in RANGE_TURFS(src, 6))
			var/turf/picked = pick(turfs)
			if(!isturf(picked))
				return
			forceMove(picked)
			return 1
	return 0

/mob/living/carbon/human/emp_act(severity)
	for(var/obj/O in src)
		if(!O)
			continue
		O.emp_act(severity)
	for(var/datum/organ/external/O  in organs)
		if(O.status & ORGAN_DESTROYED)
			continue
		O.emp_act(severity)
		for(var/datum/organ/internal/I  in O.internal_organs)
			if(I.robotic == 0)
				continue
			I.emp_act(severity)
	..()

/mob/living/carbon/human/proc/attacked_by(obj/item/I, mob/living/user, def_zone)
	if(!I || !user)
		return 0

	var/target_zone = get_zone_with_miss_chance(user.zone_sel.selecting, src)
	if(user == src) // Attacking yourself can't miss
		target_zone = user.zone_sel.selecting
	if(!target_zone)
		visible_message(SPAN_DANGER("[user] misses [src] with \the [I]!"))
		return 0

	var/datum/organ/external/affecting = get_organ(target_zone)
	if(!affecting)
		return 0
	if(affecting.status & ORGAN_DESTROYED)
		to_chat(user, "What [affecting.display_name]?")
		return 0
	var/hit_area = affecting.display_name

	if((user != src) && check_shields(I.force, "the [I.name]"))
		return 0

	if(istype(I,/obj/item/card/emag))
		if(!(affecting.status & ORGAN_ROBOT))
			to_chat(user, SPAN_WARNING("That limb isn't robotic."))
			return
		if(affecting.sabotaged)
			to_chat(user, SPAN_WARNING("[src]'s [affecting.display_name] is already sabotaged!"))
		else
			to_chat(user, SPAN_WARNING("You sneakily slide [I] into the dataport on [src]'s [affecting.display_name] and short out the safeties."))
			var/obj/item/card/emag/emag = I
			emag.uses--
			affecting.sabotaged = 1
		return 1

	if(length(I.attack_verb))
		visible_message(SPAN_DANGER("[src] has been [pick(I.attack_verb)] in the [hit_area] with [I.name] by [user]!"))
	else
		visible_message(SPAN_DANGER("[src] has been attacked in the [hit_area] with [I.name] by [user]!"))

	var/armor = run_armor_check(affecting, "melee", "Your armor has protected your [hit_area].", "Your armor has softened hit to your [hit_area].")
	if(armor >= 2)
		return 0
	if(!I.force)
		return 0

	apply_damage(I.force, I.damtype, affecting, armor, is_sharp(I), has_edge(I), I)

	var/bloody = 0
	if(((I.damtype == BRUTE) || (I.damtype == HALLOSS)) && prob(25 + (I.force * 2)))
		I.add_blood(src)	//Make the weapon bloody, not the person.
//		if(user.hand)	user.update_inv_l_hand()	//updates the attacker's overlay for the (now bloodied) weapon
//		else			user.update_inv_r_hand()	//removed because weapons don't have on-mob blood overlays
		if(prob(33))
			bloody = 1
			var/turf/location = loc
			if(isopenturf(location))
				location.add_blood(src)
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				if(get_dist(H, src) <= 1) //people with TK won't get smeared with blood
					H.bloody_body(src)
					H.bloody_hands(src)

		switch(hit_area)
			if("head")//Harder to score a stun but if you do it lasts a bit longer
				if(prob(I.force))
					apply_effect(20, PARALYZE, armor)
					visible_message(SPAN_DANGER("[src] has been knocked unconscious!"))
					if(src != user && I.damtype == BRUTE)
						global.PCticker.mode.remove_revolutionary(mind)

				if(bloody)//Apply blood
					if(isnotnull(wear_mask))
						wear_mask.add_blood(src)
						update_inv_wear_mask(0)
					if(isnotnull(head))
						head.add_blood(src)
						update_inv_head(0)
					if(isnotnull(glasses) && prob(33))
						glasses.add_blood(src)
						update_inv_glasses(0)

			if("chest")//Easier to score a stun but lasts less time
				if(prob((I.force + 10)))
					//apply_effect(5, WEAKEN, armor)
					apply_effect(6, WEAKEN, armor)
					visible_message(SPAN_DANGER("[src] has been knocked down!"))

				if(bloody)
					bloody_body(src)
	return 1

/mob/living/carbon/human/proc/bloody_hands(mob/living/source, amount = 2)
	if(gloves)
		gloves.add_blood(source)
		gloves:transfer_blood = amount
		gloves:bloody_hands_mob = source
	else
		add_blood(source)
		bloody_hands = amount
		bloody_hands_mob = source
	update_inv_gloves()		//updates on-mob overlays for bloody hands and/or bloody gloves

/mob/living/carbon/human/proc/bloody_body(mob/living/source)
	if(isnotnull(wear_suit))
		wear_suit.add_blood(source)
		update_inv_wear_suit(0)
	if(isnotnull(wear_uniform))
		wear_uniform.add_blood(source)
		update_inv_wear_uniform(0)

/mob/living/carbon/human/proc/handle_suit_punctures(damtype, damage)
	if(!wear_suit)
		return
	if(!istype(wear_suit, /obj/item/clothing/suit/space))
		return
	if(damtype != BURN && damtype != BRUTE)
		return

	var/obj/item/clothing/suit/space/SS = wear_suit
	var/penetrated_dam = max(0, (damage - max(0, (SS.breach_threshold - SS.damage))))
	if(penetrated_dam)
		SS.create_breaches(damtype, penetrated_dam)