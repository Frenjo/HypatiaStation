// AI (i.e. game AI, not the AI player) controlled bots

// Defines for security bots.
#define SECBOT_IDLE 		0		// idle
#define SECBOT_HUNT 		1		// found target, hunting
#define SECBOT_PREP_ARREST 	2		// at target, preparing to arrest
#define SECBOT_ARREST		3		// arresting target
#define SECBOT_START_PATROL	4		// start patrol
#define SECBOT_PATROL		5		// patrolling
#define SECBOT_SUMMON		6		// summoned by PDA

/obj/machinery/bot
	icon = 'icons/obj/aibots.dmi'
	layer = MOB_LAYER
	light_range = 3

	power_state = USE_POWER_OFF

	var/obj/item/card/id/botcard			// the ID card that the bot "holds"
	var/on = TRUE
	var/health = 0 //do not forget to set health for your bot!
	var/maxhealth = 0
	var/fire_dam_coeff = 1
	var/brute_dam_coeff = 1
	var/open = FALSE //Maint panel
	var/locked = TRUE
	//var/emagged = 0 //Urist: Moving that var to the general /bot tree as it's used by most bots

/obj/machinery/bot/proc/turn_on()
	if(stat)
		return 0
	on = TRUE
	set_light(initial(light_range))
	return 1

/obj/machinery/bot/proc/turn_off()
	on = FALSE
	set_light(0)

/obj/machinery/bot/proc/explode()
	qdel(src)

/obj/machinery/bot/proc/healthcheck()
	if(health <= 0)
		explode()

/obj/machinery/bot/proc/Emag(mob/user as mob)
	if(locked)
		locked = FALSE
		emagged = 1
		to_chat(user, SPAN_WARNING("You bypass [src]'s controls."))
	if(!locked && open)
		emagged = 2

/obj/machinery/bot/examine()
	set src in view()
	..()
	if(health < maxhealth)
		if(health > maxhealth / 3)
			to_chat(usr, SPAN_WARNING("[src]'s parts look loose."))
		else
			to_chat(usr, SPAN_DANGER("[src]'s parts look very loose!"))

/obj/machinery/bot/attack_animal(mob/living/simple_animal/M as mob)
	if(M.melee_damage_upper == 0)
		return
	health -= M.melee_damage_upper
	visible_message(SPAN_DANGER("[M] has [M.attacktext] [src]!"))
	M.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [name]</font>")
	if(prob(10))
		new /obj/effect/decal/cleanable/blood/oil(loc)
	healthcheck()

/obj/machinery/bot/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/screwdriver))
		if(!locked)
			open = !open
			playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
			FEEDBACK_TOGGLE_MAINTENANCE_PANEL(user, open)
	else if(istype(W, /obj/item/weldingtool))
		if(health < maxhealth)
			if(open)
				health = min(maxhealth, health + 10)
				user.visible_message(
					SPAN_WARNING("[user] repairs [src]!"),
					SPAN_INFO("You repair [src]!")
				)
			else
				to_chat(user, SPAN_NOTICE("You must open the maintenance panel first."))
		else
			to_chat(user, SPAN_NOTICE("[src] does not need repairs."))
	else if(istype(W, /obj/item/card/emag) && emagged < 2)
		Emag(user)
	else
		if(hasvar(W, "force") && hasvar(W, "damtype"))
			switch(W.damtype)
				if("fire")
					health -= W.force * fire_dam_coeff
				if("brute")
					health -= W.force * brute_dam_coeff
			..()
			healthcheck()
		else
			..()

/obj/machinery/bot/bullet_act(obj/item/projectile/proj)
	health -= proj.damage
	..()
	healthcheck()

/obj/machinery/bot/meteorhit()
	explode()

/obj/machinery/bot/blob_act()
	health -= rand(20, 40) * fire_dam_coeff
	healthcheck()

