//There has to be a better way to define this shit. ~ Z
//can't equip anything
/mob/living/carbon/alien/attack_ui(slot_id)
	return

/mob/living/carbon/alien/meteorhit(obj/O)
	visible_message(SPAN_DANGER("[src] has been hit by [O]!"))
	if (health > 0)
		adjustBruteLoss((istype(O, /obj/effect/meteor/small) ? 10 : 25))
		adjustFireLoss(30)

		updatehealth()
	return

/mob/living/carbon/alien/attack_animal(mob/living/M)
	if(isanimal(M))
		var/mob/living/simple/S = M
		if(S.melee_damage_upper == 0)
			S.emote("[S.friendly] [src]")
		else
			visible_message(SPAN_WARNING("<B>[S]</B> [S.attacktext] [src]!"))
			var/damage = rand(S.melee_damage_lower, S.melee_damage_upper)
			adjustBruteLoss(damage)
			S.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name] ([src.ckey])</font>")
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was attacked by [S.name] ([S.ckey])</font>")
			updatehealth()

/mob/living/carbon/alien/attack_paw(mob/living/carbon/monkey/M)
	if(!ismonkey(M))	return//Fix for aliens receiving double messages when attacking other aliens.

	if(!global.PCticker)
		M << "You cannot attack people before the game has started."
		return
	..()

	switch(M.a_intent)
		if ("help")
			help_shake_act(M)
		else
			if (istype(wear_mask, /obj/item/clothing/mask/muzzle))
				return
			if (health > 0)
				playsound(loc, 'sound/weapons/bite.ogg', 50, 1, -1)
				visible_message(SPAN_DANGER("[M.name] has bitten [src]!"))
				adjustBruteLoss(rand(1, 3))
				updatehealth()
	return


/mob/living/carbon/alien/attack_slime(mob/living/carbon/slime/M)
	if(!global.PCticker)
		M << "You cannot attack people before the game has started."
		return

	if(M.Victim) return // can't attack while eating!

	if (health > -100)

		visible_message(SPAN_DANGER("The [M.name] glomps [src]!"))

		var/damage = rand(1, 3)

		if(isslimeadult(M))
			damage = rand(20, 40)
		else
			damage = rand(5, 35)

		adjustBruteLoss(damage)


		updatehealth()

	return

/mob/living/carbon/alien/attack_hand(mob/living/carbon/human/M)
	if(!global.PCticker)
		M << "You cannot attack people before the game has started."
		return

	..()

	if(M.gloves && istype(M.gloves,/obj/item/clothing/gloves))
		var/obj/item/clothing/gloves/G = M.gloves
		if(G.cell)
			if(M.a_intent == "hurt")//Stungloves. Any contact will stun the alien.
				if(G.cell.charge >= 2500)
					G.cell.use(2500)

					Weaken(5)
					if (stuttering < 5)
						stuttering = 5
					Stun(5)

					visible_message(
						SPAN_DANGER("[src] has been touched with the stun gloves by [M]!"),
						SPAN_WARNING("You hear someone fall.")
					)
					return
				else
					M << "\red Not enough charge! "
					return

	switch(M.a_intent)
		if ("help")
			if (health > 0)
				help_shake_act(M)
			else
				if (M.health >= -75.0)
					if(M.is_mouth_covered())
						M << "\blue <B>Remove that mask!</B>"
						return
					var/obj/effect/equip_e/human/O = new /obj/effect/equip_e/human(  )
					O.source = M
					O.target = src
					O.s_loc = M.loc
					O.t_loc = loc
					O.place = "CPR"
					requests += O
					spawn( 0 )
						O.process()
						return

		if ("grab")
			if (M == src)
				return
			var/obj/item/grab/G = new /obj/item/grab( M, M, src )

			M.put_in_active_hand(G)

			grabbed_by += G
			G.synch()

			LAssailant = M

			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			visible_message(SPAN_WARNING("[M] has grabbed [src] passively!"))

		else
			var/damage = rand(1, 9)
			if (prob(90))
				if (HULK in M.mutations)
					damage += 5
					spawn(0)
						Paralyse(1)
						step_away(src,M,15)
						sleep(3)
						step_away(src,M,15)
				playsound(loc, "punch", 25, 1, -1)
				visible_message(SPAN_DANGER("[M] has punched [src]!"))
				if (damage > 4.9)
					Weaken(rand(10,15))
					visible_message(
						SPAN_DANGER("[M] has weakened [src]!"),
						SPAN_WARNING("You hear someone fall.")
					)
				adjustBruteLoss(damage)
				updatehealth()
			else
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				visible_message(SPAN_DANGER("[M] has attempted to punch [src]!"))
	return