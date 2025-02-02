GLOBAL_GLOBL_LIST_NEW(bump_teleporters)

/obj/effect/bump_teleporter
	name = "bump-teleporter"
	icon = 'icons/mob/screen/screen1.dmi'
	icon_state = "x2"
	invisibility = INVISIBILITY_MAXIMUM 		//nope, can't see this
	anchored = TRUE
	density = TRUE
	opacity = FALSE

	var/id = null			//id of this bump_teleporter.
	var/id_target = null	//id of bump_teleporter which this moves you to.

/obj/effect/bump_teleporter/New()
	. = ..()
	GLOBL.bump_teleporters.Add(src)

/obj/effect/bump_teleporter/Destroy()
	GLOBL.bump_teleporters.Remove(src)
	return ..()

/obj/effect/bump_teleporter/Bumped(atom/user)
	if(!ismob(user))
		//user.forceMove(loc)	//Stop at teleporter location
		return

	if(!id_target)
		//user.forceMove(loc)	//Stop at teleporter location, there is nowhere to teleport to.
		return

	for(var/obj/effect/bump_teleporter/BT in GLOBL.bump_teleporters)
		if(BT.id == src.id_target)
			usr.forceMove(BT.loc) // Teleport to location with correct id.
			return