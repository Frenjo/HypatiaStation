// Launchers
/obj/item/mecha_equipment/weapon/ballistic/launcher
	var/missile_speed = 2
	var/missile_range = 30

/obj/item/mecha_equipment/weapon/ballistic/launcher/Fire(atom/movable/AM, atom/target, turf/aimloc)
	AM.throw_at(target, missile_range, missile_speed)

// Missile
/obj/item/mecha_equipment/weapon/ballistic/launcher/missile_rack
	name = "\improper SRM-8 missile rack"
	icon_state = "missilerack"

	equip_cooldown = 6 SECONDS

	projectile = /obj/item/missile
	fire_sound = 'sound/effects/bang.ogg'
	projectiles = 8
	projectile_energy_cost = 1000

/obj/item/mecha_equipment/weapon/ballistic/launcher/missile_rack/Fire(atom/movable/AM, atom/target, turf/aimloc)
	var/obj/item/missile/M = AM
	M.primed = TRUE
	. = ..()

/obj/item/missile
	icon = 'icons/obj/weapons/grenade.dmi'
	icon_state = "missile"
	throwforce = 15

	var/primed = FALSE

/obj/item/missile/throw_impact(atom/hit_atom)
	if(primed)
		explosion(hit_atom, 0, 0, 2, 4)
		qdel(src)
	else
		..()

// Banana
/obj/item/mecha_equipment/weapon/ballistic/launcher/banana_mortar
	name = "banana mortar"
	icon_state = "bananamrtr"
	matter_amounts = /datum/design/mechfab/equipment/weapon/banana_mortar::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/banana_mortar::req_tech

	mecha_types = MECHA_TYPE_HONK

	equip_cooldown = 2 SECONDS

	projectile = /obj/item/bananapeel
	fire_sound = 'sound/items/bikehorn.ogg'
	projectiles = 15
	missile_speed = 1.5
	projectile_energy_cost = 100

// Mousetrap
/obj/item/mecha_equipment/weapon/ballistic/launcher/banana_mortar/mousetrap_mortar
	name = "mousetrap mortar"
	icon_state = "mousetrapmrtr"
	matter_amounts = /datum/design/mechfab/equipment/weapon/mousetrap_mortar::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/mousetrap_mortar::req_tech

	equip_cooldown = 1 SECOND

	projectile = /obj/item/assembly/mousetrap

/obj/item/mecha_equipment/weapon/ballistic/launcher/banana_mortar/mousetrap_mortar/Fire(atom/movable/AM, atom/target, turf/aimloc)
	var/obj/item/assembly/mousetrap/M = AM
	M.secured = TRUE
	. = ..()

// Grenade
/obj/item/mecha_equipment/weapon/ballistic/launcher/grenade
	equip_cooldown = 6 SECONDS

	projectiles = 6
	fire_sound = 'sound/effects/bang.ogg'

	projectile_energy_cost = 800

	missile_speed = 1.5

	var/det_time = 2 SECONDS

/obj/item/mecha_equipment/weapon/ballistic/launcher/grenade/Fire(atom/movable/mover, atom/target, turf/aimloc)
	. = ..()
	var/obj/item/grenade/G = mover
	spawn(det_time)
		G.prime()

// Flashbang
/obj/item/mecha_equipment/weapon/ballistic/launcher/grenade/flashbang
	name = "\improper SGL-6 grenade launcher"
	icon_state = "grenadelnchr"
	matter_amounts = /datum/design/mechfab/equipment/weapon/grenade_launcher::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/grenade_launcher::req_tech

	projectile = /obj/item/grenade/flashbang

// Clusterbang
/obj/item/mecha_equipment/weapon/ballistic/launcher/grenade/flashbang/cluster //Because I am a heartless bastard -Sieve
	name = "\improper SOP-6 grenade launcher"
	projectile = /obj/item/grenade/flashbang/clusterbang

// Limited version of the clusterbang launcher that can't reload.
/obj/item/mecha_equipment/weapon/ballistic/launcher/grenade/flashbang/cluster/limited
	matter_amounts = /datum/design/mechfab/equipment/weapon/clusterbang_launcher::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/clusterbang_launcher::req_tech

/obj/item/mecha_equipment/weapon/ballistic/launcher/grenade/flashbang/cluster/limited/get_equip_info()
	. = "<span style=\"color:[equip_ready ? "#0f0" : "#f00"];\">*</span>&nbsp;[chassis.selected == src ? "<b>" : "<a href='byond://?src=\ref[chassis];select_equip=\ref[src]'>"][name][chassis.selected == src ? "</b>" : "</a>"]\[[projectiles]\]"

/obj/item/mecha_equipment/weapon/ballistic/launcher/grenade/flashbang/cluster/limited/rearm()
	return//Extra bit of security

// Cleaner
/obj/item/mecha_equipment/weapon/ballistic/launcher/grenade/cleaner
	name = "\improper CCL-6 grenade launcher" // CCL-6 = Custodial Cleaner Launcher with a 6 shot magazine.
	icon_state = "cleaner_grenade_launcher"
	matter_amounts = /datum/design/mechfab/equipment/working/cleaner_grenade_launcher::materials
	origin_tech = /datum/design/mechfab/equipment/working/cleaner_grenade_launcher::req_tech

	mecha_types = MECHA_TYPE_WORKING

	projectile = /obj/item/grenade/chemical/cleaner