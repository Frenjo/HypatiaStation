#define NUM_E		2.71828183
#define PI			3.14159265
#define SQRT_2		1.41421356
#define INFINITY	1.#INF

#define QUANTIZE(variable) (round(variable, 0.0001))

#define CLAMP01(x) (clamp(x, 0, 1))

#define SIMPLE_SIGN(X)	((X) < 0 ? -1 : 1)
#define SIGN(X)			((X) ? SIMPLE_SIGN(X) : 0)

#define CEILING(x, y) (-round(-(x) / (y)) * (y))