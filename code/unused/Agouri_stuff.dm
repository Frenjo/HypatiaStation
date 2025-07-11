/*
/obj/vehicle/airtight
	//inner atmos
	var/use_internal_tank = 0
	var/internal_tank_valve = ONE_ATMOSPHERE
	var/obj/machinery/portable_atmospherics/canister/internal_tank
	var/datum/gas_mixture/cabin_air
	var/obj/machinery/atmospherics/unary/portables_connector/connected_port = null

	var/datum/global_iterator/pr_int_temp_processor //normalizes internal air mixture temperature
	var/datum/global_iterator/pr_give_air //moves air from tank to cabin


/obj/vehicle/airtight/New()
	..()
	src.add_airtank()
	src.add_cabin()
	src.add_airtight_iterators()




//######################################### Helpers for airtight vehicles #########################################

/obj/vehicle/airtight/proc/add_cabin()
	cabin_air = new
	cabin_air.temperature = T20C
	cabin_air.volume = 200
	cabin_air.oxygen = O2STANDARD*cabin_air.volume/(R_IDEAL_GAS_EQUATION*cabin_air.temperature)
	cabin_air.nitrogen = N2STANDARD*cabin_air.volume/(R_IDEAL_GAS_EQUATION*cabin_air.temperature)
	return cabin_air

/obj/vehicle/airtight/proc/add_airtank()
	internal_tank = new /obj/machinery/portable_atmospherics/canister/air(src)
	return internal_tank

/obj/vehicle/airtight/proc/add_airtight_iterators()
	pr_int_temp_processor = new /datum/global_iterator/vehicle_preserve_temp(list(src))
	pr_give_air = new /datum/global_iterator/vehicle_tank_give_air(list(src))


//######################################### Specific datums for airtight vehicles #################################


/datum/global_iterator/vehicle_preserve_temp  //normalizing cabin air temperature to 20 degrees celsium
	delay = 20

	process(var/obj/vehicle/airtight/V)
		if(V.cabin_air && V.cabin_air.return_volume() > 0)
			var/delta = V.cabin_air.temperature - T20C
			V.cabin_air.temperature -= max(-10, min(10, round(delta/4,0.1)))
		return


/datum/global_iterator/vehicle_tank_give_air
	delay = 15

	process(var/obj/vehicle/airtight/V)
		if(V.internal_tank)
			var/datum/gas_mixture/tank_air = V.internal_tank.return_air()
			var/datum/gas_mixture/cabin_air = V.cabin_air

			var/release_pressure = V.internal_tank_valve
			var/cabin_pressure = cabin_air.return_pressure()
			var/pressure_delta = min(release_pressure - cabin_pressure, (tank_air.return_pressure() - cabin_pressure)/2)
			var/transfer_moles = 0
			if(pressure_delta > 0) //cabin pressure lower than release pressure
				if(tank_air.return_temperature() > 0)
					transfer_moles = pressure_delta*cabin_air.return_volume()/(cabin_air.return_temperature() * R_IDEAL_GAS_EQUATION)
					var/datum/gas_mixture/removed = tank_air.remove(transfer_moles)
					cabin_air.merge(removed)
			else if(pressure_delta < 0) //cabin pressure higher than release pressure
				var/datum/gas_mixture/t_air = V.get_turf_air()
				pressure_delta = cabin_pressure - release_pressure
				if(t_air)
					pressure_delta = min(cabin_pressure - t_air.return_pressure(), pressure_delta)
				if(pressure_delta > 0) //if location pressure is lower than cabin pressure
					transfer_moles = pressure_delta*cabin_air.return_volume()/(cabin_air.return_temperature() * R_IDEAL_GAS_EQUATION)
					var/datum/gas_mixture/removed = cabin_air.remove(transfer_moles)
					if(t_air)
						t_air.merge(removed)
					else //just delete the cabin gas, we're in space or some shit
						del(removed)
		else
			return stop()
		return


//######################################### Atmospherics for vehicles #############################################


/obj/vehicle/proc/get_turf_air()
	var/turf/T = GET_TURF(src)
	if(isnotnull(T))
		. = T.return_air()

/obj/vehicle/airtight/remove_air(amount)
	if(use_internal_tank)
		return cabin_air.remove(amount)
	else
		var/turf/T = GET_TURF(src)
		if(isnotnull(T))
			return T.remove_air(amount)
	return

/obj/vehicle/airtight/return_air()
	if(use_internal_tank)
		return cabin_air
	return get_turf_air()

/obj/vehicle/airtight/proc/return_pressure()
	. = 0
	if(use_internal_tank)
		. =  cabin_air.return_pressure()
	else
		var/datum/gas_mixture/t_air = get_turf_air()
		if(t_air)
			. = t_air.return_pressure()
	return


/obj/vehicle/airtight/proc/return_temperature()
	. = 0
	if(use_internal_tank)
		. = cabin_air.return_temperature()
	else
		var/datum/gas_mixture/t_air = get_turf_air()
		if(t_air)
			. = t_air.return_temperature()
	return

/obj/vehicle/airtight/proc/connect(obj/machinery/atmospherics/unary/portables_connector/new_port)
	//Make sure not already connected to something else
	if(connected_port || !new_port || new_port.connected_device)
		return 0

	//Make sure are close enough for a valid connection
	if(new_port.loc != src.loc)
		return 0

	//Perform the connection
	connected_port = new_port
	connected_port.connected_device = src

	//Actually enforce the air sharing
	var/datum/pipe_network/network = connected_port.return_network(src)
	if(network && !(internal_tank.return_air() in network.gases))
		network.gases += internal_tank.return_air()
		network.update = 1
	log_message("Vehicle airtank connected to external port.")
	return 1

/obj/vehicle/airtight/proc/disconnect()
	if(!connected_port)
		return 0

	var/datum/pipe_network/network = connected_port.return_network(src)
	if(network)
		network.gases -= internal_tank.return_air()

	connected_port.connected_device = null
	connected_port = null
	src.log_message("Vehicle airtank disconnected from external port.")
	return 1




/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////



/obj/vehicle
	name = "Vehicle"
	icon = 'icons/vehicles/vehicles.dmi'
	density = TRUE
	anchored = TRUE
	unacidable = 1 //To avoid the pilot-deleting shit that came with mechas
	layer = MOB_LAYER
	//var/can_move = 1
	var/mob/living/carbon/occupant = null
	//var/step_in = 10 //make a step in step_in/10 sec.
	//var/dir_in = 2//What direction will the mech face when entered/powered on? Defaults to South.
	//var/step_energy_drain = 10
	var/health = 300 //health is health
	//var/deflect_chance = 10 //chance to deflect the incoming projectiles, hits, or lesser the effect of ex_act.
	//the values in this list show how much damage will pass through, not how much will be absorbed.
	var/list/damage_absorption = list("brute"=0.8,"fire"=1.2,"bullet"=0.9,"laser"=1,"energy"=1,"bomb"=1)
	var/obj/item/cell/cell //Our power source
	var/state = 0
	var/list/log = new
	var/last_message = 0
	var/add_req_access = 1
	var/maint_access = 1
	//var/dna	//dna-locking the mech
	var/list/proc_res = list() //stores proc owners, like proc_res["functionname"] = owner reference
	var/datum/effect/system/spark_spread/spark_system = new
	var/lights = 0
	var/lights_power = 6

	//inner atmos 						//These go in airtight.dm, not all vehicles are space-faring -Agouri
	//var/use_internal_tank = 0
	//var/internal_tank_valve = ONE_ATMOSPHERE
	//var/obj/machinery/portable_atmospherics/canister/internal_tank
	//var/datum/gas_mixture/cabin_air
	//var/obj/machinery/atmospherics/unary/portables_connector/connected_port = null

	var/obj/item/radio/radio = null

	var/max_temperature = 2500
	//var/internal_damage_threshold = 50 //health percentage below which internal damage is possible
	var/internal_damage = 0 //contains bitflags

	var/list/operation_req_access = list()//required access level for mecha operation
	var/list/internals_req_access = list(access_engine,access_robotics)//required access level to open cell compartment

	//var/datum/global_iterator/pr_int_temp_processor //normalizes internal air mixture temperature     //In airtight.dm you go -Agouri
	var/datum/global_iterator/pr_inertial_movement //controls intertial movement in spesss

	//var/datum/global_iterator/pr_give_air //moves air from tank to cabin   //Y-you too -Agouri

	var/datum/global_iterator/pr_internal_damage //processes internal damage


	var/wreckage

	var/list/equipment = new
	var/obj/selected
	//var/max_equip = 3

	var/datum/events/events



/obj/vehicle/New()
	..()
	events = new
	icon_state += "-unmanned"
	add_radio()
	//add_cabin() //No cabin for non-airtights

	spark_system.set_up(2, 0, src)
	spark_system.attach(src)
	add_cell()
	add_iterators()
	removeVerb(/obj/mecha/verb/disconnect_from_port)
	removeVerb(/atom/movable/verb/pull)
	log_message("[src.name]'s functions initialised. Work protocols active - Entering IDLE mode.")
	loc.Entered(src)
	return


//################ Helpers ###########################################################


/obj/vehicle/proc/removeVerb(verb_path)
	verbs -= verb_path

/obj/vehicle/proc/addVerb(verb_path)
	verbs += verb_path

/*/obj/vehicle/proc/add_airtank() //In airtight.dm -Agouri
	internal_tank = new /obj/machinery/portable_atmospherics/canister/air(src)
	return internal_tank*/

