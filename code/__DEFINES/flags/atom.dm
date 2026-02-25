/*
 * Atom Flags
 */
#define ATOM_FLAG_ON_BORDER BITFLAG(0) // Atom has priority to check when entering or leaving.
#define ATOM_FLAG_NO_BLOODY BITFLAG(1) // Atom won't get any blood overlays.

#define ATOM_FLAG_OPEN_CONTAINER BITFLAG(2) // Atom is an open container for chemistry purposes.
#define ATOM_FLAG_NO_REACT BITFLAG(3) // Reagents inside this atom won't react.

#define ATOM_FLAG_NO_SCREENTIP BITFLAG(4) // This atom doesn't display a screentip when you mouse over it.

#define ATOM_FLAG_UNSIMULATED BITFLAG(5) // This atom doesn't get "affected by things".