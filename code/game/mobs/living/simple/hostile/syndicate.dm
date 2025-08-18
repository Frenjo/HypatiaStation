/mob/living/simple/hostile/syndicate
	name = "Syndicate Operative"
	desc = "Death to NanoTrasen."
	icon_state = "syndicate"
	icon_living = "syndicate"
	icon_dead = "syndicate_dead"
	icon_gib = "syndicate_gib"
	speak_chance = 0
	turns_per_move = 5
	response_help = "pokes the"
	response_disarm = "shoves the"
	response_harm = "hits the"
	speed = 4
	stop_automated_movement_when_pulled = FALSE
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 10
	attacktext = "punches"
	a_intent = "harm"

	unsuitable_atoms_damage = 15
	wall_smash = 1
	faction = "syndicate"
	status_flags = CANPUSH

	var/corpse = /obj/effect/landmark/mobcorpse/syndicatesoldier
	var/weapon1
	var/weapon2

/mob/living/simple/hostile/syndicate/death()
	..()
	if(corpse)
		new corpse (src.loc)
	if(weapon1)
		new weapon1 (src.loc)
	if(weapon2)
		new weapon2 (src.loc)
	qdel(src)
	return

///////////////Sword and shield////////////

/mob/living/simple/hostile/syndicate/melee
	melee_damage_lower = 20
	melee_damage_upper = 25
	icon_state = "syndicatemelee"
	icon_living = "syndicatemelee"
	weapon1 = /obj/item/melee/energy/sword/red
	weapon2 = /obj/item/shield/energy
	attacktext = "slashes"
	status_flags = 0

/mob/living/simple/hostile/syndicate/melee/attackby(obj/item/O, mob/user)
	if(O.force)
		if(prob(80))
			var/damage = O.force
			if(O.damtype == HALLOSS)
				damage = 0
			health -= damage
			visible_message(SPAN_DANGER("[src] has been attacked with \the [O] by [user]."))
		else
			visible_message(SPAN_DANGER("[src] blocks \the [O] with its shield!"))
	else
		to_chat(user, SPAN_WARNING("This weapon is ineffective, it does no damage."))
		visible_message(SPAN_WARNING("[user] gently taps [src] with \the [O]."))


/mob/living/simple/hostile/syndicate/melee/bullet_act(obj/item/projectile/bullet)
	if(isnull(bullet))
		return
	if(prob(65))
		if(bullet.damage_type == BRUTE || bullet.damage_type == BURN)
			health -= bullet.damage
	else
		visible_message(SPAN_DANGER("[src] blocks [bullet] with its shield!"))
	return 0


/mob/living/simple/hostile/syndicate/melee/space
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	icon_state = "syndicatemeleespace"
	icon_living = "syndicatemeleespace"
	name = "Syndicate Commando"
	corpse = /obj/effect/landmark/mobcorpse/syndicatecommando
	speed = 0

/mob/living/simple/hostile/syndicate/melee/space/Process_Spacemove(var/check_drift = 0)
	return

/mob/living/simple/hostile/syndicate/ranged
	ranged = 1
	rapid = 1
	icon_state = "syndicateranged"
	icon_living = "syndicateranged"
	casingtype = /obj/item/ammo_casing/a12mm
	projectilesound = 'sound/weapons/gun/gunshot_smg.ogg'
	projectiletype = /obj/item/projectile/bullet/mid2

	weapon1 = /obj/item/gun/projectile/automatic/c20r

/mob/living/simple/hostile/syndicate/ranged/space
	icon_state = "syndicaterangedpsace"
	icon_living = "syndicaterangedpsace"
	name = "Syndicate Commando"
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	corpse = /obj/effect/landmark/mobcorpse/syndicatecommando
	speed = 0

/mob/living/simple/hostile/syndicate/ranged/space/Process_Spacemove(var/check_drift = 0)
	return



/mob/living/simple/hostile/viscerator
	name = "viscerator"
	desc = "A small, twin-bladed machine capable of inflicting very deadly lacerations."
	icon = 'icons/mob/simple/critter.dmi'
	icon_state = "viscerator_attack"
	icon_living = "viscerator_attack"
	pass_flags = PASS_FLAG_TABLE
	health = 15
	maxHealth = 15
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "cuts"
	attack_sound = 'sound/weapons/melee/bladeslice.ogg'
	faction = "syndicate"
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

/mob/living/simple/hostile/viscerator/death()
	..(null, "is smashed into pieces!")
	qdel(src)