/obj/machinery/bot/ex_act(severity)
	switch(severity)
		if(1)
			explode()
			return
		if(2)
			health -= rand(5, 10) * fire_dam_coeff
			health -= rand(10, 20) * brute_dam_coeff
			healthcheck()
			return
		if(3)
			if(prob(50))
				health -= rand(1, 5) * fire_dam_coeff
				health -= rand(1, 5) * brute_dam_coeff
				healthcheck()
				return

/obj/machinery/bot/emp_act(severity)
	var/was_on = on
	stat |= EMPED
	var/obj/effect/overlay/pulse2 = new /obj/effect/overlay(loc)
	pulse2.icon = 'icons/effects/effects.dmi'
	pulse2.icon_state = "empdisable"
	pulse2.name = "emp sparks"
	pulse2.anchored = TRUE
	pulse2.set_dir(pick(GLOBL.cardinal))

	spawn(10)
		qdel(pulse2)
	if(on)
		turn_off()
	spawn(severity * 300)
		stat &= ~EMPED
		if(was_on)
			turn_on()

/obj/machinery/bot/attack_ai(mob/user as mob)
	attack_hand(user)

/obj/machinery/bot/attack_hand(mob/living/carbon/human/user)
	if(!istype(user))
		return ..()

	if(user.species.can_shred(user))
		health -= rand(15, 30) * brute_dam_coeff
		visible_message(SPAN_DANGER("[user] has slashed [src]!"))
		playsound(src, 'sound/weapons/slice.ogg', 25, 1, -1)
		if(prob(10))
			new /obj/effect/decal/cleanable/blood/oil(loc)
		healthcheck()

/******************************************************************/
// Navigation procs
// Used for A-star pathfinding


// Returns the surrounding cardinal turfs with open links
// Including through doors openable with the ID
/turf/proc/CardinalTurfsWithAccess(obj/item/card/id/card)
	var/list/L = list()
	//	for(var/turf/simulated/t in oview(src,1))
	for(var/d in GLOBL.cardinal)
		var/turf/simulated/T = get_step(src, d)
		if(istype(T) && !T.density)
			if(!LinkBlockedWithAccess(src, T, card))
				L.Add(T)
	return L


// Returns true if a link between A and B is blocked
// Movement through doors allowed if ID has access
/proc/LinkBlockedWithAccess(turf/A, turf/B, obj/item/card/id/card)
	if(A == null || B == null)
		return 1
	var/adir = get_dir(A, B)
	var/rdir = get_dir(B, A)
	if((adir & (NORTH | SOUTH)) && (adir & (EAST | WEST)))	//	diagonal
		var/iStep = get_step(A, adir & (NORTH | SOUTH))
		if(!LinkBlockedWithAccess(A, iStep, card) && !LinkBlockedWithAccess(iStep, B, card))
			return 0

		var/pStep = get_step(A, adir & (EAST|WEST))
		if(!LinkBlockedWithAccess(A, pStep, card) && !LinkBlockedWithAccess(pStep, B, card))
			return 0
		return 1

	if(DirBlockedWithAccess(A, adir, card))
		return 1

	if(DirBlockedWithAccess(B, rdir, card))
		return 1

	for(var/obj/O in B)
		if(O.density && !istype(O, /obj/machinery/door) && !(O.flags & ON_BORDER))
			return 1

	return 0

// Returns true if direction is blocked from loc
// Checks doors against access with given ID
/proc/DirBlockedWithAccess(turf/loc, dir, obj/item/card/id/card)
	for(var/obj/structure/window/D in loc)
		if(!D.density)
			continue
		if(D.dir == SOUTHWEST)
			return 1
		if(D.dir == dir)
			return 1

	for(var/obj/machinery/door/D in loc)
		if(!D.density)
			continue
		if(istype(D, /obj/machinery/door/window))
			if(isnotnull(dir) & isnotnull(D.dir))
				return !D.check_access(card)

			//if((dir & SOUTH) && (D.dir & (EAST|WEST)))		return !D.check_access(card)
			//if((dir & EAST ) && (D.dir & (NORTH|SOUTH)))	return !D.check_access(card)
		else
			return !D.check_access(card)	// it's a real, air blocking door
	return 0