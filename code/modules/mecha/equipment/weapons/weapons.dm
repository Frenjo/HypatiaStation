/obj/item/mecha_part/equipment/weapon
	name = "mecha weapon"
	range = RANGED
	origin_tech = list(/datum/tech/materials = 3, /datum/tech/combat = 3)
	var/projectile //Type of projectile fired.
	var/projectiles = 1 //Amount of projectiles loaded.
	var/projectiles_per_shot = 1 //Amount of projectiles fired per single shot.
	var/deviation = 0 //Inaccuracy of shots.
	var/fire_cooldown = 0 //Duration of sleep between firing projectiles in single shot.
	var/fire_sound //Sound played while firing.
	var/fire_volume = 50 //How loud it is played.
	var/auto_rearm = 0 //Does the weapon reload itself after each shot?

/obj/item/mecha_part/equipment/weapon/can_attach(obj/mecha/combat/M)
	if(!istype(M))
		return 0
	return ..()

/obj/item/mecha_part/equipment/weapon/action_checks(atom/target)
	if(projectiles <= 0)
		return 0
	return ..()

/obj/item/mecha_part/equipment/weapon/action(atom/target)
	if(!action_checks(target))
		return
	var/turf/curloc = chassis.loc
	var/turf/targloc = GET_TURF(target)
	if(isnull(curloc) || isnull(targloc))
		return
	chassis.use_power(energy_drain)
	chassis.visible_message(SPAN_WARNING("[chassis] fires [src]!"))
	occupant_message(SPAN_WARNING("You fire [src]!"))
	log_message("Fired from [src], targeting [target].")
	for(var/i = 1 to min(projectiles, projectiles_per_shot))
		var/turf/aimloc = targloc
		if(deviation)
			aimloc = locate(targloc.x + GaussRandRound(deviation, 1), targloc.y + GaussRandRound(deviation, 1), targloc.z)
		if(!aimloc || aimloc == curloc)
			break
		playsound(chassis, fire_sound, fire_volume, 1)
		projectiles--
		var/P = new projectile(curloc)
		Fire(P, target, aimloc)
		if(fire_cooldown)
			sleep(fire_cooldown)
	if(auto_rearm)
		projectiles = projectiles_per_shot
	set_ready_state(0)
	do_after_cooldown()
	return

/obj/item/mecha_part/equipment/weapon/proc/Fire(atom/A, atom/target, turf/aimloc)
	var/obj/item/projectile/P = A
	P.shot_from = src
	P.original = target
	P.starting = P.loc
	P.current = P.loc
	P.firer = chassis.occupant
	P.yo = aimloc.y - P.loc.y
	P.xo = aimloc.x - P.loc.x
	P.process()

/obj/item/mecha_part/equipment/weapon/energy
	name = "general energy weapon"
	auto_rearm = 1

/obj/item/mecha_part/equipment/weapon/energy/laser
	equip_cooldown = 8
	name = "\improper CH-PS \"Immolator\" laser"
	icon_state = "mecha_laser"
	energy_drain = 30
	projectile = /obj/item/projectile/energy/beam/laser
	fire_sound = 'sound/weapons/Laser.ogg'

/obj/item/mecha_part/equipment/weapon/energy/laser/heavy
	equip_cooldown = 15
	name = "\improper CH-LC \"Solaris\" laser cannon"
	icon_state = "mecha_laser"
	energy_drain = 60
	projectile = /obj/item/projectile/energy/beam/laser/heavy
	fire_sound = 'sound/weapons/lasercannonfire.ogg'

/obj/item/mecha_part/equipment/weapon/energy/ion
	equip_cooldown = 40
	name = "mkIV ion heavy cannon"
	icon_state = "mecha_ion"
	energy_drain = 120
	projectile = /obj/item/projectile/ion
	fire_sound = 'sound/weapons/Laser.ogg'

/obj/item/mecha_part/equipment/weapon/energy/pulse
	equip_cooldown = 30
	name = "eZ-13 mk2 heavy pulse rifle"
	icon_state = "mecha_pulse"
	energy_drain = 120
	origin_tech = list(/datum/tech/materials = 3, /datum/tech/combat = 6, /datum/tech/power_storage = 4)
	projectile = /obj/item/projectile/energy/beam/pulse/heavy
	fire_sound = 'sound/weapons/marauder.ogg'

