/obj/effect/vaultspawner
	var/maxX = 6
	var/maxY = 6
	var/minX = 2
	var/minY = 2

/obj/effect/vaultspawner/New(turf/location, lX = minX, uX = maxX, lY = minY, uY = maxY, type = null)
	. = ..()
	if(!type)
		type = pick("sandstone", "rock", "alien")

	var/lowBoundX = location.x
	var/lowBoundY = location.y

	var/hiBoundX = location.x + rand(lX, uX)
	var/hiBoundY = location.y + rand(lY, uY)

	var/z = location.z

	for(var/i in lowBoundX to hiBoundX)
		for(var/j in lowBoundY to hiBoundY)
			if(i == lowBoundX || i == hiBoundX || j == lowBoundY || j == hiBoundY)
				new /turf/closed/wall/vault(locate(i, j, z), type)
			else
				new /turf/open/floor/vault(locate(i, j, z), type)

	qdel(src)