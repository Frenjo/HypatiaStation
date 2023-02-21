/obj/machinery/gateway
	name = "gateway"
	desc = "A mysterious gateway built by unknown hands, it allows for faster than light travel to far-flung locations."
	icon = 'icons/obj/machines/gateway.dmi'
	icon_state = "off"
	density = TRUE
	anchored = TRUE

	var/active = FALSE

/obj/machinery/gateway/initialize()
	. = ..()
	update_icon()
	if(dir == 2)
		density = FALSE

/obj/machinery/gateway/update_icon()
	if(active)
		icon_state = "on"
		return
	icon_state = "off"


//this is da important part wot makes things go
/obj/machinery/gateway/centerstation
	density = TRUE
	icon_state = "offcenter"
	use_power = TRUE

	//warping vars
	var/list/linked = list()
	var/ready = FALSE			//have we got all the parts for a gateway?
	var/wait = 0				//this just grabs world.time at world start
	var/obj/machinery/gateway/centeraway/awaygate = null

/obj/machinery/gateway/centerstation/initialize()
	. = ..()
	update_icon()
	wait = world.time + CONFIG_GET(gateway_delay)	//+ thirty minutes default
	awaygate = locate(/obj/machinery/gateway/centeraway)

/obj/machinery/gateway/centerstation/update_icon()
	if(active)
		icon_state = "oncenter"
		return
	icon_state = "offcenter"

/obj/machinery/gateway/centerstation/process()
	if(stat & (NOPOWER))
		if(active)
			toggleoff()
		return

	if(active)
		use_power(5000)

/obj/machinery/gateway/centerstation/proc/detect()
	linked = list()	//clear the list
	var/turf/T = loc

	for(var/i in GLOBL.alldirs)
		T = get_step(loc, i)
		var/obj/machinery/gateway/G = locate(/obj/machinery/gateway) in T
		if(G)
			linked.Add(G)
			continue

		//this is only done if we fail to find a part
		ready = FALSE
		toggleoff()
		break

	if(length(linked) == 8)
		ready = TRUE

/obj/machinery/gateway/centerstation/proc/toggleon(mob/user as mob)
	if(!ready)
		return
	if(length(linked) != 8)
		return
	if(!powered())
		return
	if(!awaygate)
		to_chat(user, SPAN_NOTICE("Error: No destination found."))
		return
	if(world.time < wait)
		to_chat(user, SPAN_NOTICE("Error: Warpspace triangulation in progress. Estimated time to completion: [round(((wait - world.time) / 10) / 60)] minutes."))
		return

	for(var/obj/machinery/gateway/G in linked)
		G.active = TRUE
		G.update_icon()
	active = TRUE
	update_icon()

/obj/machinery/gateway/centerstation/proc/toggleoff()
	for(var/obj/machinery/gateway/G in linked)
		G.active = FALSE
		G.update_icon()
	active = FALSE
	update_icon()

/obj/machinery/gateway/centerstation/attack_hand(mob/user as mob)
	if(!ready)
		detect()
		return
	if(!active)
		toggleon(user)
		return
	toggleoff()

//okay, here's the good teleporting stuff
/obj/machinery/gateway/centerstation/Bumped(atom/movable/M as mob|obj)
	if(!ready)
		return
	if(!active)
		return
	if(!awaygate)
		return
	if(awaygate.calibrated)
		M.loc = get_step(awaygate.loc, SOUTH)
		M.set_dir(SOUTH)
		return
	else
		var/obj/effect/landmark/dest = pick(GLOBL.awaydestinations)
		if(dest)
			M.loc = dest.loc
			M.set_dir(SOUTH)
			use_power(5000)
		return

/obj/machinery/gateway/centerstation/attackby(obj/item/device/W as obj, mob/user as mob)
	if(istype(W,/obj/item/device/multitool))
		to_chat(user, "\black The gate is already calibrated, there is no work for you to do here.")
		return


/////////////////////////////////////Away////////////////////////
/obj/machinery/gateway/centeraway
	density = TRUE
	icon_state = "offcenter"
	use_power = FALSE

	var/calibrated = TRUE
	var/list/linked = list()	//a list of the connected gateway chunks
	var/ready = FALSE
	var/obj/machinery/gateway/centeraway/stationgate = null

/obj/machinery/gateway/centeraway/initialize()
	. = ..()
	update_icon()
	stationgate = locate(/obj/machinery/gateway/centerstation)

/obj/machinery/gateway/centeraway/update_icon()
	if(active)
		icon_state = "oncenter"
		return
	icon_state = "offcenter"

/obj/machinery/gateway/centeraway/proc/detect()
	linked = list()	//clear the list
	var/turf/T = loc

	for(var/i in GLOBL.alldirs)
		T = get_step(loc, i)
		var/obj/machinery/gateway/G = locate(/obj/machinery/gateway) in T
		if(G)
			linked.Add(G)
			continue

		//this is only done if we fail to find a part
		ready = FALSE
		toggleoff()
		break

	if(length(linked) == 8)
		ready = TRUE

/obj/machinery/gateway/centeraway/proc/toggleon(mob/user as mob)
	if(!ready)
		return
	if(length(linked) != 8)
		return
	if(!stationgate)
		to_chat(user, SPAN_NOTICE("Error: No destination found."))
		return

	for(var/obj/machinery/gateway/G in linked)
		G.active = TRUE
		G.update_icon()
	active = TRUE
	update_icon()

/obj/machinery/gateway/centeraway/proc/toggleoff()
	for(var/obj/machinery/gateway/G in linked)
		G.active = FALSE
		G.update_icon()
	active = FALSE
	update_icon()

/obj/machinery/gateway/centeraway/attack_hand(mob/user as mob)
	if(!ready)
		detect()
		return
	if(!active)
		toggleon(user)
		return
	toggleoff()

/obj/machinery/gateway/centeraway/Bumped(atom/movable/M as mob|obj)
	if(!ready)
		return
	if(!active)
		return
	if(iscarbon(M))
		for(var/obj/item/weapon/implant/exile/E in M)//Checking that there is an exile implant in the contents
			if(E.imp_in == M)//Checking that it's actually implanted vs just in their pocket
				to_chat(M, "\black The station gate has detected your exile implant and is blocking your entry.")
				return
	M.loc = get_step(stationgate.loc, SOUTH)
	M.set_dir(SOUTH)


/obj/machinery/gateway/centeraway/attackby(obj/item/device/W as obj, mob/user as mob)
	if(istype(W, /obj/item/device/multitool))
		if(calibrated)
			to_chat(user, "\black The gate is already calibrated, there is no work for you to do here.")
			return
		else
			to_chat(user, "\blue <b>Recalibration successful!</b>: \black This gate's systems have been fine tuned. Travel to this gate will now be on target.")
			calibrated = TRUE
			return