/obj/vehicle/proc/add_cell(var/obj/item/cell/C=null)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new /obj/item/cell/high(src)

/*/obj/vehicle/proc/add_cabin()   //In airtight.dm -Agouri
	cabin_air = new
	cabin_air.temperature = T20C
	cabin_air.volume = 200
	cabin_air.oxygen = O2STANDARD*cabin_air.volume/(R_IDEAL_GAS_EQUATION*cabin_air.temperature)
	cabin_air.nitrogen = N2STANDARD*cabin_air.volume/(R_IDEAL_GAS_EQUATION*cabin_air.temperature)
	return cabin_air*/

/obj/vehicle/proc/add_radio()
	radio = new(src)
	radio.name = "[src] radio"
	radio.icon = icon
	radio.icon_state = icon_state
	radio.subspace_transmission = 1

/obj/vehicle/proc/add_iterators()
	pr_inertial_movement = new /datum/global_iterator/vehicle_intertial_movement(null,0)
	//pr_internal_damage = new /datum/global_iterator/vehicle_internal_damage(list(src),0)
	//pr_int_temp_processor = new /datum/global_iterator/vehicle_preserve_temp(list(src)) //In airtight.dm's add_airtight_iterators -Agouri
	//pr_give_air = new /datum/global_iterator/vehicle_tank_give_air(list(src)            //Same here -Agouri

/obj/vehicle/proc/check_for_support()
	if(locate(/obj/structure/grille, orange(1, src)) || locate(/obj/structure/lattice, orange(1, src)) || locate(/turf/open, orange(1, src)))
		return 1
	else
		return 0

//################ Logs and messages ############################################


/obj/vehicle/proc/log_message(message as text,red=null)
	log.len++
	log[log.len] = list("time"=world.timeofday,"message"="[red?"<font color='red'>":null][message][red?"</font>":null]")
	return log.len



//################ Global Iterator Datums ######################################


/datum/global_iterator/vehicle_intertial_movement //inertial movement in space
	delay = 7

	process(var/obj/vehicle/V as obj, direction)
		if(direction)
			if(!step(V, direction)||V.check_for_support())
				src.stop()
		else
			src.stop()
		return


/datum/global_iterator/mecha_internal_damage // processing internal damage

	process(var/obj/mecha/mecha)
		if(!mecha.hasInternalDamage())
			return stop()
		if(mecha.hasInternalDamage(MECHA_INT_FIRE))
			if(!mecha.hasInternalDamage(MECHA_INT_TEMP_CONTROL) && prob(5))
				mecha.clearInternalDamage(MECHA_INT_FIRE)
			if(mecha.internal_tank)
				if(mecha.internal_tank.return_pressure()>mecha.internal_tank.maximum_pressure && !(mecha.hasInternalDamage(MECHA_INT_TANK_BREACH)))
					mecha.setInternalDamage(MECHA_INT_TANK_BREACH)
				var/datum/gas_mixture/int_tank_air = mecha.internal_tank.return_air()
				if(int_tank_air && int_tank_air.return_volume()>0) //heat the air_contents
					int_tank_air.temperature = min(6000+T0C, int_tank_air.temperature+rand(10,15))
			if(mecha.cabin_air && mecha.cabin_air.return_volume()>0)
				mecha.cabin_air.temperature = min(6000+T0C, mecha.cabin_air.return_temperature()+rand(10,15))
				if(mecha.cabin_air.return_temperature()>mecha.max_temperature/2)
					mecha.take_damage(4/round(mecha.max_temperature/mecha.cabin_air.return_temperature(),0.1),"fire")
		if(mecha.hasInternalDamage(MECHA_INT_TEMP_CONTROL)) //stop the mecha_preserve_temp loop datum
			mecha.pr_int_temp_processor.stop()
		if(mecha.hasInternalDamage(MECHA_INT_TANK_BREACH)) //remove some air from internal tank
			if(mecha.internal_tank)
				var/datum/gas_mixture/int_tank_air = mecha.internal_tank.return_air()
				var/datum/gas_mixture/leaked_gas = int_tank_air.remove_ratio(0.10)
				if(mecha.loc && hascall(mecha.loc,"assume_air"))
					mecha.loc.assume_air(leaked_gas)
				else
					del(leaked_gas)
		if(mecha.hasInternalDamage(MECHA_INT_SHORT_CIRCUIT))
			if(mecha.get_charge())
				mecha.spark_system.start()
				mecha.cell.charge -= min(20,mecha.cell.charge)
				mecha.cell.maxcharge -= min(20,mecha.cell.maxcharge)
		return


*/





/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////




