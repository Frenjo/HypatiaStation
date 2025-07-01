/obj/effect/blob/node
	name = "blob node"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_node"
	health = 100
	brute_resist = 1
	fire_resist = 2

/obj/effect/blob/node/New(loc, h = 100)
	GLOBL.blobs.Add(src)
	GLOBL.blob_nodes.Add(src)
	. = ..(loc, h)

/obj/effect/blob/node/initialise()
	. = ..()
	START_PROCESSING(PCobj, src)

/obj/effect/blob/node/Destroy()
	GLOBL.blob_nodes.Remove(src)
	STOP_PROCESSING(PCobj, src)
	return ..()

/obj/effect/blob/node/update_icon()
	if(health <= 0)
		playsound(src, 'sound/effects/splat.ogg', 50, 1)
		qdel(src)

/obj/effect/blob/node/run_action()
	Pulse(0, 0)
	return 0