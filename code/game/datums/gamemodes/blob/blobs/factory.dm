/obj/effect/blob/factory
	name = "porous blob"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_factory"
	health = 100
	brute_resist = 1
	fire_resist = 2
	var/list/spores = list()
	var/max_spores = 4

/obj/effect/blob/factory/update_icon()
	if(health <= 0)
		playsound(src, 'sound/effects/splat.ogg', 50, 1)
		qdel(src)
		return
	return

/obj/effect/blob/factory/run_action()
	if(length(spores) >= max_spores)
		return 0
	new/mob/living/simple_animal/hostile/blobspore(src.loc, src)
	return 1

/obj/effect/blob/factory/Destroy()
	for(var/mob/living/simple_animal/hostile/blobspore/spore in spores)
		if(spore.factory == src)
			spore.factory = null
	return ..()

/mob/living/simple_animal/hostile/blobspore
	name = "blob"
	desc = "Some blob thing."
	icon = 'icons/mob/critter.dmi'
	icon_state = "blobsquiggle"
	icon_living = "blobsquiggle"
	pass_flags = PASSBLOB
	health = 20
	maxHealth = 20
	melee_damage_lower = 4
	melee_damage_upper = 8
	attacktext = "hits"
	attack_sound = 'sound/weapons/genhit1.ogg'
	var/obj/effect/blob/factory/factory = null
	faction = "blob"
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = 360

/mob/living/simple_animal/hostile/blobspore/New(loc, var/obj/effect/blob/factory/linked_node)
	..()
	if(istype(linked_node))
		factory = linked_node
		factory.spores += src
	..(loc)
	return

/mob/living/simple_animal/hostile/blobspore/Die()
	qdel(src)

/mob/living/simple_animal/hostile/blobspore/Destroy()
	if(factory)
		factory.spores -= src
		factory = null
	return ..()