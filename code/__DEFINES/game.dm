// Gets the turf at the location of X, or X if it is a turf itself.
// I have no idea what will happen if X is not on a turf, but it'll probably return null.
#define GET_TURF(X) get_step(X, 0)
#define get_turf(X) GET_TURF(X) // This just exists so I don't have to mass find-replace without fixing surrounding code issues.

// Gets the z-level of the turf at the location of X.
// For some reason I can't use GET_TURF(X) inside here but oh well.
#define GET_TURF_Z(X) get_step(X, 0)?.z

// Gets the area at the location of X, or X if it is an area itself.
// I have no idea what will happen if X is not in an area, but it'll probably return null.
#define GET_AREA(X) get_step(X, 0)?.loc
#define get_area(X) GET_AREA(X) // This just exists so I don't have to mass find-replace without fixing surrounding code issues.