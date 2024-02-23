// Returns TRUE if the human's eyes are covered by a helmet, glasses or mask.
/mob/living/carbon/human/are_eyes_covered()
	if(..())
		return TRUE
	if(isnotnull(head) && HAS_ITEM_FLAGS(head, ITEM_FLAG_COVERS_EYES))
		return TRUE
	if(isnotnull(glasses) && HAS_ITEM_FLAGS(glasses, ITEM_FLAG_COVERS_EYES))
		return TRUE
	return FALSE

// Returns TRUE if the human's mouth is covered by a helmet or mask.
/mob/living/carbon/human/is_mouth_covered()
	if(..())
		return TRUE
	if(isnotnull(head) && HAS_ITEM_FLAGS(head, ITEM_FLAG_COVERS_MOUTH))
		return TRUE
	return FALSE