// Ion
/obj/item/mecha_equipment/weapon/energy/ion
	name = "mkIV ion heavy cannon"
	icon_state = "ion"
	matter_amounts = /datum/design/mechfab/equipment/weapon/ion::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/ion::req_tech

	equip_cooldown = 4 SECONDS
	energy_drain = 120

	projectile = /obj/projectile/ion
	fire_sound = 'sound/weapons/gun/laser.ogg'

/obj/item/mecha_equipment/weapon/energy/ion/rigged
	name = "jury-rigged ion cannon"
	desc = "A large coil modified to amplify an ionic wave and use it as a projectile. (Can be attached to: Working and Combat Exosuits)"
	icon_state = "ion_rigged"
	matter_amounts = /datum/design/mechfab/equipment/weapon/rigged_ion::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/rigged_ion::req_tech

	mecha_types = MECHA_TYPE_WORKING | MECHA_TYPE_COMBAT

	equip_cooldown = 5 SECONDS
	energy_drain = 100

	projectile = /obj/projectile/ion/pistol