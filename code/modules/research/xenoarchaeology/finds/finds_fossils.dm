
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// fossils
/obj/item/fossil
	name = "fossil"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "bone"
	desc = "It's a fossil."

/obj/item/fossil/base/initialise()
	. = ..()
	var/list/l = list(
		/obj/item/fossil/bone = 9,
		/obj/item/fossil/skull = 3,
		/obj/item/fossil/skull/horned = 2
	)
	var/t = pickweight(l)
	var/obj/item/W = new t(src.loc)
	var/turf/T = GET_TURF(src)
	if(istype(T, /turf/closed/rock))
		var/turf/closed/rock/closed = T
		closed.last_find = W
	qdel(src)

/obj/item/fossil/bone
	name = "fossilised bone"
	icon_state = "bone"
	desc = "It's a fossilised bone."

/obj/item/fossil/skull
	name = "fossilised skull"
	icon_state = "skull"
	desc = "It's a fossilised skull."

/obj/item/fossil/skull/horned
	icon_state = "hskull"
	desc = "It's a fossilised, horned skull."

/obj/item/fossil/skull/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/fossil/bone))
		var/obj/o = new /obj/skeleton(GET_TURF(src))
		var/a = new /obj/item/fossil/bone()
		var/b = new type()
		o.contents.Add(a)
		o.contents.Add(b)
		qdel(I)
		qdel(src)
		return TRUE
	return ..()

/obj/skeleton
	name = "incomplete skeleton"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "uskel"
	desc = "Incomplete skeleton."
	var/bnum = 1
	var/breq
	var/bstate = 0
	var/plaque_contents = "Unnamed alien creature"

/obj/skeleton/initialise()
	. = ..()
	breq = rand(6) + 3
	desc = "An incomplete skeleton, looks like it could use [breq - bnum] more bones."

/obj/skeleton/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/fossil/bone))
		if(!bstate)
			bnum++
			contents.Add(new/obj/item/fossil/bone)
			qdel(W)
			if(bnum == breq)
				usr = user
				icon_state = "skel"
				bstate = 1
				density = TRUE
				name = "alien skeleton display"
				if(contents.Find(/obj/item/fossil/skull/horned))
					desc = "A creature made of [length(contents) - 1] assorted bones and a horned skull. The plaque reads \'[plaque_contents]\'."
				else
					desc = "A creature made of [length(contents) - 1] assorted bones and a skull. The plaque reads \'[plaque_contents]\'."
			else
				desc = "Incomplete skeleton, looks like it could use [breq - bnum] more bones."
				to_chat(user, "Looks like it could use [breq - bnum] more bones.")
		else
			..()
	else if(istype(W, /obj/item/pen))
		plaque_contents = input("What would you like to write on the plaque:", "Skeleton plaque", "")
		user.visible_message(
			"[user] writes something on the base of [src].",
			"You relabel the plaque on the base of \icon[src] [src]."
		)
		if(contents.Find(/obj/item/fossil/skull/horned))
			desc = "A creature made of [length(contents) - 1] assorted bones and a horned skull. The plaque reads \'[plaque_contents]\'."
		else
			desc = "A creature made of [length(contents) - 1] assorted bones and a skull. The plaque reads \'[plaque_contents]\'."
	else
		..()

//shells and plants do not make skeletons
/obj/item/fossil/shell
	name = "fossilised shell"
	icon_state = "shell"
	desc = "It's a fossilised shell."

/obj/item/fossil/plant
	name = "fossilised plant"
	icon_state = "plant1"
	desc = "It's fossilised plant remains."

/obj/item/fossil/plant/initialise()
	. = ..()
	icon_state = "plant[rand(1, 4)]"