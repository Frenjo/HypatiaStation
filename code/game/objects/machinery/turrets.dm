/area/turret_protected
	name = "Turret Protected Area"
	var/list/turretTargets = list()

/area/turret_protected/proc/subjectDied(target)
	if(isliving(target))
		if(!issilicon(target))
			var/mob/living/L = target
			if(L.stat)
				if(L in turretTargets)
					src.Exited(L)

/area/turret_protected/Entered(O)
	..()
	//if( master && master != src )
	//	return master.Entered(O)

	if(iscarbon(O))
		turretTargets |= O
	else if(ismecha(O))
		var/obj/mecha/Mech = O
		if(Mech.occupant)
			turretTargets |= Mech
	else if(issimple(O))
		turretTargets |= O
	return 1

/area/turret_protected/Exited(O)
	//if( master && master != src )
	//	return master.Exited(O)

	if(ismob(O) && !issilicon(O))
		turretTargets -= O
	else if(ismecha(O))
		turretTargets -= O
	..()
	return 1


/obj/machinery/turret
	name = "turret"
	icon = 'icons/obj/turrets.dmi'
	icon_state = "grey_target_prism"
	density = TRUE
	anchored = TRUE
	layer = 3
	invisibility = INVISIBILITY_LEVEL_TWO

	power_usage = alist(
		USE_POWER_IDLE = 50,
		USE_POWER_ACTIVE = 300
	)

	var/raised = 0
	var/enabled = 1
	var/lasers = 0
	var/lasertype = 1
		// 1 = lasers
		// 2 = cannons
		// 3 = pulse
		// 4 = change (HONK)
		// 5 = bluetag
		// 6 = redtag
	var/health = 80
	var/obj/machinery/turretcover/cover = null
	var/popping = 0
	var/wasvalid = 0
	var/lastfired = 0
	var/shot_delay = 30 //3 seconds between shots
	var/datum/effect/system/spark_spread/spark_system
//	var/list/targets
	var/atom/movable/cur_target
	var/targeting_active = 0
	var/area/turret_protected/protected_area

/obj/machinery/turret/proc/take_damage(damage)
	src.health -= damage
	if(src.health <= 0)
		qdel(src)
	return

/obj/machinery/turret/attack_hand(mob/living/carbon/human/user)
	if(!istype(user))
		return ..()

	if(user.species.can_shred(user) && !(stat & BROKEN))
		playsound(src, 'sound/weapons/melee/slash.ogg', 25, 1, -1)
		visible_message(SPAN_DANGER("[] has slashed at []!"), user, src)
		src.take_damage(15)
	return

/obj/machinery/turret/New()
	spark_system = new /datum/effect/system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
//	targets = new
	..()
	return

/obj/machinery/turret/proc/update_health()
	if(src.health <= 0)
		qdel(src)
	return

/obj/machinery/turretcover
	name = "pop-up turret cover"
	icon = 'icons/obj/turrets.dmi'
	icon_state = "turretCover"
	anchored = TRUE
	layer = 3.5
	density = FALSE
	var/obj/machinery/turret/host = null

/obj/machinery/turret/proc/isPopping()
	return (popping != 0)

/obj/machinery/turret/power_change()
	if(stat & BROKEN)
		icon_state = "grey_target_prism"
	else
		if(powered())
			if(src.enabled)
				if(src.lasers)
					icon_state = "orange_target_prism"
				else
					icon_state = "target_prism"
			else
				icon_state = "grey_target_prism"
			stat &= ~NOPOWER
		else
			spawn(rand(0, 15))
				src.icon_state = "grey_target_prism"
				stat |= NOPOWER

/obj/machinery/turret/proc/setState(enabled, lethal)
	src.enabled = enabled
	src.lasers = lethal
	src.power_change()

/obj/machinery/turret/proc/get_protected_area()
	var/area/turret_protected/TP = GET_AREA(src)
	if(istype(TP))
		//if(TP.master && TP.master != TP)
		//	TP = TP.master
		return TP
	return