/*/turf/DblClick()
	if(isAI(usr))
		return move_camera_by_click()
	if(usr.stat || usr.restrained() || usr.lying)
		return ..()

	if(usr.hand && istype(usr.l_hand, /obj/item/flamethrower))
		var/turflist = getline(usr,src)
		var/obj/item/flamethrower/F = usr.l_hand
		F.flame_turf(turflist)
	else if(!usr.hand && istype(usr.r_hand, /obj/item/flamethrower))
		var/turflist = getline(usr,src)
		var/obj/item/flamethrower/F = usr.r_hand
		F.flame_turf(turflist)

	return ..()

/turf/New()
	..()
	for(var/atom/movable/AM as mob|obj in src)
		spawn( 0 )
			src.Entered(AM)
			return
	return

/turf/ex_act(severity)
	return 0


/turf/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj ,/obj/item/projectile/beam/pulse))
		src.ex_act(2)
	..()
	return 0

/turf/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj ,/obj/item/projectile/bullet/gyro))
		explosion(src, -1, 0, 2)
	..()
	return 0

/turf/Enter(atom/movable/mover as mob|obj, atom/forget as mob|obj|turf|area)
	if (!mover || !isturf(mover.loc))
		return 1


	//First, check objects to block exit that are not on the border
	for(var/obj/obstacle in mover.loc)
		if((obstacle.flags & ~ON_BORDER) && (mover != obstacle) && (forget != obstacle))
			if(!obstacle.CheckExit(mover, src))
				mover.Bump(obstacle, 1)
				return 0

	//Now, check objects to block exit that are on the border
	for(var/obj/border_obstacle in mover.loc)
		if((border_obstacle.flags & ON_BORDER) && (mover != border_obstacle) && (forget != border_obstacle))
			if(!border_obstacle.CheckExit(mover, src))
				mover.Bump(border_obstacle, 1)
				return 0

	//Next, check objects to block entry that are on the border
	for(var/obj/border_obstacle in src)
		if(border_obstacle.flags & ON_BORDER)
			if(!border_obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != border_obstacle))
				mover.Bump(border_obstacle, 1)
				return 0

	//Then, check the turf itself
	if (!src.CanPass(mover, src))
		mover.Bump(src, 1)
		return 0

	//Finally, check objects/mobs to block entry that are not on the border
	for(var/atom/movable/obstacle in src)
		if(obstacle.flags & ~ON_BORDER)
			if(!obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != obstacle))
				mover.Bump(obstacle, 1)
				return 0
	return 1 //Nothing found to block so return success!


/turf/Entered(atom/movable/M as mob|obj)
	var/loopsanity = 100
	if(ismob(M))
		if(!M:lastarea)
			M:lastarea = GET_AREA(M)
		if(M:lastarea.has_gravity == 0)
			inertial_drift(M)

	/*
		if(M.flags & NOGRAV)
			inertial_drift(M)
	*/



		else if(!isspace(src))
			M:inertia_dir = 0
	..()
	var/objects = 0
	for(var/atom/A as mob|obj|turf|area in src)
		if(objects > loopsanity)	break
		objects++
		spawn( 0 )
			if ((A && M))
				A.HasEntered(M, 1)
			return
	objects = 0
	for(var/atom/A as mob|obj|turf|area in range(1))
		if(objects > loopsanity)	break
		objects++
		spawn( 0 )
			if ((A && M))
				A.HasProximity(M, 1)
			return
	return

/turf/proc/inertial_drift(atom/movable/A as mob|obj)
	if(!(A.last_move))	return
	if((istype(A, /mob/) && src.x > 2 && src.x < (world.maxx - 1) && src.y > 2 && src.y < (world.maxy-1)))
		var/mob/M = A
		if(M.Process_Spacemove(1))
			M.inertia_dir  = 0
			return
		spawn(5)
			if((M && !(M.anchored) && (M.loc == src)))
				if(M.inertia_dir)
					step(M, M.inertia_dir)
					return
				M.inertia_dir = M.last_move
				step(M, M.inertia_dir)
	return

/turf/proc/levelupdate()
	for(var/obj/O in src)
		if(O.level == 1)
			O.hide(src.intact)

// override for space turfs, since they should never hide anything
/turf/space/levelupdate()
	for(var/obj/O in src)
		if(O.level == 1)
			O.hide(0)

// Removes all signs of lattice on the pos of the turf -Donkieyo
/turf/proc/RemoveLattice()
	var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
	if(L)
		del L

/turf/proc/ReplaceWithFloor(explode=0)
	var/prior_icon = icon_old
	var/old_dir = dir

	var/turf/open/floor/W = new /turf/open/floor( locate(src.x, src.y, src.z) )

	W.RemoveLattice()
	W.dir = old_dir
	if(prior_icon) W.icon_state = prior_icon
	else W.icon_state = "floor"

	if (!explode)
		W.opacity = TRUE
		W.sd_SetOpacity(0)
		//This is probably gonna make lighting go a bit wonky in bombed areas, but sd_SetOpacity was the primary reason bombs have been so laggy. --NEO
	W.levelupdate()
	return W

/turf/proc/ReplaceWithPlating()
	var/prior_icon = icon_old
	var/old_dir = dir

	var/turf/open/floor/plating/metal/W = new /turf/open/floor/plating/metal( locate(src.x, src.y, src.z) )

	W.RemoveLattice()
	W.dir = old_dir
	if(prior_icon) W.icon_state = prior_icon
	else W.icon_state = "plating"
	W.opacity = TRUE
	W.sd_SetOpacity(0)
	W.levelupdate()
	return W

/turf/proc/ReplaceWithEngineFloor()
	var/old_dir = dir

	var/turf/open/floor/reinforced/E = new /turf/open/floor/reinforced( locate(src.x, src.y, src.z) )

	E.dir = old_dir
	E.icon_state = "engine"

/turf/open/Entered(atom/A, atom/OL)
	if(iscarbon(A))
		var/mob/living/carbon/M = A
		if(M.lying)	return
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(istype(H.shoes, /obj/item/clothing/shoes/clown_shoes))
				if(H.m_intent == "run")
					if(H.footstep >= 2)
						H.footstep = 0
					else
						H.footstep++
					if(H.footstep == 0)
						playsound(src, "clownstep", 50, 1) // this will get annoying very fast.
				else
					playsound(src, "clownstep", 20, 1)

		switch (src.wet)
			if(1)
				if(ishuman(M)) // Added check since monkeys don't have shoes
					if ((M.m_intent == "run") && !(istype(M:shoes, /obj/item/clothing/shoes) && M:shoes.flags&NOSLIP))
						M.stop_pulling()
						step(M, M.dir)
						M << "\blue You slipped on the wet floor!"
						playsound(src.loc, 'sound/misc/slip.ogg', 50, 1, -3)
						M.Stun(8)
						M.Weaken(5)
					else
						M.inertia_dir = 0
						return
				else if(!isslime(M))
					if (M.m_intent == "run")
						M.stop_pulling()
						step(M, M.dir)
						M << "\blue You slipped on the wet floor!"
						playsound(src.loc, 'sound/misc/slip.ogg', 50, 1, -3)
						M.Stun(8)
						M.Weaken(5)
					else
						M.inertia_dir = 0
						return

			if(2) //lube
				if(!isslime(M))
					M.stop_pulling()
					step(M, M.dir)
					spawn(1) step(M, M.dir)
					spawn(2) step(M, M.dir)
					spawn(3) step(M, M.dir)
					spawn(4) step(M, M.dir)
					M.take_organ_damage(2) // Was 5 -- TLE
					M << "\blue You slipped on the floor!"
					playsound(src.loc, 'sound/misc/slip.ogg', 50, 1, -3)
					M.Weaken(10)

	..()

/turf/proc/ReplaceWithSpace()
	var/old_dir = dir
	var/turf/space/S = new /turf/space( locate(src.x, src.y, src.z) )
	S.dir = old_dir
	return S

/turf/proc/ReplaceWithLattice()
	var/old_dir = dir
	var/turf/space/S = new /turf/space( locate(src.x, src.y, src.z) )
	S.dir = old_dir
	new /obj/structure/lattice( locate(src.x, src.y, src.z) )
	return S

/turf/proc/ReplaceWithWall()
	var/old_icon = icon_state
	var/turf/closed/wall/S = new /turf/closed/wall( locate(src.x, src.y, src.z) )
	S.icon_old = old_icon
	S.opacity = FALSE
	S.sd_NewOpacity(1)
	return S

/turf/proc/ReplaceWithRWall()
	var/old_icon = icon_state
	var/turf/closed/wall/reinforced/S = new /turf/closed/wall/reinforced( locate(src.x, src.y, src.z) )
	S.icon_old = old_icon
	S.opacity = FALSE
	S.sd_NewOpacity(1)
	return S

/turf/closed/wall/New()
	..()

