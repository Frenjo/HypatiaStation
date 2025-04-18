/obj/item/ammo_casing/a357
	desc = "A .357 bullet casing."

	caliber = "357"
	projectile_type = /obj/item/projectile/bullet

/obj/item/ammo_casing/a50
	desc = "A .50AE bullet casing."

	caliber = ".50"
	projectile_type = /obj/item/projectile/bullet

/obj/item/ammo_casing/a418
	desc = "A .418 bullet casing."

	caliber = "357"
	projectile_type = /obj/item/projectile/bullet/suffocationbullet

/obj/item/ammo_casing/a75
	desc = "A .75 bullet casing."

	caliber = "75"
	projectile_type = /obj/item/projectile/bullet/gyro

/obj/item/ammo_casing/a666
	desc = "A .666 bullet casing."

	caliber = "357"
	projectile_type = /obj/item/projectile/bullet/cyanideround

/obj/item/ammo_casing/c38
	desc = "A .38 bullet casing."

	caliber = "38"
	projectile_type = /obj/item/projectile/bullet/weakbullet

/obj/item/ammo_casing/c9mm
	desc = "A 9mm bullet casing."

	caliber = "9mm"
	projectile_type = /obj/item/projectile/bullet/midbullet2

/obj/item/ammo_casing/c45
	desc = "A .45 bullet casing."

	caliber = ".45"
	projectile_type = /obj/item/projectile/bullet/midbullet

/obj/item/ammo_casing/c45r
	desc = "A .45 rubber bullet casing."

	caliber = ".45"
	projectile_type = /obj/item/projectile/bullet/weakbullet/rubber

/obj/item/ammo_casing/a12mm
	desc = "A 12mm bullet casing."

	caliber = "12mm"
	projectile_type = /obj/item/projectile/bullet/midbullet2

/obj/item/ammo_casing/shotgun
	name = "shotgun shell"
	desc = "A 12 gauge shell."
	icon_state = "gshell"

	matter_amounts = /datum/design/autolathe/shotgun_shell::materials

	caliber = "shotgun"
	projectile_type = /obj/item/projectile/bullet

/obj/item/ammo_casing/shotgun/blank
	name = "shotgun shell"
	desc = "A blank shell."
	icon_state = "blshell"

	matter_amounts = /datum/design/autolathe/blank_shotgun_shell::materials
	projectile_type = null

/obj/item/ammo_casing/shotgun/beanbag
	name = "beanbag shell"
	desc = "A weak beanbag shell."
	icon_state = "bshell"

	matter_amounts = /datum/design/autolathe/beanbag_shell::materials
	projectile_type = /obj/item/projectile/bullet/weakbullet/beanbag

/obj/item/ammo_casing/shotgun/stunshell
	name = "stun shell"
	desc = "A stunning shell."
	icon_state = "stunshell"

	matter_amounts = /datum/design/weapon/stunshell::materials
	origin_tech = /datum/design/weapon/stunshell::req_tech
	projectile_type = /obj/item/projectile/bullet/stunshot

/obj/item/ammo_casing/shotgun/dart
	name = "shotgun darts"
	desc = "A dart for use in shotguns."
	icon_state = "dart"

	matter_amounts = /datum/design/autolathe/shotgun_dart::materials

	projectile_type = /obj/item/projectile/energy/dart

/obj/item/ammo_casing/a762
	desc = "A 7.62 bullet casing."

	caliber = "a762"
	projectile_type = /obj/item/projectile/bullet/a762

/obj/item/ammo_casing/rocket
	name = "rocket shell"
	desc = "A high explosive designed to be fired from a launcher."
	icon_state = "rocketshell"

	caliber = "rocket"
	projectile_type = /obj/item/missile