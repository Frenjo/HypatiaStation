#define TRANSITIONEDGE	7 //Distance from edge to move to another z-level

// Supposedly the fastest way to do this!
// See https://gist.github.com/Giacom/be635398926bb463b42a for details.
#define RANGE_TURFS(CENTRE, RADIUS)\
block(\
	locate(max(CENTRE.x - RADIUS, 1), max(CENTRE.y - RADIUS, 1), CENTRE.z),\
	locate(min(CENTRE.x + RADIUS, world.maxx), min(CENTRE.y + RADIUS, world.maxy), CENTRE.z)\
)