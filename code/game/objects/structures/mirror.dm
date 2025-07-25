//wip wip wup
/obj/structure/mirror
	name = "mirror"
	desc = "Mirror mirror on the wall, who's the most robust of them all?"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mirror"
	density = FALSE
	anchored = TRUE
	var/shattered = 0

/obj/structure/mirror/attack_hand(mob/user)
	if(shattered)
		return

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.a_intent == "hurt")
			if(shattered)
				playsound(src, 'sound/effects/glass/hit_on_shattered_glass.ogg', 70, 1)
				return
			if(prob(30) || H.species.can_shred(H))
				user.visible_message(SPAN_DANGER("[user] smashes [src]!"))
				shatter()
			else
				user.visible_message(SPAN_DANGER("[user] hits [src] and bounces off!"))
			return

		var/userloc = H.loc

		//see code/game/mobs/dead/new_player/preferences.dm at approx line 545 for comments!
		//this is largely copypasted from there.

		//handle facial hair (if necessary)
		if(H.gender == MALE)
			var/list/species_facial_hair = list()
			if(H.species)
				for(var/i in GLOBL.facial_hair_styles_list)
					var/datum/sprite_accessory/facial_hair/tmp_facial = GLOBL.facial_hair_styles_list[i]
					if(H.species.name in tmp_facial.species_allowed)
						species_facial_hair += i
			else
				species_facial_hair = GLOBL.facial_hair_styles_list

			var/new_style = input(user, "Select a facial hair style", "Grooming") as null|anything in species_facial_hair
			if(userloc != H.loc)
				return	//no tele-grooming
			if(new_style)
				H.f_style = new_style

		//handle normal hair
		var/list/species_hair = list()
		if(H.species)
			for(var/i in GLOBL.hair_styles_list)
				var/datum/sprite_accessory/hair/tmp_hair = GLOBL.hair_styles_list[i]
				if(H.species.name in tmp_hair.species_allowed)
					species_hair += i
		else
			species_hair = GLOBL.hair_styles_list

		var/new_style = input(user, "Select a hair style", "Grooming") as null|anything in species_hair
		if(userloc != H.loc)
			return	//no tele-grooming
		if(new_style)
			H.h_style = new_style

		H.update_hair()

/obj/structure/mirror/proc/shatter()
	if(shattered)
		return
	shattered = 1
	icon_state = "mirror_broke"
	playsound(src, "shatter", 70, 1)
	desc = "Oh no, seven years of bad luck!"

/obj/structure/mirror/bullet_act(obj/item/projectile/bullet)
	if(prob(bullet.damage * 2))
		if(bullet.damage_type == BRUTE || bullet.damage_type == BURN)
			if(!shattered)
				shatter()
			else
				playsound(src, 'sound/effects/glass/hit_on_shattered_glass.ogg', 70, 1)
	..()


/obj/structure/mirror/attackby(obj/item/I, mob/user)
	if(shattered)
		playsound(src, 'sound/effects/glass/hit_on_shattered_glass.ogg', 70, 1)
		return

	if(prob(I.force * 2))
		visible_message(SPAN_WARNING("[user] smashes [src] with [I]!"))
		shatter()
	else
		visible_message(SPAN_WARNING("[user] hits [src] with [I]!"))
		playsound(src, 'sound/effects/glass/glass_hit.ogg', 70, 1)


/obj/structure/mirror/attack_animal(mob/user)
	if(!issimple(user))
		return
	var/mob/living/simple/M = user
	if(M.melee_damage_upper <= 0 || (M.melee_damage_type != BRUTE && M.melee_damage_type != BURN))
		return
	if(shattered)
		playsound(src, 'sound/effects/glass/hit_on_shattered_glass.ogg', 70, 1)
		return
	user.visible_message(SPAN_DANGER("[user] smashes [src]!"))
	shatter()


/obj/structure/mirror/attack_slime(mob/user)
	if(!isslimeadult(user))
		return
	if(shattered)
		playsound(src, 'sound/effects/glass/hit_on_shattered_glass.ogg', 70, 1)
		return
	user.visible_message(SPAN_DANGER("[user] smashes [src]!"))
	shatter()