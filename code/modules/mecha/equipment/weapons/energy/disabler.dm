// Disabler
/obj/item/mecha_equipment/weapon/energy/disabler
	name = "\improper CH-DS \"Peacemaker\" disabler"
	desc = "A weapon for combat exosuits. Shoots basic disablers. (Can be attached to: Combat Exosuits)"
	icon_state = "disabler"
	matter_amounts = /datum/design/mechfab/equipment/weapon/disabler::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/disabler::req_tech

	equip_cooldown = 0.8 SECONDS
	energy_drain = 30

	projectile = /obj/item/projectile/energy/pulse/disabler
	fire_sound = 'sound/weapons/gun/taser2.ogg'

/obj/item/mecha_equipment/weapon/energy/disabler/rigged
	name = "jury-rigged \"Peacebringer\" disabler"
	desc = "A crude exosuit-mounted disabler. (Can be attached to: Working and Combat Exosuits)" // Write a better description later.
	icon_state = "disabler_rigged"
	matter_amounts = /datum/design/mechfab/equipment/weapon/rigged_disabler::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/rigged_disabler::req_tech

	mecha_types = MECHA_TYPE_WORKING | MECHA_TYPE_COMBAT

	equip_cooldown = 1.6 SECONDS
	energy_drain = 60