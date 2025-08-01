// Vox pinning weapon.

// Ammo.
/obj/item/spike
	name = "alloy spike"
	desc = "It's about a foot of weird silver metal with a wicked point."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "metal-rod"
	item_state = "bolt"

	throwforce = 5
	sharp = TRUE

	w_class = 2

// Launcher.
/obj/item/spikethrower
	name = "\improper Vox spike thrower"
	desc = "A vicious alien projectile weapon. Parts of it quiver gelatinously, as though the thing is insectile and alive."
	icon = 'icons/obj/weapons/gun.dmi'
	icon_state = "spikethrower3"
	item_state = "spikethrower"

	var/last_regen = 0
	var/spike_gen_time = 100
	var/max_spikes = 3
	var/spikes = 3
	var/obj/item/spike/spike
	var/fire_force = 30

	// Going to make an effort to get this compatible with the threat targetting system.
	var/tmp/list/mob/living/target
	var/tmp/mob/living/last_moved_mob

/obj/item/spikethrower/initialise()
	. = ..()
	START_PROCESSING(PCobj, src)
	last_regen = world.time

/obj/item/spikethrower/Destroy()
	QDEL_NULL(spike)
	STOP_PROCESSING(PCobj, src)
	return ..()

/obj/item/spikethrower/process()
	if(spikes < max_spikes && world.time > last_regen + spike_gen_time)
		spikes++
		last_regen = world.time
		update_icon()

/obj/item/spikethrower/get_examine_text()
	. = ..()
	. += SPAN_INFO("It has <em>[spikes]</em> spike\s remaining.")

/obj/item/spikethrower/update_icon()
	icon_state = "spikethrower[spikes]"

/obj/item/spikethrower/afterattack(atom/A, mob/living/user, flag, params)
	if(flag)
		return
	if(isnotnull(user?.client) && user.client.gun_mode && !(A in target))
		//TODO: Make this compatible with targetting (prolly have to actually make it a gun subtype, ugh.)
		//PreFire(A,user,params)
	else
		Fire(A, user, params)

/obj/item/spikethrower/attack(mob/living/M, mob/living/user, def_zone)
	if(M == user && user.zone_sel.selecting == "mouth")
		M.visible_message(SPAN_WARNING("[user] attempts without success to fit [src] into their mouth."))
		return

	if(spikes > 0)
		if(user.a_intent == "hurt")
			user.visible_message(SPAN_DANGER("\The [user] fires \the [src] point blank at [M]!"))
			Fire(M, user)
			return
		else if(target && (M in target))
			Fire(M, user)
			return
	else
		return ..()

/obj/item/spikethrower/proc/Fire(atom/target, mob/living/user, params, reflex = 0)
	add_fingerprint(user)

	var/turf/curloc = GET_TURF(user)
	var/turf/targloc = GET_TURF(target)
	if(!istype(targloc) || !istype(curloc))
		return

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.species?.name != SPECIES_VOX)
			to_chat(user, SPAN_WARNING("The weapon does not respond to you!"))
			return
	else
		to_chat(user, SPAN_WARNING("The weapon does not respond to you!"))
		return

	if(spikes <= 0)
		to_chat(user, SPAN_WARNING("The weapon has nothing to fire!"))
		return

	if(isnull(spike))
		spike = new /obj/item/spike(src) //Create a spike.
		spike.add_fingerprint(user)
		spikes--

	user.visible_message(
		SPAN_WARNING("[user] fires [src]!"),
		SPAN_WARNING("You fire [src]!")
	)
	spike.forceMove(GET_TURF(src))
	spike.throw_at(target, 10, fire_force)
	spike = null
	update_icon()

// This gun only functions for armalis. The on-sprite is too huge to render properly on other sprites.
/obj/item/gun/energy/noisecannon
	name = "alien heavy cannon"
	desc = "It's some kind of enormous alien weapon, as long as a man is tall."
	icon = 'icons/obj/weapons/gun.dmi' // Actual on-sprite is handled by icon_override.
	icon_state = "noisecannon"
	item_state = "noisecannon"

	force = 10

	fire_sound = 'sound/effects/basscannon.ogg'
	fire_delay = 4 SECONDS

	recoil = TRUE

	cell_type = /obj/item/cell/super

	gun_setting = GUN_SETTING_SPECIAL
	pulse_projectile_types = list(
		GUN_SETTING_SPECIAL = /obj/item/projectile/energy/sonic
	)

	var/mode = 1

/obj/item/gun/energy/noisecannon/attack_hand(mob/user)
	if(loc != user)
		var/mob/living/carbon/human/H = user
		if(istype(H))
			if(istype(H.species, /datum/species/vox/armalis))
				..()
				return
		to_chat(user, SPAN_WARNING("\The [src] is far too large for you to pick up."))
		return

/obj/item/gun/energy/noisecannon/load_into_chamber() //Does not have ammo.
	in_chamber = new projectile_type(src)
	return 1

/obj/item/gun/energy/noisecannon/update_icon()
	return

//Projectile.
/obj/item/projectile/energy/sonic
	name = "distortion"
	icon = 'icons/obj/machines/particle_accelerator2.dmi'
	icon_state = "particle"
	pass_flags = parent_type::pass_flags | PASS_FLAG_GLASS | PASS_FLAG_GRILLE

	damage = 60
	damage_type = BRUTE
	flag = "bullet"

	stun = 5
	weaken = 5
	embed = FALSE

/obj/item/projectile/energy/sonic/proc/split()
	//TODO: create two more projectiles to either side of this one, fire at targets to the side of target turf.
	return