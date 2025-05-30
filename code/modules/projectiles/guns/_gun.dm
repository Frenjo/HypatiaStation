/obj/item/gun
	name = "gun"
	desc = "Its a gun. It's pretty terrible, though."
	icon = 'icons/obj/weapons/gun.dmi'
	icon_state = "detective"
	item_state = "gun"

	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT
	matter_amounts = alist(/decl/material/steel = 2000)
	origin_tech = alist(/decl/tech/combat = 1)

	throwforce = 5
	throw_speed = 4
	throw_range = 5
	force = 5
	attack_verb = list("struck", "hit", "bashed")

	var/fire_sound = 'sound/weapons/gun/gunshot.ogg'
	var/fire_delay = 0.6 SECONDS
	var/last_fired = 0
	var/firerate = 0 	// 0 for keep shooting until aim is lowered.
						// 1 for one bullet after target moves and aim is lowered.

	var/silenced = 0
	var/recoil = FALSE
	var/ejectshell = TRUE
	var/clumsy_check = TRUE
	var/automatic = FALSE	// Used to determine if you can target multiple people.

	var/caliber = ""
	var/obj/item/projectile/in_chamber = null

	var/tmp/list/mob/living/target = null	// List of who yer targeting.
	var/tmp/lock_time = -100
	var/tmp/mouthshoot = FALSE				// To stop people from suiciding twice... >.>
	var/tmp/mob/living/last_moved_mob		// Used to fire faster at more than one person.
	var/tmp/told_cant_shoot = FALSE			// So that it doesn't spam them with the fact they cannot hit them.

/obj/item/gun/proc/ready_to_fire()
	if(world.time >= last_fired + fire_delay)
		last_fired = world.time
		return 1
	else
		return 0

/obj/item/gun/proc/load_into_chamber()
	return 0

/obj/item/gun/proc/special_check(mob/living/user) // Any special checks, like detective's revolver.
	if(!user.IsAdvancedToolUser())
		FEEDBACK_NOT_ENOUGH_DEXTERITY(user)
		return FALSE

	if(MUTATION_HULK in user.mutations)
		to_chat(user, SPAN_WARNING("Your meaty finger is much too large for the trigger guard!"))
		return FALSE

	if(user.dna?.mutantrace == "adamantine")
		to_chat(user, SPAN_WARNING("Your metal fingers don't fit in the trigger guard!"))
		return FALSE

	if(clumsy_check && ((MUTATION_CLUMSY in user.mutations) && prob(50)))
		handle_post_fire(user)
		to_chat(user, SPAN_DANGER("\The [src] blows up in your face!"))
		user.take_organ_damage(0, 20)
		user.drop_item()
		qdel(src)
		return FALSE

	return TRUE

/obj/item/gun/emp_act(severity)
	for(var/obj/O in contents)
		O.emp_act(severity)

/obj/item/gun/afterattack(atom/A, mob/living/user, flag, params)
	if(flag)
		return //It's adjacent, is the user, or is on the user's person
	if(istype(target, /obj/machinery/recharger) && istype(src, /obj/item/gun/energy))
		return//Shouldnt flag take care of this?

	//decide whether to aim or shoot normally
	var/aiming = 0
	if(user && user.client && !(A in target))
		var/client/C = user.client
		//If help intent is on and we have clicked on an eligible target, switch to aim mode automatically
		if(user.a_intent == "help" && isliving(A) && !C.gun_mode)
			C.ToggleGunMode()

		if(C.gun_mode)
			aiming = PreFire(A, user, params) //They're using the new gun system, locate what they're aiming at.

	if(!aiming)
		if(user && user.a_intent == "help") //regardless of what happens, refuse to shoot if help intent is on
			to_chat(user, SPAN_WARNING("You refrain from firing [src] as your intent is set to help."))
		else
			Fire(A, user, params) //Otherwise, fire normally.

/obj/item/gun/proc/isHandgun()
	return TRUE

