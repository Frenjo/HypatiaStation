/obj/effect/landmark/zcontroller
	name = "Z-Level Controller"

	var/initialized = FALSE	// when set to TRUE, turfs will report to the controller
	var/up = FALSE			// TRUE allows up movement
	var/up_target = 0		// the Z-level that is above the current one
	var/down = FALSE		// TRUE allows down movement
	var/down_target = 0		// the Z-level that is below the current one

	var/list/slow = list()
	var/list/normal = list()
	var/list/fast = list()

	var/slow_time
	var/normal_time
	var/fast_time

/obj/effect/landmark/zcontroller/initialise()
	. = ..()
	for(var/turf/T in world)
		if(T.z == z)
			fast += T
	slow_time = world.time + 3000
	normal_time = world.time + 600
	fast_time = world.time + 10
	START_PROCESSING(PCobj, src)
	initialized = TRUE

/obj/effect/landmark/zcontroller/Destroy()
	slow.Cut()
	normal.Cut()
	fast.Cut()
	STOP_PROCESSING(PCobj, src)
	return ..()

/obj/effect/landmark/zcontroller/process()
	if(world.time > fast_time)
		calc(fast)
		fast_time = world.time + 10

	if(world.time > normal_time)
		calc(normal)
		normal_time = world.time + 600

/*	if (world.time > slow_time)
		calc(slow)
		slow_time = world.time + 3000 */
	return

/obj/effect/landmark/zcontroller/proc/add(list/L, I, transfer)
	while(length(L))
		var/turf/T = pick(L)

		L.Remove(T)
		slow.Remove(T)
		normal.Remove(T)
		fast.Remove(T)

		if(isnull(T) || !isturf(T))
			continue

		switch(I)
			if(1)
				slow.Add(T)
			if(2)
				normal.Add(T)
			if(3)
				fast.Add(T)

		if(transfer > 0)
			if(up)
				var/turf/controller_up = locate(1, 1, up_target)
				for(var/obj/effect/landmark/zcontroller/c_up in controller_up)
					var/list/temp = list()
					temp.Add(locate(T.x, T.y, up_target))
					c_up.add(temp, I, transfer - 1)

			if(down)
				var/turf/controller_down = locate(1, 1, down_target)
				for(var/obj/effect/landmark/zcontroller/c_down in controller_down)
					var/list/temp = list()
					temp.Add(locate(T.x, T.y, down_target))
					c_down.add(temp, I, transfer - 1)
	return

