// Disabler
/obj/item/mecha_equipment/weapon/energy/disabler
	name = "\improper CH-DS \"Peacemaker\" disabler"
	desc = "A weapon for combat exosuits. Shoots basic disablers."
	icon_state = "disabler"
	matter_amounts = /datum/design/mechfab/equipment/weapon/disabler::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/disabler::req_tech

	equip_cooldown = 0.8 SECONDS
	energy_drain = 30

	projectile = /obj/item/projectile/energy/pulse/disabler
	fire_sound = 'sound/weapons/gun/taser2.ogg'

/obj/item/mecha_equipment/weapon/energy/rapid_disabler
	name = "\improper SW-RM \"Peaceforcer\" rapid disabler"
	desc = "A weapon for combat exosuits of unknown origin. Uses foreign technology to streamline energy compression in order to shoot a stream of disabler shots in quick succession."
	icon_state = "rapid_disabler"

	equip_cooldown = 3 SECONDS
	energy_drain = 50

	projectile = /obj/item/projectile/energy/pulse/disabler
	projectiles_per_shot = 3
	deviation = 0.7
	fire_cooldown = 2
	fire_sound = 'sound/weapons/gun/taser2.ogg'