/obj/effect/shield
	name = "emergency energy shield"
	desc = "An energy shield used to contain hull breaches."
	icon_state = "shield-old"
	density = TRUE
	anchored = TRUE

	var/const/max_health = 200
	var/health = max_health //The shield can only take so much beating (prevents perma-prisons)

/obj/effect/shield/initialise()
	. = ..()
	set_dir(pick(GLOBL.cardinal))
	update_nearby_tiles(need_rebuild = 1)

/obj/effect/shield/Destroy()
	set_opacity(FALSE)
	density = FALSE
	update_nearby_tiles()
	return ..()

/obj/effect/shield/CanPass(atom/movable/mover, turf/target, height, air_group)
	if(!height || air_group)
		return FALSE
	else
		return ..()

//Looks like copy/pasted code... I doubt 'need_rebuild' is even used here - Nodrak
/obj/effect/shield/proc/update_nearby_tiles(need_rebuild)
	global.PCair?.mark_for_update(GET_TURF(src))

/obj/effect/shield/attackby(obj/item/W, mob/user)
	if(!istype(W))
		return

	//Calculate damage
	var/aforce = W.force
	if(W.damtype == BRUTE || W.damtype == BURN)
		health -= aforce

	//Play a fitting sound
	playsound(src, 'sound/effects/EMPulse.ogg', 75, 1)

	if(health <= 0)
		visible_message(SPAN_INFO("\The [src] dissipates!"))
		qdel(src)
		return

	set_opacity(TRUE)
	spawn(2 SECONDS)
		if(src)
			set_opacity(FALSE)

	..()

/obj/effect/shield/meteorhit()
	health -= max_health * 0.75 //3/4 health as damage

	if(health <= 0)
		visible_message(SPAN_INFO("\The [src] dissipates!"))
		qdel(src)
		return

	set_opacity(TRUE)
	spawn(2 SECONDS)
		if(src)
			set_opacity(FALSE)

/obj/effect/shield/bullet_act(obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	if(health <= 0)
		visible_message(SPAN_INFO("\The [src] dissipates!"))
		qdel(src)
		return

	set_opacity(TRUE)
	spawn(2 SECONDS)
		if(src)
			set_opacity(FALSE)

/obj/effect/shield/ex_act(severity)
	switch(severity)
		if(1.0)
			if(prob(75))
				qdel(src)
		if(2.0)
			if(prob(50))
				qdel(src)
		if(3.0)
			if(prob(25))
				qdel(src)

/obj/effect/shield/emp_act(severity)
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			if(prob(50))
				qdel(src)

/obj/effect/shield/blob_act()
	qdel(src)

/obj/effect/shield/hitby(atom/movable/mover)
	//Let everyone know we've been hit!
	visible_message(SPAN_DANGER("[src] was hit by [mover]!"))

	//Super realistic, resource-intensive, real-time damage calculations.
	var/tforce = 0
	if(ismob(mover))
		tforce = 40
	else
		tforce = mover:throwforce

	health -= tforce

	//This seemed to be the best sound for hitting a force field.
	playsound(src, 'sound/effects/EMPulse.ogg', 100, 1)

	//Handle the destruction of the shield
	if(health <= 0)
		visible_message(SPAN_INFO("\The [src] dissipates!"))
		qdel(src)
		return

	//The shield becomes dense to absorb the blow.. purely asthetic.
	set_opacity(TRUE)
	spawn(2 SECONDS)
		if(src)
			set_opacity(FALSE)

	return ..()