/obj/machinery/turret/proc/check_target(atom/movable/T)
	if(T && (T in protected_area.turretTargets))
		var/area/area_T = GET_AREA(T)
		if(isnull(area_T) || (area_T.type != protected_area.type))
			protected_area.Exited(T)
			return 0 //If the guy is somehow not in the turret's area (teleportation), get them out the damn list. --NEO
		if(iscarbon(T) )
			var/mob/living/carbon/MC = T
			if(!MC.stat)
				if(!MC.lying || lasers)
					return 1
		else if(ismecha(T))
			var/obj/mecha/ME = T
			if(ME.occupant)
				return 1
		else if(issimple(T))
			var/mob/living/simple/A = T
			if(!A.stat)
				if(lasers)
					return 1
	return 0

/obj/machinery/turret/proc/get_new_target()
	var/list/new_targets = new
	var/new_target
	for(var/mob/living/carbon/M in protected_area.turretTargets)
		if(!M.stat)
			if(!M.lying || lasers)
				new_targets += M
	for(var/obj/mecha/M in protected_area.turretTargets)
		if(M.occupant)
			new_targets += M
	for(var/mob/living/simple/M in protected_area.turretTargets)
		if(!M.stat)
			new_targets += M
	if(length(new_targets))
		new_target = pick(new_targets)
	return new_target


/obj/machinery/turret/process()
	if(stat & (NOPOWER|BROKEN))
		return
	if(src.cover == null)
		src.cover = new /obj/machinery/turretcover(src.loc)
		src.cover.host = src
	protected_area = get_protected_area()
	if(!enabled || !protected_area || !length(protected_area.turretTargets))
		if(!isDown() && !isPopping())
			popDown()
		return
	if(!check_target(cur_target)) //if current target fails target check
		cur_target = get_new_target() //get new target

	if(cur_target) //if it's found, proceed
		//to_world("[cur_target]")
		if(!isPopping())
			if(isDown())
				popUp()
				update_power_state(USE_POWER_ACTIVE)
			else
				spawn()
					if(!targeting_active)
						targeting_active = 1
						target()
						targeting_active = 0

		if(prob(15))
			if(prob(50))
				playsound(src, 'sound/effects/turret/move1.wav', 60, 1)
			else
				playsound(src, 'sound/effects/turret/move2.wav', 60, 1)
	else if(!isPopping())	//else, pop down
		if(!isDown())
			popDown()
			update_power_state(USE_POWER_IDLE)
	return


/obj/machinery/turret/proc/target()
	while(src && enabled && !stat && check_target(cur_target))
		src.set_dir(get_dir(src, cur_target))
		shootAt(cur_target)
		sleep(shot_delay)
	return

/obj/machinery/turret/proc/shootAt(atom/movable/target)
	var/turf/T = GET_TURF(src)
	var/turf/U = GET_TURF(target)
	if(isnull(T) || isnull(U))
		return
	var/obj/item/projectile/A
	if(src.lasers)
		switch(lasertype)
			if(1)
				A = new /obj/item/projectile/energy/beam/laser(loc)
			if(2)
				A = new /obj/item/projectile/energy/beam/laser/heavy(loc)
			if(3)
				A = new /obj/item/projectile/energy/beam/pulse(loc)
			if(4)
				A = new /obj/item/projectile/change(loc)
			if(5)
				A = new /obj/item/projectile/energy/beam/laser/tag/blue(loc)
			if(6)
				A = new /obj/item/projectile/energy/beam/laser/tag/red(loc)
		A.original = target
		use_power(500)
	else
		A = new /obj/item/projectile/energy/electrode(loc)
		use_power(200)
	A.current = T
	A.starting = T
	A.yo = U.y - T.y
	A.xo = U.x - T.x
	spawn(0)
		A.process()
	return


/obj/machinery/turret/proc/isDown()
	return (invisibility != 0)

/obj/machinery/turret/proc/popUp()
	if((!isPopping()) || src.popping == -1)
		invisibility = 0
		popping = 1
		playsound(src, 'sound/effects/turret/open.wav', 60, 1)
		if(src.cover != null)
			flick("popup", src.cover)
			src.cover.icon_state = "openTurretCover"
		spawn(10)
			if(popping == 1)
				popping = 0

