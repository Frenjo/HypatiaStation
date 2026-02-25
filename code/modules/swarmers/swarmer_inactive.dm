/obj/item/unactivated_swarmer
	name = "unactivated swarmer"
	desc = "A currently unactivated swarmer. Swarmers can self activate at any time, it would be wise to immediately dispose of this."
	icon = 'icons/mob/simple/swarmer.dmi'
	icon_state = "unactivated"

/obj/item/unactivated_swarmer/attack_ghost(mob/user)
	var/be_swarmer = alert("Become a swarmer? (Warning: You can no longer be revived!)", , "Yes", "No")
	if(be_swarmer == "No" || GC_DESTROYED(src))
		return
	var/mob/living/simple/hostile/swarmer/swarm = new /mob/living/simple/hostile/swarmer(GET_TURF(loc))
	swarm.key = user.key
	qdel(src)