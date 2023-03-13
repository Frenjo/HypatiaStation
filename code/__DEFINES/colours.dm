/*
 * Some colours.
 */
#define COLOR_RED		"#FF0000"
#define COLOR_GREEN		"#00FF00"
#define COLOR_BLUE		"#0000FF"
#define COLOR_CYAN		"#00FFFF"
#define COLOR_PINK		"#FF00FF"
#define COLOR_YELLOW	"#FFFF00"
#define COLOR_ORANGE	"#FF9900"
#define COLOR_WHITE		"#FFFFFF"

#define COLOR_YELLOW_PIPE	"#FFCC00"
#define COLOR_PURPLE_PIPE	"#5C1EC0"

/*
 * Colour helpers.
 */
// Returns the red part of a #RRGGBB hex sequence as number.
#define GETREDPART(hexa) hex2num(copytext(hexa, 2, 4))

// Returns the green part of a #RRGGBB hex sequence as number.
#define GETGREENPART(hexa) hex2num(copytext(hexa, 4, 6))

// Returns the blue part of a #RRGGBB hex sequence as number.
#define GETBLUEPART(hexa) hex2num(copytext(hexa, 6, 8))

#define GETHEXCOLOURS(hexa) list(GETREDPART(hexa), GETGREENPART(hexa), GETBLUEPART(hexa))