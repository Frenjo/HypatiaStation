/mob/living/silicon/pai/say(msg)
	if(silence_time)
		to_chat(src, SPAN_ALIUM("Communication circuits remain uninitialized."))
	else
		..(msg)