/obj/machinery/turret/proc/popDown()
	if((!isPopping()) || src.popping == 1)
		popping = -1
		playsound(src, 'sound/effects/turret/open.wav', 60, 1)
		if(src.cover != null)
			flick("popdown", src.cover)
			src.cover.icon_state = "turretCover"
		spawn(10)
			if(popping == -1)
				invisibility = INVISIBILITY_LEVEL_TWO
				popping = 0

/obj/machinery/turret/bullet_act(obj/item/projectile/bullet)
	if(bullet.damage_type == BRUTE || bullet.damage_type == BURN)
		health -= bullet.damage
		..()
		if(prob(45) && bullet.damage > 0)
			spark_system.start()
		qdel(bullet)
		if(health <= 0)
			die()

/obj/machinery/turret/attackby(obj/item/W, mob/user)	//I can't believe no one added this before/N
	..()
	playsound(src, 'sound/weapons/melee/smash.ogg', 60, 1)
	src.spark_system.start()
	src.health -= W.force * 0.5
	if(src.health <= 0)
		src.die()
	return

/obj/machinery/turret/emp_act(severity)
	switch(severity)
		if(1)
			enabled = 0
			lasers = 0
			power_change()
	..()

/obj/machinery/turret/ex_act(severity)
	if(severity < 3)
		src.die()

/obj/machinery/turret/proc/die()
	src.health = 0
	src.density = FALSE
	src.stat |= BROKEN
	src.icon_state = "destroyed_target_prism"
	if(cover != null)
		qdel(cover)
	sleep(3)
	flick("explosion", src)
	spawn(13)
		qdel(src)

/obj/machinery/turretid
	name = "turret deactivation control"
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "motion3"
	anchored = TRUE
	density = FALSE
	var/enabled = 1
	var/lethal = 0
	var/locked = 1
	var/control_area //can be area name, path or nothing.
	var/ailock = 0 // AI cannot use this
	req_access = list(ACCESS_AI_UPLOAD)

/obj/machinery/turretid/New()
	..()
	if(!control_area)
		var/area/CA = GET_AREA(src)
		//if(CA.master && CA.master != CA)
		//	control_area = CA.master
		//else
		//	control_area = CA
		control_area = CA
	else if(istext(control_area))
		for_no_type_check(var/area/A, GLOBL.area_list)
			if(A.name && A.name == control_area)
				control_area = A
				break
	//don't have to check if control_area is path, since get_area_all_atoms can take path.
	return

/obj/machinery/turretid/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(stat & (BROKEN | NOPOWER))
		FEEDBACK_MACHINE_UNRESPONSIVE(user)
		return FALSE

	if(emagged)
		FEEDBACK_ALREADY_EMAGGED(user)
		return FALSE
	to_chat(user, SPAN_WARNING("You short out the turret control's access analysis module."))
	emagged = TRUE
	locked = FALSE
	updateUsrDialog()
	return TRUE

/obj/machinery/turretid/attackby(obj/item/W, mob/user)
	if(stat & BROKEN)
		return
	if(issilicon(user))
		return src.attack_hand(user)

	if(get_dist(src, user) == 0)		// trying to unlock the interface
		if(src.allowed(usr))
			if(emagged)
				to_chat(user, SPAN_NOTICE("The turret control is unresponsive."))
				return

			locked = !locked
			to_chat(user, SPAN_NOTICE("You [ locked ? "lock" : "unlock"] the panel."))
			if(locked)
				if(user.machine == src)
					user.unset_machine()
					user << browse(null, "window=turretid")
			else
				if(user.machine == src)
					src.attack_hand(user)
		else
			FEEDBACK_ACCESS_DENIED(user)

/obj/machinery/turretid/attack_ai(mob/user)
	if(!ailock)
		return attack_hand(user)
	else
		to_chat(user, SPAN_NOTICE("There seems to be a firewall preventing you from accessing this device."))

