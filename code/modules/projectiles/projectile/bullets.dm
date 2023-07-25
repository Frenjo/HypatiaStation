/obj/item/projectile/bullet
	name = "bullet"
	icon_state = "bullet"

	sharp = TRUE

	damage = 60
	embed = TRUE

/obj/item/projectile/bullet/on_hit(atom/target, blocked = 0)
	if(..(target, blocked))
		var/mob/living/L = target
		shake_camera(L, 3, 2)

/obj/item/projectile/bullet/weakbullet // "rubber" bullets
	sharp = FALSE

	damage = 10
	stun = 5
	weaken = 5
	embed = FALSE

/obj/item/projectile/bullet/weakbullet/beanbag		//because beanbags are not bullets
	name = "beanbag"

/obj/item/projectile/bullet/weakbullet/rubber
	name = "rubber bullet"

/obj/item/projectile/bullet/midbullet
	damage = 20
	stun = 5
	weaken = 5

/obj/item/projectile/bullet/midbullet2
	damage = 25

/obj/item/projectile/bullet/suffocationbullet//How does this even work?
	name = "co bullet"

	damage = 20
	damage_type = OXY

/obj/item/projectile/bullet/cyanideround
	name = "poison bullet"

	damage = 40
	damage_type = TOX

/obj/item/projectile/bullet/burstbullet//I think this one needs something for the on hit
	name = "exploding bullet"

	damage = 20

/obj/item/projectile/bullet/stunshot
	name = "stunshot"

	sharp = FALSE

	damage = 5
	stun = 10
	weaken = 10
	stutter = 10
	embed = FALSE

/obj/item/projectile/bullet/a762
	damage = 25