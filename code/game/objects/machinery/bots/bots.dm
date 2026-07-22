// AI (i.e. game AI, not the AI player) controlled bots

// Defines for security bots.
#define SECBOT_IDLE 		0		// idle
#define SECBOT_HUNT 		1		// found target, hunting
#define SECBOT_PREP_ARREST 	2		// at target, preparing to arrest
#define SECBOT_ARREST		3		// arresting target
#define SECBOT_START_PATROL	4		// start patrol
#define SECBOT_PATROL		5		// patrolling
#define SECBOT_SUMMON		6		// summoned by PDA

/mob/living/bot
	light_range = 3

	/// The ID card the bot has pinned to it
	var/obj/item/card/id/botcard
	/// What do you think it means?
	var/on = TRUE
	/// The bot's maintenance panel
	var/open = FALSE
	var/locked = TRUE

	/// Whether we're emagged. Can be 0, 1, or 2 for some reason
	var/emagged = 0

	var/fire_dam_coeff = 1
	var/brute_dam_coeff = 1

/mob/living/bot/New()
	SHOULD_CALL_PARENT(TRUE)

	. = ..()
	GLOBL.bots_list.Add(src)

/mob/living/bot/Destroy()
	GLOBL.bots_list.Remove(src)
	QDEL_NULL(botcard)
	return ..()

/mob/living/bot/proc/turn_on()
	if(stat)
		return FALSE

	on = TRUE
	set_light(initial(light_range))
	return TRUE

/mob/living/bot/proc/turn_off()
	on = FALSE
	set_light(0)

/mob/living/bot/proc/explode()
	SHOULD_CALL_PARENT(TRUE)
	qdel(src)

/mob/living/bot/proc/healthcheck()
	if(health <= 0)
		explode()

/mob/living/bot/proc/Emag(mob/user)
	if(locked)
		locked = FALSE
		emagged = 1
		to_chat(user, SPAN_WARNING("You bypass [src]'s controls."))
	if(!locked && open)
		emagged = 2

/mob/living/bot/get_examine_text()
	. = ..()
	if(health >= maxHealth)
		return
	if(health > maxHealth / 3)
		. += SPAN_WARNING("Its parts look loose.")
	else
		. += SPAN_DANGER("Its parts look very loose!")

/mob/living/bot/attack_animal(mob/living/simple/user)
	if(user.melee_damage_upper == 0)
		return
	visible_message(SPAN_DANGER("[user] has [user.attacktext] [src]!"))
	user.attack_log += "\[[time_stamp()]\] <font color='red'>attacked [name]</font>"
	if(prob(10))
		new /obj/effect/decal/cleanable/blood/oil(loc)
	apply_damage(rand(user.melee_damage_lower, user.melee_damage_upper), user.melee_damage_type)

/mob/living/bot/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(emagged == 2)
		FEEDBACK_ALREADY_EMAGGED(user)
		return FALSE

	Emag(user)
	return TRUE

/mob/living/bot/attackby(obj/item/attacking_item, mob/user)
	if(isscrewdriver(attacking_item))
		if(locked)
			return
		open = !open
		playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
		FEEDBACK_TOGGLE_MAINTENANCE_PANEL(user, open)
		return

	if(iswelder(attacking_item))
		if(health >= maxHealth)
			to_chat(user, SPAN_NOTICE("[src] does not need repairs."))
			return

		if(!open)
			to_chat(user, SPAN_WARNING("You must open the maintenance panel first."))
			return
		health = min(maxHealth, health + 10)
		user.visible_message(
			SPAN_WARNING("[user] repairs [src]!"),
			SPAN_INFO("You repair [src]!")
		)
		return	

	if(!hasvar(attacking_item, "force") || !hasvar(attacking_item, "damtype"))
		return ..()
		
	var/damage = null
	switch(attacking_item.damtype)
		if("fire")
			damage = attacking_item.force * fire_dam_coeff
		if("brute")
			damage = attacking_item.force * brute_dam_coeff
		else
			damage = attacking_item.force

	apply_damage(damage, attacking_item.damtype)

/mob/living/bot/bullet_act(obj/projectile/bullet)
	if(bullet.damage_type != BRUTE && bullet.damage_type != BURN)
		return
	apply_damage(bullet.damage, bullet.damage_type)

/mob/living/bot/meteorhit()
	explode()

/mob/living/bot/blob_act()
	apply_damage(rand(20, 40) * fire_dam_coeff, BURN)

/mob/living/bot/ex_act(severity)
	switch(severity)
		if(1)
			explode()
			return
		if(2)
			apply_damage(rand(5, 10) * fire_dam_coeff, BURN)
			apply_damage(rand(10, 20) * brute_dam_coeff, BRUTE)
			return

		if(3)
			if(!prob(50))
				return
			apply_damage(rand(1, 5) * fire_dam_coeff, BURN)
			apply_damage(rand(1, 5) * brute_dam_coeff, BRUTE)
			return

/mob/living/bot/emp_act(severity)
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

/mob/living/bot/attack_ai(mob/user)
	attack_hand(user)

/mob/living/bot/attack_hand(mob/living/user)
	if(!istype(user, /mob/living/carbon/human))
		return

	if(!astype(user, /mob/living/carbon/human).species.can_shred(user))
		return

	visible_message(SPAN_DANGER("[user] has slashed [src]!"))
	playsound(src, 'sound/weapons/melee/slice.ogg', 25, 1, -1)
	if(prob(10))
		new /obj/effect/decal/cleanable/blood/oil(loc)
	apply_damage(rand(15, 30) * brute_dam_coeff, BRUTE)
	

/******************************************************************/
// Navigation procs
// Used for A-star pathfinding

// Returns the surrounding cardinal turfs with open links
// Including through doors openable with the ID
/turf/proc/CardinalTurfsWithAccess(obj/item/card/id/card)
	var/list/L = list()
	//	for(var/turf/open/t in oview(src,1))
	for(var/d in GLOBL.cardinal)
		var/turf/open/T = get_step(src, d)
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
		if(O.density && !istype(O, /obj/machinery/door) && !O.is_on_border())
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
			if(isnotnull(dir) && isnotnull(D.dir))
				return !D.check_access(card)

			//if((dir & SOUTH) && (D.dir & (EAST|WEST)))		return !D.check_access(card)
			//if((dir & EAST ) && (D.dir & (NORTH|SOUTH)))	return !D.check_access(card)
		else
			return !D.check_access(card)	// it's a real, air blocking door
	return 0