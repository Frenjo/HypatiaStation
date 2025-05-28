// Ion
/obj/item/mecha_equipment/weapon/energy/ion
	name = "mkIV ion heavy cannon"
	icon_state = "ion"
	matter_amounts = /datum/design/mechfab/equipment/weapon/ion::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/ion::req_tech

	equip_cooldown = 4 SECONDS
	energy_drain = 120
	projectile = /obj/item/projectile/ion
	fire_sound = 'sound/weapons/gun/laser.ogg'

/obj/item/mecha_equipment/weapon/energy/ion/rigged
	name = "jury-rigged ion cannon"
	icon_state = "ion_rigged"
	matter_amounts = /datum/design/mechfab/equipment/weapon/rigged_ion::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/rigged_ion::req_tech

	mecha_flags = MECHA_FLAG_WORKING | MECHA_FLAG_COMBAT
	equip_cooldown = 5 SECONDS
	energy_drain = 100
	projectile = /obj/item/projectile/ion/pistol