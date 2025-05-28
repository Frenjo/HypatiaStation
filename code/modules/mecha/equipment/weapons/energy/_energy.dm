/obj/item/mecha_equipment/weapon/energy
	name = "general energy weapon"
	auto_rearm = 1

// Taser
/obj/item/mecha_equipment/weapon/energy/taser
	name = "PBT \"Pacifier\" mounted taser"
	icon_state = "taser"
	matter_amounts = /datum/design/mechfab/equipment/weapon/taser::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/taser::req_tech

	equip_cooldown = 0.8 SECONDS
	energy_drain = 20
	projectile = /obj/item/projectile/energy/electrode
	fire_sound = 'sound/weapons/gun/taser.ogg'

// Pulse
/obj/item/mecha_equipment/weapon/energy/pulse
	name = "eZ-13 mk2 heavy pulse rifle"
	icon_state = "pulse"
	equip_cooldown = 3 SECONDS
	energy_drain = 120
	origin_tech = alist(/decl/tech/materials = 3, /decl/tech/combat = 6, /decl/tech/power_storage = 4)
	projectile = /obj/item/projectile/energy/beam/pulse/heavy
	fire_sound = 'sound/weapons/gun/marauder.ogg'

/obj/item/projectile/energy/beam/pulse/heavy
	name = "heavy pulse laser"
	icon_state = "pulse1_bl"

	var/life = 20

/obj/item/projectile/energy/beam/pulse/heavy/Bump(atom/A)
	A.bullet_act(src, def_zone)
	life -= 10
	if(life <= 0)
		qdel(src)