/proc/togglebuildmode(mob/M as mob in GLOBL.player_list)
	set category = PANEL_SPECIAL_VERBS
	set name = "Toggle Build Mode"

	if(M.client)
		if(M.client.buildmode)
			log_admin("[key_name(usr)] has left build mode.")
			M.client.buildmode = 0
			M.client.show_popup_menus = 1
			for(var/obj/effect/bmode/buildholder/H)
				if(H.cl == M.client)
					qdel(H)
		else
			log_admin("[key_name(usr)] has entered build mode.")
			M.client.buildmode = 1
			M.client.show_popup_menus = 0

			var/obj/effect/bmode/buildholder/H = new/obj/effect/bmode/buildholder()
			var/obj/effect/bmode/builddir/A = new/obj/effect/bmode/builddir(H)
			A.master = H
			var/obj/effect/bmode/buildhelp/B = new/obj/effect/bmode/buildhelp(H)
			B.master = H
			var/obj/effect/bmode/buildmode/C = new/obj/effect/bmode/buildmode(H)
			C.master = H
			var/obj/effect/bmode/buildquit/D = new/obj/effect/bmode/buildquit(H)
			D.master = H

			H.builddir = A
			H.buildhelp = B
			H.buildmode = C
			H.buildquit = D
			M.client.screen += A
			M.client.screen += B
			M.client.screen += C
			M.client.screen += D
			H.cl = M.client

/obj/effect/bmode//Cleaning up the tree a bit
	density = TRUE
	anchored = TRUE
	plane = HUD_PLANE
	layer = HUD_BASE_LAYER
	dir = NORTH
	icon = 'icons/misc/buildmode.dmi'
	var/obj/effect/bmode/buildholder/master = null

/obj/effect/bmode/builddir
	icon_state = "build"
	screen_loc = "NORTH,WEST"

/obj/effect/bmode/builddir/Click()
	switch(dir)
		if(NORTH)
			dir = EAST
		if(EAST)
			dir = SOUTH
		if(SOUTH)
			dir = WEST
		if(WEST)
			dir = NORTHWEST
		if(NORTHWEST)
			dir = NORTH
	return 1

/obj/effect/bmode/buildhelp
	icon = 'icons/misc/buildmode.dmi'
	icon_state = "buildhelp"
	screen_loc = "NORTH,WEST+1"

/obj/effect/bmode/buildhelp/Click()
	switch(master.cl.buildmode)
		if(1)
			usr << "\blue ***********************************************************"
			usr << "\blue Left Mouse Button        = Construct / Upgrade"
			usr << "\blue Right Mouse Button       = Deconstruct / Delete / Downgrade"
			usr << "\blue Left Mouse Button + ctrl = R-Window"
			usr << "\blue Left Mouse Button + alt  = Airlock"
			usr << ""
			usr << "\blue Use the button in the upper left corner to"
			usr << "\blue change the direction of built objects."
			usr << "\blue ***********************************************************"
		if(2)
			usr << "\blue ***********************************************************"
			usr << "\blue Right Mouse Button on buildmode button = Set object type"
			usr << "\blue Left Mouse Button on turf/obj          = Place objects"
			usr << "\blue Right Mouse Button                     = Delete objects"
			usr << ""
			usr << "\blue Use the button in the upper left corner to"
			usr << "\blue change the direction of built objects."
			usr << "\blue ***********************************************************"
		if(3)
			usr << "\blue ***********************************************************"
			usr << "\blue Right Mouse Button on buildmode button = Select var(type) & value"
			usr << "\blue Left Mouse Button on turf/obj/mob      = Set var(type) & value"
			usr << "\blue Right Mouse Button on turf/obj/mob     = Reset var's value"
			usr << "\blue ***********************************************************"
		if(4)
			usr << "\blue ***********************************************************"
			usr << "\blue Left Mouse Button on turf/obj/mob      = Select"
			usr << "\blue Right Mouse Button on turf/obj/mob     = Throw"
			usr << "\blue ***********************************************************"
	return 1

/obj/effect/bmode/buildquit
	icon_state = "buildquit"
	screen_loc = "NORTH,WEST+3"

/obj/effect/bmode/buildquit/Click()
	togglebuildmode(master.cl.mob)
	return 1

/obj/effect/bmode/buildholder
	density = FALSE
	anchored = TRUE
	var/client/cl = null
	var/obj/effect/bmode/builddir/builddir = null
	var/obj/effect/bmode/buildhelp/buildhelp = null
	var/obj/effect/bmode/buildmode/buildmode = null
	var/obj/effect/bmode/buildquit/buildquit = null
	var/atom/movable/throw_atom = null

/obj/effect/bmode/buildmode
	icon_state = "buildmode1"
	screen_loc = "NORTH,WEST+2"
	var/varholder = "name"
	var/valueholder = "derp"
	var/objholder = /obj/structure/closet

