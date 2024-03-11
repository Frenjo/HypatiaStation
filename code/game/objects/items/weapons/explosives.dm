/obj/item/plastique
	name = "plastic explosives"
	desc = "Used to put holes in specific areas without too much extra hole."
	gender = PLURAL
	icon = 'icons/obj/items/assemblies/assemblies.dmi'
	icon_state = "plastic-explosive0"
	item_state = "plasticx"
	item_flags = ITEM_FLAG_NO_BLUDGEON
	w_class = 2.0
	origin_tech = list(RESEARCH_TECH_SYNDICATE = 2)

	var/datum/wires/explosive/c4/wires = null
	var/timer = 10
	var/atom/target = null
	var/open_panel = 0
	var/image_overlay = null

/obj/item/plastique/New()
	wires = new(src)
	image_overlay = image('icons/obj/items/assemblies/assemblies.dmi', "plastic-explosive2")
	..()

/obj/item/plastique/attack_tool(obj/item/tool, mob/user)
	if(isscrewdriver(tool))
		open_panel = !open_panel
		user.visible_message(
			SPAN_NOTICE("[user] [open_panel ? "opens" : "closes"] the wire panel on \the [src]."),
			SPAN_NOTICE("You [open_panel ? "open" : "close"] the wire panel on \the [src]."),
			SPAN_INFO("You hear someone using a screwdriver.")
		)
		return TRUE

	if(iswirecutter(tool) || ismultitool(tool) || istype(tool, /obj/item/assembly/signaler))
		wires.Interact(user)
		return TRUE

	return ..()

/obj/item/plastique/attack_self(mob/user as mob)
	var/newtime = input(usr, "Please set the timer.", "Timer", 10) as num
	if(user.get_active_hand() == src)
		newtime = clamp(newtime, 10, 60000)
		timer = newtime
		user << "Timer set for [timer] seconds."

/obj/item/plastique/afterattack(atom/movable/target, mob/user, flag)
	if(!flag)
		return
	if(ismob(target) || istype(target, /turf/simulated/shuttle) || istype(target, /obj/item/storage))
		return

	user << "Planting explosives..."
	if(do_after(user, 50) && in_range(user, target))
		user.drop_item()
		src.target = target
		loc = null

		if(ismob(target))
			user.attack_log += "\[[time_stamp()]\] <font color='red'> [user.real_name] tried planting [name] on [target:real_name] ([target:ckey])</font>"
			message_admins("[key_name(user, user.client)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) planted [src.name] on [key_name(target)](<A HREF='?_src_=holder;adminmoreinfo=\ref[target]'>?</A>) with [timer] second fuse",0,1)
			user.visible_message(SPAN_DANGER("[user.name] finished planting an explosive on [target.name]!"))
			log_game("[key_name(user)] planted [src.name] on [key_name(target)] with [timer] second fuse")
		else
			message_admins("[key_name(user, user.client)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) planted [src.name] on [target.name] at ([target.x],[target.y],[target.z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[target.x];Y=[target.y];Z=[target.z]'>JMP</a>) with [timer] second fuse",0,1)
			log_game("[key_name(user)] planted [src.name] on [target.name] at ([target.x],[target.y],[target.z]) with [timer] second fuse")

		target.overlays += image_overlay

		user << "Bomb has been planted. Timer counting down from [timer]."
		spawn(timer*10)
			explode(get_turf(target))

/obj/item/plastique/proc/explode(var/location)
	if(!target)
		target = get_atom_on_turf(src)
	if(!target)
		target = src
	if(location)
		explosion(location, -1, -1, 2, 3)

	if(target)
		if (istype(target, /turf/simulated/wall))
			var/turf/simulated/wall/W = target
			W.dismantle_wall(1)
		else if(isliving(target))
			target.ex_act(2) // c4 can't gib mobs anymore.
		else
			target.ex_act(1)
	if(target)
		target.overlays -= image_overlay
	qdel(src)

/obj/item/plastique/attack(mob/M as mob, mob/user as mob, def_zone)
	return