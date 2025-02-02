//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/assembly/infra
	name = "infrared emitter"
	desc = "Emits a visible or invisible beam and is triggered when the beam is interrupted."
	icon_state = "infrared"
	matter_amounts = list(MATERIAL_METAL = 1000, /decl/material/glass = 500, "waste" = 100)
	origin_tech = list(/decl/tech/magnets = 2)

	wires = WIRE_PULSE

	secured = 0

	var/on = 0
	var/visible = 0
	var/obj/effect/beam/i_beam/first = null

/obj/item/assembly/infra/activate()
	if(!..())
		return 0 //Cooldown check
	on = !on
	update_icon()
	return 1

/obj/item/assembly/infra/toggle_secure()
	secured = !secured
	if(secured)
		GLOBL.processing_objects.Add(src)
	else
		on = 0
		if(first)
			qdel(first)
		GLOBL.processing_objects.Remove(src)
	update_icon()
	return secured

/obj/item/assembly/infra/update_icon()
	overlays.Cut()
	attached_overlays = list()
	if(on)
		overlays += "infrared_on"
		attached_overlays += "infrared_on"

	if(holder)
		holder.update_icon()
	return

/obj/item/assembly/infra/process() //Old code
	if(!on)
		if(first)
			qdel(first)
			return

	if((!first && (secured && (isturf(loc) || (holder && isturf(holder.loc))))))
		var/obj/effect/beam/i_beam/I = new /obj/effect/beam/i_beam((holder ? holder.loc : loc))
		I.master = src
		I.density = TRUE
		I.set_dir(dir)
		step(I, I.dir)
		if(I)
			I.density = FALSE
			first = I
			I.vis_spread(visible)
			spawn(0)
				if(I)
					//to_world("infra: setting limit")
					I.limit = 8
					//to_world("infra: processing beam \ref[I]")
					I.process()
				return
	return

/obj/item/assembly/infra/attack_hand()
	qdel(first)
	..()
	return

/obj/item/assembly/infra/Move()
	var/t = dir
	..()
	dir = t
	qdel(first)
	return

/obj/item/assembly/infra/holder_movement()
	if(!holder)
		return 0
//	dir = holder.dir
	qdel(first)
	return 1

/obj/item/assembly/infra/proc/trigger_beam()
	if(!secured || !on || cooldown > 0)
		return 0
	pulse(0)
	if(!holder)
		visible_message("\icon[src] *beep* *beep*")
	cooldown = 2
	spawn(10)
		process_cooldown()
	return

/obj/item/assembly/infra/interact(mob/user) //TODO: change this this to the wire control panel
	if(!secured)
		return
	user.set_machine(src)
	var/dat = text("<TT><B>Infrared Laser</B>\n<B>Status</B>: []<BR>\n<B>Visibility</B>: []<BR>\n</TT>", (on ? text("<A href='byond://?src=\ref[];state=0'>On</A>", src) : text("<A href='byond://?src=\ref[];state=1'>Off</A>", src)), (src.visible ? text("<A href='byond://?src=\ref[];visible=0'>Visible</A>", src) : text("<A href='byond://?src=\ref[];visible=1'>Invisible</A>", src)))
	dat += "<BR><BR><A href='byond://?src=\ref[src];refresh=1'>Refresh</A>"
	dat += "<BR><BR><A href='byond://?src=\ref[src];close=1'>Close</A>"
	user << browse(dat, "window=infra")
	onclose(user, "infra")
	return

/obj/item/assembly/infra/Topic(href, href_list)
	..()
	if(!usr.canmove || usr.stat || usr.restrained() || !in_range(loc, usr))
		usr << browse(null, "window=infra")
		onclose(usr, "infra")
		return

	if(href_list["state"])
		on = !(on)
		update_icon()

	if(href_list["visible"])
		visible = !(visible)
		spawn(0)
			if(first)
				first.vis_spread(visible)

	if(href_list["close"])
		usr << browse(null, "window=infra")
		return

	if(usr)
		attack_self(usr)

	return

/obj/item/assembly/infra/verb/rotate() //This could likely be better
	set category = PANEL_OBJECT
	set name = "Rotate Infrared Laser"
	set src in usr

	set_dir(turn(dir, 90))
	return

/***************************IBeam*********************************/
/obj/effect/beam/i_beam
	name = "i beam"
	icon = 'icons/obj/weapons/projectiles.dmi'
	icon_state = "ibeam"
	var/obj/effect/beam/i_beam/next = null
	var/obj/item/assembly/infra/master = null
	var/limit = null
	var/visible = 0.0
	var/left = null
	anchored = TRUE

/obj/effect/beam/i_beam/proc/hit()
	//to_world("beam \ref[src]: hit")
	if(master)
		//to_world("beam hit \ref[src]: calling master \ref[master].hit")
		master.trigger_beam()
	qdel(src)
	return

/obj/effect/beam/i_beam/proc/vis_spread(v)
	//to_world("i_beam \ref[src] : vis_spread")
	visible = v
	spawn(0)
		if(next)
			//to_world("i_beam \ref[src] : is next [next.type] \ref[next], calling spread")
			next.vis_spread(v)
		return
	return

/obj/effect/beam/i_beam/process()
	//to_world("i_beam \ref[src] : process")

	if((loc.density || !master))
	//	to_world("beam hit loc [loc] or no master [master], deleting")
		qdel(src)
		return
	//to_world("proccess: [src.left] left")

	if(left > 0)
		left--
	if(left < 1)
		if(!visible)
			invisibility = INVISIBILITY_MAXIMUM
		else
			invisibility = 0
	else
		invisibility = 0


	//to_world("now [src.left] left")
	var/obj/effect/beam/i_beam/I = new /obj/effect/beam/i_beam(loc)
	I.master = master
	I.density = TRUE
	I.set_dir(dir)
	//to_world("created new beam \ref[I] at [I.x] [I.y] [I.z]")
	step(I, I.dir)

	if(I)
		//to_world("step worked, now at [I.x] [I.y] [I.z]")
		if(!next)
			//to_world("no next")
			I.density = FALSE
			//to_world("spreading")
			I.vis_spread(visible)
			next = I
			spawn(0)
				//to_world("limit = [limit] ")
				if(I && limit > 0)
					I.limit = limit - 1
					//to_world("calling next process")
					I.process()
				return
		else
			//to_world("is a next: \ref[next], deleting beam \ref[I]")
			qdel(I)
	else
		//to_world("step failed, deleting \ref[next]")
		qdel(next)
	spawn(10)
		process()
		return
	return

/obj/effect/beam/i_beam/Bump()
	qdel(src)
	return

/obj/effect/beam/i_beam/Bumped()
	hit()
	return

/obj/effect/beam/i_beam/Crossed(atom/movable/AM)
	if(istype(AM, /obj/effect/beam))
		return
	spawn(0)
		hit()
		return
	return

/obj/effect/beam/i_beam/Destroy()
	QDEL_NULL(next)
	return ..()