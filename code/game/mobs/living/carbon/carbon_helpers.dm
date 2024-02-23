// Returns TRUE if the mob's eyes are covered by a mask.
/mob/living/carbon/proc/are_eyes_covered()
	if(isnotnull(wear_mask) && HAS_ITEM_FLAGS(wear_mask, ITEM_FLAG_COVERS_EYES))
		return TRUE
	return FALSE

// Returns TRUE if the mob's mouth is covered by a mask.
/mob/living/carbon/proc/is_mouth_covered()
	if(isnotnull(wear_mask) && HAS_ITEM_FLAGS(wear_mask, ITEM_FLAG_COVERS_MOUTH))
		return TRUE
	return FALSE