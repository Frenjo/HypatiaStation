/obj/structure/closet/secure/guncabinet
	name = "gun cabinet"
	req_access = list(ACCESS_ARMOURY)
	icon = 'icons/obj/closets/guncabinet.dmi'
	icon_state = "base"
	icon_off = "base"
	icon_broken = "base"
	icon_locked = "base"
	icon_closed = "base"
	icon_opened = "base"

/obj/structure/closet/secure/guncabinet/New()
	. = ..()
	update_icon()

/obj/structure/closet/secure/guncabinet/toggle()
	..()
	update_icon()

/obj/structure/closet/secure/guncabinet/update_icon()
	cut_overlays()
	if(opened)
		add_overlay(icon(icon, "door_open"))
	else
		var/lazors = 0
		var/shottas = 0
		for(var/obj/item/gun/G in contents)
			if(istype(G, /obj/item/gun/energy))
				lazors++
			if(istype(G, /obj/item/gun/projectile/))
				shottas++
		if(lazors || shottas)
			for(var/i in 0 to 2)
				var/image/gun = image(icon(src.icon))

				if(lazors > 0 && (shottas <= 0 || prob(50)))
					lazors--
					gun.icon_state = "laser"
				else if(shottas > 0)
					shottas--
					gun.icon_state = "projectile"

				gun.pixel_x = i*4
				add_overlay(gun)

		add_overlay(icon(src.icon, "door"))

		if(broken)
			add_overlay(icon(src.icon, "broken"))
		else if(locked)
			add_overlay(icon(src.icon, "locked"))
		else
			add_overlay(icon(src.icon, "open"))