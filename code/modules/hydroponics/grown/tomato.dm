// This one has so many variants it gets it's own file.
// But should technically be under grown_fruit.dm. -Frenjo

/*
 * Tomato
 */
/obj/item/reagent_containers/food/snacks/grown/tomato
	seed = /obj/item/seeds/tomato
	name = "tomato"
	desc = "I say to-mah-to, you say tom-mae-to."
	icon_state = "tomato"
	filling_color = "#FF0000"
	potency = 10

/obj/item/reagent_containers/food/snacks/grown/tomato/initialise()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 10), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/obj/item/reagent_containers/food/snacks/grown/tomato/throw_impact(atom/hit_atom)
	..()
	new/obj/effect/decal/cleanable/tomato_smudge(src.loc)
	src.visible_message(SPAN_NOTICE("The [src.name] has been squashed."), SPAN_MODERATE("You hear a smack."))
	qdel(src)
	return

/*
 * Blood Tomato
 */
/obj/item/reagent_containers/food/snacks/grown/bloodtomato
	seed = /obj/item/seeds/tomato/blood
	name = "blood-tomato"
	desc = "So bloody...so...very...bloody....AHHHH!!!!"
	icon_state = "bloodtomato"
	potency = 10
	filling_color = "#FF0000"

/obj/item/reagent_containers/food/snacks/grown/bloodtomato/initialise()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 10), 1))
	reagents.add_reagent("blood", 1 + round((potency / 5), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/obj/item/reagent_containers/food/snacks/grown/bloodtomato/throw_impact(atom/hit_atom)
	..()
	new/obj/effect/decal/cleanable/blood/splatter(src.loc)
	src.visible_message(SPAN_NOTICE("The [src.name] has been squashed."), SPAN_MODERATE("You hear a smack."))
	src.reagents.reaction(get_turf(hit_atom))
	for(var/atom/A in get_turf(hit_atom))
		src.reagents.reaction(A)
	qdel(src)
	return

/*
 * Killer Tomato
 */
/obj/item/reagent_containers/food/snacks/grown/killertomato
	seed = /obj/item/seeds/tomato/killer
	name = "killer-tomato"
	desc = "I say to-mah-to, you say tom-mae-to... OH GOD IT'S EATING MY LEGS!!"
	icon_state = "killertomato"
	potency = 10
	filling_color = "#FF0000"

	lifespan = 120
	endurance = 30
	maturation = 15
	production = 1
	yield = 3
	potency = 30
	plant_type = 2

/obj/item/reagent_containers/food/snacks/grown/killertomato/initialise()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 10), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)
	if(ismob(loc))
		pickup(loc)

/obj/item/reagent_containers/food/snacks/grown/killertomato/attack_self(mob/user as mob)
	if(isspace(user.loc))
		return

	new /mob/living/simple_animal/tomato(user.loc)
	qdel(src)

	to_chat(user, SPAN_NOTICE("You plant the killer-tomato."))

/*
 * Blue Tomato
 */
/obj/item/reagent_containers/food/snacks/grown/bluetomato
	seed = /obj/item/seeds/tomato/blue
	name = "blue-tomato"
	desc = "I say blue-mah-to, you say blue-mae-to."
	icon_state = "bluetomato"
	potency = 10
	filling_color = "#586CFC"