/obj/machinery/turretid/attack_hand(mob/user)
	if(get_dist(src, user) > 0)
		if(!issilicon(user))
			to_chat(user, SPAN_NOTICE("You are too far away."))
			user.unset_machine()
			user << browse(null, "window=turretid")
			return

	user.set_machine(src)
	var/loc = src.loc
	if(isturf(loc))
		loc = loc:loc
	if(!isarea(loc))
		user << text("Turret badly positioned - loc.loc is [].", loc)
		return
	var/area/area = loc
	var/t = "<TT><B>Turret Control Panel</B> ([area.name])<HR>"

	if(src.locked && (!issilicon(user)))
		t += "<I>(Swipe ID card to unlock control panel.)</I><BR>"
	else
		t += text("Turrets [] - <A href='byond://?src=\ref[];toggleOn=1'>[]?</a><br>\n", src.enabled?"activated":"deactivated", src, src.enabled?"Disable":"Enable")
		t += text("Currently set for [] - <A href='byond://?src=\ref[];toggleLethal=1'>Change to []?</a><br>\n", src.lethal?"lethal":"stun repeatedly", src,  src.lethal?"Stun repeatedly":"Lethal")

	user << browse(t, "window=turretid")
	onclose(user, "turretid")


/obj/machinery/turret/attack_animal(mob/living/M)
	if(M.melee_damage_upper == 0)
		return
	if(!(stat & BROKEN))
		visible_message(SPAN_DANGER("[M] [M.attacktext] [src]!"))
		M.attack_log += "\[[time_stamp()]\] <font color='red'>attacked [src.name]</font>"
		//src.attack_log += "\[[time_stamp()]\] <font color='orange'>was attacked by [M.name] ([M.ckey])</font>"
		src.health -= M.melee_damage_upper
		if(src.health <= 0)
			src.die()
	else
		to_chat(M, SPAN_WARNING("That object is useless to you."))
	return

/obj/machinery/turretid/Topic(href, href_list)
	..()
	if(src.locked)
		if(!issilicon(usr))
			to_chat(usr, "Control panel is locked!")
			return
	if(get_dist(src, usr) == 0 || issilicon(usr))
		if(href_list["toggleOn"])
			src.enabled = !src.enabled
			src.updateTurrets()
		else if(href_list["toggleLethal"])
			src.lethal = !src.lethal
			src.updateTurrets()
	src.attack_hand(usr)

/obj/machinery/turretid/proc/updateTurrets()
	if(control_area)
		for(var/obj/machinery/turret/aTurret in get_area_all_atoms(control_area))
			aTurret.setState(enabled, lethal)
	src.update_icons()

/obj/machinery/turretid/proc/update_icons()
	if(src.enabled)
		if(src.lethal)
			icon_state = "motion1"
		else
			icon_state = "motion3"
	else
		icon_state = "motion0"
																				//CODE FIXED BUT REMOVED
//	if(control_area)															//USE: updates other controls in the area
//		for (var/obj/machinery/turretid/Turret_Control in GLOBL.machines)		//I'm not sure if this is what it was
//			if( Turret_Control.control_area != src.control_area )	continue	//supposed to do. Or whether the person
//			Turret_Control.icon_state = icon_state								//who coded it originally was just tired
//			Turret_Control.enabled = enabled									//or something. I don't see  any situation
//			Turret_Control.lethal = lethal										//in which this would be used on the current map.
																				//If he wants it back he can uncomment it


/obj/structure/turret/gun_turret
	name = "Gun Turret"
	density = TRUE
	anchored = TRUE
	var/cooldown = 20
	var/projectiles = 100
	var/projectiles_per_shot = 2
	var/deviation = 0.3
	var/list/exclude = list()
	var/atom/cur_target
	var/scan_range = 7
	var/health = 40
	var/list/scan_for = list("human" = 0, "cyborg" = 0, "mecha" = 0, "alien" = 1)
	var/on = 0
	icon = 'icons/obj/turrets.dmi'
	icon_state = "gun_turret"

/obj/structure/turret/gun_turret/proc/take_damage(damage)
	src.health -= damage
	if(src.health <= 0)
		qdel(src)
	return

/obj/structure/turret/gun_turret/bullet_act(obj/item/projectile/Proj)
	take_damage(Proj.damage)
	..()
	return

/obj/structure/turret/gun_turret/ex_act()
	qdel(src)
	return

/obj/structure/turret/gun_turret/emp_act()
	qdel(src)
	return

/obj/structure/turret/gun_turret/meteorhit()
	qdel(src)
	return