/turf/closed/wall/proc/dismantle_wall(devastated=0, explode=0)
	if(istype(src,/turf/closed/wall/reinforced))
		if(!devastated)
			playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)
			new /obj/structure/girder/reinforced(src)
			new /obj/item/stack/sheet/plasteel( src )
		else
			new /obj/item/stack/sheet/steel(src)
			new /obj/item/stack/sheet/steel(src)
			new /obj/item/stack/sheet/plasteel( src )
	else if(istype(src,/turf/closed/wall/cult))
		if(!devastated)
			playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)
			new /obj/effect/decal/remains/human(src)
		else
			new /obj/effect/decal/remains/human(src)

	else
		if(!devastated)
			playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)
			new /obj/structure/girder(src)
			new /obj/item/stack/sheet/steel(src)
			new /obj/item/stack/sheet/steel(src)
		else
			new /obj/item/stack/sheet/steel(src)
			new /obj/item/stack/sheet/steel(src)
			new /obj/item/stack/sheet/steel(src)

	ReplaceWithPlating(explode)

/turf/closed/wall/examine()
	set src in oview(1)

	usr << "It looks like a regular wall."
	return

/turf/closed/wall/ex_act(severity)
	switch(severity)
		if(1.0)
			//SN src = null
			src.ReplaceWithSpace()
			del(src)
			return
		if(2.0)
			if (prob(50))
				dismantle_wall(0,1)
			else
				dismantle_wall(1,1)
		if(3.0)
			var/proba
			if (istype(src, /turf/closed/wall/reinforced))
				proba = 15
			else
				proba = 40
			if (prob(proba))
				dismantle_wall(0,1)
		else
	return

/turf/closed/wall/blob_act()
	if(prob(50))
		dismantle_wall()

/turf/closed/wall/attack_paw(mob/user as mob)
	if ((user.mutations & MUTATION_HULK))
		if (prob(40))
			usr << text("\blue You smash through the wall.")
			dismantle_wall(1)
			return
		else
			usr << text("\blue You punch the wall.")
			return

	return src.attack_hand(user)


/turf/closed/wall/attack_animal(mob/living/simple/M as mob)
	if(M.wall_smash)
		if (istype(src, /turf/closed/wall/reinforced))
			M << text("\blue This wall is far too strong for you to destroy.")
			return
		else
			if (prob(40))
				M << text("\blue You smash through the wall.")
				dismantle_wall(1)
				return
			else
				M << text("\blue You smash against the wall.")
				return

	M << "\blue You push the wall but nothing happens!"
	return

/turf/closed/wall/attack_hand(mob/user as mob)
	if ((user.mutations & MUTATION_HULK))
		if (prob(40))
			usr << text("\blue You smash through the wall.")
			dismantle_wall(1)
			return
		else
			usr << text("\blue You punch the wall.")
			return

	user << "\blue You push the wall but nothing happens!"
	playsound(src.loc, 'sound/weapons/melee/genhit.ogg', 25, 1)
	src.add_fingerprint(user)
	return

/turf/closed/wall/attackby(obj/item/W as obj, mob/user as mob)

	if(!(ishuman(usr) || ticker) && ticker.mode.name != "monkey")
		FEEDBACK_NOT_ENOUGH_DEXTERITY(usr)
		return

	if(iswelder(W) && W:welding)
		var/turf/T = GET_TURF(user)
		if(!isturf(T))
			return

		if (thermite)
			var/obj/effect/overlay/O = new/obj/effect/overlay( src )
			O.name = "Thermite"
			O.desc = "Looks hot."
			O.icon = 'icons/effects/fire.dmi'
			O.icon_state = "2"
			O.anchored = TRUE
			O.density = TRUE
			O.layer = 5
			var/turf/open/floor/F = ReplaceWithPlating()
			F.burn_tile()
			F.icon_state = "wall_thermite"
			user << "\red The thermite melts the wall."
			spawn(100) del(O)
			F.sd_LumReset()
			return

		if(W:remove_fuel(0, user))
			W:welding = 2
			user << "\blue Now disassembling the outer wall plating."
			playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)
			sleep(100)
			if(W && istype(src, /turf/closed/wall))
				if(GET_TURF(user) == T && user.equipped() == W)
					user << "\blue You disassembled the outer wall plating."
					dismantle_wall()
				W:welding = 1
		else
			return

	else if (istype(W, /obj/item/pickaxe/plasmacutter))
		var/turf/T = user.loc
		if(!isturf(T))
			return

		if (thermite)
			var/obj/effect/overlay/O = new/obj/effect/overlay( src )
			O.name = "Thermite"
			O.desc = "Looks hot."
			O.icon = 'icons/effects/fire.dmi'
			O.icon_state = "2"
			O.anchored = TRUE
			O.density = TRUE
			O.layer = 5
			var/turf/open/floor/F = ReplaceWithPlating()
			F.burn_tile()
			F.icon_state = "wall_thermite"
			user << "\red The thermite melts the wall."
			spawn(100) del(O)
			F.sd_LumReset()
			return

		else
			user << "\blue Now disassembling the outer wall plating."
			playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)
			sleep(60)
			if(W && istype(src, /turf/closed/wall))
				if(GET_TURF(user) == T && user.equipped() == W)
					user << "\blue You disassembled the outer wall plating."
					dismantle_wall()
					for(var/mob/O in viewers(user, 5))
						O.show_message(text("\blue The wall was sliced apart by []!", user), 1, text("\red You hear metal being sliced apart."), 2)
		return

	else if(istype(W, /obj/item/pickaxe/drill/diamond))
		var/turf/T = user.loc
		user << "\blue Now drilling through wall."
		sleep(60)
		if (W && istype(src, /turf/closed/wall))
			if ((user.loc == T && user.equipped() == W))
				dismantle_wall(1)
				for(var/mob/O in viewers(user, 5))
					O.show_message(text("\blue The wall was drilled apart by []!", user), 1, text("\red You hear metal being drilled appart."), 2)
		return

	else if(istype(W, /obj/item/melee/energy/blade))
		var/turf/T = user.loc
		user << "\blue Now slicing through wall."
		W:spark_system.start()
		playsound(src.loc, "sparks", 50, 1)
		sleep(70)
		if (W && istype(src, /turf/closed/wall))
			if ((user.loc == T && user.equipped() == W))
				W:spark_system.start()
				playsound(src.loc, "sparks", 50, 1)
				playsound(src.loc, 'sound/weapons/melee/blade1.ogg', 50, 1)
				dismantle_wall(1)
				for(var/mob/O in viewers(user, 5))
					O.show_message(text("\blue The wall was sliced apart by []!", user), 1, text("\red You hear metal being sliced and sparks flying."), 2)
		return

	else if(istype(W,/obj/item/apc_frame))
		var/obj/item/apc_frame/AH = W
		AH.try_build(src)
	else if(istype(W,/obj/item/contraband/poster))
		var/obj/item/contraband/poster/P = W
		if(P.resulting_poster)
			var/check = 0
			var/stuff_on_wall = 0
			for( var/obj/O in src.contents) //Let's see if it already has a poster on it or too much stuff
				if(istype(O,/obj/effect/decal/poster))
					check = 1
					break
				stuff_on_wall++
				if(stuff_on_wall==3)
					check = 1
					break

			if(check)
				user << "<FONT COLOR='RED'>The wall is far too cluttered to place a poster!</FONT>"
				return

			user << "<FONT COLOR='blue'>You start placing the poster on the wall...</FONT>" //Looks like it's uncluttered enough. Place the poster.

			P.resulting_poster.forceMove(src)
			var/temp = P.resulting_poster.icon_state
			var/temp_loc = user.loc
			P.resulting_poster.icon_state = "poster_being_set"
			playsound(P.resulting_poster.loc, 'sound/items/poster_being_created.ogg', 100, 1)
			sleep(24)

			if(user.loc == temp_loc)//Let's check if he still is there
				user << "<FONT COLOR='blue'>You place the poster!</FONT>"
				P.resulting_poster.icon_state = temp
				src.contents += P.resulting_poster
				del(P)
			else
				user << "<FONT COLOR='BLUE'>You stop placing the poster.</FONT>"
				P.resulting_poster.forceMove(P)
				P.resulting_poster.icon_state = temp
	else
		return attack_hand(user)
	return


