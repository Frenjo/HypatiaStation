/*
		Portable Turrets:

		Constructed from metal, a gun of choice, and a prox sensor.
		Gun can be a taser or laser or energy gun.

		This code is slightly more documented than normal, as requested by XSI on IRC.

*/

/obj/machinery/porta_turret
	name = "turret"
	icon = 'icons/obj/turrets.dmi'
	icon_state = "grey_target_prism"
	anchored = TRUE
	layer = 3
	invisibility = INVISIBILITY_LEVEL_TWO		// the turret is invisible if it's inside its cover
	density = TRUE

	// This turret uses and requires power.
	// Drains power from the EQUIP channel.
	power_usage = alist(
		USE_POWER_IDLE = 50, // When inactive, this turret takes up constant 50 equipment power.
		USE_POWER_ACTIVE = 300 // When active, this turret takes up constant 300 equipment power.
	)

	req_access = list(ACCESS_SECURITY)

	var/lasercolor = ""		// Something to do with lasertag turrets, blame Sieve for not adding a comment.
	var/raised = 0			// if the turret cover is "open" and the turret is raised
	var/raising= 0			// if the turret is currently opening or closing its cover
	var/health = 80			// the turret's health
	var/locked = 1			// if the turret's behaviour control access is locked

	var/installation		// the type of weapon installed
	var/gun_charge = 0		// the charge of the gun inserted
	var/projectile = null	//holder for bullettype
	var/eprojectile = null//holder for the shot when emagged
	var/reqpower = 0 //holder for power needed
	var/sound = null//So the taser can have sound
	var/iconholder = null//holder for the icon_state
	var/egun = null//holder to handle certain guns switching bullettypes

	var/obj/machinery/porta_turret_cover/cover = null	// the cover that is covering this turret
	var/last_fired = 0		// 1: if the turret is cooling down from a shot, 0: turret is ready to fire
	var/shot_delay = 15		// 1.5 seconds between each shot

	var/check_records = 1	// checks if it can use the security records
	var/criminals = 1		// checks if it can shoot people on arrest
	var/auth_weapons = 0	// checks if it can shoot people that have a weapon they aren't authorized to have
	var/stun_all = 0		// if this is active, the turret shoots everything that isn't security or head of staff
	var/check_anomalies = 1	// checks if it can shoot at unidentified lifeforms (ie xenos)
	var/ai		 = 0 		// if active, will shoot at anything not an AI or cyborg

	var/attacked = 0		// if set to 1, the turret gets pissed off and shoots at people nearby (unless they have sec access!)

	//var/emagged = 0			// 1: emagged, 0: not emagged
	var/on = 1				// determines if the turret is on
	var/disabled = 0

	var/datum/effect/system/spark_spread/spark_system // the spark system, used for generating... sparks?

