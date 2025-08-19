/obj/item/hailer
	name = "hailer"
	desc = "Used by obese officers to save their breath for running."
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "voice0"
	item_state = "flashbang"	//looks exactly like a flash (and nothing like a flashbang)
	w_class = WEIGHT_CLASS_TINY
	obj_flags = OBJ_FLAG_CONDUCT

	var/spamcheck = 0
	var/emagged = 0
	var/insults = 0//just in case

/obj/item/hailer/attack_self(mob/living/carbon/user)
	if(spamcheck)
		return

	if(emagged)
		if(insults >= 1)
			// I am deeply conflicted about the content of these insults. -Frenjo
			playsound(GET_TURF(src), 'sound/voice/binsult.ogg', 100, 1, vary = 0)//hueheuheuheuheuheuhe
			user.show_message(SPAN_WARNING("[user]'s [name] gurgles, \"FUCK YOUR CUNT YOU SHIT EATING CUNT TILL YOU ARE A MASS EATING SHIT CUNT. EAT PENISES IN YOUR FUCK FACE AND SHIT OUT ABORTIONS TO FUCK UP SHIT IN YOUR ASS YOU COCK FUCK SHIT MONKEY FROM THE DEPTHS OF SHIT\""), 2) //It's a hearable message silly!
			insults--
		else
			to_chat(user, SPAN_WARNING("*BZZZZcuntZZZZT*"))
	else
		playsound(GET_TURF(src), 'sound/voice/halt.ogg', 100, 1, vary = 0)
		user.show_message(SPAN_WARNING("[user]'s [name] rasps, \"Halt! Security!\""), 1)

	spamcheck = 1
	spawn(20)
		spamcheck = 0

/obj/item/hailer/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(emagged)
		to_chat(user, SPAN_WARNING("\The [src]'s voice synthesiser is already overloaded!"))
		return FALSE
	to_chat(user, SPAN_WARNING("You overload \the [src]'s voice synthesiser."))
	emagged = TRUE
	insults = rand(1, 3)//to prevent dickflooding
	return TRUE