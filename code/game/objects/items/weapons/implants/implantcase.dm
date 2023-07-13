//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/implantcase
	name = "Glass Case"
	desc = "A case containing an implant."
	icon_state = "implantcase-0"
	item_state = "implantcase"
	throw_speed = 1
	throw_range = 5
	w_class = 1.0
	var/obj/item/implant/imp = null

/obj/item/implantcase/proc/update()
	if(src.imp)
		src.icon_state = "implantcase-[src.imp.item_color]"
	else
		src.icon_state = "implantcase-0"
	return

/obj/item/implantcase/attackby(obj/item/I as obj, mob/user as mob)
	..()
	if(istype(I, /obj/item/pen))
		var/t = input(user, "What would you like the label to be?", src.name, null) as text
		if(user.get_active_hand() != I)
			return
		if(!in_range(src, usr) && src.loc != user)
			return
		t = copytext(sanitize(t), 1, MAX_MESSAGE_LEN)
		if(t)
			src.name = "Glass Case - '[t]'"
		else
			src.name = "Glass Case"
	else if(istype(I, /obj/item/reagent_containers/syringe))
		if(!src.imp)
			return
		if(!src.imp.allow_reagents)
			return
		if(src.imp.reagents.total_volume >= src.imp.reagents.maximum_volume)
			to_chat(user, SPAN_WARNING("[src] is full."))
		else
			spawn(5)
				I.reagents.trans_to(src.imp, 5)
				to_chat(user, SPAN_INFO("You inject 5 units of the solution. The syringe now contains [I.reagents.total_volume] units."))
	else if(istype(I, /obj/item/implanter))
		var/obj/item/implanter/implanter = I
		if(implanter.imp)
			if(src.imp || implanter.imp.implanted)
				return
			implanter.imp.loc = src
			src.imp = implanter.imp
			implanter.imp = null
			src.update()
			implanter.update()
		else
			if(src.imp)
				if(implanter.imp)
					return
				src.imp.loc = implanter
				implanter.imp = src.imp
				src.imp = null
				update()
			implanter.update()
	return


/obj/item/implantcase/tracking
	name = "Glass Case - 'Tracking'"
	desc = "A case containing a tracking implant."
	icon = 'icons/obj/items.dmi'
	icon_state = "implantcase-b"

/obj/item/implantcase/tracking/New()
	src.imp = new /obj/item/implant/tracking(src)
	..()
	return


/obj/item/implantcase/explosive
	name = "Glass Case - 'Explosive'"
	desc = "A case containing an explosive implant."
	icon = 'icons/obj/items.dmi'
	icon_state = "implantcase-r"

/obj/item/implantcase/explosive/New()
	src.imp = new /obj/item/implant/explosive(src)
	..()
	return


/obj/item/implantcase/chem
	name = "Glass Case - 'Chem'"
	desc = "A case containing a chemical implant."
	icon = 'icons/obj/items.dmi'
	icon_state = "implantcase-b"

/obj/item/implantcase/chem/New()
	src.imp = new /obj/item/implant/chem(src)
	..()
	return


/obj/item/implantcase/loyalty
	name = "Glass Case - 'Loyalty'"
	desc = "A case containing a loyalty implant."
	icon = 'icons/obj/items.dmi'
	icon_state = "implantcase-r"

/obj/item/implantcase/loyalty/New()
	src.imp = new /obj/item/implant/loyalty(src)
	..()
	return


/obj/item/implantcase/death_alarm
	name = "Glass Case - 'Death Alarm'"
	desc = "A case containing a death alarm implant."
	icon = 'icons/obj/items.dmi'
	icon_state = "implantcase-b"

/obj/item/implantcase/death_alarm/New()
	src.imp = new /obj/item/implant/death_alarm(src)
	..()
	return