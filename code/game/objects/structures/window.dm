/obj/structure/window
	name = "window"
	desc = "A window."
	icon = 'icons/obj/structures/windows.dmi'
	density = TRUE
	layer = 3.2//Just above doors
	pressure_resistance = 4 * ONE_ATMOSPHERE
	anchored = TRUE
	atom_flags = ATOM_FLAG_ON_BORDER

	var/maxhealth = 14.0
	var/health
	var/ini_dir = null
	var/state = 2
	var/reinf = 0
	var/basestate
	var/shardtype = /obj/item/shard
//	var/silicate = 0 // number of units of silicate
//	var/icon/silicateIcon = null // the silicated icon

/obj/structure/window/New(Loc, re = 0)
	..()
	health = maxhealth

//	if(re)
//		reinf = re

	ini_dir = dir

	update_nearby_tiles(need_rebuild = 1)
	update_nearby_icons()

	return

/obj/structure/window/Destroy()
	density = FALSE
	update_nearby_tiles()
	update_nearby_icons()
	return ..()

/obj/structure/window/proc/take_damage(damage = 0, sound_effect = 1)
	var/initialhealth = src.health
	src.health = max(0, src.health - damage)
	if(src.health <= 0)
		src.shatter()
	else
		if(sound_effect)
			playsound(loc, 'sound/effects/Glasshit.ogg', 100, 1)
		if(src.health < src.maxhealth / 4 && initialhealth >= src.maxhealth / 4)
			visible_message("[src] looks like it's about to shatter!" )
		else if(src.health < src.maxhealth / 2 && initialhealth >= src.maxhealth / 2)
			visible_message("[src] looks seriously damaged!" )
		else if(src.health < src.maxhealth * 3 / 4 && initialhealth >= src.maxhealth * 3 / 4)
			visible_message("Cracks begin to appear in [src]!" )
	return

/obj/structure/window/proc/shatter(display_message = 1)
	playsound(src, "shatter", 70, 1)
	if(display_message)
		visible_message("[src] shatters!")
	if(dir == SOUTHWEST)
		var/index = null
		index = 0
		while(index < 2)
			new shardtype(loc)
			if(reinf)
				new /obj/item/stack/rods(loc)
			index++
	else
		new shardtype(loc)
		if(reinf)
			new /obj/item/stack/rods(loc)
	qdel(src)
	return

/obj/structure/window/bullet_act(obj/item/projectile/Proj)
	take_damage(Proj.damage)
	return

/obj/structure/window/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			shatter(0)
			return
		if(3.0)
			if(prob(50))
				shatter(0)
				return

/obj/structure/window/blob_act()
	shatter()

/obj/structure/window/meteorhit()
	shatter()

/obj/structure/window/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(istype(mover) && HAS_PASS_FLAGS(mover, PASS_FLAG_GLASS))
		return TRUE
	if(dir == SOUTHWEST || dir == SOUTHEAST || dir == NORTHWEST || dir == NORTHEAST)
		return FALSE	//full tile window, you can't move into it!
	if(get_dir(loc, target) == dir)
		return !density
	else
		return TRUE

/obj/structure/window/CheckExit(atom/movable/mover, turf/target)
	if(istype(mover) && HAS_PASS_FLAGS(mover, PASS_FLAG_GLASS))
		return 1
	if(get_dir(mover.loc, target) == dir)
		return 0
	return 1

/obj/structure/window/hitby(atom/movable/AM)
	..()
	visible_message(SPAN_DANGER("[src] was hit by [AM]."))
	var/tforce = 0
	if(ismob(AM))
		tforce = 40
	else if(isobj(AM))
		var/obj/item/I = AM
		tforce = I.throwforce
	if(reinf)
		tforce *= 0.25
	if(health - tforce <= 7 && !reinf)
		anchored = FALSE
		update_nearby_icons()
		step(src, get_dir(AM, src))
	take_damage(tforce)

/obj/structure/window/attack_tk(mob/user)
	user.visible_message(SPAN_NOTICE("Something knocks on [src]."))
	playsound(loc, 'sound/effects/Glasshit.ogg', 50, 1)

/obj/structure/window/attack_hand(mob/user)
	if(HULK in user.mutations)
		user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!"))
		user.visible_message(SPAN_DANGER("[user] smashes through [src]!"))
		shatter()
	else if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(user.a_intent == "hurt")
			if(H.species.can_shred(H))
				attack_generic(H, 25)
				return

			playsound(src, 'sound/effects/glassknock.ogg', 80, 1)
			user.visible_message(
				SPAN_WARNING("[user.name] bangs against the [src.name]!"),
				SPAN_WARNING("You bang against the [src.name]!"),
				"You hear a banging sound."
			)
		else
			playsound(src, 'sound/effects/glassknock.ogg', 80, 1)
			user.visible_message(
				"[user.name] knocks on the [src.name].",
				"You knock on the [src.name].",
				"You hear a knocking sound."
			)
	return

