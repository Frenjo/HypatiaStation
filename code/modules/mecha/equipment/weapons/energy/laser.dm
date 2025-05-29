// Laser
/obj/item/mecha_equipment/weapon/energy/laser
	name = "\improper CH-PS \"Immolator\" laser"
	icon_state = "laser"
	matter_amounts = /datum/design/mechfab/equipment/weapon/laser::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/laser::req_tech

	equip_cooldown = 0.8 SECONDS
	energy_drain = 30
	projectile = /obj/item/projectile/energy/beam/laser
	fire_sound = 'sound/weapons/gun/laser.ogg'

/obj/item/mecha_equipment/weapon/energy/laser/heavy
	name = "\improper CH-LC \"Solaris\" laser cannon"
	icon_state = "laser_cannon"
	matter_amounts = /datum/design/mechfab/equipment/weapon/heavy_laser::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/heavy_laser::req_tech

	equip_cooldown = 1.5 SECONDS
	energy_drain = 60
	projectile = /obj/item/projectile/energy/beam/laser/heavy
	fire_sound = 'sound/weapons/gun/lasercannonfire.ogg'

/obj/item/mecha_equipment/weapon/energy/laser/rigged
	name = "jury-rigged welder-laser"
	desc = "While not regulation, this inefficient weapon can be attached to working exosuits in desperate, or malicious, times. (Can be attached to: Working and Combat Exosuits)"
	icon_state = "laser_rigged"
	matter_amounts = /datum/design/mechfab/equipment/weapon/rigged_laser::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/rigged_laser::req_tech

	mecha_flags = MECHA_FLAG_WORKING | MECHA_FLAG_COMBAT
	equip_cooldown = 1.6 SECONDS
	energy_drain = 60