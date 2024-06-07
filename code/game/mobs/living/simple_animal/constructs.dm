/mob/living/simple_animal/construct
	name = "Construct"
	real_name = "Construct"
	desc = ""
	speak_emote = list("hisses")
	emote_hear = list("wails", "screeches")
	response_help = "thinks better of touching"
	response_disarm = "flails at"
	response_harm = "punches"
	icon_dead = "shade_dead"
	speed = -1
	a_intent = "harm"
	stop_automated_movement = 1
	status_flags = CANPUSH
	universal_speak = 0
	universal_understand = 1
	attack_sound = 'sound/weapons/punch1.ogg'
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	faction = "cult"

	mob_swap_flags = HUMAN|SIMPLE_ANIMAL|SLIME|MONKEY
	mob_push_flags = ALLMOBS

	var/list/construct_spells = list()

/mob/living/simple_animal/construct/New()
	..()
	name = text("[initial(name)] ([rand(1, 1000)])")
	real_name = name
	add_language("Cult")
	add_language("Occult")
	for(var/spell in construct_spells)
		spell_list += new spell(src)
	updateicon()

/mob/living/simple_animal/construct/death()
	new /obj/item/ectoplasm(src.loc)
	..(null, "collapses in a shattered heap.")
	ghostize()
	qdel(src)

/mob/living/simple_animal/construct/examine()
	set src in oview()
	var/msg = "<span cass='info'>*---------*\nThis is \icon[src] \a <EM>[src]</EM>!\n"
	if(health < maxHealth)
		msg += "<span class='warning'>"
		if(health >= maxHealth / 2)
			msg += "It looks slightly dented.\n"
		else
			msg += "<B>It looks severely dented!</B>\n"
		msg += "</span>"
	msg += "*---------*</span>"

	to_chat(usr, msg)

/mob/living/simple_animal/construct/attack_animal(mob/living/M)
	if(istype(M, /mob/living/simple_animal/construct/builder))
		health += 5
		M.emote("mends some of \the <EM>[src]'s</EM> wounds.")
	else
		if(M.melee_damage_upper <= 0)
			M.emote("[M.friendly] \the <EM>[src]</EM>")
		else
			if(M.attack_sound)
				playsound(loc, M.attack_sound, 50, 1, 1)
			for(var/mob/O in viewers(src, null))
				O.show_message(SPAN("attack", "\The <EM>[M]</EM> [M.attacktext] \the <EM>[src]</EM>!"), 1)
			M.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name] ([src.ckey])</font>")
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was attacked by [M.name] ([M.ckey])</font>")

			var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
			adjustBruteLoss(damage)

/mob/living/simple_animal/construct/attackby(obj/item/O, mob/user)
	if(O.force)
		var/damage = O.force
		if(O.damtype == HALLOSS)
			damage = 0
		adjustBruteLoss(damage)
		for(var/mob/M in viewers(src, null))
			if(M.client && !M.blinded)
				M.show_message(SPAN_DANGER("[src] has been attacked with [O] by [user]."))
	else
		to_chat(usr, SPAN_WARNING("This weapon is ineffective, it does no damage."))
		for(var/mob/M in viewers(src, null))
			if(M.client && !M.blinded)
				M.show_message(SPAN_WARNING("[user] gently taps [src] with [O]."))


/////////////////Juggernaut///////////////
/mob/living/simple_animal/construct/armoured
	name = "Juggernaut"
	real_name = "Juggernaut"
	desc = "A possessed suit of armour driven by the will of the restless dead"
	icon = 'icons/mob/mob.dmi'
	icon_state = "behemoth"
	icon_living = "behemoth"
	maxHealth = 250
	health = 250
	response_harm = "harmlessly punches"
	harm_intent_damage = 0
	melee_damage_lower = 30
	melee_damage_upper = 30
	attacktext = "smashes their armoured gauntlet into"
	speed = 3
	wall_smash = 1
	attack_sound = 'sound/weapons/punch3.ogg'
	status_flags = 0
	construct_spells = list(/obj/effect/proc_holder/spell/aoe_turf/conjure/lesserforcewall)

/mob/living/simple_animal/construct/armoured/Life()
	weakened = 0
	..()

/mob/living/simple_animal/construct/armoured/bullet_act(obj/item/projectile/P)
	if(istype(P, /obj/item/projectile/energy))
		var/reflectchance = 80 - round(P.damage / 3)
		if(prob(reflectchance))
			adjustBruteLoss(P.damage * 0.5)
			visible_message(
				SPAN_DANGER("The [P.name] gets reflected by [src]'s shell!"),
				SPAN("userdanger", "The [P.name] gets reflected by [src]'s shell!")
			)

			// Find a turf near or on the original location to bounce to
			if(P.starting)
				var/new_x = P.starting.x + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
				var/new_y = P.starting.y + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
				var/turf/curloc = get_turf(src)

				// redirect the projectile
				P.original = locate(new_x, new_y, P.z)
				P.starting = curloc
				P.current = curloc
				P.firer = src
				P.yo = new_y - curloc.y
				P.xo = new_x - curloc.x

			return -1 // complete projectile permutation

	return (..(P))


