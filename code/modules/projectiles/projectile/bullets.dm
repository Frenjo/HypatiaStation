/obj/projectile/bullet
	name = "bullet"
	icon_state = "bullet"

	sharp = TRUE

	damage = 60
	embed = TRUE

	muzzle_type = /obj/effect/projectile/bullet/muzzle

/obj/projectile/bullet/on_hit(atom/target, blocked = 0)
	if(..(target, blocked))
		var/mob/living/L = target
		shake_camera(L, 3, 2)

/obj/projectile/bullet/weak // "rubber" bullets
	sharp = FALSE

	damage = 10
	stun = 5
	weaken = 5
	embed = FALSE

/obj/projectile/bullet/weak/beanbag		//because beanbags are not bullets
	name = "beanbag"

/obj/projectile/bullet/weak/rubber
	name = "rubber bullet"

/obj/projectile/bullet/mid
	damage = 20
	stun = 5
	weaken = 5

/obj/projectile/bullet/mid2
	damage = 25

/obj/projectile/bullet/suffocation //How does this even work?
	name = "co bullet"

	damage = 20
	damage_type = OXY

/obj/projectile/bullet/cyanide
	name = "poison bullet"

	damage = 40
	damage_type = TOX

/obj/projectile/bullet/burst //I think this one needs something for the on hit
	name = "exploding bullet"

	damage = 20

/obj/projectile/bullet/stunshot
	name = "stunshot"

	sharp = FALSE

	damage = 5
	stun = 10
	weaken = 10
	stutter = 10
	embed = FALSE

/obj/projectile/bullet/a762
	damage = 25

// Quietus
/obj/projectile/bullet/mime
	damage = 20

/obj/projectile/bullet/mime/on_hit(atom/target, blocked = 0)
	if(..(target, blocked) && isliving(target))
		var/mob/living/alive = target
		alive.silent = max(alive.silent, 10)