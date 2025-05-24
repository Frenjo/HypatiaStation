/obj/item/implant/sad_trombone
	name = "sad trombone implant"
	desc = "Makes death amusing."
	matter_amounts = /datum/design/implant/sad_trombone::materials
	origin_tech = /datum/design/implant/sad_trombone::req_tech

/obj/item/implant/sad_trombone/get_data()
	return "<b>Implant Specifications:</b><BR> \
		<b>Name:</b> Honk Co. Sad Trombone Implant<BR> \
		<b>Life:</b> Activates upon death.<BR>"

/obj/item/implant/sad_trombone/implanted(mob/source)
	. = ..()
	if(!.)
		return FALSE
	playsound(src, 'sound/items/bikehorn.ogg', 50, FALSE)
	return TRUE

/obj/item/implant/sad_trombone/trigger(emote, mob/source)
	if(emote == "deathgasp")
		playsound(loc, 'sound/misc/sadtrombone.ogg', 50, FALSE)

// Case
/obj/item/implantcase/sad_trombone
	name = "implant case - 'sad trombone'"
	desc = "A glass case containing a sad trombone implant."

	imp_type = /obj/item/implant/sad_trombone

// Implanter
/obj/item/implanter/sad_trombone
	name = "implanter (sad trombone)"

	imp_type = /obj/item/implant/sad_trombone