/obj/structure/turret/gun_turret/attack_hand(mob/user)
	user.set_machine(src)
	var/dat = {"<html>
					<head><title>[src] Control</title></head>
					<body>
					<b>Power: </b><a href='byond://?src=\ref[src];power=1'>[on?"on":"off"]</a><br>
					<b>Scan Range: </b><a href='byond://?src=\ref[src];scan_range=-1'>-</a> [scan_range] <a href='byond://?src=\ref[src];scan_range=1'>+</a><br>
					<b>Scan for: </b>"}
	for(var/scan in scan_for)
		dat += "<div style=\"margin-left: 15px;\">[scan] (<a href='byond://?src=\ref[src];scan_for=[scan]'>[scan_for[scan]?"Yes":"No"]</a>)</div>"

	dat += {"<b>Ammo: </b>[max(0, projectiles)]<br>
				</body>
				</html>"}
	user << browse(dat, "window=turret")
	onclose(user, "turret")
	return

/obj/structure/turret/gun_turret/attack_ai(mob/user)
	return attack_hand(user)

/obj/structure/turret/gun_turret/Topic(href, href_list)
	if(href_list["power"])
		src.on = !src.on
		if(src.on)
			spawn(50)
				if(src)
					src.process()
	if(href_list["scan_range"])
		scan_range = clamp(scan_range + text2num(href_list["scan_range"]), 1, 8)
	if(href_list["scan_for"])
		if(href_list["scan_for"] in scan_for)
			scan_for[href_list["scan_for"]] = !scan_for[href_list["scan_for"]]
	src.updateUsrDialog()
	return

/obj/structure/turret/gun_turret/proc/validate_target(atom/target)
	if(get_dist(target, src) > scan_range)
		return 0
	if(ismob(target))
		var/mob/M = target
		if(!M.stat && !M.lying)	//ninjas can't catch you if you're lying
			return 1
	else if(ismecha(target))
		return 1
	return 0

/obj/structure/turret/gun_turret/process()
	spawn()
		while(on)
			if(projectiles <= 0)
				on = 0
				return
			if(cur_target && !validate_target(cur_target))
				cur_target = null
			if(!cur_target)
				cur_target = get_target()
			fire(cur_target)
			sleep(cooldown)
	return

/obj/structure/turret/gun_turret/proc/get_target()
	var/list/pos_targets = list()
	var/target = null
	if(scan_for["human"])
		for(var/mob/living/carbon/human/M in oview(scan_range, src))
			if(M.stat || M.lying || (M in exclude))
				continue
			pos_targets += M
	if(scan_for["cyborg"])
		for(var/mob/living/silicon/M in oview(scan_range, src))
			if(M.stat || M.lying || (M in exclude))
				continue
			pos_targets += M
	if(scan_for["mecha"])
		for(var/obj/mecha/M in oview(scan_range, src))
			if(M in exclude)
				continue
			pos_targets += M
	if(scan_for["alien"])
		for(var/mob/living/carbon/alien/M in oview(scan_range, src))
			if(M.stat || M.lying || (M in exclude))
				continue
			pos_targets += M
	if(length(pos_targets))
		target = pick(pos_targets)
	return target

/obj/structure/turret/gun_turret/proc/fire(atom/target)
	if(!target)
		cur_target = null
		return
	src.set_dir(get_dir(src, target))
	var/turf/targloc = GET_TURF(target)
	var/target_x = targloc.x
	var/target_y = targloc.y
	var/target_z = targloc.z
	targloc = null
	spawn()
		for(var/i = 1 to min(projectiles, projectiles_per_shot))
			if(!src)
				break
			var/turf/curloc = GET_TURF(src)
			targloc = locate(target_x + GaussRandRound(deviation, 1), target_y + GaussRandRound(deviation, 1), target_z)
			if(isnull(targloc) || isnull(curloc))
				continue
			if(targloc == curloc)
				continue
			playsound(src, 'sound/weapons/gun/gunshot.ogg', 50, 1)
			var/obj/item/projectile/A = new /obj/item/projectile(curloc)
			src.projectiles--
			A.current = curloc
			A.yo = targloc.y - curloc.y
			A.xo = targloc.x - curloc.x
			A.process()
			sleep(2)
	return