/turf/closed/wall/reinforced/attackby(obj/item/W as obj, mob/user as mob)

	if(!(ishuman(usr) || ticker) && ticker.mode.name != "monkey")
		FEEDBACK_NOT_ENOUGH_DEXTERITY(usr)
		return

	if(!istype(src, /turf/closed/wall/reinforced))
		return // this may seem stupid and redundant but apparently floors can call this attackby() proc, it was spamming shit up. -- Doohl


	if(iswelder(W) && W:welding)
		W:eyecheck(user)
		var/turf/T = user.loc
		if(!isturf(T))
			return

		if (thermite)
			var/obj/effect/overlay/O = new/obj/effect/overlay( src )
			O.name = "Thermite"
			O.desc = "Looks hot."
			O.icon = 'icons/effects/fire.dmi'
			O.icon_state = "2"
			O.anchored = TRUE
			O.density = TRUE
			O.layer = 5
			var/turf/open/floor/F = ReplaceWithPlating()
			F.burn_tile()
			F.icon_state = "wall_thermite"
			user << "\red The thermite melts the wall."
			spawn(100) del(O)
			F.sd_LumReset()
			return

		if (src.d_state == 2)
			W:welding = 2
			user << "\blue Slicing metal cover."
			playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)
			sleep(60)
			if ((user.loc == T && user.equipped() == W))
				src.d_state = 3
				user << "\blue You removed the metal cover."
			W:welding = 1

		else if (src.d_state == 5)
			W:welding = 2
			user << "\blue Removing support rods."
			playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)
			sleep(100)
			if ((user.loc == T && user.equipped() == W))
				src.d_state = 6
				new /obj/item/stack/rods( src )
				user << "\blue You removed the support rods."
			W:welding = 1

	else if(istype(W, /obj/item/pickaxe/plasmacutter))
		var/turf/T = user.loc
		if(!isturf(T))
			return

		if (thermite)
			var/obj/effect/overlay/O = new/obj/effect/overlay( src )
			O.name = "Thermite"
			O.desc = "Looks hot."
			O.icon = 'icons/effects/fire.dmi'
			O.icon_state = "2"
			O.anchored = TRUE
			O.density = TRUE
			O.layer = 5
			var/turf/open/floor/F = ReplaceWithPlating()
			F.burn_tile()
			F.icon_state = "wall_thermite"
			user << "\red The thermite melts the wall."
			spawn(100) del(O)
			F.sd_LumReset()
			return

		if (src.d_state == 2)
			user << "\blue Slicing metal cover."
			playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)
			sleep(40)
			if ((user.loc == T && user.equipped() == W))
				src.d_state = 3
				user << "\blue You removed the metal cover."

		else if (src.d_state == 5)
			user << "\blue Removing support rods."
			playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)
			sleep(70)
			if ((user.loc == T && user.equipped() == W))
				src.d_state = 6
				new /obj/item/stack/rods( src )
				user << "\blue You removed the support rods."

	else if(istype(W, /obj/item/melee/energy/blade))
		user << "\blue This wall is too thick to slice through. You will need to find a different path."
		return

	else if(iswrench(W))
		if (src.d_state == 4)
			var/turf/T = user.loc
			user << "\blue Detaching support rods."
			playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)
			sleep(40)
			if ((user.loc == T && user.equipped() == W))
				src.d_state = 5
				user << "\blue You detach the support rods."

	else if(iswirecutter(W))
		if (src.d_state == 0)
			playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
			src.d_state = 1
			new /obj/item/stack/rods( src )

	else if(isscrewdriver(W))
		if (src.d_state == 1)
			var/turf/T = user.loc
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 100, 1)
			user << "\blue Removing support lines."
			sleep(40)
			if ((user.loc == T && user.equipped() == W))
				src.d_state = 2
				user << "\blue You removed the support lines."

	else if(iscrowbar(W))

		if (src.d_state == 3)
			var/turf/T = user.loc
			user << "\blue Prying cover off."
			playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
			sleep(100)
			if ((user.loc == T && user.equipped() == W))
				src.d_state = 4
				user << "\blue You removed the cover."

		else if (src.d_state == 6)
			var/turf/T = user.loc
			user << "\blue Prying outer sheath off."
			playsound(src.loc, 'sound/items/Crowbar.ogg', 100, 1)
			sleep(100)
			if(src)
				if ((user.loc == T && user.equipped() == W))
					user << "\blue You removed the outer sheath."
					dismantle_wall()
					return

	else if (istype(W, /obj/item/pickaxe/drill/diamond))
		var/turf/T = user.loc
		user << "\blue You begin to drill though, this will take some time."
		sleep(200)
		if(src)
			if ((user.loc == T && user.equipped() == W))
				user << "\blue Your drill tears though the reinforced plating."
				dismantle_wall()
				return

	else if ((istype(W, /obj/item/stack/sheet/steel)) && (src.d_state))
		var/turf/T = user.loc
		user << "\blue Repairing wall."
		sleep(100)
		if ((user.loc == T && user.equipped() == W))
			src.d_state = 0
			src.icon_state = initial(src.icon_state)
			user << "\blue You repaired the wall."
			if (W:amount > 1)
				W:amount--
			else
				del(W)

	else if(istype(W,/obj/item/contraband/poster))
		var/obj/item/contraband/poster/P = W
		if(P.resulting_poster)
			var/check = 0
			var/stuff_on_wall = 0
			for( var/obj/O in src.contents) //Let's see if it already has a poster on it or too much stuff
				if(istype(O,/obj/effect/decal/poster))
					check = 1
					break
				stuff_on_wall++
				if(stuff_on_wall==3)
					check = 1
					break

			if(check)
				user << "<FONT COLOR='RED'>The wall is far too cluttered to place a poster!</FONT>"
				return

			user << "<FONT COLOR='blue'>You start placing the poster on the wall...</FONT>" //Looks like it's uncluttered enough. Place the poster.

			P.resulting_poster.forceMove(src)
			var/temp = P.resulting_poster.icon_state
			var/temp_loc = user.loc
			P.resulting_poster.icon_state = "poster_being_set"
			playsound(P.resulting_poster.loc, 'sound/items/poster_being_created.ogg', 100, 1)
			sleep(24)

			if(user.loc == temp_loc)//Let's check if he still is there
				user << "<FONT COLOR='blue'>You place the poster!</FONT>"
				P.resulting_poster.icon_state = temp
				src.contents += P.resulting_poster
				del(P)
			else
				user << "<FONT COLOR='BLUE'>You stop placing the poster.</FONT>"
				P.resulting_poster.forceMove(P)
				P.resulting_poster.icon_state = temp
		return

	if(istype(W,/obj/item/apc_frame))
		var/obj/item/apc_frame/AH = W
		AH.try_build(src)
		return

	if(src.d_state > 0)
		src.icon_state = "r_wall-[d_state]"

	else
		return attack_hand(user)
	return

/turf/closed/wall/meteorhit(obj/M as obj)
	if (prob(15))
		dismantle_wall()
	else if(prob(70))
		ReplaceWithPlating()
	else
		ReplaceWithLattice()
	return 0