/obj/item/projectile/energy/beam/pulse/heavy
	name = "heavy pulse laser"
	icon_state = "pulse1_bl"
	var/life = 20

/obj/item/projectile/energy/beam/pulse/heavy/Bump(atom/A)
	A.bullet_act(src, def_zone)
	src.life -= 10
	if(life <= 0)
		qdel(src)
	return

/obj/item/mecha_part/equipment/weapon/energy/taser
	name = "PBT \"Pacifier\" mounted taser"
	icon_state = "mecha_taser"
	energy_drain = 20
	equip_cooldown = 8
	projectile = /obj/item/projectile/energy/electrode
	fire_sound = 'sound/weapons/Taser.ogg'

/obj/item/mecha_part/equipment/weapon/honker
	name = "\improper HoNkER BlAsT 5000"
	icon_state = "mecha_honker"
	energy_drain = 200
	equip_cooldown = 150
	range = MELEE|RANGED
	construction_time = 500
	construction_cost = list(MATERIAL_METAL = 20000, /decl/material/bananium = 10000)

/obj/item/mecha_part/equipment/weapon/honker/can_attach(obj/mecha/combat/honker/M)
	if(!istype(M))
		return 0
	return ..()

/obj/item/mecha_part/equipment/weapon/honker/action(target)
	if(!chassis)
		return 0
	if(energy_drain && chassis.get_charge() < energy_drain)
		return 0
	if(!equip_ready)
		return 0

	playsound(chassis, 'sound/items/AirHorn.ogg', 100, 1)
	chassis.occupant_message("<font color='red' size='5'>HONK</font>")
	for(var/mob/living/carbon/M in ohearers(6, chassis))
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(istype(H.l_ear, /obj/item/clothing/ears/earmuffs) || istype(H.r_ear, /obj/item/clothing/ears/earmuffs))
				continue
		to_chat(M, "<font color='red' size='7'>HONK</font>")
		M.sleeping = 0
		M.stuttering += 20
		M.ear_deaf += 30
		M.Weaken(3)
		if(prob(30))
			M.Stun(10)
			M.Paralyse(4)
		else
			M.make_jittery(500)
		/* //else the mousetraps are useless
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(isobj(H.shoes))
				var/thingy = H.shoes
				H.drop_from_inventory(H.shoes)
				walk_away(thingy,chassis,15,2)
				spawn(20)
					if(thingy)
						walk(thingy,0)
		*/
	chassis.use_power(energy_drain)
	log_message("Honked from [src.name]. HONK!")
	do_after_cooldown()
	return

/obj/item/mecha_part/equipment/weapon/ballistic
	name = "general ballisic weapon"
	var/projectile_energy_cost

/obj/item/mecha_part/equipment/weapon/ballistic/get_equip_info()
		return "[..()]\[[src.projectiles]\][(src.projectiles < initial(src.projectiles))?" - <a href='byond://?src=\ref[src];rearm=1'>Rearm</a>":null]"

/obj/item/mecha_part/equipment/weapon/ballistic/proc/rearm()
	if(projectiles < initial(projectiles))
		var/projectiles_to_add = initial(projectiles) - projectiles
		while(chassis.get_charge() >= projectile_energy_cost && projectiles_to_add)
			projectiles++
			projectiles_to_add--
			chassis.use_power(projectile_energy_cost)
	send_byjax(chassis.occupant, "exosuit.browser", "\ref[src]", src.get_equip_info())
	log_message("Rearmed [src.name].")
	return

/obj/item/mecha_part/equipment/weapon/ballistic/Topic(href, href_list)
	..()
	if(href_list["rearm"])
		src.rearm()
	return

/obj/item/mecha_part/equipment/weapon/ballistic/scattershot
	name = "\improper LBX AC 10 \"Scattershot\""
	icon_state = "mecha_scatter"
	equip_cooldown = 20
	projectile = /obj/item/projectile/bullet/midbullet
	fire_sound = 'sound/weapons/Gunshot.ogg'
	fire_volume = 80
	projectiles = 40
	projectiles_per_shot = 4
	deviation = 0.7
	projectile_energy_cost = 25

/obj/item/mecha_part/equipment/weapon/ballistic/lmg
	name = "\improper Ultra AC 2"
	icon_state = "mecha_uac2"
	equip_cooldown = 10
	projectile = /obj/item/projectile/bullet/weakbullet
	fire_sound = 'sound/weapons/Gunshot.ogg'
	projectiles = 300
	projectiles_per_shot = 3
	deviation = 0.3
	projectile_energy_cost = 20
	fire_cooldown = 2

