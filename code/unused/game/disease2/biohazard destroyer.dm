/obj/machinery/disease2/biodestroyer
	name = "Biohazard destroyer"
	icon = 'icons/obj/pipes/disposal.dmi'
	icon_state = "disposal"
	var/list/accepts = list(/obj/item/clothing,/obj/item/virusdish/,/obj/item/cureimplanter,/obj/item/diseasedisk)
	density = TRUE
	anchored = TRUE

/obj/machinery/disease2/biodestroyer/attackby(var/obj/I as obj, var/mob/user as mob)
	for(var/path in accepts)
		if(I.type in typesof(path))
			user.drop_item()
			del(I)
			add_overlay(image('icons/obj/pipes/disposal.dmi', "dispover-handle"))
			return
	user.drop_item()
	I.forceMove(loc)

	for(var/mob/O in hearers(src, null))
		O.show_message("[html_icon(src)] \blue The [src.name] beeps", 2)