/obj/item/gun/proc/Fire(atom/target, mob/living/user, params, reflex = FALSE)//TODO: go over this
	if(isnull(target) || isnull(user))
		return

	add_fingerprint(user)

	if(!special_check(user))
		return

	if(!ready_to_fire())
		if(world.time % 3) //to prevent spam
			to_chat(user, SPAN_WARNING("\The [src] is not ready to fire again!"))
		return

	if(!load_into_chamber()) //CHECK
		return click_empty(user)

	if(isnull(in_chamber))
		return

	user.next_move = world.time + 4

	var/x_offset = 0
	var/y_offset = 0
	if(iscarbon(user))
		var/mob/living/carbon/mob = user
		if(mob.shock_stage > 120)
			x_offset += rand(-2, 2)
			y_offset += rand(-2, 2)
		else if(mob.shock_stage > 70)
			x_offset += rand(-1, 1)
			y_offset += rand(-1, 1)

	if(isnotnull(params))
		in_chamber.set_clickpoint(params)

	if(isnotnull(in_chamber))
		var/result = in_chamber.launch(target, user, src, user.zone_sel.selecting, x_offset, y_offset)
		if(!result)
			return

	sleep(1)
	in_chamber = null

	handle_post_fire(user, reflex)
	update_icon()
	if(user.hand)
		user.update_inv_l_hand()
	else
		user.update_inv_r_hand()

/obj/item/gun/proc/handle_post_fire(mob/user, reflex = FALSE)
	if(silenced)
		playsound(user, fire_sound, 10, 1)
	else
		playsound(user, fire_sound, 50, 1)
		user.visible_message(
			SPAN_WARNING("[user] fires \the [src][reflex ? " by reflex" : ""]!"),
			SPAN_WARNING("You fire \the [src][reflex ? "by reflex":""]!"),
			"You hear a [istype(in_chamber, /obj/item/projectile/energy) ? "laser blast" : "gunshot"]!"
		)

	if(recoil)
		spawn()
			shake_camera(user, recoil + 1, recoil)

/obj/item/gun/proc/can_fire()
	return load_into_chamber()

/obj/item/gun/proc/can_hit(mob/living/target, mob/living/user)
	return in_chamber.check_fire(target, user)

/obj/item/gun/proc/click_empty(mob/user = null)
	if(isnotnull(user))
		user.visible_message("*click click*", SPAN_DANGER("*click*"))
		playsound(user, 'sound/weapons/empty.ogg', 100, 1)
	else
		visible_message("*click click*")
		playsound(src, 'sound/weapons/empty.ogg', 100, 1)

/obj/item/gun/attack(mob/living/M, mob/living/user, def_zone)
	//Suicide handling.
	if(M == user && user.zone_sel.selecting == "mouth" && !mouthshoot)
		mouthshoot = TRUE
		M.visible_message(SPAN_WARNING("[user] sticks their gun in their mouth, ready to pull the trigger..."))
		if(!do_after(user, 40))
			M.visible_message(SPAN_INFO("[user] decided life was worth living."))
			mouthshoot = FALSE
			return
		if(load_into_chamber())
			user.visible_message(SPAN_WARNING("[user] pulls the trigger."))
			if(silenced)
				playsound(user, fire_sound, 10, 1)
			else
				playsound(user, fire_sound, 50, 1)
			if(istype(in_chamber, /obj/item/projectile/energy/beam/laser/tag))
				user.show_message(SPAN_WARNING("You feel rather silly, trying to commit suicide with a toy."))
				mouthshoot = FALSE
				return

			in_chamber.on_hit(M)
			if(in_chamber.damage_type != HALLOSS)
				user.apply_damage(in_chamber.damage * 2.5, in_chamber.damage_type, "head", used_weapon = "Point blank shot in the mouth with \a [in_chamber]", sharp = 1)
				user.death()
			else
				to_chat(user, SPAN_NOTICE("Ow..."))
				user.apply_effect(110, AGONY, 0)
			qdel(in_chamber)
			mouthshoot = FALSE
			return
		else
			click_empty(user)
			mouthshoot = FALSE
			return

	if(load_into_chamber())
		//Point blank shooting if on harm intent or target we were targeting.
		if(user.a_intent == "hurt")
			user.visible_message(SPAN_DANGER("\The [user] fires \the [src] point blank at [M]!"))
			in_chamber.damage *= 1.3
			Fire(M, user)
			return
		else if(target && (M in target))
			Fire(M, user) ///Otherwise, shoot!
			return
	else
		return ..() //Pistolwhippin'