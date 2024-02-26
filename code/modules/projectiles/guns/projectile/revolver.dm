/obj/item/gun/projectile/detective
	desc = "A cheap Martian knock-off of a Smith & Wesson Model 10. Uses .38-Special rounds."
	name = "revolver"
	icon_state = "detective"

	origin_tech = list(RESEARCH_TECH_COMBAT = 2, RESEARCH_TECH_MATERIALS = 2)

	caliber = "38"

	ammo_type = /obj/item/ammo_casing/c38
	max_shells = 6

/obj/item/gun/projectile/detective/special_check(mob/living/carbon/human/M)
	if(caliber == initial(caliber))
		return 1
	if(prob(70 - (length(loaded) * 10)))	//minimum probability of 10, maximum of 60
		to_chat(M, SPAN_DANGER("[src] blows up in your face."))
		M.take_organ_damage(0, 20)
		M.drop_item()
		qdel(src)
		return 0
	return 1

/obj/item/gun/projectile/detective/verb/rename_gun()
	set category = PANEL_OBJECT
	set name = "Name Gun"
	set desc = "Click to rename your gun. If you're the detective."

	var/mob/M = usr
	if(isnull(M.mind))
		return 0
	if(!M.mind.assigned_role == "Detective")
		to_chat(M, SPAN_NOTICE("You don't feel cool enough to name this gun, chump."))
		return 0

	var/input = stripped_input(usr,"What do you want to name the gun?", ,"", MAX_NAME_LEN)

	if(isnotnull(src) && input && !M.stat && in_range(M, src))
		name = input
		to_chat(M, "You name the gun [input]. Say hello to your new friend.")
		return 1

/obj/item/gun/projectile/detective/attackby(obj/item/A as obj, mob/user as mob)
	..()
	if(istype(A, /obj/item/screwdriver))
		if(caliber == "38")
			to_chat(user, SPAN_NOTICE("You begin to reinforce the barrel of [src]."))
			if(length(loaded))
				afterattack(user, user)	//you know the drill
				playsound(user, fire_sound, 50, 1)
				user.visible_message(
					SPAN_DANGER("[src] goes off!"),
					SPAN_DANGER("[src] goes off in your face!")
				)
				return
			if(do_after(user, 30))
				if(length(loaded))
					to_chat(user, SPAN_NOTICE("You can't modify it!"))
					return
				caliber = "357"
				desc = "The barrel and chamber assembly seems to have been modified."
				to_chat(user, SPAN_WARNING("You reinforce the barrel of [src]! Now it will fire .357 rounds."))
		else if(caliber == "357")
			to_chat(user, SPAN_NOTICE("You begin to revert the modifications to [src]."))

			if(length(loaded))
				afterattack(user, user)	//and again
				playsound(user, fire_sound, 50, 1)
				user.visible_message(
					SPAN_DANGER("[src] goes off!"),
					SPAN_DANGER("[src] goes off in your face!")
				)
				return
			if(do_after(user, 30))
				if(length(loaded))
					to_chat(user, SPAN_NOTICE("You can't modify it!"))
					return
				caliber = "38"
				desc = initial(desc)
				to_chat(user, SPAN_WARNING("You remove the modifications on [src]! Now it will fire .38 rounds."))

/obj/item/gun/projectile/detective/semiauto
	name = "\improper Colt M1911"
	desc = "A cheap Martian knock-off of a Colt M1911. Uses less-than-lethal .45 rounds."
	icon_state = "colt"

	caliber = ".45"

	ammo_type = /obj/item/ammo_casing/c45r
	max_shells = 7
	load_method = MAGAZINE

/obj/item/gun/projectile/detective/semiauto/New()
	. = ..()
	empty_mag = new /obj/item/ammo_magazine/c45r/empty(src)

/obj/item/gun/projectile/detective/semiauto/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag)
	..()
	if(!length(loaded) && empty_mag)
		empty_mag.loc = get_turf(loc)
		empty_mag = null
		to_chat(user, SPAN_NOTICE("The magazine falls out and clatters on the floor!"))

