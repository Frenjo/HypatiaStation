// Laser
/obj/item/mecha_equipment/weapon/energy/laser
	name = "\improper CH-PS \"Immolator\" laser"
	icon_state = "laser"
	matter_amounts = /datum/design/mechfab/equipment/weapon/laser::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/laser::req_tech

	equip_cooldown = 0.8 SECONDS
	energy_drain = 30

	projectile = /obj/item/projectile/energy/pulse/laser
	fire_sound = 'sound/weapons/gun/laser.ogg'

/obj/item/mecha_equipment/weapon/energy/laser/heavy
	name = "\improper CH-LC \"Solaris\" laser cannon"
	icon_state = "laser_cannon"
	matter_amounts = /datum/design/mechfab/equipment/weapon/heavy_laser::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/heavy_laser::req_tech

	equip_cooldown = 1.5 SECONDS
	energy_drain = 60

	projectile = /obj/item/projectile/energy/pulse/laser/heavy
	fire_sound = 'sound/weapons/gun/lasercannonfire.ogg'

/obj/item/mecha_equipment/weapon/energy/laser/rigged
	name = "jury-rigged welder-laser"
	desc = "While not regulation, this inefficient weapon can be attached to working exosuits in desperate, or malicious, times. \
		(Can be attached to: Working and Combat Exosuits)"
	icon_state = "laser_rigged"
	matter_amounts = /datum/design/mechfab/equipment/weapon/rigged_laser::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/rigged_laser::req_tech

	mecha_types = MECHA_TYPE_WORKING | MECHA_TYPE_COMBAT

	equip_cooldown = 1.6 SECONDS
	energy_drain = 60

// X-ray
/obj/item/mecha_equipment/weapon/energy/laser/xray
	name = "\improper CH-XS \"Penetrator\" X-ray laser"
	desc = "A large exosuit-mounted variant of the anti-armor xray rifle. \
		(Can be attached to: Combat Exosuits)"
	icon_state = "xray"
	matter_amounts = /datum/design/mechfab/equipment/weapon/xray::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/xray::req_tech

	equip_cooldown = 0.6 SECONDS
	energy_drain = 150

	projectile = /obj/item/projectile/energy/pulse/laser/xray
	fire_sound = 'sound/weapons/gun/laser3.ogg'

/obj/item/mecha_equipment/weapon/energy/laser/xray/rigged
	name = "jury-rigged X-ray laser"
	desc = "A modified wormhole modulation array and meson-scanning control system allow this abomination to produce concentrated blasts of xrays. \
		(Can be attached to: Working and Combat Exosuits)"
	icon_state = "xray_rigged"
	matter_amounts = /datum/design/mechfab/equipment/weapon/rigged_xray::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/rigged_xray::req_tech

	mecha_types = MECHA_TYPE_WORKING | MECHA_TYPE_COMBAT

	equip_cooldown = 1.2 SECONDS
	energy_drain = 175