/obj/structure/window/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/window/proc/attack_generic(mob/user, damage = 0)	//used by attack_animal and attack_slime
	user.visible_message(SPAN_DANGER("[user] smashes into [src]!"))
	take_damage(damage)

/obj/structure/window/attack_animal(mob/user)
	if(!isanimal(user))
		return
	var/mob/living/simple_animal/M = user
	if(M.melee_damage_upper <= 0)
		return
	attack_generic(M, M.melee_damage_upper)

/obj/structure/window/attack_slime(mob/user)
	if(!isslimeadult(user))
		return
	attack_generic(user, rand(10, 15))

/obj/structure/window/attackby(obj/item/W, mob/user)
	if(!istype(W))
		return//I really wish I did not need this

	if(istype(W, /obj/item/grab) && get_dist(src, user) < 2)
		var/obj/item/grab/G = W
		if(isliving(G.affecting))
			var/mob/living/M = G.affecting
			var/state = G.state
			qdel(W)	//gotta delete it here because if window breaks, it won't get deleted
			switch(state)
				if(1)
					M.visible_message(SPAN_WARNING("[user] slams [M] against \the [src]!"))
					M.apply_damage(7)
					hit(10)
				if(2)
					M.visible_message(SPAN_DANGER("[user] bashes [M] against \the [src]!"))
					if(prob(50))
						M.Weaken(1)
					M.apply_damage(10)
					hit(25)
				if(3)
					M.visible_message(SPAN_DANGER("<big>[user] crushes [M] against \the [src]!</big>"))
					M.Weaken(5)
					M.apply_damage(20)
					hit(50)
			return

	if(HAS_ITEM_FLAGS(W, ITEM_FLAG_NO_BLUDGEON))
		return

	if(istype(W, /obj/item/screwdriver))
		if(reinf && state >= 1)
			state = 3 - state
			playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
			to_chat(user, SPAN_NOTICE("[state == 1 ? "You have unfastened the window from the frame" : "You have fastened the window to the frame"]."))
		else if(reinf && state == 0)
			anchored = !anchored
			update_nearby_icons()
			playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
			to_chat(user, SPAN_NOTICE("[anchored ? "You have fastened the frame to the floor" : "You have unfastened the frame from the floor"]."))
		else if(!reinf)
			anchored = !anchored
			update_nearby_icons()
			playsound(loc, 'sound/items/Screwdriver.ogg', 75, 1)
			to_chat(user, SPAN_NOTICE("[anchored ? "You have fastened the window to the floor" : "You have unfastened the window"]."))
	else if(istype(W, /obj/item/crowbar) && reinf && state <= 1)
		state = 1 - state
		playsound(loc, 'sound/items/Crowbar.ogg', 75, 1)
		to_chat(user, SPAN_NOTICE("[state ? "You have pried the window into the frame" : "You have pried the window out of the frame"]."))
	else
		if(W.damtype == BRUTE || W.damtype == BURN)
			hit(W.force)
			if(health <= 7)
				anchored = FALSE
				update_nearby_icons()
				step(src, get_dir(user, src))
		else
			playsound(loc, 'sound/effects/Glasshit.ogg', 75, 1)
		..()
	return

/obj/structure/window/proc/hit(damage, sound_effect = 1)
	if(reinf)
		damage *= 0.5
		take_damage(damage)
	return

/obj/structure/window/verb/rotate()
	set category = PANEL_OBJECT
	set name = "Rotate Window Counter-Clockwise"
	set src in oview(1)

	if(anchored)
		to_chat(usr, "It is fastened to the floor therefore you can't rotate it!")
		return 0

	update_nearby_tiles(need_rebuild = 1) //Compel updates before
	set_dir(turn(dir, 90))
//	updateSilicate()
	update_nearby_tiles(need_rebuild = 1)
	ini_dir = dir
	return

/obj/structure/window/verb/revrotate()
	set category = PANEL_OBJECT
	set name = "Rotate Window Clockwise"
	set src in oview(1)

	if(anchored)
		to_chat(usr, "It is fastened to the floor therefore you can't rotate it!")
		return 0

	update_nearby_tiles(need_rebuild = 1) //Compel updates before
	set_dir(turn(dir, 270))
