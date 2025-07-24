/turf/closed
	opacity = TRUE
	density = TRUE
	turf_flags = TURF_FLAG_BLOCKS_AIR

/turf/closed/New()
	. = ..()
	GLOBL.closed_turf_list.Add(src)

/turf/closed/Destroy()
	GLOBL.closed_turf_list.Remove(src)
	return ..()