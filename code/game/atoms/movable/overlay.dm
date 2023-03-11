/*
 * Overlays
 */
/atom/movable/overlay
	anchored = TRUE

	var/atom/master = null

/atom/movable/overlay/New()
	for(var/type in verbs)
		verbs.Remove(type)
	..()

/atom/movable/overlay/attackby(a, b)
	if(!isnull(master))
		return master.attackby(a, b)

/atom/movable/overlay/attack_paw(a, b, c)
	if(!isnull(master))
		return master.attack_paw(a, b, c)

/atom/movable/overlay/attack_hand(a, b, c)
	if(!isnull(master))
		return master.attack_hand(a, b, c)