/obj/machinery/porta_turret/New()
	..()
	icon_state = "[lasercolor]grey_target_prism"
	// Sets up a spark system
	spark_system = new /datum/effect/system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	sleep(10)
	if(!installation)// if for some reason the turret has no gun (ie, admin spawned) it resorts to basic taser shots
		projectile = /obj/item/projectile/energy/electrode	//holder for the projectile, here it is being set
		eprojectile = /obj/item/projectile/energy/beam/laser	//holder for the projectile when emagged, if it is different
		reqpower = 200
		sound = 1
		iconholder = 1
	else
		var/obj/item/gun/energy/E = installation	//All energy-based weapons are applicable
		switch(E.type)
			if(/obj/item/gun/energy/laser/tag/blue)
				projectile = /obj/item/projectile/energy/beam/laser/tag/blue
				eprojectile = /obj/item/projectile/energy/beam/laser/tag/omni//This bolt will stun ERRYONE with a vest
				iconholder = null
				reqpower = 100
				lasercolor = "b"
				req_access = list(ACCESS_MAINT_TUNNELS)
				check_records = 0
				criminals = 0
				auth_weapons = 1
				stun_all = 0
				check_anomalies = 0
				shot_delay = 30

			if(/obj/item/gun/energy/laser/tag/red)
				projectile = /obj/item/projectile/energy/beam/laser/tag/red
				eprojectile = /obj/item/projectile/energy/beam/laser/tag/omni
				iconholder = null
				reqpower = 100
				lasercolor = "r"
				req_access = list(ACCESS_MAINT_TUNNELS)
				check_records = 0
				criminals = 0
				auth_weapons = 1
				stun_all = 0
				check_anomalies = 0
				shot_delay = 30

			if(/obj/item/gun/energy/laser/practice)
				projectile = /obj/item/projectile/energy/beam/laser/practice
				eprojectile = /obj/item/projectile/energy/beam/laser
				iconholder = null
				reqpower = 100

			if(/obj/item/gun/energy/pulse_rifle)
				projectile = /obj/item/projectile/energy/beam/pulse
				eprojectile = projectile
				iconholder = null
				reqpower = 700

			if(/obj/item/gun/energy/staff)
				projectile = /obj/item/projectile/change
				eprojectile = projectile
				iconholder = 1
				reqpower = 700

			if(/obj/item/gun/energy/ion)
				projectile = /obj/item/projectile/ion
				eprojectile = projectile
				iconholder = 1
				reqpower = 700

			if(/obj/item/gun/energy/taser)
				projectile = /obj/item/projectile/energy/electrode
				eprojectile = projectile
				iconholder = 1
				reqpower = 200

			if(/obj/item/gun/energy/stunrevolver)
				projectile = /obj/item/projectile/energy/electrode
				eprojectile = projectile
				iconholder = 1
				reqpower = 200

			if(/obj/item/gun/energy/lasercannon)
				projectile = /obj/item/projectile/energy/beam/laser/heavy
				eprojectile = projectile
				iconholder = null
				reqpower = 600

			if(/obj/item/gun/energy/decloner)
				projectile = /obj/item/projectile/energy/declone
				eprojectile = projectile
				iconholder = null
				reqpower = 600

			if(/obj/item/gun/energy/crossbow/largecrossbow)
				projectile = /obj/item/projectile/energy/bolt/large
				eprojectile = projectile
				iconholder = null
				reqpower = 125

			if(/obj/item/gun/energy/crossbow)
				projectile = /obj/item/projectile/energy/bolt
				eprojectile = projectile
				iconholder = null
				reqpower = 50

			if(/obj/item/gun/energy/laser)
				projectile = /obj/item/projectile/energy/beam/laser
				eprojectile = projectile
				iconholder = null
				reqpower = 500

			else // Energy gun shots
				projectile = /obj/item/projectile/energy/electrode	// if it hasn't been emagged, it uses normal taser shots
				eprojectile = /obj/item/projectile/energy/beam/laser	//If it has, going to kill mode
				iconholder = 1
				egun = 1
				reqpower = 200

/obj/machinery/porta_turret/Destroy()
	// deletes its own cover with it
	QDEL_NULL(cover)
	return ..()

