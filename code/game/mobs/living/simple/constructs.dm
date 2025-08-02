/mob/living/simple/construct
	name = "Construct"
	icon = 'icons/mob/simple/construct.dmi'

	speak_emote = list("hisses")
	emote_hear = list("wails", "screeches")
	response_help = "thinks better of touching"
	response_disarm = "flails at"
	response_harm = "punches"
	icon_dead = "shade_dead"
	speed = -1
	a_intent = "harm"
	stop_automated_movement = TRUE
	status_flags = CANPUSH
	universal_speak = 0
	universal_understand = TRUE
	attack_sound = 'sound/weapons/melee/punch1.ogg'

	min_oxy = 0
	max_tox = 0
	max_co2 = 0
	minbodytemp = 0
	faction = "cult"

	mob_swap_flags = HUMAN|SIMPLE_ANIMAL|SLIME|MONKEY
	mob_push_flags = ALLMOBS

	var/list/construct_spells = list()

/mob/living/simple/construct/New()
	. = ..()
	name = "[initial(name)] ([rand(1, 1000)])"
	real_name = name
	add_language("Cult")
	add_language("Occult")
	for(var/spell in construct_spells)
		spell_list.Add(new spell(src))
	updateicon()

/mob/living/simple/construct/death()
	new /obj/item/ectoplasm(loc)
	..(null, "collapses in a shattered heap.")
	ghostize()
	qdel(src)

/mob/living/simple/construct/get_examine_text()
	. = ..()
	if(health < maxHealth)
		if(health >= maxHealth / 2)
			. += SPAN_WARNING("It looks slightly dented.")
		else
			. += SPAN_DANGER("It looks severely dented.")
	. += SPAN_INFO_B("*---------*")

/mob/living/simple/construct/attack_animal(mob/living/M)
	if(istype(M, /mob/living/simple/construct/builder))
		health += 5
		M.emote("mends some of \the <EM>[src]'s</EM> wounds.")
	else
		if(M.melee_damage_upper <= 0)
			M.emote("[M.friendly] \the <EM>[src]</EM>")
		else
			if(M.attack_sound)
				playsound(loc, M.attack_sound, 50, 1, 1)
			visible_message(SPAN("attack", "\The <EM>[M]</EM> [M.attacktext] \the <EM>[src]</EM>!"))
			M.attack_log += "\[[time_stamp()]\] <font color='red'>attacked [src.name] ([src.ckey])</font>"
			attack_log += "\[[time_stamp()]\] <font color='orange'>was attacked by [M.name] ([M.ckey])</font>"

			var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
			switch(M.melee_damage_type)
				if(BRUTE)
					adjustBruteLoss(damage)
				if(BURN)
					adjustFireLoss(damage)
				if(TOX)
					adjustToxLoss(damage)
				if(OXY)
					adjustOxyLoss(damage)
				if(CLONE)
					adjustCloneLoss(damage)
				if(HALLOSS)
					adjustHalLoss(damage)

/mob/living/simple/construct/attackby(obj/item/O, mob/user)
	if(O.force)
		var/damage = O.force
		if(O.damtype == HALLOSS)
			damage = 0
		adjustBruteLoss(damage)
		visible_message(SPAN_DANGER("[src] has been attacked with \the [O] by [user]."))
	else
		to_chat(usr, SPAN_WARNING("This weapon is ineffective, it does no damage."))
		visible_message(SPAN_WARNING("[user] gently taps [src] with \the [O]."))


/////////////////Juggernaut///////////////
/mob/living/simple/construct/armoured
	name = "Juggernaut"
	desc = "A possessed suit of armour driven by the will of the restless dead."

	icon_state = "armour"
	icon_living = "armour"

	maxHealth = 250
	health = 250
	response_harm = "harmlessly punches"
	harm_intent_damage = 0
	melee_damage_lower = 30
	melee_damage_upper = 30
	attacktext = "smashes their armoured gauntlet into"
	speed = 3
	wall_smash = 1
	attack_sound = 'sound/weapons/melee/punch3.ogg'
	status_flags = 0
	construct_spells = list(/obj/effect/proc_holder/spell/aoe_turf/conjure/lesserforcewall)

/mob/living/simple/construct/armoured/Life()
	weakened = 0
	..()

/mob/living/simple/construct/armoured/bullet_act(obj/item/projectile/P)
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
				var/turf/curloc = GET_TURF(src)

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
/mob/living/simple/construct/wraith
	name = "Wraith"
	desc = "A wicked bladed shell contraption piloted by a bound spirit."

	icon_state = "floating"
	icon_living = "floating"

	maxHealth = 75
	health = 75
	melee_damage_lower = 25
	melee_damage_upper = 25
	attacktext = "slashes"
	speed = -1
	see_in_dark = 7
	attack_sound = 'sound/weapons/melee/bladeslice.ogg'
	construct_spells = list(/obj/effect/proc_holder/spell/targeted/ethereal_jaunt/shift)


/////////////////////////////Artificer/////////////////////////
/mob/living/simple/construct/builder
	name = "Artificer"
	desc = "A bulbous construct dedicated to building and maintaining The Cult of Nar-Sie's armies."

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
	attack_sound = 'sound/weapons/melee/punch2.ogg'
	construct_spells = list(
		/obj/effect/proc_holder/spell/aoe_turf/conjure/construct/lesser,
		/obj/effect/proc_holder/spell/aoe_turf/conjure/wall,
		/obj/effect/proc_holder/spell/aoe_turf/conjure/floor,
		/obj/effect/proc_holder/spell/aoe_turf/conjure/soulstone
	)


/////////////////////////////Behemoth/////////////////////////
/mob/living/simple/construct/behemoth
	name = "Behemoth"
	desc = "The pinnacle of occult technology, Behemoths are the ultimate weapon in the Cult of Nar-Sie's arsenal."

	icon_state = "behemoth"
	icon_living = "behemoth"

	maxHealth = 750
	health = 750
	speak_emote = list("rumbles")
	response_harm = "harmlessly punches"
	harm_intent_damage = 0
	melee_damage_lower = 50
	melee_damage_upper = 50
	attacktext = "brutally crushes"
	speed = 5
	wall_smash = 1
	attack_sound = 'sound/weapons/melee/punch4.ogg'
	var/energy = 0
	var/max_energy = 1000

/mob/living/simple/construct/behemoth/attackby(obj/item/O, mob/user)
	if(O.force)
		if(O.force >= 11)
			var/damage = O.force
			if(O.damtype == HALLOSS)
				damage = 0
			adjustBruteLoss(damage)
			visible_message(SPAN_DANGER("[src] has been attacked with \the [O] by [user]."))
		else
			visible_message(SPAN_DANGER("\The [O] bounces harmlessly off of [src]."))
	else
		to_chat(usr, SPAN_WARNING("This weapon is ineffective, it does no damage."))
		visible_message(SPAN_WARNING("[user] gently taps [src] with \the [O]."))


////////////////Powers//////////////////
/*
/client/proc/summon_cultist()
	set category = "Behemoth"
	set name = "Summon Cultist (300)"
	set desc = "Teleport a cultist to your location"
	if (istype(usr,/mob/living/simple/constructbehemoth))

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
			cultist.forceMove(usr.loc)
			usr.visible_message("/red [cultist] appears in a flash of red light as [usr] glows with power")*/


////////////////////////Harvester////////////////////////////////
/mob/living/simple/construct/harvester
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
	attack_sound = 'sound/weapons/melee/pierce.ogg'

	construct_spells = list(
			//spell/targeted/harvest,
			//spell/aoe_turf/knock/harvester,
			//spell/rune_write
		)