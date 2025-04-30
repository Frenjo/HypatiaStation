/mob/living/proc/set_move_intent(decl/move_intent/intent)
	if(!ispath(intent, /decl/move_intent))
		return

	move_intent = GET_DECL_INSTANCE(intent)
	hud_used?.move_intent?.icon_state = move_intent.hud_icon_state

/mob/living/proc/thunk()
	. = TRUE
	if(isspace(loc)) // Can't fall onto nothing.
		return FALSE
	to_chat(src, "Gravity!")