/obj/machinery/porta_turret/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/porta_turret/attack_hand(mob/user)
	. = ..()
	if (.)
		return
	var/dat

	// The browse() text, similar to ED-209s and beepskies.
	if(!(src.lasercolor))//Lasertag turrets have less options
		dat += text({"
<TT><B>Automatic Portable Turret Installation</B></TT><BR><BR>
Status: []<BR>
Behaviour controls are [src.locked ? "locked" : "unlocked"]"},

"<A href='byond://?src=\ref[src];power=1'>[src.on ? "On" : "Off"]</A>" )

		if(!src.locked)
			dat += text({"<BR>
Check for Weapon Authorisation: []<BR>
Check Security Records: []<BR>
Neutralize Identified Criminals: []<BR>
Neutralize All Non-Security and Non-Command Personnel: []<BR>
Neutralize All Unidentified Life Signs: []<BR>"},

"<A href='byond://?src=\ref[src];operation=authweapon'>[src.auth_weapons ? "Yes" : "No"]</A>",
"<A href='byond://?src=\ref[src];operation=checkrecords'>[src.check_records ? "Yes" : "No"]</A>",
"<A href='byond://?src=\ref[src];operation=shootcrooks'>[src.criminals ? "Yes" : "No"]</A>",
"<A href='byond://?src=\ref[src];operation=shootall'>[stun_all ? "Yes" : "No"]</A>",
"<A href='byond://?src=\ref[src];operation=checkxenos'>[check_anomalies ? "Yes" : "No"]</A>" )
	else
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(((src.lasercolor) == "b") && (istype(H.wear_suit, /obj/item/clothing/suit/laser_tag/red)))
				return
			if(((src.lasercolor) == "r") && (istype(H.wear_suit, /obj/item/clothing/suit/laser_tag/blue)))
				return
		dat += text({"
<TT><B>Automatic Portable Turret Installation</B></TT><BR><BR>
Status: []<BR>"},

"<A href='byond://?src=\ref[src];power=1'>[src.on ? "On" : "Off"]</A>" )


	user << browse("<HEAD><TITLE>Automatic Portable Turret Installation</TITLE></HEAD>[dat]", "window=autosec")
	onclose(user, "autosec")
	return

/obj/machinery/porta_turret/Topic(href, href_list)
	if (..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)
	if ((href_list["power"]) && (src.allowed(usr)))
		if(anchored) // you can't turn a turret on/off if it's not anchored/secured
			on = !on // toggle on/off
		else
			usr << "\red It has to be secured first!"

		updateUsrDialog()
		return

	switch(href_list["operation"])
		// toggles customizable behavioural protocols
		if ("authweapon")
			src.auth_weapons = !src.auth_weapons
		if ("checkrecords")
			src.check_records = !src.check_records
		if ("shootcrooks")
			src.criminals = !src.criminals
		if("shootall")
			stun_all = !stun_all
	updateUsrDialog()

/obj/machinery/porta_turret/power_change()
	if(!anchored)
		icon_state = "turretCover"
		return
	if(stat & BROKEN)
		icon_state = "[lasercolor]destroyed_target_prism"
	else
		if( powered() )
			if (on)
				if (installation == /obj/item/gun/energy/laser || installation == /obj/item/gun/energy/pulse_rifle)
					// laser guns and pulse rifles have an orange icon
					icon_state = "[lasercolor]orange_target_prism"
				else
					// anything else has a blue icon
					icon_state = "[lasercolor]target_prism"
			else
				icon_state = "[lasercolor]grey_target_prism"
			stat &= ~NOPOWER
		else
			spawn(rand(0, 15))
				src.icon_state = "[lasercolor]grey_target_prism"
				stat |= NOPOWER

/obj/machinery/porta_turret/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(stat & (BROKEN | NOPOWER))
		FEEDBACK_MACHINE_UNRESPONSIVE(user)
		return FALSE
	if(emagged)
		FEEDBACK_ALREADY_EMAGGED(user)
		return FALSE

	// Emagging the turret makes it go bonkers and stun everyone. It also makes the turret shoot much, much faster.
	to_chat(user, SPAN_WARNING("You short out the [src]'s threat assessment circuits."))
	visible_message(SPAN_WARNING("[src] hums oddly..."))
	emagged = TRUE
	on = FALSE // Temporarily turns the turret off.
	spawn(6 SECONDS) // 6 seconds for the traitor to gtfo of the area before the turret decides to ruin his shit.
		on = TRUE // Turns it back on. The cover popUp() popDown() are automatically called in process(), no need to call them here.
	return TRUE

/obj/machinery/porta_turret/attackby(obj/item/W, mob/user)
	if(stat & BROKEN)
		if(iscrowbar(W))

			// If the turret is destroyed, you can remove it with a crowbar to
			// try and salvage its components
			user << "You begin prying the metal coverings off."
			sleep(20)
			if(prob(70))
				user << "You remove the turret and salvage some components."
				if(installation)
					var/obj/item/gun/energy/Gun = new installation(src.loc)
					Gun.power_supply.charge=gun_charge
					Gun.update_icon()
					lasercolor = null
				if(prob(50))
					new /obj/item/stack/sheet/steel(loc, rand(1, 4))
				if(prob(50))
					new /obj/item/assembly/prox_sensor(locate(x,y,z))
			else
				user << "You remove the turret but did not manage to salvage anything."
			qdel(src)

	if(iswrench(W) && (!on))
		if(raised) return
		// This code handles moving the turret around. After all, it's a portable turret!

		if(!anchored)
			anchored = TRUE
			invisibility = INVISIBILITY_LEVEL_TWO
			icon_state = "[lasercolor]grey_target_prism"
			user << "You secure the exterior bolts on the turret."
			cover=new/obj/machinery/porta_turret_cover(src.loc) // create a new turret. While this is handled in process(), this is to workaround a bug where the turret becomes invisible for a split second
			cover.Parent_Turret = src // make the cover's parent src
		else
			anchored = FALSE
			user << "You unsecure the exterior bolts on the turret."
			icon_state = "turretCover"
			invisibility = 0
			qdel(cover) // deletes the cover, and the turret instance itself becomes its own cover.

	else if (istype(W, /obj/item/card/id)||istype(W, /obj/item/pda))
		// Behavior lock/unlock mangement
		if (allowed(user))
			locked = !src.locked
			FEEDBACK_TOGGLE_CONTROLS_LOCK(user, locked)
		else
			FEEDBACK_ACCESS_DENIED(user)

	else
		// if the turret was attacked with the intention of harming it:
		src.health -= W.force * 0.5
		if (src.health <= 0)
			src.die()
		if ((W.force * 0.5) > 1) // if the force of impact dealt at least 1 damage, the turret gets pissed off
			if(!attacked && !emagged)
				attacked = 1
				spawn()
					sleep(60)
					attacked = 0
		..()

/obj/machinery/porta_turret/bullet_act(var/obj/item/projectile/Proj)
	if(on)
		if(!attacked && !emagged)
			attacked = 1
			spawn()
				sleep(60)
				attacked = 0

	src.health -= Proj.damage
	..()
	if(prob(45) && Proj.damage > 0) src.spark_system.start()
	if (src.health <= 0)
		src.die() // the death process :(
	if((src.lasercolor == "b") && (src.disabled == 0))
		if(istype(Proj, /obj/item/projectile/energy/beam/laser/tag/red))
			src.disabled = 1
			qdel (Proj)
			sleep(100)
			src.disabled = 0
	if((src.lasercolor == "r") && (src.disabled == 0))
		if(istype(Proj, /obj/item/projectile/energy/beam/laser/tag/blue))
			src.disabled = 1
			qdel (Proj)
			sleep(100)
			src.disabled = 0
	return

/obj/machinery/porta_turret/emp_act(severity)
	if(on)
		// if the turret is on, the EMP no matter how severe disables the turret for a while
		// and scrambles its settings, with a slight chance of having an emag effect
		check_records=pick(0,1)
		criminals=pick(0,1)
		auth_weapons=pick(0,1)
		stun_all=pick(0,0,0,0,1) // stun_all is a pretty big deal, so it's least likely to get turned on
		if(prob(5)) emagged=1
		on=0
		sleep(rand(60,600))
		if(!on)
			on=1

	..()

/obj/machinery/porta_turret/ex_act(severity)
	if(severity >= 3) // turret dies if an explosion touches it!
		qdel(src)
	else
		src.die()

/obj/machinery/porta_turret/proc/die() // called when the turret dies, ie, health <= 0
	src.health = 0
	src.density = FALSE
	src.stat |= BROKEN // enables the BROKEN bit
	src.icon_state = "[lasercolor]destroyed_target_prism"
	invisibility = 0
	src.spark_system.start() // creates some sparks because they look cool
	src.density = TRUE
	qdel(cover) // deletes the cover - no need on keeping it there!

/obj/machinery/porta_turret/process()
	// the main machinery process

	set background = BACKGROUND_ENABLED

	if(src.cover==null && anchored) // if it has no cover and is anchored
		if (stat & BROKEN) // if the turret is borked
			qdel(cover) // delete its cover, assuming it has one. Workaround for a pesky little bug
		else

			src.cover = new /obj/machinery/porta_turret_cover(src.loc) // if the turret has no cover and is anchored, give it a cover
			src.cover.Parent_Turret = src // assign the cover its Parent_Turret, which would be this (src)

	if(stat & (NOPOWER|BROKEN))
		// if the turret has no power or is broken, make the turret pop down if it hasn't already
		popDown()
		return

	if(!on)
		// if the turret is off, make it pop down
		popDown()
		return

	var/list/targets = list()		   // list of primary targets
	var/list/secondarytargets = list() // targets that are least important

	if(src.check_anomalies) // if its set to check for xenos/carps, check for non-mob "crittersssss"(And simple_animals)
		for(var/mob/living/simple/C in view(7,src))
			if(!C.stat)
				targets += C

	for (var/mob/living/carbon/C in view(7,src)) // loops through all living carbon-based lifeforms in view(12)
		if(isalien(C) && src.check_anomalies) // git those fukken xenos
			if(!C.stat) // if it's dead/dying, there's no need to keep shooting at it.
				targets += C

		else
			if(emagged) // if emagged, HOLY SHIT EVERYONE IS DANGEROUS beep boop beep
				targets += C
			else
				if (C.stat || C.handcuffed) // if the perp is handcuffed or dead/dying, no need to bother really
					continue // move onto next potential victim!

				var/dst = get_dist(src, C) // if it's too far away, why bother?
				if (dst > 7)
					continue

				if(ai) // If it's set to attack all nonsilicons, target them!
					if(C.lying)
						if(lasercolor)
							continue
						else
							secondarytargets += C
							continue
					else
						targets += C
						continue

				if(ishuman(C)) // if the target is a human, analyse threat level
					if(src.assess_perp(C)<4)
						continue // if threat level < 4, keep going

				else if(ismonkey(C))
					continue // Don't target monkeys or borgs/AIs you dumb shit

				if (C.lying) // if the perp is lying down, it's still a target but a less-important target
					secondarytargets += C
					continue

				targets += C // if the perp has passed all previous tests, congrats, it is now a "shoot-me!" nominee

	if(length(targets)) // if there are targets to shoot

		var/atom/t = pick(targets) // pick a perp from the list of targets. Targets go first because they are the most important

		if(isliving(t)) // if a mob
			var/mob/living/M = t // simple typecasting
			if (M.stat!=2) // if the target is not dead
				spawn() popUp() // pop the turret up if it's not already up.
				dir=get_dir(src,M) // even if you can't shoot, follow the target
				spawn() shootAt(M) // shoot the target, finally

	else
		if(length(secondarytargets)) // if there are no primary targets, go for secondary targets
			var/mob/t = pick(secondarytargets)
			if(isliving(t))
				if (t.stat!=2)
					spawn() popUp()
					dir=get_dir(src,t)
					shootAt(t)
		else
			spawn() popDown()

/obj/machinery/porta_turret/proc/popUp() // pops the turret up
	if(disabled)
		return
	if(raising || raised)
		return
	if(stat & BROKEN)
		return
	invisibility = 0
	raising = 1
	flick("popup", cover)
	sleep(5)
	sleep(5)
	raising = 0
	cover.icon_state = "openTurretCover"
	raised = 1
	layer = 4

/obj/machinery/porta_turret/proc/popDown() // pops the turret down
	if(disabled)
		return
	if(raising || !raised)
		return
	if(stat & BROKEN)
		return
	layer = 3
	raising = 1
	flick("popdown", cover)
	sleep(10)
	raising = 0
	cover.icon_state = "turretCover"
	raised = 0
	invisibility = 2
	icon_state = "[lasercolor]grey_target_prism"

/obj/machinery/porta_turret/proc/assess_perp(mob/living/carbon/human/perp)
	var/threatcount = 0 // the integer returned

	if(src.emagged) return 10 // if emagged, always return 10.

	if((stun_all && !src.allowed(perp)) || attacked && !src.allowed(perp))
		// if the turret has been attacked or is angry, target all non-sec people
		if(!src.allowed(perp))
			return 10

	if(auth_weapons) // check for weapon authorisation
		if((isnull(perp.id_store)) || (istype(perp.id_store.get_id(), /obj/item/card/id/syndicate)))

			if((src.allowed(perp)) && !(src.lasercolor)) // if the perp has security access, return 0
				return 0

			if((istype(perp.l_hand, /obj/item/gun) && !istype(perp.l_hand, /obj/item/gun/projectile/shotgun)) || istype(perp.l_hand, /obj/item/melee/baton))
				threatcount += 4

			if((istype(perp.r_hand, /obj/item/gun) && !istype(perp.r_hand, /obj/item/gun/projectile/shotgun)) || istype(perp.r_hand, /obj/item/melee/baton))
				threatcount += 4

			if(istype(perp.belt, /obj/item/gun) || istype(perp.belt, /obj/item/melee/baton))
				threatcount += 2

	if((src.lasercolor) == "b")//Lasertag turrets target the opposing team, how great is that? -Sieve
		threatcount = 0//But does not target anyone else
		if(istype(perp.wear_suit, /obj/item/clothing/suit/laser_tag/red))
			threatcount += 4
		if((istype(perp.r_hand,/obj/item/gun/energy/laser/tag/red)) || (istype(perp.l_hand,/obj/item/gun/energy/laser/tag/red)))
			threatcount += 4
		if(istype(perp.belt, /obj/item/gun/energy/laser/tag/red))
			threatcount += 2

	if((src.lasercolor) == "r")
		threatcount = 0
		if(istype(perp.wear_suit, /obj/item/clothing/suit/laser_tag/blue))
			threatcount += 4
		if((istype(perp.r_hand,/obj/item/gun/energy/laser/tag/blue)) || (istype(perp.l_hand,/obj/item/gun/energy/laser/tag/blue)))
			threatcount += 4
		if(istype(perp.belt, /obj/item/gun/energy/laser/tag/blue))
			threatcount += 2

	if (src.check_records) // if the turret can check the records, check if they are set to *Arrest* on records
		for_no_type_check(var/datum/data/record/E, GLOBL.data_core.general)

			var/perpname = perp.name
			if(isnotnull(perp.id_store))
				var/obj/item/card/id/id = perp.id_store.get_id()
				if(isnotnull(id))
					perpname = id.registered_name

			if (E.fields["name"] == perpname)
				for_no_type_check(var/datum/data/record/R, GLOBL.data_core.security)
					if ((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "*Arrest*"))
						threatcount = 4
						break



	return threatcount





/obj/machinery/porta_turret/proc/shootAt(var/atom/movable/target) // shoots at a target
	if(disabled)
		return

	if(lasercolor && ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.lying)
			return

	if(!emagged) // if it hasn't been emagged, it has to obey a cooldown rate
		if(last_fired || !raised) return // prevents rapid-fire shooting, unless it's been emagged
		last_fired = 1
		spawn()
			sleep(shot_delay)
			last_fired = 0

	var/turf/T = GET_TURF(src)
	var/turf/U = GET_TURF(target)
	if(!istype(T) || !istype(U))
		return

	if (!raised) // the turret has to be raised in order to fire - makes sense, right?
		return


	// any emagged turrets will shoot extremely fast! This not only is deadly, but drains a lot power!

	if(iconholder)
		icon_state = "[lasercolor]target_prism"
	else
		icon_state = "[lasercolor]orange_target_prism"
	if(sound)
		playsound(src, 'sound/weapons/gun/taser.ogg', 75, 1)
	var/obj/item/projectile/A
	if(emagged)
		A = new eprojectile( loc )
	else
		A = new projectile( loc )
	A.original = target.loc
	if(!emagged)
		use_power(reqpower)
	else
		use_power((reqpower*2))
		// Shooting Code:
	A.current = T
	A.starting = T
	A.yo = U.y - T.y
	A.xo = U.x - T.x
	spawn( 1 )
		A.process()
	return



/*

		Portable turret constructions

		Known as "turret frame"s

*/

/obj/machinery/porta_turret_construct
	name = "turret frame"
	icon = 'icons/obj/turrets.dmi'
	icon_state = "turret_frame"
	density=1
	var/build_step = 0 // the current step in the building process
	var/finish_name="turret" // the name applied to the product turret
	var/installation = null // the gun type installed
	var/gun_charge = 0 // the gun charge of the gun type installed



/obj/machinery/porta_turret_construct/attackby(obj/item/W, mob/user)

	// this is a bit unweildy but self-explanitory
	switch(build_step)
		if(0) // first step
			if(iswrench(W) && !anchored)
				playsound(src, 'sound/items/Ratchet.ogg', 100, 1)
				user << "\blue You secure the external bolts."
				anchored = TRUE
				build_step = 1
				return

			else if(iscrowbar(W) && !anchored)
				playsound(src, 'sound/items/Crowbar.ogg', 75, 1)
				user << "You dismantle the turret construction."
				new /obj/item/stack/sheet/steel(loc, 5)
				qdel(src)
				return

		if(1)
			if(istype(W, /obj/item/stack/sheet/steel))
				if(W:amount>=2) // requires 2 steel sheets
					user << "\blue You add some steel armor to the interior frame."
					build_step = 2
					W:amount -= 2
					icon_state = "turret_frame2"
					if(W:amount <= 0)
						qdel(W)
					return

			else if(iswrench(W))
				playsound(src, 'sound/items/Ratchet.ogg', 75, 1)
				user << "You unfasten the external bolts."
				anchored = FALSE
				build_step = 0
				return


		if(2)
			if(iswrench(W))
				playsound(src, 'sound/items/Ratchet.ogg', 100, 1)
				user << "\blue You bolt the metal armor into place."
				build_step = 3
				return

			else if(iswelder(W))
				var/obj/item/weldingtool/WT = W
				if(!WT.isOn()) return
				if (WT.get_fuel() < 5) // uses up 5 fuel.
					user << "\red You need more fuel to complete this task."
					return

				playsound(src, pick('sound/items/Welder.ogg', 'sound/items/Welder2.ogg'), 50, 1)
				if(do_after(user, 20))
					if(!src || !WT.remove_fuel(5, user)) return
					build_step = 1
					user << "You remove the turret's interior steel armor."
					new /obj/item/stack/sheet/steel(loc, 2)
					return


		if(3)
			if(istype(W, /obj/item/gun/energy)) // the gun installation part

				var/obj/item/gun/energy/E = W // typecasts the item to an energy gun
				installation = W.type // installation becomes W.type
				gun_charge = E.power_supply.charge // the gun's charge is stored in src.gun_charge
				user << "\blue You add \the [W] to the turret."
				build_step = 4
				qdel(W) // delete the gun :(
				return

			else if(iswrench(W))
				playsound(src, 'sound/items/Ratchet.ogg', 100, 1)
				user << "You remove the turret's metal armor bolts."
				build_step = 2
				return

		if(4)
			if(isprox(W))
				build_step = 5
				user << "\blue You add the prox sensor to the turret."
				qdel(W)
				return

			// attack_hand() removes the gun

		if(5)
			if(isscrewdriver(W))
				playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
				build_step = 6
				user << "\blue You close the internal access hatch."
				return

			// attack_hand() removes the prox sensor

		if(6)
			if(istype(W, /obj/item/stack/sheet/steel))
				if(W:amount>=2)
					user << "\blue You add some steel armor to the exterior frame."
					build_step = 7
					W:amount -= 2
					if(W:amount <= 0)
						qdel(W)
					return

			else if(isscrewdriver(W))
				playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
				build_step = 5
				user << "You open the internal access hatch."
				return

		if(7)
			if(iswelder(W))
				var/obj/item/weldingtool/WT = W
				if(!WT.isOn()) return
				if (WT.get_fuel() < 5)
					user << "\red You need more fuel to complete this task."

				playsound(src, pick('sound/items/Welder.ogg', 'sound/items/Welder2.ogg'), 50, 1)
				if(do_after(user, 30))
					if(!src || !WT.remove_fuel(5, user)) return
					build_step = 8
					user << "\blue You weld the turret's armor down."

					// The final step: create a full turret
					var/obj/machinery/porta_turret/Turret = new/obj/machinery/porta_turret(locate(x,y,z))
					Turret.name = finish_name
					Turret.installation = src.installation
					Turret.gun_charge = src.gun_charge

//					Turret.cover=new/obj/machinery/porta_turret_cover(src.loc)
//					Turret.cover.Parent_Turret=Turret
//					Turret.cover.name = finish_name
					Turret.New()
					qdel(src)

			else if(iscrowbar(W))
				playsound(src, 'sound/items/Crowbar.ogg', 75, 1)
				user << "You pry off the turret's exterior armor."
				new /obj/item/stack/sheet/steel(loc, 2)
				build_step = 6
				return

	if (istype(W, /obj/item/pen)) // you can rename turrets like bots!
		var/t = input(user, "Enter new turret name", src.name, src.finish_name) as text
		t = copytext(sanitize(t), 1, MAX_MESSAGE_LEN)
		if (!t)
			return
		if (!in_range(src, usr) && src.loc != usr)
			return

		src.finish_name = t
		return
	..()



/obj/machinery/porta_turret_construct/attack_hand(mob/user)
	switch(build_step)
		if(4)
			if(!installation) return
			build_step = 3

			var/obj/item/gun/energy/Gun = new installation(src.loc)
			Gun.power_supply.charge=gun_charge
			Gun.update_icon()
			installation = null
			gun_charge = 0
			user << "You remove \the [Gun] from the turret frame."

		if(5)
			user << "You remove the prox sensor from the turret frame."
			new/obj/item/assembly/prox_sensor(locate(x,y,z))
			build_step = 4


/obj/machinery/porta_turret_cover
	name = "turret"
	icon = 'icons/obj/turrets.dmi'
	icon_state = "turretCover"
	anchored = TRUE
	layer = 3.5
	density = FALSE
	var/obj/machinery/porta_turret/Parent_Turret = null

/obj/machinery/porta_turret_cover/Destroy()
	Parent_Turret = null
	return ..()

// The below code is pretty much just recoded from the initial turret object. It's necessary but uncommented because it's exactly the same!

/obj/machinery/porta_turret_cover/attack_ai(mob/user)
	. = ..()
	if (.)
		return
	var/dat
	if(!(Parent_Turret.lasercolor))
		dat += text({"
<TT><B>Automatic Portable Turret Installation</B></TT><BR><BR>
Status: []<BR>
Behaviour controls are [Parent_Turret.locked ? "locked" : "unlocked"]"},

"<A href='byond://?src=\ref[src];power=1'>[Parent_Turret.on ? "On" : "Off"]</A>" )


		dat += text({"<BR>
Check for Weapon Authorisation: []<BR>
Check Security Records: []<BR>
Neutralize Identified Criminals: []<BR>
Neutralize All Non-Security and Non-Command Personnel: []<BR>
Neutralize All Unidentified Life Signs: []<BR>"},

"<A href='byond://?src=\ref[src];operation=authweapon'>[Parent_Turret.auth_weapons ? "Yes" : "No"]</A>",
"<A href='byond://?src=\ref[src];operation=checkrecords'>[Parent_Turret.check_records ? "Yes" : "No"]</A>",
"<A href='byond://?src=\ref[src];operation=shootcrooks'>[Parent_Turret.criminals ? "Yes" : "No"]</A>",
"<A href='byond://?src=\ref[src];operation=shootall'>[Parent_Turret.stun_all ? "Yes" : "No"]</A>" ,
"<A href='byond://?src=\ref[src];operation=checkxenos'>[Parent_Turret.check_anomalies ? "Yes" : "No"]</A>" )
	else
		dat += text({"
<TT><B>Automatic Portable Turret Installation</B></TT><BR><BR>
Status: []<BR>"},

"<A href='byond://?src=\ref[src];power=1'>[Parent_Turret.on ? "On" : "Off"]</A>" )

	user << browse("<HEAD><TITLE>Automatic Portable Turret Installation</TITLE></HEAD>[dat]", "window=autosec")
	onclose(user, "autosec")
	return

/obj/machinery/porta_turret_cover/attack_hand(mob/user)
	. = ..()
	if (.)
		return
	var/dat
	if(!(Parent_Turret.lasercolor))
		dat += text({"
<TT><B>Automatic Portable Turret Installation</B></TT><BR><BR>
Status: []<BR>
Behaviour controls are [Parent_Turret.locked ? "locked" : "unlocked"]"},

"<A href='byond://?src=\ref[src];power=1'>[Parent_Turret.on ? "On" : "Off"]</A>" )

		if(!Parent_Turret.locked)
			dat += text({"<BR>
Check for Weapon Authorisation: []<BR>
Check Security Records: []<BR>
Neutralize Identified Criminals: []<BR>
Neutralize All Non-Security and Non-Command Personnel: []<BR>
Neutralize All Unidentified Life Signs: []<BR>"},

"<A href='byond://?src=\ref[src];operation=authweapon'>[Parent_Turret.auth_weapons ? "Yes" : "No"]</A>",
"<A href='byond://?src=\ref[src];operation=checkrecords'>[Parent_Turret.check_records ? "Yes" : "No"]</A>",
"<A href='byond://?src=\ref[src];operation=shootcrooks'>[Parent_Turret.criminals ? "Yes" : "No"]</A>",
"<A href='byond://?src=\ref[src];operation=shootall'>[Parent_Turret.stun_all ? "Yes" : "No"]</A>" ,
"<A href='byond://?src=\ref[src];operation=checkxenos'>[Parent_Turret.check_anomalies ? "Yes" : "No"]</A>" )
	else
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(((Parent_Turret.lasercolor) == "b") && (istype(H.wear_suit, /obj/item/clothing/suit/laser_tag/red)))
				return
			if(((Parent_Turret.lasercolor) == "r") && (istype(H.wear_suit, /obj/item/clothing/suit/laser_tag/blue)))
				return
		dat += text({"
<TT><B>Automatic Portable Turret Installation</B></TT><BR><BR>
Status: []<BR>"},

"<A href='byond://?src=\ref[src];power=1'>[Parent_Turret.on ? "On" : "Off"]</A>" )



	user << browse("<HEAD><TITLE>Automatic Portable Turret Installation</TITLE></HEAD>[dat]", "window=autosec")
	onclose(user, "autosec")
	return

/obj/machinery/porta_turret_cover/Topic(href, href_list)
	if (..())
		return
	usr.set_machine(src)
	Parent_Turret.add_fingerprint(usr)
	src.add_fingerprint(usr)
	if ((href_list["power"]) && (Parent_Turret.allowed(usr)))
		if(Parent_Turret.anchored)
			if (Parent_Turret.on)
				Parent_Turret.on=0
			else
				Parent_Turret.on=1
		else
			usr << "\red It has to be secured first!"

		updateUsrDialog()
		return

	switch(href_list["operation"])
		if ("authweapon")
			Parent_Turret.auth_weapons = !Parent_Turret.auth_weapons
		if ("checkrecords")
			Parent_Turret.check_records = !Parent_Turret.check_records
		if ("shootcrooks")
			Parent_Turret.criminals = !Parent_Turret.criminals
		if("shootall")
			Parent_Turret.stun_all = !Parent_Turret.stun_all
		if("checkxenos")
			Parent_Turret.check_anomalies = !Parent_Turret.check_anomalies

	updateUsrDialog()



/obj/machinery/porta_turret_cover/attackby(obj/item/W, mob/user)

	if ((istype(W, /obj/item/card/emag)) && (!Parent_Turret.emagged))
		user << "\red You short out [Parent_Turret]'s threat assessment circuits."
		spawn(0)
			for(var/mob/O in hearers(Parent_Turret, null))
				O.show_message("\red [Parent_Turret] hums oddly...", 1)
		Parent_Turret.emagged = 1
		Parent_Turret.on = 0
		sleep(40)
		Parent_Turret.on = 1

	else if(iswrench(W) && (!Parent_Turret.on))
		if(Parent_Turret.raised) return

		if(!Parent_Turret.anchored)
			Parent_Turret.anchored = TRUE
			Parent_Turret.invisibility = INVISIBILITY_LEVEL_TWO
			Parent_Turret.icon_state = "grey_target_prism"
			user << "You secure the exterior bolts on the turret."
		else
			Parent_Turret.anchored = FALSE
			user << "You unsecure the exterior bolts on the turret."
			Parent_Turret.icon_state = "turretCover"
			Parent_Turret.invisibility = 0
			qdel(src)

	else if (istype(W, /obj/item/card/id)||istype(W, /obj/item/pda))
		if (Parent_Turret.allowed(user))
			Parent_Turret.locked = !Parent_Turret.locked
			FEEDBACK_TOGGLE_CONTROLS_LOCK(user, Parent_Turret.locked)
			updateUsrDialog()
		else
			FEEDBACK_ACCESS_DENIED(user)

	else
		Parent_Turret.health -= W.force * 0.5
		if (Parent_Turret.health <= 0)
			Parent_Turret.die()
		if ((W.force * 0.5) > 2)
			if(!Parent_Turret.attacked && !Parent_Turret.emagged)
				Parent_Turret.attacked = 1
				spawn()
					sleep(30)
					Parent_Turret.attacked = 0
		..()


/obj/machinery/porta_turret/stationary
	emagged = 1

/obj/machinery/porta_turret/stationary/New()
	installation = new/obj/item/gun/energy/laser(src.loc)
	..()