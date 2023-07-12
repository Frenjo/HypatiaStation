/obj/structure/signpost
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "signpost"
	anchored = TRUE
	density = TRUE

/obj/structure/signpost/attackby(obj/item/W as obj, mob/user as mob)
	return attack_hand(user)

/obj/structure/signpost/attack_hand(mob/user as mob)
	switch(alert("Travel back to ss13?", , "Yes", "No"))
		if("Yes")
			if(user.z != src.z)
				return
			user.loc.loc.Exited(user)
			user.loc = pick(GLOBL.latejoin)
		if("No")
			return