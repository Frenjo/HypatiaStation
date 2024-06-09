/obj/machinery/biohazard_destroyer
	name = "biohazard destroyer"
	icon = 'icons/obj/pipes/disposal.dmi'
	icon_state = "disposalbio"
	var/list/accepts = list(/obj/item/clothing,/obj/item/virusdish/,/obj/item/cureimplanter,/obj/item/diseasedisk,/obj/item/reagent_containers)
	density = TRUE
	anchored = TRUE

/obj/machinery/biohazard_destroyer/attackby(obj/I, mob/user)
	for(var/path in accepts)
		if(I.type in typesof(path))
			user.drop_item()
			del(I)
			overlays += image('icons/obj/pipes/disposal.dmi', "dispover-handle")
			return
	user.drop_item()
	I.loc = src.loc

	for(var/mob/O in hearers(src, null))
		O.show_message("\icon[src] \blue The [src.name] beeps", 2)