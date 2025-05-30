/obj/item/veilrender
	name = "veil render"
	desc = "A wicked curved blade of alien origin, recovered from the ruins of a vast city."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "render"
	item_state = "render"
	force = 15
	throwforce = 10
	w_class = 3
	var/charged = 1

/obj/item/veilrender/attack_self(mob/user)
	if(charged == 1)
		new /obj/effect/rend(GET_TURF(usr))
		charged = 0
		visible_message(SPAN_DANGER("[src] hums with power as [usr] deals a blow to reality itself!"))
	else
		to_chat(user, SPAN_WARNING("The unearthly energies that powered the blade are now dormant."))


/obj/effect/rend
	name = "Tear in the fabric of reality"
	desc = "You should run now"
	icon = 'icons/obj/biomass.dmi'
	icon_state = "rift"
	density = TRUE
	anchored = TRUE

/obj/effect/rend/New()
	. = ..()
	spawn(50)
		new /obj/singularity/narsie/wizard(GET_TURF(src))
		qdel(src)