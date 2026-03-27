// Moves all colors angle degrees around the color wheel while maintaining intensity of the color and not affecting greys
// 0 is identity, 120 moves reds to greens, 240 moves reds to blues
/proc/color_matrix_rotate_hue(angle)
	var/sin = sin(angle)
	var/cos = cos(angle)
	var/cos_inv_third = 0.333 * (1 - cos)
	var/sqrt3_sin = sqrt(3) * sin
	return list(
		round(cos + cos_inv_third, 0.001), round(cos_inv_third + sqrt3_sin, 0.001), round(cos_inv_third - sqrt3_sin, 0.001), 0,
		round(cos_inv_third - sqrt3_sin, 0.001), round(cos + cos_inv_third, 0.001), round(cos_inv_third + sqrt3_sin, 0.001), 0,
		round(cos_inv_third + sqrt3_sin, 0.001), round(cos_inv_third - sqrt3_sin, 0.001), round(cos + cos_inv_third, 0.001), 0,
		0, 0, 0, 1,
		0, 0, 0, 0
	)