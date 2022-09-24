/mob/living/carbon/brain/death(gibbed)
	if(!gibbed && istype(container, /obj/item/device/mmi)) //If not gibbed but in a container.
		container.icon_state = "mmi_dead"
	stat = DEAD

	return ..(gibbed, "beeps shrilly as the MMI flatlines!")

/mob/living/carbon/brain/gib()
	if(istype(container, /obj/item/device/mmi))
		qdel(container)//Gets rid of the MMI if there is one
	if(loc)
		if(istype(loc, /obj/item/brain))
			qdel(loc)//Gets rid of the brain item

	..(null, 1)