/obj/item/gun/projectile/mateba
	name = "mateba"
	desc = "When you absolutely, positively need a 10mm hole in the other guy. Uses .357 ammo."	//>10mm hole >.357
	icon_state = "mateba"

	origin_tech = list(RESEARCH_TECH_COMBAT = 2, RESEARCH_TECH_MATERIALS = 2)

// A gun to play Russian Roulette!
// You can spin the chamber to randomize the position of the bullet.
/obj/item/gun/projectile/russian
	name = "Russian Revolver"
	desc = "A Russian made revolver. Uses .357 ammo. It has a single slot in it's chamber for a bullet."

	origin_tech = list(RESEARCH_TECH_COMBAT = 2, RESEARCH_TECH_MATERIALS = 2)

	max_shells = 6

/obj/item/gun/projectile/russian/New()
	SHOULD_CALL_PARENT(FALSE)

	Spin()
	update_icon()

/obj/item/gun/projectile/russian/proc/Spin()
	for(var/obj/item/ammo_casing/AC in loaded)
		qdel(AC)
	loaded = list()
	var/random = rand(1, max_shells)
	for(var/i = 1; i <= max_shells; i++)
		if(i != random)
			loaded.Add(i) // Basically null
		else
			loaded.Add(new ammo_type(src))

/obj/item/gun/projectile/russian/attackby(obj/item/A as obj, mob/user as mob)
	if(isnull(A))
		return

	var/num_loaded = 0
	if(istype(A, /obj/item/ammo_magazine))
		if(load_method == MAGAZINE && length(loaded))
			return
		var/obj/item/ammo_magazine/AM = A
		for(var/obj/item/ammo_casing/AC in AM.stored_ammo)
			if(getAmmo() > 0 || length(loaded) >= max_shells)
				break
			if(AC.caliber == caliber && length(loaded) < max_shells)
				AC.loc = src
				AM.stored_ammo -= AC
				loaded += AC
				num_loaded++
			break
		A.update_icon()

	if(num_loaded)
		user.visible_message(
			SPAN_WARNING("[user] loads a single bullet into the revolver and spins the chamber."),
			SPAN_WARNING("You load a single bullet into the chamber and spin it.")
		)
	else
		user.visible_message(
			SPAN_WARNING("[user] spins the chamber of the revolver."),
			SPAN_WARNING("You spin the revolver's chamber.")
		)
	if(getAmmo() > 0)
		Spin()
	update_icon()

/obj/item/gun/projectile/russian/attack_self(mob/user as mob)
	user.visible_message(
		SPAN_WARNING("[user] spins the chamber of the revolver."),
		SPAN_WARNING("You spin the revolver's chamber.")
	)
	if(getAmmo() > 0)
		Spin()

/obj/item/gun/projectile/russian/attack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj)
	if(!length(loaded))
		user.visible_message(
			SPAN_WARNING("*click*"),
			SPAN_WARNING("*click*")
		)
		playsound(user, 'sound/weapons/empty.ogg', 100, 1)
		return

	if(isliving(target) && isliving(user))
		if(target == user)
			var/datum/organ/external/affecting = user.zone_sel.selecting
			if(affecting == "head")
				var/obj/item/ammo_casing/AC = loaded[1]
				if(!load_into_chamber())
					user.visible_message(
						SPAN_WARNING("*click*"),
						SPAN_WARNING("*click*")
					)
					playsound(user, 'sound/weapons/empty.ogg', 100, 1)
					return
				if(isnull(in_chamber))
					return
				var/obj/item/projectile/P = new AC.projectile_type
				playsound(user, fire_sound, 50, 1)
				user.visible_message(
					SPAN_DANGER("[user.name] fires [src] at \his head!"),
					SPAN_DANGER("You fire [src] at your head!"),
					"You hear a [istype(in_chamber, /obj/item/projectile/energy) ? "laser blast" : "gunshot"]!"
				)
				if(!P.nodamage)
					user.apply_damage(300, BRUTE, affecting, sharp = 1) // You are dead, dead, dead.
				return
	..()