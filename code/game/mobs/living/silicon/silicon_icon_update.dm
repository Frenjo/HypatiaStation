#define RESIZE_DEFAULT_SIZE 1

/mob/living/silicon/proc/update_transform()
	var/matrix/new_transform = matrix(transform) //aka transform.Copy()
	var/changed = 0
	if(resize != RESIZE_DEFAULT_SIZE)
		changed++
		new_transform.Scale(resize)
		resize = RESIZE_DEFAULT_SIZE

	if(changed)
		animate(src, transform = new_transform, time = 2, easing = EASE_IN | EASE_OUT)

#undef RESIZE_DEFAULT_SIZE