/obj/item/mecha_part/equipment/weapon/ballistic/missile_rack
	var/missile_speed = 2
	var/missile_range = 30

/obj/item/mecha_part/equipment/weapon/ballistic/missile_rack/Fire(atom/movable/AM, atom/target, turf/aimloc)
	AM.throw_at(target, missile_range, missile_speed)

/obj/item/mecha_part/equipment/weapon/ballistic/missile_rack/explosive
	name = "\improper SRM-8 missile rack"
	icon_state = "mecha_missilerack"
	projectile = /obj/item/missile
	fire_sound = 'sound/effects/bang.ogg'
	projectiles = 8
	projectile_energy_cost = 1000
	equip_cooldown = 60

/obj/item/mecha_part/equipment/weapon/ballistic/missile_rack/explosive/Fire(atom/movable/AM, atom/target, turf/aimloc)
	var/obj/item/missile/M = AM
	M.primed = 1
	..()

/obj/item/missile
	icon = 'icons/obj/weapons/grenade.dmi'
	icon_state = "missile"
	var/primed = null
	throwforce = 15

/obj/item/missile/throw_impact(atom/hit_atom)
	if(primed)
		explosion(hit_atom, 0, 0, 2, 4)
		qdel(src)
	else
		..()
	return

/obj/item/mecha_part/equipment/weapon/ballistic/missile_rack/flashbang
	name = "\improper SGL-6 grenade launcher"
	icon_state = "mecha_grenadelnchr"
	projectile = /obj/item/grenade/flashbang
	fire_sound = 'sound/effects/bang.ogg'
	projectiles = 6
	missile_speed = 1.5
	projectile_energy_cost = 800
	equip_cooldown = 60
	var/det_time = 20

/obj/item/mecha_part/equipment/weapon/ballistic/missile_rack/flashbang/Fire(atom/movable/AM, atom/target, turf/aimloc)
	..()
	var/obj/item/grenade/flashbang/F = AM
	spawn(det_time)
		F.prime()

/obj/item/mecha_part/equipment/weapon/ballistic/missile_rack/flashbang/clusterbang//Because I am a heartless bastard -Sieve
	name = "\improper SOP-6 grenade launcher"
	projectile = /obj/item/grenade/flashbang/clusterbang
	construction_cost = list(MATERIAL_METAL = 20000, /decl/material/gold = 6000, /decl/material/uranium = 6000)

/obj/item/mecha_part/equipment/weapon/ballistic/missile_rack/flashbang/clusterbang/limited/get_equip_info()//Limited version of the clusterbang launcher that can't reload
	return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[chassis.selected == src ? "<b>" : "<a href='byond://?src=\ref[chassis];select_equip=\ref[src]'>"][src.name][chassis.selected == src ? "</b>" : "</a>"]\[[src.projectiles]\]"

/obj/item/mecha_part/equipment/weapon/ballistic/missile_rack/flashbang/clusterbang/limited/rearm()
	return//Extra bit of security

/obj/item/mecha_part/equipment/weapon/ballistic/missile_rack/banana_mortar
	name = "banana mortar"
	icon_state = "mecha_bananamrtr"
	projectile = /obj/item/bananapeel
	fire_sound = 'sound/items/bikehorn.ogg'
	projectiles = 15
	missile_speed = 1.5
	projectile_energy_cost = 100
	equip_cooldown = 20
	construction_time = 300
	construction_cost = list(MATERIAL_METAL = 20000, /decl/material/bananium = 5000)

/obj/item/mecha_part/equipment/weapon/ballistic/missile_rack/banana_mortar/can_attach(obj/mecha/combat/honker/M)
	if(!istype(M))
		return 0
	return ..()

/obj/item/mecha_part/equipment/weapon/ballistic/missile_rack/banana_mortar/mousetrap_mortar
	name = "mousetrap mortar"
	icon_state = "mecha_mousetrapmrtr"
	projectile = /obj/item/assembly/mousetrap
	equip_cooldown = 10

/obj/item/mecha_part/equipment/weapon/ballistic/missile_rack/banana_mortar/mousetrap_mortar/Fire(atom/movable/AM, atom/target, turf/aimloc)
	var/obj/item/assembly/mousetrap/M = AM
	M.secured = 1
	..()