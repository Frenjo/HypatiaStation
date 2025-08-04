/mob/living/carbon/monkey/get_examine_text(mob/user)
	. = ..()
	if(isnotnull(wear_mask))
		. += SPAN_INFO("It has [icon2html(wear_mask, user)] <em>\a [wear_mask]</em> on its head.")
	if(isnotnull(back))
		. += SPAN_INFO("It has [icon2html(back, user)] <em>\a [back]</em> on its back.")
	if(isnotnull(l_hand))
		. += SPAN_INFO("It has [icon2html(l_hand, user)] <em>\a [l_hand]</em> in its left hand.")
	if(isnotnull(r_hand))
		. += SPAN_INFO("It has [icon2html(r_hand, user)] <em>\a [r_hand]</em> in its right hand.")
	if(isnotnull(handcuffed))
		. += SPAN_WARNING("It is [icon2html(handcuffed, user)] handcuffed!")

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