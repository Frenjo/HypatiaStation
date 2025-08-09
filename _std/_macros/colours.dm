/*
 * Colour Macros
 */
// Returns the red part of a #RRGGBB hex sequence as number.
#define GETREDPART(hexa) hex2num(copytext(hexa, 2, 4))

// Returns the green part of a #RRGGBB hex sequence as number.
#define GETGREENPART(hexa) hex2num(copytext(hexa, 4, 6))

// Returns the blue part of a #RRGGBB hex sequence as number.
#define GETBLUEPART(hexa) hex2num(copytext(hexa, 6, 8))

#define GETHEXCOLOURS(hexa) list(GETREDPART(hexa), GETGREENPART(hexa), GETBLUEPART(hexa))