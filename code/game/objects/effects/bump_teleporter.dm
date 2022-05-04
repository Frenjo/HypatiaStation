/var/global/list/obj/effect/bump_teleporter/bump_teleporters = list()

/obj/effect/bump_teleporter
	name = "bump-teleporter"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	invisibility = 101 		//nope, can't see this
	anchored = TRUE
	density = TRUE
	opacity = FALSE

	var/id = null			//id of this bump_teleporter.
	var/id_target = null	//id of bump_teleporter which this moves you to.

/obj/effect/bump_teleporter/New()
	..()
	global.bump_teleporters += src

/obj/effect/bump_teleporter/Destroy()
	global.bump_teleporters -= src
	return ..()

/obj/effect/bump_teleporter/Bumped(atom/user)
	if(!ismob(user))
		//user.loc = src.loc	//Stop at teleporter location
		return

	if(!id_target)
		//user.loc = src.loc	//Stop at teleporter location, there is nowhere to teleport to.
		return

	for(var/obj/effect/bump_teleporter/BT in global.bump_teleporters)
		if(BT.id == src.id_target)
			usr.loc = BT.loc	//Teleport to location with correct id.
			return