//	updateSilicate()
	update_nearby_tiles(need_rebuild = 1)
	ini_dir = dir
	return

/*
/obj/structure/window/proc/updateSilicate()
	if(silicateIcon && silicate)
		icon = initial(icon)

		var/icon/I = icon(icon,icon_state,dir)

		var/r = (silicate / 100) + 1
		var/g = (silicate / 70) + 1
		var/b = (silicate / 50) + 1
		I.SetIntensity(r,g,b)
		icon = I
		silicateIcon = I
*/

/obj/structure/window/Move()
	update_nearby_tiles(need_rebuild = 1)
	..()
	dir = ini_dir
	update_nearby_tiles(need_rebuild = 1)

//This proc has to do with airgroups and atmos, it has nothing to do with smoothwindows, that's update_nearby_tiles().
/obj/structure/window/proc/update_nearby_tiles(need_rebuild)
	if(!global.PCair)
		return 0
	global.PCair.mark_for_update(get_turf(src))

	return 1

//checks if this window is full-tile one
/obj/structure/window/proc/is_fulltile()
	if(dir & (dir - 1))
		return 1
	return 0

//This proc is used to update the icons of nearby windows. It should not be confused with update_nearby_tiles(), which is an atmos proc!
/obj/structure/window/proc/update_nearby_icons()
	update_icon()
	for(var/direction in GLOBL.cardinal)
		for(var/obj/structure/window/W in get_step(src, direction))
			W.update_icon()

//merges adjacent full-tile windows into one (blatant ripoff from game/smoothwall.dm)
/obj/structure/window/update_icon()
	//A little cludge here, since I don't know how it will work with slim windows. Most likely VERY wrong.
	//this way it will only update full-tile ones
	//This spawn is here so windows get properly updated when one gets deleted.
	spawn(2)
		if(isnull(src))
			return
		var/junction = 0 //will be used to determine from which side the window is connected to other windows
		for(var/turf/simulated/wall/W in orange(src, 1))
			if(abs(x - W.x) - abs(y - W.y))		//doesn't count windows, placed diagonally to src
				junction |= get_dir(src, W)
		if(!is_fulltile())
			icon_state = "[basestate]"
			return
		if(anchored)
			for(var/obj/structure/window/W in orange(src, 1))
				if(W.anchored && W.density && W.is_fulltile()) //Only counts anchored, not-destroyed fill-tile windows.
					if(abs(x - W.x) - abs(y - W.y)) 		//doesn't count windows, placed diagonally to src
						junction |= get_dir(src, W)
		if(opacity)
			icon_state = "[basestate][junction]"
		else
			if(reinf)
				icon_state = "[basestate][junction]"
			else
				icon_state = "[basestate][junction]"

		return

/obj/structure/window/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > T0C + 800)
		hit(round(exposed_volume / 100), 0)
	..()

/obj/structure/window/basic
	desc = "It looks thin and flimsy. A few knocks with... anything, really should shatter it."
	icon_state = "window"
	basestate = "window"

/obj/structure/window/plasmabasic
	name = "plasma window"
	desc = "A plasma-glass alloy window. It looks insanely tough to break. It appears it's also insanely tough to burn through."
	basestate = "plasmawindow"
	icon_state = "plasmawindow"
	shardtype = /obj/item/shard/plasma
	maxhealth = 120

/obj/structure/window/plasmabasic/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > T0C + 32000)
		hit(round(exposed_volume / 1000), 0)
	..()

/obj/structure/window/plasmareinforced
	name = "reinforced plasma window"
	desc = "A plasma-glass alloy window, with rods supporting it. It looks hopelessly tough to break. It also looks completely fireproof, considering how basic plasma windows are insanely fireproof."
	basestate = "plasmarwindow"
	icon_state = "plasmarwindow"
	shardtype = /obj/item/shard/plasma
	reinf = 1
	maxhealth = 160

/obj/structure/window/plasmareinforced/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return

/obj/structure/window/reinforced
	name = "reinforced window"
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon_state = "rwindow"
	basestate = "rwindow"
	maxhealth = 40
	reinf = 1

/obj/structure/window/reinforced/tinted
	name = "tinted window"
	desc = "It looks rather strong and opaque. Might take a few good hits to shatter it."
	icon_state = "twindow"
	basestate = "twindow"
	opacity = TRUE

/obj/structure/window/reinforced/tinted/frosted
	name = "frosted window"
	desc = "It looks rather strong and frosted over. Looks like it might take a few less hits then a normal reinforced window."
	icon_state = "fwindow"
	basestate = "fwindow"
	maxhealth = 30