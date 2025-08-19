/obj/projectile/ion
	name = "ion bolt"
	icon_state = "ion"

	damage = 0
	damage_type = BURN
	nodamage = TRUE
	flag = "energy"

/obj/projectile/ion/on_hit(atom/target, blocked = 0)
	empulse(target, 1, 1)
	return 1

/obj/projectile/ion/pistol/on_hit(atom/target, blocked = 0)
	empulse(target, 0, 0, 0)
	return 1

/obj/projectile/bullet/gyro
	name = "explosive bolt"
	icon_state = "bolter"

	damage = 50
	edge = TRUE

/obj/projectile/bullet/gyro/on_hit(atom/target, blocked = 0)
	explosion(target, -1, 0, 2)
	return 1

/obj/projectile/temp
	name = "freeze beam"
	icon_state = "ice_2"

	damage = 0
	damage_type = BURN
	nodamage = TRUE
	flag = "energy"

	var/temperature = 300

/obj/projectile/temp/on_hit(atom/target, blocked = 0)//These two could likely check temp protection on the mob
	if(ismob(target))
		var/mob/M = target
		M.bodytemperature = temperature
	return 1

/obj/projectile/meteor
	name = "meteor"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "smallf"

	damage = 0
	nodamage = TRUE

/obj/projectile/meteor/Bump(atom/A)
	if(A == firer)
		loc = A.loc
		return

	sleep(-1) // Might not be important enough for a sleep(-1) but the sleep/spawn itself is necessary thanks to explosions and metoerhits

	if(isnotnull(src)) // Do not add to this if() statement, otherwise the meteor won't delete them
		if(isnotnull(A))
			A.meteorhit(src)
			playsound(src, 'sound/effects/meteorimpact.ogg', 40, 1)

			for(var/mob/M in range(10, src))
				if(!M.stat && !isAI(M))
					shake_camera(M, 3, 1)
			qdel(src)
			return 1
	else
		return 0