//This is so damaged or burnt tiles or platings don't get remembered as the default tile
var/list/icons_to_ignore_at_floor_init = list("damaged1","damaged2","damaged3","damaged4",
				"damaged5","panelscorched","floorscorched1","floorscorched2","platingdmg1","platingdmg2",
				"platingdmg3","plating","light_on","light_on_flicker1","light_on_flicker2",
				"light_on_clicker3","light_on_clicker4","light_on_clicker5","light_broken",
				"light_on_broken","light_off","wall_thermite","grass1","grass2","grass3","grass4",
				"asteroid","asteroid_dug",
				"asteroid0","asteroid1","asteroid2","asteroid3","asteroid4",
				"asteroid5","asteroid6","asteroid7","asteroid8",
				"burning","oldburning","light-on-r","light-on-y","light-on-g","light-on-b")

var/list/plating_icons = list("plating","platingdmg1","platingdmg2","platingdmg3","asteroid","asteroid_dug")

/turf/open/floor

	//Note to coders, the 'intact' var can no longer be used to determine if the floor is a plating or not.
	//Use the is_plating(), is_plasteel_floor() and is_light_floor() procs instead. --Errorage
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "floor"
	var/icon_regular_floor = "floor" //used to remember what icon the tile should have by default
	var/icon_plating = "plating"
	thermal_conductivity = 0.040
	heat_capacity = 10000
	var/broken = 0
	var/burnt = 0
	var/obj/item/stack/tile/floor_tile = new/obj/item/stack/tile/metal/grey

	airless
		icon_state = "floor"
		name = "airless floor"
		oxygen = 0.01
		nitrogen = 0.01
		temperature = TCMB

		New()
			..()
			name = "floor"

	light
		name = "Light floor"
		luminosity = 5
		icon_state = "light_on"
		floor_tile = new/obj/item/stack/tile/light

		New()
			floor_tile.New() //I guess New() isn't run on objects spawned without the definition of a turf to house them, ah well.
			var/n = name //just in case commands rename it in the ..() call
			..()
			spawn(4)
				update_icon()
				name = n

	grass
		name = "Grass patch"
		icon_state = "grass1"
		floor_tile = new/obj/item/stack/tile/grass

		New()
			floor_tile.New() //I guess New() isn't run on objects spawned without the definition of a turf to house them, ah well.
			icon_state = "grass[pick("1","2","3","4")]"
			..()
			spawn(4)
				update_icon()
				for(var/direction in cardinal)
					if(isfloorturf(get_step(src, direction)))
						var/turf/open/floor/FF = get_step(src,direction)
						FF.update_icon() //so siding get updated properly

/turf/open/floor/vault
	icon_state = "rockvault"

	New(location,type)
		..()
		icon_state = "[type]vault"

/turf/closed/wall/vault
	icon_state = "rockvault"

	New(location,type)
		..()
		icon_state = "[type]vault"

/turf/open/floor/reinforced
	name = "reinforced floor"
	icon_state = "engine"
	thermal_conductivity = 0.025
	heat_capacity = 325000

/turf/open/floor/reinforced/cult
	name = "engraved floor"
	icon_state = "cult"


/turf/open/floor/reinforced/n20
	New()
		..()
		var/datum/gas_mixture/adding = new
		var/datum/gas/sleeping_agent/trace_gas = new

		trace_gas.moles = 2000
		adding.trace_gases += trace_gas
		adding.temperature = T20C

		assume_air(adding)

/turf/open/floor/reinforced/vacuum
	name = "vacuum floor"
	icon_state = "engine"
	oxygen = 0
	nitrogen = 0.001
	temperature = TCMB

/turf/open/floor/plating/metal
	name = "plating"
	icon_state = "plating"
	floor_tile = null
	intact = 0

/turf/open/floor/plating/metal/airless
	icon_state = "plating"
	name = "airless plating"
	oxygen = 0.01
	nitrogen = 0.01
	temperature = TCMB

	New()
		..()
		name = "plating"

/turf/open/floor/grid
	icon = 'icons/turf/floors.dmi'
	icon_state = "circuit"

/turf/open/floor/New()
	..()
	if(icon_state in icons_to_ignore_at_floor_init) //so damaged/burned tiles or plating icons aren't saved as the default
		icon_regular_floor = "floor"
	else
		icon_regular_floor = icon_state

//turf/open/floor/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
//	if ((istype(mover, /obj/machinery/vehicle) && !(src.burnt)))
//		if (!( locate(/obj/machinery/mass_driver, src) ))
//			return 0
//	return ..()

/turf/open/floor/ex_act(severity)
	//set src in oview(1)
	switch(severity)
		if(1.0)
			src.ReplaceWithSpace()
		if(2.0)
			switch(pick(1,2;75,3))
				if (1)
					src.ReplaceWithLattice()
					if(prob(33)) new /obj/item/stack/sheet/steel(src)
				if(2)
					src.ReplaceWithSpace()
				if(3)
					if(prob(80))
						src.break_tile_to_plating()
					else
						src.break_tile()
					src.hotspot_expose(1000,CELL_VOLUME)
					if(prob(33)) new /obj/item/stack/sheet/steel(src)
		if(3.0)
			if (prob(50))
				src.break_tile()
				src.hotspot_expose(1000,CELL_VOLUME)
	return

/turf/open/floor/blob_act()
	return

turf/open/floor/proc/update_icon()
	if(is_plasteel_floor())
		if(!broken && !burnt)
			icon_state = icon_regular_floor
	if(is_plating())
		if(!broken && !burnt)
			icon_state = icon_plating //Because asteroids are 'platings' too.
	if(is_light_floor())
		var/obj/item/stack/tile/light/T = floor_tile
		if(T.on)
			switch(T.state)
				if(0)
					icon_state = "light_on"
					sd_SetLuminosity(5)
				if(1)
					var/num = pick("1","2","3","4")
					icon_state = "light_on_flicker[num]"
					sd_SetLuminosity(5)
				if(2)
					icon_state = "light_on_broken"
					sd_SetLuminosity(5)
				if(3)
					icon_state = "light_off"
					sd_SetLuminosity(0)
		else
			sd_SetLuminosity(0)
			icon_state = "light_off"
	if(is_grass_floor())
		if(!broken && !burnt)
			if(!(icon_state in list("grass1","grass2","grass3","grass4")))
				icon_state = "grass[pick("1","2","3","4")]"
	spawn(1)
		if(isfloorturf(src)) //Was throwing runtime errors due to a chance of it changing to space halfway through.
			if(air)
				update_visuals(air)

turf/open/floor/return_siding_icon_state()
	..()
	if(is_grass_floor())
		var/dir_sum = 0
		for(var/direction in cardinal)
			var/turf/T = get_step(src,direction)
			if(!(T.is_grass_floor()))
				dir_sum += direction
		if(dir_sum)
			return "wood_siding[dir_sum]"
		else
			return 0