/obj/item/reagent_containers/food/snacks/grown/bluetomato/initialise()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 20), 1))
	reagents.add_reagent("lube", 1 + round((potency / 5), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/obj/item/reagent_containers/food/snacks/grown/bluetomato/throw_impact(atom/hit_atom)
	..()
	new/obj/effect/decal/cleanable/blood/oil(src.loc)
	src.visible_message(
		SPAN_NOTICE("The [src.name] has been squashed."),
		SPAN_MODERATE("You hear a smack.")
	)
	src.reagents.reaction(get_turf(hit_atom))
	for(var/atom/A in get_turf(hit_atom))
		src.reagents.reaction(A)
	qdel(src)
	return

/obj/item/reagent_containers/food/snacks/grown/bluetomato/Crossed(AM as mob|obj)
	if(iscarbon(AM))
		var/mob/M =	AM
		if(ishuman(M))
			var/mob/living/carbon/human/human = M
			if(isobj(human.shoes) && HAS_ITEM_FLAGS(human.shoes, ITEM_FLAG_NO_SLIP))
				return

		M.stop_pulling()
		to_chat(M, SPAN_INFO("You slipped on the [name]!"))
		playsound(src, 'sound/misc/slip.ogg', 50, 1, -3)
		M.Stun(8)
		M.Weaken(5)

/*
 * Bluespace Tomato
 */
/obj/item/reagent_containers/food/snacks/grown/bluespacetomato
	seed = /obj/item/seeds/tomato/bluespace
	name = "blue-space tomato"
	desc = "So lubricated, you might slip through space-time."
	icon_state = "bluespacetomato"
	potency = 20
	origin_tech = list(/datum/tech/bluespace = 3)
	filling_color = "#91F8FF"

/obj/item/reagent_containers/food/snacks/grown/bluespacetomato/initialise()
	. = ..()
	reagents.add_reagent("nutriment", 1 + round((potency / 20), 1))
	reagents.add_reagent("singulo", 1 + round((potency / 5), 1))
	bitesize = 1 + round(reagents.total_volume / 2, 1)

/obj/item/reagent_containers/food/snacks/grown/bluespacetomato/throw_impact(atom/hit_atom)
	..()
	var/mob/M = usr
	var/outer_teleport_radius = potency / 10 //Plant potency determines radius of teleport.
	var/inner_teleport_radius = potency / 15
	var/list/turfs = list()
	var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
	if(inner_teleport_radius < 1) //Wasn't potent enough, it just splats.
		new/obj/effect/decal/cleanable/blood/oil(src.loc)
		src.visible_message(
			SPAN_NOTICE("The [src.name] has been squashed."),
			SPAN_MODERATE("You hear a smack.")
		)
		qdel(src)
		return
	for(var/turf/T in orange(M, outer_teleport_radius))
		if(T in orange(M, inner_teleport_radius))
			continue
		if(isspace(T))
			continue
		if(T.density)
			continue
		if(T.x > world.maxx-outer_teleport_radius || T.x < outer_teleport_radius)
			continue
		if(T.y > world.maxy-outer_teleport_radius || T.y < outer_teleport_radius)
			continue
		turfs += T
	if(!length(turfs))
		var/list/turfs_to_pick_from = list()
		for(var/turf/T in orange(M, outer_teleport_radius))
			if(!(T in orange(M, inner_teleport_radius)))
				turfs_to_pick_from += T
		turfs += pick(/turf in turfs_to_pick_from)
	var/turf/picked = pick(turfs)
	if(!isturf(picked))
		return
	switch(rand(1, 2))//Decides randomly to teleport the thrower or the throwee.
		if(1) // Teleports the person who threw the tomato.
			s.set_up(3, 1, M)
			s.start()
			new/obj/effect/decal/cleanable/molten_item(M.loc) //Leaves a pile of goo behind for dramatic effect.
			M.loc = picked //
			sleep(1)
			s.set_up(3, 1, M)
			s.start() //Two set of sparks, one before the teleport and one after.
		if(2) //Teleports mob the tomato hit instead.
			for(var/mob/A in get_turf(hit_atom))//For the mobs in the tile that was hit...
				s.set_up(3, 1, A)
				s.start()
				new/obj/effect/decal/cleanable/molten_item(A.loc) //Leave a pile of goo behind for dramatic effect...
				A.loc = picked//And teleport them to the chosen location.
				sleep(1)
				s.set_up(3, 1, A)
				s.start()
	new/obj/effect/decal/cleanable/blood/oil(src.loc)
	src.visible_message(
		SPAN_NOTICE("The [src.name] has been squashed, causing a distortion in space-time."),
		SPAN_MODERATE("You hear a splat and a crackle.")
	)
	qdel(src)
	return

/*
 * Gib Tomato
 */
/*
/obj/item/grown/gibtomato
	desc = "A plump tomato."
	icon = 'icons/obj/flora/harvest.dmi'
	name = "Gib Tomato"
	icon_state = "gibtomato"
	damtype = "fire"
	force = 0
	flags = TABLEPASS
	throwforce = 1
	w_class = 1.0
	throw_speed = 1
	throw_range = 3
	plant_type = 1
	seed = /obj/item/seeds/gibtomato

/obj/item/grown/gibtomato/New()
	..()
	src.gibs = new /obj/effect/gibspawner/human(get_turf(src))
	src.gibs.attach(src)
	src.smoke.set_up(10, 0, usr.loc)
*/