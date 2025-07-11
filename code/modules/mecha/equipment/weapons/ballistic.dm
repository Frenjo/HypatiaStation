/obj/item/mecha_equipment/weapon/ballistic
	name = "general ballistic weapon"

	var/projectile_energy_cost

/obj/item/mecha_equipment/weapon/ballistic/get_equip_info()
	. = "[..()] \[[projectiles]\][projectiles < initial(projectiles) ? " - <a href='byond://?src=\ref[src];rearm=1'>Rearm</a>" : null]"

/obj/item/mecha_equipment/weapon/ballistic/proc/rearm()
	if(projectiles < initial(projectiles))
		var/projectiles_to_add = initial(projectiles) - projectiles
		while(chassis.get_charge() >= projectile_energy_cost && projectiles_to_add)
			projectiles++
			projectiles_to_add--
			chassis.use_power(projectile_energy_cost)
	send_byjax(chassis.occupant, "exosuit.browser", "\ref[src]", get_equip_info())
	log_message("Rearmed [name].")

/obj/item/mecha_equipment/weapon/ballistic/Topic(href, href_list)
	. = ..()
	if(href_list["rearm"])
		rearm()

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

/obj/item/mecha_equipment/weapon/ballistic/launcher
	var/missile_speed = 2
	var/missile_range = 30

/obj/item/mecha_equipment/weapon/ballistic/launcher/Fire(atom/movable/AM, atom/target, turf/aimloc)
	AM.throw_at(target, missile_range, missile_speed)

// Launchers
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

/obj/item/mecha_equipment/weapon/ballistic/launcher/flashbang
	name = "\improper SGL-6 grenade launcher"
	icon_state = "grenadelnchr"
	matter_amounts = /datum/design/mechfab/equipment/weapon/grenade_launcher::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/grenade_launcher::req_tech

	equip_cooldown = 6 SECONDS

	projectile = /obj/item/grenade/flashbang
	fire_sound = 'sound/effects/bang.ogg'
	projectiles = 6
	missile_speed = 1.5
	projectile_energy_cost = 800

	var/det_time = 20

/obj/item/mecha_equipment/weapon/ballistic/launcher/flashbang/Fire(atom/movable/AM, atom/target, turf/aimloc)
	. = ..()
	var/obj/item/grenade/flashbang/F = AM
	spawn(det_time)
		F.prime()

/obj/item/mecha_equipment/weapon/ballistic/launcher/flashbang/cluster //Because I am a heartless bastard -Sieve
	name = "\improper SOP-6 grenade launcher"
	projectile = /obj/item/grenade/flashbang/clusterbang

/obj/item/mecha_equipment/weapon/ballistic/launcher/flashbang/cluster/limited
	matter_amounts = /datum/design/mechfab/equipment/weapon/clusterbang_launcher::materials
	origin_tech = /datum/design/mechfab/equipment/weapon/clusterbang_launcher::req_tech

/obj/item/mecha_equipment/weapon/ballistic/launcher/flashbang/cluster/limited/get_equip_info() // Limited version of the clusterbang launcher that can't reload
	. = "<span style=\"color:[equip_ready ? "#0f0" : "#f00"];\">*</span>&nbsp;[chassis.selected == src ? "<b>" : "<a href='byond://?src=\ref[chassis];select_equip=\ref[src]'>"][name][chassis.selected == src ? "</b>" : "</a>"]\[[projectiles]\]"

/obj/item/mecha_equipment/weapon/ballistic/launcher/flashbang/cluster/limited/rearm()
	return//Extra bit of security

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