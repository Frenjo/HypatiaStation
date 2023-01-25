#define PI 3.1415

#define CLAMP01(x)			(clamp(x, 0, 1))
#define CLAMP02(x, y, z)	(x <= y ? y : (x >= z ? z : x))

#define QUANTIZE(variable)	(round(variable, 0.0001))

#define SIMPLE_SIGN(X)	((X) < 0 ? -1 : 1)
#define SIGN(X)			((X) ? SIMPLE_SIGN(X) : 0)

#define CEILING(x, y) (-round(-(x) / (y)) * (y))