/obj/effect/landmark/zcontroller/proc/calc(list/L)
	var/list/slowholder = list()
	var/list/normalholder = list()
	var/list/fastholder = list()
	var/new_list

	while(length(L))
		var/turf/T = pick(L)
		new_list = 0

		if(isnull(T) || !isturf(T))
			L.Remove(T)
			continue

		if(isnotnull(T.z_overlays))
			T.remove_overlay(T.z_overlays)
			T.z_overlays.Remove(T.z_overlays)
		else
			T.z_overlays = list()

		if(down && (isspace(T) || isopenspace(T)))
			var/turf/below = locate(T.x, T.y, down_target)
			if(below)
				if(!isspace(below) || !isopenspace(below))
					var/list/image/t_img = list()
					new_list = 1

					var/image/temp = image(below, dir = below.dir, layer = TURF_LAYER + 0.04)

					temp.color = rgb(127, 127, 127)
					temp.add_overlay(below.overlays)
					t_img.Add(temp)
					T.add_overlay(t_img)
					T.z_overlays.Add(t_img)

				// get objects
				var/list/image/o_img = list()
				for(var/obj/o in below)
					// ingore objects that have any form of invisibility
					if(o.invisibility)
						continue
					new_list = 2
					var/image/temp2 = image(o, dir = o.dir, layer = TURF_LAYER + 0.05 * o.layer)
					temp2.color = rgb(127, 127, 127)
					temp2.add_overlay(o.overlays)
					o_img.Add(temp2)
					// you need to add a list to .overlays or it will not display any because space
				T.add_overlay(o_img)
				T.z_overlays.Add(o_img)

				// get mobs
				var/list/image/m_img = list()
				for(var/mob/m in below)
					// ingore mobs that have any form of invisibility
					if(m.invisibility)
						continue
					// only add this tile to fastprocessing if there is a living mob, not a dead one
					if(isliving(m))
						new_list = 3
					var/image/temp2 = image(m, dir = m.dir, layer = TURF_LAYER + 0.05 * m.layer)
					temp2.color = rgb(127, 127, 127)
					temp2.add_overlay(m.overlays)
					m_img.Add(temp2)
					// you need to add a list to .overlays or it will not display any because space
				T.add_overlay(m_img)
				T.z_overlays.Add(m_img)

				T.remove_overlay(below.z_overlays)
				T.z_overlays.Remove(below.z_overlays)

		// this is sadly impossible to use right now
		// the overlay is always opaque to mouseclicks and thus prevents interactions with everything except the turf
		/*if(up)
			var/turf/above = locate(T.x, T.y, up_target)
			if(above)
				var/eligeable = 0
				for(var/d in cardinal)
					var/turf/mT = get_step(above,d)
					if(isspace(mT) || isopenspace(mT))
						eligeable = 1
					/*if(mT.opacity == 0)
						for(var/f in cardinal)
							var/turf/nT = get_step(mT,f)
							if(isspace(nT) || isopenspace(nT))
								eligeable = 1*/
				if(isspace(above) || isopenspace(above)) eligeable = 1
				if(eligeable == 1)
					if(!isspace(above) || !isopenspace(above))
						var/image/t_img = list()
						if(new_list < 1) new_list = 1

						above.remove_overlay(above.z_overlays)
						var/image/temp = image(above, dir=above.dir, layer = 5 + 0.04)
						above.add_overlay(above.z_overlays)

						temp.alpha = 100
						temp.add_overlay(above.overlays)
						temp.remove_overlay(above.z_overlays)
						t_img += temp
						T.add_overlay(t_img)
						T.z_overlays += t_img

					// get objects
					var/image/o_img = list()
					for(var/obj/o in above)
						// ingore objects that have any form of invisibility
						if(o.invisibility) continue
						if(new_list < 2) new_list = 2
						var/image/temp2 = image(o, dir=o.dir, layer = 5+0.05*o.layer)
						temp2.alpha = 100
						temp2.add_overlay(o.overlays)
						o_img += temp2
						// you need to add a list to .overlays or it will not display any because space
					T.add_overlay(o_img)
					T.z_overlays += o_img

					// get mobs
					var/image/m_img = list()
					for(var/mob/m in above)
						// ingore mobs that have any form of invisibility
						if(m.invisibility) continue
						// only add this tile to fastprocessing if there is a living mob, not a dead one
						if(isliving(m) && new_list < 3) new_list = 3
						var/image/temp2 = image(m, dir=m.dir, layer = 5+0.05*m.layer)
						temp2.alpha = 100
						temp2.add_overlay(m.overlays)
						m_img += temp2
						// you need to add a list to .overlays or it will not display any because space
					T.add_overlay(m_img)
					T.z_overlays += m_img

					T.remove_overlay(above.z_overlays)
					T.z_overlays -= above.z_overlays*/

		L.Remove(T)

		if(new_list == 1)
			slowholder.Add(T)
		if(new_list == 2)
			normalholder.Add(T)
		if(new_list == 3)
			fastholder.Add(T)
			for(var/d in GLOBL.cardinal)
				var/turf/mT = get_step(T, d)
				if(!(mT in fastholder))
					fastholder.Add(mT)
				for(var/f in GLOBL.cardinal)
					var/turf/nT = get_step(mT, f)
					if(!(nT in fastholder))
						fastholder.Add(nT)

	add(slowholder, 1, 0)
	add(normalholder, 2, 0)
	add(fastholder, 3, 0)

// Overrides
/turf
	var/list/z_overlays

/turf/New()
	. = ..()
	var/turf/controller = locate(1, 1, z)
	for(var/obj/effect/landmark/zcontroller/c in controller)
		if(c.initialized)
			var/list/turf = list()
			turf.Add(src)
			c.add(turf, 3, 1)

/turf/space/New()
	. = ..()
	var/turf/controller = locate(1, 1, z)
	for(var/obj/effect/landmark/zcontroller/c in controller)
		if(c.initialized)
			var/list/turf = list()
			turf.Add(src)
			c.add(turf, 3, 1)

/atom/movable/Move() //Hackish
	. = ..()
	var/turf/controllerlocation = locate(1, 1, z)
	for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
		if(controller.up || controller.down)
			var/list/temp = list()
			temp.Add(locate(x, y, z))
			controller.add(temp, 3, 1)