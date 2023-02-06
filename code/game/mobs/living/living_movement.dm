/mob/living/proc/set_move_intent(decl/move_intent/intent)
	move_intent = move_intents[intent]
	if(hud_used)
		if(hud_used.move_intent)
			hud_used.move_intent.icon_state = move_intent.hud_icon_state