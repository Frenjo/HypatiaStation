/mob/living/carbon/slime/death(gibbed)
	if(stat == DEAD)
		return
	stat = DEAD

	if(!gibbed)
		if(isslimeadult(src))
			ghostize()
			var/mob/living/carbon/slime/M1 = new primarytype(loc)
			M1.rabid = 1
			var/mob/living/carbon/slime/M2 = new primarytype(loc)
			M2.rabid = 1
			if(src)
				qdel(src)

	icon_state = "[colour] baby slime dead"

	overlays.Cut()

	return ..(gibbed)