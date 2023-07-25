/obj/item/projectile/energy
	name = "energy"
	icon_state = "spark"

	damage = 0
	damage_type = BURN
	flag = "energy"

/obj/item/projectile/energy/electrode
	name = "electrode"
	icon_state = "spark"

	damage_type = HALLOSS
	nodamage = TRUE
	stun = 5
	weaken = 5
	stutter = 5
	agony = 40
	//Damage will be handled on the MOB side, to prevent window shattering.

/obj/item/projectile/energy/electrode/on_hit(atom/target, blocked = 0)
	if(!ismob(target) || blocked >= 2) //Fully blocked by mob or collided with dense object - burst into sparks!
		var/datum/effect/system/spark_spread/sparks = new /datum/effect/system/spark_spread
		sparks.set_up(1, 1, src)
		sparks.start()
	. = ..()

/obj/item/projectile/energy/declone
	name = "declone"
	icon_state = "declone"

	damage_type = CLONE
	nodamage = TRUE
	irradiate = 40

/obj/item/projectile/energy/dart
	name = "dart"
	icon_state = "toxin"

	damage = 5
	damage_type = TOX
	weaken = 5

/obj/item/projectile/energy/bolt
	name = "bolt"
	icon_state = "cbbolt"

	damage = 10
	damage_type = TOX
	agony = 40
	stutter = 10

/obj/item/projectile/energy/bolt/large
	name = "largebolt"
	damage = 20

/obj/item/projectile/energy/neurotoxin
	name = "neuro"
	icon_state = "neurotoxin"

	damage = 5
	damage_type = TOX
	weaken = 5

/obj/item/projectile/energy/plasma
	name = "plasma bolt"
	icon_state = "energy"

	damage = 20
	damage_type = TOX
	irradiate = 20