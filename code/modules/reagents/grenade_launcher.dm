/obj/item/weapon/gun/grenadelauncher
	name = "grenade launcher"
	icon_state = "riotgun"
	item_state = "riotgun"
	w_class = 4.0
	throw_speed = 2
	throw_range = 10
	force = 5.0

	var/list/grenades = list()
	var/max_grenades = 3

/obj/item/weapon/gun/grenadelauncher/examine()
	set src in view()
	..()
	if(!(usr in view(2)) && usr != src.loc)
		return
	to_chat(usr, "[src] Grenade launcher:")
	to_chat(usr, SPAN_INFO("[grenades] / [max_grenades] Grenades."))

/obj/item/weapon/gun/grenadelauncher/attackby(obj/item/I as obj, mob/user as mob)
	if((istype(I, /obj/item/weapon/grenade)))
		if(length(grenades) < max_grenades)
			user.drop_item()
			I.loc = src
			grenades += I
			to_chat(user, SPAN_INFO("You put the grenade in the grenade launcher."))
			to_chat(user, SPAN_INFO("[length(grenades)] / [max_grenades] Grenades."))
		else
			to_chat(usr, SPAN_WARNING("The grenade launcher cannot hold more grenades."))

/obj/item/weapon/gun/grenadelauncher/afterattack(obj/target, mob/user , flag)
	if(istype(target, /obj/item/weapon/storage/backpack))
		return

	else if(locate(/obj/structure/table, src.loc))
		return

	else if(target == user)
		return

	if(length(grenades))
		spawn(0)
			fire_grenade(target, user)
	else
		to_chat(usr, SPAN_WARNING("The grenade launcher is empty."))

/obj/item/weapon/gun/grenadelauncher/proc/fire_grenade(atom/target, mob/user)
	for(var/mob/O in viewers(world.view, user))
		O.show_message(SPAN_WARNING("[user] fired a grenade!"), 1)
	to_chat(user, SPAN_WARNING("You fire the grenade launcher!"))
	var/obj/item/weapon/grenade/chem_grenade/F = grenades[1] //Now with less copypasta!
	grenades -= F
	F.loc = user.loc
	F.throw_at(target, 30, 2)
	message_admins("[key_name_admin(user)] fired a grenade ([F.name]) from a grenade launcher ([src.name]).")
	log_game("[key_name_admin(user)] used a grenade ([src.name]).")
	F.active = 1
	F.icon_state = initial(icon_state) + "_active"
	playsound(user.loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
	spawn(15)
		F.prime()