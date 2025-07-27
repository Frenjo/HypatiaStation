// LMG
/obj/item/mecha_equipment/weapon/ballistic/lmg
	name = "\improper Ultra AC 2"
	icon_state = "uac2"
	matter_amounts = /datum/design/mechfab/equipment/weapon/lmg::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/lmg::req_tech

	equip_cooldown = 1 SECOND

	projectile = /obj/item/projectile/bullet/weakbullet
	fire_sound = 'sound/weapons/gun/gunshot.ogg'
	projectiles = 300
	projectiles_per_shot = 3
	deviation = 0.3
	projectile_energy_cost = 20
	fire_cooldown = 2

// Scattershot
/obj/item/mecha_equipment/weapon/ballistic/scattershot
	name = "\improper LBX AC 10 \"Scattershot\""
	icon_state = "scatter"
	matter_amounts = /datum/design/mechfab/equipment/weapon/scattershot::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/scattershot::req_tech

	equip_cooldown = 2 SECONDS

	projectile = /obj/item/projectile/bullet/midbullet
	fire_sound = 'sound/weapons/gun/gunshot.ogg'
	fire_volume = 80
	projectiles = 40
	projectiles_per_shot = 4
	deviation = 0.7
	projectile_energy_cost = 25