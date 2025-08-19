/obj/projectile/hivebotbullet
	damage = 10
	damage_type = BRUTE

/mob/living/simple/hostile/hivebot
	name = "Hivebot"
	desc = "A small robot"
	icon = 'icons/mob/silicon/hivebot.dmi'
	icon_state = "basic"
	icon_living = "basic"
	icon_dead = "basic"
	health = 15
	maxHealth = 15
	melee_damage_lower = 2
	melee_damage_upper = 3
	attacktext = "claws"
	projectilesound = 'sound/weapons/gun/gunshot.ogg'
	projectiletype = /obj/projectile/hivebotbullet
	faction = "hivebot"

	min_oxy = 0
	max_tox = 0
	max_co2 = 0
	minbodytemp = 0
	speed = 4

/mob/living/simple/hostile/hivebot/range
	name = "Hivebot"
	desc = "A smallish robot, this one is armed!"
	ranged = 1

/mob/living/simple/hostile/hivebot/rapid
	ranged = 1
	rapid = 1

/mob/living/simple/hostile/hivebot/strong
	name = "Strong Hivebot"
	desc = "A robot, this one is armed and looks tough!"
	health = 80
	ranged = 1

/mob/living/simple/hostile/hivebot/Die()
	..()
	visible_message("<b>[src]</b> blows apart!")
	new /obj/effect/decal/cleanable/blood/gibs/robot(src.loc)
	make_sparks(3, TRUE, src)
	qdel(src)
	return


/mob/living/simple/hostile/hivebot/tele	//this still needs work
	name = "Beacon"
	desc = "Some odd beacon thing"
	icon = 'icons/mob/silicon/hivebot.dmi'
	icon_state = "def_radar-off"
	icon_living = "def_radar-off"
	health = 200
	maxHealth = 200
	status_flags = 0
	anchored = TRUE
	stop_automated_movement = TRUE

	var/bot_type = "norm"
	var/bot_amt = 10
	var/spawn_delay = 600
	var/turn_on = 0
	var/auto_spawn = 1

/mob/living/simple/hostile/hivebot/tele/New()
	..()
	make_smoke(5, FALSE, loc)
	visible_message("\red <B>The [src] warps in!</B>")
	playsound(src, 'sound/effects/EMPulse.ogg', 25, 1)

/mob/living/simple/hostile/hivebot/tele/Life()
	..()
	if(stat == CONSCIOUS)
		if(prob(2))//Might be a bit low, will mess with it likely
			warpbots()

/mob/living/simple/hostile/hivebot/tele/proc/warpbots()
	icon_state = "def_radar"
	visible_message("\red The [src] turns on!")
	while(bot_amt > 0)
		bot_amt--
		switch(bot_type)
			if("norm")
				new /mob/living/simple/hostile/hivebot(GET_TURF(src))
			if("range")
				new /mob/living/simple/hostile/hivebot/range(GET_TURF(src))
			if("rapid")
				new /mob/living/simple/hostile/hivebot/rapid(GET_TURF(src))
	spawn(100)
		qdel(src)
	return