////////////////////////Wraith/////////////////////////////////////////////
/mob/living/simple_animal/construct/wraith
	name = "Wraith"
	real_name = "Wraith"
	desc = "A wicked bladed shell contraption piloted by a bound spirit"
	icon = 'icons/mob/mob.dmi'
	icon_state = "floating"
	icon_living = "floating"
	maxHealth = 75
	health = 75
	melee_damage_lower = 25
	melee_damage_upper = 25
	attacktext = "slashes"
	speed = -1
	see_in_dark = 7
	attack_sound = 'sound/weapons/bladeslice.ogg'
	construct_spells = list(/obj/effect/proc_holder/spell/targeted/ethereal_jaunt/shift)


/////////////////////////////Artificer/////////////////////////
/mob/living/simple_animal/construct/builder
	name = "Artificer"
	real_name = "Artificer"
	desc = "A bulbous construct dedicated to building and maintaining The Cult of Nar-Sie's armies"
	icon = 'icons/mob/mob.dmi'
	icon_state = "artificer"
	icon_living = "artificer"
	maxHealth = 50
	health = 50
	response_harm = "viciously beats"
	harm_intent_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 5
	attacktext = "rams"
	speed = 0
	wall_smash = 1
	attack_sound = 'sound/weapons/punch2.ogg'
	construct_spells = list(
		/obj/effect/proc_holder/spell/aoe_turf/conjure/construct/lesser,
		/obj/effect/proc_holder/spell/aoe_turf/conjure/wall,
		/obj/effect/proc_holder/spell/aoe_turf/conjure/floor,
		/obj/effect/proc_holder/spell/aoe_turf/conjure/soulstone
	)


/////////////////////////////Behemoth/////////////////////////
/mob/living/simple_animal/construct/behemoth
	name = "Behemoth"
	real_name = "Behemoth"
	desc = "The pinnacle of occult technology, Behemoths are the ultimate weapon in the Cult of Nar-Sie's arsenal."
	icon = 'icons/mob/mob.dmi'
	icon_state = "behemoth"
	icon_living = "behemoth"
	maxHealth = 750
	health = 750
	speak_emote = list("rumbles")
	response_harm   = "harmlessly punches"
	harm_intent_damage = 0
	melee_damage_lower = 50
	melee_damage_upper = 50
	attacktext = "brutally crushes"
	speed = 5
	wall_smash = 1
	attack_sound = 'sound/weapons/punch4.ogg'
	var/energy = 0
	var/max_energy = 1000

/mob/living/simple_animal/construct/behemoth/attackby(obj/item/O, mob/user)
	if(O.force)
		if(O.force >= 11)
			var/damage = O.force
			if(O.damtype == HALLOSS)
				damage = 0
			adjustBruteLoss(damage)
			for(var/mob/M in viewers(src, null))
				if(M.client && !M.blinded)
					M.show_message(SPAN_DANGER("[src] has been attacked with [O] by [user]."))
		else
			for(var/mob/M in viewers(src, null))
				if(M.client && !M.blinded)
					M.show_message(SPAN_DANGER("[O] bounces harmlessly off of [src]."))
	else
		to_chat(usr, SPAN_WARNING("This weapon is ineffective, it does no damage."))
		for(var/mob/M in viewers(src, null))
			if(M.client && !M.blinded)
				M.show_message(SPAN_DANGER("[user] gently taps [src] with [O]."))


////////////////Powers//////////////////
/*
/client/proc/summon_cultist()
	set category = "Behemoth"
	set name = "Summon Cultist (300)"
	set desc = "Teleport a cultist to your location"
	if (istype(usr,/mob/living/simple_animal/constructbehemoth))

		if(usr.energy<300)
			usr << "\red You do not have enough power stored!"
			return

		if(usr.stat)
			return

		usr.energy -= 300
	var/list/mob/living/cultists = new
	for_no_type_check(var/datum/mind/H, ticker.mode.cult)
		if(isliving(H.current))
			cultists+=H.current
			var/mob/cultist = input("Choose the one who you want to summon", "Followers of Geometer") as null|anything in (cultists - usr)
			if(!cultist)
				return
			if (cultist == usr) //just to be sure.
				return
			cultist.loc = usr.loc
			usr.visible_message("/red [cultist] appears in a flash of red light as [usr] glows with power")*/


////////////////////////Harvester////////////////////////////////
/mob/living/simple_animal/construct/harvester
	name = "Harvester"
	real_name = "Harvester"
	desc = "The promised reward of the livings who follow narsie. Obtained by offering their bodies to the geometer of blood"
	icon = 'icons/mob/mob.dmi'
	icon_state = "harvester"
	icon_living = "harvester"
	maxHealth = 150
	health = 150
	melee_damage_lower = 25
	melee_damage_upper = 25
	attacktext = "violently stabs"
	speed = -1
	wall_smash = 1
	see_in_dark = 7
	attack_sound = 'sound/weapons/pierce.ogg'

	construct_spells = list(
			//spell/targeted/harvest,
			//spell/aoe_turf/knock/harvester,
			//spell/rune_write
		)