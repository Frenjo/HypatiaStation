/obj/item/mecha_part/equipment/weapon/energy
	name = "general energy weapon"
	auto_rearm = 1

// Taser
/obj/item/mecha_part/equipment/weapon/energy/taser
	name = "PBT \"Pacifier\" mounted taser"
	icon_state = "taser"
	equip_cooldown = 0.8 SECONDS
	energy_drain = 20
	projectile = /obj/item/projectile/energy/electrode
	fire_sound = 'sound/weapons/Taser.ogg'

// Disabler
/obj/item/mecha_part/equipment/weapon/energy/disabler
	name = "\improper CH-DS \"Peacemaker\" disabler"
	desc = "A weapon for combat exosuits. Shoots basic disablers."
	icon_state = "disabler"

	equip_cooldown = 0.8 SECONDS
	energy_drain = 30

	projectile = /obj/item/projectile/energy/pulse/disabler
	fire_sound = 'sound/weapons/taser2.ogg'

/obj/item/mecha_part/equipment/weapon/energy/rapid_disabler
	name = "\improper SW-RM \"Peaceforcer\" rapid disabler"
	desc = "A weapon for combat exosuits of unknown origin. Uses foreign technology to streamline energy compression in order to shoot a stream of disabler shots in quick succession."
	icon_state = "rapid_disabler"

	equip_cooldown = 3 SECONDS
	energy_drain = 50

	projectile = /obj/item/projectile/energy/pulse/disabler
	projectiles_per_shot = 3
	deviation = 0.7
	fire_cooldown = 2
	fire_sound = 'sound/weapons/taser2.ogg'

// Laser
/obj/item/mecha_part/equipment/weapon/energy/laser
	name = "\improper CH-PS \"Immolator\" laser"
	icon_state = "laser"
	matter_amounts = /datum/design/mechfab/equipment/weapon/laser::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/laser::req_tech
	equip_cooldown = 0.8 SECONDS
	energy_drain = 30
	projectile = /obj/item/projectile/energy/beam/laser
	fire_sound = 'sound/weapons/Laser.ogg'

/obj/item/mecha_part/equipment/weapon/energy/laser/heavy
	name = "\improper CH-LC \"Solaris\" laser cannon"
	icon_state = "laser_cannon"
	matter_amounts = /datum/design/mechfab/equipment/weapon/heavy_laser::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/heavy_laser::req_tech
	equip_cooldown = 1.5 SECONDS
	energy_drain = 60
	projectile = /obj/item/projectile/energy/beam/laser/heavy
	fire_sound = 'sound/weapons/lasercannonfire.ogg'

// Ion
/obj/item/mecha_part/equipment/weapon/energy/ion
	name = "mkIV ion heavy cannon"
	icon_state = "ion"
	equip_cooldown = 4 SECONDS
	energy_drain = 120
	projectile = /obj/item/projectile/ion
	fire_sound = 'sound/weapons/Laser.ogg'

// Pulse
/obj/item/mecha_part/equipment/weapon/energy/pulse
	name = "eZ-13 mk2 heavy pulse rifle"
	icon_state = "pulse"
	equip_cooldown = 3 SECONDS
	energy_drain = 120
	origin_tech = alist(/decl/tech/materials = 3, /decl/tech/combat = 6, /decl/tech/power_storage = 4)
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