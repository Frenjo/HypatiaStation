/obj/item/grenade/spawner
	desc = "It is set to detonate in 5 seconds. It will unleash unleash an unspecified anomaly into the vicinity."
	name = "delivery grenade"
	icon_state = "delivery"
	item_state = "flashbang"
	origin_tech = alist(/decl/tech/materials = 3, /decl/tech/magnets = 4)

	var/banglet = 0
	var/spawn_type = null // must be a type path
	var/deliveryamt = 1 // amount of type to deliver

/obj/item/grenade/spawner/prime()	// Prime now just handles the two loops that query for people in lockers and people who can see it.
	if(isnotnull(spawn_type) && deliveryamt)
		// Make a quick flash
		var/turf/T = GET_TURF(src)
		playsound(T, 'sound/effects/phasein.ogg', 100, 1)
		for(var/mob/living/carbon/human/H in viewers(T, null))
			if(H.eyecheck() <= 0)
				flick("e_flash", H.flash)

		for(var/i = 1, i <= deliveryamt, i++)
			var/atom/movable/x = new spawn_type(T)
			if(prob(50))
				for(var/j = 1, j <= rand(1, 3), j++)
					step(x, pick(GLOBL.cardinal))

			// Spawn some hostile syndicate critters

	qdel(src)

/obj/item/grenade/spawner/manhacks
	name = "manhack delivery grenade"
	spawn_type = /mob/living/simple/hostile/viscerator
	deliveryamt = 5
	origin_tech = alist(/decl/tech/materials = 3, /decl/tech/magnets = 4, /decl/tech/syndicate = 4)

/obj/item/grenade/spawner/spesscarp
	name = "carp delivery grenade"
	spawn_type = /mob/living/simple/hostile/carp
	deliveryamt = 5
	origin_tech = alist(/decl/tech/materials = 3, /decl/tech/magnets = 4, /decl/tech/syndicate = 4)