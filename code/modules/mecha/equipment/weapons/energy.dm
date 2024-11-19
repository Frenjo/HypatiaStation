/obj/item/mecha_part/equipment/weapon/energy
	name = "general energy weapon"
	auto_rearm = 1

/obj/item/mecha_part/equipment/weapon/energy/laser
	equip_cooldown = 8
	name = "\improper CH-PS \"Immolator\" laser"
	icon_state = "mecha_laser"
	energy_drain = 30
	projectile = /obj/item/projectile/energy/beam/laser
	fire_sound = 'sound/weapons/Laser.ogg'

/obj/item/mecha_part/equipment/weapon/energy/laser/heavy
	equip_cooldown = 15
	name = "\improper CH-LC \"Solaris\" laser cannon"
	icon_state = "mecha_laser"
	energy_drain = 60
	projectile = /obj/item/projectile/energy/beam/laser/heavy
	fire_sound = 'sound/weapons/lasercannonfire.ogg'

/obj/item/mecha_part/equipment/weapon/energy/ion
	equip_cooldown = 40
	name = "mkIV ion heavy cannon"
	icon_state = "mecha_ion"
	energy_drain = 120
	projectile = /obj/item/projectile/ion
	fire_sound = 'sound/weapons/Laser.ogg'

/obj/item/mecha_part/equipment/weapon/energy/pulse
	equip_cooldown = 30
	name = "eZ-13 mk2 heavy pulse rifle"
	icon_state = "mecha_pulse"
	energy_drain = 120
	origin_tech = list(/datum/tech/materials = 3, /datum/tech/combat = 6, /datum/tech/power_storage = 4)
	projectile = /obj/item/projectile/energy/beam/pulse/heavy
	fire_sound = 'sound/weapons/marauder.ogg'

/obj/item/projectile/energy/beam/pulse/heavy
	name = "heavy pulse laser"
	icon_state = "pulse1_bl"

	var/life = 20

/obj/item/projectile/energy/beam/pulse/heavy/Bump(atom/A)
	A.bullet_act(src, def_zone)
	life -= 10
	if(life <= 0)
		qdel(src)

/obj/item/mecha_part/equipment/weapon/energy/taser
	name = "PBT \"Pacifier\" mounted taser"
	icon_state = "mecha_taser"
	energy_drain = 20
	equip_cooldown = 8
	projectile = /obj/item/projectile/energy/electrode
	fire_sound = 'sound/weapons/Taser.ogg'