/obj/effect/bmode/buildmode/Click(location, control, params)
	var/list/pa = params2list(params)

	if(pa.Find("left"))
		switch(master.cl.buildmode)
			if(1)
				master.cl.buildmode = 2
				src.icon_state = "buildmode2"
			if(2)
				master.cl.buildmode = 3
				src.icon_state = "buildmode3"
			if(3)
				master.cl.buildmode = 4
				src.icon_state = "buildmode4"
			if(4)
				master.cl.buildmode = 1
				src.icon_state = "buildmode1"

	else if(pa.Find("right"))
		switch(master.cl.buildmode)
			if(1)
				return 1
			if(2)
				objholder = text2path(input(usr,"Enter typepath:" ,"Typepath","/obj/structure/closet"))
				if(!ispath(objholder))
					objholder = /obj/structure/closet
					alert("That path is not allowed.")
				else
					if(ispath(objholder,/mob) && !check_rights(R_DEBUG,0))
						objholder = /obj/structure/closet
			if(3)
				var/list/locked = list("vars", "key", "ckey", "client", "firemut", "ishulk", "telekinesis", "xray", "virus", "viruses", "cuffed", "ka", "last_eaten", "urine")

				master.buildmode.varholder = input(usr,"Enter variable name:" ,"Name", "name")
				if(master.buildmode.varholder in locked && !check_rights(R_DEBUG,0))
					return 1
				var/thetype = input(usr,"Select variable type:" ,"Type") in list("text","number","mob-reference","obj-reference","turf-reference")
				if(!thetype) return 1
				switch(thetype)
					if("text")
						master.buildmode.valueholder = input(usr,"Enter variable value:" ,"Value", "value") as text
					if("number")
						master.buildmode.valueholder = input(usr,"Enter variable value:" ,"Value", 123) as num
					if("mob-reference")
						master.buildmode.valueholder = input(usr,"Enter variable value:" ,"Value") as mob in GLOBL.mob_list
					if("obj-reference")
						master.buildmode.valueholder = input(usr,"Enter variable value:" ,"Value") as obj in GLOBL.movable_atom_list
					if("turf-reference")
						master.buildmode.valueholder = input(usr,"Enter variable value:" ,"Value") as turf in world
	return 1

/proc/build_click(mob/user, buildmode, params, obj/object)
	var/obj/effect/bmode/buildholder/holder = null
	for(var/obj/effect/bmode/buildholder/H)
		if(H.cl == user.client)
			holder = H
			break
	if(!holder) return
	var/list/pa = params2list(params)

	switch(buildmode)
		if(1)
			if(isturf(object) && pa.Find("left") && !pa.Find("alt") && !pa.Find("ctrl") )
				if(isspace(object))
					var/turf/T = object
					T.ChangeTurf(/turf/open/floor)
					return
				else if(isfloorturf(object))
					var/turf/T = object
					T.ChangeTurf(/turf/closed/wall/steel)
					return
				else if(istype(object, /turf/closed/wall))
					var/turf/T = object
					T.ChangeTurf(/turf/closed/wall/reinforced)
					return
			else if(pa.Find("right"))
				if(istype(object, /turf/closed/wall))
					var/turf/T = object
					T.ChangeTurf(/turf/open/floor)
					return
				else if(isfloorturf(object))
					var/turf/T = object
					T.ChangeTurf(/turf/space)
					return
				else if(istype(object, /turf/closed/wall/reinforced))
					var/turf/T = object
					T.ChangeTurf(/turf/closed/wall/steel)
					return
				else if(isobj(object))
					qdel(object)
					return
			else if(isturf(object) && pa.Find("alt") && pa.Find("left"))
				new /obj/machinery/door/airlock(GET_TURF(object))
			else if(isturf(object) && pa.Find("ctrl") && pa.Find("left"))
				switch(holder.builddir.dir)
					if(NORTH)
						var/obj/structure/window/reinforced/WIN = new/obj/structure/window/reinforced(GET_TURF(object))
						WIN.set_dir(NORTH)
					if(SOUTH)
						var/obj/structure/window/reinforced/WIN = new/obj/structure/window/reinforced(GET_TURF(object))
						WIN.set_dir(SOUTH)
					if(EAST)
						var/obj/structure/window/reinforced/WIN = new/obj/structure/window/reinforced(GET_TURF(object))
						WIN.set_dir(EAST)
					if(WEST)
						var/obj/structure/window/reinforced/WIN = new/obj/structure/window/reinforced(GET_TURF(object))
						WIN.set_dir(WEST)
					if(NORTHWEST)
						var/obj/structure/window/reinforced/WIN = new/obj/structure/window/reinforced(GET_TURF(object))
						WIN.set_dir(NORTHWEST)
		if(2)
			if(pa.Find("left"))
				if(ispath(holder.buildmode.objholder, /turf))
					var/turf/T = GET_TURF(object)
					T.ChangeTurf(holder.buildmode.objholder)
				else
					var/obj/A = new holder.buildmode.objholder(GET_TURF(object))
					A.set_dir(holder.builddir.dir)
			else if(pa.Find("right"))
				if(isobj(object)) qdel(object)

		if(3)
			if(pa.Find("left")) //I cant believe this shit actually compiles.
				if(object.vars.Find(holder.buildmode.varholder))
					log_admin("[key_name(usr)] modified [object.name]'s [holder.buildmode.varholder] to [holder.buildmode.valueholder]")
					object.vars[holder.buildmode.varholder] = holder.buildmode.valueholder
				else
					usr << "\red [initial(object.name)] does not have a var called '[holder.buildmode.varholder]'"
			if(pa.Find("right"))
				if(object.vars.Find(holder.buildmode.varholder))
					log_admin("[key_name(usr)] modified [object.name]'s [holder.buildmode.varholder] to [holder.buildmode.valueholder]")
					object.vars[holder.buildmode.varholder] = initial(object.vars[holder.buildmode.varholder])
				else
					usr << "\red [initial(object.name)] does not have a var called '[holder.buildmode.varholder]'"

		if(4)
			if(pa.Find("left"))
				holder.throw_atom = object
			if(pa.Find("right"))
				if(holder.throw_atom)
					holder.throw_atom.throw_at(object, 10, 1)