/turf/open/floor/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/turf/open/floor/attack_hand(mob/user as mob)
	if (is_light_floor())
		var/obj/item/stack/tile/light/T = floor_tile
		T.on = !T.on
	update_icon()
	if ((!( user.canmove ) || user.restrained() || !( user.pulling )))
		return
	if (user.pulling.anchored)
		return
	if ((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	if (ismob(user.pulling))
		var/mob/M = user.pulling
		var/mob/t = M.pulling
		M.stop_pulling()
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.start_pulling(t)
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return

/turf/open/floor/reinforced/attackby(obj/item/C as obj, mob/user as mob)
	if(!C)
		return
	if(!user)
		return
	if(iswrench(C))
		user << "\blue Removing rods..."
		playsound(src.loc, 'sound/items/Ratchet.ogg', 80, 1)
		if(do_after(user, 30))
			new /obj/item/stack/rods(src, 2)
			ReplaceWithFloor()
			var/turf/open/floor/F = src
			F.make_plating()
			return

/turf/open/floor/proc/gets_drilled()
	return

/turf/open/floor/proc/break_tile_to_plating()
	if(!is_plating())
		make_plating()
	break_tile()

/turf/open/floor/is_plasteel_floor()
	if(istype(floor_tile,/obj/item/stack/tile/metal/grey))
		return 1
	else
		return 0

/turf/open/floor/is_light_floor()
	if(istype(floor_tile,/obj/item/stack/tile/light))
		return 1
	else
		return 0

/turf/open/floor/is_grass_floor()
	if(istype(floor_tile,/obj/item/stack/tile/grass))
		return 1
	else
		return 0

/turf/open/floor/is_plating()
	if(!floor_tile)
		return 1
	return 0

/turf/open/floor/proc/break_tile()
	if(istype(src,/turf/open/floor/reinforced)) return
	if(istype(src,/turf/open/floor/mech_bay_recharge_floor))
		src.ReplaceWithPlating()
	if(broken) return
	if(is_plasteel_floor())
		src.icon_state = "damaged[pick(1,2,3,4,5)]"
		broken = 1
	else if(is_plasteel_floor())
		src.icon_state = "light_broken"
		broken = 1
	else if(is_plating())
		src.icon_state = "platingdmg[pick(1,2,3)]"
		broken = 1
	else if(is_grass_floor())
		src.icon_state = "sand[pick("1","2","3")]"
		broken = 1

/turf/open/floor/proc/burn_tile()
	if(istype(src,/turf/open/floor/reinforced)) return
	if(broken || burnt) return
	if(is_plasteel_floor())
		src.icon_state = "damaged[pick(1,2,3,4,5)]"
		burnt = 1
	else if(is_plasteel_floor())
		src.icon_state = "floorscorched[pick(1,2)]"
		burnt = 1
	else if(is_plating())
		src.icon_state = "panelscorched"
		burnt = 1
	else if(is_grass_floor())
		src.icon_state = "sand[pick("1","2","3")]"
		burnt = 1

//This proc will delete the floor_tile and the update_iocn() proc will then change the icon_state of the turf
//This proc auto corrects the grass tiles' siding.
/turf/open/floor/proc/make_plating()
	if(istype(src,/turf/open/floor/reinforced)) return

	if(is_grass_floor())
		for(var/direction in cardinal)
			if(isfloorturf(get_step(src, direction)))
				var/turf/open/floor/FF = get_step(src,direction)
				FF.update_icon() //so siding get updated properly

	if(!floor_tile) return
	del(floor_tile)
	icon_plating = "plating"
	sd_SetLuminosity(0)
	floor_tile = null
	intact = 0
	broken = 0
	burnt = 0

	update_icon()
	levelupdate()

//This proc will make the turf a plasteel floor tile. The expected argument is the tile to make the turf with
//If none is given it will make a new object. dropping or unequipping must be handled before or after calling
//this proc.
/turf/open/floor/proc/make_plasteel_floor(var/obj/item/stack/tile/metal/grey/T = null)
	broken = 0
	burnt = 0
	intact = 1
	sd_SetLuminosity(0)
	if(T)
		if(istype(T,/obj/item/stack/tile/metal/grey))
			floor_tile = T
			if (icon_regular_floor)
				icon_state = icon_regular_floor
			else
				icon_state = "floor"
				icon_regular_floor = icon_state
			update_icon()
			levelupdate()
			return
	//if you gave a valid parameter, it won't get thisf ar.
	floor_tile = new/obj/item/stack/tile/metal/grey
	icon_state = "floor"
	icon_regular_floor = icon_state

	update_icon()
	levelupdate()

//This proc will make the turf a light floor tile. The expected argument is the tile to make the turf with
//If none is given it will make a new object. dropping or unequipping must be handled before or after calling
//this proc.
/turf/open/floor/proc/make_light_floor(var/obj/item/stack/tile/light/T = null)
	broken = 0
	burnt = 0
	intact = 1
	if(T)
		if(istype(T,/obj/item/stack/tile/light))
			floor_tile = T
			update_icon()
			levelupdate()
			return
	//if you gave a valid parameter, it won't get thisf ar.
	floor_tile = new/obj/item/stack/tile/light

	update_icon()
	levelupdate()

//This proc will make a turf into a grass patch. Fun eh? Insert the grass tile to be used as the argument
//If no argument is given a new one will be made.
/turf/open/floor/proc/make_grass_floor(var/obj/item/stack/tile/grass/T = null)
	broken = 0
	burnt = 0
	intact = 1
	if(T)
		if(istype(T,/obj/item/stack/tile/grass))
			floor_tile = T
			update_icon()
			levelupdate()
			return
	//if you gave a valid parameter, it won't get thisf ar.
	floor_tile = new/obj/item/stack/tile/grass

	update_icon()
	levelupdate()

/turf/open/floor/attackby(obj/item/C as obj, mob/user as mob)

	if(!C || !user)
		return 0

	if(istype(C,/obj/item/light/bulb)) //only for light tiles
		if(is_light_floor())
			var/obj/item/stack/tile/light/T = floor_tile
			if(T.state)
				user.u_equip(C)
				del(C)
				T.state = C //fixing it by bashing it with a light bulb, fun eh?
				update_icon()
				user << "\blue You replace the light bulb."
			else
				user << "\blue The lightbulb seems fine, no need to replace it."

	if(iscrowbar(C) && (!(is_plating())))
		if(broken || burnt)
			user << "\red You remove the broken plating."
		else
			user << "\red You remove the [floor_tile.name]."
			new floor_tile.type(src)

		make_plating()
		playsound(src.loc, 'sound/items/Crowbar.ogg', 80, 1)

		return

	if(istype(C, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = C
		if (is_plating())
			if (R.amount >= 2)
				user << "\blue Reinforcing the floor..."
				if(do_after(user, 30) && R && R.amount >= 2 && is_plating())
					ReplaceWithEngineFloor()
					playsound(src.loc, 'sound/items/Deconstruct.ogg', 80, 1)
					R.use(2)
					return
			else
				user << "\red You need more rods."
		else
			user << "\red You must remove the plating first."
		return

	if(istype(C, /obj/item/stack/tile))
		if(is_plating())
			if(!broken && !burnt)
				var/obj/item/stack/tile/T = C
				floor_tile = new T.type
				intact = 1
				if(istype(T,/obj/item/stack/tile/light))
					var/obj/item/stack/tile/light/L = T
					var/obj/item/stack/tile/light/F = floor_tile
					F.state = L.state
					F.on = L.on
				if(istype(T,/obj/item/stack/tile/grass))
					for(var/direction in cardinal)
						if(isfloorturf(get_step(src, direction)))
							var/turf/open/floor/FF = get_step(src,direction)
							FF.update_icon() //so siding gets updated properly
				T.use(1)
				update_icon()
				levelupdate()
				playsound(src.loc, 'sound/weapons/melee/genhit.ogg', 50, 1)
			else
				user << "\blue This section is too damaged to support a tile. Use a welder to fix the damage."


	if(istype(C, /obj/item/cable_coil))
		if(is_plating())
			var/obj/item/cable_coil/coil = C
			coil.turf_place(src, user)
		else
			user << "\red You must remove the plating first."

	if(istype(C, /obj/item/shovel))
		if(is_grass_floor())
			new /obj/item/ore/glass(src)
			new /obj/item/ore/glass(src) //Make some sand if you shovel grass
			user << "\blue You shovel the grass."
			make_plating()
		else
			user << "\red You cannot shovel this."

	if(iswelder(C))
		var/obj/item/weldingtool/welder = C
		if(welder.welding && (is_plating()))
			if(broken || burnt)
				if(welder.remove_fuel(0, user))
					user << "\red You fix some dents on the broken plating."
					playsound(src.loc, 'sound/items/Welder.ogg', 80, 1)
					icon_state = "plating"
					burnt = 0
					broken = 0
				else
					return

/turf/unsimulated/floor/attack_paw(user as mob)
	return src.attack_hand(user)

/turf/unsimulated/floor/attack_hand(var/mob/user as mob)
	if ((!( user.canmove ) || user.restrained() || !( user.pulling )))
		return
	if (user.pulling.anchored)
		return
	if ((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	if (ismob(user.pulling))
		var/mob/M = user.pulling
		var/mob/t = M.pulling
		M.stop_pulling()
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.start_pulling(t)
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return

// imported from space.dm

/turf/space/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/turf/space/attack_hand(mob/user as mob)
	if ((user.restrained() || !( user.pulling )))
		return
	if (user.pulling.anchored)
		return
	if ((user.pulling.loc != user.loc && get_dist(user, user.pulling) > 1))
		return
	if (ismob(user.pulling))
		var/mob/M = user.pulling
		var/atom/movable/t = M.pulling
		M.stop_pulling()
		step(user.pulling, get_dir(user.pulling.loc, src))
		M.start_pulling(t)
	else
		step(user.pulling, get_dir(user.pulling.loc, src))
	return

/turf/space/attackby(obj/item/C as obj, mob/user as mob)

	if (istype(C, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return
		var/obj/item/stack/rods/R = C
		user << "\blue Constructing support lattice ..."
		playsound(src.loc, 'sound/weapons/melee/genhit.ogg', 50, 1)
		ReplaceWithLattice()
		R.use(1)
		return

	if (istype(C, /obj/item/stack/tile/metal/grey))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/metal/grey/S = C
			del(L)
			playsound(src.loc, 'sound/weapons/melee/genhit.ogg', 50, 1)
			S.build(src)
			S.use(1)
			return
		else
			user << "\red The plating is going to need some support."
	return


// Ported from unstable r355

/turf/space/Entered(atom/movable/A as mob|obj)
	..()
	if ((!(A) || src != A.loc || istype(null, /obj/effect/beam)))	return

	inertial_drift(A)

	if(ticker && ticker.mode)

		// Okay, so let's make it so that people can travel z levels but not nuke disks!
		// if(IS_GAME_MODE(/datum/game_mode/nuclear))
		//	return

		if(ticker.mode.name == "extended"||ticker.mode.name == "sandbox")
			Sandbox_Spacemove(A)

		else
			if (src.x <= 2 || A.x >= (world.maxx - 1) || src.y <= 2 || A.y >= (world.maxy - 1))
				if(istype(A, /obj/effect/meteor)||istype(A, /obj/effect/space_dust))
					del(A)
					return

				if(istype(A, /obj/item/disk/nuclear)) // Don't let nuke disks travel Z levels  ... And moving this shit down here so it only fires when they're actually trying to change z-level.
					return

				if(!isemptylist(A.search_contents_for(/obj/item/disk/nuclear)))
					if(isliving(A))
						var/mob/living/MM = A
						if(MM.client)
							MM << "\red Something you are carrying is preventing you from leaving. Don't play stupid; you know exactly what it is."
					return



				var/move_to_z_str = pickweight(accessable_z_levels)

				var/move_to_z = text2num(move_to_z_str)

				if(!move_to_z)
					return



				A.z = move_to_z


				if(src.x <= 2)
					A.x = world.maxx - 2

				else if (A.x >= (world.maxx - 1))
					A.x = 3

				else if (src.y <= 2)
					A.y = world.maxy - 2

				else if (A.y >= (world.maxy - 1))
					A.y = 3

				spawn (0)
					if ((A && A.loc))
						A.loc.Entered(A)

//				if(istype(A, /obj/structure/closet/coffin))
//					coffinhandler.Add(A)

/turf/space/proc/Sandbox_Spacemove(atom/movable/A as mob|obj)
	var/cur_x
	var/cur_y
	var/next_x
	var/next_y
	var/target_z
	var/list/y_arr

	if(src.x <= 1)
		if(istype(A, /obj/effect/meteor)||istype(A, /obj/effect/space_dust))
			del(A)
			return

		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		next_x = (--cur_x||global_map.len)
		y_arr = global_map[next_x]
		target_z = y_arr[cur_y]
/*
		//debug
		to_world("Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]")
		to_world("Target Z = [target_z]")
		to_world("Next X = [next_x]")
		//debug
*/
		if(target_z)
			A.z = target_z
			A.x = world.maxx - 2
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	else if (src.x >= world.maxx)
		if(istype(A, /obj/effect/meteor))
			del(A)
			return

		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		next_x = (++cur_x > global_map.len ? 1 : cur_x)
		y_arr = global_map[next_x]
		target_z = y_arr[cur_y]
/*
		//debug
		to_world("Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]")
		to_world("Target Z = [target_z]")
		to_world("Next X = [next_x]")
		//debug
*/
		if(target_z)
			A.z = target_z
			A.x = 3
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	else if (src.y <= 1)
		if(istype(A, /obj/effect/meteor))
			del(A)
			return
		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		y_arr = global_map[cur_x]
		next_y = (--cur_y||y_arr.len)
		target_z = y_arr[next_y]
/*
		//debug
		to_world("Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]")
		to_world("Next Y = [next_y]")
		to_world("Target Z = [target_z]")
		//debug
*/
		if(target_z)
			A.z = target_z
			A.y = world.maxy - 2
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)

	else if (src.y >= world.maxy)
		if(istype(A, /obj/effect/meteor)||istype(A, /obj/effect/space_dust))
			del(A)
			return
		var/list/cur_pos = src.get_global_map_pos()
		if(!cur_pos) return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		y_arr = global_map[cur_x]
		next_y = (++cur_y > y_arr.len ? 1 : cur_y)
		target_z = y_arr[next_y]
/*
		//debug
		to_world("Src.z = [src.z] in global map X = [cur_x], Y = [cur_y]")
		to_world("Next Y = [next_y]")
		to_world("Target Z = [target_z]")
		//debug
*/
		if(target_z)
			A.z = target_z
			A.y = 3
			spawn (0)
				if ((A && A.loc))
					A.loc.Entered(A)
	return

/obj/effect/vaultspawner
	var/maxX = 6
	var/maxY = 6
	var/minX = 2
	var/minY = 2

/obj/effect/vaultspawner/New(turf/location as turf,lX = minX,uX = maxX,lY = minY,uY = maxY,var/type = null)
	if(!type)
		type = pick("sandstone","rock","alien")

	var/lowBoundX = location.x
	var/lowBoundY = location.y

	var/hiBoundX = location.x + rand(lX,uX)
	var/hiBoundY = location.y + rand(lY,uY)

	var/z = location.z

	for(var/i = lowBoundX,i<=hiBoundX,i++)
		for(var/j = lowBoundY,j<=hiBoundY,j++)
			if(i == lowBoundX || i == hiBoundX || j == lowBoundY || j == hiBoundY)
				new /turf/closed/wall/vault(locate(i,j,z),type)
			else
				new /turf/open/floor/vault(locate(i,j,z),type)

	del(src)

/turf/proc/kill_creatures(mob/U = null)//Will kill people/creatures and damage mechs./N
//Useful to batch-add creatures to the list.
	for(var/mob/living/M in src)
		if(M==U)	continue//Will not harm U. Since null != M, can be excluded to kill everyone.
		spawn(0)
			M.gib()
	for(var/obj/mecha/M in src)//Mecha are not gibbed but are damaged.
		spawn(0)
			M.take_damage(100, "brute")
	for(var/obj/effect/critter/M in src)
		spawn(0)
			M.Die()

/turf/proc/Bless()
	if(HAS_TURF_FLAGS(src, TURF_NO_JAUNT))
		return
	SET_TURF_FLAGS(src, TURF_NO_JAUNT)
	add_overlay(image('icons/effects/water.dmi',src,"holywater"))*/