/mob/living/carbon/monkey/get_examine_text()
	. = ..()
	if(isnotnull(wear_mask))
		. += SPAN_INFO("It has \icon[wear_mask] <em>\a [wear_mask]</em> on its head.")
	if(isnotnull(back))
		. += SPAN_INFO("It has \icon[back] <em>\a [back]</em> on its back.")
	if(isnotnull(l_hand))
		. += SPAN_INFO("It has \icon[l_hand] <em>\a [l_hand]</em> in its left hand.")
	if(isnotnull(r_hand))
		. += SPAN_INFO("It has \icon[r_hand] <em>\a [r_hand]</em> in its right hand.")
	if(isnotnull(handcuffed))
		. += SPAN_WARNING("It is \icon[handcuffed] handcuffed!")

	if(getBruteLoss())
		if(getBruteLoss() < 30)
			. += SPAN_WARNING("It has minor bruising.")
		else
			. += SPAN_DANGER("It has severe bruising!")
	if(getFireLoss())
		if(getFireLoss() < 30)
			. += SPAN_WARNING("It has minor burns.")
		else
			. += SPAN_DANGER("It has severe burns!")

	if(stat == DEAD)
		. += SPAN("deadsay", "It is limp and unresponsive, with no signs of life.")
	else if(stat == UNCONSCIOUS)
		. += SPAN_WARNING("It isn't responding to anything around it; it seems to be asleep.")

	if(digitalcamo)
		. += SPAN_INFO("It is repulsively uncanny!")

	. += SPAN_INFO_B("*---------*")