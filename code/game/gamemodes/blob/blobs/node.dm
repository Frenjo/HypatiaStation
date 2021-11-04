/obj/effect/blob/node
	name = "blob node"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_node"
	health = 100
	brute_resist = 1
	fire_resist = 2

/obj/effect/blob/node/New(loc, h = 100)
	blobs += src
	blob_nodes += src
	processing_objects.Add(src)
	..(loc, h)

/obj/effect/blob/node/Destroy()
	blob_nodes -= src
	processing_objects.Remove(src)
	return ..()

/obj/effect/blob/node/update_icon()
	if(health <= 0)
		playsound(src, 'sound/effects/splat.ogg', 50, 1)
		qdel(src)
		return
	return

/obj/effect/blob/node/run_action()
	Pulse(0, 0)
	return 0